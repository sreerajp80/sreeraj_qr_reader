import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';

/// Modal bottom sheet displaying detailed scan record metadata with note editing and location tagging.
class HistoryDetailSheet extends StatefulWidget {
  final ScanRecord record;
  final Function(String? notes, String? locationTag) onSave;

  const HistoryDetailSheet({
    super.key,
    required this.record,
    required this.onSave,
  });

  @override
  State<HistoryDetailSheet> createState() => _HistoryDetailSheetState();
}

class _HistoryDetailSheetState extends State<HistoryDetailSheet> {
  late TextEditingController _notesController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.record.notes ?? '');
    _locationController = TextEditingController(
      text: widget.record.locationTag ?? '',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scan Record Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(widget.record.category.toUpperCase()),
                  backgroundColor: theme.colorScheme.primaryContainer,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(widget.record.barcodeFormat),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
                const Spacer(),
                Text(
                  '🛡️ ${widget.record.safetyScore}% Safe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.record.safetyScore < 70
                        ? Colors.orange.shade800
                        : Colors.green.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Scanned Content:',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                widget.record.rawContent,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy'),
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: widget.record.rawContent),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Share'),
                  // ignore: deprecated_member_use
                  onPressed: () => Share.share(widget.record.rawContent),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Custom User Notes',
                hintText: 'Add personal notes or remarks about this scan...',
                prefixIcon: Icon(Icons.note_alt_outlined),
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location Tag (Optional)',
                hintText: 'e.g. Office Desk, Grocery Store, Conference',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Metadata Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final notes = _notesController.text.trim();
                  final loc = _locationController.text.trim();
                  widget.onSave(
                    notes.isEmpty ? null : notes,
                    loc.isEmpty ? null : loc,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
