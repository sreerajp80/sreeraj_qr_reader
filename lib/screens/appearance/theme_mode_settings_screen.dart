import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';

/// Configuration screen for Light / Dark / OLED / System theme mode selection.
class ThemeModeSettingsScreen extends StatelessWidget {
  const ThemeModeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final accent = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearanceThemeModeCardTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text(
            l10n.themeModeHeading.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<AppThemeMode>(
            segments: [
              ButtonSegment<AppThemeMode>(
                value: AppThemeMode.system,
                label: Text(l10n.themeChipSystem),
                icon: const Icon(Icons.brightness_auto, size: 18),
              ),
              ButtonSegment<AppThemeMode>(
                value: AppThemeMode.light,
                label: Text(l10n.themeChipLight),
                icon: const Icon(Icons.light_mode, size: 18),
              ),
              ButtonSegment<AppThemeMode>(
                value: AppThemeMode.dark,
                label: Text(l10n.themeChipDark),
                icon: const Icon(Icons.dark_mode, size: 18),
              ),
              ButtonSegment<AppThemeMode>(
                value: AppThemeMode.oled,
                label: Text(l10n.themeChipOled),
                icon: const Icon(Icons.power_settings_new, size: 18),
              ),
            ],
            selected: {themeProvider.themeMode},
            onSelectionChanged: (newSelection) {
              context.read<ThemeProvider>().setThemeMode(newSelection.first);
            },
          ),
          const SizedBox(height: 24),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: accent, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getModeDescription(l10n, themeProvider.themeMode),
                          style: TextStyle(
                            fontSize: 13.5,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getModeDescription(AppLocalizations l10n, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return l10n.themeDescSystem;
      case AppThemeMode.light:
        return l10n.themeDescLight;
      case AppThemeMode.dark:
        return l10n.themeDescDark;
      case AppThemeMode.oled:
        return l10n.themeDescOled;
    }
  }
}
