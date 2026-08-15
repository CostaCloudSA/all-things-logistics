# Fortified Enterprise Multi-Agent Architecture & Golden Documents Matrix

This document defines the **Fortified Enterprise Multi-Agent Architecture** and the authoritative catalog of **Golden Documents** required for end-to-end import and export compliance across all 35 sovereign nations and key territories in the Americas, powered by **Gemini 3.7 Flash** and **Google Cloud**.

---

## 1. Enterprise Infrastructure & Governance Architecture

To satisfy the stringent compliance, security, and lifecycle requirements of the **Fortified Enterprise Fleet**, the platform structures agents within an enterprise-grade control plane:

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        FORTIFIED ENTERPRISE AGENT FLEET GATEWAY                        │
│  ┌───────────────────────────┐  ┌───────────────────────────┐  ┌─────────────────────┐ │
│  │        MODEL ARMOR        │  │      AGENT IDENTITY       │  │   AGENT REGISTRY    │ │
│  │ • Local Gemma Sanitizer   │  │ • Zero-Trust IAM Scopes   │  │ • Versioned Schemas │ │
│  │ • Deterministic Grounding │  │ • BigQuery Row-Level Sec  │  │ • Semantic Tools    │ │
│  │ • Anti-Hallucination Gate │  │ • Least Privilege Access  │  │ • Lifecycle State   │ │
│  └─────────────┬─────────────┘  └─────────────┬─────────────┘  └──────────┬──────────┘ │
└────────────────┼──────────────────────────────┼───────────────────────────┼────────────┘
                 │                              │                           │
┌────────────────▼──────────────────────────────▼───────────────────────────▼────────────┐
│                    ORCHESTRATION & STATE ENGINE (GEMINI 3.7 FLASH)                     │
│  ┌──────────────────────────────────────────────┐  ┌────────────────────────────────┐  │
│  │  Async Agent Runtime (Cloud Run + Pub/Sub)   │  │  Memory Bank & State Store     │  │
│  │  • Event-driven manifest processing          │  │  • Persistent customer context │  │
│  │  • Circuit Breaker (Max Retries n=2)         │  │  • Verified Tax IDs & Bonds    │  │
│  │  • Confidence Gating (< 0.80 -> Smart Chips) │  │  • Historical HS mappings      │  │
│  └──────────────────────────────────────────────┘  └────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

### 1.1 Discovery & Lifecycle: Agent Registry
The **Agent Registry** serves as the central, version-controlled catalog for publishing, discovering, and monitoring enterprise-approved agents. Every agent exposes:
- **Semantic Metadata**: Unique agent ID, semantic version (`v1.2.0`), author domain, and capability tags.
- **Input/Output Schemas**: Strongly typed Pydantic/Zod schemas for parameter validation.
- **Tool Bindings**: Explicitly declared BigQuery tools, OCR endpoints, and document generation templates.

### 1.2 Core Execution & State: Agent Runtime & Memory Bank
- **Async Agent Runtime**: Ingesting multi-item commercial manifests triggers asynchronous, non-blocking execution jobs via Cloud Run and Cloud Pub/Sub. Real-time updates stream back to the client via WebSockets/SSE.
- **Memory Bank**: Maintains persistent, secure, cross-session enterprise memory:
  - Importer/Exporter profiles (verified IRS EIN, Mexico RFC, Brazil CNPJ, Colombia RUT).
  - Continuous customs bonds and power-of-attorney (POA) records.
  - Preferred ports of entry, default Incoterms, and historical HS classification decisions.

### 1.3 Security & Governance: Agent Identity, Gateway & Model Armor
- **Agent Identity (Zero-Trust IAM)**: Each specialized agent operates under a dedicated Google Cloud Service Account with least-privilege IAM bindings:
  - `HS Classification Agent` $\rightarrow$ Read-only access to `ds_customs_compliance`.
  - `Valuation Agent` $\rightarrow$ Access to `ds_trade_agreements` and `ds_customs_compliance`.
  - `Golden Document Generator` $\rightarrow$ Authorized to write to `ds_shipments_declarations`.
- **Model Armor (Inline Guardrails & Local Gemma PII Sanitizer)**:
  - **Local Gemma Model**: Runs on-device/edge to scrub and tokenize sensitive commercial data (EINs, SSNs, personal broker license IDs, supplier cost markups, consignee phone numbers) before transmitting payloads to cloud agents.
  - **Deterministic Grounding**: LLMs are prohibited from inventing tariff rates or HS subheadings. Tariff math is strictly queried from BigQuery.
- **Circuit Breaker & Loop Prevention**:
  - **Confidence Gating**: If HS code confidence is `< 0.80`, the agent immediately pauses automated routing and yields interactive **Smart Tap Chips** in Flutter.
  - **Max Reflection Cycles ($n=2$)**: If validation fails after 2 iterations, the job enters `STATUS_FLAGGED_FOR_HUMAN_REVIEW` with an alert logged to OpenTelemetry.

### 1.4 Telemetry: Agent Observability (OpenTelemetry)
Every reasoning step, tool invocation, and decision path is captured in OpenTelemetry-compliant trace spans:
- Span Attributes: `trade.origin_iso`, `trade.destination_iso`, `trade.hs_code`, `agent.name`, `agent.confidence_score`, `agent.execution_latency_ms`.
- Full auditability for customs and regulatory legal compliance.

---

## 2. Specialized Multi-Agent Swarm (Gemini 3.7 Flash)

```
                                  ┌───────────────────────────────┐
                                  │   ORCHESTRATOR / ROUTER AGENT │
                                  │       (Gemini 3.7 Flash)      │
                                  └───────────────┬───────────────┘
                                                  │
         ┌───────────────────┬────────────────────┼────────────────────┬───────────────────┐
         ▼                   ▼                    ▼                    ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌──────────────────┐ ┌───────────────────┐ ┌─────────────────┐
│ OCR & Document  │ │ HS Classification│ │ Valuation &      │ │ Sanitary & Health │ │ Golden Document │
│ Parser Agent    │ │ Agent           │ │ Tariff Agent     │ │ Regulatory Agent  │ │ Generator Agent │
└────────┬────────┘ └────────┬────────┘ └────────┬─────────┘ └─────────┬─────────┘ └────────┬────────┘
         │                   │                    │                    │                    │
         └───────────────────┴────────────────────┼────────────────────┴────────────────────┘
                                                  │
                                                  ▼
                                    ┌──────────────────────────┐
                                    │ BigQuery Data Mesh       │
                                    │ (ds_customs_compliance)  │
                                    └──────────────────────────┘
```

| Agent Role | Primary Function | Model / Engine | Inputs | Key Outputs |
| :--- | :--- | :--- | :--- | :--- |
| **Orchestrator Agent** | Receives user input (voice, text prompt, or OCR scan), determines origin/destination pair, and dispatches tasks to domain agents. | Gemini 3.7 Flash | Natural language prompt / document upload | Complete clearance payload & interactive UX state |
| **OCR & Document Parser Agent** | Extracts structured fields from raw commercial invoices, bills of lading, packing lists, and photos via vision-OCR models. | Gemini 3.7 Flash Vision | PDF, PNG, JPG, or camera scan of shipping paper | Structured JSON payload (`invoice_number`, `items`, `weights`, `declared_values`) |
| **HS Classification Agent** | Analyzes commodity descriptions and maps them to 6-to-10 digit Harmonized System tariff codes across target country nomenclature. | Gemini 3.7 Flash | Item description, material composition, end-use | 6-10 digit HS Code + confidence score + alternative options |
| **Valuation & Tariff Agent** | Computes duty rates, VAT/GST, merchandise processing fees, and assesses De Minimis threshold rules and FTA discounts. | Gemini 3.7 Flash + SQL | HS Code, Origin ISO, Destination ISO, Declared Value | Itemized landed cost breakdown (Duty, Taxes, MPF, HMF, Fees) |
| **Sanitary & Health Regulatory Agent** | Identifies mandatory permits, health clearances, and phytosanitary rules based on commodity type and destination health authority. | Gemini 3.7 Flash | HS Code, Origin/Destination ISO, Good Type (e.g. Poultry, Food, Meds) | Required permit list (e.g., USDA/APHIS, SENASICA, COFEPRIS, ANVISA, INVIMA) |
| **Trade Agreement Verifier Agent** | Evaluates Rules of Origin under USMCA, MERCOSUR, CAFTA-DR, Pacific Alliance, or CARICOM to auto-apply preferential duty rates. | Gemini 3.7 Flash | Origin ISO, Destination ISO, Regional Value Content (RVC) | Preferential rate applicability status & Certificate of Origin draft |
| **Golden Document Generator Agent** | Compiles validated trade data into official, legally binding customs forms (PDF / JSON / EDI) formatted for local customs platforms. | Gemini 3.7 Flash | Cleared trade JSON payload + verification tokens | Final Golden Document (CBP 7501, Pedimento, DUCA, DUImp, Form 500) |

---

## 3. Golden Documents Master Catalog Across the Americas

A **Golden Document** is a canonical, error-free, legally compliant customs declaration or health permit required by national authorities for import/export authorization.

### 3.1 North America

| Country | Customs Authority | Primary Golden Documents | Primary Sanitary / Regulatory Authorities |
| :--- | :--- | :--- | :--- |
| **United States (`US`)** | U.S. CBP | • **CBP Form 7501** (Entry Summary)<br>• **CBP Form 3461** (Entry/Immediate Delivery)<br>• **ISF 10+2** (Importer Security Filing)<br>• **USMCA Certificate of Origin** | • **FDA**: Prior Notice (PN) & Food Facility Registration<br>• **USDA APHIS**: Veterinary/Phytosanitary Import Permit<br>• **USDA FSIS**: Foreign Establishment Verification |
| **Canada (`CA`)** | CBSA | • **Form B3-3** (Canada Customs Coding Form)<br>• **Canada Customs Invoice (CCI)**<br>• **ACI eManifest** | • **CFIA**: Canadian Food Inspection Agency Import Permit |
| **Mexico (`MX`)** | ANAM / SAT | • **Pedimento Aduanal 3.0**<br>• **CFDI con Complemento Carta Porte**<br>• **NOM Compliance Certificate** | • **SENASICA (SADER)**: Certificado Zoosanitario/Fitosanitario<br>• **COFEPRIS**: Permiso Sanitario de Importación |

---

### 3.2 Central America

| Country | Customs Authority | Primary Golden Documents | Primary Sanitary / Regulatory Authorities |
| :--- | :--- | :--- | :--- |
| **Costa Rica (`CR`)** | SNA / Hacienda | • **DUCA-D** (Declaración Única Centroamericana)<br>• **DUCA-F** (CAFTA Trade)<br>• **TICA Clearance Form** | • **MAG**: Ministerio de Agricultura y Ganadería Permit<br>• **Ministerio de Salud**: Registro Sanitario |
| **Panama (`PA`)** | ANA | • **Declaración de Importación SIGA**<br>• **Permiso de Zona Libre de Colón (ZLC)** | • **APA** (Autoridad Panameña de Alimentos): Licencia de Importación<br>• **MIDA**: Certificado Fitosanitario |
| **Guatemala (`GT`)** | SAT Aduanas | • **DUCA-D / DUCA-F / DUCA-T** | • **MAGA**: Ministerio de Agricultura, Ganadería y Alimentación Permit |
| **El Salvador (`SV`)** | DGA | • **DUCA-D / DUCA-F** | • **MAG**: Certificado Sanitario/Fitosanitario<br>• **MINSAL**: Autorización de Alimentos |
| **Honduras (`HN`)** | Aduanas Honduras | • **DUCA-D / DUCA-F** | • **ARSA**: Agencia de Regulación Sanitaria Permit |
| **Nicaragua (`NI`)** | DGA | • **DUCA-D / DUCA-F** | • **IPSA**: Instituto de Protección y Sanidad Agropecuaria |
| **Belize (`BZ`)** | Customs & Excise | • **C200 Single Administrative Document** | • **BAHA**: Belize Agricultural Health Authority Permit |

---

### 3.3 South America

| Country | Customs Authority | Primary Golden Documents | Primary Sanitary / Regulatory Authorities |
| :--- | :--- | :--- | :--- |
| **Brazil (`BR`)** | Receita Federal (RFB) | • **DUImp** (Declaração Única de Importação)<br>• **Extrato de DI** (Declaração de Importação)<br>• **Certificado de Origem MERCOSUR** | • **MAPA**: Ministério da Agricultura e Pecuária (SIF Registration)<br>• **ANVISA**: Agência Nacional de Vigilância Sanitária License |
| **Colombia (`CO`)** | DIAN | • **Formulario 500** (Declaración de Importación)<br>• **Registro de Importación VUCE** | • **ICA**: Instituto Colombiano Agropecuario Sanidad Permit<br>• **INVIMA**: Instituto Nacional de Vigilancia de Medicamentos y Alimentos |
| **Chile (`CL`)** | Servicio Nacional de Aduanas | • **DIN** (Declaración de Ingreso)<br>• **Certificado de Origen Alianza del Pacífico** | • **SAG**: Servicio Agrícola y Ganadero Permit<br>• **ISP**: Instituto de Salud Pública |
| **Peru (`PE`)** | SUNAT Aduanas | • **DUA** (Declaración Única de Aduanas)<br>• **DAM** (Declaración Aduanera de Mercancías) | • **SENASA**: Servicio Nacional de Sanidad Agraria<br>• **DIGESA**: Dirección General de Salud Ambiental |
| **Ecuador (`EC`)** | SENAE | • **DAI** (Declaración Aduanera de Importación ECUAPASS) | • **AGROCALIDAD**: Certificado Fitosanitario/Zoosanitario<br>• **ARCSA**: Agencia Nacional de Regulación y Control Sanitario |
| **Argentina (`AR`)** | ARCA / DGA | • **Declaración SIM** (Sistema Informático Malvina) | • **SENASA**: Servicio Nacional de Sanidad y Calidad Agroalimentaria<br>• **ANMAT**: Regulación Sanitaria |
| **Uruguay (`UY`)** | DNA | • **DUA** (Declaración Única de Aduanas LUCIA) | • **MGAP**: Ministerio de Ganadería, Agricultura y Pesca |
| **Paraguay (`PY`)** | DNIT Aduanas | • **Despacho de Importación SOFIA** | • **SENAVE / SENACSA**: Sanidad Vegetal y Animal |
| **Bolivia (`BO`)** | Aduana Nacional | • **DMI** (Declaración de Mercancías SUMA) | • **SENASAG**: Sanidad Agropecuaria |
| **Venezuela (`VE`)** | SENIAT | • **Declaración Única de Aduanas** | • **INSAI**: Instituto Neotropical de Sanidad Agropecuaria |
| **Guyana (`GY`)** | GRA Customs | • **Form C72 Customs Entry** | • **NAREI / GLDA**: Agricultural Health Authorities |
| **Suriname (`SR`)** | Douane Suriname | • **Single Administrative Document (SAD)** | • **LVV**: Ministry of Agriculture Permits |

---

### 3.4 Caribbean Nations

| Country | Customs Authority | Primary Golden Documents | Primary Sanitary / Regulatory Authorities |
| :--- | :--- | :--- | :--- |
| **Dominican Republic (`DO`)** | DGA | • **DUA** (Declaración Única Aduanera SIGA)<br>• **CAFTA-DR Certificate of Origin** | • **Ministerio de Agricultura**: Permiso de Importación<br>• **DIGEMAPS**: Control de Alimentos y Medicamentos |
| **Jamaica (`JM`)** | JCA | • **C87 Import Entry Form**<br>• **CARICOM Certificate of Origin** | • **Plant Quarantine / Veterinary Services Division**: Import License |
| **Trinidad & Tobago (`TT`)** | Customs & Excise | • **C75 Declaration Form** | • **Chemistry, Food and Drugs Division**: Inspection Certificate |
| **Bahamas (`BS`)** | Bahamas Customs | • **C13 Import Entry Form (Click2Clear)** | • **BAHFSA**: Bahamas Agricultural Health & Food Safety Authority |
| **Barbados (`BB`)** | Customs & Excise | • **C63 Customs Declaration** | • **Ministry of Agriculture**: Veterinary/Plant Permit |
| **OECS Nations** *(AG, DM, GD, KN, LC, VC)* | OECS Customs | • **ASYCUDA SAD Declaration** | • **Ministry of Agriculture**: CARICOM Sanitary Permits |

---

## 4. Flutter Zero-Typing Client Specification (Mobile + Web)

To maximize speed for logistics sales reps and field warehouse inspectors, the multi-agent system powers a **Zero-Typing Flutter App** (compilable to native Android/iOS and hosted Flutter Web):

1. **Camera OCR Vision Ingestion**:
   - Tapping "Scan Document" captures commercial invoices or bills of lading. The `OCR & Document Parser Agent` populates items, weights, prices, and addresses automatically.
   - **Local Gemma Model** scrubs PII before transmitting.

2. **Smart Contextual Tap Buttons (Chips)**:
   - Instead of asking users to type detailed specs, the UI displays dynamic interactive choice buttons generated by the `HS Classification Agent`:
     - Example for Frozen Chicken:
       `[ 🍗 Whole Chicken ]` `[ 🍗 Cut Pieces / Offal ]` `[ 🍗 Deboned Breasts ]`
     - Example for Valuation:
       `[ 💲 FOB Price ]` `[ 💲 CIF Price ]` `[ 💲 De Minimis Duty-Free ]`

3. **Generative Voice-to-Trade Input**:
   - Sales reps hold a single microphone button in Flutter to speak naturally in Spanish, English, or Portuguese. The `Orchestrator Agent` parses the audio into structured trade variables instantly.
