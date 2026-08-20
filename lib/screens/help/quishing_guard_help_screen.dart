import 'package:flutter/material.dart';

class QuishingGuardHelpScreen extends StatelessWidget {
  const QuishingGuardHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuishingGuard™ Tamper Detection')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'Quishing (QR Phishing) occurs when criminals paste physical fraudulent sticker QR codes '
            'over legitimate QR codes on parking meters, restaurant menus, payment counters, or transit signs.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.policy_outlined,
            title: 'On-Device Computer Vision Analysis',
            children: [
              _Bullet(
                'Edge Discontinuity Metric: Detects double edges, cutting misalignment, and micro-shadows along the boundary of pasted overlay stickers.',
              ),
              _Bullet(
                'Print Grain & Halftone Metric: Identifies inconsistencies in dot pitch, chromatic noise, and print resolution between the code and surrounding background poster.',
              ),
              _Bullet(
                'Calculates a combined Tamper Risk Score from 0% (Authentic) to 100% (High Tamper Risk).',
              ),
            ],
          ),
          _Section(
            icon: Icons.analytics_outlined,
            title: 'Forensic Signal Inspection',
            children: [
              _Bullet(
                'Tap "View Forensic Analysis" on any scanned code to view real-time CV confidence levels, border edge metrics, and chromatic noise charts.',
              ),
              _Bullet(
                'Helps identify suspicious payment QR codes in public places before sending money or typing credentials.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: When scanning outdoor QR codes on parking meters or public kiosks, inspect the code physically with your fingers if QuishingGuard flags an edge discontinuity alert.',
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
