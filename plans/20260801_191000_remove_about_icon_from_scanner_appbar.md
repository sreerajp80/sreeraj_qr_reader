# Plan: Remove Redundant About Icon from Scanner Screen Top Bar

**Status:** Completed

## Problem / Background
The **About** section was moved inside the **Settings** screen as an About Card. However, the top `AppBar` of `ScannerScreen` still contains a separate `IconButton` for `Icons.info_outline` pointing to `/about`. Having both a Settings icon and an About icon in the top action bar is redundant since About is accessible inside Settings.

## Proposed Changes

### `lib/screens/`

#### [MODIFY] [scanner_screen.dart](../lib/screens/scanner_screen.dart)
- Remove the `IconButton` for `Icons.info_outline` from the `actions` list in the `AppBar`.
- Keep the `Icons.settings` action, which allows accessing Settings (and About within it).

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure 0 static analysis errors/warnings.
- Run `flutter test` to ensure all tests pass cleanly.

### Manual Verification
- Verify that only the Settings gear icon (and other intended action icons) remain in the Scanner screen top bar.
- Verify that tapping Settings leads to the Settings screen, where the About card opens the About screen as expected.
