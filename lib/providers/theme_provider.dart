import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported application theme modes.
enum AppThemeMode { system, light, dark, oled }

/// Supported scanner frame overlay styles.
enum ScanOverlayStyle {
  laserLine,
  pulsingCorners,
  cyberneticGrid,
  subtleDotMatrix,
}

/// Provider managing theme preferences, Material You dynamic colors,
/// OLED dark mode, and scanner frame overlay styles.
class ThemeProvider extends ChangeNotifier {
  static const String _prefThemeModeKey = 'app_theme_mode';
  static const String _prefUseDynamicColorKey = 'use_dynamic_color';
  static const String _prefScanOverlayStyleKey = 'scan_overlay_style';

  AppThemeMode _themeMode = AppThemeMode.system;
  bool _useDynamicColor = true;
  ScanOverlayStyle _scanOverlayStyle = ScanOverlayStyle.laserLine;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadPreferences();
  }

  AppThemeMode get themeMode => _themeMode;
  bool get useDynamicColor => _useDynamicColor;
  ScanOverlayStyle get scanOverlayStyle => _scanOverlayStyle;
  bool get isInitialized => _isInitialized;

  /// Loads saved preferences from [SharedPreferences].
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final modeStr = prefs.getString(_prefThemeModeKey);
      if (modeStr != null) {
        _themeMode = AppThemeMode.values.firstWhere(
          (e) => e.name == modeStr,
          orElse: () => AppThemeMode.system,
        );
      }

      _useDynamicColor = prefs.getBool(_prefUseDynamicColorKey) ?? true;

      final overlayStr = prefs.getString(_prefScanOverlayStyleKey);
      if (overlayStr != null) {
        _scanOverlayStyle = ScanOverlayStyle.values.firstWhere(
          (e) => e.name == overlayStr,
          orElse: () => ScanOverlayStyle.laserLine,
        );
      }
    } catch (_) {
      // Fallback to default settings if SharedPreferences fails
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Sets the application theme mode.
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefThemeModeKey, mode.name);
    } catch (_) {}
  }

  /// Toggles or sets Material You dynamic color support (Android 12+ Monet engine).
  Future<void> setUseDynamicColor(bool enabled) async {
    if (_useDynamicColor == enabled) return;
    _useDynamicColor = enabled;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefUseDynamicColorKey, enabled);
    } catch (_) {}
  }

  /// Sets the active scanner overlay style.
  Future<void> setScanOverlayStyle(ScanOverlayStyle style) async {
    if (_scanOverlayStyle == style) return;
    _scanOverlayStyle = style;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefScanOverlayStyleKey, style.name);
    } catch (_) {}
  }

  /// Builds Light Theme Data.
  ThemeData buildLightTheme({ColorScheme? dynamicColorScheme}) {
    final colorScheme = (_useDynamicColor && dynamicColorScheme != null)
        ? dynamicColorScheme.harmonized()
        : ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  /// Builds Dark Theme Data.
  ThemeData buildDarkTheme({ColorScheme? dynamicColorScheme}) {
    final colorScheme = (_useDynamicColor && dynamicColorScheme != null)
        ? dynamicColorScheme.harmonized()
        : ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }

  /// Builds True OLED Pure Black Theme Data optimized for AMOLED battery saving.
  ThemeData buildOledTheme({ColorScheme? dynamicColorScheme}) {
    final baseScheme = (_useDynamicColor && dynamicColorScheme != null)
        ? dynamicColorScheme.harmonized()
        : ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          );

    // Override surface, background, and surfaceContainer to pure black #000000
    final oledColorScheme = baseScheme.copyWith(
      surface: Colors.black,
      onSurface: Colors.white,
      surfaceContainer: const Color(0xFF0D0D0D),
      surfaceContainerHigh: const Color(0xFF141414),
      surfaceContainerHighest: const Color(0xFF1F1F1F),
      outline: const Color(0xFF333333),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: oledColorScheme,
      primaryColor: oledColorScheme.primary,
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.black,
      cardColor: Colors.black,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF262626)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF333333)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          side: BorderSide(color: Color(0xFF333333)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.black,
        indicatorColor: oledColorScheme.primaryContainer,
      ),
    );
  }
}
