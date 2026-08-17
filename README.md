# All Things Logistics: Fortified Enterprise Fleet

[![Hackathon Track](https://img.shields.io/badge/Hackathon_Track-Fortified_Enterprise_Fleet-blue.svg)](https://allthingsagentichackathon.devpost.com/)
[![AI Engine](https://img.shields.io/badge/AI_Engine-Gemini_3.7_Flash-purple.svg)](https://deepmind.google/technologies/gemini/)
[![Model Armor](https://img.shields.io/badge/Model_Armor-Local_Gemma_Sanitizer-green.svg)](https://ai.google.dev/gemma)
[![Infrastructure](https://img.shields.io/badge/IaC-Terraform_on_GCP-orange.svg)](https://cloud.google.com/)
[![Client](https://img.shields.io/badge/Client-Flutter_Mobile_%2B_Web-cyan.svg)](https://flutter.dev/)

An enterprise-grade, multi-agent cross-border trade compliance, customs automation, and deskless logistics platform across the Americas. Built for the **Google All Things Agentic Hackathon** under the **Fortified Enterprise Fleet** track.

* **GitHub Code Repository**: [`https://github.com/CostaCloudSA/all-things-logistics`](https://github.com/CostaCloudSA/all-things-logistics)

---

## 🏛️ System Architecture

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              CROSS-PLATFORM FLUTTER CLIENT                             │
│                     (Native Android / iOS APK + Hosted Web Client)                     │
│        • Camera Vision OCR  • Generative Voice-to-Trade  • Smart Contextual Chips      │
│        • Adaptive Device Frame (Smartphone Mockup + Live Telemetry Sidebar on Desktop) │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                    AGENT GATEWAY & MODEL ARMOR (LOCAL GEMMA)                           │
│        • On-Device PII & Tax ID Redaction  • Deterministic Tariff Grounding Gate       │
│        • Circuit Breaker (n=2, Confidence < 0.80)  • OpenTelemetry Span Tracer         │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                 EXPANDED MULTI-AGENT SWARM (GEMINI 3.7 FLASH)                          │
│   • Fleet Orchestrator         • HS Tariff Classifier      • Valuation & Landed Cost   │
│   • Vision OCR Manifest Parser • Sanitary Health Agent     • Golden Document Generator │
│   • Regulatory Legal Watchdog  • Sanctions Screener        • Discrepancy Auditor       │
│   • Demurrage Predictor        • Deskless Dept Sync Agent  • Post-Clearance Audit Risk │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                 UNIFIED BIGQUERY ENTERPRISE DATA MESH & GCP IaC                        │
│   • ds_customs_compliance      • ds_shipments_declarations • ds_fleet_telematics       │
│   • ds_workforce_hr_payroll    • ds_deskless_crm           • ds_warehousing_wms        │
│   • Multi-Region Cloud Run     • Cloud Pub/Sub Buffer      • Zero-Trust Service Accts  │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📚 Project Documentation Hub

| Category | Document | Link | Description |
| :--- | :--- | :--- | :--- |
| **Field Research** | **SME Field Interview Guide** | [`docs/SME_INTERVIEW_QUESTIONS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/docs/SME_INTERVIEW_QUESTIONS.md) | 45+ questions for multinational logistics veterans across booking realities, paper/EDI bottlenecks, and AI wishlists. |
| **Agent Roster & QA** | **Expanded Agent Roster & QA Governance** | [`compliance/EXPANDED_AGENT_ROSTER.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/compliance/EXPANDED_AGENT_ROSTER.md) | Detailed specs for 12 enterprise agents including the **Regulatory Legal Watchdog**, Sanctions Screener, and Discrepancy Auditor. |
| **Data Mesh & Deskless Org**| **BigQuery Enterprise Data Mesh** | [`standards/BIGQUERY_ENTERPRISE_DATA_MESH.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/standards/BIGQUERY_ENTERPRISE_DATA_MESH.md) | Complete blueprint for a 100% deskless logistics organization (Telematics, Driver Payroll, Mobile CRM, WMS). |
| **Security & Resilience** | **Security & High Availability Standards** | [`standards/SECURITY_AND_HIGH_AVAILABILITY.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/standards/SECURITY_AND_HIGH_AVAILABILITY.md) | Zero-Trust IAM, BigQuery RLS/CLS, Model Armor with Gemma, Multi-Region Cloud Run HA, and 5-year audit trails. |
| **Artifact Index** | **Master Artifact Index** | [`INDEX.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/INDEX.md) | Central navigation hub for all project documentation and architecture specifications. |
| **Compliance Directory** | **Americas Customs Directory** | [`compliance/CUSTOMS_AMERICAS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/compliance/CUSTOMS_AMERICAS.md) | Master regulatory directory of customs authorities, de minimis thresholds, and trade rules across 35+ countries. |
| **Engineering Standards** | **Engineering & Code Standards** | [`standards/ENGINEERING_STANDARDS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/standards/ENGINEERING_STANDARDS.md) | OpenTelemetry semantic attributes, BigQuery rules, Terraform standards, and Flutter Clean Architecture. |
| **Strategy & Submission** | **Strategy & Submission Plan** | [`docs/PROJECT_STRATEGY_AND_QUESTIONS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/docs/PROJECT_STRATEGY_AND_QUESTIONS.md) | Track alignment, Zero-Typing UX specs, and +0.6 Bonus Points execution roadmap. |

---

## ⚡ Quick Spin-Up Instructions (Reproducibility)

### 1. Provision Infrastructure with Terraform
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Update terraform.tfvars with your GCP project_id and region
terraform init
terraform apply -auto-approve
```

### 2. Run the Gemini 3.7 Flash Agent Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
export GEMINI_API_KEY="your-gemini-api-key"
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

### 3. Launch the Flutter Client (Mobile & Web)
```bash
cd client
flutter pub get
# Run in browser for live web testing with Adaptive Device Frame:
flutter run -d chrome
# Build release APK for native mobile deployment:
flutter build apk --release
```
