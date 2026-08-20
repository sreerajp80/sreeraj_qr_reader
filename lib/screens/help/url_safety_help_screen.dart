import 'package:flutter/material.dart';

class UrlSafetyHelpScreen extends StatelessWidget {
  const UrlSafetyHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('6-Layer URL Safety Engine')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'Before you open any scanned web link, our comprehensive 6-layer forensic safety engine '
            'evaluates the URL against modern phishing heuristics, homograph spoofing attacks, and malicious redirect traps.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.shield_outlined,
            title: 'The 6 Safety Layers Explained',
            children: [
              _Bullet(
                'Layer 1: Protocol & Scheme Guard - Enforces HTTPS encryption and verifies standard protocol formatting while intercepting malformed or zero-width character traps.',
              ),
              _Bullet(
                'Layer 2: Homograph & Unicode Attack Shield - Identifies Cyrillic, Greek, and mixed-script lookalike characters (such as "а" instead of "a") used by scammers to imitate trusted websites.',
              ),
              _Bullet(
                'Layer 3: Suspicious TLD & Entropy Analysis - Flags high-risk domain endings (.xyz, .top, .work), excessive subdomain nesting, and randomized machine-generated domain names.',
              ),
              _Bullet(
                'Layer 4: Heuristic IP & Non-Standard Port Trap - Detects links connecting directly to numeric IP addresses or weird port numbers often used by botnet malware servers.',
              ),
              _Bullet(
                'Layer 5: Privacy-Safe Online Head Probing - Optionally follows shortened URL redirects (bit.ly, tinyurl) and inspects SSL certificate trust chains without executing malicious JavaScript.',
              ),
              _Bullet(
                'Layer 6: Google Safe Browsing API Integration - Optional cloud-based real-time threat intelligence protecting against phishing sites and malware distribution networks.',
              ),
            ],
          ),
          _Section(
            icon: Icons.lock_outline,
            title: 'Safety Verdicts & Action Guidance',
            children: [
              _Bullet(
                'Verified Safe (Green): The URL passed all structural and threat checks without triggering any suspicious signals.',
              ),
              _Bullet(
                'Caution / Warning (Orange/Red): High risk factors detected. The app displays the full unshortened destination and highlights exactly which rules triggered the alert.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: Layers 1 through 4 operate 100% offline using on-device heuristics, protecting your privacy wherever you are.',
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
