class SmartChip {
  final String id;
  final String label;
  final String category;
  final String value;
  final String? icon;

  SmartChip({
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

  TradeItem({
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

class LandedCostSummary {
  final double totalDeclaredValueUsd;
  final double totalDutyUsd;
  final double totalVatUsd;
  final double merchandiseProcessingFeeUsd;
  final double harborMaintenanceFeeUsd;
  final double totalLandedCostUsd;
  final bool isDeMinimisExempt;

  LandedCostSummary({
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

class TradeResponse {
  final String sessionId;
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
  final String? telemetryTraceId;
  final List<String> auditNotes;

  TradeResponse({
    required this.sessionId,
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
    this.telemetryTraceId,
    required this.auditNotes,
  });

  factory TradeResponse.fromJson(Map<String, dynamic> json) {
    return TradeResponse(
      sessionId: json['session_id'] ?? '',
      status: json['status'] ?? 'PROCESSED',
      originIso: json['origin_iso'] ?? 'CO',
      destinationIso: json['destination_iso'] ?? 'US',
      originCountry: json['origin_country'] ?? 'Colombia',
      destinationCountry: json['destination_country'] ?? 'United States',
      customsAuthority: json['customs_authority'] ?? 'U.S. Customs and Border Protection',
      tradeAgreementApplied: json['trade_agreement_applied'],
      items: (json['items'] as List?)?.map((e) => TradeItem.fromJson(e)).toList() ?? [],
      landedCost: LandedCostSummary.fromJson(json['landed_cost'] ?? {}),
      smartChips: (json['smart_chips'] as List?)?.map((e) => SmartChip.fromJson(e)).toList() ?? [],
      mandatoryPermits: (json['mandatory_permits'] as List?)?.map((e) => e.toString()).toList() ?? [],
      generatedGoldenDocument: json['generated_golden_document'] as Map<String, dynamic>?,
      telemetryTraceId: json['telemetry_trace_id'],
      auditNotes: (json['audit_notes'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class TelemetrySpanModel {
  final String name;
  final String traceId;
  final String spanId;
  final double latencyMs;
  final Map<String, dynamic> attributes;

  TelemetrySpanModel({
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
