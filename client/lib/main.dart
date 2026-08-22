/// Entrypoint for Campabadal Global Logistics.
/// Initializes Flutter bindings, applies dark theme aesthetics with Google Fonts,
/// and wraps the application with the interactive DeviceFrameWrapper for responsive simulation.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'widgets/device_frame_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CampabadalLogisticsApp());
}

/// Root widget configuring the Material dark theme and typography.
class CampabadalLogisticsApp extends StatelessWidget {
  const CampabadalLogisticsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campabadal Global Logistics | Fortified Enterprise Fleet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070B14),
        primaryColor: const Color(0xFF0284C7),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0284C7),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF0F172A),
          background: Color(0xFF070B14),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const DeviceFrameWrapper(
        child: HomeScreen(),
      ),
    );
  }
}
