import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/screens/scanner_screen.dart';
import 'package:sreeraj_qr_reader/screens/result_screen.dart';
import 'package:sreeraj_qr_reader/screens/about_screen.dart';
import 'package:sreeraj_qr_reader/screens/settings_screen.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

void main() {
  runApp(const SreerajQRReaderApp());
}

class SreerajQRReaderApp extends StatelessWidget {
  const SreerajQRReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScanProvider(),
      child: MaterialApp(
        title: 'Sreeraj P QR Reader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF2196F3),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
          ),
        ),
        home: const ScannerScreen(),
        routes: {
          '/result': (context) => const ResultScreen(),
          '/about': (context) => const AboutScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
