# Change Log: Fix Text Contrast in Help & Feature Guides for Dark/OLED Theme

**Plan Reference:** [plans/20260801_194000_fix_help_card_contrast_dark_theme.md](../plans/20260801_194000_fix_help_card_contrast_dark_theme.md)

## Summary of Changes
- Fixed illegible dark text contrast on the **Help & Feature Guides** page (`HelpSettingsScreen`) in Dark Mode and OLED Pure Black mode.
- Replaced hardcoded `Colors.grey[800]` on key capability bullet points with `Theme.of(context).colorScheme.onSurfaceVariant`.
- Text now dynamically adapts with crisp, high-contrast legibility across all theme modes (Light, Dark, and OLED).

## Files Modified
- `lib/screens/settings_screen.dart`
- `plans/20260801_194000_fix_help_card_contrast_dark_theme.md`
- `change_log/20260801_194500_fix_help_card_contrast_dark_theme.md`
