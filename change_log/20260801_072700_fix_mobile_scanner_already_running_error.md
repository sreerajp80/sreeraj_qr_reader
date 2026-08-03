# Fix MobileScannerController Already Running Error & Stale Camera Viewport

**Reference Plan:** [plans/20260801_072500_fix_mobile_scanner_already_running_error.md](../plans/20260801_072500_fix_mobile_scanner_already_running_error.md)

## Summary of Changes
Fixed the `MobileScannerController is already running. Stop it before starting again` viewport error and stale native camera texture when navigating between the main scanner and secondary camera screens (AR CodeVision and AirQR Stream Receiver).

## Detailed Changes

### `lib/screens/scanner_screen.dart`
- **Re-initialize Controller for Camera Routes**: In `_navigateToRoute`, when pushing `/ar_codevision` or `/air_qr`, cleanly dispose the old `MobileScannerController` instance and reset `_isInitialized`. Upon returning, call `_initializeScanner()` to create a fresh controller with clean native hardware texture bindings.
- **`isRunning` Guard Checks**: Added `controller.value.isRunning` check before all `start()` and `stop()` calls to prevent calling `start()` when already running.
- **Custom `errorBuilder`**: Added user-friendly `errorBuilder` to `MobileScanner` to display a subtle initialization card instead of unhandled raw plugin error strings.

### `lib/screens/ar_codevision_screen.dart`
- Wrapped `_controller.start()` and `_controller.stop()` in `didChangeAppLifecycleState` with `!_controller.value.isRunning` / `_controller.value.isRunning` guards and try-catch blocks.
- Added custom `errorBuilder` to `MobileScanner` widget.

### `lib/screens/air_qr_screen.dart`
- Added `isRunning` guards and try-catch blocks around camera start/stop methods.
- Added custom `errorBuilder` to `MobileScanner` widget.

## Verification Results
- `dart format .`: Formatted all files cleanly.
- `flutter analyze`: Passed with **0 warnings / 0 errors**.
- `flutter test`: Passed all **144 tests**.
