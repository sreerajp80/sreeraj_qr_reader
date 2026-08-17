# Change Log: Add Last Build Date to About Screen

**Plan Reference:** [plans/20260731_215400_add_last_build_date_about_screen.md](../plans/20260731_215400_add_last_build_date_about_screen.md)

## Summary of Changes

- **Configuration Layer**: Added `"Last build": "2026-07-31"` to the `details` map in [assets/config/app_config.json](../assets/config/app_config.json).
- **UI Layer**: Added mapping for `'build'` and `'date'` keys in `_getIconForKey` within [lib/screens/about_screen.dart](../lib/screens/about_screen.dart) to display `Icons.calendar_today`.
- **Testing Layer**: Updated [test/core/config/app_config_test.dart](../test/core/config/app_config_test.dart) to verify `AppConfig.fromJson` parses `"Last build"` correctly.

## Verification

- `flutter analyze`: 0 issues found.
- `flutter test`: 140/140 tests passed.
