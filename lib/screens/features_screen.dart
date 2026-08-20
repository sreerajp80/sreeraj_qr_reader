import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';

/// One feature item displayed on the Features screen.
class _AppFeature {
  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;

  const _AppFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.highlights,
  });
}

/// A category grouping related features.
class _FeatureCategory {
  final String name;
  final String subtitle;
  final IconData icon;
  final List<_AppFeature> features;

  const _FeatureCategory({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.features,
  });
}

/// Lists all features of SreerajP QR Reader, grouped by category with visual cards.
class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  static const List<_FeatureCategory> _categories = [
    _FeatureCategory(
      name: 'Core Scanning & Ingestion',
      subtitle:
          'Lightning-fast 1D/2D barcode engine with multi-source media support',
      icon: Icons.qr_code_scanner,
      features: [
        _AppFeature(
          title: 'Multi-Format Barcode Engine',
          description:
              'Instantly decodes 1D barcodes (EAN-13, UPC-A, Code 128, Code 39, Codabar, ITF) and 2D codes (QR, Data Matrix, Aztec, PDF417) in milliseconds.',
          icon: Icons.document_scanner_outlined,
          highlights: ['QR & Data Matrix', 'Aztec & PDF417', 'EAN & Code 128'],
        ),
        _AppFeature(
          title: 'Multi-Source Media & PDF Ingestion',
          description:
              'Scan barcodes from live camera feed, select existing images from your gallery, or extract and parse barcodes across multi-page PDF documents.',
          icon: Icons.photo_library_outlined,
          highlights: ['Gallery Photos', 'Multi-Page PDF', 'Live Viewport'],
        ),
        _AppFeature(
          title: 'Precision Camera Controls',
          description:
              'Smooth zoom slider, torch flashlight toggle, front and rear camera switching, and continuous autofocus for low-light scanning.',
          icon: Icons.camera_alt_outlined,
          highlights: ['Flashlight Torch', 'Zoom Control', 'Front/Back Flip'],
        ),
        _AppFeature(
          title: 'Customizable Scan Overlays',
          description:
              'Choose between Laser Line, Pulsing Corners, Cybernetic Grid, or Subtle Dot Matrix viewfinder overlays with live feedback.',
          icon: Icons.layers_outlined,
          highlights: ['4 Overlay Styles', 'Live Animation', 'OLED Compatible'],
        ),
        _AppFeature(
          title: 'Tactile Haptic & Audio Feedback',
          description:
              'Customizable vibration pulses and audible beep tones confirm successful recognition even in noisy environments.',
          icon: Icons.vibration,
          highlights: ['Haptic Pulse', 'Audio Beep', 'Independent Toggles'],
        ),
      ],
    ),
    _FeatureCategory(
      name: '6-Layer URL Safety & Forensic Engine',
      subtitle:
          'Zero-trust forensic analysis defending you against malicious QR phishing & scams',
      icon: Icons.security_outlined,
      features: [
        _AppFeature(
          title: 'Protocol & Syntax Guard (Layer 1)',
          description:
              'Validates scheme authenticity, checks for encrypted HTTPS connections, and flags plain HTTP or unsupported schemes.',
          icon: Icons.lock_outline,
          highlights: [
            'HTTPS Validation',
            'Scheme Checking',
            'Zero-Width Char Trap',
          ],
        ),
        _AppFeature(
          title: 'Homograph & Unicode Shield (Layer 2)',
          description:
              'Detects lookalike Cyrillic, Greek, and Unicode spoofing characters used to disguise fraudulent domain names (IDN punycode defense).',
          icon: Icons.spellcheck,
          highlights: [
            'Punycode Defense',
            'Cyrillic Lookalikes',
            'Mixed-Script Trap',
          ],
        ),
        _AppFeature(
          title: 'Suspicious TLD & Entropy Analysis (Layer 3)',
          description:
              'Flags high-risk top-level domains, excessive subdomains, and evaluates domain name character entropy to catch algorithmic domains.',
          icon: Icons.dns_outlined,
          highlights: ['High-Risk TLDs', 'Entropy Scoring', 'Subdomain Depth'],
        ),
        _AppFeature(
          title: 'Heuristic IP & Port Flagging (Layer 4)',
          description:
              'Flags links pointing directly to raw IP addresses or non-standard HTTP/HTTPS network ports designed to bypass firewalls.',
          icon: Icons.router_outlined,
          highlights: [
            'Raw IP Traps',
            'Non-Standard Ports',
            'Embedded Userinfo',
          ],
        ),
        _AppFeature(
          title: 'Privacy-Safe Online Head Probing (Layer 5)',
          description:
              'Optional opt-in lightweight HTTP HEAD probing to resolve URL shorteners, uncover hidden redirect chains, and verify TLS certificates.',
          icon: Icons.travel_explore,
          highlights: [
            'Redirect Chains',
            'Shortener Unrolling',
            'Opt-In Privacy',
          ],
        ),
        _AppFeature(
          title: 'Google Safe Browsing API (Layer 6)',
          description:
              'Optional cloud threat intelligence against millions of known malicious URLs, malware distribution hubs, and social engineering sites.',
          icon: Icons.shield_outlined,
          highlights: [
            'Google Threat DB',
            'Local Key Storage',
            'Daily Quota Meter',
          ],
        ),
      ],
    ),
    _FeatureCategory(
      name: 'QuishingGuard™ & Advanced AI Vision',
      subtitle:
          'Cutting-edge on-device computer vision and optical air-gap data streaming',
      icon: Icons.remove_red_eye_outlined,
      features: [
        _AppFeature(
          title: 'QuishingGuard™ Physical Tamper Detection',
          description:
              'Forensic computer vision pipeline detecting physical QR sticker overlays, edge discontinuities, micro-shadows, and chromatic halftone print grain.',
          icon: Icons.policy_outlined,
          highlights: [
            'Sticker Overlays',
            'Edge Discontinuity',
            'Print Grain Analysis',
          ],
        ),
        _AppFeature(
          title: 'AR CodeVision™ Spatial HUD',
          description:
              'Augmented Reality multi-barcode scanner displaying floating interactive chips over all detected codes with live safety badges and batch selection.',
          icon: Icons.view_in_ar_outlined,
          highlights: ['Spatial Tracking', 'Multi-Code HUD', 'Batch Select'],
        ),
        _AppFeature(
          title: 'AirQR™ Optical Air-Gap Data Stream',
          description:
              'High-speed animated strobe QR transmitter & receiver pipeline transferring encrypted text, files, and keys completely offline without Wi-Fi or Bluetooth.',
          icon: Icons.stream,
          highlights: [
            'Animated Strobe QR',
            'Reed-Solomon FEC',
            '100% Offline Air-Gap',
          ],
        ),
        _AppFeature(
          title: 'StegoQR™ Steganographic Scanner',
          description:
              'Discovers and extracts hidden encrypted payloads and watermarked data layers invisibly embedded within custom QR codes.',
          icon: Icons.vpn_key_outlined,
          highlights: ['Decoy QR Parsing', 'AES Decryption', 'Biometric Auth'],
        ),
      ],
    ),
    _FeatureCategory(
      name: 'Smart Payloads & 1-Tap Integrations',
      subtitle:
          'Instant parsing and contextual native actions for everyday barcodes',
      icon: Icons.touch_app_outlined,
      features: [
        _AppFeature(
          title: 'Wi-Fi Instant Auto Connect',
          description:
              'Parses WPA/WPA2/WPA3 network credentials, displays network info, copies passwords, and opens Wi-Fi settings in 1 tap.',
          icon: Icons.wifi,
          highlights: ['WPA3 & WPA2', '1-Tap Connect', 'Password Reveal/Copy'],
        ),
        _AppFeature(
          title: 'UPI & Global Crypto Payments',
          description:
              'Parses Indian UPI QR codes (dispatching to GPay, PhonePe, Paytm) and Bitcoin/Ethereum/Solana crypto payment addresses with amount detection.',
          icon: Icons.payment_outlined,
          highlights: ['UPI App Dispatch', 'Crypto Wallets', 'SEPA Transfer'],
        ),
        _AppFeature(
          title: 'TOTP 2FA Authenticator & Token Generator',
          description:
              'Scans 2FA setup codes, renders live rolling 6-digit OTP passcodes with circular countdown timers, and imports into authenticator apps.',
          icon: Icons.timer_outlined,
          highlights: ['Live Passcodes', 'Visual Countdown', 'App Importer'],
        ),
        _AppFeature(
          title: 'Contacts & vCard Importer',
          description:
              'Parses vCard 2.1/3.0/4.0 and MeCard contact barcodes with 1-tap phone dialing, email composition, and saving to your address book.',
          icon: Icons.contact_phone_outlined,
          highlights: ['vCard 4.0', '1-Tap Save', 'Direct Call & Email'],
        ),
        _AppFeature(
          title: 'Calendar Events & Scheduling',
          description:
              'Reads iCalendar VEVENT formats with start/end time ranges, locations, and descriptions, adding them directly to your device calendar.',
          icon: Icons.event_outlined,
          highlights: ['iCal Parsing', 'Start/End Time', 'Device Calendar Add'],
        ),
        _AppFeature(
          title: 'Geographic Location & Navigation',
          description:
              'Parses geo: coordinates and search queries, offering instant navigation directions via Google Maps.',
          icon: Icons.location_on_outlined,
          highlights: [
            'Lat/Long Parsing',
            'Google Maps Link',
            'Search Queries',
          ],
        ),
      ],
    ),
    _FeatureCategory(
      name: 'History, Backup & Privacy Vault',
      subtitle:
          'Your personal scan history protected by biometric security and offline storage',
      icon: Icons.history_edu_outlined,
      features: [
        _AppFeature(
          title: 'Comprehensive Offline Scan History',
          description:
              'Stores every scan locally with payload categorization, safety scores, timestamp tracking, favorite stars, and real-time full-text search.',
          icon: Icons.history,
          highlights: [
            'Full-Text Search',
            'Category Filtering',
            'Favorite Stars',
          ],
        ),
        _AppFeature(
          title: 'Flexible JSON & CSV Backups',
          description:
              'Export your complete scan history to standard CSV spreadsheets or encrypted JSON backup files with one-click restore.',
          icon: Icons.import_export,
          highlights: ['CSV Spreadsheet', 'JSON Backup', 'One-Click Restore'],
        ),
        _AppFeature(
          title: 'Biometric & Screen Security Guard',
          description:
              'Protects sensitive hidden StegoQR payloads and history with fingerprint/face authentication and blocks screen captures (FLAG_SECURE).',
          icon: Icons.fingerprint,
          highlights: [
            'Biometric Prompt',
            'Screenshot Guard',
            'Encrypted Storage',
          ],
        ),
        _AppFeature(
          title: '100% Offline-First Privacy',
          description:
              'Scans, decodes, and analyzes barcodes completely on your phone without sending any data to external servers by default.',
          icon: Icons.lock_person_outlined,
          highlights: ['No Telemetry', 'Zero Ads', 'Open-Source Safety'],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsFeaturesTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildHeaderCard(context, l10n),
          const SizedBox(height: 20),
          for (final category in _categories) ...[
            _buildCategoryHeader(context, category),
            const SizedBox(height: 10),
            _buildCategoryCard(context, category),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.14),
              theme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.stars_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.featuresHeaderTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.featuresHeaderSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, _FeatureCategory category) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, size: 18, color: primary),
              const SizedBox(width: 8),
              Text(
                category.name.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            category.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, _FeatureCategory category) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          for (var i = 0; i < category.features.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: theme.dividerColor.withValues(alpha: 0.4),
              ),
            _buildFeatureTile(context, category.features[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context, _AppFeature feature) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(feature.icon, color: accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                if (feature.highlights.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: feature.highlights.map((h) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          h,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accent,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
