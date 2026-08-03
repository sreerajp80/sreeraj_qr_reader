import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/providers/air_qr_provider.dart';
import 'package:sreeraj_qr_reader/providers/ar_codevision_provider.dart';
import 'package:sreeraj_qr_reader/providers/history_provider.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';
import 'package:sreeraj_qr_reader/screens/about_screen.dart';
import 'package:sreeraj_qr_reader/screens/air_qr_screen.dart';
import 'package:sreeraj_qr_reader/screens/air_qr_transmitter_screen.dart';
import 'package:sreeraj_qr_reader/screens/ar_codevision_screen.dart';
import 'package:sreeraj_qr_reader/screens/history_screen.dart';
import 'package:sreeraj_qr_reader/screens/result_screen.dart';
import 'package:sreeraj_qr_reader/screens/scanner_screen.dart';
import 'package:sreeraj_qr_reader/screens/settings_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const SreerajQRReaderApp());
}

class SreerajQRReaderApp extends StatelessWidget {
  const SreerajQRReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => AirQrProvider()),
        ChangeNotifierProvider(create: (_) => ArCodevisionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              final lightTheme = themeProvider.buildLightTheme(
                dynamicColorScheme: lightDynamic,
              );

              final darkTheme = themeProvider.themeMode == AppThemeMode.oled
                  ? themeProvider.buildOledTheme(
                      dynamicColorScheme: darkDynamic,
                    )
                  : themeProvider.buildDarkTheme(
                      dynamicColorScheme: darkDynamic,
                    );

              final themeMode = switch (themeProvider.themeMode) {
                AppThemeMode.system => ThemeMode.system,
                AppThemeMode.light => ThemeMode.light,
                AppThemeMode.dark => ThemeMode.dark,
                AppThemeMode.oled => ThemeMode.dark,
              };

              return MaterialApp(
                title: 'Sreeraj P QR Reader',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeMode,
                home: const ScannerScreen(),
                navigatorObservers: [routeObserver],
                routes: {
                  '/result': (context) => const ResultScreen(),
                  '/about': (context) => const AboutScreen(),
                  '/settings': (context) => const SettingsScreen(),
                  '/history': (context) => const HistoryScreen(),
                  '/air_qr': (context) => const AirQrScreen(),
                  '/air_qr_transmitter': (context) =>
                      const AirQrTransmitterScreen(),
                  '/ar_codevision': (context) => const ArCodevisionScreen(),
                },
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
