# Change Log — 2.5 Modern Material You (M3), True OLED Dark Theme & Customizable Scan Overlay

**Plan reference:** `plans/20260731_203500_m3_dark_theme_scan_overlay.md`

## Summary of Changes
- Added `dynamic_color: ^1.7.0` dependency for Material You Monet system wallpaper color extraction on Android 12+.
- Created `ThemeProvider` in `lib/providers/theme_provider.dart`:
  - Manages `AppThemeMode` (`system`, `light`, `dark`, `oled`), `useDynamicColor`, and `ScanOverlayStyle` (`laserLine`, `pulsingCorners`, `cyberneticGrid`, `subtleDotMatrix`).
  - Persists settings across app restarts via `SharedPreferences`.
  - Builds custom `ThemeData` for Light, Dark, and True OLED Pure Black (`#000000`) modes.
- Created `ScanOverlayWidget` in `lib/screens/widgets/scan_overlay_widget.dart` featuring animated custom painters for all 4 scan frame overlay styles:
  1. `laserLine`: Animated vertical scanning laser line with glow effect.
  2. `pulsingCorners`: Breathing L-shaped reticles with color glow and scale animation.
  3. `cyberneticGrid`: Sci-fi grid mesh pattern with target crosshairs.
  4. `subtleDotMatrix`: Minimalist dot matrix corner grid accents.
- Updated `lib/main.dart` to register `ThemeProvider` and wrap `MaterialApp` with `DynamicColorBuilder`.
- Updated `lib/screens/scanner_screen.dart` to use the dynamic `ScanOverlayWidget`.
- Updated `lib/screens/settings_screen.dart` with "Appearance & Theme" and "Customizable Scan Overlay" sections.
- Added comprehensive unit tests in `test/providers/theme_provider_test.dart` and widget tests in `test/screens/widgets/scan_overlay_widget_test.dart`.

## Verification Results
- `flutter analyze`: Clean (0 issues, 0 warnings).
- `flutter test`: All 117 tests passed.
