# Change Log - Fix Camera Controller Recreation on Route Return

**Date:** 2026-08-01 07:55:00
**Referenced Plan:** [plans/20260801_075000_fix_camera_controller_recreation_on_return.md](../plans/20260801_075000_fix_camera_controller_recreation_on_return.md)

## Summary of Changes
Resolved issue where camera feed would freeze or stay black upon returning to `ScannerScreen` from `AirQR Stream Receiver`, `AR CodeVision HUD`, `Settings`, `History`, or `Result` screens.

1. **Camera Controller Disposal on Navigation**:
   - Updated `ScannerScreen._navigateToRoute()` to explicitly dispose the active `MobileScannerController` instance and set `controller = null` before pushing any named route.
   - This ensures native Android `CameraX` / `Camera2` hardware session is completely freed.

2. **Fresh Controller Recreation on Return**:
   - Added `_recreateAndStartController()` helper in `ScannerScreen` that waits 300ms for native Android camera unbind clearance and instantiates a brand-new `MobileScannerController`.
   - Updated `didChangeAppLifecycleState()`, `_navigateToRoute()`, `_handleBarcode()`, and `_toggleScanning()` to invoke `_recreateAndStartController()`.

## Files Changed
- [lib/screens/scanner_screen.dart](../lib/screens/scanner_screen.dart)
- [plans/20260801_075000_fix_camera_controller_recreation_on_return.md](../plans/20260801_075000_fix_camera_controller_recreation_on_return.md)

## Verification
- `flutter analyze`: 0 warnings, 0 errors.
- `flutter test`: 144/144 tests passed cleanly.
