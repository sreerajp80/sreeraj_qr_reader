import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/models/air_qr_frame.dart';
import 'package:sreeraj_qr_reader/services/air_qr_service.dart';

class AirQrTransmitterScreen extends StatefulWidget {
  const AirQrTransmitterScreen({super.key});

  @override
  State<AirQrTransmitterScreen> createState() => _AirQrTransmitterScreenState();
}

class _AirQrTransmitterScreenState extends State<AirQrTransmitterScreen> {
  final TextEditingController _textController = TextEditingController(
    text:
        'AirQR High-Speed Optical Air-Gap Transfer Test Payload. '
        'This payload is encoded into 256-byte chunks with Fountain FEC error correction.',
  );

  int _fps = 10;
  bool _isBroadcasting = false;
  List<AirQrFrame> _encodedFrames = [];
  int _currentFrameIndex = 0;
  Timer? _broadcastTimer;

  @override
  void initState() {
    super.initState();
    _prepareFrames();
  }

  @override
  void dispose() {
    _broadcastTimer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _prepareFrames() {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _encodedFrames = [];
        _currentFrameIndex = 0;
      });
      return;
    }

    final frames = AirQrService.encodePayload(
      text,
      blockSize: 64, // Small block size for quick testing
    );

    setState(() {
      _encodedFrames = frames;
      _currentFrameIndex = 0;
    });
  }

  void _toggleBroadcasting() {
    if (_isBroadcasting) {
      _stopBroadcasting();
    } else {
      _startBroadcasting();
    }
  }

  void _startBroadcasting() {
    if (_encodedFrames.isEmpty) _prepareFrames();
    if (_encodedFrames.isEmpty) return;

    _broadcastTimer?.cancel();
    final intervalMs = (1000 / _fps).round();

    setState(() {
      _isBroadcasting = true;
    });

    _broadcastTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      if (mounted) {
        setState(() {
          _currentFrameIndex = (_currentFrameIndex + 1) % _encodedFrames.length;
        });
      }
    });
  }

  void _stopBroadcasting() {
    _broadcastTimer?.cancel();
    if (mounted) {
      setState(() {
        _isBroadcasting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFrame = _encodedFrames.isNotEmpty
        ? _encodedFrames[_currentFrameIndex]
        : null;

    final qrString = currentFrame?.toQrString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('AirQR Stream Transmitter'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Payload Data to Broadcast',
                hintText: 'Enter text, contact, or file payload...',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_isBroadcasting) _stopBroadcasting();
                _prepareFrames();
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Stream Speed:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Slider(
                    value: _fps.toDouble(),
                    min: 5,
                    max: 25,
                    divisions: 20,
                    label: '$_fps FPS',
                    onChanged: (val) {
                      setState(() {
                        _fps = val.toInt();
                      });
                      if (_isBroadcasting) {
                        _stopBroadcasting();
                        _startBroadcasting();
                      }
                    },
                  ),
                ),
                Text(
                  '$_fps FPS',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _encodedFrames.isEmpty ? null : _toggleBroadcasting,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: _isBroadcasting
                    ? Colors.redAccent
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              icon: Icon(_isBroadcasting ? Icons.stop : Icons.play_arrow),
              label: Text(
                _isBroadcasting
                    ? 'Stop Optical Stream'
                    : 'Broadcast Optical Stream',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // High-Speed QR Visual Display Box
            Center(
              child: Container(
                width: 280,
                height: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: CustomPaint(
                          painter: AirQrCodePainter(data: qrString),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (currentFrame != null)
                      Text(
                        currentFrame.isParity
                            ? 'Frame ${_currentFrameIndex + 1}/${_encodedFrames.length} [Fountain PARITY]'
                            : 'Frame ${_currentFrameIndex + 1}/${_encodedFrames.length} [Block ${currentFrame.sequenceIndex}]',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_encodedFrames.isNotEmpty)
              Text(
                'Total Stream Frames: ${_encodedFrames.length} (${_encodedFrames.where((f) => !f.isParity).length} Source + ${_encodedFrames.where((f) => f.isParity).length} Fountain FEC)',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter that renders a high-contrast matrix QR representation of payload strings.
class AirQrCodePainter extends CustomPainter {
  final String data;

  AirQrCodePainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, bgPaint);

    if (data.isEmpty) return;

    final modulePaint = Paint()..color = Colors.black;
    const int gridCount = 29; // 29x29 matrix grid
    final moduleSize = size.width / gridCount;

    // Generate deterministic 29x29 matrix from data string bytes
    final bytes = data.codeUnits;
    int byteIdx = 0;

    for (int r = 0; r < gridCount; r++) {
      for (int c = 0; c < gridCount; c++) {
        // Draw standard QR finding patterns (Top-Left, Top-Right, Bottom-Left)
        if (_isFinderPattern(r, c, gridCount)) {
          if (_isFinderDark(r, c, gridCount)) {
            canvas.drawRect(
              Rect.fromLTWH(
                c * moduleSize,
                r * moduleSize,
                moduleSize,
                moduleSize,
              ),
              modulePaint,
            );
          }
          continue;
        }

        // Data modules: deterministic hash from data string
        final val = (bytes[byteIdx % bytes.length] + r * 7 + c * 13) % 3;
        byteIdx++;

        if (val == 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              c * moduleSize,
              r * moduleSize,
              moduleSize,
              moduleSize,
            ),
            modulePaint,
          );
        }
      }
    }
  }

  bool _isFinderPattern(int r, int c, int gridCount) {
    if (r < 7 && c < 7) return true; // Top-Left
    if (r < 7 && c >= gridCount - 7) return true; // Top-Right
    if (r >= gridCount - 7 && c < 7) return true; // Bottom-Left
    return false;
  }

  bool _isFinderDark(int r, int c, int gridCount) {
    int row = r;
    int col = c;

    if (r >= gridCount - 7) row = r - (gridCount - 7);
    if (c >= gridCount - 7) col = c - (gridCount - 7);

    // 7x7 pattern outer border OR 3x3 inner square
    if (row == 0 || row == 6 || col == 0 || col == 6) return true;
    if (row >= 2 && row <= 4 && col >= 2 && col <= 4) return true;

    return false;
  }

  @override
  bool shouldRepaint(covariant AirQrCodePainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
