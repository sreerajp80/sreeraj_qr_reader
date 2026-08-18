import 'package:sreeraj_qr_reader/models/app_message.dart';
import 'package:flutter/foundation.dart';

enum AirQrStatus { idle, receiving, assembling, completed, error }

/// Model representing optical stream decoding progress.
@immutable
class AirQrProgress {
  final String? streamId;
  final int totalBlocks;
  final int receivedBlockCount;
  final Set<int> capturedIndices;
  final double fps;
  final AirQrStatus status;
  final String? reassembledContent;
  final AppMessage? errorMessage;

  const AirQrProgress({
    this.streamId,
    this.totalBlocks = 0,
    this.receivedBlockCount = 0,
    this.capturedIndices = const {},
    this.fps = 0.0,
    this.status = AirQrStatus.idle,
    this.reassembledContent,
    this.errorMessage,
  });

  double get progressPercentage {
    if (totalBlocks <= 0) return 0.0;
    return (receivedBlockCount / totalBlocks).clamp(0.0, 1.0);
  }

  int get missingBlockCount {
    if (totalBlocks <= 0) return 0;
    return (totalBlocks - receivedBlockCount).clamp(0, totalBlocks);
  }

  AirQrProgress copyWith({
    String? streamId,
    int? totalBlocks,
    int? receivedBlockCount,
    Set<int>? capturedIndices,
    double? fps,
    AirQrStatus? status,
    String? reassembledContent,
    AppMessage? errorMessage,
  }) {
    return AirQrProgress(
      streamId: streamId ?? this.streamId,
      totalBlocks: totalBlocks ?? this.totalBlocks,
      receivedBlockCount: receivedBlockCount ?? this.receivedBlockCount,
      capturedIndices: capturedIndices ?? this.capturedIndices,
      fps: fps ?? this.fps,
      status: status ?? this.status,
      reassembledContent: reassembledContent ?? this.reassembledContent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
