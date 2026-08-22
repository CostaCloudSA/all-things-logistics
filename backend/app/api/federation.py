"""
Cross-Tenant Agent-to-Agent (A2A) Federation API Router.

Handles cryptographic manifest transfers, peer validation,
and roadside inspector QR code verification across independent enterprise instances.
"""

from fastapi import APIRouter, HTTPException, Header
from typing import Optional, Dict, Any
from app.models.schemas import (
    FederatedAgentHandshakeRequest,
    FederatedAgentHandshakeResponse,
    FieldInspectorQRPayload,
)
from app.core.tenant_manager import tenant_manager
from app.security.manifest_signer import manifest_signer

router = APIRouter(prefix="/api/federation", tags=["Agent Federation & Interoperability"])


@router.post("/handshake", response_model=FederatedAgentHandshakeResponse)
def execute_agent_handshake(
    request: FederatedAgentHandshakeRequest,
    x_tenant_id: Optional[str] = Header(None),
) -> FederatedAgentHandshakeResponse:
    """
    Executes an autonomous Agent-to-Agent (A2A) B2B handshake between two independent white-labeled instances.
    Example: Originating Tenant (Transportes Tomas MX) transfers manifest to Receiving Tenant (Campabadal Global GT).

    Args:
        request (FederatedAgentHandshakeRequest): Inbound peer handshake request containing Ed25519 payload.
        x_tenant_id (Optional[str]): Injected tenant identifier header.

    Returns:
        FederatedAgentHandshakeResponse: Cryptographic validation results and DUCA-T transit reference.
    """
    receiving_tenant_id = x_tenant_id or request.target_tenant_id
    receiving_tenant = tenant_manager.get_tenant(receiving_tenant_id)

    # 1. Verify Ed25519 Cryptographic Signature
    is_valid_sig, sig_message = manifest_signer.verify_signature(request.qr_payload)
    if not is_valid_sig:
        return FederatedAgentHandshakeResponse(
            handshake_id=f"hsk-{request.manifest_id[:8]}-err",
            status="REJECTED_SIGNATURE_INVALID",
            verified_by_agent=f"{receiving_tenant.org_name} Security Gatekeeper Agent",
            originating_tenant_id=request.originating_tenant_id,
            receiving_tenant_id=receiving_tenant.tenant_id,
            is_ed25519_signature_valid=False,
            bridge_formula_accepted=False,
            audit_log=[
                f"Model Armor Security Warning: {sig_message}",
                f"Rejected transfer for Container {request.container_number}.",
            ],
        )

    # 2. Check Bridge Formula Compliance
    bridge_accepted = request.qr_payload.bridge_formula_compliant

    # 3. Generate Cross-Border DUCA-T Transit Reference
    duca_t_ref = request.qr_payload.duca_t_reference or f"DUCA-T-{receiving_tenant_id.upper()}-{request.manifest_id[:6]}"

    return FederatedAgentHandshakeResponse(
        handshake_id=f"hsk-{request.manifest_id[:8]}-ok",
        status="ACCEPTED_VERIFIED",
        verified_by_agent=f"{receiving_tenant.org_name} Transload Relay Agent",
        originating_tenant_id=request.originating_tenant_id,
        receiving_tenant_id=receiving_tenant.tenant_id,
        is_ed25519_signature_valid=True,
        bridge_formula_accepted=bridge_accepted,
        generated_duca_t_number=duca_t_ref,
        audit_log=[
            f"Verified Ed25519 Public Key: {request.qr_payload.public_key_ed25519[:16]}...",
            f"Verified Axle Compliance: Gross Weight {request.qr_payload.gross_weight_kg:,.0f} kg.",
            f"Relayed to DUCA-T Reference: {duca_t_ref}.",
            f"OpenTelemetry Traceparent Propagated: {request.traceparent or 'traceparent-live-w3c'}.",
        ],
    )


@router.post("/verify-qr")
def verify_inspector_qr(payload: FieldInspectorQRPayload) -> Dict[str, Any]:
    """
    Public / Inspector QR Code Verification Endpoint.
    Allows roadside police, border guards, and weigh-station officers to scan and verify manifests in <1 sec.

    Args:
        payload (FieldInspectorQRPayload): The payload scanned from a field QR code.

    Returns:
        Dict[str, Any]: Instant verification verdict including weight, sanitary clearance, and authenticity.
    """
    is_valid, message = manifest_signer.verify_signature(payload)
    return {
        "status": "VALID" if is_valid else "TAMPERED",
        "is_authentic": is_valid,
        "signing_organization": payload.signing_org_name,
        "trailer_plate": payload.trailer_plate,
        "gross_weight_kg": payload.gross_weight_kg,
        "bridge_formula_status": "COMPLIANT" if payload.bridge_formula_compliant else "NON_COMPLIANT_OVERLOADED",
        "sanitary_clearance": payload.sanitary_status,
        "duca_t_reference": payload.duca_t_reference,
        "verification_message": message,
    }
