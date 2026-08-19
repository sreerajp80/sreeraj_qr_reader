# Fix wrong package id in docs/features.md

**Status:** completed

## Issue

`docs/features.md` lists the app package id as `in.sreerajp.qr_reader` (extra `p` after
`sreeraj`). The real id, set in `android/app/build.gradle`, is `in.sreeraj.qr_reader`.

Two rows in the "Key technical facts" table are wrong:

- Line 266 — `| App package | \`in.sreerajp.qr_reader\` |`
- Line 272 — the build flavors row, which names both `in.sreerajp.qr_reader.dev` and
  `in.sreerajp.qr_reader`

So there are three wrong ids across two rows.

This was found earlier but left alone, because it sits outside the three plans that were
approved before. It gets its own plan here.

## Files to change

- `docs/features.md` — fix the package id in the two table rows.

## Plan for the fix

1. Replace every `in.sreerajp.qr_reader` in `docs/features.md` with `in.sreeraj.qr_reader`.
   This covers the plain id and the `.dev` suffixed one.
2. Check no other file under `docs/` has the same typo; if any do, they stay out of scope
   and get reported, not changed.
3. Confirm the fixed value matches `applicationId` in `android/app/build.gradle`.

## Not in scope

- No code change. This is a documentation text fix only.
- No `flutter analyze` / `flutter test` run needed, since no Dart source is touched.
