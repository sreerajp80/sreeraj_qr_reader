# Change Log - Robust Camera Start Retry Loop with Explicit autoStart & Pre-Pop Release

**Date:** 2026-07-31 19:16:00
**Referenced Plan:** [plans/20260731_191600_robust_camera_retry_loop_and_pre_pop_release.md](file:///l:/Android/sreeraj_qr_reader/plans/20260731_191600_robust_camera_retry_loop_and_pre_pop_release.md)

## Summary of Changes
Resolved camera freeze/black viewport issues when returning from `AirQR Stream Receiver` or `AR CodeVision HUD` by implementing an explicit startup retry loop with exponential backoff and pre-pop camera release.

1. **Flutter `RouteObserver` Integration**:
   - Registered global `RouteObserver<ModalRoute<void>> routeObserver` in `lib/main.dart`.
   - Subscribed `ScannerScreen` as `RouteAware` in `lib/screens/scanner_screen.dart` to listen for `didPopNext()`.

2. **Explicit `autoStart: false` & Retry Loop**:
   - Replaced one-shot camera creation with `_startCameraWithRetry()` in `ScannerScreen`.
   - Created `MobileScannerController` with `autoStart: false` for explicit startup control.
   - Implemented an async retry loop with exponential backoff (250ms, 500ms, 750ms, 1000ms) that explicitly awaits `newController.start()`. If native Android `Camera2` hardware is busy unbinding, the exception is caught, the controller is cleaned up, and initialization is retried automatically.

3. **Pre-Pop Camera Release in Secondary Screens**:
   - Added explicit back handlers in `lib/screens/ar_codevision_screen.dart` and `lib/screens/air_qr_screen.dart` that stop and dispose the secondary camera controller (`await controller?.stop(); await controller?.dispose()`) before invoking `Navigator.pop(context)`.

## Files Changed
- [lib/main.dart](file:///l:/Android/sreeraj_qr_reader/lib/main.dart)
- [lib/screens/scanner_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/scanner_screen.dart)
- [lib/screens/ar_codevision_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/ar_codevision_screen.dart)
- [lib/screens/air_qr_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/air_qr_screen.dart)
- [plans/20260731_191600_robust_camera_retry_loop_and_pre_pop_release.md](file:///l:/Android/sreeraj_qr_reader/plans/20260731_191600_robust_camera_retry_loop_and_pre_pop_release.md)

## Verification
- `flutter analyze`: 0 errors, 0 warnings.
- `flutter test`: 144/144 tests passed cleanly.
