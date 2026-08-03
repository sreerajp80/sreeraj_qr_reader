import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/ar_code_target.dart';
import 'package:sreeraj_qr_reader/services/ar_spatial_service.dart';

void main() {
  group('ArSpatialService Unit Tests', () {
    late ArSpatialService service;

    setUp(() {
      service = ArSpatialService();
    });

    test('convertFrameToScreenOffset converts frame point correctly', () {
      const framePoint = Offset(360, 640);
      const imageSize = Size(720, 1280);
      const screenSize = Size(360, 640);

      final result = service.convertFrameToScreenOffset(
        framePoint: framePoint,
        imageSize: imageSize,
        screenSize: screenSize,
      );

      expect(result.dx, equals(180.0));
      expect(result.dy, equals(320.0));
    });

    test('calculateTargetCenter calculates average from corners', () {
      const corners = [
        Offset(0, 0),
        Offset(100, 0),
        Offset(100, 100),
        Offset(0, 100),
      ];

      final center = service.calculateTargetCenter(corners, Rect.zero);
      expect(center, equals(const Offset(50, 50)));
    });

    test('decayStaleTargets removes targets older than decayDuration', () {
      final now = DateTime.now();
      final targets = [
        ArCodeTarget(
          id: 'fresh',
          rawValue: 'https://example.com',
          type: BarcodeType.url,
          corners: const [],
          boundingBox: Rect.zero,
          isUrl: true,
          safetyStatus: TargetSafetyStatus.safe,
          priceTag: '\$10.00',
          formatName: 'QR Code',
          isSelected: false,
          lastSeen: now,
        ),
        ArCodeTarget(
          id: 'stale',
          rawValue: '12345678',
          type: BarcodeType.product,
          corners: const [],
          boundingBox: Rect.zero,
          isUrl: false,
          safetyStatus: TargetSafetyStatus.safe,
          priceTag: '\$5.00',
          formatName: 'EAN',
          isSelected: false,
          lastSeen: now.subtract(const Duration(seconds: 3)),
        ),
      ];

      final activeTargets = service.decayStaleTargets(
        targets,
        decayDuration: const Duration(seconds: 2),
      );

      expect(activeTargets.length, equals(1));
      expect(activeTargets.first.id, equals('fresh'));
    });

    test('generatePriceTag produces consistent price string for input', () {
      final price1 = service.generatePriceTag('123456789', BarcodeType.product);
      final price2 = service.generatePriceTag('123456789', BarcodeType.product);

      expect(price1, startsWith('\$'));
      expect(price1, equals(price2));
    });
  });
}
