import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';

/// Card widget rendering a single scan history item with rich metadata badges and quick actions.
class HistoryCard extends StatelessWidget {
  final ScanRecord record;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onEditNotes;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.record,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onEditNotes,
    required this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'url':
        return Icons.link;
      case 'wifi':
        return Icons.wifi;
      case 'contact':
        return Icons.person;
      case 'geo':
        return Icons.location_on;
      case 'event':
        return Icons.event;
      case 'payment':
        return Icons.payment;
      case 'totp':
        return Icons.vpn_key;
      case 'barcode':
        return Icons.qr_code_2;
      default:
        return Icons.text_snippet;
    }
  }

  Color _getCategoryColor(BuildContext context, String category) {
    final theme = Theme.of(context);
    switch (category.toLowerCase()) {
      case 'url':
        return Colors.blue;
      case 'wifi':
        return Colors.green;
      case 'contact':
        return Colors.orange;
      case 'geo':
        return Colors.redAccent;
      case 'event':
        return Colors.teal;
      case 'payment':
        return Colors.deepPurple;
      case 'totp':
        return Colors.amber.shade800;
      case 'barcode':
        return Colors.indigo;
      default:
        return theme.colorScheme.secondary;
    }
  }

  /// Formats the scan time using the reader's own locale, so month names and
  /// the 12- or 24-hour clock follow the device language.
  String _formatTimestamp(AppLocalizations l10n, DateTime dt) {
    final locale = l10n.localeName;
    return l10n.historyTimestamp(
      DateFormat.yMMMd(locale).format(dt),
      DateFormat.jm(locale).format(dt),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final catColor = _getCategoryColor(context, record.category);
    final catIcon = _getCategoryIcon(record.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(catIcon, color: catColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                record.barcodeFormat.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (record.safetyScore < 100)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: record.safetyScore < 50
                                      ? Colors.red.shade100
                                      : Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  l10n.historyScoreBadge(record.safetyScore),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: record.safetyScore < 50
                                        ? Colors.red.shade900
                                        : Colors.amber.shade900,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatTimestamp(l10n, record.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      record.isFavorite ? Icons.star : Icons.star_border,
                      color: record.isFavorite
                          ? Colors.amber.shade700
                          : Colors.grey,
                    ),
                    onPressed: onToggleFavorite,
                    tooltip: record.isFavorite
                        ? l10n.historyUnstar
                        : l10n.historyStar,
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        onEditNotes();
                      } else if (value == 'copy') {
                        await Clipboard.setData(
                          ClipboardData(text: record.rawContent),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.copiedToClipboard)),
                          );
                        }
                      } else if (value == 'share') {
                        // ignore: deprecated_member_use
                        await Share.share(record.rawContent);
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 18),
                            const SizedBox(width: 8),
                            Text(l10n.historyEditNotes),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'copy',
                        child: Row(
                          children: [
                            const Icon(Icons.copy, size: 18),
                            const SizedBox(width: 8),
                            Text(l10n.historyCopyString),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            const Icon(Icons.share, size: 18),
                            const SizedBox(width: 8),
                            Text(l10n.historyShare),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.historyDelete,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                record.rawContent,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if ((record.notes != null && record.notes!.isNotEmpty) ||
                  (record.locationTag != null &&
                      record.locationTag!.isNotEmpty)) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    if (record.notes != null && record.notes!.isNotEmpty)
                      Chip(
                        avatar: const Icon(Icons.note_alt_outlined, size: 14),
                        label: Text(
                          record.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    if (record.locationTag != null &&
                        record.locationTag!.isNotEmpty)
                      Chip(
                        avatar: const Icon(Icons.location_on, size: 14),
                        label: Text(
                          record.locationTag!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
