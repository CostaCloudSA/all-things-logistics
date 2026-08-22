import 'package:flutter/material.dart';

class AxleWeightCard extends StatelessWidget {
  final double steerLbs;
  final double driveTandemLbs;
  final double trailerTandemLbs;
  final double grossWeightLbs;
  final bool isCompliant;
  final String advice;

  const AxleWeightCard({
    Key? key,
    this.steerLbs = 11800.0,
    this.driveTandemLbs = 33500.0,
    this.trailerTandemLbs = 34800.0,
    this.grossWeightLbs = 80100.0,
    this.isCompliant = false,
    this.advice = '⚠️ Trailer tandem (34,800 lbs) exceeds 34k limit. Shift 1,200 lbs forward before scale weigh-in.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompliant ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          width: 1.5,
        ),
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
                      color: const Color(0xFFF59E0B).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.scale_rounded, color: Color(0xFFFBBF24), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BRIDGE FORMULA AUDITOR',
                        style: TextStyle(
                          color: Color(0xFFFBBF24),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Axle Load Distribution',
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
                  color: (isCompliant ? Colors.green : Colors.amber).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: (isCompliant ? Colors.green : Colors.amber).withOpacity(0.5)),
                ),
                child: Text(
                  isCompliant ? 'LEGAL SCALE' : 'REBALANCE REQ',
                  style: TextStyle(
                    color: isCompliant ? Colors.greenAccent : Colors.amberAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Axle Visual Meter
          Row(
            children: [
              _buildAxleBox('STEER AXLE', steerLbs, 12000.0, steerLbs <= 12000.0),
              const SizedBox(width: 8),
              _buildAxleBox('DRIVE TANDEM', driveTandemLbs, 34000.0, driveTandemLbs <= 34000.0),
              const SizedBox(width: 8),
              _buildAxleBox('TRAILER TANDEM', trailerTandemLbs, 34000.0, trailerTandemLbs <= 34000.0),
            ],
          ),

          const SizedBox(height: 12),

          // Advice / Action Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isCompliant ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                  size: 16,
                  color: isCompliant ? Colors.greenAccent : Colors.amberAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    advice,
                    style: const TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAxleBox(String name, double weight, double maxLimit, bool isOk) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOk ? const Color(0xFF334155) : Colors.amberAccent.withOpacity(0.8),
          ),
        ),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8.5, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${(weight / 1000).toStringAsFixed(1)}k lbs',
              style: TextStyle(
                color: isOk ? Colors.white : Colors.amberAccent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'JetBrains Mono',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Max ${(maxLimit / 1000).toStringAsFixed(0)}k',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
