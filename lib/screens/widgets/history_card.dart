import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
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

  String _formatTimestamp(DateTime dt) {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${monthNames[dt.month - 1]} ${dt.day}, ${dt.year} • $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
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
                                  '🛡️ ${record.safetyScore}%',
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
                          _formatTimestamp(record.timestamp),
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
                    tooltip: record.isFavorite ? 'Unstar' : 'Star favorite',
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
                            const SnackBar(
                              content: Text('Copied to clipboard'),
                            ),
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
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit Notes'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'copy',
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 18),
                            SizedBox(width: 8),
                            Text('Copy String'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, size: 18),
                            SizedBox(width: 8),
                            Text('Share'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
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
