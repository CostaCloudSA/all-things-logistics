/// In-Frame Fallback Modal for Non-Demo Features.
/// Displayed when the user taps features outside the active working multi-step demo.

import 'package:flutter/material.dart';

class UnderConstructionModal extends StatelessWidget {
  final String companyName;
  final Color brandColor;
  final String featureName;
  final String demoGuideTitle;
  final String demoGuideFileName;
  final VoidCallback? onLaunchActiveDemo;

  const UnderConstructionModal({
    Key? key,
    required this.companyName,
    required this.brandColor,
    required this.featureName,
    required this.demoGuideTitle,
    required this.demoGuideFileName,
    this.onLaunchActiveDemo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Slate 900
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF475569),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAB308).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFEAB308).withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.construction_rounded, color: Color(0xFFFACC15), size: 14),
                    SizedBox(width: 6),
                    Text(
                      'FEATURE IN DEVELOPMENT',
                      style: TextStyle(
                        color: Color(0xFFFACC15),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Feature Title & Notice
          Text(
            featureName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "This part isn't fully programmed yet. Please refer to the demo guide for this company:",
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // Demo Guide Link Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: brandColor.withOpacity(0.35)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.menu_book_rounded, color: brandColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        demoGuideTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'docs/demos/$demoGuideFileName',
                        style: TextStyle(
                          color: brandColor,
                          fontSize: 11,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Primary 1-Tap Action: Launch Active Demo
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: false).pop();
              if (onLaunchActiveDemo != null) {
                onLaunchActiveDemo!();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 3,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_fill_rounded, size: 20),
                SizedBox(width: 8),
                Text(
                  'Launch Working Multi-Step Demo',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Secondary Close Button
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
            child: const Text(
              'Dismiss Notice',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
