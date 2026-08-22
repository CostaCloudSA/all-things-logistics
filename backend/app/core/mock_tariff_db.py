"""
High-fidelity local mock database for Customs Agencies, De Minimis thresholds,
Harmonized System (HS) classifications, tariff schedules, sanitary permit rules,
Federal Bridge Formula limits, non-resident foreign tax withholdings, and border transload hubs across the Americas.
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
    "GT": {
        "name": "Guatemala",
        "customs_authority": "Superintendencia de Administración Tributaria (SAT Guatemala)",
        "electronic_portal": "DUCA Portal / SAQD",
        "de_minimis_usd": 50.0,
        "tax_de_minimis_usd": 50.0,
        "default_golden_doc": "DUCA_T",
        "currency": "GTQ",
        "sanitary_agencies": ["MAGA (VISAR)", "MSPAS"]
    },
    "SV": {
        "name": "El Salvador",
        "customs_authority": "Dirección General de Aduanas (DGA El Salvador)",
        "electronic_portal": "SIDUNEA World / DUCA",
        "de_minimis_usd": 50.0,
        "tax_de_minimis_usd": 50.0,
        "default_golden_doc": "DUCA_T",
        "currency": "USD",
        "sanitary_agencies": ["MAG", "MINSAL"]
    },
    "HN": {
        "name": "Honduras",
        "customs_authority": "Administración Aduanera de Honduras (Aduanas Honduras)",
        "electronic_portal": "SAR / DUCA",
        "de_minimis_usd": 50.0,
        "tax_de_minimis_usd": 50.0,
        "default_golden_doc": "DUCA_T",
        "currency": "HNL",
        "sanitary_agencies": ["SENASA", "ARSA"]
    },
    "NI": {
        "name": "Nicaragua",
        "customs_authority": "Dirección General de Servicios Aduaneros (DGA Nicaragua)",
        "electronic_portal": "SIDUNEA++ / DUCA",
        "de_minimis_usd": 50.0,
        "tax_de_minimis_usd": 50.0,
        "default_golden_doc": "DUCA_T",
        "currency": "NIO",
        "sanitary_agencies": ["IPSA", "MINSA"]
    },
    "CR": {
        "name": "Costa Rica",
        "customs_authority": "Servicio Nacional de Aduanas (SNA) / Hacienda",
        "electronic_portal": "TICA / DUCA",
        "de_minimis_usd": 0.0,
        "tax_de_minimis_usd": 0.0,
        "default_golden_doc": "DUCA_T",
        "currency": "CRC",
        "sanitary_agencies": ["MAG / SENASA", "Ministerio de Salud"]
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

# Federal & Central American Bridge Formula Weight Limits
MOCK_BRIDGE_FORMULA_LIMITS: Dict[str, Dict[str, Any]] = {
    "US_FEDERAL_TITLE_23": {
        "max_steer_axle_lbs": 12000.0,
        "max_drive_tandem_lbs": 34000.0,
        "max_trailer_tandem_lbs": 34000.0,
        "max_gross_weight_lbs": 80000.0,
        "unit": "lbs",
        "regulatory_statute": "23 U.S.C. § 127 / Federal Bridge Formula B"
    },
    "CENTRAL_AMERICA_SIECA": {
        "max_steer_axle_lbs": 11023.0, # 5,000 kg
        "max_drive_tandem_lbs": 33069.0, # 15,000 kg
        "max_trailer_tandem_lbs": 33069.0, # 15,000 kg
        "max_gross_weight_lbs": 88184.0, # 40,000 kg (40 Tonnes)
        "unit": "lbs",
        "regulatory_statute": "Reglamento Centroamericano de Pesos y Dimensiones (SIECA COMIECO)"
    },
    "MEXICO_NOM_012_SCT": {
        "max_steer_axle_lbs": 14330.0, # 6,500 kg
        "max_drive_tandem_lbs": 39683.0, # 18,000 kg
        "max_trailer_tandem_lbs": 39683.0, # 18,000 kg
        "max_gross_weight_lbs": 90389.0, # 41,000 kg (T3-S2 Standard)
        "unit": "lbs",
        "regulatory_statute": "NOM-012-SCT-2-2017 Pesos y Dimensiones"
    }
}

# Statutory Non-Resident Foreign Withholding Tax Schedules (SME Discovery)
MOCK_NON_RESIDENT_WITHHOLDINGS: Dict[str, Dict[str, Any]] = {
    "SV": {
        "country_name": "El Salvador",
        "statutory_withholding_rate": 0.20, # 20%
        "legal_basis": "Ley de Impuesto sobre la Renta de El Salvador, Art. 158 (Remesas por servicios al exterior)",
        "applies_to": "Servicios de transporte, intermediación y fletes cobrados por no residentes"
    },
    "CR": {
        "country_name": "Costa Rica",
        "statutory_withholding_rate": 0.15, # 15%
        "legal_basis": "Ley N° 7092 de Impuesto sobre la Renta, Art. 59 (Remesas al Exterior)",
        "applies_to": "Fletes y servicios técnicos pagados a casas matrices o proveedores no domiciliados"
    },
    "GT": {
        "country_name": "Guatemala",
        "statutory_withholding_rate": 0.15, # 15%
        "legal_basis": "Decreto 10-2012 Ley de Actualización Tributaria, Libro I Impuesto sobre la Renta",
        "applies_to": "Rentas de no residentes por transporte internacional y comisiones"
    },
    "HN": {
        "country_name": "Honduras",
        "statutory_withholding_rate": 0.25, # 25%
        "legal_basis": "Decreto 170-2016 Código Tributario de Honduras",
        "applies_to": "Pagos a personas jurídicas extranjeras no domiciliadas"
    },
    "NI": {
        "country_name": "Nicaragua",
        "statutory_withholding_rate": 0.15, # 15%
        "legal_basis": "Ley 822 Ley de Concertación Tributaria, Art. 53",
        "applies_to": "Servicios de transporte y flete originados en el país"
    },
    "CO": {
        "country_name": "Colombia",
        "statutory_withholding_rate": 0.20, # 20%
        "legal_basis": "Estatuto Tributario de Colombia, Art. 408",
        "applies_to": "Pagos al exterior por consultoría, servicios y fletes marítimos/terrestres"
    },
    "MX": {
        "country_name": "Mexico",
        "statutory_withholding_rate": 0.25, # 25%
        "legal_basis": "Ley del Impuesto sobre la Renta (LISR), Título V, Art. 167",
        "applies_to": "Servicios y fletes contratados con entidades sin establecimiento permanente"
    }
}

# Border Transload Hubs & Cabotage Relay Yards
MOCK_BORDER_TERMINALS: Dict[str, Dict[str, Any]] = {
    "TECUN_UMAN": {
        "name": "Tecún Umán Multi-Modal Transload Hub",
        "country_a": "MX",
        "country_b": "GT",
        "bridge_name": "Puente Internacional Rodolfo Robles",
        "cabotage_rule": "Mexican trucks cannot enter Central America. Cargo must transload to Central American rigs.",
        "primary_transit_doc": "DUCA-T (Declaración Única Centroamericana de Tránsito)",
        "coordinates": {"lat": 14.6739, "lng": -92.1438},
        "transfer_yards": ["Patio Fiscal Tecún I", "Cross-Dock Rodolfo Robles", "Bodega Aduanal San Cristóbal"]
    },
    "PENAS_BLANCAS": {
        "name": "Peñas Blancas Border Terminal",
        "country_a": "NI",
        "country_b": "CR",
        "bridge_name": "Paso Fronterizo Peñas Blancas",
        "cabotage_rule": "Direct transit allowed under DUCA-T with verified international carrier permit.",
        "primary_transit_doc": "DUCA-T",
        "coordinates": {"lat": 11.2186, "lng": -85.6111},
        "transfer_yards": ["Zona Primaria Peñas Blancas", "Depósito Fiscal La Cruz"]
    },
    "PASO_CANOAS": {
        "name": "Paso Canoas Border Terminal",
        "country_a": "CR",
        "country_b": "PA",
        "bridge_name": "Paso Fronterizo Canoas",
        "cabotage_rule": "Reciprocal binational drayage and direct bonded trailer transit.",
        "primary_transit_doc": "DUCA-T / Formulario DM-PA",
        "coordinates": {"lat": 8.5322, "lng": -82.8394},
        "transfer_yards": ["Depósito Aduanero Canoas", "Recinto Fiscal Fronterizo"]
    }
}

# Denied Entities & Watchlists for Sanctions Screener
MOCK_SANCTIONS_WATCHLIST: List[Dict[str, Any]] = [
    {
        "entity_name": "TRANSCARGO GLOBAL LOGISTICS LTD",
        "list_source": "OFAC SDN (Specially Designated Nationals)",
        "program": "SDGT (Global Terrorism)",
        "country": "IR",
        "risk_level": "BLOCKED_CRITICAL"
    },
    {
        "entity_name": "PACIFIC OCEAN SHIPPING CORP",
        "list_source": "BIS Entity List",
        "program": "Export Administration Regulations (EAR)",
        "country": "RU",
        "risk_level": "BLOCKED_CRITICAL"
    },
    {
        "entity_name": "CARIBE AGROEXPORTACIONES S.A.",
        "list_source": "INTERPOL Red Notice / Anti-Narcotics Watchlist",
        "program": "Transnational Organized Crime",
        "country": "CO",
        "risk_level": "HIGH_INSPECTION_MANDATORY"
    }
]

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
        "hs_code": "0207.14.00",
        "hs_code_root": "0207",
        "description_en": "Meat and edible offal of poultry: Frozen cuts for Guatemala / Central America",
        "description_es": "Carne y despojos comestibles de aves: Trozos y despojos congelados para Centroamérica",
        "destination_iso": "GT",
        "ad_valorem_rate": 0.15, # 15% DAI
        "vat_rate": 0.12, # 12% IVA
        "requires_sanitary_permit": True,
        "sanitary_authorities": ["MAGA (VISAR)"],
        "permits_required": ["Permiso Zoosanitario de Importación MAGA", "Certificado Veterinario de Origen"]
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

def lookup_bridge_formula(jurisdiction: str = "US_FEDERAL_TITLE_23") -> Optional[Dict[str, Any]]:
    return MOCK_BRIDGE_FORMULA_LIMITS.get(jurisdiction.upper())

def lookup_non_resident_withholding(country_iso: str) -> Optional[Dict[str, Any]]:
    return MOCK_NON_RESIDENT_WITHHOLDINGS.get(country_iso.upper())

def lookup_border_terminal(terminal_code: str) -> Optional[Dict[str, Any]]:
    return MOCK_BORDER_TERMINALS.get(terminal_code.upper())

def screen_sanctions_entity(name: str) -> Optional[Dict[str, Any]]:
    name_clean = name.upper().strip()
    for entity in MOCK_SANCTIONS_WATCHLIST:
        if entity["entity_name"] in name_clean or name_clean in entity["entity_name"]:
            return entity
    return None

def search_hs_codes(keyword: str, destination_iso: str = "US") -> List[Dict[str, Any]]:
    kw = keyword.lower()
    matches = []
    for entry in MOCK_HS_DATABASE:
        if entry["destination_iso"] == destination_iso.upper():
            if kw in entry["description_en"].lower() or kw in entry["description_es"].lower() or kw in entry["hs_code"]:
                matches.append(entry)
    return matches
