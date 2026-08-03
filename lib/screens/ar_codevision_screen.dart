import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/providers/ar_codevision_provider.dart';
import 'package:sreeraj_qr_reader/services/ar_spatial_service.dart';
import 'package:sreeraj_qr_reader/screens/widgets/ar_action_sheet.dart';
import 'package:sreeraj_qr_reader/screens/widgets/ar_floating_chip_widget.dart';

/// AR CodeVision Spatial Multi-Target Camera HUD Screen.
class ArCodevisionScreen extends StatefulWidget {
  const ArCodevisionScreen({super.key});

  @override
  State<ArCodevisionScreen> createState() => _ArCodevisionScreenState();
}

class _ArCodevisionScreenState extends State<ArCodevisionScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _controller;
  bool _hasPermission = false;
  bool _isInitialized = false;
  bool _isTorchOn = false;
  final ArSpatialService _spatialService = ArSpatialService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    final status = await Permission.camera.request();
    if (status.isGranted && mounted) {
      setState(() {
        _hasPermission = true;
        _controller = MobileScannerController(
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
          detectionSpeed: DetectionSpeed.unrestricted,
        );
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        try {
          if (_controller!.value.isRunning) {
            _controller?.stop();
          }
        } catch (_) {}
        break;
      case AppLifecycleState.resumed:
        try {
          if (!_controller!.value.isRunning) {
            _controller?.start();
          }
        } catch (_) {}
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller?.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error toggling torch: $e');
    }
  }

  Future<void> _handleBack() async {
    try {
      if (_controller != null) {
        await _controller!.stop();
        await _controller!.dispose();
        _controller = null;
      }
    } catch (_) {}
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final arProvider = Provider.of<ArCodevisionProvider>(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        try {
          if (_controller != null) {
            await _controller!.stop();
            await _controller!.dispose();
            _controller = null;
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
          title: const Row(
            children: [
              Icon(Icons.view_in_ar),
              SizedBox(width: 8),
              Text('AR CodeVision HUD'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: _isTorchOn ? Colors.amber : null,
              ),
              onPressed: _toggleTorch,
              tooltip: 'Toggle Flashlight',
            ),
          ],
        ),
        body: _hasPermission && _isInitialized && _controller != null
            ? LayoutBuilder(
                builder: (context, constraints) {
                  final screenSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return Stack(
                    children: [
                      // Live MobileScanner Viewport
                      MobileScanner(
                        controller: _controller!,
                        onDetect: (capture) {
                          arProvider.processBarcodeCapture(capture);
                        },
                        errorBuilder: (context, error) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.view_in_ar_outlined,
                                  size: 48,
                                  color: Colors.cyanAccent,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Initializing AR HUD Viewport...',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Spatial Overlay Layer — Floating M3 Chips
                      ...arProvider.targets.map((target) {
                        // Estimate image frame size from scanner ratio
                        const imageSize = Size(720, 1280);
                        final frameCenter = _spatialService
                            .calculateTargetCenter(
                              target.corners,
                              target.boundingBox,
                            );
                        final screenPosition = _spatialService
                            .convertFrameToScreenOffset(
                              framePoint: frameCenter,
                              imageSize: imageSize,
                              screenSize: screenSize,
                            );

                        return ArFloatingChipWidget(
                          key: ValueKey(target.id),
                          target: target,
                          position: screenPosition,
                          hudMode: arProvider.hudMode,
                          onTap: () {
                            arProvider.selectTargetForSheet(target);
                          },
                          onSelectionChanged: (val) {
                            arProvider.toggleTargetSelection(target.id);
                          },
                        );
                      }),

                      // Expanded Action Sheet overlay for tapped item
                      if (arProvider.sheetTarget != null)
                        ArActionSheet(
                          target: arProvider.sheetTarget!,
                          onClose: () {
                            arProvider.clearSheetTarget();
                          },
                        ),

                      // Warehouse Batch Selection Footer
                      if (arProvider.hudMode == ArHudMode.warehouse &&
                          arProvider.selectedCount > 0)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant,
                              ),
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, blurRadius: 8),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${arProvider.selectedCount} Items Selected',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        arProvider.clearSelection();
                                      },
                                      child: const Text('Clear'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final selectedValues = arProvider
                                            .targets
                                            .where((t) => t.isSelected)
                                            .map((t) => t.rawValue)
                                            .join('\n');
                                        Clipboard.setData(
                                          ClipboardData(text: selectedValues),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Copied ${arProvider.selectedCount} barcodes to clipboard',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.copy, size: 18),
                                      label: const Text('Batch Copy'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              )
            : _buildPermissionDeniedState(),
      ),
    );
  }

  Widget _buildPermissionDeniedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Camera permission is required for AR CodeVision',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _initializeScanner,
            child: const Text('Grant Camera Permission'),
          ),
        ],
      ),
    );
  }
}
