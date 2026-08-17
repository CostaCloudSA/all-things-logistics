# Enterprise Security, Data Governance & High Availability Standards

> **Scope**: Codified security architecture, data governance policies, Zero-Trust IAM, and High Availability (HA) infrastructure designs for the **All Things Logistics** platform under the **Fortified Enterprise Fleet** track.

---

## 🛡️ 1. Zero-Trust IAM & Agent Identity Isolation

Every agent in the fleet operates as an isolated Google Cloud Service Account governed by the principle of **least privilege**. No single agent has blanket access to the enterprise infrastructure.

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                          ZERO-TRUST AGENT IDENTITY ARCHITECTURE                         │
├───────────────────────────────┬──────────────────────────────────┬─────────────────────┤
│ Service Account               │ Permitted Google Cloud Roles     │ Resource Scope      │
├───────────────────────────────┼──────────────────────────────────┼─────────────────────┤
│ sa-logistics-orchestrator     │ • roles/run.invoker              │ Backend Cloud Run   │
│                               │ • roles/pubsub.publisher         │ Pub/Sub Topics      │
│                               │ • roles/bigquery.dataViewer      │ BigQuery NLP Views  │
├───────────────────────────────┼──────────────────────────────────┼─────────────────────┤
│ sa-hs-classifier              │ • roles/bigquery.dataViewer      │ ds_customs_complia. │
│                               │ • roles/aiplatform.user          │ Vertex AI Predict   │
├───────────────────────────────┼──────────────────────────────────┼─────────────────────┤
│ sa-doc-generator              │ • roles/bigquery.dataEditor      │ ds_shipments_declar │
│                               │ • roles/storage.objectCreator    │ Cloud Storage Docs  │
├───────────────────────────────┼──────────────────────────────────┼─────────────────────┤
│ sa-legal-watchdog             │ • roles/bigquery.dataEditor      │ ds_customs_complia. │
│                               │ • roles/cloudscheduler.jobRunner │ Daily Cron Scraper  │
└───────────────────────────────┴──────────────────────────────────┴─────────────────────┘
```

* **Workload Identity Federation**: External mobile devices and workers authenticate via short-lived OAuth 2.0 OpenID Connect (OIDC) tokens. No long-lived service account JSON keys are ever exported or embedded in client binaries.

---

## 🔒 2. BigQuery Data Governance: Row-Level & Column-Level Security

To protect confidential commercial profit margins, customer pricing contracts, and sensitive personal identifiers (PII), BigQuery enforces fine-grained access control at the data layer.

### A. Column-Level Security (CLS) with Policy Tags
Sensitive fields are tagged using Google Cloud **Data Catalog Taxonomy** and masked dynamically based on the querying principal's role:

| Field Name | Policy Tag | Masking Rule (Unauthorized Principal) | Permitted Role |
| :--- | :--- | :--- | :--- |
| `tax_identification_number` (EIN/RFC/CNPJ) | `Tax_Identifier_PII` | **SHA-256 Hash Masking** (`e3b0c44...`) | Compliance Officer |
| `unit_cost_usd` / `profit_margin_pct` | `Commercial_Confidential_Margin` | **Nullify / Zero Masking** (`NULL` or `$0.00`) | Executive / Finance |
| `driver_ssn` / `driver_home_phone` | `Employee_PII` | **Partial Redaction** (`***-**-6789`) | HR Admin |

### B. Row-Level Security (RLS)
Brokers and port dispatchers can only query declarations and shipments associated with their assigned geographic region or client portfolio:

```sql
-- BigQuery Row-Level Security Policy Example for Regional Dispatchers
CREATE OR REPLACE ROW ACCESS POLICY regional_dispatcher_policy
ON `all-things-logistics-dev.ds_shipments_declarations.customs_declarations`
GRANT TO ("group:us-dispatchers@campabadal.com")
FILTER USING (destination_iso = 'US');
```

---

## 🛡️ 3. Model Armor: Dual-Layer Defense Architecture

Model Armor provides automated defense against data leaks, prompt injection attacks, and hallucinated regulatory math.

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              MODEL ARMOR DUAL-LAYER PIPELINE                           │
│                                                                                        │
│   [User Input / Manifest]                                                              │
│             │                                                                          │
│             ▼                                                                          │
│   ┌──────────────────────────────────┐                                                 │
│   │ 1. LOCAL GEMMA SANITIZER (EDGE)  │ ──► Redacts EIN, SSN, RFC, CNPJ, & phone nums   │
│   └──────────────────────────────────┘                                                 │
│             │                                                                          │
│             ▼ (Sanitized Payload)                                                      │
│   ┌──────────────────────────────────┐                                                 │
│   │ 2. GEMINI 3.7 FLASH SWARM        │ ──► Proposes HS Codes & Extracts Line Items     │
│   └──────────────────────────────────┘                                                 │
│             │                                                                          │
│             ▼ (Proposed Classification)                                                │
│   ┌──────────────────────────────────┐                                                 │
│   │ 3. DETERMINISTIC GROUNDING GATE  │ ──► Overrides LLM duty math with exact BigQuery │
│   └──────────────────────────────────┘     `ds_customs_compliance` SQL truth           │
│             │                                                                          │
│             ▼                                                                          │
│   [Verified Golden Document JSON]                                                      │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

1. **Local Gemma On-Device Tokenization**:
   - Executes locally on the edge or serverless API boundary before prompts leave the trust perimeter.
   - Scrubs commercial tax identifiers (`[REDACTED_EIN]`, `[REDACTED_RFC]`) and personal contact info.
2. **Deterministic Tariff Grounding**:
   - The LLM is strictly prohibited from executing arithmetic or declaring final tariff percentages.
   - Ad valorem rates, VAT/IVA schedules, and MPF calculations are queried directly from BigQuery truth tables.
3. **Circuit Breakers & Reflection Limits**:
   - Maximum agent self-reflection cycles: $n=2$.
   - If classification confidence $< 0.80$, the agent immediately trips a circuit breaker and requests human-in-the-loop clarification via single-tap **Smart Chips**.

---

## 🌐 4. High Availability (HA) & Disaster Recovery Architecture

Customs filings at ocean ports and international land border crossings are **tier-0 mission-critical**. Downtime can result in border gridlock and tens of thousands of dollars in demurrage penalties.

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        HIGH AVAILABILITY & RESILIENCE TOPOLOGY                         │
│                                                                                        │
│                      [ Global Cloud DNS / Cloud Armor WAF ]                            │
│                                   │                                                    │
│                 ┌─────────────────┴─────────────────┐                                  │
│                 ▼                                   ▼                                  │
│    ┌───────────────────────────┐       ┌───────────────────────────┐                   │
│    │ Primary Region (us-east1) │       │ Secondary (us-central1)   │                   │
│    │ • Cloud Run Backend Swarm │       │ • Cloud Run Backend Swarm │                   │
│    │ • Pub/Sub Regional Buffer │       │ • Pub/Sub Regional Buffer │                   │
│    └───────────────────────────┘       └───────────────────────────┘                   │
│                 │                                   │                                  │
│                 └─────────────────┬─────────────────┘                                  │
│                                   ▼                                                    │
│             ┌───────────────────────────────────────────┐                              │
│             │ BigQuery Multi-Region (US) + Replicated   │                              │
│             │ Cloud Storage Dual-Region Buckets         │                              │
│             └───────────────────────────────────────────┘                              │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

### Key High Availability Pillars:
* **Multi-Region Serverless Cloud Run**:
  * Cloud Run containers are deployed in active-active configurations across `us-east1` (South Carolina) and `us-central1` (Iowa).
  * Cloud Load Balancing automatically routes traffic to the nearest healthy region with zero-downtime failover ($< 5\text{s}$).
* **Dual-Region BigQuery & Storage Replication**:
  * BigQuery datasets are provisioned in the multi-region `US` location with automated geo-redundancy.
  * Generated Golden Document PDFs and bill of lading scans are persisted in Google Cloud Storage **Dual-Region buckets** (`us-east1` + `us-central1`) with object versioning.
* **Pub/Sub Asynchronous Buffer & Dead-Letter Queues (DLQ)**:
  * Bulk manifest processing jobs are queued in Cloud Pub/Sub with a **Dead-Letter Queue (DLQ)**. If an external customs API (e.g. CBP ACE or Mexican SAT) is temporarily unreachable, Pub/Sub performs exponential backoff retries without dropping cargo events.
* **100% Offline Client Resilience**:
  * If internet connectivity drops entirely at a port dock, the Flutter client falls back to local high-fidelity mock state, caching user actions for automatic synchronization when connectivity is restored.

---

## 📝 5. Tamper-Evident Auditability & OpenTelemetry Compliance

To satisfy federal customs audit standards (CBP 5-year recordkeeping under 19 U.S.C. § 1508; SAT 5-year tax recordkeeping under Código Fiscal de la Federación Art. 30):

* **OpenTelemetry Distributed Tracing**: Every single agent execution produces an OpenTelemetry span containing:
  * `trace_id`: Unique end-to-end transaction UUID.
  * `trade.origin_iso` & `trade.destination_iso`: Country corridor.
  * `trade.hs_code` & `trade.confidence_score`: Classification details.
  * `security.gemma_sanitized`: Proof of PII redaction.
  * `bigquery.dataset`: Source truth table queried.
* **Cloud Audit Logs**: All BigQuery SQL queries, Cloud Run invocations, and IAM token exchanges are immutably logged to Google Cloud **Cloud Logging** with a 7-year retention lock.
