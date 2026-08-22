from typing import List, Dict, Any
from app.models.schemas import AgentRegistryEntry

class AgentRegistry:
    """Enterprise Catalog for cross-department agent discovery, schemas, and lifecycle monitoring."""
    def __init__(self):
        self._registry: Dict[str, AgentRegistryEntry] = {}
        self._register_default_fleet()

    def _register_default_fleet(self):
        fleet = [
            # 1. Fleet Orchestrator
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
            # 2. Vision OCR Parser
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
            # 3. HS Classifier
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
            # 4. Valuation & Landed Cost
            AgentRegistryEntry(
                agent_id="agent-valuation-tariff",
                name="Valuation & Landed Cost Agent",
                role="Calculates exact ad valorem duties, VAT, MPF, HMF, and Non-Resident Withholding Taxes.",
                model="gemini-3.7-flash + BigQuery SQL",
                version="1.0.0",
                capabilities=["landed_cost_math", "de_minimis_verification", "foreign_withholding_tax"],
                input_schema="TradeItem + DestinationISO",
                output_schema="LandedCostSummary",
                service_account="sa-hs-classifier@gserviceaccount.com"
            ),
            # 5. Sanitary & Health Regulatory
            AgentRegistryEntry(
                agent_id="agent-sanitary-health",
                name="Sanitary & Regulatory Health Agent",
                role="Identifies mandatory agricultural, veterinary, and pharmaceutical health permits and CA gas specs.",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["usda_aphis_check", "fda_prior_notice", "senasica_rules", "controlled_atmosphere_gas"],
                input_schema="HSCode + OriginDestinationISO",
                output_schema="List[MandatoryPermit]",
                service_account="sa-hs-classifier@gserviceaccount.com"
            ),
            # 6. Golden Document Generator
            AgentRegistryEntry(
                agent_id="agent-golden-doc-gen",
                name="Golden Document Generator Agent",
                role="Compiles validated declarations into legal customs formats (CBP 7501, Pedimento, DUCA-T, DUImp).",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["cbp_7501_generation", "pedimento_generation", "duca_t_compilation", "duimp_json"],
                input_schema="ValidatedTradePayload",
                output_schema="GoldenDocumentJSON",
                service_account="sa-doc-generator@gserviceaccount.com"
            ),
            # 7. Autonomous 24/7 Night-Watch (SME Discovery)
            AgentRegistryEntry(
                agent_id="night_watch_telematics_agent",
                name="Night Watch Telematics Agent",
                role="Autonomous 24/7 route tracking, off-route deviation alerts, and proactive client WhatsApp dispatch.",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["geofence_monitoring", "route_adherence", "automated_whatsapp_dispatch"],
                input_schema="VehicleTelematicsStream",
                output_schema="NightWatchStatusJSON",
                service_account="sa-fleet-telematics@gserviceaccount.com"
            ),
            # 8. Bridge Formula & Axle-Weight Auditor (SME Discovery)
            AgentRegistryEntry(
                agent_id="bridge_formula_auditor_agent",
                name="Bridge Formula Auditor Agent",
                role="Audits weight distribution across steer, drive tandem, and trailer tandem axles against Federal Bridge Formula B.",
                model="gemini-3.7-flash + Model Armor Grounding",
                version="1.0.0",
                capabilities=["axle_load_balancing", "bridge_formula_audit", "weigh_scale_shield"],
                input_schema="AxleWeightsLbs",
                output_schema="BridgeFormulaComplianceJSON",
                service_account="sa-compliance-auditor@gserviceaccount.com"
            ),
            # 9. 3-Way Vendor Invoice Matcher (SME Discovery)
            AgentRegistryEntry(
                agent_id="vendor_invoice_matcher_agent",
                name="Vendor Invoice Matcher Agent",
                role="Reconciles multi-party vendor invoices against booking IDs and B/L rate agreements.",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["3_way_freight_audit", "booking_reconciliation", "accessorial_validation"],
                input_schema="VendorInvoicePayload",
                output_schema="FreightAuditReconciliationJSON",
                service_account="sa-finance-billing@gserviceaccount.com"
            ),
            # 10. Transload Relay & DUCA-T Generator (SME Discovery)
            AgentRegistryEntry(
                agent_id="transload_relay_agent",
                name="Transload Relay Agent",
                role="Automates Tecún Umán transloading manifests and generates multi-country DUCA-T declarations.",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["tecun_uman_relay", "cabotage_transfer", "duca_t_generation"],
                input_schema="OceanBLPayload",
                output_schema="TransloadManifestJSON",
                service_account="sa-customs-broker@gserviceaccount.com"
            ),
            # 11. Regulatory Legal Watchdog
            AgentRegistryEntry(
                agent_id="legal_watchdog_agent",
                name="Regulatory Legal Watchdog Agent",
                role="Scrapes official gazettes (Federal Register, DOF, DOU, DIAN) to auto-update BigQuery compliance tables.",
                model="gemini-3.7-flash",
                version="1.0.0",
                capabilities=["gazette_scraping", "tariff_change_detection", "bigquery_sync"],
                input_schema="GazetteWatchlist",
                output_schema="RegulatorySyncReportJSON",
                service_account="sa-legal-watchdog@gserviceaccount.com"
            ),
            # 12. Real-Time Sanctions Screener
            AgentRegistryEntry(
                agent_id="sanctions_screener_agent",
                name="Sanctions Screener Agent",
                role="Screens all parties against OFAC SDN, BIS Entity List, and UN Sanctions in real time.",
                model="gemini-3.7-flash + Model Armor",
                version="1.0.0",
                capabilities=["ofac_sdn_screen", "bis_entity_screen", "un_sanctions_check"],
                input_schema="List[EntityName]",
                output_schema="SanctionsScreeningResultJSON",
                service_account="sa-security-compliance@gserviceaccount.com"
            )
        ]
        for agent in fleet:
            self._registry[agent.agent_id] = agent

    def list_agents(self) -> List[AgentRegistryEntry]:
        return list(self._registry.values())

    def get_agent(self, agent_id: str) -> AgentRegistryEntry:
        return self._registry.get(agent_id)

agent_registry = AgentRegistry()
