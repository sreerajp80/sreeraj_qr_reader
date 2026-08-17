# Change log — `CLAUDE.md` and `AGENTS.md` brought up to the new guidelines

Implements plan: `plans/20260817_220700_claude-agents-md-conformance.md`

## Files changed

- `CLAUDE.md`
- `AGENTS.md`

## What changed in both files

1. **New "Localization rules" section**, placed after "Security rules" and before
   "Code style / naming", as the guideline templates require. It states:
   - all user-visible text comes from `lib/l10n/*.arb` through `AppLocalizations`, never a raw
     literal in a widget, even though the app ships English only;
   - `l10n.yaml` and `lib/l10n/app_en.arb` must exist; run `flutter gen-l10n` after editing ARB;
   - every ARB key needs an `@key` description;
   - services must not hold user-visible text — they return an `AppMessage` (key plus arguments)
     and the screen turns it into text;
   - the allowed literal exceptions (logs, non-UI exceptions, asset paths, route names, map and
     JSON keys, barcode protocol tokens, CSV/JSON export headers).
2. **Workflow rules gained rule 3** — relative repository paths only, no local system details,
   no secrets, worded as in the guideline templates.
3. **Docs table** now lists the three new guideline documents: `CLAUDE_MD_GUIDELINE.md`,
   `AGENTS_MD_GUIDELINE.md`, `DOCS_FOLDER_GUIDELINE.md`.
4. **Dos & Don'ts** gained one line: never hard-code user-visible text in a widget.

## What changed in `AGENTS.md` only

5. **Package id corrected.** It said `in.sreerajp.qr_reader` (with an extra `p`) in the identity
   table and in both build-flavor rows. The real id in `android/app/build.gradle` is
   `in.sreeraj.qr_reader`. All three are fixed, so the two root files now agree.
6. **Read-first banner fixed.** It said the file is read by Claude Code. It now says it is read by
   AI agents and LLM assistants, and adds a line telling the reader to keep `AGENTS.md` and
   `CLAUDE.md` in step.
7. **Dos & Don'ts retitled** from "What Claude must always / never do" to "What AI agents must
   always / never do", and its first line now says to read `AGENTS.md` first.

## Verification

- Both files were re-checked against `docs/guidelines/CLAUDE_MD_GUIDELINE.md` §8 and
  `docs/guidelines/AGENTS_MD_GUIDELINE.md` §9.
- Section order in both files matches the canonical order in §2 of each guideline.
- A search confirms the wrong package id no longer appears in either file.
- Documentation only — no code changed.

## Still wrong elsewhere (not fixed — outside this plan)

The same package-id error exists in `docs/features.md` (the "App package" row and the build
flavors row still say `in.sreerajp.qr_reader`). It was introduced on purpose by the change
`change_log/20260812_200706_update_docs_features_md.md`, which "fixed" the id in the wrong
direction. `docs/features.md` was not in this plan's file list, so it is left alone and reported
here. It needs its own small plan.
