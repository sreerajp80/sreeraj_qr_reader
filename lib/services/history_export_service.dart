import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:sreeraj_qr_reader/models/backup_exception.dart';
import 'package:sreeraj_qr_reader/models/history_report_labels.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';

/// Service providing export capabilities (CSV, JSON, TXT, PDF) and encrypted backup/restore.
class HistoryExportService {
  /// Converts scan records into a formatted CSV string.
  String exportToCsv(List<ScanRecord> records) {
    final buffer = StringBuffer();
    // Headers
    buffer.writeln(
      'ID,Timestamp,Barcode Format,Category,Safety Score,Favorite,Location Tag,Notes,Raw Content',
    );

    for (final record in records) {
      final id = _escapeCsv(record.id);
      final timestamp = _escapeCsv(record.timestamp.toIso8601String());
      final format = _escapeCsv(record.barcodeFormat);
      final category = _escapeCsv(record.category);
      final score = record.safetyScore;
      final favorite = record.isFavorite ? 'Yes' : 'No';
      final location = _escapeCsv(record.locationTag ?? '');
      final notes = _escapeCsv(record.notes ?? '');
      final content = _escapeCsv(record.rawContent);

      buffer.writeln(
        '$id,$timestamp,$format,$category,$score,$favorite,$location,$notes,$content',
      );
    }

    return buffer.toString();
  }

  String _escapeCsv(String input) {
    if (input.contains(',') || input.contains('"') || input.contains('\n')) {
      final escaped = input.replaceAll('"', '""');
      return '"$escaped"';
    }
    return input;
  }

  /// Converts scan records into a formatted JSON string.
  String exportToJson(List<ScanRecord> records) {
    final list = records.map((r) => r.toJson()).toList();
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert({
      'app': 'Sreeraj P QR Reader',
      'version': '2.4.3',
      'exportedAt': DateTime.now().toIso8601String(),
      'totalRecords': records.length,
      'records': list,
    });
  }

  /// Converts scan records into a human-readable text report.
  ///
  /// [labels] carries the wording, already localized by the caller.
  String exportToFormattedTxt(
    List<ScanRecord> records,
    HistoryReportLabels labels,
  ) {
    const rule = '====================================================';
    final buffer = StringBuffer();
    buffer.writeln(rule);
    buffer.writeln('          ${labels.reportHeading}        ');
    buffer.writeln(rule);
    buffer.writeln('${labels.exportDateLabel}: ${DateTime.now()}');
    buffer.writeln('${labels.totalScansLabel}: ${records.length}');
    buffer.writeln(rule);
    buffer.writeln();

    for (var i = 0; i < records.length; i++) {
      final r = records[i];
      buffer.writeln('${labels.scanNumberLabel}${i + 1}');
      buffer.writeln('${labels.idLabel}: ${r.id}');
      buffer.writeln('${labels.timestampLabel}: ${r.timestamp}');
      buffer.writeln('${labels.formatLabel}: ${r.barcodeFormat}');
      buffer.writeln('${labels.categoryLabel}: ${r.category.toUpperCase()}');
      buffer.writeln('${labels.safetyScoreLabel}: ${r.safetyScore}%');
      buffer.writeln(
        '${labels.starredLabel}: '
        '${r.isFavorite ? labels.starredYes : labels.starredNo}',
      );
      if (r.locationTag != null && r.locationTag!.isNotEmpty) {
        buffer.writeln('${labels.locationLabel}: ${r.locationTag}');
      }
      if (r.notes != null && r.notes!.isNotEmpty) {
        buffer.writeln('${labels.notesLabel}: ${r.notes}');
      }
      buffer.writeln('${labels.contentLabel}: ${r.rawContent}');
      buffer.writeln('----------------------------------------------------');
    }

    return buffer.toString();
  }

  /// Renders scan records into a formatted PDF document byte buffer.
  Future<Uint8List> exportToPdf(
    List<ScanRecord> records,
    HistoryReportLabels labels,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 20.0),
            padding: const pw.EdgeInsets.only(bottom: 5.0),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey400),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  labels.reportHeading,
                  style: const pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.Text(
                  '${context.pageNumber} / ${context.pagesCount}',
                  style: const pw.TextStyle(
                    color: PdfColors.grey600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  labels.reportTitle,
                  style: const pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.Text(
                  '${labels.totalScansLabel}: ${records.length}',
                  style: const pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: [
              '#',
              labels.columnDateTime,
              labels.columnFormat,
              labels.columnCategory,
              labels.columnSafety,
              labels.columnContent,
              labels.columnNotes,
            ],
            data: List<List<String>>.generate(records.length, (index) {
              final r = records[index];
              final dateStr = r.timestamp.toString().substring(0, 16);
              final contentSnippet = r.rawContent.length > 40
                  ? '${r.rawContent.substring(0, 37)}...'
                  : r.rawContent;
              return [
                '${index + 1}',
                dateStr,
                r.barcodeFormat,
                r.category.toUpperCase(),
                '${r.safetyScore}%',
                contentSnippet,
                r.notes ?? '-',
              ];
            }),
            headerStyle: const pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5),
              ),
            ),
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: const pw.TextStyle(fontSize: 9),
            columnWidths: {
              0: const pw.FixedColumnWidth(20),
              1: const pw.FixedColumnWidth(80),
              2: const pw.FixedColumnWidth(60),
              3: const pw.FixedColumnWidth(60),
              4: const pw.FixedColumnWidth(40),
              5: const pw.FlexColumnWidth(2),
              6: const pw.FlexColumnWidth(),
            },
          ),
        ],
      ),
    );

    return await pdf.save();
  }

  /// Encrypts scan history with a passphrase into a binary/string backup package (`.sreerajqr`).
  String createEncryptedBackup(List<ScanRecord> records, String passphrase) {
    final jsonStr = exportToJson(records);

    // Derive 256-bit key from passphrase SHA-256 hash
    final bytes = utf8.encode(passphrase);
    final digest = sha256.convert(bytes);
    final key = enc.Key(Uint8List.fromList(digest.bytes));

    // Create fixed IV for backup container compatibility
    final iv = enc.IV(Uint8List.fromList(digest.bytes.sublist(0, 16)));
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    final encrypted = encrypter.encrypt(jsonStr, iv: iv);

    final payload = {
      'header': 'SREERAJ_QR_BACKUP_V1',
      'encryptedData': encrypted.base64,
    };

    return jsonEncode(payload);
  }

  /// Decrypts and restores scan history from an encrypted backup container (`.sreerajqr`).
  List<ScanRecord> restoreEncryptedBackup(
    String backupContent,
    String passphrase,
  ) {
    Map<String, dynamic> container;
    try {
      container = jsonDecode(backupContent) as Map<String, dynamic>;
    } catch (_) {
      throw const BackupException(
        AppMessage(AppMessageKey.backupInvalidFormat),
      );
    }

    if (container['header'] != 'SREERAJ_QR_BACKUP_V1' ||
        container['encryptedData'] == null) {
      throw const BackupException(AppMessage(AppMessageKey.backupBadHeader));
    }

    final encryptedB64 = container['encryptedData'] as String;

    final bytes = utf8.encode(passphrase);
    final digest = sha256.convert(bytes);
    final key = enc.Key(Uint8List.fromList(digest.bytes));
    final iv = enc.IV(Uint8List.fromList(digest.bytes.sublist(0, 16)));
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    String decryptedJson;
    try {
      decryptedJson = encrypter.decrypt64(encryptedB64, iv: iv);
    } catch (_) {
      throw const BackupException(
        AppMessage(AppMessageKey.backupWrongPassphrase),
      );
    }

    final data = jsonDecode(decryptedJson) as Map<String, dynamic>;
    final recordsList = data['records'] as List<dynamic>?;

    if (recordsList == null) {
      return [];
    }

    return recordsList
        .map((item) => ScanRecord.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
