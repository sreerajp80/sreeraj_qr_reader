# Plan: Move Settings, History, AR CodeVision HUD, and AirQR Stream Receiver to Dotted Overflow Menu

**Status:** Completed

## Problem / Background
The top app bar of `ScannerScreen` currently displays six individual icon action buttons:
1. Gallery Image scan (`Icons.photo_library`)
2. PDF Document scan (`Icons.picture_as_pdf`)
3. AR CodeVision HUD (`Icons.view_in_ar`)
4. AirQR Stream Receiver (`Icons.sensors`)
5. History (`Icons.history`)
6. Settings (`Icons.settings`)

This clutters the app bar on mobile screens. We will keep direct icon buttons for primary scanning actions (Gallery and PDF) and move Settings, History, AR CodeVision HUD, and AirQR Stream Receiver into a standard Material dotted overflow menu (`PopupMenuButton`).

## Proposed Changes

### `lib/screens/`

#### [MODIFY] [scanner_screen.dart](../lib/screens/scanner_screen.dart)
- In the `appBar` actions list:
  - Keep `IconButton` for Gallery scan.
  - Keep `IconButton` for PDF scan.
  - Remove individual `IconButton`s for AR CodeVision HUD, AirQR Stream Receiver, History, and Settings.
  - Add a `PopupMenuButton<String>` with icon `Icons.more_vert` containing options for:
    - **AR CodeVision HUD** (`value: '/ar_codevision'`, icon `Icons.view_in_ar`)
    - **AirQR Stream Receiver** (`value: '/air_qr'`, icon `Icons.sensors`)
    - **History** (`value: '/history'`, icon `Icons.history`)
    - **Settings** (`value: '/settings'`, icon `Icons.settings`)

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure 0 lint warnings or static analysis errors.
- Run `flutter test` to verify all unit & widget tests pass cleanly.

### Manual Verification
- Launch the app and verify the app bar top right displays Gallery, PDF, and a three-dot overflow menu icon.
- Tap the three-dot overflow menu icon and verify that AR CodeVision HUD, AirQR Stream Receiver, History, and Settings menu options appear.
- Tap each menu option to confirm proper navigation to its respective screen.
