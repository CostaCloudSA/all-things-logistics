from typing import List, Dict, Any
from app.models.schemas import AgentRegistryEntry

class AgentRegistry:
    """Enterprise Catalog for cross-department agent discovery, schemas, and lifecycle monitoring."""
    def __init__(self):
        self._registry: Dict[str, AgentRegistryEntry] = {}
        self._register_default_fleet()

    def _register_default_fleet(self):
        fleet = [
            AgentRegistryEntry(
                agent_id="agent-orchestrator",
                name="Fleet Orchestrator & Router",
                role="Receives multimodal user intent, resolves trade corridors, and coordinates the agent swarm.",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["intent_extraction", "country_resolution", "multimodal_routing"],
                input_schema="TradeRequest",
                output_schema="TradeResponse",
                service_account="sa-logistics-orchestrator@gserviceaccount.com"
            ),
            AgentRegistryEntry(
                agent_id="agent-ocr-parser",
                name="Vision OCR Document Parser",
                role="Extracts structured trade items, quantities, and values from invoice/B/L scans.",
                model="gemini-3.7-flash-vision",
                version="1.0.0",
                capabilities=["vision_ocr", "invoice_parsing", "manifest_tokenization"],
                input_schema="ImageUpload / PDF",
                output_schema="List[TradeItem]",
                service_account="sa-logistics-orchestrator@gserviceaccount.com"
            ),
            AgentRegistryEntry(
                agent_id="agent-hs-classifier",
                name="HS Tariff Classification Agent",
                role="Maps natural language commodity descriptions to 6-10 digit Harmonized System codes.",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["hs_classification", "confidence_scoring", "smart_chip_generation"],
                input_schema="TradeItem.raw_description",
                output_schema="HSClassificationResult",
                service_account="sa-hs-classifier@gserviceaccount.com"
            ),
            AgentRegistryEntry(
                agent_id="agent-valuation-tariff",
                name="Valuation & Landed Cost Agent",
                role="Calculates exact ad valorem duties, VAT, MPF, HMF, and De Minimis exemptions.",
                model="gemini-3.7-flash + BigQuery SQL",
                version="1.0.0",
                capabilities=["landed_cost_math", "de_minimis_verification", "currency_conversion"],
                input_schema="TradeItem + DestinationISO",
                output_schema="LandedCostSummary",
                service_account="sa-hs-classifier@gserviceaccount.com"
            ),
            AgentRegistryEntry(
                agent_id="agent-sanitary-health",
                name="Sanitary & Regulatory Health Agent",
                role="Identifies mandatory agricultural, veterinary, and pharmaceutical health permits.",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["usda_aphis_check", "fda_prior_notice", "senasica_rules", "mapa_sif"],
                input_schema="HSCode + OriginDestinationISO",
                output_schema="List[MandatoryPermit]",
                service_account="sa-hs-classifier@gserviceaccount.com"
            ),
            AgentRegistryEntry(
                agent_id="agent-golden-doc-gen",
                name="Golden Document Generator Agent",
                role="Compiles validated declarations into legal customs formats (CBP 7501, Pedimento, DUCA, DUImp).",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["cbp_7501_generation", "pedimento_generation", "duca_compilation", "duimp_json"],
                input_schema="ValidatedTradePayload",
                output_schema="GoldenDocumentJSON",
                service_account="sa-doc-generator@gserviceaccount.com"
            )
        ]
        for agent in fleet:
            self._registry[agent.agent_id] = agent

    def list_agents(self) -> List[AgentRegistryEntry]:
        return list(self._registry.values())

    def get_agent(self, agent_id: str) -> AgentRegistryEntry:
        return self._registry.get(agent_id)

agent_registry = AgentRegistry()
