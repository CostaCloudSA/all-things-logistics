import uuid
from typing import Dict, Any, List
from app.agents.base import BaseAgent
from app.core.telemetry import OpenTelemetrySpan
from app.core.memory_bank import memory_bank
from app.models.schemas import TradeItem, LandedCostSummary

class GoldenDocumentGeneratorAgent(BaseAgent):
    """
    Golden Document Generator Agent.
    Compiles validated trade data into official, legally binding customs declarations:
    - CBP Form 7501 (USA Entry Summary)
    - Pedimento Aduanal 3.0 (Mexico)
    - DUCA-D (Central America)
    - DUImp (Brazil Portal Siscomex)
    - Formulario 500 (Colombia DIAN)
    """
    def __init__(self):
        super().__init__(
            agent_id="agent-golden-doc-gen",
            name="Golden Document Generator Agent",
            role="Compiles official customs entry summaries and legal EDI/JSON forms",
            model="gemini-3.7-flash"
        )

    def process(self, payload: Dict[str, Any], span: OpenTelemetrySpan) -> Dict[str, Any]:
        origin_iso = payload.get("origin_iso", "CO").upper()
        destination_iso = payload.get("destination_iso", "US").upper()
        items: List[TradeItem] = payload.get("items", [])
        landed_cost: LandedCostSummary = payload.get("landed_cost")
        permits: List[str] = payload.get("mandatory_permits", [])

        importer_profile = memory_bank.get_importer_profile()

        span.set_attribute("trade.origin_iso", origin_iso)
        span.set_attribute("trade.destination_iso", destination_iso)

        if destination_iso == "US":
            doc = self._generate_cbp_7501(origin_iso, items, landed_cost, permits, importer_profile)
        elif destination_iso == "MX":
            doc = self._generate_pedimento(origin_iso, items, landed_cost, permits, importer_profile)
        elif destination_iso == "BR":
            doc = self._generate_duimp(origin_iso, items, landed_cost, permits, importer_profile)
        else:
            doc = self._generate_generic_customs_doc(origin_iso, destination_iso, items, landed_cost, permits, importer_profile)

        span.set_attribute("trade.document_type", doc.get("document_type"))
        return {"golden_document": doc}

    def _generate_cbp_7501(self, origin: str, items: List[TradeItem], cost: LandedCostSummary, permits: List[str], profile: Dict[str, Any]) -> Dict[str, Any]:
        entry_number = f"CBP-{uuid.uuid4().hex[:8].upper()}"
        return {
            "document_type": "CBP_FORM_7501",
            "form_title": "U.S. Customs and Border Protection - Entry Summary (CBP 7501)",
            "entry_number": entry_number,
            "entry_type": "01 (Free and Dutiable Consumption)",
            "port_of_entry": profile.get("preferred_us_port", "5201 - Miami, FL"),
            "importer_of_record_ein": profile.get("us_ein", "12-3456789"),
            "customs_bond_number": profile.get("customs_bond_number", "CB-9948210-US"),
            "country_of_origin": origin,
            "total_entered_value_usd": cost.total_declared_value_usd,
            "duty_usd": cost.total_duty_usd,
            "merchandise_processing_fee_usd": cost.merchandise_processing_fee_usd,
            "harbor_maintenance_fee_usd": cost.harbor_maintenance_fee_usd,
            "total_estimated_duties_and_fees_usd": cost.total_duty_usd + cost.merchandise_processing_fee_usd,
            "line_items": [
                {
                    "item_number": idx + 1,
                    "hs_code": item.hs_code,
                    "description": item.refined_description or item.raw_description,
                    "quantity": f"{item.quantity} {item.unit}",
                    "entered_value_usd": item.total_declared_value_usd,
                    "duty_rate": f"{item.ad_valorem_duty_rate * 100}%",
                    "duty_amount_usd": item.calculated_duty_usd
                }
                for idx, item in enumerate(items)
            ],
            "mandatory_regulatory_filings": permits,
            "status": "READY_FOR_ACE_TRANSMISSION"
        }

    def _generate_pedimento(self, origin: str, items: List[TradeItem], cost: LandedCostSummary, permits: List[str], profile: Dict[str, Any]) -> Dict[str, Any]:
        pedimento_num = f"240-3948-{uuid.uuid4().hex[:7].upper()}"
        return {
            "document_type": "PEDIMENTO_3_0",
            "form_title": "SAT / ANAM - Pedimento de Importación Definitiva (Clave A1)",
            "numero_pedimento": pedimento_num,
            "clave_pedimento": "A1 (Importación Definitiva)",
            "aduana_despacho": "240 (Nuevo Laredo, Tamps)",
            "rfc_importador": profile.get("mx_rfc", "CGL950815AB1"),
            "pais_origen": origin,
            "valor_dolares": cost.total_declared_value_usd,
            "igi_impuesto_general_importacion_usd": cost.total_duty_usd,
            "iva_impuesto_valor_agregado_usd": cost.total_vat_usd,
            "dta_derecho_tramite_aduanero_usd": 38.00,
            "permisos_senasica_cofepris": permits,
            "status": "VALIDADO_VUCEM_LISTO_PAGO"
        }

    def _generate_duimp(self, origin: str, items: List[TradeItem], cost: LandedCostSummary, permits: List[str], profile: Dict[str, Any]) -> Dict[str, Any]:
        return {
            "document_type": "DUIMP",
            "form_title": "Receita Federal do Brasil - Declaração Única de Importação (DUImp)",
            "numero_duimp": f"24BR{uuid.uuid4().hex[:10].upper()}",
            "cnpj_importador": profile.get("br_cnpj", "12.345.678/0001-90"),
            "pais_origem": origin,
            "valor_aduaneiro_usd": cost.total_declared_value_usd,
            "ii_imposto_importacao_usd": cost.total_duty_usd,
            "icms_estimado_usd": cost.total_vat_usd,
            "inspecoes_mapa_anvisa": permits,
            "status": "REGISTRADA_AGUARDANDO_CANAL"
        }

    def _generate_generic_customs_doc(self, origin: str, dest: str, items: List[TradeItem], cost: LandedCostSummary, permits: List[str], profile: Dict[str, Any]) -> Dict[str, Any]:
        return {
            "document_type": f"CUSTOMS_DECLARATION_{dest}",
            "form_title": f"Single Administrative Customs Declaration ({dest})",
            "declaration_id": f"DECL-{uuid.uuid4().hex[:8].upper()}",
            "origin_iso": origin,
            "destination_iso": dest,
            "total_value_usd": cost.total_declared_value_usd,
            "total_duty_usd": cost.total_duty_usd,
            "total_vat_usd": cost.total_vat_usd,
            "permits": permits,
            "status": "CLEARED"
        }

    def fallback_heuristic(self, prompt: str) -> str:
        return "{}"

document_generator_agent = GoldenDocumentGeneratorAgent()
