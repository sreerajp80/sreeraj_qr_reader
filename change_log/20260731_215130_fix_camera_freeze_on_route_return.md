# Fix Camera Preview Freeze When Returning from AR CodeVision & AirQR Screens

**Reference Plan:** [plans/20260731_215100_fix_camera_freeze_on_route_return.md](../plans/20260731_215100_fix_camera_freeze_on_route_return.md)

## Summary of Changes
Fixed black/frozen camera preview on the main scanner screen after navigating back from AR CodeVision HUD or AirQR Stream Receiver screen.

## Detailed Changes

### `lib/screens/scanner_screen.dart`
- Added `WidgetsBindingObserver` to manage camera lifecycle across Android app lifecycle events (paused, hidden, resumed).
- Added `_navigateToRoute(routeName)` helper:
  - Calls `controller.stop()` before pushing secondary camera screens or route destinations.
  - Automatically calls `controller.start()` upon popping back to re-acquire native camera hardware session.
- Updated `_handleBarcode` so camera stops cleanly before pushing `/result` route and restarts cleanly upon popping back.
- Updated all `AppBar` action buttons to use `_navigateToRoute`.

### `lib/screens/ar_codevision_screen.dart`
- Added `WidgetsBindingObserver` mixin to manage camera controller start/stop on background/foreground transitions.

### `lib/screens/air_qr_screen.dart`
- Added `WidgetsBindingObserver` mixin for app lifecycle events.
- Added camera stop and restart around `AirQrTransmitter` route transition.

## Verification Results
- `flutter analyze`: Passed with **0 warnings / 0 errors**.
- `flutter test`: All **140 tests passed**.
