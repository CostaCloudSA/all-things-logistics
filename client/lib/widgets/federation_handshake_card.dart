/// B2B Agent-to-Agent (A2A) Federation Handshake Card.
/// Visualizes cross-tenant cryptographic manifest transfer between Campabadal 3PL,
/// Transportes Tomas, and Agroexport Costa Rica with W3C distributed trace propagation.

import 'package:flutter/material.dart';
import '../models/trade_models.dart';

class FederationHandshakeCard extends StatelessWidget {
  final FederatedAgentHandshakeResponse handshake;

  const FederationHandshakeCard({
    Key? key,
    required this.handshake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Resolve dynamic colors based on tenant names
    final origTenantName = handshake.originatingTenantId.contains('tomas')
        ? 'Transportes Tomas'
        : handshake.originatingTenantId.contains('agroexport')
            ? 'Agroexport CR'
            : 'Campabadal 3PL';

    final origColor = handshake.originatingTenantId.contains('tomas')
        ? const Color(0xFFDC2626) // Red
        : handshake.originatingTenantId.contains('agroexport')
            ? const Color(0xFF059669) // Green
            : const Color(0xFF0284C7); // Blue

    final recvTenantName = handshake.receivingTenantId.contains('tomas')
        ? 'Transportes Tomas'
        : handshake.receivingTenantId.contains('agroexport')
            ? 'Agroexport CR'
            : 'Campabadal 3PL';

    final recvColor = handshake.receivingTenantId.contains('tomas')
        ? const Color(0xFFDC2626)
        : handshake.receivingTenantId.contains('agroexport')
            ? const Color(0xFF059669)
            : const Color(0xFF0284C7);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFF818CF8).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        color: const Color(0xFF818CF8).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.sync_alt, color: Color(0xFF818CF8), size: 22),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'B2B AGENT-TO-AGENT (A2A) FEDERATION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          'Autonomous Cross-Tenant Transload Handshake',
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
                      Icon(Icons.check_circle, color: Color(0xFF34D399), size: 12),
                      SizedBox(width: 4),
                      Text(
                        'RELAY VERIFIED',
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
            const SizedBox(height: 14),

            // Flow Diagram Bar (Origin Tenant -> Ed25519 Handshake -> Receiving Tenant)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNodePill(origTenantName, origColor),
                  const Icon(Icons.arrow_forward, color: Color(0xFF818CF8), size: 16),
                  _buildNodePill('Ed25519 A2A Protocol', const Color(0xFF818CF8)),
                  const Icon(Icons.arrow_forward, color: Color(0xFF818CF8), size: 16),
                  _buildNodePill(recvTenantName, recvColor),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Audit Trail items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: handshake.auditLog.map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.chevron_right, size: 14, color: Color(0xFF818CF8)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        log,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodePill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
