import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';

/// Configuration screen for scanner viewport frame overlay styles.
class ScanOverlaySettingsScreen extends StatelessWidget {
  const ScanOverlaySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearanceOverlayCardTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                _buildOverlayTile(
                  context: context,
                  themeProvider: themeProvider,
                  style: ScanOverlayStyle.laserLine,
                  icon: Icons.linear_scale,
                  title: l10n.overlayLaserLine,
                  subtitle: l10n.overlayLaserLineDesc,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildOverlayTile(
                  context: context,
                  themeProvider: themeProvider,
                  style: ScanOverlayStyle.pulsingCorners,
                  icon: Icons.crop_free,
                  title: l10n.overlayPulsingCorners,
                  subtitle: l10n.overlayPulsingCornersDesc,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildOverlayTile(
                  context: context,
                  themeProvider: themeProvider,
                  style: ScanOverlayStyle.cyberneticGrid,
                  icon: Icons.grid_4x4,
                  title: l10n.overlayCyberneticGrid,
                  subtitle: l10n.overlayCyberneticGridDesc,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildOverlayTile(
                  context: context,
                  themeProvider: themeProvider,
                  style: ScanOverlayStyle.subtleDotMatrix,
                  icon: Icons.grain,
                  title: l10n.overlaySubtleDotMatrix,
                  subtitle: l10n.overlaySubtleDotMatrixDesc,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayTile({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required ScanOverlayStyle style,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = themeProvider.scanOverlayStyle == style;
    final accent = Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: isSelected ? 0.16 : 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isSelected ? accent : Colors.grey, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        isSelected ? Icons.check_circle : Icons.circle_outlined,
        color: isSelected ? accent : Colors.grey,
      ),
      onTap: () => themeProvider.setScanOverlayStyle(style),
    );
  }
}
