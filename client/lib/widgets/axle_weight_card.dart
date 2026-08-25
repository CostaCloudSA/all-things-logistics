import 'package:flutter/material.dart';

/// Interactive Federal Bridge Formula B Axle Distribution Visualizer.
/// Allows live shifting of freight weight between trailer and drive tandems
/// to demonstrate real-time roadside scale compliance.
class AxleWeightCard extends StatefulWidget {
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
    this.advice = 'AXLE SCALE OVERLOAD: Trailer tandem (34,800 lbs) exceeds 34,000 lbs statutory limit. Shift 1,200 lbs forward before scale weigh-in.',
  }) : super(key: key);

  @override
  State<AxleWeightCard> createState() => _AxleWeightCardState();
}

class _AxleWeightCardState extends State<AxleWeightCard> {
  late double _shiftAmountLbs;

  @override
  void initState() {
    super.initState();
    _shiftAmountLbs = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final curDrive = widget.driveTandemLbs + _shiftAmountLbs;
    final curTrailer = widget.trailerTandemLbs - _shiftAmountLbs;
    final isDriveOk = curDrive <= 34000.0;
    final isTrailerOk = curTrailer <= 34000.0;
    final isSteerOk = widget.steerLbs <= 12000.0;
    final isCompliant = isDriveOk && isTrailerOk && isSteerOk && widget.grossWeightLbs <= 80000.0;

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
                      color: (isCompliant ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.scale_rounded,
                      color: isCompliant ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BRIDGE FORMULA B AUDITOR',
                        style: TextStyle(
                          color: isCompliant ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Text(
                        '5-Axle Weight Distribution (23 CFR 658)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCompliant ? Icons.check_circle : Icons.warning_amber,
                      size: 11,
                      color: isCompliant ? Colors.greenAccent : Colors.amberAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCompliant ? 'LEGAL SCALE COMPLIANT' : 'AXLE OVERLOAD',
                      style: TextStyle(
                        color: isCompliant ? Colors.greenAccent : Colors.amberAccent,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Axle Visual Meters
          Row(
            children: [
              _buildAxleBox('STEER AXLE', widget.steerLbs, 12000.0, isSteerOk),
              const SizedBox(width: 8),
              _buildAxleBox('DRIVE TANDEM', curDrive, 34000.0, isDriveOk),
              const SizedBox(width: 8),
              _buildAxleBox('TRAILER TANDEM', curTrailer, 34000.0, isTrailerOk),
            ],
          ),

          const SizedBox(height: 12),

          // Interactive Weight Redistribution Slider
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    const Text(
                      'Tandem Slider: Shift Weight Forward ->',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '+${_shiftAmountLbs.toStringAsFixed(0)} lbs to Drive',
                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF0284C7),
                    inactiveTrackColor: const Color(0xFF334155),
                    thumbColor: const Color(0xFF38BDF8),
                    overlayColor: const Color(0xFF38BDF8).withOpacity(0.2),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _shiftAmountLbs,
                    min: 0.0,
                    max: 2000.0,
                    divisions: 20,
                    onChanged: (val) {
                      setState(() {
                        _shiftAmountLbs = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

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
                    isCompliant
                        ? 'Bridge Formula B verified: All axles within 23 CFR 658 statutory limits. Roadside scale pre-cleared.'
                        : widget.advice,
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

