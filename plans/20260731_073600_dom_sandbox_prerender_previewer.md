# Zero-Trust Sandboxed HTML Pre-Render Previewer

**Status:** Proposed

## Problem / Goal
Implement Feature 5: Zero-Trust Sandboxed HTML Pre-Render Previewer in Sreeraj QR Reader. When a web URL QR code is scanned, the app fetches the destination HTML header and DOM hierarchy using a headless, script-disabled sandbox socket, blocks tracking scripts/automatic downloads/popups/redirect traps, checks domain age via WHOIS/RDAP, SSL validity, and renders a sanitized visual thumbnail preview card on `ResultScreen` before the user opens the link in the device browser.

## Proposed Changes

1. `lib/models/dom_sandbox_result.dart` [NEW]
   - Immutable data model representing sanitized DOM analysis results, page title, meta description, heading structure, links, blocked scripts count, blocked trackers count, open redirect traps, SSL details, and WHOIS domain age.

2. `lib/services/dom_sandbox_service.dart` [NEW]
   - Headless, script-disabled DOM fetching and sanitization service.
   - Strips `<script>`, `<style>`, `<iframe>`, `<embed>`, `<meta http-equiv="refresh">`, `on*` event attributes, and tracking pixels (`1x1` pixels/trackers).
   - Detects open redirect traps in query parameters and HTTP/meta headers.
   - Queries WHOIS/RDAP to calculate domain age and flags newly registered domains.
   - Verifies SSL certificate status and issuer details.

3. `lib/screens/widgets/dom_sandbox_preview_card.dart` [NEW]
   - Interactive M3 browser frame card widget rendering a sanitized visual thumbnail preview of the target site.
   - Displays script & tracker shield badges, domain age indicator, SSL certificate badge, and open redirect trap alert.
   - Includes a dialog for detailed DOM inspection (sanitized hierarchy & blocked scripts summary).

4. `lib/providers/scan_provider.dart` [MODIFY]
   - Integrate `DomSandboxService` into state management.
   - Trigger `DomSandboxService` analysis during URL safety check and expose `domSandboxResult` state.

5. `lib/screens/result_screen.dart` [MODIFY]
   - Display `DomSandboxPreviewCard` when scanning a URL QR code.

6. `docs/feature_analysis_and_roadmap.md` [MODIFY]
   - Mark Feature 5: Zero-Trust Sandboxed HTML Pre-Render Previewer as ✅ [COMPLETED].

7. `test/services/dom_sandbox_service_test.dart` [NEW] & `test/providers/scan_provider_dom_sandbox_test.dart` [NEW]
   - Automated unit tests covering HTML sanitization, script blocking, tracker detection, open redirect trap detection, domain age calculation, and provider state management.

## Verification Plan
- Run `flutter analyze` to ensure 0 lint errors/warnings.
- Run `flutter test` to ensure all existing and new unit tests pass cleanly.
