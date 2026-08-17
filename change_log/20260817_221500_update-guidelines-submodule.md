# Change log — Update `docs/guidelines` submodule

Implements plan: `plans/20260817_220145_update-guidelines-submodule.md`

## What changed

- `docs/guidelines` submodule moved from `4b7e85a` to `2b381be` (branch `master`).
- The new pointer was staged and committed in this repository.
- No app source, test, asset, or build file was touched.

## What came in

Two upstream commits (`aed1261` "Features", `2b381be` "Update"), about 1714 lines
added across 23 files.

New guideline documents:

- `AGENTS_MD_GUIDELINE.md` — mandatory rules for a project-root `AGENTS.md`
- `CLAUDE_MD_GUIDELINE.md` — mandatory rules for a project-root `CLAUDE.md`
- `DOCS_FOLDER_GUIDELINE.md` — how to create files in a project `docs/` folder

Updated documents:

- `GUIDELINES_MANIFEST.md` — now lists the three new documents and marks
  `CLAUDE.md` / `AGENTS.md` as MUST in the `Core Baseline` profile
- `guideline.md` — new MUST rules for `CLAUDE.md`, `AGENTS.md`, l10n, and the
  plans/change_log privacy rule
- `flutter_project_engineering_standard.md` — §8.2 string externalization is now
  mandatory for every app; new §21.1.1 privacy rule for `plans/` and `change_log/`
- `README.md`, `docs/flutter_project_engineering_standard_README.md`

## Verification

- `git submodule status` reports `2b381be docs/guidelines (heads/master)`.
- The submodule work tree is clean.
- The parent repo commit contains only the submodule pointer and the plan file.
- Nothing was pushed.

## Gaps found (not fixed here — out of scope)

The new guidelines add rules this project does not yet meet:

1. **Localization (engineering standard §8.2, now `Core Baseline` and mandatory).**
   The project has no `l10n.yaml` and no `lib/l10n/app_en.arb`. All user-visible
   text is still written as string literals in widgets. The new rule says every
   app must externalize strings into ARB files even when it ships one language.
   This is the largest gap and needs its own plan.
2. **Privacy rule for `plans/` and `change_log/` (§21.1.1).**
   Many existing files in `plans/` and `change_log/` contain absolute drive-letter
   paths from the machine they were written on. The new rule requires relative
   repository paths only. A clean-up pass would be needed.
3. **`AGENTS.md` and `CLAUDE.md` conformance.** Both files exist at the project
   root, but they have not been checked line by line against the new
   `AGENTS_MD_GUIDELINE.md` and `CLAUDE_MD_GUIDELINE.md`.

Each of these should get its own plan before any work starts.
