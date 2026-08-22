from typing import Dict, Any, List
from app.agents.base import BaseAgent
from app.core.telemetry import OpenTelemetrySpan
from app.core.mock_tariff_db import lookup_country, lookup_tariff, lookup_non_resident_withholding
from app.security.model_armor import model_armor
from app.models.schemas import LandedCostSummary, TradeItem

class ValuationTariffAgent(BaseAgent):
    """
    Valuation & Landed Cost Agent.
    Calculates exact customs duties, national VAT/IVA, processing fees, De Minimis exemptions,
    and statutory Non-Resident Foreign Income Tax Withholdings (SME Discovery).
    Enforces deterministic Model Armor verification on all calculated tariffs.
    """
    def __init__(self):
        super().__init__(
            agent_id="agent-valuation-tariff",
            name="Valuation & Tariff Agent",
            role="Customs valuation, ad valorem duties, and tax math",
            model="gemini-3.7-flash + BigQuery"
        )

    def process(self, payload: Dict[str, Any], span: OpenTelemetrySpan) -> Dict[str, Any]:
        destination_iso = payload.get("destination_iso", "US").upper()
        origin_iso = payload.get("origin_iso", "US").upper()
        items: List[TradeItem] = payload.get("items", [])

        span.set_attribute("trade.destination_iso", destination_iso)
        span.set_attribute("trade.origin_iso", origin_iso)
        span.set_attribute("trade.items_count", len(items))

        country_data = lookup_country(destination_iso) or {}
        de_minimis_usd = country_data.get("de_minimis_usd", 0.0)

        total_declared_val = sum(item.total_declared_value_usd for item in items)
        is_de_minimis = total_declared_val > 0 and total_declared_val <= de_minimis_usd

        total_duty = 0.0
        total_vat = 0.0

        for item in items:
            tariff_info = lookup_tariff(item.hs_code or "0207.14.00", destination_iso) or {}
            official_duty_rate = tariff_info.get("ad_valorem_rate", 0.0)
            official_vat_rate = tariff_info.get("vat_rate", 0.0)

            # Model Armor: Verify rate against truth table
            _, verified_duty_rate, armor_note = model_armor.verify_tariff_grounding(
                item.hs_code or "", destination_iso, official_duty_rate
            )

            if is_de_minimis:
                item.ad_valorem_duty_rate = 0.0
                item.calculated_duty_usd = 0.0
                item.vat_rate = 0.0
                item.calculated_vat_usd = 0.0
            else:
                item.ad_valorem_duty_rate = verified_duty_rate
                item.calculated_duty_usd = round(item.total_declared_value_usd * verified_duty_rate, 2)
                item.vat_rate = official_vat_rate
                item.calculated_vat_usd = round((item.total_declared_value_usd + item.calculated_duty_usd) * official_vat_rate, 2)

            total_duty += item.calculated_duty_usd
            total_vat += item.calculated_vat_usd

        # US Merchandise Processing Fee (MPF) minimum = $31.67
        mpf = 31.67 if destination_iso == "US" and not is_de_minimis and total_declared_val > 0 else 0.0
        hmf = 0.0 # Harbor Maintenance Fee

        # Non-Resident Withholding Tax Check (SME Discovery)
        withholding_info = lookup_non_resident_withholding(destination_iso)
        withholding_tax_usd = 0.0
        withholding_note = None
        if withholding_info and origin_iso != destination_iso:
            withholding_rate = withholding_info["statutory_withholding_rate"]
            withholding_tax_usd = round(total_declared_val * withholding_rate, 2)
            withholding_note = f"Non-Resident Withholding ({withholding_rate*100}%): {withholding_info['legal_basis']}"

        landed_cost = LandedCostSummary(
            total_declared_value_usd=round(total_declared_val, 2),
            total_duty_usd=round(total_duty, 2),
            total_vat_usd=round(total_vat, 2),
            merchandise_processing_fee_usd=round(mpf, 2),
            harbor_maintenance_fee_usd=round(hmf, 2),
            total_landed_cost_usd=round(total_declared_val + total_duty + total_vat + mpf + hmf, 2),
            is_de_minimis_exempt=is_de_minimis
        )

        span.set_attribute("trade.total_landed_cost_usd", landed_cost.total_landed_cost_usd)
        span.set_attribute("trade.is_de_minimis", is_de_minimis)
        if withholding_tax_usd > 0:
            span.set_attribute("trade.foreign_withholding_tax_usd", withholding_tax_usd)

        return {
            "items": items,
            "landed_cost": landed_cost,
            "foreign_withholding_tax_usd": withholding_tax_usd,
            "withholding_note": withholding_note
        }

    def fallback_heuristic(self, prompt: str) -> str:
        return "{}"

valuation_agent = ValuationTariffAgent()
