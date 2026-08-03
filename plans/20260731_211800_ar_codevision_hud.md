# Plan: AR CodeVision — Spatial Multi-Target Real-Time Camera HUD

**Status:** Completed

## Overview
Implement **AR CodeVision**, an Augmented Reality (AR) camera viewport engine that continuously scans, tracks, and anchors interactive Material 3 floating chips over every visible barcode and QR code simultaneously in real-time camera space without stopping the live video preview.

## Issue / Requirement
Implement Feature 3.4 (AR CodeVision):
- Continuous Multi-Target Tracking: Track multiple bounding boxes across video frame without freezing scanner screen.
- Interactive Floating Tags: Anchor interactive floating chips over every detected code.
- Warehouse / Store Mode: Shows price tags, barcode format name, and batch select checkboxes.
- Safety HUD Mode: Displays Green Shield (safe) or Red Warning badge (suspicious/malicious) above URL links floating in physical space.
- Tap-to-Expand Action Sheets: Tapping any floating tag in camera space expands its action sheet without stopping live preview.

## Architecture & Layering
- **Models (`lib/models/`)**:
  - `ar_code_target.dart`: Model for a tracked code target (ID, raw value, format, corners, bounding box, safety status, price tag, batch checkbox state, timestamp).
- **Service (`lib/services/`)**:
  - `ar_spatial_service.dart`: Handles camera image to viewport screen coordinate transformation, target position smoothing, target expiration/decay, and retail metadata generation.
- **Provider (`lib/providers/`)**:
  - `ar_codevision_provider.dart`: Provider managing HUD mode (Warehouse vs Safety), active tracked target state, batch selection, and live safety check integration.
- **Widgets (`lib/screens/widgets/`)**:
  - `ar_floating_chip_widget.dart`: Animated Material 3 chip widget positioned in 3D/2D viewport space over target coordinates.
  - `ar_action_sheet.dart`: Floating/bottom action sheet displaying item breakdown on tap.
- **Screen (`lib/screens/`)**:
  - `ar_codevision_screen.dart`: Main AR viewport camera HUD with HUD mode toggle header, multi-target spatial overlay, batch actions footer, and live preview.
- **Scanner Integration (`lib/screens/scanner_screen.dart`)**:
  - Add AR CodeVision shortcut button (`view_in_ar`) to main scanner AppBar.
- **App Core (`lib/main.dart`)**:
  - Register `ArCodevisionProvider` in `MultiProvider` and register `/ar_codevision` named route.

## Files to Create
- `lib/models/ar_code_target.dart`
- `lib/services/ar_spatial_service.dart`
- `lib/providers/ar_codevision_provider.dart`
- `lib/screens/widgets/ar_floating_chip_widget.dart`
- `lib/screens/widgets/ar_action_sheet.dart`
- `lib/screens/ar_codevision_screen.dart`
- `test/services/ar_spatial_service_test.dart`
- `test/providers/ar_codevision_provider_test.dart`

## Files to Modify
- `lib/main.dart`
- `lib/screens/scanner_screen.dart`

## Verification Plan
1. Run `flutter analyze` to ensure clean zero-warning build.
2. Run `flutter test` including new unit tests for `ArSpatialService` and `ArCodevisionProvider`.
