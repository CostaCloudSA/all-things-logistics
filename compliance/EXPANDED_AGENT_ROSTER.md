# Fortified Enterprise Agent Roster & Quality Assurance Governance

> **Architecture Overview**: A cataloged, scalable multi-agent fleet built on **Gemini 3.7 Flash**, isolated by **Zero-Trust IAM Service Accounts**, audited by **OpenTelemetry**, and governed by **Model Armor**. Each agent fulfills a distinct role in cross-border trade, legal compliance, field operations, and cross-department synchronization.

---

## 🏛️ Master Fleet Catalog & Identity Matrix

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        FORTIFIED MULTI-AGENT ENTERPRISE FLEET                          │
├──────────────────────────┬──────────────────────────┬──────────────────────────────────┤
│ 1. Core Trade Swarm      │ 2. Legal & Risk Defense  │ 3. Operations & Deskless Sync    │
│ • Fleet Orchestrator     │ • Legal Watchdog         │ • Demurrage & Telematics Agent   │
│ • Vision OCR Parser      │ • Sanctions Screener     │ • Deskless Department Sync       │
│ • HS Tariff Classifier   │ • Discrepancy Auditor    │ • Post-Clearance Audit Agent     │
│ • Valuation & Landed Cost│ • Model Armor Sanitizer  │ • Mobile Assistant Dispatcher    │
│ • Sanitary Health Agent  │                          │                                  │
│ • Golden Document Gen    │                          │                                  │
└──────────────────────────┴──────────────────────────┴──────────────────────────────────┘
```

---

## 📑 1. Core Trade & Compliance Swarm

### Agent 1: Fleet Orchestrator & Intent Router (`agent-orchestrator`)
* **Model**: `gemini-3.7-flash` (Temperature 0.1)
* **IAM Identity**: `sa-logistics-orchestrator@gserviceaccount.com`
* **Purpose**: Primary conversational entrypoint and workflow coordinator. Parses multimodal queries (voice, text, photo), resolves trade corridors (Origin $\rightarrow$ Destination ISO), and coordinates downstream worker agents.
* **Input Schema**: `TradeRequest` (user prompt, voice audio, or uploaded manifest).
* **Output Schema**: `TradeResponse` (orchestrated declaration, landed cost, smart chips).
* **Circuit Breaker**: Capped at max 2 reflection loops; fails over to human-in-the-loop Smart Chips if ambiguity remains.

### Agent 2: Vision OCR & Manifest Parser (`agent-ocr-parser`)
* **Model**: `gemini-3.7-flash-vision`
* **IAM Identity**: `sa-logistics-orchestrator@gserviceaccount.com`
* **Purpose**: Ingests unstructured commercial invoices, packing lists, and bills of lading. Extracts tabular line items, unit prices, net/gross weights, container numbers, and Incoterms.
* **Model Armor Defense**: Runs through Local Gemma PII Sanitizer to tokenize vendor tax IDs before cloud reasoning.

### Agent 3: HS Tariff Classification Agent (`agent-hs-classifier`)
* **Model**: `gemini-3.7-flash`
* **IAM Identity**: `sa-hs-classifier@gserviceaccount.com`
* **Purpose**: Maps commodity descriptions to 6-to-10 digit Harmonized System (HS) subheadings across the Americas (HTS US, TIGIE Mexico, NCM Brazil/Mercosur, Arancel Andino).
* **Confidence Gating**: If classification confidence is $< 0.80$, generates dynamic `SmartChip` options (`[ 🍗 Whole Bird ]`, `[ 🍗 Boneless Breasts ]`) to eliminate keyboard typing.

### Agent 4: Valuation & Landed Cost Agent (`agent-valuation-tariff`)
* **Model**: `gemini-3.7-flash` + BigQuery Deterministic SQL
* **IAM Identity**: `sa-hs-classifier@gserviceaccount.com`
* **Purpose**: Computes exact landed cost math: CIF conversion, ad valorem duties, national VAT/IVA, Merchandise Processing Fees (MPF), Harbor Maintenance Fees (HMF), and De Minimis exemptions.
* **Deterministic Model Armor**: Prohibits LLM from guessing math; queries official rate tables in BigQuery `ds_customs_compliance`.

### Agent 5: Sanitary & Regulatory Health Agent (`agent-sanitary-health`)
* **Model**: `gemini-3.7-flash`
* **IAM Identity**: `sa-hs-classifier@gserviceaccount.com`
* **Purpose**: Determines mandatory agricultural, veterinary, and pharmaceutical permit requirements from partner government agencies (USDA APHIS/FSIS, FDA Prior Notice, SENASICA Mexico, MAPA Brazil, ICA/INVIMA Colombia).

### Agent 6: Golden Document Generator Agent (`agent-golden-doc-gen`)
* **Model**: `gemini-3.7-flash`
* **IAM Identity**: `sa-doc-generator@gserviceaccount.com`
* **Purpose**: Formats validated trade data into official customs declaration JSON/EDI schemas:
  * **USA**: CBP Form 7501 (Entry Summary)
  * **Mexico**: Pedimento Aduanal 3.0 (Clave A1)
  * **Central America**: DUCA-D / DUCA-F
  * **Brazil**: Declaração Única de Importação (DUImp - Portal Siscomex)
  * **Colombia**: DIAN Formulario 500

---

## ⚖️ 2. Legal, Risk Defense & Quality Assurance Agents

### Agent 7: Regulatory Legal Watchdog Agent (`agent-legal-watchdog`)
* **Model**: `gemini-3.7-flash` + Cloud Scheduler Cron / Scraper
* **IAM Identity**: `sa-legal-watchdog@gserviceaccount.com`
* **Trigger**: Scheduled daily cron + event-driven RSS notifications.
* **Monitored Official Sources**:
  * **USA**: *Federal Register* (CBP, USTR Section 301, USDA bulletins).
  * **Mexico**: *Diario Oficial de la Federación (DOF)* (ANAM, SAT, Secretaría de Economía).
  * **Brazil**: *Diário Oficial da União (DOU)* (Receita Federal, CAMEX, MAPA).
  * **Colombia**: *Diario Oficial de Colombia* (DIAN, MinCIT, ICA).
  * **Costa Rica**: *La Gaceta Oficial* (Servicio Nacional de Aduanas, PROCOMER).
* **Functionality**:
  1. Scrapes official legal gazettes and changes in customs regulations.
  2. Parses legal decrees using Gemini 3.7 Flash into structured change sets (HS code, old rate, new rate, effective date, decree number).
  3. Automatically updates BigQuery `ds_customs_compliance.hs_codes_v2022` and inserts an audit row into `ds_customs_compliance.legal_updates_log`.
  4. Triggers instant push notifications to compliance officers if an active shipment in transit is impacted by a new tariff or embargo.

### Agent 8: Sanctions & Denied Parties Screening Agent (`agent-sanctions-screener`)
* **Model**: `gemini-3.7-flash` + BigQuery Watchlist Search
* **IAM Identity**: `sa-legal-watchdog@gserviceaccount.com`
* **Purpose**: Screens shippers, consignees, beneficial owners, vessel IMO numbers, and intermediate banks against international watchlists:
  * US OFAC Specially Designated Nationals (SDN) & Sectoral Sanctions Identifications (SSI).
  * US BIS Entity List & Military End-User List.
  * United Nations Security Council Sanctions.
  * INTERPOL Red Notices & National Anti-Money Laundering lists.
* **Output**: Instant PASS / WARNING / HARD_BLOCK flag with matching entity confidence score and legal reference citation.

### Agent 9: Commercial Discrepancy & Cross-Audit Agent (`agent-discrepancy-auditor`)
* **Model**: `gemini-3.7-flash`
* **IAM Identity**: `sa-doc-generator@gserviceaccount.com`
* **Purpose**: Performs pre-submission 3-way cross-reconciliation:
  * **Commercial Invoice vs. Packing List vs. Bill of Lading (B/L)**.
  * Checks for weight discrepancies ($> 3\%$ delta), piece count mismatches, contradictory Incoterms (e.g., invoice says DDP but B/L says Freight Collect), and typographical errors in consignee tax IDs.
* **Output**: Detailed Discrepancy Report highlighting potential customs hold triggers before the declaration is transmitted.

---

## 🚛 3. Operations & Deskless Department Synchronization Agents

### Agent 10: Demurrage & Telematics Predictive Agent (`agent-demurrage-telematics`)
* **Model**: `gemini-3.7-flash` + BigQuery `ds_fleet_telematics`
* **IAM Identity**: `sa-telematics-agent@gserviceaccount.com`
* **Purpose**:
  1. Correlates real-time vessel AIS telemetry, port terminal congestion, and container gate-in timestamps.
  2. Tracks the contractual **Free Time Clock** (Demurrage inside port; Detention/Per Diem outside port).
  3. Calculates financial risk ($/day) and issues voice/push alerts to dispatchers 48 hours before free time expires, recommending priority drayage pickup.

### Agent 11: Deskless Department Sync Agent (`agent-dept-sync`)
* **Model**: `gemini-3.7-flash` + BigQuery Data Mesh
* **IAM Identity**: `sa-logistics-orchestrator@gserviceaccount.com`
* **Purpose**: Automatically derives cross-department operations from customs and shipment milestones:
  * **Payroll / Driver Hours**: Calculates driver detention pay when port wait time exceeds 2 hours.
  * **Finance / Billing**: Automatically generates invoice line items for customs duties, MPF, and accessorial charges.
  * **Warehouse / WMS**: Pre-alerts receiving teams with verified SKU counts and temperature logs before the truck arrives at the loading dock.

### Agent 12: Post-Clearance Audit & Risk Scoring Agent (`agent-audit-risk`)
* **Model**: `gemini-3.7-flash` + BigQuery `ds_shipments_declarations`
* **IAM Identity**: `sa-doc-generator@gserviceaccount.com`
* **Purpose**:
  1. Analyzes 5-year historical declarations against customs agency audit patterns.
  2. Generates complete **Audit Binders** (declarations, commercial invoices, payments, certificates of origin) ready for CBP Focused Assessments or SAT electronic audits in under 10 seconds.
  3. Assigns an institutional **Compliance Risk Score (0-100)** to each importer profile.

---

## 🛡️ Quality Assurance & Governance Framework

| QA Mechanism | Implementation | Enforcement Point |
| :--- | :--- | :--- |
| **Model Armor (Gemma Sanitizer)** | Local on-device entity tokenization | `backend/app/security/gemma_sanitizer.py` |
| **Deterministic Grounding** | Exact tariff lookup via BigQuery SQL | `backend/app/security/model_armor.py` |
| **Circuit Breakers** | Max reflection count $n=2$, confidence threshold $0.80$ | `backend/app/agents/hs_classifier.py` |
| **OpenTelemetry Spans** | Standard semantic attributes (`trade.*`, `security.*`) | `backend/app/core/telemetry.py` |
| **Least-Privilege IAM** | Dedicated Google Cloud Service Accounts per agent | `terraform/modules/iam/` |
| **Multi-Tier Schema Validation** | Pydantic v2 strict models for inputs and outputs | `backend/app/models/schemas.py` |
