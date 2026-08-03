# Fix MobileScannerController Already Running Error and Stale Camera Preview

**Status:** Approved

## Issue Summary
When navigating between the main `ScannerScreen` and secondary camera screens (`AR CodeVision HUD` or `AirQR Stream Receiver`), the camera viewport displays the error message:
`The MobileScannerController is already running. Stop it before starting again.`

## Root Cause Analysis
1. When `ScannerScreen` opens `ArCodevisionScreen` or `AirQrScreen`, both screens create independent `MobileScannerController` instances.
2. Leaving `ScannerScreen`'s controller alive while another screen takes over camera hardware breaks the native Android camera texture binding on `ScannerScreen`'s controller.
3. Upon returning to `ScannerScreen`, calling `controller.start()` on the stale controller (or when `MobileScanner` auto-starts) triggers a `MobileScannerException` (`controllerAlreadyInitialized`) because the controller state in Dart and native Android plugin got out of sync.

## Proposed Solution

### 1. Re-initialize Controller on Camera Screen Transitions (`lib/screens/scanner_screen.dart`)
- For transitions to secondary camera screens (`/ar_codevision` and `/air_qr`), dispose `ScannerScreen`'s old `controller` before pushing the route.
- When returning from these camera screens, invoke `_initializeScanner()` to create a fresh `MobileScannerController` instance with clean native texture bindings.
- For non-camera screens (`/history`, `/settings`, `/about`, `/result`), check `controller.value.isRunning` before calling `stop()` or `start()` to prevent double-start exceptions.

### 2. State & Exception Protection (`lib/screens/scanner_screen.dart`, `lib/screens/ar_codevision_screen.dart`, `lib/screens/air_qr_screen.dart`)
- Wrap all `controller.start()` and `controller.stop()` calls with `if (!controller.value.isRunning)` / `if (controller.value.isRunning)` guards and `try-catch` blocks.
- Add custom `errorBuilder` to `MobileScanner` widgets across all three camera screens to display a clean, friendly fallback UI instead of unhandled system error strings.

## Files to Modify
- [lib/screens/scanner_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/scanner_screen.dart)
- [lib/screens/ar_codevision_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/ar_codevision_screen.dart)
- [lib/screens/air_qr_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/air_qr_screen.dart)

## Verification Plan
1. Run `flutter analyze` to ensure 0 static analysis errors/warnings.
2. Run `flutter test` to ensure all 140 unit and widget tests pass.
