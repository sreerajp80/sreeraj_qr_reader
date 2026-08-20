import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/screens/help/air_qr_help_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/ar_codevision_help_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/barcode_scanning_help_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/faq_troubleshooting_help_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/history_privacy_help_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/quishing_guard_help_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/safe_browsing_help_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/smart_payloads_help_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/url_safety_help_screen.dart';

/// Help Center hub reached from Settings -> Help.
class HelpHomeScreen extends StatelessWidget {
  const HelpHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsHelpTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildHeaderCard(context, l10n),
          const SizedBox(height: 20),

          _buildSectionHeader(
            context,
            'Scanning & Ingestion Guides',
            Icons.qr_code_scanner,
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.document_scanner_outlined,
            title: 'Barcode & Media Scanning',
            subtitle:
                'Live camera controls, gallery photos, and multi-page PDF document scanning.',
            onTap: () => _push(context, const BarcodeScanningHelpScreen()),
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.view_in_ar,
            title: 'AR CodeVision™ Spatial HUD',
            subtitle:
                'Real-time multi-barcode camera tracking, floating chips, and batch actions.',
            onTap: () => _push(context, const ArCodeVisionHelpScreen()),
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.stream,
            title: 'AirQR™ Optical Air-Gap Stream',
            subtitle:
                'Offline animated QR strobe transmitter and receiver for radio-silent data sharing.',
            onTap: () => _push(context, const AirQrHelpScreen()),
          ),
          const SizedBox(height: 22),

          _buildSectionHeader(
            context,
            'Security & Threat Defense',
            Icons.security_outlined,
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.shield_outlined,
            title: '6-Layer URL Safety Engine',
            subtitle:
                'Homograph attacks, punycode defense, suspicious TLDs, and heuristic port traps.',
            onTap: () => _push(context, const UrlSafetyHelpScreen()),
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.policy_outlined,
            title: 'QuishingGuard™ Tamper Detection',
            subtitle:
                'On-device computer vision analyzing physical QR sticker overlays and edge cuts.',
            onTap: () => _push(context, const QuishingGuardHelpScreen()),
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.vpn_key_outlined,
            title: 'Google Safe Browsing Setup',
            subtitle:
                'Acquiring a Google Cloud API key, hardware keystore storage, and lookup quotas.',
            onTap: () => _push(context, const SafeBrowsingHelpScreen()),
          ),
          const SizedBox(height: 22),

          _buildSectionHeader(
            context,
            'Payloads, Storage & Privacy',
            Icons.inventory_2_outlined,
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.touch_app_outlined,
            title: 'Smart Actions & Payments',
            subtitle:
                'Wi-Fi connect, UPI & crypto payments, live TOTP 2FA tokens, vCards, and events.',
            onTap: () => _push(context, const SmartPayloadsHelpScreen()),
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.history_edu_outlined,
            title: 'History, Backups & Privacy',
            subtitle:
                'Offline SQLite database, JSON/CSV backups, biometrics, and screenshot guard.',
            onTap: () => _push(context, const HistoryPrivacyHelpScreen()),
          ),
          const SizedBox(height: 10),
          _HelpTopicCard(
            icon: Icons.help_center_outlined,
            title: 'FAQ & Troubleshooting',
            subtitle:
                'Common questions, camera focus tips, permission recovery, and offline guarantees.',
            onTap: () => _push(context, const FaqTroubleshootingHelpScreen()),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
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
                Icons.help_center_rounded,
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
                    l10n.helpCenterHeaderTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.helpCenterHeaderSubtitle,
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: primary),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single help topic row, styled to match the Settings cards.
class _HelpTopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpTopicCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: accent, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
