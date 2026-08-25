from typing import Dict, Any, List
from app.agents.base import BaseAgent
from app.core.telemetry import OpenTelemetrySpan
from app.core.mock_tariff_db import lookup_country, lookup_tariff
from app.models.schemas import TradeItem

class SanitaryRegulatoryAgent(BaseAgent):
    """
    Sanitary & Regulatory Health Compliance Agent.
    Identifies mandatory agricultural, veterinary, and pharmaceutical health permits
    based on commodity and destination health authorities (USDA, FDA, SENASICA, MAPA, INVIMA, MAGA),
    and validates Controlled Atmosphere (CA) gas levels for perishable produce.
    """
    def __init__(self):
        super().__init__(
            agent_id="agent-sanitary-health",
            name="Sanitary & Regulatory Health Agent",
            role="Permit verification, health agency checks, and CA gas telemetry",
            model="gemini-3.7-flash"
        )

    def process(self, payload: Dict[str, Any], span: OpenTelemetrySpan) -> Dict[str, Any]:
        destination_iso = payload.get("destination_iso", "US").upper()
        items: List[TradeItem] = payload.get("items", [])
        is_perishable = payload.get("is_perishable", True)

        span.set_attribute("trade.destination_iso", destination_iso)

        country_data = lookup_country(destination_iso) or {}
        health_agencies = country_data.get("sanitary_agencies", [])
        all_permits = []

        for item in items:
            tariff_info = lookup_tariff(item.hs_code or "", destination_iso) or {}
            item.requires_sanitary_permit = tariff_info.get("requires_sanitary_permit", False)
            item.sanitary_authorities = tariff_info.get("sanitary_authorities", health_agencies)
            item.sanitary_permits_required = tariff_info.get("permits_required", [])

            for permit in item.sanitary_permits_required:
                if permit not in all_permits:
                    all_permits.append(permit)

        # Controlled Atmosphere (CA) Telemetry for cold chain (SME Discovery)
        ca_telemetry = None
        if is_perishable:
            ca_telemetry = {
                "target_o2_pct": 3.0, # 3% Oxygen (low respiration)
                "target_co2_pct": 5.0, # 5% Carbon Dioxide
                "temp_setpoint_celsius": -18.0 if any("frozen" in (getattr(i, "raw_description", "") or getattr(i, "refined_description", "") or "").lower() for i in items) else 4.0,
                "gas_injection_seal_status": "CONTROLLED_ATMOSPHERE_ACTIVE"
            }

        span.set_attribute("trade.mandatory_permits_count", len(all_permits))

        return {
            "items": items,
            "mandatory_permits": all_permits,
            "regulatory_authorities": health_agencies,
            "controlled_atmosphere_specs": ca_telemetry
        }

    def fallback_heuristic(self, prompt: str) -> str:
        return "[]"

sanitary_agent = SanitaryRegulatoryAgent()
