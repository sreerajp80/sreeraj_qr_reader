import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/models/air_qr_progress.dart';
import 'package:sreeraj_qr_reader/providers/air_qr_provider.dart';
import 'package:sreeraj_qr_reader/providers/history_provider.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

class AirQrScreen extends StatefulWidget {
  const AirQrScreen({super.key});

  @override
  State<AirQrScreen> createState() => _AirQrScreenState();
}

class _AirQrScreenState extends State<AirQrScreen> with WidgetsBindingObserver {
  MobileScannerController? controller;
  bool _isTorchOn = false;
  bool _isFrontCamera = false;
  bool _hasSavedRecord = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.unrestricted,
    );

    // Reset stream state on enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AirQrProvider>(context, listen: false).resetStream();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
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
        try {
          if (!controller!.value.isRunning) {
            controller?.start();
          }
        } catch (_) {}
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final airQrProvider = Provider.of<AirQrProvider>(context, listen: false);
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        airQrProvider.processScannedCode(barcode.rawValue!);
      }
    }

    if (airQrProvider.isCompleted && !_hasSavedRecord) {
      _hasSavedRecord = true;
      final scanProvider = Provider.of<ScanProvider>(context, listen: false);
      if (scanProvider.isVibrationEnabled) {
        HapticFeedback.heavyImpact();
      }
      if (scanProvider.isSoundEnabled) {
        SystemSound.play(SystemSoundType.click);
      }

      final record = airQrProvider.createScanRecord();
      if (record != null) {
        Provider.of<HistoryProvider>(
          context,
          listen: false,
        ).addScanRecord(record);
      }
    }
  }

  Future<void> _handleBack() async {
    try {
      if (controller != null) {
        await controller!.stop();
        await controller!.dispose();
        controller = null;
      }
    } catch (_) {}
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final airQrProvider = Provider.of<AirQrProvider>(context);
    final progress = airQrProvider.progress;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        try {
          if (controller != null) {
            await controller!.stop();
            await controller!.dispose();
            controller = null;
          }
        } catch (_) {}
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          title: const Text('AirQR Stream Receiver'),
          elevation: 0,
          backgroundColor: Colors.black87,
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_2),
              onPressed: () async {
                try {
                  if (controller != null &&
                      controller!.value.isInitialized &&
                      controller!.value.isRunning) {
                    await controller!.stop();
                  }
                } catch (_) {}
                if (context.mounted) {
                  await Navigator.pushNamed(context, '/air_qr_transmitter');
                  if (mounted &&
                      controller != null &&
                      controller!.value.isInitialized) {
                    try {
                      if (!controller!.value.isRunning) {
                        await controller!.start();
                      }
                    } catch (_) {}
                  }
                }
              },
              tooltip: 'AirQR Transmitter',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _hasSavedRecord = false;
                });
                airQrProvider.resetStream();
              },
              tooltip: 'Reset Stream',
            ),
          ],
        ),
        body: Stack(
          children: [
            if (controller != null)
              MobileScanner(
                controller: controller!,
                onDetect: _onDetect,
                errorBuilder: (context, error) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sensors_outlined,
                          size: 48,
                          color: Colors.cyanAccent,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Initializing AirQR Stream Receiver...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                },
              ),
            // HUD Controls Bar (Top)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.cyanAccent.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.sensors,
                          color: Colors.cyanAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${progress.fps.toStringAsFixed(1)} FPS',
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isTorchOn ? Icons.flash_on : Icons.flash_off,
                            color: _isTorchOn ? Colors.amber : Colors.white,
                          ),
                          onPressed: () async {
                            await controller?.toggleTorch();
                            setState(() => _isTorchOn = !_isTorchOn);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.cameraswitch,
                            color: _isFrontCamera
                                ? Colors.cyanAccent
                                : Colors.white,
                          ),
                          onPressed: () async {
                            await controller?.switchCamera();
                            setState(() => _isFrontCamera = !_isFrontCamera);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // HUD Matrix & Progress Panel (Bottom)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _buildHudPanel(progress),
            ),
            // Complete Payload Result Dialog Overlay
            if (progress.status == AirQrStatus.completed &&
                progress.reassembledContent != null)
              _buildCompletedOverlay(context, progress.reassembledContent!),
          ],
        ),
      ),
    );
  }

  Widget _buildHudPanel(AirQrProgress progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                progress.status == AirQrStatus.completed
                    ? 'STREAM REASSEMBLED'
                    : progress.status == AirQrStatus.receiving
                    ? 'CAPTURING OPTICAL STREAM...'
                    : 'POINT AT ANIMATED QR STREAM',
                style: TextStyle(
                  color: progress.status == AirQrStatus.completed
                      ? Colors.greenAccent
                      : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                '${(progress.progressPercentage * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.progressPercentage,
              minHeight: 10,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.cyanAccent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Captured: ${progress.receivedBlockCount} / ${progress.totalBlocks} Blocks',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                'Missing: ${progress.missingBlockCount}',
                style: const TextStyle(color: Colors.amberAccent, fontSize: 13),
              ),
            ],
          ),
          if (progress.totalBlocks > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(progress.totalBlocks, (index) {
                    final isCaptured = progress.capturedIndices.contains(index);
                    return Container(
                      width: 14,
                      height: 36,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: isCaptured ? Colors.cyanAccent : Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletedOverlay(BuildContext context, String content) {
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.greenAccent, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.greenAccent,
                size: 56,
              ),
              const SizedBox(height: 12),
              const Text(
                'Air-Gap Transfer Complete!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Payload reassembled and verified offline via Fountain error correction.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied payload to clipboard'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Done'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
