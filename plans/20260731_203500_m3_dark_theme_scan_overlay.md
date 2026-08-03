# Plan — 2.5 Modern Material You (M3), True OLED Dark Theme & Customizable Scan Overlay

**Status:** Approved

## Goal
Implement Feature 2.5:
1. **Material You Dynamic Colors**: Dynamically sample system wallpaper colors on Android 12+ (Monet engine) for a personalized UI.
2. **True OLED Dark Mode**: Pure black (`#000000`) theme option optimized for AMOLED screens to conserve battery during continuous camera usage.
3. **Customizable Scan Overlay**: Allow users to choose scanner frame styles (`laserLine`, `pulsingCorners`, `cyberneticGrid`, `subtleDotMatrix`).

---

## Target Layer & Files to Modify / Create

### 1. Dependencies
- **[MODIFY]** `pubspec.yaml`: Add `dynamic_color: ^1.7.0` (BSD-3-Clause license).

### 2. Providers Layer (`lib/providers/`)
- **[NEW]** `lib/providers/theme_provider.dart`:
  - Enums: `AppThemeMode` (`system`, `light`, `dark`, `oled`), `ScanOverlayStyle` (`laserLine`, `pulsingCorners`, `cyberneticGrid`, `subtleDotMatrix`).
  - Manages theme mode, dynamic color enablement, and scanner overlay style.
  - Loads and persists settings using `SharedPreferences`.
  - Generates `ThemeData` for Light, Dark, and True OLED Dark modes with optional Material You `ColorScheme` integration.

### 3. UI Widgets & Screens Layer (`lib/screens/`)
- **[NEW]** `lib/screens/widgets/scan_overlay_widget.dart`:
  - Custom painters for 4 scanner frame styles (`laserLine`, `pulsingCorners`, `cyberneticGrid`, `subtleDotMatrix`).
  - Animated frame effects (laser sweep line, corner pulse glow, grid crosshairs, dot matrix accents).
- **[MODIFY]** `lib/screens/scanner_screen.dart`:
  - Replace static overlay container with `ScanOverlayWidget` consuming `ThemeProvider.scanOverlayStyle`.
- **[MODIFY]** `lib/screens/settings_screen.dart`:
  - Add "Appearance & Scanner Display" section with Theme Mode selection (System, Light, Dark, OLED Pure Black), Material You dynamic colors toggle, and Scanner Overlay Style selector.
- **[MODIFY]** `lib/main.dart`:
  - Wrap app with `DynamicColorBuilder` from `package:dynamic_color`.
  - Register `ThemeProvider` in `MultiProvider`.
  - Bind `MaterialApp` theme and darkTheme properties dynamically based on `ThemeProvider` state.

### 4. Tests (`test/`)
- **[NEW]** `test/providers/theme_provider_test.dart`:
  - Test initial values, theme state mutations, and persistence.
- **[NEW]** `test/screens/widgets/scan_overlay_widget_test.dart`:
  - Widget tests for scanner overlay rendering across all 4 styles.

---

## Architectural Impact & Security
- Follows Tier 1 layer-first structure.
- No network requests added.
- All state changes managed via Provider (`ChangeNotifier`).
- Clean static analysis and test coverage.

---

## Verification Plan
1. Run `flutter pub get`
2. Run `flutter analyze` (must be 0 errors/warnings)
3. Run `flutter test` (all tests passing)
