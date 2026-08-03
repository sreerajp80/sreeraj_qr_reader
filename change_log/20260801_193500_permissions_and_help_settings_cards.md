# Change Log: Add Permissions and Help Cards to Settings Screen

**Plan Reference:** [plans/20260801_193000_permissions_and_help_settings_cards.md](file:///l:/Android/sreeraj_qr_reader/plans/20260801_193000_permissions_and_help_settings_cards.md)

## Summary of Changes
Added two new settings cards and dedicated detail screens to the Settings section:
1. **Permissions Card & Overview Screen (`PermissionsSettingsScreen`)**:
   - Explicit permissions (Camera `android.permission.CAMERA`, Biometrics `android.permission.USE_BIOMETRIC`).
   - Implicit & system permissions (Internet `android.permission.INTERNET`, Vibration/Haptics `android.permission.VIBRATE`, Scoped Media Photo Picker).
   - Setting-dependent permissions (Active Online Probing HTTP requests, Google Safe Browsing API cloud lookup, Scan Feedback Haptics).
2. **Help & Feature Guides Card & Screen (`HelpSettingsScreen`)**:
   - **AR CodeVision HUD**: Multi-target spatial scanning, floating AR chips, camera controls, action sheet.
   - **AirQR Stream Receiver**: Optical sequence QR stream transfer, live progress tracking, camera/file input modes.
   - **URL Tamper Checking & Quishing Guard**: 6-layer URL safety engine (Homograph attack detection, zero-width space trickery, IP literal & userinfo checks, suspicious TLD analysis, URL shortener unrolling, Safe Browsing lookup), offline-first privacy guarantee.
3. **Widget Tests (`test/screens/settings_screen_test.dart`)**:
   - Added widget test coverage for rendering both cards and verifying navigation to `PermissionsSettingsScreen` and `HelpSettingsScreen`.

## Files Modified
- `lib/screens/settings_screen.dart`
- `test/screens/settings_screen_test.dart`
- `plans/20260801_193000_permissions_and_help_settings_cards.md`
- `change_log/20260801_193500_permissions_and_help_settings_cards.md`
