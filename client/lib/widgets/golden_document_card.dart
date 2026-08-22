/// Golden Customs Document Card.
/// Formats and displays generated official international trade declarations
/// (DUCA-T, USMCA COO, CBP 7501, SAT Pedimento) with landed cost and sanitary permit matrices.

import 'package:flutter/material.dart';
import '../models/trade_models.dart';

class GoldenDocumentCard extends StatelessWidget {
  final TradeResponse response;

  const GoldenDocumentCard({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doc = response.generatedGoldenDocument ?? {};
    final docType = doc['document_type'] ?? 'CUSTOMS_DECLARATION';
    final formTitle = doc['form_title'] ?? 'Official Customs Declaration';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.description_outlined, color: Color(0xFF60A5FA), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        docType,
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        formTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                ),
                child: const Text(
                  'READY',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: 12),

          // Core Trade Metadata Grid
          Row(
            children: [
              _buildMetaCell('CUSTOMS REGIME', doc['customs_regime'] ?? '80 - Tránsito Terrestre'),
              _buildMetaCell('ORIGIN / DISPATCH', '${response.originCountry} (${response.originIso})'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetaCell('DECLARANT ID', doc['declarant_carrier_id'] ?? response.tenantProfile?.scacOrDotCode ?? 'CPBD'),
              _buildMetaCell('DECLARATION #', doc['declaration_number'] ?? doc['entry_number'] ?? 'DUCA-T-881920-GT'),
            ],
          ),

          const SizedBox(height: 16),

          // Landed Cost & Tariff Math Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF070B14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: [
                _buildCostRow('Declared Value (FOB):', '\$${response.landedCost.totalDeclaredValueUsd.toStringAsFixed(2)}'),
                const SizedBox(height: 6),
                _buildCostRow(
                  'Ad Valorem Duty (${response.items.isNotEmpty ? (response.items.first.adValoremDutyRate * 100).toStringAsFixed(1) : "0"}%):',
                  '\$${response.landedCost.totalDutyUsd.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 6),
                _buildCostRow('VAT / Tax (${response.destinationIso}):', '\$${response.landedCost.totalVatUsd.toStringAsFixed(2)}'),
                const Divider(color: Color(0xFF334155), height: 16),
                _buildCostRow(
                  'TOTAL ESTIMATED DUTIES & TAXES:',
                  '\$${response.landedCost.totalLandedCostUsd.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Mandatory Sanitary Permits
          if (response.mandatoryPermits.isNotEmpty) ...[
            const Text(
              'MANDATORY HEALTH & PHYTOSANITARY FILINGS',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            ...response.mandatoryPermits.map((permit) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.verified, size: 14, color: Colors.amberAccent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        permit,
                        style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
          ],

          // Transmit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Transmit Declaration to Customs ACE / SAT', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Golden Document Transmitted Successfully to Customs EDI Portal!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCell(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCostRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? Colors.white : const Color(0xFF94A3B8),
            fontSize: isTotal ? 13 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? const Color(0xFF38BDF8) : Colors.white,
            fontSize: isTotal ? 14 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontFamily: 'JetBrains Mono',
          ),
        ),
      ],
    );
  }
}
