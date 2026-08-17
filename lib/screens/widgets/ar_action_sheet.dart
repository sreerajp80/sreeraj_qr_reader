import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/models/ar_code_target.dart';
import 'package:sreeraj_qr_reader/providers/ar_codevision_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Non-blocking floating action sheet for examining tapped AR targets.
class ArActionSheet extends StatelessWidget {
  final ArCodeTarget target;
  final VoidCallback onClose;

  const ArActionSheet({super.key, required this.target, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final provider = Provider.of<ArCodevisionProvider>(context, listen: false);

    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surface,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        target.isUrl ? Icons.link : Icons.qr_code,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        target.formatName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    tooltip: l10n.arCloseSheet,
                  ),
                ],
              ),
              const Divider(height: 12),
              const SizedBox(height: 4),
              // Safety HUD Badge Indicator
              if (target.isUrl) ...[
                Row(
                  children: [
                    _getSafetyIcon(target.safetyStatus),
                    const SizedBox(width: 8),
                    Text(
                      _getSafetyText(l10n, target.safetyStatus),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getSafetyColor(target.safetyStatus),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              // Raw Value content display
              SelectableText(
                target.rawValue,
                style: theme.textTheme.bodyMedium,
                maxLines: 4,
              ),
              const SizedBox(height: 8),
              if (provider.hudMode == ArHudMode.warehouse)
                Text(
                  l10n.arItemPriceTag(target.priceTag),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 12),
              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: target.rawValue));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.arContentCopied),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text(l10n.arCopyButton),
                  ),
                  const SizedBox(width: 8),
                  if (target.isUrl)
                    FilledButton.icon(
                      onPressed: () async {
                        final uri = Uri.tryParse(target.rawValue);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      icon: const Icon(Icons.open_in_browser, size: 18),
                      label: Text(l10n.arOpenUrlButton),
                    )
                  else
                    FilledButton.icon(
                      onPressed: () {
                        provider.toggleTargetSelection(target.id);
                        onClose();
                      },
                      icon: Icon(
                        target.isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 18,
                      ),
                      label: Text(
                        target.isSelected
                            ? l10n.arDeselectButton
                            : l10n.arSelectButton,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Icon _getSafetyIcon(TargetSafetyStatus status) {
    switch (status) {
      case TargetSafetyStatus.safe:
        return const Icon(Icons.verified_user, color: Colors.green);
      case TargetSafetyStatus.warning:
        return const Icon(Icons.gpp_maybe, color: Colors.red);
      case TargetSafetyStatus.unknown:
        return const Icon(Icons.help_outline, color: Colors.amber);
    }
  }

  String _getSafetyText(AppLocalizations l10n, TargetSafetyStatus status) {
    switch (status) {
      case TargetSafetyStatus.safe:
        return l10n.arSafetyStatusSafe;
      case TargetSafetyStatus.warning:
        return l10n.arSafetyStatusWarning;
      case TargetSafetyStatus.unknown:
        return l10n.arSafetyStatusUnknown;
    }
  }

  Color _getSafetyColor(TargetSafetyStatus status) {
    switch (status) {
      case TargetSafetyStatus.safe:
        return Colors.green;
      case TargetSafetyStatus.warning:
        return Colors.red;
      case TargetSafetyStatus.unknown:
        return Colors.amber.shade800;
    }
  }
}
