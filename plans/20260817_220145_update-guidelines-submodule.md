# Update `docs/guidelines` submodule

**Status:** completed

## Files to be changed

- `docs/guidelines` (submodule pointer, recorded in the parent repo's git index)

No app source, test, or doc file in this repo is edited.

## What the issue is

The `docs/guidelines` submodule (Flutter_Guidelines) is pinned to an old commit:

- Current pin: `4b7e85a` ("Changes")
- Latest on `origin/master`: `2b381be` ("Update")

Two new commits are missing locally:

1. `aed1261` — Features
2. `2b381be` — Update

These commits add and change the shared guideline documents this project must follow, including:

- New files: `AGENTS_MD_GUIDELINE.md`, `CLAUDE_MD_GUIDELINE.md`, `DOCS_FOLDER_GUIDELINE.md`
- Updated: `GUIDELINES_MANIFEST.md`, `README.md`, `guideline.md`,
  `flutter_project_engineering_standard.md` (about 1714 lines added in total)

Because the pin is old, this project is reading stale guidelines.

## Plan for the fix

1. In `docs/guidelines`, check out `origin/master` (`2b381be`) on the `master` branch.
2. Confirm the submodule work tree is clean and now points at `2b381be`.
3. In the parent repo, stage the new submodule pointer (`git add docs/guidelines`).
4. Commit the pointer bump in the parent repo with a short message.
5. Do **not** push unless asked.
6. Write the change log to `change_log/`.

Note: after the update, the new guideline files may ask for extra work in this
project (for example an `AGENTS.md` file or doc changes). That is **out of scope**
for this plan. I will read the new guidelines and report any gaps, then a separate
plan can be made if you want them fixed.

## Risk

Low. Only a submodule pointer moves. It can be undone by checking out the old
commit `4b7e85a` in `docs/guidelines`.
