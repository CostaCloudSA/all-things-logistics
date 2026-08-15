from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any

class CBP7501EntrySummary(BaseModel):
    entry_number: str = Field(..., description="CBP Entry Number (11 characters).")
    entry_type: str = Field("01", description="01 = Free and Dutiable Consumption.")
    port_of_entry: str = Field("5201", description="Port code (e.g. 5201 = Miami, FL).")
    importer_of_record_number: str = Field(..., description="Masked/tokenized IRS EIN or CBP Assigned Number.")
    consignee_number: str = Field(..., description="Masked consignee tax identifier.")
    country_of_origin: str = Field(..., description="2-letter ISO origin country.")
    exporting_country: str = Field(..., description="2-letter ISO export country.")
    total_entered_value_usd: float
    total_duty_usd: float
    total_tax_usd: float
    merchandise_processing_fee_usd: float = 31.67
    harbor_maintenance_fee_usd: float = 0.0
    total_estimated_duties_and_fees_usd: float
    line_items: List[Dict[str, Any]]
    fda_prior_notice_confirmation: Optional[str] = None
    usda_aphis_permit_number: Optional[str] = None

class PedimentoAduanal(BaseModel):
    numero_pedimento: str = Field(..., description="Formato 15 dígitos: Patente + Año + Aduana + Consecutivo.")
    clave_pedimento: str = Field("A1", description="A1 = Importación Definitiva.")
    aduana_despacho: str = Field("240", description="240 = Nuevo Laredo / 470 = Aeropuerto CDMX.")
    rfc_importador: str = Field(..., description="RFC del importador de registro.")
    pais_origen: str
    pais_vendedor: str
    valor_dolares: float
    valor_comercial_mxn: float
    igi_impuesto_general_importacion: float
    iva_impuesto_valor_agregado: float
    dta_derecho_tramite_aduanero: float
    lineas_mercancia: List[Dict[str, Any]]
    certificado_senasica: Optional[str] = None

class DUCADeclaration(BaseModel):
    numero_declaracion: str = Field(..., description="Número único DUCA-D / DUCA-F.")
    tipo_duca: str = Field("DUCA_D", description="DUCA-D (Terceros) o DUCA-F (Originarias CAFTA/SIECA).")
    pais_exportador: str
    pais_importador: str
    aduanas_ingreso: str
    valor_aduanero_cif_usd: float
    derechos_arancelarios_dai_usd: float
    iva_usd: float
    lineas_mercancia: List[Dict[str, Any]]

class DUImpDeclaration(BaseModel):
    numero_duimp: str = Field(..., description="Número DUImp no Portal Único Siscomex.")
    cnpj_importador: str
    pais_origem: str
    valor_aduaneiro_usd: float
    ii_imposto_importacao_brl: float
    ipi_brl: float
    pis_cofins_brl: float
    icms_brl: float
    licenca_mapa_anvisa: Optional[str] = None
    lineas_mercancia: List[Dict[str, Any]]
