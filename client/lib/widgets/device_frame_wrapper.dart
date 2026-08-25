/// Responsive Device Frame Wrapper.
/// Renders an adaptive layout:
/// - Desktop (width > 900px): Centered smartphone frame showcasing deskless mobile ergonomics alongside a live OpenTelemetry sidebar.
/// - Mobile / Tablet: Full-screen native experience for on-the-field use.

import 'package:flutter/material.dart';
import 'telemetry_sidebar.dart';

class DeviceFrameWrapper extends StatelessWidget {
  final Widget child;

  const DeviceFrameWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        if (!isDesktop) {
          // Native Full-Screen View for Real Mobile Devices and Small Screens
          return child;
        }

        // Adaptive Desktop Layout: Smartphone Frame on Left + Telemetry Sidebar on Right
        return Scaffold(
          backgroundColor: const Color(0xFF070B14),
          body: Row(
            children: [
              // Left Section: Interactive Smartphone Mockup Container
              Expanded(
                flex: 5,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    width: 420,
                    height: 860,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(44),
                      border: Border.all(color: const Color(0xFF334155), width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 4,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(38),
                      child: Column(
                        children: [
                          // Simulated Smartphone Status Bar & Camera Pill
                          Container(
                            height: 36,
                            color: const Color(0xFF0F172A),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '9:41',
                                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: 80,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(Icons.wifi, size: 14, color: Colors.white70),
                                    SizedBox(width: 4),
                                    Icon(Icons.battery_full, size: 14, color: Colors.white70),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // The Embedded Mobile App (Constrained with Local Navigator for in-frame popups & bottom sheets)
                          Expanded(
                            child: Navigator(
                              onGenerateRoute: (settings) => MaterialPageRoute(
                                builder: (nestedContext) => child,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Right Section: Live Enterprise Fleet Telemetry Sidebar
              const Expanded(
                flex: 4,
                child: TelemetrySidebar(),
              ),
            ],
          ),
        );
      },
    );
  }
}
