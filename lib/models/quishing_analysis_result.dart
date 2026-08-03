import 'package:flutter/foundation.dart';

/// Risk levels determined by the QuishingGuard tamper detection engine.
enum QuishingRiskLevel {
  /// Authentic printed QR code on base substrate (Low risk).
  authentic,

  /// Physical wear, scratches, or minor environmental noise detected (Medium risk).
  wearAndTear,

  /// High risk physical overlay sticker detected around perimeter (High risk).
  highWarning,
}

/// Holds the comprehensive computer vision analysis result from QuishingGuard.
@immutable
class QuishingAnalysisResult {
  /// Overall physical tamper risk score from 0.0 (Authentic) to 1.0 (High Tamper Warning).
  final double overallRiskScore;

  /// Risk classification level.
  final QuishingRiskLevel riskLevel;

  /// Edge & Boundary Discontinuity score (0.0 to 1.0) evaluating double edges and micro-shadows.
  final double edgeDiscontinuityScore;

  /// Texture & Print Grain score (0.0 to 1.0) evaluating dot density variance and chromatic noise.
  final double textureGrainScore;

  /// Human-readable list of forensic computer vision observations.
  final List<String> detectedSignals;

  /// Summary description of the physical tampering analysis.
  final String summaryMessage;

  const QuishingAnalysisResult({
    required this.overallRiskScore,
    required this.riskLevel,
    required this.edgeDiscontinuityScore,
    required this.textureGrainScore,
    required this.detectedSignals,
    required this.summaryMessage,
  });

  /// Factory constructor helper creating a default authentic baseline.
  factory QuishingAnalysisResult.authentic({
    double edgeScore = 0.1,
    double textureScore = 0.1,
    List<String>? signals,
  }) {
    return QuishingAnalysisResult(
      overallRiskScore: (edgeScore + textureScore) / 2,
      riskLevel: QuishingRiskLevel.authentic,
      edgeDiscontinuityScore: edgeScore,
      textureGrainScore: textureScore,
      detectedSignals:
          signals ??
          const [
            'Uniform substrate reflection profile verified',
            'Halftone dot density consistent across matrix',
          ],
      summaryMessage: 'Authentic Printed Code. No physical tampering detected.',
    );
  }

  /// Label string with emoji for UI display.
  String get statusLabel {
    switch (riskLevel) {
      case QuishingRiskLevel.authentic:
        return '🟢 Authentic Printed Code';
      case QuishingRiskLevel.wearAndTear:
        return '🟡 Wear & Tear Detected';
      case QuishingRiskLevel.highWarning:
        return '🔴 High Warning: Physical Overlay Sticker Detected!';
    }
  }
}
