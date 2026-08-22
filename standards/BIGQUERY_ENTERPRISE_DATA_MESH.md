# BigQuery Enterprise Data Mesh: The Blueprint for a Deskless Logistics Organization

> **Core Objective**: Dramatically reduce or eliminate the need for laptops, desktop computers, and rigid ERP workstations across logistics companies by centralizing every departmental data stream into a **Domain-Driven BigQuery Data Mesh**. 
> Field workers, drivers, dispatchers, and warehouse personnel operate 100% on **mobile voice, camera OCR, and smart-chip interfaces**, while Gemini 3.7 Flash autonomous agents query, update, and orchestrate business logic directly over BigQuery tables in real time.

---

## 🏛️ Enterprise Data Mesh Architecture

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        UNIFIED BIGQUERY ENTERPRISE DATA MESH                           │
├──────────────────────────┬──────────────────────────┬──────────────────────────────────┤
│ 1. Operations & Fleet    │ 2. Compliance & Customs  │ 3. Workforce & CRM               │
│ • ds_fleet_telematics    │ • ds_customs_compliance  │ • ds_workforce_hr_payroll        │
│ • ds_warehousing_wms     │ • ds_shipments_declarat. │ • ds_deskless_crm                │
│ • ds_port_terminals      │ • ds_sanctions_watchlists│ • ds_finance_billing             │
└──────────────────────────┴──────────────────────────┴──────────────────────────────────┘
                                   │
              ┌────────────────────┴────────────────────┐
              ▼                                         ▼
   🤖 Autonomous Agent Swarm                📱 Mobile Zero-Typing UI
   (Gemini 3.7 Flash + Tool Calling)        (Voice, Camera OCR, Smart Chips)
```

---

## 📊 Complete Departmental BigQuery Catalog

### 1. Fleet Telematics & Vehicle Tracking (`ds_fleet_telematics`)
Replaces expensive legacy telematics desktop portals with streaming table data and autonomous night-watch agents.

* **`vehicle_telemetry_live`**:
  * `vehicle_id` (STRING): Unique tractor/chassis identifier.
  * `timestamp` (TIMESTAMP): Real-time GPS ping timestamp (partitioned by day).
  * `latitude`, `longitude` (FLOAT64): Geospatial coordinates.
  * `geofence_id` (STRING): Terminal, port, warehouse, or border crossing identifier.
  * `speed_mph`, `engine_rpm` (FLOAT64): Vehicle performance metrics.
  * `fuel_level_pct` (FLOAT64): Real-time fuel gauge reading.
  * `hours_of_service_status` (STRING): `DRIVING`, `ON_DUTY_NOT_DRIVING`, `SLEEPER`, `OFF_DUTY`.
* **`axle_weights_and_load_balance`** *(SME Operational Discovery)*:
  * `vehicle_id` (STRING): Tractor/chassis identifier.
  * `container_number` (STRING): Associated container.
  * `steer_axle_lbs` (FLOAT64): Steer axle weight (Limit: 12,000 lbs).
  * `drive_tandem_lbs` (FLOAT64): Drive tandem weight (Limit: 34,000 lbs).
  * `trailer_tandem_lbs` (FLOAT64): Trailer tandem weight (Limit: 34,000 lbs).
  * `gross_vehicle_weight_lbs` (FLOAT64): Total gross weight (Limit: 80,000 lbs).
  * `bridge_formula_compliance_status` (STRING): `COMPLIANT`, `OVERWEIGHT_TRAILER_TANDEM`, `OVERWEIGHT_DRIVE_TANDEM`, `GROSS_EXCEEDED`.
  * `audited_timestamp` (TIMESTAMP): Timestamp of pre-trip weight calculation.
* **`reefer_cold_chain_telemetry`** *(Expanded with Controlled Atmosphere)*:
  * `container_number` (STRING): Reefer box number (e.g., `MSCU1234567`).
  * `set_temperature_celsius` (FLOAT64): Target temperature for cargo (e.g., -18.0°C for chicken, +4.0°C for berries).
  * `actual_temperature_celsius` (FLOAT64): Sensor probe reading.
  * `controlled_atmosphere_o2_pct` (FLOAT64): Oxygen percentage for fruit/produce respiration control.
  * `controlled_atmosphere_co2_pct` (FLOAT64): Carbon dioxide percentage.
  * `power_plug_status` (STRING): `PLUGGED_TERMINAL`, `GENSET_RUNNING`, `BATTERY_BACKUP`, `UNPLUGGED_ALERT`.
  * `door_sensor_state` (STRING): `OPEN`, `CLOSED`.
* **`route_deviations_and_detours`** *(SME Operational Discovery)*:
  * `deviation_id` (STRING): Unique detour event ID.
  * `vehicle_id` (STRING): Vehicle ID.
  * `original_route_id` (STRING): Planned route.
  * `detour_reason` (STRING): `LANDSLIDE_BLOCKAGE`, `PROTEST_ROADBLOCK`, `BRIDGE_WEIGHT_RESTRICTION`, `WEATHER_EMERGENCY`.
  * `approved_alternate_route` (STRING): Code name for alternate route (e.g., `ROUTE_B_COASTAL`).
  * `extra_mileage` (FLOAT64): Additional odometer miles.
  * `extra_fuel_gallons` (FLOAT64): Fuel consumed during detour.
  * `reimbursable_claim_status` (STRING): `CLAIM_GENERATED_FORM_ARM`, `AUTO_APPROVED`, `REIMBURSED`.

---

### 2. Customs, Regulatory & Compliance (`ds_customs_compliance` & `ds_shipments_declarations`)
Centralizes all tariff rules, trade agreements, bridge formulas, and transload manifests.

* **`ref_bridge_formula_limits`**:
  * `jurisdiction` (STRING): `US_FEDERAL_TITLE_23`, `MEXICO_NOM_012_SCT`, `CENTRAL_AMERICA_SIECA`.
  * `max_steer_axle_kg` (FLOAT64): Steer limit (5,443 kg / 12,000 lbs).
  * `max_tandem_axle_kg` (FLOAT64): Tandem limit (15,422 kg / 34,000 lbs).
  * `max_gross_weight_kg` (FLOAT64): Gross limit (36,287 kg / 80,000 lbs).
  * `calculation_formula` (STRING): `W = 500 * (LN/(N-1) + 12N + 36)`.
* **`ref_non_resident_tax_withholdings`** *(SME Operational Discovery)*:
  * `country_code` (STRING): `SV`, `CR`, `GT`, `HN`, `NI`, `CO`, `MX`.
  * `country_name` (STRING): El Salvador, Costa Rica, Guatemala, Honduras, Nicaragua, Colombia, Mexico.
  * `withholding_tax_pct` (FLOAT64): 0.20 (20% for El Salvador, Colombia), 0.15 (15% for Costa Rica).
  * `statutory_reference` (STRING): National Tax Code legal reference for non-domiciled corporate income.
* **`transload_border_declarations`** *(Tecún Umán & Multi-Border Relays)*:
  * `transload_id` (STRING): Unique border transload event ID.
  * `origin_ocean_bl_number` (STRING): Primary ocean Bill of Lading (Miami $\rightarrow$ Guatemala).
  * `border_hub_name` (STRING): `TECUN_UMAN_GT_MX`, `PENAS_BLANCAS_CR_NI`, `PASO_CANOAS_CR_PA`.
  * `inbound_carrier_tax_id` (STRING): Inbound motor carrier RFC/ID (Mexico / US).
  * `outbound_carrier_tax_id` (STRING): Outbound Central American carrier ID (Guatemala / Regional).
  * `duca_t_document_id` (STRING): Generated Central American Transit Declaration ID.
  * `seal_verification_status` (STRING): `ISO_17712_VERIFIED_MATCH`, `BROKEN_ALERT`.

---

### 3. Workforce, HR & Automated Payroll (`ds_workforce_hr_payroll`)
Replaces manual punch clocks and spreadsheet payroll calculations with automated event-driven tracking.

* **`driver_shift_logs`**:
  * `driver_id` (STRING): Masked employee identifier.
  * `shift_start_time`, `shift_end_time` (TIMESTAMP): Geofence-verified start/end timestamps.
  * `miles_driven` (FLOAT64): Verified odometer distance from GPS.
  * `assigned_vehicle_id` (STRING): Tractor identifier.
* **`driver_detention_events`**:
  * `event_id` (STRING): Unique detention incident ID.
  * `driver_id` (STRING): Driver identifier.
  * `facility_id` (STRING): Terminal gate, shipper warehouse, or border inspection bay.
  * `arrival_timestamp` (TIMESTAMP): Verified geofence entry.
  * `dock_in_timestamp`, `dock_out_timestamp` (TIMESTAMP): Loading/unloading times.
  * `free_time_allowed_hours` (FLOAT64): Standard allowable waiting time (typically 2.0 hours).
  * `billable_detention_hours` (FLOAT64): `dock_out - arrival - free_time`.
  * `driver_detention_rate_per_hour` (FLOAT64): Payout rate ($75.00/hr).
  * `total_payout_amount_usd` (FLOAT64): Automated wage line item.
  * `status` (STRING): `AUTO_APPROVED`, `FLAGGED_REVIEW`, `PAID`.

---

### 4. Warehousing & Cross-Dock Management (`ds_warehousing_wms`)
Eliminates desktop WMS workstations by logging barcode scans directly to BigQuery via mobile camera feeds.

* **`inventory_pallet_locations`**:
  * `pallet_barcode_id` (STRING): Scanned GS1 barcode.
  * `warehouse_id` (STRING): Facility code (e.g., `WH-MIA-01`).
  * `rack_bay_tier` (STRING): Physical storage coordinate (e.g., `A-14-03`).
  * `sku_id` (STRING): Product identifier.
  * `hs_code` (STRING): Harmonized System classification code.
  * `quantity_units` (INTEGER): Piece count.
  * `temperature_zone` (STRING): `AMBIENT`, `CHILLED`, `FROZEN`.
  * `last_scanned_by_worker_id` (STRING): Mobile device user ID.
  * `last_scanned_timestamp` (TIMESTAMP): Event timestamp.

---

### 5. Deskless Mobile-First CRM (`ds_deskless_crm`)
Replaces cumbersome desktop CRM suites with voice-driven customer records and instant quoting.

* **`customer_accounts`**:
  * `customer_id` (STRING): Unique corporate account number.
  * `company_name` (STRING): Client legal name.
  * `tax_identification_number` (STRING): Tokenized IRS EIN / RFC / CNPJ.
  * `credit_limit_usd` (FLOAT64): Approved credit threshold.
  * `current_balance_usd` (FLOAT64): Real-time outstanding accounts receivable.
  * `payment_terms_days` (INTEGER): `NET_15`, `NET_30`, `PRE_PAID`.
  * `preferred_destination_ports` (ARRAY<STRING>): Default ports (e.g., `["5201 - Miami", "470 - CDMX"]`).
* **`voice_crm_activity_stream`**:
  * `activity_id` (STRING): Unique interaction log ID.
  * `customer_id` (STRING): Associated account.
  * `worker_id` (STRING): Account manager or dispatcher identifier.
  * `timestamp` (TIMESTAMP): Timestamp of interaction.
  * `interaction_channel` (STRING): `VOICE_MEMO`, `WHATSAPP_SUMMARY`, `PHONE_CALL`.
  * `raw_voice_transcript` (STRING): Gemini speech-to-text transcript.
  * `extracted_intent` (STRING): Gemini-extracted action items.
  * `sentiment_score` (FLOAT64): Client satisfaction sentiment analysis (-1.0 to +1.0).

---

### 6. Finance, Invoicing & Freight Audit (`ds_finance_billing`)
Automates invoice generation, 3-way vendor matching, and foreign tax withholding.

* **`accounts_receivable_invoices`**:
  * `invoice_number` (STRING): Formal invoice ID.
  * `shipment_id` (STRING): Associated container/declaration ID.
  * `customer_id` (STRING): Billing target.
  * `base_freight_rate_usd` (FLOAT64): Agreed line-haul charge.
  * `foreign_withholding_tax_deducted_usd` (FLOAT64): Non-resident tax withheld at source.
  * `net_receivable_amount_usd` (FLOAT64): Actual cash receivable after statutory tax.
  * `driver_detention_charge_usd` (FLOAT64): Auto-billed detention fee.
  * `chassis_split_fee_usd` (FLOAT64): Auto-billed chassis fee.
  * `total_invoice_amount_usd` (FLOAT64): Final sum.
  * `payment_status` (STRING): `GENERATED`, `SENT_VIA_EMAIL_WHATSAPP`, `SETTLED`.
* **`vendor_invoice_reconciliations`** *(SME Operational Discovery)*:
  * `vendor_invoice_id` (STRING): Incoming invoice number from 3rd party (drayman, chassis pool, terminal).
  * `matched_booking_id` (STRING): Associated ocean booking / container ID.
  * `vendor_name` (STRING): Vendor business name.
  * `contracted_rate_usd` (FLOAT64): Contractual tariff rate.
  * `billed_rate_usd` (FLOAT64): Billed amount on vendor invoice.
  * `variance_usd` (FLOAT64): `billed_rate - contracted_rate`.
  * `audit_status` (STRING): `AUTO_MATCHED_APPROVED`, `RATE_DISCREPANCY_FLAGGED`, `REJECTED_UNAUTHORIZED_ACCESSORIAL`.

---

## 🚀 Autonomous Services Powered by the BigQuery Data Mesh

| Service Name | BigQuery Input Streams | Autonomous Action Triggered |
| :--- | :--- | :--- |
| **1. Autonomous 24/7 Night-Watch Dispatcher** | `ds_fleet_telematics.vehicle_telemetry_live` | Replaces human night staff by silently monitoring truck progress along planned route, detecting unexpected stops or detours $>15\text{ mins}$, and sending scheduled 2-hour status reports directly to customers via WhatsApp/Email. |
| **2. Axle-Weight Bridge Formula Auditor** | `ds_fleet_telematics.axle_weights_and_load_balance` + `ds_customs_compliance.ref_bridge_formula_limits` | Audits weight distribution across steer, drive tandem, and trailer tandem axles before departure. Prevents driver fines and license point deductions by alerting loaders to shift cargo weight forward or backward. |
| **3. Non-Resident Tax Shield** | `ds_finance_billing` + `ds_customs_compliance.ref_non_resident_tax_withholdings` | Calculates foreign withholding tax (e.g. 20% in Central America) before issuing international freight invoices, ensuring foreign exporters are never blindsided by unexpected deductions. |
| **4. Tecún Umán Transload & DUCA-T Generator** | `ds_shipments_declarations.transload_border_declarations` | Automatically parses ocean manifests from Miami and generates unified multi-country DUCA-T declarations, eliminating 90% of manual data re-typing at Central American border crossings. |
| **5. 3-Way Vendor Freight Auditor** | `ds_finance_billing.vendor_invoice_reconciliations` | Matches incoming invoices from chassis pools, truckers, and lumpers to active booking IDs and contracts, auto-rejecting fabricated accessorials. |
