# Changelog

All notable changes to the **Campabadal Global Logistics** autonomous trade compliance and enterprise multi-agent fleet platform will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.1.0] - 2026-08-23 (Operations Hub UI Overhaul)

### 🎨 Frontend & UX Overhaul
- **2x4 Tactile Operations Hub Grid**: Implemented high-contrast squircle macro-grid featuring:
  - `Scan QR Code` (Royal Blue `#2563EB`) $\to$ Roadside Offline Ed25519 Inspector & Camera OCR.
  - `Cargo Manifest` (Vibrant Green `#16A34A`) $\to$ Golden Document DUCA-T & B/L modal.
  - `Track Shipments` (Vibrant Orange `#EA580C`) $\to$ 24/7 Night-Watch Geofence & WhatsApp Dispatch.
  - `Inventory Lookup` (Dark Teal `#0D9488`) $\to$ BigQuery Data Mesh SKU schedule.
  - `Create BOL` (Coral Red `#EF4444`) $\to$ Multimodal Vision OCR and manifest synthesizer.
  - `Customs Clearance` (Royal Purple `#7C3AED`) $\to$ 0% CAFTA-DR duty & CIF Landed Cost engine.
  - `Schedule Pickup` (Golden Amber `#EAB308`) $\to$ Cabotage Transload Relay & tractor dispatch.
  - `Warehouse Entry` (Bright Sky Blue `#0EA5E9`) $\to$ 5-Axle Bridge Formula load distribution.
- **Top Operator Profile Header**: Integrated circular avatar with operator badge ("T. Omas") and hamburger menu drawer (`≡`).
- **4-Tab Enterprise Navigation**: Restructured into `Dashboard` (Hero 2x4 Grid), `Fleet` (SME Telematics & Axle Scale), `Profile` (Multi-Tenant Switcher & SCAC/DOT credentials), and `Settings` (Security & Ed25519 Verification).
- **Interactive App Drawer**: Side drawer housing tenant switcher, operator status, and GCP Cloud Run infrastructure health.

---

## [2.0.0] - 2026-08-22 (Fortified Enterprise Fleet Release)

### 🎨 Frontend & UX
- **Glassmorphic Modern UI**: Implemented high-contrast dark theme (`#070B14` to `#0F172A`) with subtle glassmorphism borders and dynamic accent glows.
- **Dynamic Multi-Company Switcher**: 1-click top switcher bar to instantly switch personas between:
  - **Campabadal Global Logistics** (`#0284C7` Electric Blue): Multinational 3PL Freight Forwarder.
  - **Transportes Tomas** (`#DC2626` Vibrant Red): Regional Motor Carrier and Heavy Drayage Relay.
  - **Agroexport Costa Rica** (`#059669` Emerald Green): Enterprise Perishables Shipper.
- **Guided Smart Chips ("No Keyboard" UX)**: Built 1-tap scenario presets (`[🍗 20T Poultry]`, `[🍍 Fresh Pineapples]`, `[🥑 Hass Avocados]`) and operational action chips (`[⚖️ Bridge Formula]`, `[🌙 Night-Watch]`, `[📄 DUCA-T]`, `[📱 Inspector QR]`, `[🤝 A2A Handshake]`) designed for deskless forklift and truck operators.
- **Tabbed Operational Views**: Reorganized dashboard into Golden Document, SME Operations, A2A Federation, and Audit & Telemetry tabs.
- **Flutter Web Engine Bootstrap**: Resolved `FlutterLoader.loadEntrypoint` initialization hook for zero-latency loading on `https://logistics.campabadal.com`.

### 🛡️ Security & Enterprise Compliance
- **OWASP Top 10 & Compliance Whitepaper** (`docs/OWASP_AND_ENTERPRISE_SECURITY_AUDIT.md`): Complete security audit documenting mitigations for OWASP Top 10:2021/2025 (Web/API), OWASP Top 10 for LLMs (LLM01-LLM10), C-TPAT Cybersecurity Criteria, SOC 2 Type II, ISO/IEC 27001:2022, NIST SP 800-161 (C-SCRM), and FedRAMP Moderate.
- **Ed25519 Cryptographic Manifest Signing**: Embedded asymmetric signature seals into Golden Documents and offline roadside QR inspection codes (`backend/app/security/manifest_signer.py`).
- **On-Device Model Armor**: Sanitized confidential commercial invoices, tax identifiers, and driver PII using edge Gemma sanitizer.

### 🤖 Multi-Agent Swarm Backend
- **12-Agent Roster**: Expanded fleet with Gemini 3.7 Flash:
  - `bridge_formula.py`: Statutory Federal Bridge Formula B ($W = 500 \cdot [\frac{LN}{N-1} + 12N + 36]$) and Central American SIECA axle load auditor.
  - `night_watch.py`: Autonomous 24/7 geofence tracking and 2-hour proactive WhatsApp pushes.
  - `transload_relay.py`: Automated Tecún Umán border drayage DUCA-T transit synthesizer.
  - `vendor_matcher.py`: 3-way freight audit reconciling B/L, detention, and linehaul invoices.
  - `sanitary.py`: USDA-APHIS / SENASA / MAGA cold-treatment and Controlled Atmosphere telemetry analyzer.
  - `valuation.py`: Foreign non-resident withholding tax deduction engine (15-25%).
  - `legal_watchdog.py`, `sanctions_screener.py`, `discrepancy_auditor.py`, `demurrage_predictor.py`, `deskless_sync.py`.
- **Codebase Engineering Standards Audit**: 100% of backend and frontend files annotated with Google-style docstrings and Dart documentation comments (`///`).

---

## [1.1.0] - 2026-08-21

### Added
- Cloud Run production deployments for `logistics-flutter-web` and `logistics-backend-api` in `us-central1`.
- Custom domain mapping to `https://logistics.campabadal.com`.
- BigQuery Data Mesh schema specification for sovereign multi-tenant dataset partitioning.
- SME operational interview guide based on Jorge Campabadal's cross-border logistics expertise.

---

## [1.0.0] - 2026-08-20

### Added
- Initial 6-agent Gemini 3.7 Flash customs clearance prototype.
- Multimodal OCR Bill of Lading parsing agent.
- Golden Document generation for CBP Form 7501, Mexican Pedimento, and DUCA-T.
- OpenTelemetry distributed trace collector.

---

## [0.1.0] - 2026-08-19

### Added
- Master Americas regulatory customs database across 35+ countries (`compliance/CUSTOMS_AMERICAS.md`).
- Initial repository layout, Dockerfiles, and Terraform IaC definitions.
