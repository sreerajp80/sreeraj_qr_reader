# Change Plan: Settings Screen Card Layout & About Migration

**Status:** Pending Approval

## Proposed Changes

### UI Layer

#### [MODIFY] [lib/screens/settings_screen.dart](../lib/screens/settings_screen.dart)
- Refactor main `SettingsScreen` to display a clean card-based hub layout where each section is an interactive `Card` / `ListTile`:
  1. **Appearance & Theme Card** (`Icons.palette_outlined`): Displays active theme mode and dynamic colors status. Tapping opens `AppearanceSettingsScreen`.
  2. **Customizable Scan Overlay Card** (`Icons.layers_outlined`): Displays currently active overlay style (Laser Line, Pulsing Corners, etc.). Tapping opens `ScanOverlaySettingsScreen`.
  3. **Scan Feedback & Alerts Card** (`Icons.vibration`): Displays status of vibration and sound feedback. Tapping opens `ScanFeedbackSettingsScreen`.
  4. **Privacy Card** (`Icons.security`): Displays active online probing status. Tapping opens `PrivacySettingsScreen`.
  5. **Google Safe Browsing API Card** (`Icons.shield_outlined`): Displays API key configuration status and today's usage. Tapping opens `SafeBrowsingSettingsScreen`.
  6. **About Card** (`Icons.info_outline`): Displays app version and developer info. Tapping opens `AboutScreen`.
- Implement dedicated detail sub-page scaffolds (`AppearanceSettingsScreen`, `ScanOverlaySettingsScreen`, `ScanFeedbackSettingsScreen`, `PrivacySettingsScreen`, `SafeBrowsingSettingsScreen`) providing back navigation to the Settings hub.

#### [MODIFY] [lib/screens/about_screen.dart](../lib/screens/about_screen.dart)
- Keep existing `AboutScreen` interface clean and ensure seamless integration when navigated to from the `SettingsScreen` About Card.

---

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure clean static analysis without warnings or errors.
- Run `flutter test` to verify all unit and widget tests pass.

### Manual Verification
- Launch the app with `flutter run --flavor dev` or verify card navigation between Settings hub and each detail subpage (Appearance, Scan Overlay, Scan Feedback, Privacy, Safe Browsing, About).
