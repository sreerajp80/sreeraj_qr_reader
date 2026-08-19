import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';
import 'package:sreeraj_qr_reader/models/backup_exception.dart';
import 'package:sreeraj_qr_reader/models/history_report_labels.dart';
import 'package:sreeraj_qr_reader/services/history_export_service.dart';

void main() {
  const testLabels = HistoryReportLabels(
    reportHeading: 'SREERAJ P QR READER - SCAN HISTORY',
    reportTitle: 'Scan History Export',
    exportDateLabel: 'Export Date',
    totalScansLabel: 'Total Scans',
    scanNumberLabel: 'Scan #',
    idLabel: 'ID           ',
    timestampLabel: 'Timestamp    ',
    formatLabel: 'Format       ',
    categoryLabel: 'Category     ',
    safetyScoreLabel: 'Safety Score ',
    starredLabel: 'Starred      ',
    starredYes: '⭐ Yes',
    starredNo: 'No',
    locationLabel: 'Location     ',
    notesLabel: 'Notes        ',
    contentLabel: 'Content      ',
    columnDateTime: 'Date & Time',
    columnFormat: 'Format',
    columnCategory: 'Category',
    columnSafety: 'Safety',
    columnContent: 'Content Snippet',
    columnNotes: 'Notes',
  );

  group('HistoryExportService Tests', () {
    late HistoryExportService service;
    late List<ScanRecord> records;

    setUp(() {
      service = HistoryExportService();
      records = [
        ScanRecord(
          id: 'rec-1',
          timestamp: DateTime(2026, 7, 31, 8),
          rawContent: 'https://secure-site.com',
          barcodeFormat: 'qrCode',
          category: 'url',
          notes: 'Important link',
          locationTag: 'Work',
          isFavorite: true,
        ),
        ScanRecord(
          id: 'rec-2',
          timestamp: DateTime(2026, 7, 31, 9, 30),
          rawContent: 'WIFI:S:MyRouter;T:WPA;P:secret123;;',
          barcodeFormat: 'qrCode',
          category: 'wifi',
        ),
      ];
    });

    test('exportToCsv generates valid CSV with headers and records', () {
      final csv = service.exportToCsv(records);
      expect(csv, contains('ID,Timestamp,Barcode Format,Category'));
      expect(csv, contains('rec-1'));
      expect(csv, contains('https://secure-site.com'));
      expect(csv, contains('WIFI:S:MyRouter'));
    });

    test('exportToJson generates structured JSON with app metadata', () {
      final jsonStr = service.exportToJson(records);
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(map['app'], 'SreerajP QR Reader');
      expect(map['totalRecords'], 2);
      expect((map['records'] as List).length, 2);
    });

    test('exportToFormattedTxt generates readable report', () {
      final txt = service.exportToFormattedTxt(records, testLabels);
      expect(txt, contains('SREERAJ P QR READER - SCAN HISTORY'));
      expect(txt, contains('Total Scans: 2'));
      expect(txt, contains('Category     : URL'));
      expect(txt, contains('Category     : WIFI'));
    });

    test('exportToPdf generates non-empty PDF byte array', () async {
      final pdfBytes = await service.exportToPdf(records, testLabels);
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(100));
    });

    test('createEncryptedBackup and restoreEncryptedBackup round-trip', () {
      const passphrase = 'MySuperSecretPassword123!';
      final backupStr = service.createEncryptedBackup(records, passphrase);

      expect(backupStr, contains('SREERAJ_QR_BACKUP_V1'));

      final restored = service.restoreEncryptedBackup(backupStr, passphrase);
      expect(restored.length, 2);
      expect(restored[0].id, 'rec-1');
      expect(restored[0].rawContent, 'https://secure-site.com');
      expect(restored[1].id, 'rec-2');
    });

    test(
      'restoreEncryptedBackup throws BackupException with incorrect passphrase',
      () {
        const passphrase = 'RightPassword';
        const wrongPassphrase = 'WrongPassword';
        final backupStr = service.createEncryptedBackup(records, passphrase);

        expect(
          () => service.restoreEncryptedBackup(backupStr, wrongPassphrase),
          throwsA(isA<BackupException>()),
        );
      },
    );
  });
}
