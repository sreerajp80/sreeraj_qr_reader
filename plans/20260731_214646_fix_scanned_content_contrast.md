# Fix Scanned Content Low Contrast in Dark/OLED Mode and Night Light

**Status:** Proposed

## Problem
In `lib/screens/result_screen.dart`, the `_buildContentCard` widget renders scanned text inside a container with a fixed light background (`Colors.grey[100]`). In Dark Mode / OLED mode, the default text color is light (`onSurface` / white / light yellow dynamic theme color).
When light text is rendered on a light gray background, contrast is lost. When Night Light (blue light filter) is enabled on the PC/system, the light colors turn yellow, causing yellowish text on a yellowish background which is completely unreadable.

## Files to Change
- [lib/screens/result_screen.dart](file:///l:/Android/sreeraj_qr_reader/lib/screens/result_screen.dart)

## Proposed Changes

### `lib/screens/result_screen.dart`
1. **Content Display Card (`_buildContentCard`)**:
   - Check if current theme brightness is `Brightness.dark`.
   - Set container background to `theme.colorScheme.surfaceContainerHighest` (dark background) in Dark Mode and `Colors.grey[100]` in Light Mode.
   - Set border color to `theme.colorScheme.outline.withValues(alpha: 0.4)` in Dark Mode and `Colors.grey[300]` in Light Mode.
   - Set text color explicitly to `theme.colorScheme.onSurface` in Dark Mode and `Colors.black87` in Light Mode.

2. **Secret Payload Display Container**:
   - Adapt container background color to `theme.colorScheme.surfaceContainerHighest` in Dark Mode instead of hardcoded `Colors.white`.
   - Set explicit text color `theme.colorScheme.onSurface`.

3. **URL Safety & Detailed Check Cards**:
   - Update background and text colors to use high-contrast dark palette variants (e.g. `Colors.red[950]`, `Colors.green[950]`, `Colors.orange[950]` for backgrounds with `Colors.red[200]`, `Colors.green[200]`, `Colors.orange[200]` for text in Dark Mode).

## Verification Plan
1. Run `flutter analyze` to ensure 0 warnings and no deprecated member usages (use `.withValues(alpha: 0.4)` instead of `.withOpacity`).
2. Run `flutter test` to ensure all existing tests pass cleanly.
