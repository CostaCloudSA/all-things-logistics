/// Guided Smart Chip Bar for Deskless "No Keyboard" Logistics Execution.
/// Categorizes 1-tap scenario presets and operational swarm actions
/// with touch-friendly 48px hit-targets for forklift operators and truck drivers.

import 'package:flutter/material.dart';
import '../models/trade_models.dart';

class SmartChipsBar extends StatelessWidget {
  final List<SmartChip> chips;
  final Function(SmartChip) onChipSelected;
  final Color accentColor;

  const SmartChipsBar({
    Key? key,
    required this.chips,
    required this.onChipSelected,
    this.accentColor = const Color(0xFF0284C7),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    final scenarioChips = chips.where((c) => c.category == 'scenario').toList();
    final actionChips = chips.where((c) => c.category != 'scenario').toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.touch_app_rounded, size: 16, color: accentColor),
              const SizedBox(width: 8),
              const Text(
                'DESKLESS ZERO-KEYBOARD CONTROLS (1-TAP EXECUTION)',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          if (scenarioChips.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Quick Scenarios:',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: scenarioChips.map((chip) => _buildChipItem(chip, isScenario: true)).toList(),
            ),
          ],
          if (actionChips.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Swarm Operational Actions:',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: actionChips.map((chip) => _buildChipItem(chip, isScenario: false)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChipItem(SmartChip chip, {required bool isScenario}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChipSelected(chip),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isScenario ? accentColor.withOpacity(0.15) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isScenario ? accentColor.withOpacity(0.6) : Colors.white.withOpacity(0.15),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                chip.label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isScenario ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
