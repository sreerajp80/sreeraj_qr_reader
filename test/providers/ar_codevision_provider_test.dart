import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/providers/ar_codevision_provider.dart';

void main() {
  group('ArCodevisionProvider Unit Tests', () {
    late ArCodevisionProvider provider;

    setUp(() {
      provider = ArCodevisionProvider();
    });

    test('Initial mode defaults to Warehouse mode', () {
      expect(provider.hudMode, equals(ArHudMode.warehouse));
      expect(provider.targets, isEmpty);
      expect(provider.selectedCount, equals(0));
    });

    test('setHudMode updates active HUD mode', () {
      provider.setHudMode(ArHudMode.safety);
      expect(provider.hudMode, equals(ArHudMode.safety));
    });

    test('processBarcodeCapture tracks incoming barcodes', () {
      const capture = BarcodeCapture(
        barcodes: [
          Barcode(rawValue: 'https://example.com/test', type: BarcodeType.url),
          Barcode(rawValue: '8901234567890', type: BarcodeType.product),
        ],
      );

      provider.processBarcodeCapture(capture);

      expect(provider.targets.length, equals(2));
      expect(
        provider.targets.any((t) => t.rawValue == 'https://example.com/test'),
        isTrue,
      );
    });

    test('toggleTargetSelection and batch selection operations', () {
      const capture = BarcodeCapture(
        barcodes: [
          Barcode(rawValue: 'item_1', type: BarcodeType.text),
          Barcode(rawValue: 'item_2', type: BarcodeType.text),
        ],
      );

      provider.processBarcodeCapture(capture);
      expect(provider.targets.length, equals(2));

      final target1Id = provider.targets[0].id;
      provider.toggleTargetSelection(target1Id);

      expect(provider.selectedCount, equals(1));
      expect(provider.selectedTargetIds.contains(target1Id), isTrue);

      provider.selectAll();
      expect(provider.selectedCount, equals(2));

      provider.clearSelection();
      expect(provider.selectedCount, equals(0));
    });
  });
}
