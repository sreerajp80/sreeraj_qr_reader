# Plan — 2.1 Camera & Viewport Controls Suite

**Status:** Completed

## Goal
Implement Feature Suite 2.1 — Camera & Viewport Controls Suite:
1. **Flashlight / Torch Toggle**: Add floating button on `ScannerScreen` bound to `controller.toggleTorch()` with torch state icon binding.
2. **Camera Flip**: Add camera flip button bound to `controller.switchCamera()` to switch between back and front camera.
3. **Pinch-to-Zoom & Zoom Slider**: Implement pinch gesture handling and visual zoom bar (1.0x to 8.0x) calling `controller.setZoomScale()`.
4. **Haptic & Audible Feedback**: Provide user configurable vibration pulses and scan beep sounds upon barcode detection, managed via `SettingsScreen` and stored in `SharedPreferences`.
5. **Animated Frame & Focus Box**: Enhance scanning overlay with dynamic auto-resizing bounding box reticles around detected barcodes in real time.

---

## Target Layer & Files to Modify / Create

### 1. Settings & Provider Layer (`lib/providers/`)
- **[MODIFY]** `lib/providers/scan_provider.dart` (or `lib/providers/theme_provider.dart` / settings handling):
  - Add scan feedback settings state (`isVibrationEnabled`, `isSoundEnabled`).
  - Load/persist preferences in `SharedPreferences` (`scan_feedback_vibration`, `scan_feedback_sound`).
  - Provide setter methods `setVibrationEnabled(bool)` and `setSoundEnabled(bool)` with `notifyListeners()`.

### 2. UI Viewport & Controls Layer (`lib/screens/`)
- **[MODIFY]** `lib/screens/scanner_screen.dart`:
  - Add floating viewport controls overlay containing:
    - Torch toggle button (`Icons.flash_on` / `Icons.flash_off`).
    - Camera flip button (`Icons.cameraswitch`).
    - Zoom slider toggle & zoom level badge (1.0x to 8.0x).
  - Wrap camera view in `GestureDetector` for pinch-to-zoom scale gesture calculation.
  - Bind `_handleBarcode` to fire `HapticFeedback` and `SystemSound` according to user settings.
  - Track detected barcode bounding box/corners and pass to `ScanOverlayWidget`.

- **[MODIFY]** `lib/screens/widgets/scan_overlay_widget.dart`:
  - Add support for rendering dynamic bounding box reticles around detected code coordinates (`barcode.corners` / `boundingBox`).
  - Add smooth pulse/highlight box surrounding detected code.

- **[MODIFY]** `lib/screens/settings_screen.dart`:
  - Add "Scan Feedback & Viewport" settings section.
  - Include switches for "Vibration Feedback" and "Audible Sound Beep".

### 3. Tests (`test/`)
- **[NEW]** `test/providers/scan_feedback_test.dart`:
  - Unit tests for scan feedback preference state transitions and persistence.
- **[MODIFY]** `test/screens/widgets/scan_overlay_widget_test.dart`:
  - Widget tests for dynamic bounding box drawing.

---

## Architectural Impact & Security
- Follows Tier 1 layer-first structure.
- State managed exclusively via `Provider` (`ChangeNotifier`).
- Camera permission requested on-demand only.
- Simple, plain English, offline-first.

---

## Verification Plan

### Automated Tests
```bash
flutter analyze                        # Static analysis (0 errors/warnings)
flutter test                           # Run all unit and widget tests
```

### Manual Verification
1. Open scanner screen and verify torch toggle button turns flash on/off.
2. Verify camera flip button toggles between front and back camera.
3. Test pinch-to-zoom gesture and zoom slider bar up to 8.0x.
4. Toggle vibration and sound options in Settings screen and verify feedback on code detection.
5. Verify dynamic focus box highlighting detected barcodes in real time.
