import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/ar_code_target.dart';

/// Pure service handling coordinate transformations, target decay,
/// and metadata formatting for AR CodeVision HUD mode.
class ArSpatialService {
  /// Transforms camera frame coordinates to screen viewport logical coordinates.
  Offset convertFrameToScreenOffset({
    required Offset framePoint,
    required Size imageSize,
    required Size screenSize,
  }) {
    if (imageSize.width <= 0 || imageSize.height <= 0) {
      return framePoint;
    }

    final scaleX = screenSize.width / imageSize.width;
    final scaleY = screenSize.height / imageSize.height;

    return Offset(framePoint.dx * scaleX, framePoint.dy * scaleY);
  }

  /// Calculates the center anchor point for placing an AR chip over a target.
  Offset calculateTargetCenter(List<Offset> corners, Rect boundingBox) {
    if (corners.isNotEmpty) {
      double sumX = 0;
      double sumY = 0;
      for (final corner in corners) {
        sumX += corner.dx;
        sumY += corner.dy;
      }
      return Offset(sumX / corners.length, sumY / corners.length);
    }
    return boundingBox.center;
  }

  /// Filters out targets that have not been updated within [decayDuration].
  List<ArCodeTarget> decayStaleTargets(
    List<ArCodeTarget> targets, {
    Duration decayDuration = const Duration(milliseconds: 1500),
  }) {
    final now = DateTime.now();
    return targets.where((target) {
      return now.difference(target.lastSeen) <= decayDuration;
    }).toList();
  }

  /// Generates human-readable format names for barcode types.
  String getFormatDisplayName(BarcodeType type, String rawValue) {
    switch (type) {
      case BarcodeType.url:
        return 'QR (URL)';
      case BarcodeType.email:
        return 'QR (Email)';
      case BarcodeType.phone:
        return 'QR (Phone)';
      case BarcodeType.sms:
        return 'QR (SMS)';
      case BarcodeType.wifi:
        return 'QR (Wi-Fi)';
      case BarcodeType.geo:
        return 'QR (Location)';
      case BarcodeType.contactInfo:
        return 'QR (Contact)';
      case BarcodeType.isbn:
        return 'ISBN';
      case BarcodeType.product:
        return 'EAN/UPC';
      case BarcodeType.text:
      default:
        if (rawValue.startsWith('http://') || rawValue.startsWith('https://')) {
          return 'QR Code';
        }
        if (RegExp(r'^\d{8}$|^\d{12,13}$').hasMatch(rawValue)) {
          return 'EAN/UPC Product';
        }
        return 'Barcode';
    }
  }

  /// Generates price tag / retail label for Warehouse Mode.
  String generatePriceTag(String rawValue, BarcodeType type) {
    if (rawValue.isEmpty) return '\$0.00';
    // Generate deterministic price representation based on barcode content hash
    final hash = rawValue.codeUnits.fold(0, (prev, elem) => prev + elem);
    final dollars = (hash % 95) + 5;
    final cents = (hash % 100).toString().padLeft(2, '0');
    return '\$$dollars.$cents';
  }
}
