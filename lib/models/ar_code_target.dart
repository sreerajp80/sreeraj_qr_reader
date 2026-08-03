import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Represents the safety status of a detected target in Safety HUD mode.
enum TargetSafetyStatus { safe, warning, unknown }

/// Immutable model representing a single tracked barcode/QR code target in AR space.
@immutable
class ArCodeTarget {
  final String id;
  final String rawValue;
  final BarcodeType type;
  final List<Offset> corners;
  final Rect boundingBox;
  final bool isUrl;
  final TargetSafetyStatus safetyStatus;
  final String priceTag;
  final String formatName;
  final bool isSelected;
  final DateTime lastSeen;

  const ArCodeTarget({
    required this.id,
    required this.rawValue,
    required this.type,
    required this.corners,
    required this.boundingBox,
    required this.isUrl,
    required this.safetyStatus,
    required this.priceTag,
    required this.formatName,
    required this.isSelected,
    required this.lastSeen,
  });

  ArCodeTarget copyWith({
    String? id,
    String? rawValue,
    BarcodeType? type,
    List<Offset>? corners,
    Rect? boundingBox,
    bool? isUrl,
    TargetSafetyStatus? safetyStatus,
    String? priceTag,
    String? formatName,
    bool? isSelected,
    DateTime? lastSeen,
  }) {
    return ArCodeTarget(
      id: id ?? this.id,
      rawValue: rawValue ?? this.rawValue,
      type: type ?? this.type,
      corners: corners ?? this.corners,
      boundingBox: boundingBox ?? this.boundingBox,
      isUrl: isUrl ?? this.isUrl,
      safetyStatus: safetyStatus ?? this.safetyStatus,
      priceTag: priceTag ?? this.priceTag,
      formatName: formatName ?? this.formatName,
      isSelected: isSelected ?? this.isSelected,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArCodeTarget &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          rawValue == other.rawValue &&
          isSelected == other.isSelected &&
          safetyStatus == other.safetyStatus;

  @override
  int get hashCode =>
      id.hashCode ^
      rawValue.hashCode ^
      isSelected.hashCode ^
      safetyStatus.hashCode;
}
