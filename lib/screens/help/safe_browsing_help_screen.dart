import 'package:flutter/material.dart';

class SafeBrowsingHelpScreen extends StatelessWidget {
  const SafeBrowsingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Safe Browsing Setup')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'Google Safe Browsing enables Layer 6 cloud threat intelligence to check scanned URLs against '
            'billions of constantly updated known malware, social engineering, and phishing threat entries.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.vpn_key_outlined,
            title: 'How to Obtain a Free API Key',
            children: [
              _Bullet(
                '1. Open the Google Cloud Console (console.cloud.google.com) on your computer or mobile browser.',
              ),
              _Bullet(
                '2. Create a new Google Cloud Project (e.g., "My QR Reader Security").',
              ),
              _Bullet(
                '3. Navigate to APIs & Services -> Library and search for "Web Risk API" or "Safe Browsing API" and click Enable.',
              ),
              _Bullet(
                '4. Go to APIs & Services -> Credentials and click "+ CREATE CREDENTIALS" -> "API key".',
              ),
              _Bullet(
                '5. Copy your new API key and paste it into the Google Safe Browsing field under Settings.',
              ),
            ],
          ),
          _Section(
            icon: Icons.lock_outline,
            title: 'Privacy & Secure Keystore Storage',
            children: [
              _Bullet(
                'Your API key is encrypted using Android Keystore hardware-backed secure storage (FlutterSecureStorage) and never exported or shared.',
              ),
              _Bullet(
                'Google Safe Browsing is 100% optional. If no key is provided, the app continues to perform comprehensive offline checks.',
              ),
              _Bullet(
                'Free Tier Quota: Google provides up to 10,000 free requests per day, and the app resets its local usage counter every 24 hours.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: Safe Browsing checks only execute after offline heuristics pass, conserving your daily lookup quota.',
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
