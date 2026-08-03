import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';
import 'package:sreeraj_qr_reader/screens/widgets/scan_overlay_widget.dart';

void main() {
  group('ScanOverlayWidget Widget Tests', () {
    testWidgets('Renders Laser Line overlay style cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScanOverlayWidget(style: ScanOverlayStyle.laserLine),
            ),
          ),
        ),
      );

      expect(find.byType(ScanOverlayWidget), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders Pulsing Corners overlay style cleanly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScanOverlayWidget(style: ScanOverlayStyle.pulsingCorners),
            ),
          ),
        ),
      );

      expect(find.byType(ScanOverlayWidget), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders Cybernetic Grid overlay style cleanly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScanOverlayWidget(style: ScanOverlayStyle.cyberneticGrid),
            ),
          ),
        ),
      );

      expect(find.byType(ScanOverlayWidget), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders Subtle Dot Matrix overlay style cleanly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScanOverlayWidget(style: ScanOverlayStyle.subtleDotMatrix),
            ),
          ),
        ),
      );

      expect(find.byType(ScanOverlayWidget), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders overlay with detected corners bounding box cleanly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScanOverlayWidget(
                style: ScanOverlayStyle.laserLine,
                detectedCorners: [
                  Offset(20, 20),
                  Offset(100, 20),
                  Offset(100, 100),
                  Offset(20, 100),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ScanOverlayWidget), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });
  });
}
