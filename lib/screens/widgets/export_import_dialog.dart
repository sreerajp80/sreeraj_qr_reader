import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sreeraj_qr_reader/providers/history_provider.dart';

/// Modal dialog for choosing export format (CSV, JSON, TXT, PDF) or performing password-encrypted local backup/restore.
class ExportImportDialog extends StatefulWidget {
  const ExportImportDialog({super.key});

  @override
  State<ExportImportDialog> createState() => _ExportImportDialogState();
}

class _ExportImportDialogState extends State<ExportImportDialog> {
  final _passphraseController = TextEditingController();
  final _backupPayloadController = TextEditingController();
  bool _isRestoreMode = false;

  @override
  void dispose() {
    _passphraseController.dispose();
    _backupPayloadController.dispose();
    super.dispose();
  }

  Future<void> _handleExport(BuildContext context, ExportFormat format) async {
    final provider = Provider.of<HistoryProvider>(context, listen: false);
    final result = await provider.exportData(format);

    if (!mounted) return;

    if (format == ExportFormat.pdf) {
      final pdfBytes = result as Uint8List;
      // ignore: deprecated_member_use
      await Share.shareXFiles([
        XFile.fromData(
          pdfBytes,
          mimeType: 'application/pdf',
          name: 'Sreeraj_QR_History.pdf',
        ),
      ], text: 'Sreeraj QR Reader Scan History Report (PDF)');
    } else {
      final textResult = result as String;
      final mimeType = format == ExportFormat.csv
          ? 'text/csv'
          : format == ExportFormat.json
          ? 'application/json'
          : 'text/plain';
      final fileName = format == ExportFormat.csv
          ? 'history.csv'
          : format == ExportFormat.json
          ? 'history.json'
          : 'history.txt';

      // ignore: deprecated_member_use
      await Share.shareXFiles([
        XFile.fromData(
          utf8.encode(textResult),
          mimeType: mimeType,
          name: fileName,
        ),
      ], text: 'Sreeraj QR Reader Scan History Export');
    }
  }

  Future<void> _handleEncryptedBackup(BuildContext context) async {
    final passphrase = _passphraseController.text.trim();
    if (passphrase.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a password to encrypt your backup file.'),
        ),
      );
      return;
    }

    final provider = Provider.of<HistoryProvider>(context, listen: false);
    final backupContainer = provider.createEncryptedBackup(passphrase);
    final navigator = Navigator.of(context);

    // ignore: deprecated_member_use
    await Share.shareXFiles([
      XFile.fromData(
        utf8.encode(backupContainer),
        mimeType: 'application/json',
        name: 'sreeraj_qr_backup.sreerajqr',
      ),
    ], text: 'Sreeraj QR Reader Encrypted Backup File');

    if (mounted) navigator.pop();
  }

  Future<void> _handleRestore(BuildContext context) async {
    final passphrase = _passphraseController.text.trim();
    final backupData = _backupPayloadController.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (passphrase.isEmpty || backupData.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please provide both the password and backup content.'),
        ),
      );
      return;
    }

    final provider = Provider.of<HistoryProvider>(context, listen: false);
    try {
      final count = await provider.restoreEncryptedBackup(
        backupData,
        passphrase,
      );
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Successfully restored $count scan records!')),
        );
        navigator.pop();
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Restore failed: ${e.toString().replaceAll("FormatException: ", "")}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _isRestoreMode ? Icons.settings_backup_restore : Icons.ios_share,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            _isRestoreMode
                ? 'Restore Encrypted Backup'
                : 'Export & Cloud Backup',
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FilterChip(
                    label: const Text('Export Records'),
                    selected: !_isRestoreMode,
                    onSelected: (val) => setState(() => _isRestoreMode = false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('Restore Backup'),
                    selected: _isRestoreMode,
                    onSelected: (val) => setState(() => _isRestoreMode = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!_isRestoreMode) ...[
              Text(
                'Select Export Format:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.table_chart, color: Colors.green),
                title: const Text('CSV Format (.csv)'),
                subtitle: const Text('Compatible with Excel and Sheets'),
                onTap: () => _handleExport(context, ExportFormat.csv),
              ),
              ListTile(
                leading: const Icon(Icons.code, color: Colors.blue),
                title: const Text('JSON Dataset (.json)'),
                subtitle: const Text('Structured developer format'),
                onTap: () => _handleExport(context, ExportFormat.json),
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.orange),
                title: const Text('Formatted TXT Report (.txt)'),
                subtitle: const Text('Human readable summary document'),
                onTap: () => _handleExport(context, ExportFormat.txt),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: const Text('PDF Document Report (.pdf)'),
                subtitle: const Text('Formatted printable report table'),
                onTap: () => _handleExport(context, ExportFormat.pdf),
              ),
              const Divider(height: 24),
              Text(
                'Encrypted Local Backup File (.sreerajqr)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passphraseController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Backup Encryption Passphrase',
                  hintText: 'Enter secret passphrase...',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.security),
                  label: const Text('Create Encrypted Backup File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                  ),
                  onPressed: () => _handleEncryptedBackup(context),
                ),
              ),
            ] else ...[
              Text(
                'Restore History from Encrypted Backup File:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passphraseController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Backup Decryption Passphrase',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _backupPayloadController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Encrypted Backup Payload (.sreerajqr)',
                  hintText: 'Paste backup JSON payload string here...',
                  prefixIcon: const Icon(Icons.paste),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.content_paste),
                    onPressed: () async {
                      final data = await Clipboard.getData(
                        Clipboard.kTextPlain,
                      );
                      if (data?.text != null) {
                        _backupPayloadController.text = data!.text!;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('Decrypt & Restore History'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () => _handleRestore(context),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
