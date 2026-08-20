import 'package:flutter/material.dart';

class BarcodeScanningHelpScreen extends StatelessWidget {
  const BarcodeScanningHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode & Media Scanning')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: const [
          _Intro(
            'Scan any 1D or 2D barcode instantly using live camera, photo gallery images, '
            'or multi-page PDF documents with high-precision computer vision.',
          ),
          SizedBox(height: 24),
          _Section(
            icon: Icons.qr_code_scanner,
            title: 'Live Camera Viewport',
            children: [
              _Bullet(
                'Aim your camera at any QR code, Data Matrix, Aztec, PDF417, EAN-13, UPC-A, Code 128, or Codabar symbol.',
              ),
              _Bullet(
                'Torch & Zoom: Tap the Flashlight icon in low light, or use the zoom slider to read high-density micro-QR codes from a distance.',
              ),
              _Bullet(
                'Viewfinder Overlays: Customize the visual scan frame under Settings -> Appearance to suit your preference.',
              ),
            ],
          ),
          _Section(
            icon: Icons.photo_library_outlined,
            title: 'Scanning Gallery Photos & Images',
            children: [
              _Bullet(
                'Tap the Gallery icon on the scanner screen to pick any saved image or screenshot from your device.',
              ),
              _Bullet(
                'Uses privacy-safe Android Photo Picker without requiring broad storage permissions.',
              ),
              _Bullet(
                'The scanner analyzes full-resolution image frames to detect and decode multiple barcodes in milliseconds.',
              ),
            ],
          ),
          _Section(
            icon: Icons.picture_as_pdf_outlined,
            title: 'Multi-Page PDF Scanning',
            children: [
              _Bullet(
                'Select a PDF document (such as an invoice, ticket, or boarding pass) directly through the file picker.',
              ),
              _Bullet(
                'Extracts and renders every page in memory, cataloging all barcodes found across each individual page.',
              ),
              _Bullet(
                'Review all detected codes in a dedicated bottom sheet and save them into your scan history in 1 tap.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _Footer(
            'Tip: Barcode recognition operates 100% locally on your device without uploading your camera frames or images to the cloud.',
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
