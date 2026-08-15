import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'widgets/device_frame_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AllThingsLogisticsApp());
}

class AllThingsLogisticsApp extends StatelessWidget {
  const AllThingsLogisticsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Things Logistics | Fortified Enterprise Fleet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF3B82F6),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
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
