# Engineering & Code Standards

This document establishes the official engineering, code quality, annotation, data architecture, security, and operational standards for the **Logistics Hackathon** project under the **Fortified Enterprise Fleet** track. All contributors, Terraform scripts, Flutter developers, and automated agents must adhere to these guidelines.

---

## 1. Core Engineering Principles

1. **Modular Architecture & Strict Separation of Concerns**
   - Decouple agent business logic, AI prompt orchestration, data persistence (BigQuery), infrastructure (Terraform), and presentation (Flutter).
   - Each agent is a single-purpose, bounded worker (e.g., Valuation Agent performs math and queries tariffs; it cannot write documents directly).

2. **Type Safety & Schema Rigor**
   - Python Backend: Strict Pydantic models for all agent input/output parameters.
   - Flutter App: Type-safe Dart models with `freezed` or `json_serializable` for JSON encoding/decoding.
   - Terraform: Variable type definitions and validation blocks for all Google Cloud modules.

3. **Defensive Programming & Deterministic Guardrails**
   - Never allow LLMs to invent legal tariff rates or HS subheadings. Tariff lookups must query BigQuery `ds_customs_compliance` deterministically.
   - All network calls (BigQuery, Gemini API, Cloud Run endpoints) must include timeouts, exponential backoff retries, and circuit breakers.

4. **DRY & Reusability**
   - Encapsulate trade calculations (FOB/CIF math, VAT, MPF, exchange rates) in shared, unit-tested core modules.

---

## 2. Fortified Enterprise Security & Model Armor Standards

### 2.1 Model Armor & PII Sanitization
1. **Local Gemma Masking**: All commercial invoices and shipping documents must be scrubbed of confidential data (Tax IDs, EINs, personal broker IDs, confidential margins, phone numbers) before cloud transmission.
2. **Anti-Hallucination Gating**:
   - Every generated HS code must have a confidence score $> 0.80$ against the BigQuery taxonomy.
   - If confidence is $\le 0.80$, the backend MUST yield interactive choice chips to Flutter for human confirmation.
3. **Circuit Breakers**:
   - `max_agent_reflection_cycles` is strictly capped at `2`.
   - If validation fails twice, transition to `STATUS_FLAGGED_FOR_HUMAN_REVIEW` with an OpenTelemetry trace.

### 2.2 Agent Identity (Zero-Trust IAM)
- Every agent runs under a dedicated Google Cloud Service Account:
  - `sa-hs-classifier@<project>.iam.gserviceaccount.com` (BigQuery Data Viewer on `ds_customs_compliance`).
  - `sa-valuation@<project>.iam.gserviceaccount.com` (BigQuery Data Viewer on `ds_trade_agreements` & `ds_customs_compliance`).
  - `sa-doc-generator@<project>.iam.gserviceaccount.com` (BigQuery Data Editor on `ds_shipments_declarations`).

---

## 3. Telemetry & Agent Observability Standards (OpenTelemetry)

Every agent execution and decision step MUST emit OpenTelemetry-compliant trace spans containing standardized semantic attributes:

```python
# OpenTelemetry Span Standards Example
with tracer.start_as_current_span("agent.hs_classification") as span:
    span.set_attribute("trade.origin_iso", "CO")
    span.set_attribute("trade.destination_iso", "US")
    span.set_attribute("trade.commodity_raw", "frozen chicken cuts")
    span.set_attribute("trade.hs_code_predicted", "0207.14.00")
    span.set_attribute("agent.confidence_score", 0.94)
    span.set_attribute("agent.model", "gemini-3.7-flash")
```

| Span Attribute Key | Type | Description |
| :--- | :--- | :--- |
| `trade.origin_iso` | String | 2-letter ISO origin country (e.g., `CO`, `MX`). |
| `trade.destination_iso` | String | 2-letter ISO destination country (e.g., `US`, `BR`). |
| `trade.hs_code` | String | 6-10 digit Harmonized System tariff code. |
| `agent.name` | String | Unique identifier of the executing agent (`hs-classifier`, `valuation`). |
| `agent.model` | String | Active AI model (e.g., `gemini-3.7-flash`, `gemma-2b-local`). |
| `agent.confidence_score` | Float | Model confidence metric between `0.0` and `1.0`. |
| `agent.circuit_breaker_tripped` | Boolean | `true` if fallback triggered. |

---

## 4. BigQuery Domain-Driven Data Mesh Standards

Data in BigQuery must be organized into domain-specific datasets prefixed with `ds_`:

| Dataset Identifier | Domain Scope | Mandatory Table Examples |
| :--- | :--- | :--- |
| `ds_customs_compliance` | Tariff schedules, HS code hierarchies, De Minimis thresholds, sanitary permit rules. | `hs_codes_v2022`, `country_de_minimis`, `regulatory_permits_matrix` |
| `ds_shipments_declarations` | Commercial invoices, entry summaries, Pedimentos, DUCAs, DUImps. | `entry_summaries_cbp_7501`, `pedimentos_mx`, `duca_manifests` |
| `ds_trade_agreements` | Preferential rates, rules of origin, duty reduction schedules. | `usmca_rules_origin`, `mercosur_cet_rates`, `cafta_dr_schedule` |
| `ds_logistics_tracking` | Transport waybills, vessel/flight events, port status logs. | `carrier_waybills`, `port_events`, `intermodal_segments` |
| `ds_mcp_nlp_views` | Flattened semantic views (`v_*`) and vector tables for BigQuery MCP & NLP engines. | `v_shipment_customs_status`, `v_landed_cost_breakdown` |

### Mandatory Schema & Column Descriptions
EVERY table and column created in BigQuery MUST include an explicit `description` field in its DDL or schema specification for LLM/MCP tool discovery.

---

## 5. Infrastructure as Code (IaC) Standards: Terraform

All Google Cloud infrastructure in [`https://github.com/CostaCloudSA/all-things-logistics`](https://github.com/CostaCloudSA/all-things-logistics) must be provisioned via modular Terraform:

### Directory Layout
```
terraform/
├── main.tf                 # Global provider and backend configuration
├── variables.tf            # Input variables with descriptions and type constraints
├── outputs.tf              # Exported resource IDs, Cloud Run URLs, BigQuery dataset IDs
├── terraform.tfvars.example # Sample variable values for reproduction
└── modules/
    ├── bigquery/           # Datasets, tables, schemas, and partitioning
    ├── cloud_run/          # Backend container service and autoscaling configuration
    ├── iam/                # Zero-Trust Service Accounts and least-privilege role bindings
    └── pubsub/             # Topics and subscriptions for async agent queues
```

### Rules
1. **No Hardcoded Secrets**: Use Google Secret Manager or environment variables.
2. **State Storage**: Remote backend configured with Google Cloud Storage bucket locking.
3. **Reproducibility**: `terraform init` and `terraform apply` must run seamlessly using `terraform.tfvars.example`.

---

## 6. Client Application Standards: Flutter (Mobile + Web)

### Architecture Pattern: Clean Architecture + BLoC / Riverpod
1. **Directory Structure**:
   ```
   lib/
   ├── core/          # Theme, constants, network clients, Gemma local bridges
   ├── data/          # BigQuery/Backend API repositories, DTO models, local storage
   ├── domain/        # Business entities, use cases, validation rules
   └── presentation/  # Zero-Typing UI widgets, smart chips, camera OCR view, voice button
   ```
2. **Zero-Typing UI Mandate**:
   - Mobile screens must minimize keyboard activation.
   - Dynamic choice chips (`ChoiceChip`, `ActionChip`) must be dynamically populated from backend agent schemas.
3. **Compilation Targets**:
   - Android APK (`flutter build apk --release`).
   - Flutter Web (`flutter build web --release`) for public judging URL.
