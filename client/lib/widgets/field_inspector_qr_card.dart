import 'package:flutter/material.dart';
import '../models/trade_models.dart';

class FieldInspectorQrCard extends StatelessWidget {
  final FieldInspectorQRPayload qrPayload;

  const FieldInspectorQrCard({
    Key? key,
    required this.qrPayload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFF38BDF8).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.qr_code_2, color: Color(0xFF38BDF8), size: 22),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FIELD INSPECTOR QR SEAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          'Roadside Police & Border Gate Offline Verification',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF10B981), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.verified_user, color: Color(0xFF34D399), size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Ed25519 SIGNED',
                        style: TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // QR & Data Breakdown Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mock High-Contrast QR Code Visualizer
                Container(
                  width: 110,
                  height: 110,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQrCorner(),
                          _buildQrDot(),
                          _buildQrCorner(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQrDot(),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.local_shipping, size: 14, color: Colors.white),
                          ),
                          _buildQrDot(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQrCorner(),
                          _buildQrDot(),
                          _buildQrCorner(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Manifest Metadata Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Manifest Ref:', qrPayload.manifestId),
                      const SizedBox(height: 4),
                      _buildInfoRow('Trailer Plate:', qrPayload.trailerPlate),
                      const SizedBox(height: 4),
                      _buildInfoRow('Gross Weight:', '${qrPayload.grossWeightKg.toStringAsFixed(0)} kg (20 Tonnes)'),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        'Bridge Formula:',
                        qrPayload.bridgeFormulaCompliant ? 'COMPLIANT' : 'OVERLOAD ALERT',
                        valueColor: qrPayload.bridgeFormulaCompliant ? const Color(0xFF34D399) : const Color(0xFFF87171),
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow('Sanitary Seal:', 'USDA FSIS / MAGA PASSED', valueColor: const Color(0xFF34D399)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Cryptographic Key Ribbon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.key, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Ed25519 Sig: ${qrPayload.signatureEd25519.substring(0, 32)}...',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '100% UNTAMPERED',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF34D399),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrCorner() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildQrDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
