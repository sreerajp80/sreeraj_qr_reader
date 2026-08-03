import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';

void main() {
  group('ScanRecord Model Tests', () {
    final testDate = DateTime(2026, 7, 31, 10, 30);
    final record = ScanRecord(
      id: 'test-123',
      timestamp: testDate,
      rawContent: 'https://example.com/test',
      barcodeFormat: 'qrCode',
      category: 'url',
      safetyScore: 95,
      notes: 'Test note',
      locationTag: 'Office',
      isFavorite: true,
      metadata: {'domain': 'example.com'},
    );

    test('toMap and fromMap serialization round-trip', () {
      final map = record.toMap();
      expect(map['id'], 'test-123');
      expect(map['category'], 'url');
      expect(map['isFavorite'], 1);

      final restored = ScanRecord.fromMap(map);
      expect(restored.id, record.id);
      expect(restored.rawContent, record.rawContent);
      expect(restored.category, record.category);
      expect(restored.safetyScore, record.safetyScore);
      expect(restored.notes, record.notes);
      expect(restored.locationTag, record.locationTag);
      expect(restored.isFavorite, true);
      expect(restored.metadata?['domain'], 'example.com');
    });

    test('copyWith creates modified copy', () {
      final updated = record.copyWith(notes: 'New note', isFavorite: false);
      expect(updated.id, record.id);
      expect(updated.notes, 'New note');
      expect(updated.isFavorite, false);
      expect(record.notes, 'Test note'); // Original unmodified
    });

    test('toJson and fromJson work as expected', () {
      final jsonMap = record.toJson();
      final restored = ScanRecord.fromJson(jsonMap);
      expect(restored, equals(record));
    });
  });
}
