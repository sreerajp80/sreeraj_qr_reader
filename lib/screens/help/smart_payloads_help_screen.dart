import 'package:flutter/material.dart';

class SmartPayloadsHelpScreen extends StatelessWidget {
  const SmartPayloadsHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Actions & Payments')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'SreerajP QR Reader automatically identifies the semantic type of every barcode, '
            'presenting contextual, 1-tap actionable cards for Wi-Fi networks, UPI and crypto payments, 2FA tokens, contacts, and calendar events.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.wifi,
            title: 'Wi-Fi Network Auto-Connect',
            children: [
              _Bullet(
                'Scans WIFI: formatted barcodes containing SSID, encryption type (WPA, WPA2, WPA3, WEP, None), and network passwords.',
              ),
              _Bullet(
                'Includes a Password Reveal / Hide button and 1-tap clipboard copy.',
              ),
              _Bullet(
                'Tap "Connect to Wi-Fi" to trigger direct connection or jump straight to system Wi-Fi settings.',
              ),
            ],
          ),
          _Section(
            icon: Icons.payment_outlined,
            title: 'UPI & Cryptocurrency Payments',
            children: [
              _Bullet(
                'Indian UPI QR Codes: Parses Virtual Payment Addresses (VPA), merchant names, transaction references, and exact amount values.',
              ),
              _Bullet(
                '1-Tap Dispatch: Launches your installed payment apps (Google Pay, PhonePe, Paytm, or BHIM) with pre-filled transaction parameters.',
              ),
              _Bullet(
                'Crypto QR Codes: Recognizes Bitcoin, Ethereum, and Solana wallet schemes with 1-tap copy and address formatting.',
              ),
            ],
          ),
          _Section(
            icon: Icons.timer_outlined,
            title: 'TOTP 2FA Authenticator & Tokens',
            children: [
              _Bullet(
                'Scans otpauth:// standard two-factor authentication setup codes used by Google Authenticator and Microsoft Authenticator.',
              ),
              _Bullet(
                'Displays a live, rolling 6-digit one-time passcode with an animated 30-second circular countdown timer on device.',
              ),
              _Bullet(
                'Tap "Import into Authenticator App" to register the key in your preferred 2FA app.',
              ),
            ],
          ),
          _Section(
            icon: Icons.contact_page_outlined,
            title: 'Contacts & Calendar Events',
            children: [
              _Bullet(
                'vCard & MeCard: Parses full name, telephone numbers, email addresses, organization, and job title with 1-tap address book import.',
              ),
              _Bullet(
                'iCalendar (VEVENT): Parses event title, start and end date/time, location, and description, offering 1-tap Google/device calendar scheduling.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: When paying with UPI QR codes, always verify the merchant name shown on the card matches the physical store counter.',
          ),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  final String text;
  const _Intro(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _Section({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: accent),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, right: 10),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final String text;
  const _Footer(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: accent,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
