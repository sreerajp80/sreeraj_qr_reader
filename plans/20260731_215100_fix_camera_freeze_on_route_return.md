# Fix Camera Preview Freeze When Returning from AR CodeVision & AirQR Screens

**Status:** Approved

## Problem
When navigating to AR CodeVision (`/ar_codevision`) or AirQR Stream Receiver (`/air_qr`) from the main `ScannerScreen`, those screens instantiate a new `MobileScannerController` to access device camera hardware.
Because native mobile OS camera hardware cannot support multiple active preview sessions concurrently:
1. `ScannerScreen`'s camera controller was left active during route pushes, resulting in camera hardware resource conflicts.
2. When popping back to `ScannerScreen`, its camera controller remained in a stale/stopped hardware state, showing a black screen despite `_isScanning` being `true`.
3. The user had to manually pause and restart the scanner button to re-initialize the camera stream.

## Files to Change
- [lib/screens/scanner_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/scanner_screen.dart)
- [lib/screens/ar_codevision_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/ar_codevision_screen.dart)
- [lib/screens/air_qr_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/air_qr_screen.dart)

## Proposed Changes

### `lib/screens/scanner_screen.dart`
1. Add `WidgetsBindingObserver` mixin to manage app lifecycle (paused/resumed).
2. Implement `_navigateToRoute(routeName)` helper method:
   - Call `await controller?.stop()` before `Navigator.pushNamed`.
   - Call `await controller?.start()` after `Navigator.pushNamed` completes when `_isScanning` is true.
3. Update `_handleBarcode` to stop camera before `/result` navigation and restart after returning.
4. Update `didChangeAppLifecycleState` to stop camera on app pause and restart on resume.

### `lib/screens/ar_codevision_screen.dart`
1. Add `WidgetsBindingObserver` mixin to stop camera on app pause and restart on app resume.

### `lib/screens/air_qr_screen.dart`
1. Add `WidgetsBindingObserver` mixin to stop camera on app pause and restart on app resume.
2. Stop camera before navigating to `/air_qr_transmitter` and restart after returning.

## Verification Plan
1. Run `flutter analyze` to ensure 0 static analysis issues.
2. Run `flutter test` to ensure all 140 unit and widget tests pass.
