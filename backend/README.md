# Gemini 3.7 Flash Backend Agent Fleet

[![Engine](https://img.shields.io/badge/AI_Engine-Gemini_3.7_Flash-purple.svg)](https://deepmind.google/technologies/gemini/)
[![Framework](https://img.shields.io/badge/Framework-FastAPI-green.svg)](https://fastapi.tiangolo.com/)
[![Observability](https://img.shields.io/badge/Telemetry-OpenTelemetry-blue.svg)](https://opentelemetry.io/)

This is the Fortified Enterprise multi-agent backend engine for **All Things Logistics**, designed to automate cross-border trade compliance, customs valuation, and Golden Document generation across the Americas.

---

## 🏛️ Multi-Agent Swarm Architecture

1. **Fleet Orchestrator (`orchestrator.py`)**: Resolves trade corridors and dispatches tasks to specialized workers.
2. **Vision OCR Parser (`ocr_parser.py`)**: Ingests shipping manifests and commercial invoices.
3. **HS Classification Agent (`hs_classifier.py`)**: Maps commodities to Harmonized System subheadings with confidence scoring.
4. **Valuation & Landed Cost Agent (`valuation.py`)**: Computes ad valorem duties, taxes, MPF fees, and De Minimis exemptions.
5. **Sanitary Regulatory Agent (`sanitary.py`)**: Verifies health permits (USDA, FDA, SENASICA, MAPA, INVIMA).
6. **Golden Document Generator (`document_generator.py`)**: Emits legal customs declarations (CBP Form 7501, Pedimento 3.0, DUCA, DUImp).

---

## 🛡️ Model Armor & Security Layers

* **Local Gemma Sanitizer (`gemma_sanitizer.py`)**: Scrubs and tokenizes sensitive trade numbers (IRS EIN, SSN, RFC, CNPJ) on-device before sending prompts to cloud models (+0.2 Bonus Points).
* **Deterministic Tariff Grounding (`model_armor.py`)**: Replaces LLM tariff hallucinations with exact math queried from the BigQuery Data Mesh.
* **Circuit Breaker**: Capped at max 2 reflection cycles and triggers interactive Smart Tap Chips when confidence $< 0.80$.

---

## 🔌 API Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/` | Service health and engine version. |
| `GET` | `/api/registry` | Cross-department Agent Registry catalog. |
| `POST` | `/api/trade/process` | Main natural language & Smart Chip trade resolution endpoint. |
| `POST` | `/api/trade/ocr` | Camera OCR upload & manifest parsing. |
| `GET` | `/api/telemetry/{trace_id}` | OpenTelemetry span viewer for live telemetry sidebars. |
| `WS` | `/ws/telemetry` | Streaming WebSocket for real-time agent execution events. |

---

## ⚡ Quickstart

```bash
# 1. Create Virtual Environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# 2. Install Dependencies
pip install -r requirements.txt

# 3. Set API Key (Optional: works with built-in heuristic fallback even without key)
export GEMINI_API_KEY="your-gemini-api-key"

# 4. Run Server
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```
