import 'dart:convert';

/// Domain model representing a persistent scan record with rich metadata.
class ScanRecord {
  final String id;
  final DateTime timestamp;
  final String rawContent;
  final String barcodeFormat;
  final String
  category; // 'url', 'wifi', 'contact', 'text', 'barcode', 'geo', 'event', 'totp'
  final String? imageThumbnail; // Base64 thumbnail or local path
  final String? locationTag;
  final int safetyScore; // 0 (dangerous) to 100 (safe)
  final String? notes;
  final bool isFavorite;
  final Map<String, dynamic>? metadata;

  const ScanRecord({
    required this.id,
    required this.timestamp,
    required this.rawContent,
    required this.barcodeFormat,
    required this.category,
    this.imageThumbnail,
    this.locationTag,
    this.safetyScore = 100,
    this.notes,
    this.isFavorite = false,
    this.metadata,
  });

  ScanRecord copyWith({
    String? id,
    DateTime? timestamp,
    String? rawContent,
    String? barcodeFormat,
    String? category,
    String? imageThumbnail,
    String? locationTag,
    int? safetyScore,
    String? notes,
    bool? isFavorite,
    Map<String, dynamic>? metadata,
  }) {
    return ScanRecord(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      rawContent: rawContent ?? this.rawContent,
      barcodeFormat: barcodeFormat ?? this.barcodeFormat,
      category: category ?? this.category,
      imageThumbnail: imageThumbnail ?? this.imageThumbnail,
      locationTag: locationTag ?? this.locationTag,
      safetyScore: safetyScore ?? this.safetyScore,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'rawContent': rawContent,
      'barcodeFormat': barcodeFormat,
      'category': category,
      'imageThumbnail': imageThumbnail,
      'locationTag': locationTag,
      'safetyScore': safetyScore,
      'notes': notes,
      'isFavorite': isFavorite ? 1 : 0,
      'metadata': metadata != null ? jsonEncode(metadata) : null,
    };
  }

  factory ScanRecord.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? parsedMetadata;
    if (map['metadata'] != null &&
        map['metadata'] is String &&
        (map['metadata'] as String).isNotEmpty) {
      try {
        parsedMetadata =
            jsonDecode(map['metadata'] as String) as Map<String, dynamic>;
      } catch (_) {
        parsedMetadata = null;
      }
    } else if (map['metadata'] is Map) {
      parsedMetadata = Map<String, dynamic>.from(map['metadata'] as Map);
    }

    return ScanRecord(
      id: map['id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      rawContent: map['rawContent'] as String? ?? '',
      barcodeFormat: map['barcodeFormat'] as String? ?? 'qrCode',
      category: map['category'] as String? ?? 'text',
      imageThumbnail: map['imageThumbnail'] as String?,
      locationTag: map['locationTag'] as String?,
      safetyScore: (map['safetyScore'] as num?)?.toInt() ?? 100,
      notes: map['notes'] as String?,
      isFavorite: (map['isFavorite'] == 1 || map['isFavorite'] == true),
      metadata: parsedMetadata,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory ScanRecord.fromJson(Map<String, dynamic> json) =>
      ScanRecord.fromMap(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanRecord &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timestamp == other.timestamp &&
          rawContent == other.rawContent &&
          barcodeFormat == other.barcodeFormat &&
          category == other.category &&
          imageThumbnail == other.imageThumbnail &&
          locationTag == other.locationTag &&
          safetyScore == other.safetyScore &&
          notes == other.notes &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode =>
      id.hashCode ^
      timestamp.hashCode ^
      rawContent.hashCode ^
      barcodeFormat.hashCode ^
      category.hashCode ^
      imageThumbnail.hashCode ^
      locationTag.hashCode ^
      safetyScore.hashCode ^
      notes.hashCode ^
      isFavorite.hashCode;
}
