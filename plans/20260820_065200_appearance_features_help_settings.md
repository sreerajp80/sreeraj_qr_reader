# Plan: Replicate Appearance, Features, and Help Cards under Settings

**Status:** Completed

## Files to Change
1. `lib/l10n/app_en.arb` - Add localization strings and `@key` descriptions for Appearance, Features, and Help screens, categories, topics, and guides.
2. `lib/screens/settings_screen.dart` - Update settings cards layout, Appearance card, Features card, and Help card to match ContactSphere design patterns.
3. `lib/screens/appearance_screen.dart` - Implement Appearance hub screen with sub-cards for Theme Mode, Accent Color & Dynamic Colors, Scan Overlay Style, and Typography & Text Size.
4. `lib/screens/appearance/theme_mode_settings_screen.dart` - Dedicated Theme Mode settings screen (Light, Dark, OLED, System).
5. `lib/screens/appearance/scan_overlay_settings_screen.dart` - Dedicated Scan Overlay style settings screen.
6. `lib/screens/appearance/accent_color_settings_screen.dart` - Dedicated Accent Color & Dynamic Color settings screen.
7. `lib/screens/appearance/typography_settings_screen.dart` - Dedicated Typography & Text Scale settings screen.
8. `lib/screens/features_screen.dart` - Implement rich categorized Features screen with gradient header card, section headers, and feature cards with highlight chips.
9. `lib/screens/help/help_home_screen.dart` - Implement Help Center hub screen with gradient header and categorized topic cards.
10. `lib/screens/help/barcode_scanning_help_screen.dart` - Barcode & Media Scanning help guide.
11. `lib/screens/help/ar_codevision_help_screen.dart` - AR CodeVision Spatial HUD help guide.
12. `lib/screens/help/air_qr_help_screen.dart` - AirQR Optical Data Stream help guide.
13. `lib/screens/help/url_safety_help_screen.dart` - 6-Layer URL Safety Engine help guide.
14. `lib/screens/help/quishing_guard_help_screen.dart` - QuishingGuard Physical Tamper Detection help guide.
15. `lib/screens/help/safe_browsing_help_screen.dart` - Google Safe Browsing Setup help guide.
16. `lib/screens/help/smart_payloads_help_screen.dart` - Smart Actions & Payments help guide.
17. `lib/screens/help/history_privacy_help_screen.dart` - History, Backups & Biometric Security help guide.
18. `lib/screens/help/faq_troubleshooting_help_screen.dart` - FAQ & Troubleshooting help guide.
19. `test/screens/settings_screen_test.dart` - Update tests for new Appearance, Features, and Help screens and cards.

## Issue
The Settings screen currently uses basic flat cards and lacks dedicated, rich showcase screens for:
1. **Appearance**: It has limited sub-settings directly crammed in one screen instead of a modular hub covering Theme Mode, Accent Colors, Typography, and Scan Overlay styles.
2. **Features**: It is missing a comprehensive Features showcase screen like ContactSphere, which highlights all offline barcode capabilities, 6-layer URL security, QuishingGuard, AR CodeVision, AirQR, and smart payloads.
3. **Help & Guides**: The existing Help screen is a basic single list with accordion tiles instead of a categorized Help Hub with dedicated in-depth user guide screens.

## Fix
1. **Settings Cards & Visual Polish**:
   - Modernize the Settings list cards with 48x48 rounded icon containers, vibrant primary tint backgrounds, crisp typography, and chevron indicators matching ContactSphere aesthetics.
2. **Appearance Hub & Modular Screens**:
   - Create `AppearanceScreen` linking to:
     - `ThemeModeSettingsScreen` (Light, Dark, True OLED Pure Black, System).
     - `AccentColorSettingsScreen` (Material You Dynamic Colors toggle and customizable accent palettes with live preview).
     - `ScanOverlaySettingsScreen` (Laser line, Pulsing corners, Cybernetic grid, Subtle dot matrix).
     - `TypographySettingsScreen` (App font families and text scale adjustment).
3. **Features Screen**:
   - Implement `FeaturesScreen` with:
     - Top gradient brand header card.
     - Categorized sections: Core Scanning & Ingestion, 6-Layer URL Safety Engine, QuishingGuard & Advanced Vision, Smart Payloads & Integrations, and History, Backup & Privacy Vault.
     - Rich feature tiles with icon badges, descriptive text, and highlight chip tags.
4. **Help Center Hub & Dedicated Topic Screens**:
   - Implement `HelpHomeScreen` with:
     - Header card: Help Center & User Guides.
     - Grouped categories: Scanning & Ingestion Guides, Security & Threat Defense, and Payloads, Storage & Privacy.
     - Dedicated screens for all 9 topics with intro headers, icon sections, bullet points, and pro tip footers.
5. **Localization & Testing**:
   - Add all ARB localization keys and run `flutter gen-l10n`.
   - Update tests in `test/screens/settings_screen_test.dart` to verify all cards and navigations.
   - Run `flutter analyze` and `flutter test` to ensure clean static analysis and passing test suite.
