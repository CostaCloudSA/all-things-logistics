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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.touch_app_rounded, size: 16, color: accentColor),
                  const SizedBox(width: 8),
                  const Text(
                    'DESKLESS ZERO-KEYBOARD CONTROLS',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              // Dropdown Menu Selectors for Quick Actions
              Row(
                children: [
                  if (scenarioChips.isNotEmpty)
                    _buildCategoryDropdown(
                      context,
                      label: 'Scenarios ▾',
                      icon: Icons.inventory_2,
                      chips: scenarioChips,
                      isScenario: true,
                    ),
                  if (actionChips.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    _buildCategoryDropdown(
                      context,
                      label: 'Swarm Actions ▾',
                      icon: Icons.auto_awesome,
                      chips: actionChips,
                      isScenario: false,
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (scenarioChips.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.flash_on, size: 13, color: accentColor),
                const SizedBox(width: 4),
                const Text(
                  'Quick 1-Tap Scenarios:',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
            Row(
              children: [
                const Icon(Icons.hub_outlined, size: 13, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                const Text(
                  'Autonomous Swarm Actions:',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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

  Widget _buildCategoryDropdown(
    BuildContext context, {
    required String label,
    required IconData icon,
    required List<SmartChip> chips,
    required bool isScenario,
  }) {
    return PopupMenuButton<SmartChip>(
      tooltip: 'Open $label menu',
      onSelected: onChipSelected,
      color: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.12)),
      ),
      offset: const Offset(0, 30),
      itemBuilder: (context) {
        return chips.map((chip) {
          final cleanLabel = chip.label.replaceAll(RegExp(r'^[^\w\s\(\)\-\+\$\.\,\/]+\s*'), '');
          final chipIcon = _getIconForChip(chip);
          return PopupMenuItem<SmartChip>(
            value: chip,
            child: Row(
              children: [
                Icon(chipIcon, size: 16, color: isScenario ? accentColor : const Color(0xFF38BDF8)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cleanLabel,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isScenario ? accentColor.withOpacity(0.15) : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isScenario ? accentColor.withOpacity(0.4) : Colors.white.withOpacity(0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: isScenario ? accentColor : const Color(0xFF94A3B8)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: isScenario ? Colors.white : const Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForChip(SmartChip chip) {
    final id = chip.id.toLowerCase();
    final cat = chip.category.toLowerCase();
    if (id.contains('poultry')) return Icons.inventory_2;
    if (id.contains('pineapple') || id.contains('avocado')) return Icons.eco;
    if (id.contains('drayage') || id.contains('tomas')) return Icons.local_shipping;
    if (id.contains('feeder') || id.contains('ndj') || id.contains('ebl')) return Icons.directions_boat;
    if (id.contains('bridge') || id.contains('ballast') || cat == 'axle_weight') return Icons.scale;
    if (id.contains('nightwatch') || cat == 'night_watch') return Icons.nights_stay;
    if (id.contains('detention') || id.contains('demurrage')) return Icons.timer;
    if (id.contains('ducat') || id.contains('phyto') || id.contains('cif')) return Icons.description;
    if (id.contains('qr')) return Icons.qr_code_2;
    if (id.contains('a2a')) return Icons.sync_alt;
    if (id.contains('tax') || id.contains('shield')) return Icons.security;
    return Icons.touch_app;
  }

  Widget _buildChipItem(SmartChip chip, {required bool isScenario}) {
    final icon = _getIconForChip(chip);
    // Strip leading emoji if present in label
    final cleanLabel = chip.label.replaceAll(RegExp(r'^[^\w\s\(\)\-\+\$\.\,\/]+\s*'), '');

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
              Icon(icon, size: 15, color: isScenario ? accentColor : const Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Text(
                cleanLabel,
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
