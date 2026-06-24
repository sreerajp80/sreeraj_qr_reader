# Change Log: Add "Made with ❤️ from India" footer to About screen

Implements plan: `plans/20260624_085904_about-made-with-love-footer.md`

## What changed
- `lib/screens/about_screen.dart`: Added a centered "Made with ❤️ from India" text line
  to the About screen footer, placed below the existing copyright line and above the
  final bottom spacer. Styled with `textTheme.bodySmall` and `Colors.grey[600]` to match
  the copyright line. Inserted an 8px spacer between the copyright and the new line.

## Verification
- `flutter analyze lib/screens/about_screen.dart` — No issues found.
- No logic, state, or dependency changes; purely presentational.
