import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sreeraj_qr_reader/main.dart';
import 'package:sreeraj_qr_reader/providers/history_provider.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';
import 'package:sreeraj_qr_reader/screens/widgets/pdf_scan_results_sheet.dart';
import 'package:sreeraj_qr_reader/screens/widgets/scan_overlay_widget.dart';
import 'package:sreeraj_qr_reader/services/media_scan_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver, RouteAware {
  MobileScannerController? controller;
  bool _isScanning = true;
  bool _hasPermission = false;
  bool _isInitialized = false;

  // Viewport & camera control states
  bool _isTorchOn = false;
  bool _isFrontCamera = false;
  double _zoomScale = 1.0;
  double _baseZoomScale = 1.0;
  bool _showZoomBar = false;
  List<Offset>? _detectedCorners;

  // Media scanning & Android share sheet target
  late final MediaScanService _mediaScanService;
  StreamSubscription<List<SharedMediaFile>>? _intentSubscription;

  @override
  void initState() {
    super.initState();
    _mediaScanService = MediaScanService();
    WidgetsBinding.instance.addObserver(this);
    _initializeScanner();
    _listenToShareIntents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  Future<void> _initializeScanner() async {
    await _checkPermissions();
    if (_hasPermission && mounted) {
      setState(() {
        controller = MobileScannerController(
          formats: const [
            BarcodeFormat.qrCode,
            BarcodeFormat.code128,
            BarcodeFormat.code39,
            BarcodeFormat.code93,
            BarcodeFormat.ean8,
            BarcodeFormat.ean13,
            BarcodeFormat.upcA,
            BarcodeFormat.upcE,
            BarcodeFormat.pdf417,
            BarcodeFormat.dataMatrix,
          ],
        );
        _isInitialized = true;
      });
    }
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.request();
    if (mounted) {
      setState(() {
        _hasPermission = status.isGranted;
      });
    }
  }

  void _listenToShareIntents() {
    // Media shared while app is running in foreground/background
    _intentSubscription = ReceiveSharingIntent.instance.getMediaStream().listen(
      _handleSharedFiles,
      onError: (err) {
        if (kDebugMode) debugPrint('Error receiving share intent stream: $err');
      },
    );

    // Media shared when launching app from closed state
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) {
        _handleSharedFiles(files);
        ReceiveSharingIntent.instance.reset();
      }
    });
  }

  Future<void> _handleSharedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty || !mounted) return;
    final sharedFile = files.first;

    if (controller == null) {
      await _initializeScanner();
    }
    if (controller == null) return;

    final path = sharedFile.path;
    if (path.toLowerCase().endsWith('.pdf') ||
        sharedFile.mimeType == 'application/pdf') {
      _scanPdfPath(path);
    } else {
      _scanImagePath(path);
    }
  }

  @override
  void dispose() {
    _intentSubscription?.cancel();
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {
    try {
      if (controller != null &&
          controller!.value.isInitialized &&
          controller!.value.isRunning) {
        controller?.stop();
      }
    } catch (_) {}
  }

  @override
  void didPopNext() async {
    if (mounted &&
        _isScanning &&
        controller != null &&
        controller!.value.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted && _isScanning && controller != null) {
        try {
          if (!controller!.value.isRunning) {
            await controller!.start();
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('didPopNext camera start failed, retrying: $e');
          }
          await Future.delayed(const Duration(milliseconds: 400));
          if (mounted &&
              _isScanning &&
              controller != null &&
              !controller!.value.isRunning) {
            try {
              await controller!.start();
            } catch (_) {}
          }
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller!.value.isInitialized) return;
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        try {
          if (controller!.value.isRunning) {
            controller?.stop();
          }
        } catch (_) {}
        break;
      case AppLifecycleState.resumed:
        if (_isScanning) {
          try {
            if (!controller!.value.isRunning) {
              controller?.start();
            }
          } catch (_) {}
        }
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  Future<void> _navigateToRoute(String routeName) async {
    try {
      if (controller != null &&
          controller!.value.isInitialized &&
          controller!.value.isRunning) {
        await controller!.stop();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error stopping camera before navigation: $e');
    }

    if (!mounted) return;
    await Navigator.pushNamed(context, routeName);

    if (mounted &&
        _isScanning &&
        controller != null &&
        controller!.value.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted && _isScanning && controller != null) {
        try {
          if (!controller!.value.isRunning) {
            await controller!.start();
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Initial camera start failed, retrying: $e');
          }
          await Future.delayed(const Duration(milliseconds: 400));
          if (mounted &&
              _isScanning &&
              controller != null &&
              !controller!.value.isRunning) {
            try {
              await controller!.start();
            } catch (_) {}
          }
        }
      }
    }
  }

  void _handleBarcode(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    _processSingleBarcode(
      barcode.rawValue!,
      barcode.type,
      corners: barcode.corners,
    );
  }

  void _processSingleBarcode(
    String rawValue,
    BarcodeType format, {
    List<Offset>? corners,
  }) async {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);

    // Haptic & Audible Feedback based on user configuration
    if (scanProvider.isVibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
    if (scanProvider.isSoundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }

    if (corners != null && corners.isNotEmpty) {
      setState(() {
        _detectedCorners = corners;
      });
    }

    setState(() {
      _isScanning = false;
    });

    scanProvider.setScanResult(rawValue, format);

    final record = scanProvider.createScanRecord();
    if (record != null) {
      Provider.of<HistoryProvider>(
        context,
        listen: false,
      ).addScanRecord(record);
    }

    if (scanProvider.isUrl) {
      scanProvider.checkUrlSafety(rawValue);
    }

    try {
      if (controller != null &&
          controller!.value.isInitialized &&
          controller!.value.isRunning) {
        await controller!.stop();
      }
    } catch (_) {}
    if (!mounted) return;

    Navigator.pushNamed(context, '/result').then((_) async {
      // Reset scanning state when returning from result screen
      if (mounted) {
        setState(() {
          _isScanning = true;
          _detectedCorners = null;
        });
        if (controller != null &&
            controller!.value.isInitialized &&
            !controller!.value.isRunning) {
          try {
            await controller!.start();
          } catch (_) {}
        }
      }
    });
  }

  Future<void> _scanGalleryImage() async {
    if (controller == null) return;
    final result = await _mediaScanService.pickAndScanImage(controller!);
    _processMediaScanResult(result);
  }

  Future<void> _scanImagePath(String path) async {
    if (controller == null) return;
    final result = await _mediaScanService.scanImageFile(controller!, path);
    _processMediaScanResult(result);
  }

  Future<void> _scanPdfDocument() async {
    if (controller == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(AppLocalizations.of(context).scanPdfProgress)),
          ],
        ),
      ),
    );

    final result = await _mediaScanService.pickAndScanPdf(controller!);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss progress
      _processMediaScanResult(result);
    }
  }

  Future<void> _scanPdfPath(String pdfPath) async {
    if (controller == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(AppLocalizations.of(context).scanSharedPdfProgress),
            ),
          ],
        ),
      ),
    );

    final result = await _mediaScanService.scanPdfFile(controller!, pdfPath);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss progress
      _processMediaScanResult(result);
    }
  }

  void _processMediaScanResult(MediaScanResult result) {
    if (!mounted) return;

    if (!result.hasBarcodes) {
      if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (result.isPdf && result.pdfBarcodes.length > 1) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => PdfScanResultsSheet(
          pdfBarcodes: result.pdfBarcodes,
          onSelect: (selectedBarcode) {
            _processSingleBarcode(
              selectedBarcode.rawValue,
              selectedBarcode.format,
            );
          },
        ),
      );
    } else if (result.isPdf && result.pdfBarcodes.isNotEmpty) {
      final first = result.pdfBarcodes.first;
      _processSingleBarcode(first.rawValue, first.format);
    } else if (result.barcodes.isNotEmpty) {
      final first = result.barcodes.first;
      if (first.rawValue != null) {
        _processSingleBarcode(first.rawValue!, first.type);
      }
    }
  }

  Future<void> _toggleTorch() async {
    try {
      await controller?.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error toggling torch: $e');
    }
  }

  Future<void> _switchCamera() async {
    try {
      await controller?.switchCamera();
      setState(() {
        _isFrontCamera = !_isFrontCamera;
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error switching camera: $e');
    }
  }

  Future<void> _setZoom(double zoom) async {
    setState(() {
      _zoomScale = zoom;
    });
    try {
      final zoomFactor = ((zoom - 1.0) / 7.0).clamp(0.0, 1.0);
      await controller?.setZoomScale(zoomFactor);
    } catch (e) {
      if (kDebugMode) debugPrint('Error setting zoom: $e');
    }
  }

  void _toggleScanning() {
    setState(() {
      _isScanning = !_isScanning;
    });
    if (_isScanning) {
      controller?.start();
    } else {
      controller?.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: _scanGalleryImage,
            tooltip: l10n.scanFromGallery,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _scanPdfDocument,
            tooltip: l10n.scanPdfDocument,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: l10n.moreOptions,
            onSelected: _navigateToRoute,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '/ar_codevision',
                child: Row(
                  children: [
                    const Icon(Icons.view_in_ar),
                    const SizedBox(width: 12),
                    Text(l10n.arScreenTitle),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: '/air_qr',
                child: Row(
                  children: [
                    const Icon(Icons.sensors),
                    const SizedBox(width: 12),
                    Text(l10n.airQrReceiverTitle),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: '/history',
                child: Row(
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(width: 12),
                    Text(l10n.menuHistory),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: '/settings',
                child: Row(
                  children: [
                    const Icon(Icons.settings),
                    const SizedBox(width: 12),
                    Text(l10n.menuSettings),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: !_hasPermission
          ? _buildPermissionRequest()
          : (_isInitialized && controller != null
                ? _buildScanner()
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          l10n.scanInitializingCamera,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  )),
      floatingActionButton: _hasPermission && _isInitialized
          ? FloatingActionButton(
              onPressed: _toggleScanning,
              child: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
            )
          : null,
    );
  }

  Widget _buildScanner() {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onScaleStart: (details) {
        _baseZoomScale = _zoomScale;
      },
      onScaleUpdate: (details) {
        final newZoom = (_baseZoomScale * details.scale).clamp(1.0, 8.0);
        _setZoom(newZoom);
      },
      child: Stack(
        children: [
          MobileScanner(
            controller: controller!,
            onDetect: _handleBarcode,
            errorBuilder: (context, error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.scanInitializingFeed,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),
          // Dynamic customizable scanning overlay & barcode focus box
          Center(
            child: ScanOverlayWidget(
              style: themeProvider.scanOverlayStyle,
              detectedCorners: _detectedCorners,
            ),
          ),
          // Viewport Controls Suite Bar (Top Overlay)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      _isTorchOn ? Icons.flash_on : Icons.flash_off,
                      color: _isTorchOn ? Colors.amber : Colors.white,
                    ),
                    onPressed: _toggleTorch,
                    tooltip: l10n.scanTorchTooltip,
                  ),
                  IconButton(
                    icon: Icon(
                      _showZoomBar ? Icons.zoom_in_map : Icons.search,
                      color: _showZoomBar
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _showZoomBar = !_showZoomBar);
                    },
                    tooltip: l10n.scanZoomTooltip,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_zoomScale.toStringAsFixed(1)}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cameraswitch,
                      color: _isFrontCamera ? Colors.cyanAccent : Colors.white,
                    ),
                    onPressed: _switchCamera,
                    tooltip: l10n.scanFlipCameraTooltip,
                  ),
                ],
              ),
            ),
          ),
          // Visual Zoom Slider Bar (Collapsible)
          if (_showZoomBar)
            Positioned(
              top: 76,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.scanZoomValue('1.0'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _zoomScale,
                        min: 1.0,
                        max: 8.0,
                        divisions: 28,
                        label: l10n.scanZoomValue(
                          _zoomScale.toStringAsFixed(1),
                        ),
                        onChanged: (val) {
                          _setZoom(val);
                        },
                      ),
                    ),
                    Text(
                      l10n.scanZoomValue('8.0'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Viewport instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.scanViewfinderHint,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequest() {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l10n.scanCameraPermissionRequired,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await _checkPermissions();
              if (_hasPermission) {
                _initializeScanner();
              }
            },
            child: Text(l10n.grantPermission),
          ),
        ],
      ),
    );
  }
}
