# Change Log: Smart Payload Action Engine

**Plan File:** `plans/20260731_071500_smart_payload_action_engine.md`

## Summary of Changes

Implemented Feature 2.2 **Smart Payload Action Engine** for Sreeraj QR Reader, supporting 6 standard payload schemas with dedicated Material 3 action cards and 1-tap system integrations:

1. **Wi-Fi QR**:
   - Built `WifiPayload` parser and `WifiActionCard` widget.
   - Displays SSID, security type (WPA/WEP/nopass), show/hide password toggle, password copy button, and "Connect to Wi-Fi" launcher using system Wi-Fi settings intent.

2. **Contact Card (vCard / MeCard)**:
   - Built `ContactPayload` parser supporting RFC 6350 vCard and MeCard formats.
   - Renders structured avatar, contact name, title, organization, phones (with tap-to-call), emails (with tap-to-email), addresses, and "Save to Contacts" intent.

3. **Geographic Location (Geo)**:
   - Built `GeoPayload` parser supporting `geo:lat,lng?q=query`.
   - Renders stylized location snippet banner, coordinates, query, and "Navigate in Google Maps" launcher.

4. **Calendar Event (iCalendar)**:
   - Built `CalendarPayload` parser for `BEGIN:VEVENT` / `BEGIN:VCALENDAR`.
   - Displays event summary, start/end dates, location, description, and "Add to Device Calendar" action button.

5. **Payment Code (UPI, SEPA, Crypto)**:
   - Built `PaymentPayload` parser for `upi://pay`, SEPA credit transfers, and crypto URIs (`bitcoin:`, `ethereum:`, `solana:`).
   - Displays payee/merchant name, amount, currency, VPA/IBAN/Wallet address, transaction note, and "Pay via App" deep-link launcher.

6. **Two-Factor Authentication (2FA TOTP)**:
   - Built `TotpPayload` parser and pure Dart RFC 6238 / RFC 4226 `TotpService` engine.
   - Renders live 30-second 6-digit TOTP token generator with countdown ring, secret key mask/unmask, and "Import into Authenticator" launcher.

## Verification Results

- `flutter analyze`: **0 issues found!** (Static analysis passed cleanly)
- `flutter test`: **76 / 76 tests passed!** (All unit tests passed)
- Documentation: Updated `docs/feature_analysis_and_roadmap.md` marking section 2.2 as `[COMPLETED]`.
