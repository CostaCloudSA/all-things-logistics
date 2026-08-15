import 'package:flutter/material.dart';
import '../models/trade_models.dart';

class SmartChipsBar extends StatelessWidget {
  final List<SmartChip> chips;
  final Function(SmartChip) onChipSelected;

  const SmartChipsBar({
    Key? key,
    required this.chips,
    required this.onChipSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.touch_app_outlined, size: 16, color: Color(0xFF60A5FA)),
            SizedBox(width: 6),
            Text(
              'Zero-Typing: Tap to Refine Commodity',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips.map((chip) {
            return ActionChip(
              backgroundColor: const Color(0xFF1E293B),
              side: const BorderSide(color: Color(0xFF3B82F6), width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              label: Text(
                chip.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              onPressed: () => onChipSelected(chip),
            );
          }).toList(),
        ),
      ],
    );
  }
}
