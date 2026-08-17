# Remove absolute local paths from `plans/` and `change_log/`

**Status:** completed

Gap 2 of 3.

## Files to be changed

32 existing markdown files:

- 16 files in `plans/`
- 16 files in `change_log/`

No code, asset, or config file is touched. The exact list is produced by the search in step 1
below; every changed file is a plan or change log written before this rule existed.

## What the issue is

The updated engineering standard adds §21.1.1, a privacy rule for `plans/` and `change_log/`.
These files are committed and may become public. They must use **relative repository paths only**
and must not reveal the machine they were written on.

32 existing files break the rule. Every break is the same shape: a markdown link whose target is
an absolute path with a drive letter, for example a link pointing at
`file:///<drive>:/Android/<repo>/lib/screens/scanner_screen.dart` instead of
`lib/screens/scanner_screen.dart`.

I searched for the other things §21.1.1 bans and found **none**:

| Checked for | Found |
|---|---|
| Absolute drive-letter paths / `file:///` links | 32 files (the problem) |
| OS user name or home folder paths | none |
| Computer or host names, network shares | none |
| LAN or internal IP addresses, local server URLs with ports | none |
| Personal email addresses | none |
| Secrets, keys, tokens, passwords | none |

So the fix is one mechanical replacement, not a rewrite.

## Plan for the fix

1. List every file under `plans/` and `change_log/` that contains an absolute path or a
   `file:///` link. Record the list in the change log.
2. In those files, rewrite each link target to a path relative to the repository root:
   - `file:///<drive>:/Android/<repo>/lib/main.dart` becomes `lib/main.dart`
   - the visible link text is left exactly as it is; only the target changes.
3. Do not change any other word in these files. This is a path fix, not an edit of past records.
4. Re-run the §21.1.1 search over the whole of `plans/` and `change_log/` and confirm zero hits
   for absolute paths, `file:///`, user or host names, network shares, IPs with ports, and
   personal email addresses.
5. Check that the rewritten links resolve: each target must be a file that exists in the repo, or
   a file that the plan itself described as new. Report any link that points at a file which no
   longer exists — I will leave the path relative and note it, not delete the line.

## What I will not do

- I will not reword, summarise, or delete any past plan or change log. They are a record.
- I will not change the two files written today, which already follow the rule.

## Verification

- Search over `plans/` and `change_log/` returns no absolute path and no `file:///`.
- `git diff` shows only link targets changing.
- No file outside `plans/` and `change_log/` appears in the diff.

## Risk

Low. Markdown link targets only. Worst case a link points at a moved file, which is reported in
the change log rather than silently dropped.
