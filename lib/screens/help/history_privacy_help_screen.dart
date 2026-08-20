import 'package:flutter/material.dart';

class HistoryPrivacyHelpScreen extends StatelessWidget {
  const HistoryPrivacyHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History, Backups & Privacy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'Your scan records belong solely to you. SreerajP QR Reader stores all history entries in a '
            'local SQLite database on your device with biometric authentication safeguards and structured export formats.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.history,
            title: 'Scan History Management',
            children: [
              _Bullet(
                'Search & Filter: Search scan history in real time by text query or filter by payload type (URLs, Wi-Fi, Contacts, Payments, TOTP).',
              ),
              _Bullet(
                'Star Favorites: Mark important Wi-Fi credentials or loyalty codes as favorites for quick access.',
              ),
              _Bullet(
                'Detailed Inspect Sheet: Review the exact raw decoded bytes, safety score breakdown, timestamp, and add custom notes.',
              ),
            ],
          ),
          _Section(
            icon: Icons.import_export,
            title: 'Backup & Restore (JSON / CSV)',
            children: [
              _Bullet(
                'JSON Full Backup: Exports your complete history including custom tags, favorites, and safety results into a portable .json file.',
              ),
              _Bullet(
                'CSV Spreadsheet: Generates a clean comma-separated values file compatible with Microsoft Excel and Google Sheets.',
              ),
              _Bullet(
                'One-Click Restore: Import previously exported JSON backup files at any time to restore your scan log.',
              ),
            ],
          ),
          _Section(
            icon: Icons.fingerprint,
            title: 'Biometrics & Screenshot Guard',
            children: [
              _Bullet(
                'Biometric Authentication: Protects sensitive StegoQR hidden records using your device fingerprint or facial recognition.',
              ),
              _Bullet(
                'Screenshot Guard: Prevents malicious background apps or unauthorized shoulder-surfers from capturing screen content (FLAG_SECURE).',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: Back up your history to a JSON file before switching or resetting your phone to preserve your saved scans.',
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
