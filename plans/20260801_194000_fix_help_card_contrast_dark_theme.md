# Plan: Fix Contrast for Help Card Items in Dark/OLED Theme

**Status:** Completed

## Files to Change
1. `lib/screens/settings_screen.dart` - Replace hardcoded `Colors.grey[800]` with `Theme.of(context).colorScheme.onSurfaceVariant` so text adapts with high contrast in both light and dark/OLED themes.

## Issue
In the Help & Feature Guides card (`HelpSettingsScreen`), key capability list items were hardcoded with `color: Colors.grey[800]`. In dark mode and OLED pure black mode, dark grey text (`#424242`) against a dark background renders the text unreadable (nearly invisible).

## Fix
In `_buildHelpCard` inside `HelpSettingsScreen`:
- Change `color: Colors.grey[800]` to `color: Theme.of(context).colorScheme.onSurfaceVariant`.
- This dynamically resolves to legible light text in dark/OLED mode and appropriate dark text in light mode.
