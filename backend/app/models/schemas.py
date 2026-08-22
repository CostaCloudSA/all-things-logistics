from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from enum import Enum

class DocumentType(str, Enum):
    CBP_7501 = "CBP_7501" # USA Entry Summary
    PEDIMENTO_3_0 = "PEDIMENTO_3_0" # Mexico Pedimento
    DUCA_T = "DUCA_T" # Central America International Transit (SIECA)
    DUCA_D = "DUCA_D" # Central America DUCA Import
    DUIMP = "DUIMP" # Brazil Declaração Única de Importação
    FORM_500 = "FORM_500" # Colombia DIAN Declaracion de Importacion
    GENERIC_COMMERCIAL = "GENERIC_COMMERCIAL"

class TenantType(str, Enum):
    MULTINATIONAL_FORWARDER = "MULTINATIONAL_FORWARDER"
    REGIONAL_CARRIER = "REGIONAL_CARRIER"
    CUSTOMS_BROKER = "CUSTOMS_BROKER"
    ENTERPRISE_SHIPPER = "ENTERPRISE_SHIPPER"
    TERMINAL_OPERATOR = "TERMINAL_OPERATOR"

class TenantProfile(BaseModel):
    tenant_id: str = Field(..., description="Unique tenant slug (e.g., 'tenant-campabadal').")
    org_name: str = Field(..., description="Display company name.")
    org_type: TenantType = Field(TenantType.MULTINATIONAL_FORWARDER, description="Type of logistics organization.")
    tagline: str = Field("", description="Company slogan or operational subtitle.")
    brand_color_hex: str = Field("#2563EB", description="Primary brand color (hex).")
    accent_color_hex: str = Field("#38BDF8", description="Secondary accent color (hex).")
    logo_icon: str = Field("local_shipping", description="Icon identifier.")
    scac_or_dot_code: str = Field("", description="Standard Carrier Alpha Code or DOT/MC number.")
    tax_identifier: str = Field("", description="EIN, RFC, NIT, CNPJ or local tax ID.")
    public_key_ed25519_hex: str = Field("", description="Ed25519 public key hex for manifest signature verification.")
    default_origin_iso: str = Field("US", description="Default origin ISO.")
    default_destination_iso: str = Field("GT", description="Default destination ISO.")

class SmartChip(BaseModel):
    id: str = Field(..., description="Unique chip identifier.")
    label: str = Field(..., description="Display label on button (e.g. '🍗 Whole Bird').")
    category: str = Field(..., description="Category: 'commodity_refinement', 'incoterm', 'valuation', 'axle_weight', 'federation'.")
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
    tenant_id: Optional[str] = Field("tenant-campabadal", description="Active white-label tenant ID.")
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

class FieldInspectorQRPayload(BaseModel):
    manifest_id: str
    signing_tenant_id: str
    signing_org_name: str
    signature_ed25519: str
    public_key_ed25519: str
    trailer_plate: str
    gross_weight_kg: float
    bridge_formula_compliant: bool
    duca_t_reference: str
    sanitary_status: str
    timestamp_utc: str
    verification_url: str

class FederatedAgentHandshakeRequest(BaseModel):
    originating_tenant_id: str
    target_tenant_id: str
    manifest_id: str
    container_number: str
    bill_of_lading_number: str
    qr_payload: FieldInspectorQRPayload
    items: List[TradeItem]
    traceparent: Optional[str] = None

class FederatedAgentHandshakeResponse(BaseModel):
    handshake_id: str
    status: str # ACCEPTED_VERIFIED, REJECTED_SIGNATURE_INVALID, PENDING_INSPECTION
    verified_by_agent: str
    originating_tenant_id: str
    receiving_tenant_id: str
    is_ed25519_signature_valid: bool
    bridge_formula_accepted: bool
    generated_duca_t_number: Optional[str] = None
    audit_log: List[str] = Field(default_factory=list)

class TradeResponse(BaseModel):
    session_id: str
    tenant_id: str = "tenant-campabadal"
    tenant_profile: Optional[TenantProfile] = None
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
    field_inspector_qr: Optional[FieldInspectorQRPayload] = None
    federated_handshake: Optional[FederatedAgentHandshakeResponse] = None
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
