# Fix Camera Hardware Release Delay on Route Return

**Status:** Approved

## Problem Analysis
When returning to `ScannerScreen` from `ArCodevisionScreen` or `AirQrScreen`:
1. Native Android Camera2 hardware requires 200–500ms to fully release the camera device after a secondary controller is stopped/disposed.
2. Calling `controller.start()` immediately upon returning to `ScannerScreen` hits a temporary native camera hardware lock, causing `mobile_scanner` to fail initialization and trigger the `errorBuilder` ("Initializing camera feed...").
3. Setting `controller = null` during route push caused widget tree rebuild issues where `MobileScanner` attempted to read a disposed/null controller.

## Proposed Fix

### 1. Pre-Release Camera Hardware on Secondary Screens (`ar_codevision_screen.dart` & `air_qr_screen.dart`)
- Stop the secondary camera controller (`await _controller?.stop()`) BEFORE triggering `Navigator.pop(context)` or handling back button presses (via `PopScope`).
- This allows native Android Camera2 release to complete before `ScannerScreen` comes back into view.

### 2. Smooth Camera Re-Acquisition & Retry in `ScannerScreen` (`scanner_screen.dart`)
- Keep `ScannerScreen`'s `controller` instance intact throughout the app lifecycle (do not dispose or set to `null` during route pushes).
- In `_navigateToRoute(routeName)`:
  - Call `await controller?.stop()` before pushing the route.
  - Upon returning to `ScannerScreen`, wait a brief 200ms delay for native hardware lock clearance.
  - Attempt `await controller?.start()` wrapped in a `try-catch` with an automatic fallback retry (300ms delay) if the native camera was briefly busy.

## Files to Change
- [lib/screens/scanner_screen.dart](../lib/screens/scanner_screen.dart)
- [lib/screens/ar_codevision_screen.dart](../lib/screens/ar_codevision_screen.dart)
- [lib/screens/air_qr_screen.dart](../lib/screens/air_qr_screen.dart)

## Verification Plan
1. Run `flutter analyze` to verify 0 static analysis errors/warnings.
2. Run `flutter test` to ensure all 144 unit and widget tests pass cleanly.
