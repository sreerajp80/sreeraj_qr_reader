# Fix False "Permission Required" UI Screen & Ensure Seamless Camera Resume

**Status:** Approved

## Problem Analysis
1. **False "Camera Permission Required" Screen**:
   - In `ScannerScreen.build()`, body branching evaluated `_hasPermission && _isInitialized && controller != null ? _buildScanner() : _buildPermissionRequest()`.
   - Whenever `controller` was unmounted or initializing, it falsely evaluated to false and rendered `_buildPermissionRequest()` ("Camera permission required"), even when camera permission was already granted.
2. **Controller Attachment Exception (`controllerNotAttached`)**:
   - Setting `controller = null` unmounted `MobileScanner` from the Flutter widget tree. Calling `start()` on a new controller before `MobileScanner` was attached in the tree threw `MobileScannerException(controllerNotAttached)`.

## Solution
1. **Proper Permission vs Initialization UI Branching**:
   - In `ScannerScreen.build()`, check `!_hasPermission` first. If false, show `_buildPermissionRequest()`.
   - If `_hasPermission` is true, show `_buildScanner()` when `_isInitialized && controller != null`, otherwise show `Initializing camera...` spinner.
2. **Maintain Mounted Controller Lifecycle**:
   - Retain `controller` instance in `ScannerScreen` once created in `_initializeScanner()`.
   - Rely on `RouteObserver` (`didPushNext()` / `didPopNext()`) to call `controller.stop()` on navigation and `controller.start()` on return with fallback retry after a 300ms/400ms delay for native Android `Camera2` hardware release.

## Files Modified
- [lib/screens/scanner_screen.dart](../lib/screens/scanner_screen.dart)

## Verification Plan
### Automated Verification
- `flutter analyze`
- `flutter test`

### Manual Verification
- Verify `ScannerScreen` never displays "Camera permission required" when permission is already granted.
- Verify camera resumes automatically upon returning from `AirQR Stream Receiver` or `AR CodeVision HUD`.
