# Fix Camera Hardware Release Delay on Route Return

**Reference Plan:** [plans/20260801_074000_fix_camera_hardware_release_delay.md](../plans/20260801_074000_fix_camera_hardware_release_delay.md)

## Summary of Changes
Fixed camera initialization stall ("Initializing camera feed...") when returning to the main scanner screen from AR CodeVision HUD or AirQR Receiver.

## Detailed Changes

### `lib/screens/ar_codevision_screen.dart` & `lib/screens/air_qr_screen.dart`
- Wrapped `Scaffold` in `PopScope` with `onPopInvokedWithResult`.
- When popping back from secondary camera screens, `controller.stop()` is triggered immediately before the pop animation finishes, pre-releasing native Android Camera2 hardware resources.

### `lib/screens/scanner_screen.dart`
- Retained the main `MobileScannerController` instance across route pushes (avoiding null/disposed state rebuild issues).
- In `_navigateToRoute`, added a brief 250ms hardware lock clearance delay upon returning to `ScannerScreen`.
- Added an automatic fallback retry mechanism (350ms delay) in `_navigateToRoute` to handle cases where native camera hardware is momentarily busy closing the previous session.

## Verification Results
- `dart format .`: Formatted cleanly (0 issues).
- `flutter analyze`: **0 warnings / 0 errors**.
- `flutter test`: **All 144 tests passed**.
