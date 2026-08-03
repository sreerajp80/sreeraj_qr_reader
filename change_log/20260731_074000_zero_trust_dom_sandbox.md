# Change Log: Zero-Trust Sandboxed HTML Pre-Render Previewer

**Plan Reference:** `plans/20260731_073600_dom_sandbox_prerender_previewer.md`

## Summary of Changes

Implemented **Feature 5: Zero-Trust Sandboxed HTML Pre-Render Previewer** in Sreeraj QR Reader. When a URL QR code is scanned, the app runs an isolated off-screen sandbox renderer to generate a sanitized visual thumbnail preview of the destination HTML DOM before the user opens the link in their device browser.

### Key Additions & Modifications

1. `lib/models/dom_sandbox_result.dart` [NEW]
   - Created `DomSandboxResult` data model capturing page title, meta description, favicon URL, theme color, headings hierarchy, paragraph text snippets, links, blocked scripts count, blocked trackers count, blocked iframes count, open redirect traps, SSL validity details, WHOIS domain creation date, and domain age in days.

2. `lib/services/dom_sandbox_service.dart` [NEW]
   - Created `DomSandboxService` providing headless, script-disabled HTML DOM fetching and sanitization.
   - Strips `<script>`, inline JS event attributes (`onload=`, `onclick=`, `onerror=`), `<iframe>`, `<embed>`, `<object>`, `<meta http-equiv="refresh">`, and tracking pixel images (`1x1` pixels, analytics scripts/trackers).
   - Detects open redirect traps in query parameters (`redirect`, `url`, `dest`, `next`, `target`, `out`, `link`, `to`, `goto`, `u`, `r`, `ref`), HTTP 3xx Location headers, and meta refresh tags.
   - Evaluates SSL certificates and queries WHOIS/RDAP (`https://rdap.org/domain/<host>`) to analyze domain age and flag newly registered domain risks (< 30 days old).

3. `lib/screens/widgets/dom_sandbox_preview_card.dart` [NEW]
   - Built interactive Material 3 browser frame preview card displaying address bar, SSL lock icon, domain, and "SANDBOXED" badge.
   - Renders a sanitized visual thumbnail preview viewport with header banner, page title, meta description, headings, text snippet preview, script/tracker shield badges, domain age indicator, SSL status, and open redirect trap alert.
   - Added modal bottom sheet dialog to inspect the complete sanitized DOM hierarchy and blocked scripts list safely.

4. `lib/providers/scan_provider.dart` [MODIFY]
   - Integrated `DomSandboxService` into `ScanProvider` state management.
   - Exposed `domSandboxResult` state and triggered automatic DOM sandbox analysis during `checkUrlSafety`.
   - Cleared `domSandboxResult` in `clearScan()`.

5. `lib/screens/result_screen.dart` [MODIFY]
   - Rendered `DomSandboxPreviewCard` on `ResultScreen` whenever a URL QR code is scanned.

6. `docs/feature_analysis_and_roadmap.md` [MODIFY]
   - Updated section 3.5, feature comparison matrix, and roadmap phase 2 to mark **Feature 5: Zero-Trust Sandboxed HTML Pre-Render Previewer** as ✅ [COMPLETED].

7. `test/services/dom_sandbox_service_test.dart` [NEW] & `test/providers/scan_provider_dom_sandbox_test.dart` [NEW]
   - Added comprehensive unit tests for script/tracker stripping, DOM hierarchy extraction, open redirect trap detection, domain age calculation, SSL verification, and provider integration.

## Verification
- `flutter analyze`: Passed with 0 errors/warnings.
- `flutter test`: Passed all 88 unit tests across the entire test suite cleanly.
