# All Things Logistics: Fortified Enterprise Fleet

[![Hackathon Track](https://img.shields.io/badge/Hackathon_Track-Fortified_Enterprise_Fleet-blue.svg)](https://allthingsagentichackathon.devpost.com/)
[![AI Engine](https://img.shields.io/badge/AI_Engine-Gemini_3.7_Flash-purple.svg)](https://deepmind.google/technologies/gemini/)
[![Infrastructure](https://img.shields.io/badge/IaC-Terraform_on_GCP-orange.svg)](https://cloud.google.com/)
[![Client](https://img.shields.io/badge/Client-Flutter_Mobile_%2B_Web-cyan.svg)](https://flutter.dev/)

An enterprise-grade, multi-agent cross-border trade compliance and automated customs clearance platform across the Americas. Built for the **Google All Things Agentic Hackathon** under the **Fortified Enterprise Fleet** track.

* **GitHub Code Repository**: [`https://github.com/CostaCloudSA/all-things-logistics`](https://github.com/CostaCloudSA/all-things-logistics)

---

## 🏛️ System Architecture

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              CROSS-PLATFORM FLUTTER APP                                │
│                     (Native Android / iOS APK + Hosted Web URL)                        │
│             • Camera Vision Ingestion  • Voice-to-Trade  • Smart Tap Chips             │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                    AGENT GATEWAY & MODEL ARMOR (LOCAL GEMMA)                           │
│             • PII/Confidential Data Masking  • Anti-Hallucination Guardrails           │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                 ENTERPRISE AGENT FLEET BACKEND (GEMINI 3.7 FLASH)                      │
│     • Orchestrator  • HS Classifier  • Valuation  • Sanitary  • Doc Generator          │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │
┌───────────────────────────────────────────▼────────────────────────────────────────────┐
│                    GOOGLE CLOUD INFRASTRUCTURE (TERRAFORM)                             │
│   • Cloud Run (Async Runtime)    • Cloud Pub/Sub    • BigQuery Domain Data Mesh        │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📚 Project Documentation Hub

| Document | Link | Description |
| :--- | :--- | :--- |
| **Artifact Index** | [`INDEX.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/INDEX.md) | Central navigation hub for all project artifacts and guides. |
| **Multi-Agent & Golden Docs** | [`compliance/AGENTS_AND_GOLDEN_DOCUMENTS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/compliance/AGENTS_AND_GOLDEN_DOCUMENTS.md) | Agent Registry, Model Armor, and Golden Documents matrix for all 35+ countries in the Americas. |
| **Engineering Standards** | [`standards/ENGINEERING_STANDARDS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/standards/ENGINEERING_STANDARDS.md) | OpenTelemetry tracing standards, BigQuery Data Mesh DDL rules, Terraform IaC, and Flutter guidelines. |
| **Americas Customs Directory** | [`compliance/CUSTOMS_AMERICAS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/compliance/CUSTOMS_AMERICAS.md) | Master regulatory directory of customs authorities, de minimis thresholds, and trade rules. |
| **Strategy & Submission Plan** | [`docs/PROJECT_STRATEGY_AND_QUESTIONS.md`](file:///c:/Users/campabadal/Documents/antigravity/logistics%20hackathon/docs/PROJECT_STRATEGY_AND_QUESTIONS.md) | Fortified Enterprise Fleet roadmap, Zero-Typing UX specs, and bonus points strategy (+0.6 pts). |

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
export GOOGLE_API_KEY="your-gemini-api-key"
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

### 3. Launch the Flutter Client (Mobile & Web)
```bash
cd client
flutter pub get
# Run in browser for live web testing:
flutter run -d chrome
# Build release APK for native mobile testing:
flutter build apk --release
```
