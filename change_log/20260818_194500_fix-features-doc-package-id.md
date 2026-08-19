# Fixed wrong package id in docs/features.md

Implements plan `plans/20260818_193934_fix-features-doc-package-id.md`.

## What was wrong

`docs/features.md`, in the "Key technical facts" table, gave the app package id as
`in.sreerajp.qr_reader` — an extra `p` after `sreeraj`. The real id, set as `applicationId`
in `android/app/build.gradle`, is `in.sreeraj.qr_reader`.

Three wrong ids sat in two rows:

- the "App package" row,
- the "Build flavors" row, which named both the `.dev` id and the plain one.

## What changed

- `docs/features.md` — replaced all three occurrences of `in.sreerajp.qr_reader` with
  `in.sreeraj.qr_reader`. The rows now read:
  - App package: `in.sreeraj.qr_reader`
  - Build flavors: `dev` (`in.sreeraj.qr_reader.dev`) and `prod` (`in.sreeraj.qr_reader`)

No other file was changed.

## Checks done

- Confirmed the new value matches `applicationId` in `android/app/build.gradle`.
- Searched all of `docs/` for the old spelling — no hits left.
- No Dart source was touched, so `flutter analyze` / `flutter test` were not run.

## Noted, left alone

- Two older change log files still contain the old spelling. They are historical records of
  what happened at the time, so they were not edited. One of them shows the typo was
  introduced by an earlier change that treated the correct id as a typo and "fixed" it the
  wrong way.
- `test/core/config/app_config_test.dart` uses the old spelling as mock data in one test.
  It is a made-up value for a mock `PackageInfo` and is not compared against the real app id,
  so nothing fails. It is outside this plan's scope and was left as is.
