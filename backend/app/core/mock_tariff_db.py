"""
High-fidelity local mock database for Customs Agencies, De Minimis thresholds,
Harmonized System (HS) classifications, tariff schedules, and sanitary permit rules across the Americas.
"""

from typing import Dict, Any, List, Optional

MOCK_COUNTRIES: Dict[str, Dict[str, Any]] = {
    "US": {
        "name": "United States",
        "customs_authority": "U.S. Customs and Border Protection (CBP)",
        "electronic_portal": "ACE (Automated Commercial Environment)",
        "de_minimis_usd": 800.0,
        "tax_de_minimis_usd": 800.0,
        "default_golden_doc": "CBP_7501",
        "currency": "USD",
        "sanitary_agencies": ["USDA APHIS", "USDA FSIS", "FDA"]
    },
    "MX": {
        "name": "Mexico",
        "customs_authority": "Agencia Nacional de Aduanas de México (ANAM) / SAT",
        "electronic_portal": "VUCEM",
        "de_minimis_usd": 50.0,
        "tax_de_minimis_usd": 50.0,
        "default_golden_doc": "PEDIMENTO_3_0",
        "currency": "MXN",
        "sanitary_agencies": ["SENASICA (SADER)", "COFEPRIS"]
    },
    "CO": {
        "name": "Colombia",
        "customs_authority": "Dirección de Impuestos y Aduanas Nacionales (DIAN)",
        "electronic_portal": "VUCE / SYGA",
        "de_minimis_usd": 200.0,
        "tax_de_minimis_usd": 200.0,
        "default_golden_doc": "FORM_500",
        "currency": "COP",
        "sanitary_agencies": ["ICA", "INVIMA"]
    },
    "BR": {
        "name": "Brazil",
        "customs_authority": "Receita Federal do Brasil (RFB)",
        "electronic_portal": "Portal Único Siscomex",
        "de_minimis_usd": 50.0,
        "tax_de_minimis_usd": 0.0,
        "default_golden_doc": "DUIMP",
        "currency": "BRL",
        "sanitary_agencies": ["MAPA (SIF)", "ANVISA"]
    },
    "CR": {
        "name": "Costa Rica",
        "customs_authority": "Servicio Nacional de Aduanas (SNA) / Hacienda",
        "electronic_portal": "TICA",
        "de_minimis_usd": 0.0,
        "tax_de_minimis_usd": 0.0,
        "default_golden_doc": "DUCA_D",
        "currency": "CRC",
        "sanitary_agencies": ["MAG / SENASA", "Ministerio de Salud"]
    },
    "CA": {
        "name": "Canada",
        "customs_authority": "Canada Border Services Agency (CBSA)",
        "electronic_portal": "CARM",
        "de_minimis_usd": 20.0,
        "tax_de_minimis_usd": 20.0,
        "default_golden_doc": "FORM_B3",
        "currency": "CAD",
        "sanitary_agencies": ["CFIA"]
    },
    "PE": {
        "name": "Peru",
        "customs_authority": "SUNAT Aduanas",
        "electronic_portal": "VUCE",
        "de_minimis_usd": 200.0,
        "tax_de_minimis_usd": 200.0,
        "default_golden_doc": "DUA_DAM",
        "currency": "PEN",
        "sanitary_agencies": ["SENASA", "DIGESA"]
    },
    "CL": {
        "name": "Chile",
        "customs_authority": "Servicio Nacional de Aduanas",
        "electronic_portal": "SIDOMAR / VUCE",
        "de_minimis_usd": 41.0,
        "tax_de_minimis_usd": 41.0,
        "default_golden_doc": "DIN",
        "currency": "CLP",
        "sanitary_agencies": ["SAG", "ISP"]
    }
}

MOCK_HS_DATABASE: List[Dict[str, Any]] = [
    # Poultry
    {
        "hs_code": "0207.12.00",
        "hs_code_root": "0207",
        "description_en": "Meat and edible offal of poultry: Not cut in pieces, frozen (Whole chicken)",
        "description_es": "Carne y despojos comestibles de aves: Sin trocear, congelados (Pollo entero)",
        "destination_iso": "US",
        "ad_valorem_rate": 0.05, # 5.0%
        "vat_rate": 0.0,
        "requires_sanitary_permit": True,
        "sanitary_authorities": ["USDA FSIS", "USDA APHIS", "FDA Prior Notice"],
        "permits_required": ["APHIS Import Permit", "FSIS Form 9540-1", "FDA Prior Notice Confirmation"]
    },
    {
        "hs_code": "0207.14.00",
        "hs_code_root": "0207",
        "description_en": "Meat and edible offal of poultry: Cuts and offal, frozen (Chicken breasts/wings/thighs)",
        "description_es": "Carne y despojos comestibles de aves: Trozos y despojos, congelados (Pechugas/Alitas/Piernas)",
        "destination_iso": "US",
        "ad_valorem_rate": 0.088, # 8.8%
        "vat_rate": 0.0,
        "requires_sanitary_permit": True,
        "sanitary_authorities": ["USDA FSIS", "USDA APHIS", "FDA Prior Notice"],
        "permits_required": ["APHIS Import Permit", "FSIS Form 9540-1", "FDA Prior Notice Confirmation"]
    },
    {
        "hs_code": "0207.14.99",
        "hs_code_root": "0207",
        "description_en": "Trozos de pollo congelados para importación a México",
        "description_es": "Trozos y despojos de pollo congelados",
        "destination_iso": "MX",
        "ad_valorem_rate": 0.10, # 10.0%
        "vat_rate": 0.16, # 16% IVA
        "requires_sanitary_permit": True,
        "sanitary_authorities": ["SENASICA (SADER)", "COFEPRIS"],
        "permits_required": ["Certificado Zoosanitario para Importación (CZI)", "Hoja de Requisitos Zoosanitarios"]
    },
    {
        "hs_code": "0207.14.00",
        "hs_code_root": "0207",
        "description_en": "Cortes de frango congelados para o Brasil",
        "description_es": "Cortes de pollo congelados",
        "destination_iso": "BR",
        "ad_valorem_rate": 0.12, # 12.0% TEC MERCOSUR
        "vat_rate": 0.18, # 18% ICMS
        "requires_sanitary_permit": True,
        "sanitary_authorities": ["MAPA (SIF)", "ANVISA"],
        "permits_required": ["Certificado Sanitário Internacional (CSI)", "Registro de Rótulo no MAPA"]
    },
    # Coffee
    {
        "hs_code": "0901.11.00",
        "hs_code_root": "0901",
        "description_en": "Coffee, not roasted, not decaffeinated (Green coffee beans)",
        "description_es": "Café sin tostar, sin descafeinar (Grano verde)",
        "destination_iso": "US",
        "ad_valorem_rate": 0.00, # 0.0% Duty Free
        "vat_rate": 0.0,
        "requires_sanitary_permit": True,
        "sanitary_authorities": ["USDA APHIS", "FDA"],
        "permits_required": ["APHIS Plant Protection Permit PPQ 587", "FDA Food Facility Registration"]
    },
    # Avocados
    {
        "hs_code": "0804.40.00",
        "hs_code_root": "0804",
        "description_en": "Avocados, fresh or dried (Hass avocados)",
        "description_es": "Aguacates (paltas), frescos o secos (Aguacate Hass)",
        "destination_iso": "US",
        "ad_valorem_rate": 0.00, # Duty Free under USMCA / MFN
        "vat_rate": 0.0,
        "requires_sanitary_permit": True,
        "sanitary_authorities": ["USDA APHIS", "FDA"],
        "permits_required": ["APHIS Phytosanitary Certificate", "USDA Marketing Order Compliance"]
    },
    # Electronics / Laptops
    {
        "hs_code": "8471.30.01",
        "hs_code_root": "8471",
        "description_en": "Portable automatic data processing machines (Laptops/Notebooks)",
        "description_es": "Máquinas automáticas para tratamiento de datos, portátiles (Laptops)",
        "destination_iso": "US",
        "ad_valorem_rate": 0.00, # ITA Agreement Duty Free
        "vat_rate": 0.0,
        "requires_sanitary_permit": False,
        "sanitary_authorities": ["FCC"],
        "permits_required": ["FCC Declaration of Conformity"]
    },
    {
        "hs_code": "8471.30.01",
        "hs_code_root": "8471",
        "description_en": "Laptops y computadoras portátiles a México",
        "description_es": "Máquinas automáticas para procesamiento de datos portátiles",
        "destination_iso": "MX",
        "ad_valorem_rate": 0.00, # Prosec / T-MEC
        "vat_rate": 0.16, # 16% IVA
        "requires_sanitary_permit": False,
        "sanitary_authorities": ["SE / DGN"],
        "permits_required": ["Certificado NOM-019-SCFI", "NOM-024-SCFI"]
    }
]

def lookup_country(iso_code: str) -> Optional[Dict[str, Any]]:
    return MOCK_COUNTRIES.get(iso_code.upper())

def lookup_tariff(hs_code: str, destination_iso: str) -> Optional[Dict[str, Any]]:
    for entry in MOCK_HS_DATABASE:
        if entry["destination_iso"] == destination_iso.upper():
            if entry["hs_code"].startswith(hs_code[:4]):
                return entry
    return None

def search_hs_codes(keyword: str, destination_iso: str = "US") -> List[Dict[str, Any]]:
    kw = keyword.lower()
    matches = []
    for entry in MOCK_HS_DATABASE:
        if entry["destination_iso"] == destination_iso.upper():
            if kw in entry["description_en"].lower() or kw in entry["description_es"].lower() or kw in entry["hs_code"]:
                matches.append(entry)
    return matches
