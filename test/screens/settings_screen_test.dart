import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';
import 'package:sreeraj_qr_reader/screens/about_screen.dart';
import 'package:sreeraj_qr_reader/screens/appearance_screen.dart';
import 'package:sreeraj_qr_reader/screens/features_screen.dart';
import 'package:sreeraj_qr_reader/screens/help/help_home_screen.dart';
import 'package:sreeraj_qr_reader/screens/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });

  Widget buildTestableWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(),
      ),
    );
  }

  group('SettingsScreen Card Navigation Tests', () {
    testWidgets('Renders all main settings cards', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Features'), findsOneWidget);
      expect(find.text('Scan Feedback & Alerts'), findsOneWidget);
      expect(find.text('Privacy & Online Probing'), findsOneWidget);
      expect(find.text('Google Safe Browsing API'), findsOneWidget);
      expect(find.text('Permissions'), findsOneWidget);
      expect(find.text('Help & Feature Guides'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('Navigates to Appearance page on card tap', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Appearance'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AppearanceScreen), findsOneWidget);
      expect(find.text('Theme Mode'), findsOneWidget);
      expect(find.text('Scan Overlay Style'), findsOneWidget);
      expect(find.text('Accent Color & Dynamic Colors'), findsOneWidget);
      expect(find.text('Typography & Text Size'), findsOneWidget);
    });

    testWidgets('Navigates to Features page on card tap', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Features'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(FeaturesScreen), findsOneWidget);
      expect(find.text('SreerajP QR Reader Features'), findsOneWidget);
      expect(find.text('CORE SCANNING & INGESTION'), findsOneWidget);
    });

    testWidgets('Navigates to Scan Feedback page on card tap', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Scan Feedback & Alerts'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ScanFeedbackSettingsScreen), findsOneWidget);
      expect(find.text('Vibration Feedback'), findsOneWidget);
      expect(find.text('Audible Beep Sound'), findsOneWidget);
    });

    testWidgets('Navigates to Permissions page on card tap', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final target = find.text('Permissions');
      await tester.ensureVisible(target);
      await tester.pump();
      await tester.tap(target);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(PermissionsSettingsScreen), findsOneWidget);
      expect(find.text('Permissions Overview'), findsOneWidget);
      expect(
        find.text('Explicit Permissions (Runtime / Manifest)'),
        findsOneWidget,
      );
    });

    testWidgets('Navigates to Help Center page on card tap', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final target = find.text('Help & Feature Guides');
      await tester.ensureVisible(target);
      await tester.pump();
      await tester.tap(target);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(HelpHomeScreen), findsOneWidget);
      expect(find.text('Help Center & User Guides'), findsOneWidget);
      expect(find.text('Barcode & Media Scanning'), findsOneWidget);
      expect(find.text('AR CodeVision™ Spatial HUD'), findsOneWidget);
      expect(find.text('AirQR™ Optical Air-Gap Stream'), findsOneWidget);
    });

    testWidgets('Navigates to About screen on card tap', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final target = find.text('About');
      await tester.ensureVisible(target);
      await tester.pump();
      await tester.tap(target);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AboutScreen), findsOneWidget);
    });
  });
}
