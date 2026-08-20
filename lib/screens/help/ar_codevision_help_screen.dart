import 'package:flutter/material.dart';

class ArCodeVisionHelpScreen extends StatelessWidget {
  const ArCodeVisionHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR CodeVision™ Spatial HUD')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'AR CodeVision™ transforms your camera viewport into an augmented reality spatial heads-up display '
            'that detects, tracks, and analyzes multiple barcodes simultaneously in real time.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.view_in_ar,
            title: 'Real-Time Spatial Tracking',
            children: [
              _Bullet(
                'Simultaneously identifies every barcode within the camera frame, locking a spatial 2D/3D tracking anchor onto each code.',
              ),
              _Bullet(
                'Renders floating interactive chips directly above each physical barcode on screen as you move your camera.',
              ),
              _Bullet(
                'Live color-coded security badges immediately indicate if a link is Verified Safe (green) or Phishing Suspicion (red).',
              ),
            ],
          ),
          _Section(
            icon: Icons.checklist_outlined,
            title: 'Interactive Multi-Select & Batch Actions',
            children: [
              _Bullet(
                'Tap any floating chip to inspect its payload, trigger contextual actions, or open the detailed AR Action Sheet.',
              ),
              _Bullet(
                'Select multiple items across warehouse shelves, product catalogs, or event badges for batch processing.',
              ),
              _Bullet(
                'Copy all selected payload contents or export targets to your history in a single tap.',
              ),
            ],
          ),
          _Section(
            icon: Icons.flash_on_outlined,
            title: 'HUD Controls & Performance',
            children: [
              _Bullet(
                'HUD Action Strip: Quick toggles for camera flash, zoom level, front/rear camera flip, and target clearing.',
              ),
              _Bullet(
                'Optimized hardware frame rate processing prevents thermal throttling and conserves battery during extended scanning sessions.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: In dense environments with dozens of barcodes, use the zoom slider to isolate specific clusters with surgical precision.',
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
