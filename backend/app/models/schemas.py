from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from enum import Enum

class DocumentType(str, Enum):
    CBP_7501 = "CBP_7501" # USA Entry Summary
    PEDIMENTO_3_0 = "PEDIMENTO_3_0" # Mexico Pedimento
    DUCA_D = "DUCA_D" # Central America DUCA
    DUIMP = "DUIMP" # Brazil Declaração Única de Importação
    FORM_500 = "FORM_500" # Colombia DIAN Declaracion de Importacion
    GENERIC_COMMERCIAL = "GENERIC_COMMERCIAL"

class SmartChip(BaseModel):
    id: str = Field(..., description="Unique chip identifier.")
    label: str = Field(..., description="Display label on button (e.g. '🍗 Whole Bird').")
    category: str = Field(..., description="Category: 'commodity_refinement', 'incoterm', 'valuation'.")
    value: str = Field(..., description="Value to apply when tapped.")
    icon: Optional[str] = Field(None, description="Optional Material icon name.")

class TradeItem(BaseModel):
    item_id: str = Field(..., description="Unique line item ID.")
    raw_description: str = Field(..., description="Raw text or invoice description.")
    refined_description: Optional[str] = None
    hs_code: Optional[str] = None
    hs_code_confidence: float = 0.0
    quantity: float = 1.0
    unit: str = "kg"
    unit_price_usd: float = 0.0
    total_declared_value_usd: float = 0.0
    ad_valorem_duty_rate: float = 0.0
    calculated_duty_usd: float = 0.0
    vat_rate: float = 0.0
    calculated_vat_usd: float = 0.0
    requires_sanitary_permit: bool = False
    sanitary_authorities: List[str] = Field(default_factory=list)
    sanitary_permits_required: List[str] = Field(default_factory=list)

class TradeRequest(BaseModel):
    user_prompt: Optional[str] = Field(None, description="Natural language prompt or voice transcription.")
    origin_iso: Optional[str] = Field(None, description="2-letter ISO origin country.")
    destination_iso: Optional[str] = Field(None, description="2-letter ISO destination country.")
    items: Optional[List[TradeItem]] = None
    selected_chips: Optional[List[str]] = Field(default_factory=list, description="IDs of smart chips selected by user.")
    session_id: Optional[str] = "default_session"

class LandedCostSummary(BaseModel):
    total_declared_value_usd: float = 0.0
    total_duty_usd: float = 0.0
    total_vat_usd: float = 0.0
    merchandise_processing_fee_usd: float = 0.0
    harbor_maintenance_fee_usd: float = 0.0
    total_landed_cost_usd: float = 0.0
    is_de_minimis_exempt: bool = False

class TradeResponse(BaseModel):
    session_id: str
    status: str = "PROCESSED" # PROCESSED, REQUIRES_CLARIFICATION, FLAGGED_REVIEW
    origin_iso: str
    destination_iso: str
    origin_country: str
    destination_country: str
    customs_authority: str
    trade_agreement_applied: Optional[str] = None
    items: List[TradeItem]
    landed_cost: LandedCostSummary
    smart_chips: List[SmartChip] = Field(default_factory=list)
    mandatory_permits: List[str] = Field(default_factory=list)
    generated_golden_document: Optional[Dict[str, Any]] = None
    telemetry_trace_id: Optional[str] = None
    audit_notes: List[str] = Field(default_factory=list)

class AgentRegistryEntry(BaseModel):
    agent_id: str
    name: str
    role: str
    model: str
    version: str
    capabilities: List[str]
    input_schema: str
    output_schema: str
    service_account: str
