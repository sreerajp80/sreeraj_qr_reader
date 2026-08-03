# Change Log: AR CodeVision — Spatial Multi-Target Real-Time Camera HUD

**Plan reference:** [`plans/20260731_211800_ar_codevision_hud.md`](file:///l:/Android/sreeraj_qr_reader/plans/20260731_211800_ar_codevision_hud.md)

## Summary of Changes
Implemented **Feature 3.4: AR CodeVision (Spatial Multi-Target Real-Time Camera HUD)**, an Augmented Reality (AR) live viewport system that continuously scans, tracks, and anchors interactive 3D Material 3 (M3) floating chips over every visible barcode and QR code simultaneously in the camera frame without pausing the video feed.

## Files Created
- [`lib/models/ar_code_target.dart`](file:///l:/Android/sreeraj_qr_reader/lib/models/ar_code_target.dart): Immutable domain model for tracked code targets in camera space.
- [`lib/services/ar_spatial_service.dart`](file:///l:/Android/sreeraj_qr_reader/lib/services/ar_spatial_service.dart): Spatial coordinate conversion, target position calculation, target expiration decay, and product format/price metadata generation.
- [`lib/providers/ar_codevision_provider.dart`](file:///l:/Android/sreeraj_qr_reader/lib/providers/ar_codevision_provider.dart): State provider for AR CodeVision HUD mode, real-time multi-target tracking, batch multi-selection, and asynchronous URL safety checks.
- [`lib/screens/widgets/ar_floating_chip_widget.dart`](file:///l:/Android/sreeraj_qr_reader/lib/screens/widgets/ar_floating_chip_widget.dart): Interactive Material 3 floating chip anchored over barcodes in physical viewport space. Supports Warehouse mode (Price + Batch Checkbox) and Safety HUD mode (Green Shield / Red Warning badge).
- [`lib/screens/widgets/ar_action_sheet.dart`](file:///l:/Android/sreeraj_qr_reader/lib/screens/widgets/ar_action_sheet.dart): Non-blocking floating bottom sheet for target inspection.
- [`lib/screens/ar_codevision_screen.dart`](file:///l:/Android/sreeraj_qr_reader/lib/screens/ar_codevision_screen.dart): AR camera viewport HUD screen with mode switcher, flashlight toggle, live target overlay, and batch selection footer.
- [`test/services/ar_spatial_service_test.dart`](file:///l:/Android/sreeraj_qr_reader/test/services/ar_spatial_service_test.dart): Unit tests for spatial coordinate conversion, target center math, and target decay.
- [`test/providers/ar_codevision_provider_test.dart`](file:///l:/Android/sreeraj_qr_reader/test/providers/ar_codevision_provider_test.dart): Unit tests for HUD mode switching, target tracking updates, and batch selection.

## Files Modified
- [`lib/main.dart`](file:///l:/Android/sreeraj_qr_reader/lib/main.dart): Registered `ArCodevisionProvider` in `MultiProvider` and set up `/ar_codevision` route.
- [`lib/screens/scanner_screen.dart`](file:///l:/Android/sreeraj_qr_reader/lib/screens/scanner_screen.dart): Added AR CodeVision button to scanner screen App Bar.

## Verification
1. `flutter analyze` completed with 0 errors and 0 warnings.
2. `flutter test` passed all 140 unit and provider tests.
