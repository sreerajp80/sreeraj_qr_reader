import 'package:flutter/material.dart';

class AirQrHelpScreen extends StatelessWidget {
  const AirQrHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AirQR™ Optical Air-Gap Stream')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'AirQR™ establishes a bidirectional, completely offline optical data pipeline between devices using '
            'high-speed animated QR strobe frames without needing Wi-Fi, Bluetooth, cellular data, or physical cables.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.stream,
            title: 'How Optical Streaming Works',
            children: [
              _Bullet(
                'Large files, cryptographic keys, or long documents are divided into sequential data frames encoded with Reed-Solomon error correction.',
              ),
              _Bullet(
                'The transmitting device flashes the animated QR code stream at a customizable frame rate (5 to 20 FPS).',
              ),
              _Bullet(
                'The receiving device continuously captures the strobe sequence, reconstructing missing frames on the fly until the full payload is reassembled.',
              ),
            ],
          ),
          _Section(
            icon: Icons.security,
            title: 'Air-Gap Security & Privacy',
            children: [
              _Bullet(
                'Complete Radio Silence: Zero electromagnetic radio emissions (no RF broadcasts, pairing requests, or network logs).',
              ),
              _Bullet(
                'Immune to remote network interception, man-in-the-middle attacks, and Bluetooth sniffing vulnerabilities.',
              ),
              _Bullet(
                'Perfect for air-gapped cryptocurrency cold wallets, confidential credentials, and secure offline data sharing.',
              ),
            ],
          ),
          _Section(
            icon: Icons.settings_suggest_outlined,
            title: 'Transmitter & Receiver Controls',
            children: [
              _Bullet(
                'Transmitter Screen: Customize chunk size (bytes per frame), frame rate (FPS), and monitor total transmitted packets.',
              ),
              _Bullet(
                'Receiver Screen: Real-time progress bar, captured frame counter, missing frame indices, and checksum verification.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: When receiving an AirQR stream, hold your phone steady and ensure the transmitter screen brightness is set to high for maximum frame capture speed.',
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
