import 'package:flutter/material.dart';

class FaqTroubleshootingHelpScreen extends StatelessWidget {
  const FaqTroubleshootingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ & Troubleshooting')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'Answers to common questions, camera troubleshooting advice, and privacy clarifications for SreerajP QR Reader.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.help_outline,
            title: 'Frequently Asked Questions',
            children: [
              _Bullet(
                'Q: Does the app work without internet?\nYes! 100% of barcode decoding, QuishingGuard CV checks, and URL safety heuristics (Layers 1-4) work completely offline.',
              ),
              _Bullet(
                'Q: Is my camera feed sent to any server?\nNo. Camera frames are processed strictly on-device in volatile memory and are never recorded, saved, or uploaded.',
              ),
              _Bullet(
                'Q: Why is Google Safe Browsing optional?\nWe believe in privacy-by-default. Offline safety layers protect you immediately, while Google Safe Browsing is an optional opt-in for users with a Google Cloud API key.',
              ),
            ],
          ),
          _Section(
            icon: Icons.build_outlined,
            title: 'Camera Troubleshooting',
            children: [
              _Bullet(
                'Camera Fails to Focus: Ensure the lens is clean and hold the device 15-20 cm away. In low light, tap the Flashlight icon.',
              ),
              _Bullet(
                'Tiny or Dense QR Code: Use the zoom slider to magnify the QR code rather than bringing the phone too close.',
              ),
              _Bullet(
                'Permission Denied: If camera permission was revoked, go to Android Settings -> Apps -> SreerajP QR Reader -> Permissions -> Camera -> Allow.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: If you encounter an unusual barcode format, take a photo and use the Gallery scan tool to process it in full resolution.',
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
