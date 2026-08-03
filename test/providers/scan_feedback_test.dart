import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ScanProvider Feedback Preferences Unit Tests', () {
    test('Default scan feedback preferences are enabled by default', () async {
      final provider = ScanProvider();
      await Future<void>.delayed(Duration.zero);

      expect(provider.isVibrationEnabled, isTrue);
      expect(provider.isSoundEnabled, isTrue);
    });

    test(
      'Updating vibration setting changes state and persists to SharedPreferences',
      () async {
        final provider = ScanProvider();
        await Future<void>.delayed(Duration.zero);

        await provider.setVibrationEnabled(false);
        expect(provider.isVibrationEnabled, isFalse);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool(ScanProvider.vibrationPrefKey), isFalse);
      },
    );

    test(
      'Updating sound setting changes state and persists to SharedPreferences',
      () async {
        final provider = ScanProvider();
        await Future<void>.delayed(Duration.zero);

        await provider.setSoundEnabled(false);
        expect(provider.isSoundEnabled, isFalse);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool(ScanProvider.soundPrefKey), isFalse);
      },
    );
  });
}
