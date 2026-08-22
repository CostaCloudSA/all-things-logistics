/// Live OpenTelemetry Distributed Tracing Sidebar.
/// Displays real-time agent execution spans, model latency, Model Armor sanitization state,
/// and BigQuery deterministic grounding telemetry.

import 'package:flutter/material.dart';
import '../models/trade_models.dart';
import '../services/api_service.dart';

class TelemetrySidebar extends StatelessWidget {
  const TelemetrySidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF070B14),
        border: Border(left: BorderSide(color: Color(0xFF1E293B), width: 1.5)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.analytics_outlined, color: Color(0xFF38BDF8), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'FORTIFIED FLEET TELEMETRY',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'OpenTelemetry & BigQuery Mesh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Security & Model Armor Status Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                _buildStatusRow(Icons.shield_outlined, 'Model Armor (Gemma)', 'Active & Redacting', Colors.greenAccent),
                const Divider(color: Color(0xFF1E293B), height: 16),
                _buildStatusRow(Icons.account_tree_outlined, 'Deterministic Grounding', 'BigQuery ds_customs', Colors.blueAccent),
                const Divider(color: Color(0xFF1E293B), height: 16),
                _buildStatusRow(Icons.speed, 'Engine', 'Gemini 3.7 Flash', Colors.purpleAccent),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'ACTIVE AGENT EXECUTION SPANS',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),

          // Live Spans Stream
          Expanded(
            child: StreamBuilder<List<TelemetrySpanModel>>(
              stream: apiService.telemetryStream,
              builder: (context, snapshot) {
                final spans = snapshot.data ?? [];
                if (spans.isEmpty) {
                  return const Center(
                    child: Text(
                      'Awaiting trade action...\nTap a smart chip or send prompt',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF475569), fontSize: 13),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: spans.length,
                  itemBuilder: (context, index) {
                    final span = spans[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                span.name,
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  fontFamily: 'JetBrains Mono',
                                ),
                              ),
                              Text(
                                '${span.latencyMs}ms',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                  fontFamily: 'JetBrains Mono',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: span.attributes.entries.map((e) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF070B14),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${e.key}: ${e.value}',
                                  style: const TextStyle(
                                    color: Color(0xFFCBD5E1),
                                    fontSize: 11,
                                    fontFamily: 'JetBrains Mono',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(IconData icon, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13)),
          ],
        ),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }
}
