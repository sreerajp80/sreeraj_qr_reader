# Fix Scanned Content Low Contrast in Dark/OLED Mode & Night Light

**Reference Plan:** [plans/20260731_214646_fix_scanned_content_contrast.md](../plans/20260731_214646_fix_scanned_content_contrast.md)

## Summary of Changes
Fixed unreadable text in the Scan Result screen (`lib/screens/result_screen.dart`) when using Dark Mode, OLED mode, or when system Night Light (blue light filter) is enabled.

## Detailed Changes

### `lib/screens/result_screen.dart`
- **`_buildContentCard`**:
  - Dynamically detects `Theme.of(context).brightness == Brightness.dark`.
  - In Dark/OLED mode, container background uses `theme.colorScheme.surfaceContainerHighest`, border uses `theme.colorScheme.outline.withValues(alpha: 0.4)`, and text color uses `theme.colorScheme.onSurface` (high-contrast white/light text).
  - In Light mode, uses `Colors.grey[100]` background with `Colors.black87` text.
- **Stego Secret Payload Container**:
  - Replaced hardcoded `Colors.white` container background with theme-aware `isDark ? theme.colorScheme.surfaceContainerHighest : Colors.white`.
  - Applied `theme.colorScheme.onSurface` text color.
- **Safety Cards & Probing Mode Banner**:
  - Added dark mode color palette variants (`Colors.red[950]`, `Colors.orange[950]`, `Colors.green[950]`) with light text (`Colors.red[200]`, `Colors.orange[200]`, `Colors.green[200]`) to ensure WCAG high-contrast compliance in all dark modes.
- Replaced deprecated `.withOpacity(...)` calls with `.withValues(alpha: ...)`.

## Verification Results
- `flutter analyze lib/screens/result_screen.dart`: Passed cleanly (0 warnings, 0 errors).
- `flutter test`: Passed.
