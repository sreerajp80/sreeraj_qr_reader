import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';

/// Customizable animated scanner frame overlay supporting 4 styles:
/// Laser Line, Pulsing Corners, Cybernetic Grid, and Subtle Dot Matrix,
/// along with dynamic barcode bounding box reticles.
class ScanOverlayWidget extends StatefulWidget {
  final ScanOverlayStyle style;
  final double scanAreaSize;
  final Rect? detectedBoundingBox;
  final List<Offset>? detectedCorners;

  const ScanOverlayWidget({
    super.key,
    required this.style,
    this.scanAreaSize = 250.0,
    this.detectedBoundingBox,
    this.detectedCorners,
  });

  @override
  State<ScanOverlayWidget> createState() => _ScanOverlayWidgetState();
}

class _ScanOverlayWidgetState extends State<ScanOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.scanAreaSize, widget.scanAreaSize),
          painter: _ScanOverlayPainter(
            style: widget.style,
            progress: _animationController.value,
            colorScheme: Theme.of(context).colorScheme,
            detectedBoundingBox: widget.detectedBoundingBox,
            detectedCorners: widget.detectedCorners,
          ),
        );
      },
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  final ScanOverlayStyle style;
  final double progress;
  final ColorScheme colorScheme;
  final Rect? detectedBoundingBox;
  final List<Offset>? detectedCorners;

  _ScanOverlayPainter({
    required this.style,
    required this.progress,
    required this.colorScheme,
    this.detectedBoundingBox,
    this.detectedCorners,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    switch (style) {
      case ScanOverlayStyle.laserLine:
        _drawLaserLine(canvas, rect);
        break;
      case ScanOverlayStyle.pulsingCorners:
        _drawPulsingCorners(canvas, rect);
        break;
      case ScanOverlayStyle.cyberneticGrid:
        _drawCyberneticGrid(canvas, rect);
        break;
      case ScanOverlayStyle.subtleDotMatrix:
        _drawSubtleDotMatrix(canvas, rect);
        break;
    }

    if (detectedBoundingBox != null ||
        (detectedCorners != null && detectedCorners!.isNotEmpty)) {
      _drawDetectedFocusBox(canvas, rect);
    }
  }

  /// 1. Laser Line Style: Frame with animated vertical scanning beam line.
  void _drawLaserLine(Canvas canvas, Rect rect) {
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Outer bounding frame
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, borderPaint);

    // Corner reticles
    _drawCornerBrackets(canvas, rect, colorScheme.primary);

    // Animated laser sweep line
    final laserY = rect.top + (rect.height * progress);
    final laserPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          colorScheme.primary.withValues(alpha: 0.0),
          colorScheme.primary,
          Colors.cyanAccent,
          colorScheme.primary,
          colorScheme.primary.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(rect.left, laserY, rect.width, 3))
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(rect.left + 8, laserY),
      Offset(rect.right - 8, laserY),
      laserPaint,
    );

    // Laser glow gradient below/above laser
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colorScheme.primary.withValues(alpha: 0.35),
          colorScheme.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(rect.left, laserY - 20, rect.width, 20));

    canvas.drawRect(
      Rect.fromLTRB(rect.left + 8, laserY - 20, rect.right - 8, laserY),
      glowPaint,
    );
  }

  /// 2. Pulsing Corners Style: Glowing/breathing corner L-brackets.
  void _drawPulsingCorners(Canvas canvas, Rect rect) {
    final pulseFactor = 0.5 + 0.5 * math.sin(progress * math.pi * 2);
    final cornerLength = 28.0 + (pulseFactor * 6.0);
    final opacity = 0.6 + (pulseFactor * 0.4);
    final glowColor = Color.lerp(
      colorScheme.primary,
      Colors.greenAccent,
      pulseFactor,
    )!;

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      borderPaint,
    );

    _drawCornerBrackets(
      canvas,
      rect,
      glowColor.withValues(alpha: opacity),
      cornerLength: cornerLength,
      strokeWidth: 4.0,
    );

    // Subtle center breathing circle
    final centerCirclePaint = Paint()
      ..color = glowColor.withValues(alpha: 0.15 * pulseFactor)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      rect.center,
      24.0 + (pulseFactor * 8.0),
      centerCirclePaint,
    );
  }

  /// 3. Cybernetic Grid Style: Sci-fi grid lines with crosshair target reticle.
  void _drawCyberneticGrid(Canvas canvas, Rect rect) {
    final gridPaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.18)
      ..strokeWidth = 1.0;

    const gridDivisions = 5;
    final stepX = rect.width / gridDivisions;
    final stepY = rect.height / gridDivisions;

    // Draw inner grid lines
    for (int i = 1; i < gridDivisions; i++) {
      canvas.drawLine(
        Offset(rect.left + i * stepX, rect.top),
        Offset(rect.left + i * stepX, rect.bottom),
        gridPaint,
      );
      canvas.drawLine(
        Offset(rect.left, rect.top + i * stepY),
        Offset(rect.right, rect.top + i * stepY),
        gridPaint,
      );
    }

    // Outer sci-fi frame
    final framePaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(rect, framePaint);

    // Center crosshairs
    final crosshairPaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2.0;

    final center = rect.center;
    const crosshairSize = 16.0;
    canvas.drawLine(
      Offset(center.dx - crosshairSize, center.dy),
      Offset(center.dx + crosshairSize, center.dy),
      crosshairPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - crosshairSize),
      Offset(center.dx, center.dy + crosshairSize),
      crosshairPaint,
    );

    // Rotating/pulsing target ring
    final ringRadius = 32.0 + (progress * 4.0);
    final ringPaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.5 + 0.3 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, ringRadius, ringPaint);
  }

  /// 4. Subtle Dot Matrix Style: Minimalist corner dot grid accents.
  void _drawSubtleDotMatrix(Canvas canvas, Rect rect) {
    final framePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      framePaint,
    );

    final dotPulse = (math.sin(progress * math.pi * 2) + 1) / 2;
    final dotColor = Color.lerp(colorScheme.primary, Colors.white, dotPulse)!;

    final activeDotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const dotRadius = 3.0;
    const dotSpacing = 10.0;
    const dotsPerCorner = 3;

    // Draw 3x3 dot matrix grid on each of the 4 corners
    final cornerOffsets = [
      rect.topLeft + const Offset(12, 12),
      rect.topRight + const Offset(-12 - (dotsPerCorner - 1) * dotSpacing, 12),
      rect.bottomLeft +
          const Offset(12, -12 - (dotsPerCorner - 1) * dotSpacing),
      rect.bottomRight +
          const Offset(
            -12 - (dotsPerCorner - 1) * dotSpacing,
            -12 - (dotsPerCorner - 1) * dotSpacing,
          ),
    ];

    for (final baseOffset in cornerOffsets) {
      for (int row = 0; row < dotsPerCorner; row++) {
        for (int col = 0; col < dotsPerCorner; col++) {
          final dotCenter = Offset(
            baseOffset.dx + col * dotSpacing,
            baseOffset.dy + row * dotSpacing,
          );
          canvas.drawCircle(dotCenter, dotRadius, activeDotPaint);
        }
      }
    }
  }

  /// Helper to draw thick corner L-brackets.
  void _drawCornerBrackets(
    Canvas canvas,
    Rect rect,
    Color color, {
    double cornerLength = 24.0,
    double strokeWidth = 3.5,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Top-Left
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + Offset(cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + Offset(0, cornerLength),
      paint,
    );

    // Top-Right
    canvas.drawLine(
      rect.topRight,
      rect.topRight + Offset(-cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + Offset(0, cornerLength),
      paint,
    );

    // Bottom-Left
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + Offset(cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + Offset(0, -cornerLength),
      paint,
    );

    // Bottom-Right
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + Offset(-cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + Offset(0, -cornerLength),
      paint,
    );
  }

  /// Dynamic auto-resizing bounding box reticle drawn over detected code
  void _drawDetectedFocusBox(Canvas canvas, Rect frameRect) {
    final box = detectedBoundingBox ?? _rectFromCorners(detectedCorners!);
    if (box == null) return;

    final pulseAlpha = 0.6 + 0.4 * math.sin(progress * math.pi * 2);
    final focusPaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: pulseAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final fillPaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.15 * pulseAlpha)
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(box, const Radius.circular(8));
    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, focusPaint);

    _drawCornerBrackets(
      canvas,
      box,
      Colors.greenAccent,
      cornerLength: 14.0,
      strokeWidth: 3.0,
    );
  }

  Rect? _rectFromCorners(List<Offset> corners) {
    if (corners.isEmpty) return null;
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

  @override
  bool shouldRepaint(covariant _ScanOverlayPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.style != style ||
        oldDelegate.colorScheme != colorScheme ||
        oldDelegate.detectedBoundingBox != detectedBoundingBox ||
        oldDelegate.detectedCorners != detectedCorners;
  }
}
