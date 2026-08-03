# Fix Camera Controller Recreation on Route Return

**Status:** Approved

## Problem Analysis
When returning to `ScannerScreen` from camera-based secondary screens (`ArCodevisionScreen` or `AirQrScreen`), or non-camera screens:
1. Previous attempts kept the same `MobileScannerController` Dart instance alive across route pushes.
2. On Android, when a secondary screen (`ArCodevisionScreen` / `AirQrScreen`) initializes its own `MobileScannerController` and binds to CameraX, Android OS invalidates and destroys the native `SurfaceTexture` / `TextureRegistry` attached to `ScannerScreen`'s existing controller.
3. Calling `controller.start()` on the old `MobileScannerController` instance fails to restore the native Android camera preview surface, leaving the viewport frozen, black, or stuck until manually paused/started or app restarted.

## Proposed Solution
Instead of keeping a stale `MobileScannerController` instance across screen transitions:
1. **Explicit Disposal before Navigation**: In `ScannerScreen._navigateToRoute()`, explicitly call `await controller?.dispose()`, set `controller = null` and `_isInitialized = false` before pushing any route. This completely releases camera hardware.
2. **Fresh Controller Recreation on Return**: Implement `_recreateAndStartController()` in `ScannerScreen` which:
   - Disposes any existing controller safely.
   - Waits a brief 300ms hardware release clearance delay for Android CameraX native unbind.
   - Instantiates a brand-new `MobileScannerController` and updates UI state (`_isInitialized = true`).
3. **Apply Clean Recreation Across All Navigation & Lifecycle Resumes**:
   - On return from `Navigator.pushNamed(context, routeName)`.
   - On return from `/result` screen in `_handleBarcode()`.
   - On `AppLifecycleState.resumed`.
   - On Pause/Play FAB toggle resume.

## Files to Modify
- [lib/screens/scanner_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/scanner_screen.dart)
- [lib/screens/air_qr_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/air_qr_screen.dart)

## Verification Plan
### Automated Verification
- Run `flutter analyze` to ensure 0 static analysis warnings or errors.
- Run `flutter test` to verify all 144 unit and widget tests pass cleanly.

### Manual Verification
- Build and run production APK (`flutter build apk --flavor prod --release`).
- Verify navigating to `AirQR Stream Reader` and back restores camera preview automatically.
- Verify navigating to `AR CodeVision HUD` and back restores camera preview automatically.
