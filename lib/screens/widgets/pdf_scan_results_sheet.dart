import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';
import 'package:sreeraj_qr_reader/providers/history_provider.dart';
import 'package:sreeraj_qr_reader/services/media_scan_service.dart';

class PdfScanResultsSheet extends StatelessWidget {
  final List<PdfPageBarcode> pdfBarcodes;
  final ValueChanged<PdfPageBarcode> onSelect;

  const PdfScanResultsSheet({
    super.key,
    required this.pdfBarcodes,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'PDF Scan Results (${pdfBarcodes.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: pdfBarcodes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = pdfBarcodes[index];
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        'P${item.pageNumber}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(
                      item.rawValue,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.format.name,
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Page ${item.pageNumber}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(item);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.save_alt),
            label: Text('Save All (${pdfBarcodes.length}) to History'),
            onPressed: () {
              final historyProvider = Provider.of<HistoryProvider>(
                context,
                listen: false,
              );
              final now = DateTime.now();
              for (int i = 0; i < pdfBarcodes.length; i++) {
                final b = pdfBarcodes[i];
                final record = ScanRecord(
                  id: '${now.millisecondsSinceEpoch}_$i',
                  timestamp: now,
                  rawContent: b.rawValue,
                  barcodeFormat: b.format.name,
                  category: 'pdf_scan',
                  notes: 'Scanned from PDF (Page ${b.pageNumber})',
                );
                historyProvider.addScanRecord(record);
              }
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Saved ${pdfBarcodes.length} codes to history.',
                  ),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
