import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/ar_code_target.dart';
import 'package:sreeraj_qr_reader/services/ar_spatial_service.dart';
import 'package:sreeraj_qr_reader/services/url_safety_service.dart';

/// HUD operating mode for AR CodeVision viewport.
enum ArHudMode { warehouse, safety }

/// State provider for AR CodeVision spatial scanning HUD.
class ArCodevisionProvider with ChangeNotifier {
  final ArSpatialService _spatialService;
  final UrlSafetyService _urlSafetyService;

  ArHudMode _hudMode = ArHudMode.warehouse;
  List<ArCodeTarget> _targets = [];
  final Set<String> _selectedTargetIds = {};
  ArCodeTarget? _sheetTarget;

  ArCodevisionProvider({
    ArSpatialService? spatialService,
    UrlSafetyService? urlSafetyService,
  }) : _spatialService = spatialService ?? ArSpatialService(),
       _urlSafetyService = urlSafetyService ?? UrlSafetyService();

  ArHudMode get hudMode => _hudMode;
  List<ArCodeTarget> get targets => List.unmodifiable(_targets);
  Set<String> get selectedTargetIds => Set.unmodifiable(_selectedTargetIds);
  ArCodeTarget? get sheetTarget => _sheetTarget;
  int get selectedCount => _selectedTargetIds.length;

  /// Changes active HUD mode (Warehouse vs Safety HUD).
  void setHudMode(ArHudMode mode) {
    if (_hudMode != mode) {
      _hudMode = mode;
      notifyListeners();
    }
  }

  /// Processes fresh frame capture from MobileScanner.
  void processBarcodeCapture(BarcodeCapture capture) {
    final now = DateTime.now();
    final List<ArCodeTarget> updatedTargets = List.from(_targets);

    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue == null || rawValue.isEmpty) continue;

      final id = rawValue.hashCode.toString();
      final isUrl =
          rawValue.startsWith('http://') ||
          rawValue.startsWith('https://') ||
          barcode.type == BarcodeType.url;

      final existingIndex = updatedTargets.indexWhere((t) => t.id == id);
      final isSelected = _selectedTargetIds.contains(id);
      final boundingBox = _computeBoundingBox(barcode.corners);

      if (existingIndex >= 0) {
        // Update existing target with latest position & timestamp
        final existing = updatedTargets[existingIndex];
        updatedTargets[existingIndex] = existing.copyWith(
          corners: barcode.corners,
          boundingBox: boundingBox,
          isSelected: isSelected,
          lastSeen: now,
        );
      } else {
        // Add new target
        final formatName = _spatialService.getFormatDisplayName(
          barcode.type,
          rawValue,
        );
        final priceTag = _spatialService.generatePriceTag(
          rawValue,
          barcode.type,
        );

        final newTarget = ArCodeTarget(
          id: id,
          rawValue: rawValue,
          type: barcode.type,
          corners: barcode.corners,
          boundingBox: boundingBox,
          isUrl: isUrl,
          safetyStatus: isUrl
              ? TargetSafetyStatus.unknown
              : TargetSafetyStatus.safe,
          priceTag: priceTag,
          formatName: formatName,
          isSelected: isSelected,
          lastSeen: now,
        );

        updatedTargets.add(newTarget);

        // Perform async safety verification for URLs in Safety HUD mode
        if (isUrl) {
          _verifyTargetSafety(id, rawValue);
        }
      }
    }

    // Decay stale targets that disappeared from camera frame
    _targets = _spatialService.decayStaleTargets(updatedTargets);
    notifyListeners();
  }

  Rect _computeBoundingBox(List<Offset> corners) {
    if (corners.isEmpty) return Rect.zero;
    double minX = corners.first.dx;
    double maxX = corners.first.dx;
    double minY = corners.first.dy;
    double maxY = corners.first.dy;
    for (final c in corners) {
      if (c.dx < minX) minX = c.dx;
      if (c.dx > maxX) maxX = c.dx;
      if (c.dy < minY) minY = c.dy;
      if (c.dy > maxY) maxY = c.dy;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Verifies safety status of detected URL target asynchronously.
  Future<void> _verifyTargetSafety(String targetId, String url) async {
    try {
      final results = await _urlSafetyService.runAllChecks(url);
      final isSafe = results.every((r) => r.passed);

      final index = _targets.indexWhere((t) => t.id == targetId);
      if (index >= 0) {
        final target = _targets[index];
        final safetyStatus = isSafe
            ? TargetSafetyStatus.safe
            : TargetSafetyStatus.warning;

        _targets[index] = target.copyWith(safetyStatus: safetyStatus);
        notifyListeners();
      }
    } catch (_) {
      // In case of error, default to unknown
    }
  }

  /// Toggles multi-item selection state for batch actions.
  void toggleTargetSelection(String id) {
    if (_selectedTargetIds.contains(id)) {
      _selectedTargetIds.remove(id);
    } else {
      _selectedTargetIds.add(id);
    }

    _targets = _targets.map((target) {
      if (target.id == id) {
        return target.copyWith(isSelected: _selectedTargetIds.contains(id));
      }
      return target;
    }).toList();

    notifyListeners();
  }

  /// Selects all active targets.
  void selectAll() {
    for (final target in _targets) {
      _selectedTargetIds.add(target.id);
    }
    _targets = _targets.map((t) => t.copyWith(isSelected: true)).toList();
    notifyListeners();
  }

  /// Clears batch target selection.
  void clearSelection() {
    _selectedTargetIds.clear();
    _targets = _targets.map((t) => t.copyWith(isSelected: false)).toList();
    notifyListeners();
  }

  /// Sets currently expanded action sheet target.
  void selectTargetForSheet(ArCodeTarget target) {
    _sheetTarget = target;
    notifyListeners();
  }

  /// Clears active action sheet target.
  void clearSheetTarget() {
    _sheetTarget = null;
    notifyListeners();
  }
}
