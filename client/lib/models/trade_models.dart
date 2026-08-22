/// Data models for Campabadal Global Logistics.
/// Contains definitions for White-Label Tenant Profiles, Smart Chips,
/// Trade Items, Landed Cost summaries, Ed25519 QR seals, and A2A Handshakes.

/// Represents an enterprise tenant profile with corporate branding and Ed25519 credentials.
class TenantProfile {
  final String tenantId;
  final String orgName;
  final String orgType;
  final String tagline;
  final String brandColorHex;
  final String accentColorHex;
  final String logoIcon;
  final String scacOrDotCode;
  final String taxIdentifier;
  final String publicKeyEd25519Hex;
  final String defaultOriginIso;
  final String defaultDestinationIso;

  const TenantProfile({
    required this.tenantId,
    required this.orgName,
    required this.orgType,
    required this.tagline,
    required this.brandColorHex,
    required this.accentColorHex,
    required this.logoIcon,
    required this.scacOrDotCode,
    required this.taxIdentifier,
    required this.publicKeyEd25519Hex,
    required this.defaultOriginIso,
    required this.defaultDestinationIso,
  });

  factory TenantProfile.fromJson(Map<String, dynamic> json) {
    return TenantProfile(
      tenantId: json['tenant_id'] ?? 'tenant-campabadal',
      orgName: json['org_name'] ?? 'Campabadal Global Logistics',
      orgType: json['org_type'] ?? 'MULTINATIONAL_FORWARDER',
      tagline: json['tagline'] ?? '',
      brandColorHex: json['brand_color_hex'] ?? '#0284C7',
      accentColorHex: json['accent_color_hex'] ?? '#38BDF8',
      logoIcon: json['logo_icon'] ?? 'public',
      scacOrDotCode: json['scac_or_dot_code'] ?? 'CPBD',
      taxIdentifier: json['tax_identifier'] ?? '',
      publicKeyEd25519Hex: json['public_key_ed25519_hex'] ?? '',
      defaultOriginIso: json['default_origin_iso'] ?? 'US',
      defaultDestinationIso: json['default_destination_iso'] ?? 'GT',
    );
  }
}

/// Represents a 1-touch guided action chip for deskless zero-keyboard operator workflows.
class SmartChip {
  final String id;
  final String label;
  final String category;
  final String value;
  final String? icon;

  const SmartChip({
    required this.id,
    required this.label,
    required this.category,
    required this.value,
    this.icon,
  });

  factory SmartChip.fromJson(Map<String, dynamic> json) {
    return SmartChip(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      category: json['category'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'],
    );
  }
}

/// Represents a single customs line item with HS classification and duty breakdown.
class TradeItem {
  final String itemId;
  final String rawDescription;
  final String? refinedDescription;
  final String? hsCode;
  final double hsCodeConfidence;
  final double quantity;
  final String unit;
  final double unitPriceUsd;
  final double totalDeclaredValueUsd;
  final double adValoremDutyRate;
  final double calculatedDutyUsd;
  final double vatRate;
  final double calculatedVatUsd;
  final bool requiresSanitaryPermit;
  final List<String> sanitaryAuthorities;
  final List<String> sanitaryPermitsRequired;

  const TradeItem({
    required this.itemId,
    required this.rawDescription,
    this.refinedDescription,
    this.hsCode,
    this.hsCodeConfidence = 0.0,
    this.quantity = 1.0,
    this.unit = 'kg',
    this.unitPriceUsd = 0.0,
    this.totalDeclaredValueUsd = 0.0,
    this.adValoremDutyRate = 0.0,
    this.calculatedDutyUsd = 0.0,
    this.vatRate = 0.0,
    this.calculatedVatUsd = 0.0,
    this.requiresSanitaryPermit = false,
    this.sanitaryAuthorities = const [],
    this.sanitaryPermitsRequired = const [],
  });

  factory TradeItem.fromJson(Map<String, dynamic> json) {
    return TradeItem(
      itemId: json['item_id'] ?? '',
      rawDescription: json['raw_description'] ?? '',
      refinedDescription: json['refined_description'],
      hsCode: json['hs_code'],
      hsCodeConfidence: (json['hs_code_confidence'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] ?? 'kg',
      unitPriceUsd: (json['unit_price_usd'] as num?)?.toDouble() ?? 0.0,
      totalDeclaredValueUsd: (json['total_declared_value_usd'] as num?)?.toDouble() ?? 0.0,
      adValoremDutyRate: (json['ad_valorem_duty_rate'] as num?)?.toDouble() ?? 0.0,
      calculatedDutyUsd: (json['calculated_duty_usd'] as num?)?.toDouble() ?? 0.0,
      vatRate: (json['vat_rate'] as num?)?.toDouble() ?? 0.0,
      calculatedVatUsd: (json['calculated_vat_usd'] as num?)?.toDouble() ?? 0.0,
      requiresSanitaryPermit: json['requires_sanitary_permit'] ?? false,
      sanitaryAuthorities: (json['sanitary_authorities'] as List?)?.map((e) => e.toString()).toList() ?? [],
      sanitaryPermitsRequired: (json['sanitary_permits_required'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

/// Summarizes total landed costs including CIF/FOB valuation, duty, VAT, and processing fees.
class LandedCostSummary {
  final double totalDeclaredValueUsd;
  final double totalDutyUsd;
  final double totalVatUsd;
  final double merchandiseProcessingFeeUsd;
  final double harborMaintenanceFeeUsd;
  final double totalLandedCostUsd;
  final bool isDeMinimisExempt;

  const LandedCostSummary({
    this.totalDeclaredValueUsd = 0.0,
    this.totalDutyUsd = 0.0,
    this.totalVatUsd = 0.0,
    this.merchandiseProcessingFeeUsd = 0.0,
    this.harborMaintenanceFeeUsd = 0.0,
    this.totalLandedCostUsd = 0.0,
    this.isDeMinimisExempt = false,
  });

  factory LandedCostSummary.fromJson(Map<String, dynamic> json) {
    return LandedCostSummary(
      totalDeclaredValueUsd: (json['total_declared_value_usd'] as num?)?.toDouble() ?? 0.0,
      totalDutyUsd: (json['total_duty_usd'] as num?)?.toDouble() ?? 0.0,
      totalVatUsd: (json['total_vat_usd'] as num?)?.toDouble() ?? 0.0,
      merchandiseProcessingFeeUsd: (json['merchandise_processing_fee_usd'] as num?)?.toDouble() ?? 0.0,
      harborMaintenanceFeeUsd: (json['harbor_maintenance_fee_usd'] as num?)?.toDouble() ?? 0.0,
      totalLandedCostUsd: (json['total_landed_cost_usd'] as num?)?.toDouble() ?? 0.0,
      isDeMinimisExempt: json['is_de_minimis_exempt'] ?? false,
    );
  }
}

/// Represents the cryptographic Ed25519 payload encoded into offline roadside inspection QR codes.
class FieldInspectorQRPayload {
  final String manifestId;
  final String signingTenantId;
  final String signingOrgName;
  final String signatureEd25519;
  final String publicKeyEd25519;
  final String trailerPlate;
  final double grossWeightKg;
  final bool bridgeFormulaCompliant;
  final String ducaTReference;
  final String sanitaryStatus;
  final String timestampUtc;
  final String verificationUrl;

  const FieldInspectorQRPayload({
    required this.manifestId,
    required this.signingTenantId,
    required this.signingOrgName,
    required this.signatureEd25519,
    required this.publicKeyEd25519,
    required this.trailerPlate,
    required this.grossWeightKg,
    required this.bridgeFormulaCompliant,
    required this.ducaTReference,
    required this.sanitaryStatus,
    required this.timestampUtc,
    required this.verificationUrl,
  });

  factory FieldInspectorQRPayload.fromJson(Map<String, dynamic> json) {
    return FieldInspectorQRPayload(
      manifestId: json['manifest_id'] ?? '',
      signingTenantId: json['signing_tenant_id'] ?? '',
      signingOrgName: json['signing_org_name'] ?? '',
      signatureEd25519: json['signature_ed25519'] ?? '',
      publicKeyEd25519: json['public_key_ed25519'] ?? '',
      trailerPlate: json['trailer_plate'] ?? 'C-882BXZ-GT',
      grossWeightKg: (json['gross_weight_kg'] as num?)?.toDouble() ?? 20000.0,
      bridgeFormulaCompliant: json['bridge_formula_compliant'] ?? false,
      ducaTReference: json['duca_t_reference'] ?? '',
      sanitaryStatus: json['sanitary_status'] ?? 'INSPECTED_USDA_APHIS_PASSED',
      timestampUtc: json['timestamp_utc'] ?? '',
      verificationUrl: json['verification_url'] ?? '',
    );
  }
}

/// Represents the autonomous B2B Agent-to-Agent (A2A) handshake result between two independent logistics clouds.
class FederatedAgentHandshakeResponse {
  final String handshakeId;
  final String status;
  final String verifiedByAgent;
  final String originatingTenantId;
  final String receivingTenantId;
  final bool isEd25519SignatureValid;
  final bool bridgeFormulaAccepted;
  final String? generatedDucaTNumber;
  final List<String> auditLog;

  const FederatedAgentHandshakeResponse({
    required this.handshakeId,
    required this.status,
    required this.verifiedByAgent,
    required this.originatingTenantId,
    required this.receivingTenantId,
    required this.isEd25519SignatureValid,
    required this.bridgeFormulaAccepted,
    this.generatedDucaTNumber,
    required this.auditLog,
  });

  factory FederatedAgentHandshakeResponse.fromJson(Map<String, dynamic> json) {
    return FederatedAgentHandshakeResponse(
      handshakeId: json['handshake_id'] ?? '',
      status: json['status'] ?? 'ACCEPTED_VERIFIED',
      verifiedByAgent: json['verified_by_agent'] ?? '',
      originatingTenantId: json['originating_tenant_id'] ?? '',
      receivingTenantId: json['receiving_tenant_id'] ?? '',
      isEd25519SignatureValid: json['is_ed25519_signature_valid'] ?? true,
      bridgeFormulaAccepted: json['bridge_formula_accepted'] ?? true,
      generatedDucaTNumber: json['generated_duca_t_number'],
      auditLog: (json['audit_log'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

/// Comprehensive trade compliance processing response from the Fleet Orchestrator.
class TradeResponse {
  final String sessionId;
  final String tenantId;
  final TenantProfile? tenantProfile;
  final String status;
  final String originIso;
  final String destinationIso;
  final String originCountry;
  final String destinationCountry;
  final String customsAuthority;
  final String? tradeAgreementApplied;
  final List<TradeItem> items;
  final LandedCostSummary landedCost;
  final List<SmartChip> smartChips;
  final List<String> mandatoryPermits;
  final Map<String, dynamic>? generatedGoldenDocument;
  final FieldInspectorQRPayload? fieldInspectorQr;
  final FederatedAgentHandshakeResponse? federatedHandshake;
  final String? telemetryTraceId;
  final List<String> auditNotes;

  const TradeResponse({
    required this.sessionId,
    this.tenantId = 'tenant-campabadal',
    this.tenantProfile,
    required this.status,
    required this.originIso,
    required this.destinationIso,
    required this.originCountry,
    required this.destinationCountry,
    required this.customsAuthority,
    this.tradeAgreementApplied,
    required this.items,
    required this.landedCost,
    required this.smartChips,
    required this.mandatoryPermits,
    this.generatedGoldenDocument,
    this.fieldInspectorQr,
    this.federatedHandshake,
    this.telemetryTraceId,
    required this.auditNotes,
  });

  factory TradeResponse.fromJson(Map<String, dynamic> json) {
    return TradeResponse(
      sessionId: json['session_id'] ?? '',
      tenantId: json['tenant_id'] ?? 'tenant-campabadal',
      tenantProfile: json['tenant_profile'] != null
          ? TenantProfile.fromJson(json['tenant_profile'])
          : null,
      status: json['status'] ?? 'PROCESSED',
      originIso: json['origin_iso'] ?? 'US',
      destinationIso: json['destination_iso'] ?? 'GT',
      originCountry: json['origin_country'] ?? 'United States',
      destinationCountry: json['destination_country'] ?? 'Guatemala',
      customsAuthority: json['customs_authority'] ?? 'Superintendencia de Administración Tributaria (SAT)',
      tradeAgreementApplied: json['trade_agreement_applied'],
      items: (json['items'] as List?)?.map((e) => TradeItem.fromJson(e)).toList() ?? [],
      landedCost: LandedCostSummary.fromJson(json['landed_cost'] ?? {}),
      smartChips: (json['smart_chips'] as List?)?.map((e) => SmartChip.fromJson(e)).toList() ?? [],
      mandatoryPermits: (json['mandatory_permits'] as List?)?.map((e) => e.toString()).toList() ?? [],
      generatedGoldenDocument: json['generated_golden_document'] as Map<String, dynamic>?,
      fieldInspectorQr: json['field_inspector_qr'] != null
          ? FieldInspectorQRPayload.fromJson(json['field_inspector_qr'])
          : null,
      federatedHandshake: json['federated_handshake'] != null
          ? FederatedAgentHandshakeResponse.fromJson(json['federated_handshake'])
          : null,
      telemetryTraceId: json['telemetry_trace_id'],
      auditNotes: (json['audit_notes'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

/// Represents an OpenTelemetry trace execution span for live telemetry graphs.
class TelemetrySpanModel {
  final String name;
  final String traceId;
  final String spanId;
  final double latencyMs;
  final Map<String, dynamic> attributes;

  const TelemetrySpanModel({
    required this.name,
    required this.traceId,
    required this.spanId,
    required this.latencyMs,
    required this.attributes,
  });

  factory TelemetrySpanModel.fromJson(Map<String, dynamic> json) {
    return TelemetrySpanModel(
      name: json['name'] ?? '',
      traceId: json['trace_id'] ?? '',
      spanId: json['span_id'] ?? '',
      latencyMs: (json['latency_ms'] as num?)?.toDouble() ?? 0.0,
      attributes: json['attributes'] as Map<String, dynamic>? ?? {},
    );
  }
}
