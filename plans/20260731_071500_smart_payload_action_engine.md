# Plan: Smart Payload Action Engine

**Status:** Approved

## Problem / Goal Statement
Implement Feature 2.2 "Smart Payload Action Engine" in Sreeraj QR Reader.
Instead of displaying raw string text, automatically detect and parse standard payload schemas with dedicated action cards:
1. **Wi-Fi QR** (`WIFI:S:SSID;T:WPA;P:password;;`): Display network name, security type, password show/hide toggle, and a "Connect to Wi-Fi" button.
2. **Contact Card** (`vCard` / `MeCard`): Render structured avatar, name, phones, emails, address, with a "Save to Contacts" button.
3. **Geographic Location** (`geo:latitude,longitude`): Render interactive/static map preview snippet with a "Navigate in Google Maps" action button.
4. **Calendar Event** (`BEGIN:VEVENT ...`): Show event title, start/end time, location, description, and an "Add to Device Calendar" button.
5. **Payment Code** (`upi://pay`, `SEPA`, `Crypto`): Show merchant name, amount, transaction ID, and a "Pay via App" button.
6. **Two-Factor Authentication** (`otpauth://totp/`): Extract secret key, issuer, account name, live 30-second TOTP token generator card, and "Import into Authenticator" button.

## Files to be Modified, Created, or Deleted

### New Models (`lib/models/`)
- `lib/models/parsed_payload.dart`: Data models for all parsed payload types (`WifiPayload`, `ContactPayload`, `GeoPayload`, `CalendarPayload`, `PaymentPayload`, `TotpPayload`, `GenericPayload`).

### New Services (`lib/services/`)
- `lib/services/payload_parser_service.dart`: Robust regex & parser engine for Wi-Fi, vCard/MeCard, Geo, iCalendar, UPI/SEPA/Crypto payments, and TOTP URIs.
- `lib/services/totp_service.dart`: RFC 6238 implementation for base32 decoding, HMAC-SHA1 TOTP token generation, and countdown calculations.
- `lib/services/payload_action_service.dart`: Native intent & URI launcher helper service for Wi-Fi connection, contact insertion, Google Maps navigation, Calendar entry creation, app payment deep-linking, and authenticator app import.

### New UI Components (`lib/screens/widgets/`)
- `lib/screens/widgets/wifi_action_card.dart`
- `lib/screens/widgets/contact_action_card.dart`
- `lib/screens/widgets/geo_action_card.dart`
- `lib/screens/widgets/calendar_action_card.dart`
- `lib/screens/widgets/payment_action_card.dart`
- `lib/screens/widgets/totp_action_card.dart`

### Modified Files
- `lib/providers/scan_provider.dart`: Incorporate `PayloadParserService` to expose parsed payload state.
- `lib/screens/result_screen.dart`: Render corresponding smart payload card based on detected payload type.

### New Unit Tests (`test/`)
- `test/services/payload_parser_service_test.dart`: Unit tests for parsing all payload schemas and handling malformed strings gracefully.
- `test/services/totp_service_test.dart`: Unit tests for TOTP token generation and time-step verification.
- `test/providers/scan_provider_payload_test.dart`: Provider unit tests for payload detection.

## Architectural Impact & Security
- Tier 1 layer-first structure maintained: `models` -> `services` -> `providers` -> `screens`.
- Immutable model classes.
- Zero network leakage for TOTP, Wi-Fi, contacts, or calendar data (offline-first).
- Robust error handling ensures app never crashes on malformed QR contents.

## Testing Strategy
- Unit tests for all parser schemas (Wi-Fi, vCard, MeCard, Geo, iCalendar, UPI, SEPA, Crypto, TOTP).
- Unit tests for TOTP RFC 6238 calculations.
- Run `flutter analyze` and `flutter test` to ensure zero static analysis issues and 100% test pass.
