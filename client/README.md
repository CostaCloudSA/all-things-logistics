# All Things Logistics - Flutter Client

[![Flutter](https://img.shields.io/badge/Flutter-Cross_Platform-blue.svg)](https://flutter.dev/)
[![Platform](https://img.shields.io/badge/Platforms-Web_|_Android_|_iOS-green.svg)](https://flutter.dev/)
[![Architecture](https://img.shields.io/badge/Layout-Adaptive_Device_Frame-purple.svg)](https://flutter.dev/)

Cross-platform client application for the **All Things Logistics** Fortified Enterprise Fleet.

---

## 📱 Adaptive Device Frame Layout

To provide an intuitive evaluation experience for judges and users without requiring an in-browser emulator:

* **On Desktop / Laptops (`logistics.campabadal.com`)**:
  * Renders a simulated **Smartphone Container** on the left with status bar, camera notch, and touch interactions.
  * Renders a **Live Fleet Telemetry Console** on the right displaying OpenTelemetry execution spans, Model Armor PII redactions, and BigQuery Data Mesh query logs.
* **On Physical Mobile Devices**:
  * Automatically detects screen dimensions and expands to a full-bleed, native mobile Progressive Web App (PWA) interface.

---

## ⚡ Zero-Typing UI Features

1. **Camera Vision OCR**: Instant scanning and ingestion of commercial invoices and bills of lading.
2. **Generative Voice-to-Trade**: One-touch audio recording for dispatchers and port operators.
3. **Dynamic Smart Tap Chips**: Instant single-tap resolution when commodity descriptions require subheading clarification (e.g. `[ 🍗 Whole Bird ]`, `[ 🍗 Boneless Breasts ]`).
4. **Golden Document Inspection Card**: Clear landed cost breakdown (FOB, Ad Valorem, MPF) with 1-tap transmission to CBP ACE / Mexican SAT VUCEM.
5. **Self-Contained Offline Resilience**: Built-in mock state ensures the UI remains 100% testable and functional even without an active backend connection.

---

## 🚀 Running Locally

```bash
# 1. Get Dependencies
flutter pub get

# 2. Run in Chrome (Web)
flutter run -d chrome

# 3. Build Web Bundle
flutter build web --release
```
