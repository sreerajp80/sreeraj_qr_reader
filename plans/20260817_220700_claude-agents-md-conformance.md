# Bring `CLAUDE.md` and `AGENTS.md` up to the new guidelines

**Status:** completed

Gap 3 of 3. Do this one first — it writes down the rules the other two plans follow.

## Files to be changed

- `CLAUDE.md`
- `AGENTS.md`

## What the issue is

The updated submodule adds two mandatory guidelines: `docs/guidelines/CLAUDE_MD_GUIDELINE.md`
and `docs/guidelines/AGENTS_MD_GUIDELINE.md`. Both root files fail some of their checks.

### Problems in both files

1. **No "Localization rules" section.** Both guidelines now require one (§4 template,
   §8/§9 self-check). It must say all user-visible text comes from `lib/l10n/*.arb`
   through `AppLocalizations`, even though this app ships English only.
2. **Workflow rules are missing the new privacy clause.** Both guidelines require a third
   numbered rule: `plans/` and `change_log/` files use relative repository paths only and
   carry no local system details and no secrets.

### Problems only in `AGENTS.md`

3. **Wrong package id — a real error.** `AGENTS.md` says the id is `in.sreerajp.qr_reader`
   in three places (the identity table and both flavor rows). The real id in
   `android/app/build.gradle` is `in.sreeraj.qr_reader`, which is what `CLAUDE.md` says.
   The `AGENTS_MD_GUIDELINE.md` §8 anti-patterns forbid the two files disagreeing.
4. **Wrong read-first banner.** It says "read by Claude Code". `AGENTS.md` is the file for
   other LLMs and agents (Gemini, Cursor, Windsurf, Codex, and so on).
5. **Wrong Dos & Don'ts heading and first line.** It says "What Claude must always / never do"
   and "Read `CLAUDE.md` first". For `AGENTS.md` these should point at `AGENTS.md`.
6. **`docs/guidelines/` links are stale.** Neither file lists the three new guideline
   documents (`CLAUDE_MD_GUIDELINE.md`, `AGENTS_MD_GUIDELINE.md`, `DOCS_FOLDER_GUIDELINE.md`).

## Plan for the fix

1. Add a **Localization rules** section to both files, placed after "Security rules" and before
   "Code style / naming" (the position used by the guideline templates). Content:
   - all user-visible text comes from `lib/l10n/*.arb` through `AppLocalizations`, never a raw
     string literal in a widget, even though the app ships English only;
   - `l10n.yaml` and `lib/l10n/app_en.arb` must exist; run `flutter gen-l10n` after editing any
     `.arb` file;
   - every ARB key needs an `@key` description;
   - literals are allowed only for logs, non-UI exception messages, asset paths, route names,
     and map/JSON keys.
2. Add the third workflow rule (relative paths and privacy) to both files, worded as in the
   guideline templates.
3. In `AGENTS.md`, correct the package id to `in.sreeraj.qr_reader` in all three places.
4. In `AGENTS.md`, fix the read-first banner to name AI agents and LLMs, and retitle the
   Dos & Don'ts section to "What AI agents must always / never do" with "Read `AGENTS.md` first".
5. Add the three new guideline documents to the "Read these docs before working" table in both
   files.
6. Re-check both files against the §8 / §9 self-check lists in the two guidelines, and confirm
   the rules in `AGENTS.md` and `CLAUDE.md` now match each other.

## Note on ordering

The localization rule describes files that do not exist yet (`l10n.yaml`, `lib/l10n/app_en.arb`).
They are created by the plan `20260817_220900_l10n-full-externalization.md`. The guideline
template allows writing the rule for files that are planned, and the wording is correct as soon
as that plan lands.

## Verification

- Re-read both files against `docs/guidelines/CLAUDE_MD_GUIDELINE.md` §8 and
  `docs/guidelines/AGENTS_MD_GUIDELINE.md` §9.
- Confirm no absolute path or local system detail was added.
- No code changes, so `flutter analyze` and `flutter test` are unaffected, but both will still
  be run at the end of the whole batch.

## Risk

Very low. Documentation only.
