import 'package:flutter/material.dart';

class NightWatchStatusCard extends StatelessWidget {
  final String status;
  final String geofence;
  final double adherencePct;
  final String whatsappMessage;

  const NightWatchStatusCard({
    Key? key,
    this.status = 'ACTIVE_NORMAL',
    this.geofence = 'Patio Fiscal Tecún Umán (Guatemala)',
    this.adherencePct = 99.2,
    this.whatsappMessage = '🟢 *Night-Watch Update*: TRK-9842 verified at Patio Fiscal Tecún Umán. Route adherence: 99.2%. ETA: 14:30 UTC.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6366F1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
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
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.nightlight_round, color: Color(0xFF818CF8), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AUTONOMOUS 24/7 NIGHT-WATCH',
                        style: TextStyle(
                          color: Color(0xFF818CF8),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Route Guardian & Dispatcher',
                        style: TextStyle(
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
                  color: Colors.indigoAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.radar, size: 12, color: Colors.indigoAccent),
                    SizedBox(width: 4),
                    Text(
                      'LIVE TRACK',
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Metadata Details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LAST GEOFENCE PING', style: TextStyle(color: Color(0xFF64748B), fontSize: 9.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(geofence, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('ROUTE ADHERENCE', style: TextStyle(color: Color(0xFF64748B), fontSize: 9.5, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    '${adherencePct.toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'JetBrains Mono'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Simulated WhatsApp Push Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF22C55E)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Proactive Client WhatsApp Push (Every 2h)',
                        style: TextStyle(color: Color(0xFF22C55E), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        whatsappMessage,
                        style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
