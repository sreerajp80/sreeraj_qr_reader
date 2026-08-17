# Change Log — 2.1 Camera & Viewport Controls Suite

**Plan:** [plans/20260731_205300_camera_viewport_controls_suite.md](../plans/20260731_205300_camera_viewport_controls_suite.md)

## Summary of Changes
Implemented Feature Suite 2.1 — Camera & Viewport Controls Suite:

1. **Flashlight / Torch Toggle**:
   - Added floating flashlight toggle icon button on `ScannerScreen` overlay.
   - Bound to `controller.toggleTorch()` with visual state indication (`Icons.flash_on` in amber / `Icons.flash_off` in white).

2. **Camera Flip**:
   - Added floating camera flip button on `ScannerScreen` overlay.
   - Bound to `controller.switchCamera()` with front/rear state indication (`Icons.cameraswitch`).

3. **Pinch-to-Zoom & Zoom Slider**:
   - Added gesture scale handling (`onScaleStart` & `onScaleUpdate`) directly on the scanner preview for smooth pinch-to-zoom (1.0x to 8.0x).
   - Added visual collapsible zoom slider bar with minimum (1.0x) and maximum (8.0x) indicator labels and live zoom level badge.
   - Bound to `controller.setZoomScale()`.

4. **Haptic & Audible Feedback**:
   - Added `isVibrationEnabled` and `isSoundEnabled` state properties in `ScanProvider`, loaded/persisted via `SharedPreferences`.
   - Added "Scan Feedback & Alerts" settings section in `SettingsScreen` with switches for Vibration Feedback and Audible Beep Sound.
   - Triggered `HapticFeedback.mediumImpact()` and `SystemSound.play(SystemSoundType.click)` in `ScannerScreen._handleBarcode` upon barcode recognition when enabled.

5. **Animated Frame & Dynamic Focus Box**:
   - Enhanced `ScanOverlayWidget` and `_ScanOverlayPainter` to render dynamic, glowing focus reticle bounding boxes around detected code coordinates (`detectedCorners` / `detectedBoundingBox`) in real time.

6. **Automated Testing**:
   - Created `test/providers/scan_feedback_test.dart` for unit testing scan feedback preferences initialization and persistence.
   - Updated `test/screens/widgets/scan_overlay_widget_test.dart` to test dynamic bounding box rendering.

## Verification
- Executed `flutter analyze` — Clean, 0 warnings/errors.
- Executed `flutter test` — All 121 unit & widget tests passed successfully.
