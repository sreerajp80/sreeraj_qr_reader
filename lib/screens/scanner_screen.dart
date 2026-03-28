import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController? controller;
  bool _isScanning = true;
  bool _hasPermission = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    setState(() {
      _isScanning = false;
    });

    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    scanProvider.setScanResult(barcode.rawValue!, barcode.type);

    if (scanProvider.isUrl) {
      scanProvider.checkUrlSafety(barcode.rawValue!);
    }

    Navigator.pushNamed(context, '/result').then((_) {
      // Reset scanning state when returning from result screen
      if (mounted) {
        setState(() {
          _isScanning = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sreeraj P QR Reader'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            tooltip: 'About',
          ),
        ],
      ),
      body: _hasPermission && _isInitialized && controller != null
          ? _buildScanner()
          : _buildPermissionRequest(),
      floatingActionButton: _hasPermission && _isInitialized
          ? FloatingActionButton(
              onPressed: _toggleScanning,
              child: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
            )
          : null,
    );
  }

  Widget _buildScanner() {
    return Stack(
      children: [
        MobileScanner(controller: controller!, onDetect: _handleBarcode),
        // Scanning overlay
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Corner indicators
                _buildCornerIndicator(true, true),
                _buildCornerIndicator(true, false),
                _buildCornerIndicator(false, true),
                _buildCornerIndicator(false, false),
              ],
            ),
          ),
        ),
        // Instructions
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Position QR code or barcode within the frame',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Camera permission required',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await _checkPermissions();
              if (_hasPermission) {
                _initializeScanner();
              }
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  void _toggleScanning() {
    setState(() {
      _isScanning = !_isScanning;
      if (_isScanning) {
        controller?.start();
      } else {
        controller?.stop();
      }
    });
  }

  Widget _buildCornerIndicator(bool isTop, bool isLeft) {
    return Positioned(
      top: isTop ? -2 : null,
      bottom: isTop ? null : -2,
      left: isLeft ? -2 : null,
      right: isLeft ? null : -2,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Colors.greenAccent, width: 3)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Colors.greenAccent, width: 3)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Colors.greenAccent, width: 3)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Colors.greenAccent, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
