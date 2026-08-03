import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeProvider Unit Tests', () {
    test('Initial defaults are correctly set', () async {
      final provider = ThemeProvider();
      await Future<void>.delayed(Duration.zero);

      expect(provider.themeMode, equals(AppThemeMode.system));
      expect(provider.useDynamicColor, isTrue);
      expect(provider.scanOverlayStyle, equals(ScanOverlayStyle.laserLine));
    });

    test('Updating theme mode updates state and persists', () async {
      final provider = ThemeProvider();
      await Future<void>.delayed(Duration.zero);

      await provider.setThemeMode(AppThemeMode.oled);
      expect(provider.themeMode, equals(AppThemeMode.oled));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), equals('oled'));
    });

    test('Updating dynamic color setting updates state and persists', () async {
      final provider = ThemeProvider();
      await Future<void>.delayed(Duration.zero);

      await provider.setUseDynamicColor(false);
      expect(provider.useDynamicColor, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('use_dynamic_color'), isFalse);
    });

    test('Updating scan overlay style updates state and persists', () async {
      final provider = ThemeProvider();
      await Future<void>.delayed(Duration.zero);

      await provider.setScanOverlayStyle(ScanOverlayStyle.cyberneticGrid);
      expect(
        provider.scanOverlayStyle,
        equals(ScanOverlayStyle.cyberneticGrid),
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('scan_overlay_style'), equals('cyberneticGrid'));
    });

    test('buildOledTheme creates pure black scaffold background', () {
      final provider = ThemeProvider();
      final oledTheme = provider.buildOledTheme();

      expect(oledTheme.brightness, equals(Brightness.dark));
      expect(oledTheme.scaffoldBackgroundColor, equals(Colors.black));
      expect(oledTheme.canvasColor, equals(Colors.black));
      expect(oledTheme.appBarTheme.backgroundColor, equals(Colors.black));
    });

    test('buildLightTheme creates light brightness theme', () {
      final provider = ThemeProvider();
      final lightTheme = provider.buildLightTheme();

      expect(lightTheme.brightness, equals(Brightness.light));
      expect(lightTheme.useMaterial3, isTrue);
    });

    test('buildDarkTheme creates dark brightness theme', () {
      final provider = ThemeProvider();
      final darkTheme = provider.buildDarkTheme();

      expect(darkTheme.brightness, equals(Brightness.dark));
      expect(darkTheme.useMaterial3, isTrue);
    });
  });
}
