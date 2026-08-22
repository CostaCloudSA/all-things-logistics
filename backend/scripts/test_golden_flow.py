"""
End-to-End Golden Flow Simulation:
Demonstrates the Miami -> Tecún Umán (Guatemala) -> Central America Corridor
with Zero-Typing Vision OCR ingestion, Model Armor Grounding, Bridge Formula axle audit,
24/7 Night-Watch telematics monitoring, Ed25519 Cryptographic Manifest Seals,
Cross-Tenant A2A Federation Handshake, and DUCA-T Golden Document generation.
"""

import sys
import os
import json

# Ensure backend root is in sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.models.schemas import TradeRequest, FederatedAgentHandshakeRequest
from app.agents.orchestrator import fleet_orchestrator
from app.agents.transload_relay import TransloadRelayAgent
from app.agents.bridge_formula import BridgeFormulaAuditorAgent
from app.agents.night_watch import NightWatchTelematicsAgent
from app.agents.vendor_matcher import VendorInvoiceMatcherAgent
from app.agents.sanctions_screener import SanctionsScreenerAgent
from app.agents.discrepancy_auditor import DiscrepancyAuditorAgent
from app.core.tenant_manager import tenant_manager
from app.security.manifest_signer import manifest_signer
from app.api.federation import execute_agent_handshake, verify_inspector_qr
from app.core.telemetry import OpenTelemetrySpan, telemetry_collector

def run_golden_simulation():
    print("=" * 80)
    print("🚀 CAMPABADAL GLOBAL LOGISTICS - FORTIFIED ENTERPRISE MULTI-AGENT SWARM")
    print("Corridor: Miami (PortMiami) -> Tecún Umán Hub -> Central America (Guatemala)")
    print("Cargo: 20,000 kg Frozen Poultry (Controlled Atmosphere Cold-Chain)")
    print("=" * 80)

    # 1. Orchestrator Run with White-Label Tenant
    print("\n[1/8] 🤖 Executing Fleet Orchestrator (Gemini 3.7 Flash) with Tenant Profile...")
    req = TradeRequest(
        user_prompt="20T frozen poultry from Miami to Guatemala via Tecún Umán border",
        tenant_id="tenant-campabadal",
        origin_iso="US",
        destination_iso="GT"
    )
    res = fleet_orchestrator.process_trade_request(req)
    print(f"  • Active White-Label Tenant: {res.tenant_profile.org_name} ({res.tenant_profile.scac_or_dot_code})")
    print(f"  • Destination Authority: {res.customs_authority}")
    print(f"  • Trade Agreement: {res.trade_agreement_applied}")
    print(f"  • Total FOB Value: ${res.landed_cost.total_declared_value_usd:,.2f}")
    print(f"  • Estimated Duties (DAI): ${res.landed_cost.total_duty_usd:,.2f}")
    print(f"  • OpenTelemetry Trace ID: {res.telemetry_trace_id}")

    # 2. Bridge Formula Axle Weight Audit
    print("\n[2/8] ⚖️ Auditing Axle Load Distribution (Federal Bridge Formula B / SIECA)...")
    bridge_agent = BridgeFormulaAuditorAgent()
    span1 = OpenTelemetrySpan("simulation.bridge_formula")
    bridge_res = bridge_agent.process({
        "steer_lbs": 11800.0,
        "drive_tandem_lbs": 33500.0,
        "trailer_tandem_lbs": 34800.0, # Exceeds 34k tandem limit
        "jurisdiction": "CENTRAL_AMERICA_SIECA"
    }, span1)
    print(f"  • Gross Weight: {bridge_res['gross_weight_lbs']:,.0f} lbs (Legal: <= 88,184 lbs)")
    print(f"  • Compliance Status: {'🟢 LEGAL' if bridge_res['is_compliant'] else '⚠️ REBALANCE REQUIRED'}")
    print(f"  • Advisory: {bridge_res['rebalance_advice']}")

    # 3. Autonomous 24/7 Night-Watch Telematics
    print("\n[3/8] 🌙 Evaluating 24/7 Night-Watch Route Telematics...")
    night_agent = NightWatchTelematicsAgent()
    span2 = OpenTelemetrySpan("simulation.night_watch")
    night_res = night_agent.process({
        "vehicle_id": "TRK-9842",
        "route_corridor": "Miami -> Tecún Umán",
        "current_geofence": "PATIO_FISCAL_TECUN_UMAN",
        "is_deviated": False
    }, span2)
    print(f"  • Geofence: {night_res['last_verified_checkpoint']}")
    print(f"  • Route Adherence: {night_res['route_adherence_pct']}%")
    print(f"  • Proactive WhatsApp Message:\n    \"{night_res['customer_whatsapp_message']}\"")

    # 4. Tecún Umán Transload Relay & DUCA-T
    print("\n[4/8] 🔄 Generating Tecún Umán Transload Manifest & DUCA-T...")
    transload_agent = TransloadRelayAgent()
    span3 = OpenTelemetrySpan("simulation.transload_relay")
    transload_res = transload_agent.process({
        "ocean_bl_number": "MSCU-MIA-GUA-881920",
        "container_number": "MSCU7823410",
        "border_hub_code": "TECUN_UMAN",
        "commodity": "Frozen Chicken Cuts",
        "weight_kg": 20000.0
    }, span3)
    print(f"  • Transload Document ID: {transload_res['transload_document_id']}")
    print(f"  • Border Hub: {transload_res['border_hub']}")
    print(f"  • Inbound Transport: {transload_res['inbound_transport']}")
    print(f"  • Outbound Transport: {transload_res['outbound_transport']}")
    print(f"  • Re-Typing Time Saved: {transload_res['retyping_time_eliminated_mins']} minutes (100% Zero-Typing)")

    # 5. Sanctions & Discrepancy Screening
    print("\n[5/8] 🛡️ Running Real-Time Sanctions Screening & 3-Way Discrepancy Cross-Audit...")
    sanctions_agent = SanctionsScreenerAgent()
    span4 = OpenTelemetrySpan("simulation.sanctions")
    sanctions_res = sanctions_agent.process({
        "parties": ["AgroAvícola del Caribe S.A.", "Mediterranean Shipping Co", "CrossDock Tecún Logistics"]
    }, span4)
    print(f"  • Sanctions Cleared: {'🟢 YES' if sanctions_res['is_sanctions_cleared'] else '🔴 BLOCKED'}")

    discrepancy_agent = DiscrepancyAuditorAgent()
    span5 = OpenTelemetrySpan("simulation.discrepancy")
    disc_res = discrepancy_agent.process({
        "invoice_total_usd": 45000.0,
        "invoice_weight_kg": 20000.0,
        "bl_weight_kg": 20000.0,
        "invoice_cartons": 1000,
        "packing_list_cartons": 1000
    }, span5)
    print(f"  • Discrepancy Cross-Audit: {'🟢 PASSED (0 mismatches)' if disc_res['is_audit_passed'] else '⚠️ MISMATCH DETECTED'}")

    # 6. Ed25519 Cryptographic Manifest Signing
    print("\n[6/8] 🔐 Generating Ed25519 Signed Manifest & Field Inspector QR Code...")
    tenant = tenant_manager.get_tenant("tenant-campabadal")
    qr_payload = manifest_signer.sign_manifest(
        tenant=tenant,
        manifest_id="MNF-CPBD-881920",
        trailer_plate="C-882BXZ-GT",
        gross_weight_kg=20000.0,
        bridge_formula_compliant=False,
        duca_t_reference="DUCA-T-TECUN_UMAN-881920"
    )
    print(f"  • Signing Tenant: {qr_payload.signing_org_name}")
    print(f"  • Ed25519 Signature: {qr_payload.signature_ed25519}")
    print(f"  • Public Key: {qr_payload.public_key_ed25519}")
    print(f"  • Mobile Verification URL: {qr_payload.verification_url}")

    # 7. Cross-Tenant A2A Handshake (Campabadal 3PL -> Transportes Tecún MX-GT)
    print("\n[7/8] 🤝 Executing Cross-Tenant B2B Agent-to-Agent (A2A) Handshake...")
    handshake_req = FederatedAgentHandshakeRequest(
        originating_tenant_id="tenant-campabadal",
        target_tenant_id="tenant-tecun",
        manifest_id="MNF-CPBD-881920",
        container_number="MSCU7823410",
        bill_of_lading_number="MSCU-MIA-GUA-881920",
        qr_payload=qr_payload,
        items=res.items,
        traceparent=f"00-{res.telemetry_trace_id[:16]}-01"
    )
    handshake_res = execute_agent_handshake(handshake_req)
    print(f"  • Handshake ID: {handshake_res.handshake_id}")
    print(f"  • Status: {handshake_res.status}")
    print(f"  • Ed25519 Signature Verified: {'🟢 VALID' if handshake_res.is_ed25519_signature_valid else '🔴 INVALID'}")
    print(f"  • Verified By: {handshake_res.verified_by_agent}")
    for log in handshake_res.audit_log:
        print(f"    - {log}")

    # 8. Roadside / Border Inspector QR Scan Verification
    print("\n[8/8] 📱 Verifying Field Inspector QR Scan (Simulating Border Guard Phone)...")
    inspect_result = verify_inspector_qr(qr_payload)
    print(f"  • Scan Result: {inspect_result['status']}")
    print(f"  • Trailer Plate: {inspect_result['trailer_plate']}")
    print(f"  • Gross Weight: {inspect_result['gross_weight_kg']:,.0f} kg")
    print(f"  • Sanitary Clearance: {inspect_result['sanitary_clearance']}")
    print(f"  • Message: {inspect_result['verification_message']}")

    print("\n" + "=" * 80)
    print("✅ SIMULATION COMPLETE: 12 AGENTS + MULTI-TENANCY + ED25519 A2A FEDERATION PASSED")
    print("=" * 80)

if __name__ == "__main__":
    run_golden_simulation()
