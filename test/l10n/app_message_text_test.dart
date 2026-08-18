import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/l10n/app_message_text.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/models/app_message.dart';

/// Sample arguments for the keys that carry values, so the resolver can be
/// exercised with realistic input.
const Map<AppMessageKey, Map<String, String>> _sampleArgs = {
  AppMessageKey.redirectSuspiciousChain: {'count': '3'},
  AppMessageKey.redirectWithinRange: {'count': '1'},
  AppMessageKey.patternDetected: {
    'patterns': 'patternIpAddress,patternDataUri',
  },
  AppMessageKey.shortenerKnown: {'shortener': 'bit.ly'},
  AppMessageKey.shortenerRedirect: {'host': 'example.com'},
  AppMessageKey.shortenerPossibleTld: {'tld': '.ly'},
  AppMessageKey.homographLookalikes: {'characters': 'а, о'},
  AppMessageKey.maliciousThreats: {'threats': 'MALWARE'},
  AppMessageKey.maliciousApiError: {'status': '503'},
  AppMessageKey.quishingSignalPerimeterDoubleEdge: {'zones': '2'},
  AppMessageKey.quishingSignalDotDensityVariance: {'variance': '12.5'},
  AppMessageKey.domStatusOpenRedirect: {'target': 'https://elsewhere.example'},
  AppMessageKey.domStatusNewDomain: {'days': '9'},
  AppMessageKey.mediaImagePickFailed: {'error': 'boom'},
  AppMessageKey.mediaImageAnalyzeFailed: {'error': 'boom'},
  AppMessageKey.mediaPdfPickFailed: {'error': 'boom'},
  AppMessageKey.mediaPdfScanFailed: {'error': 'boom'},
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('appMessageText', () {
    test('every message key resolves to non-empty text', () {
      final unresolved = <AppMessageKey>[];

      for (final key in AppMessageKey.values) {
        final message = AppMessage(key, args: _sampleArgs[key] ?? const {});
        final text = appMessageText(l10n, message);
        if (text.trim().isEmpty) {
          unresolved.add(key);
        }
      }

      expect(
        unresolved,
        isEmpty,
        reason:
            'These message keys have no text in app_en.arb. Add an entry with '
            'an @key description for each one.',
      );
    });

    test('arguments reach the final text', () {
      final redirect = appMessageText(
        l10n,
        const AppMessage(
          AppMessageKey.shortenerRedirect,
          args: {'host': 'example.com'},
        ),
      );
      expect(redirect, contains('example.com'));

      final chain = appMessageText(
        l10n,
        const AppMessage(
          AppMessageKey.redirectSuspiciousChain,
          args: {'count': '3'},
        ),
      );
      expect(chain, contains('3'));
    });

    test('a detected pattern list is spelled out in words', () {
      final text = appMessageText(
        l10n,
        const AppMessage(
          AppMessageKey.patternDetected,
          args: {'patterns': 'patternIpAddress,patternDataUri'},
        ),
      );

      expect(text, contains('IP Address'));
      expect(text, contains('Data URI'));
      expect(text, isNot(contains('patternIpAddress')));
    });

    test('a missing argument does not throw', () {
      final text = appMessageText(
        l10n,
        const AppMessage(AppMessageKey.shortenerRedirect),
      );
      expect(text, isNotEmpty);
    });
  });
}
