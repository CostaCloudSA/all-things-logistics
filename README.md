# All Things Logistics: Fortified Enterprise Fleet

[![Hackathon Track](https://img.shields.io/badge/Hackathon_Track-Fortified_Enterprise_Fleet-blue.svg)](https://allthingsagentichackathon.devpost.com/)
[![AI Engine](https://img.shields.io/badge/AI_Engine-Gemini_3.7_Flash-purple.svg)](https://deepmind.google/technologies/gemini/)
[![Model Armor](https://img.shields.io/badge/Model_Armor-Local_Gemma_Sanitizer-green.svg)](https://ai.google.dev/gemma)
[![Infrastructure](https://img.shields.io/badge/IaC-Terraform_on_GCP-orange.svg)](https://cloud.google.com/)
[![Client](https://img.shields.io/badge/Client-Flutter_Mobile_%2B_Web-cyan.svg)](https://flutter.dev/)

An enterprise-grade, 12-agent cross-border trade compliance, customs automation, and deskless logistics platform across the Americas. Built for the **Google All Things Agentic Hackathon** under the **Fortified Enterprise Fleet** track.

* **GitHub Code Repository**: [`https://github.com/CostaCloudSA/all-things-logistics`](https://github.com/CostaCloudSA/all-things-logistics)

---

## 🏛️ System Architecture

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              DESKLESS MOBILE ZERO-TYPING UI                            │
│           (Camera Vision OCR • Voice-to-Trade Audio • Contextual Smart Chips)          │
│        • Adaptive Device Frame (Smartphone Mockup + Live Telemetry Sidebar on Desktop) │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │ Streaming REST / WebSocket
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                    AGENT GATEWAY & MODEL ARMOR (LOCAL GEMMA)                           │
│        • On-Device PII & Tax ID Redaction  • Deterministic Tariff Grounding Gate       │
│        • Bridge Formula & Sanctions Gates  • OpenTelemetry Span Tracer                │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                 EXPANDED MULTI-AGENT SWARM (GEMINI 3.7 FLASH)                          │
│   • Fleet Orchestrator         • HS Tariff Classifier      • Valuation & Landed Cost   │
│   • Vision OCR Manifest Parser • Sanitary Health Agent     • Golden Document Generator │
│   • Night-Watch Telematics     • Bridge Formula Auditor    • Vendor Invoice Matcher    │
│   • Transload Relay (Tecún)    • Regulatory Legal Watchdog • Real-Time Sanctions Screener
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │ Least-Privilege IAM / SQL
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                 UNIFIED BIGQUERY ENTERPRISE DATA MESH & GCP IaC                        │
│   • ds_fleet_telematics        • ds_customs_compliance    • ds_finance_billing        │
│   • ds_workforce_hr_payroll    • ds_deskless_crm           • ds_warehousing_wms        │
│   • Multi-Region Cloud Run     • Cloud Pub/Sub Buffer      • Zero-Trust Service Accts  │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🌟 Primary Golden Showcase Corridor: Miami $\rightarrow$ Tecún Umán $\rightarrow$ Central America

Based on operational research with logistics industry veteran **Jorge Campabadal**, the system highlights a full end-to-end corridor run:
1. **Zero-Typing Ingestion**: Ingests messy ocean bills of lading and invoices via Camera Vision OCR.
2. **Bridge Formula Axle Shield**: Detects that while gross weight is legal (20T), trailer tandem is overloaded at 34,800 lbs ($>34\text{k limit}$), advising pallet rebalancing before gate departure.
3. **Autonomous 24/7 Night-Watch**: Silently monitors cold-chain Controlled Atmosphere ($O_2/CO_2$) telemetry at -18°C and dispatches automated WhatsApp updates to clients every 2 hours.
4. **Tecún Umán Transload & DUCA-T Relay**: Synthesizes the required Central American transit declaration (`DUCA-T`) for Mexican/Guatemalan border transloading, eliminating 45 minutes of manual re-typing.
5. **Non-Resident Tax Defense**: Calculates and accounts for statutory foreign withholding taxes (15–25%) deducted at source.

---

## 📚 Master Project Hub & Deliverables

| Category | Document | Link | Description |
| :--- | :--- | :--- | :--- |
| **Devpost Submission** | **Devpost Written Submission** | [`docs/DEVPOST_SUBMISSION.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/docs/DEVPOST_SUBMISSION.md) | Official submission narrative for the Fortified Enterprise Fleet track. |
| **Demo Video** | **4-Minute Demo Video Script** | [`docs/DEMO_VIDEO_SCRIPT.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/docs/DEMO_VIDEO_SCRIPT.md) | Scene-by-scene script covering the Problem, Zero-Typing UX, live corridor run, and GCP proof. |
| **Bonus (+0.2 pts)** | **Technical Blog Post** | [`docs/TECHNICAL_BLOG_POST.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/docs/TECHNICAL_BLOG_POST.md) | Engineering article on Gemini 3.7 Flash, Local Gemma Model Armor, and BigQuery Data Mesh. |
| **Bonus (+0.2 pts)** | **LinkedIn Announcement** | [`docs/LINKEDIN_POST.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/docs/LINKEDIN_POST.md) | Community launch post with `#AllThingsAgenticHackathon` and repository links. |
| **SME Field Validation** | **SME Interview Guide** | [`docs/SME_INTERVIEW_QUESTIONS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/docs/SME_INTERVIEW_QUESTIONS.md) | Field operational variable guide validated with logistics veteran Jorge Campabadal. |
| **Agent Roster** | **Expanded Agent Roster** | [`compliance/EXPANDED_AGENT_ROSTER.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/compliance/EXPANDED_AGENT_ROSTER.md) | Detailed specifications for all 12 enterprise fleet agents. |
| **Data Mesh** | **BigQuery Enterprise Data Mesh** | [`standards/BIGQUERY_ENTERPRISE_DATA_MESH.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/standards/BIGQUERY_ENTERPRISE_DATA_MESH.md) | Complete DDLs for a 100% deskless logistics organization (Telematics, Payroll, Billing, WMS). |
| **Security** | **Security & HA Standards** | [`standards/SECURITY_AND_HIGH_AVAILABILITY.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/standards/SECURITY_AND_HIGH_AVAILABILITY.md) | Zero-Trust IAM, BigQuery RLS/CLS, Model Armor with Gemma, and OpenTelemetry tracing. |
| **Master Index** | **Artifact Index** | [`INDEX.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/INDEX.md) | Master navigation hub for all project documentation. |

---

## ⚡ Quick Spin-Up Instructions (Reproducibility)

### 1. Run the Golden Flow Simulation (Docker / Python)
```bash
cd backend
python scripts/test_golden_flow.py
```

### 2. Run Backend with Docker
```bash
docker build -t logistics-backend .
docker run -p 8080:8080 -e GEMINI_API_KEY="your-gemini-api-key" logistics-backend
```

### 3. Provision Cloud Infrastructure with Terraform
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply -auto-approve
```

### 4. Launch Flutter Client (Mobile & Web)
```bash
cd client
flutter pub get
flutter run -d chrome
```
