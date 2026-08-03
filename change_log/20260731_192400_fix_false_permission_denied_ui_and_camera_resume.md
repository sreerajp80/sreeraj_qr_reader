# Change Log - Fix False "Permission Required" UI Screen & Ensure Seamless Camera Resume

**Date:** 2026-07-31 19:24:00
**Referenced Plan:** [plans/20260731_192400_fix_false_permission_denied_ui_and_camera_resume.md](file:///l:/Android/sreeraj_qr_reader/plans/20260731_192400_fix_false_permission_denied_ui_and_camera_resume.md)

## Summary of Changes
Fixed false "Camera permission required" screen and eliminated `MobileScannerException(controllerNotAttached)` crashes.

1. **Fixed UI Branching Logic in `ScannerScreen.build()`**:
   - Explicitly separated camera permission checks (`!_hasPermission`) from camera initialization state checks (`!_isInitialized || controller == null`).
   - If permission is granted (`_hasPermission`), the UI shows either the live scanner (`_buildScanner()`) or a clean progress indicator (`Initializing camera...`), never the "Camera permission required" prompt.

2. **Mounted Controller Lifecycle Preservation**:
   - Preserved `controller` instance in `ScannerScreen` without setting it to `null` during route pushes/pops.
   - Relying on `didPushNext()` to pause preview (`controller.stop()`) and `didPopNext()` / route returns to resume preview (`controller.start()`) with automated retry logic after 300ms/400ms delay.

## Files Changed
- [lib/screens/scanner_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/scanner_screen.dart)
- [plans/20260731_192400_fix_false_permission_denied_ui_and_camera_resume.md](file:///l:/Android/sreeraj_qr_reader/plans/20260731_192400_fix_false_permission_denied_ui_and_camera_resume.md)

## Verification
- `flutter analyze`: 0 errors, 0 warnings.
- `flutter test`: 144/144 tests passed cleanly.
