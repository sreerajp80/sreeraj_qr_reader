# Change log — absolute local paths removed from `plans/` and `change_log/`

Implements plan: `plans/20260817_220800_plans-changelog-privacy-cleanup.md`

## What changed

32 markdown files were edited — 16 in `plans/` and 16 in `change_log/`. Only markdown link
targets changed. No sentence, heading, or record was reworded.

Every link that pointed at an absolute location on the machine, in the form
`file:///<drive>:/Android/<repo>/<path>`, now points at a path relative to the file that holds
the link, for example `../lib/main.dart` or `../docs/features.md`.

Two passes were needed:

1. Strip the absolute prefix, leaving a repository-root path such as `lib/main.dart`.
2. Add `../` so the link resolves from inside `plans/` or `change_log/` and stays clickable.
   The engineering standard §21.1.1 asks for relative repository paths, and the guideline's own
   example uses the `../plans/x.md` form, so this satisfies the rule and keeps the links working.

## Files changed

In `change_log/`: `20260731_191600_robust_camera_retry_loop_and_pre_pop_release.md`,
`20260731_192400_fix_false_permission_denied_ui_and_camera_resume.md`,
`20260731_205400_camera_viewport_controls_suite.md`,
`20260731_210000_air_qr_optical_stream_reader.md`, `20260731_212000_ar_codevision_hud.md`,
`20260731_215400_add_last_build_date_about_screen.md`,
`20260801_072000_settings_cards_and_about_migration.md`,
`20260801_075500_fix_camera_controller_recreation_on_return.md`,
`20260801_191100_remove_about_icon_from_scanner_appbar.md`,
`20260801_193500_permissions_and_help_settings_cards.md`,
`20260801_194500_fix_help_card_contrast_dark_theme.md`,
`20260801_195000_separate_quishing_guard_and_url_tamper_help_cards.md`,
`20260801_220655_compile_sdk_37_upgrade.md`, `20260801_221858_dotted_overflow_menu.md`,
`20260801_223200_upi_qr_contrast_and_app_launch_fix.md`,
`20260812_200706_update_docs_features_md.md`.

In `plans/`: `20260731_065500_flutter-3-44-8-upgrade-and-docs-alignment.md`,
`20260731_070000_stego_qr_reader_biometric_encrypted.md`,
`20260731_192400_fix_false_permission_denied_ui_and_camera_resume.md`,
`20260731_214646_fix_scanned_content_contrast.md`,
`20260731_215100_fix_camera_freeze_on_route_return.md`,
`20260731_215400_add_last_build_date_about_screen.md`,
`20260801_071600_settings_cards_and_about_migration.md`,
`20260801_072500_fix_mobile_scanner_already_running_error.md`,
`20260801_074000_fix_camera_hardware_release_delay.md`,
`20260801_075000_fix_camera_controller_recreation_on_return.md`,
`20260801_191000_remove_about_icon_from_scanner_appbar.md`,
`20260801_215033_gallery_and_file_media_scanning.md`,
`20260801_220623_compile_sdk_37_upgrade.md`, `20260801_221406_dotted_overflow_menu.md`,
`20260801_222100_upi_qr_contrast_and_app_launch_fix.md`,
`20260812_200706_update_docs_features_md.md`.

## Verification

- A search over `plans/` and `change_log/` finds no absolute path and no `file:///` link. The only
  remaining matches are in the plan for this work, where they appear as `<drive>` and `<repo>`
  placeholders that describe the problem and name no real machine.
- The other things §21.1.1 bans were searched for across both folders and none were found: OS user
  names, computer or host names, network shares, LAN or internal IP addresses, local server URLs
  with ports, personal email addresses, and secrets.
- `git diff` shows 107 lines added and 107 removed across 32 files. Every added line is identical
  to its removed line once the link target is masked out, which confirms no wording changed.
- Every rewritten link was resolved against the file that holds it. All resolve to a real file,
  with one exception below.

## One broken link found (left as it is, on purpose)

`change_log/20260731_191600_robust_camera_retry_loop_and_pre_pop_release.md` links twice to
`../plans/20260731_191600_robust_camera_retry_loop_and_pre_pop_release.md`, which does not exist
and never did — that change was logged without its plan being committed. The plan for this work
said such a link would be reported, not deleted, so the link is left relative and correct in form.
Fixing the missing record is a separate decision.
