import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';

/// Configuration screen for Font size scaling preferences and typography display.
class TypographySettingsScreen extends StatefulWidget {
  const TypographySettingsScreen({super.key});

  @override
  State<TypographySettingsScreen> createState() =>
      _TypographySettingsScreenState();
}

class _TypographySettingsScreenState extends State<TypographySettingsScreen> {
  double _textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final accent = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearanceTypographyCardTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildLabel(context, 'LIVE SAMPLE PREVIEW'),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: TextStyle(
                      fontSize: 18 * _textScale,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'https://sreeraj.in/qr-reader/verify?id=987213',
                    style: TextStyle(
                      fontSize: 14 * _textScale,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '6-Layer URL Safety Check • 100% Offline QuishingGuard™ CV Engine',
                    style: TextStyle(
                      fontSize: 13 * _textScale,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildLabel(context, 'TEXT SCALE FACTOR'),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scale Preference',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${(_textScale * 100).toInt()}%',
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _textScale,
                    min: 0.85,
                    max: 1.3,
                    divisions: 3,
                    label: '${(_textScale * 100).toInt()}%',
                    onChanged: (val) {
                      setState(() => _textScale = val);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Compact (85%)',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Standard (100%)',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Large (130%)',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
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
                    child: Text(
                      'The app layout dynamically scales with your Android system accessibility font settings while preserving scan barcode alignment and high-density HUD legibility.',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
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

  Widget _buildLabel(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
      ),
    );
  }
}
