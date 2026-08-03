import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sreeraj_qr_reader/core/config/app_config.dart';
import 'package:sreeraj_qr_reader/core/config/config_service.dart';

void main() {
  group('AppConfig', () {
    test('fallback returns non-empty defaults', () {
      expect(AppConfig.fallback.appName, isNotEmpty);
      expect(AppConfig.fallback.version, isNotEmpty);
      expect(AppConfig.fallback.build, isNotEmpty);
      expect(AppConfig.fallback.details, isNotEmpty);
    });

    test('fromJson parses valid JSON map correctly', () {
      final json = {
        'appName': 'Test App',
        'description': 'Test Description',
        'version': '2.0.0',
        'build': '10',
        'details': {
          'Author': 'Test Author',
          'License': 'MIT',
          'Last build': '2026-07-31',
        },
      };

      final config = AppConfig.fromJson(json);
      expect(config.appName, 'Test App');
      expect(config.description, 'Test Description');
      expect(config.version, '2.0.0');
      expect(config.build, '10');
      expect(config.details['Author'], 'Test Author');
      expect(config.details['License'], 'MIT');
      expect(config.details['Last build'], '2026-07-31');
    });

    test('fromJson falls back gracefully on missing or malformed fields', () {
      final json = {
        'appName': 123, // invalid type
        'details': 'not a map', // invalid type
      };

      final config = AppConfig.fromJson(json);
      expect(config.appName, AppConfig.fallback.appName);
      expect(config.description, AppConfig.fallback.description);
      expect(config.version, AppConfig.fallback.version);
      expect(config.build, AppConfig.fallback.build);
      expect(config.details, isEmpty);
    });
  });

  group('ConfigService', () {
    test('load returns parsed AppConfig when asset loading succeeds', () async {
      Future<String> mockLoader(String path) async {
        return '''
        {
          "appName": "Mock App",
          "description": "Mock Desc",
          "version": "1.4.3",
          "build": "1",
          "details": {
            "Author": "Mock Author"
          }
        }
        ''';
      }

      final service = ConfigService(loadAsset: mockLoader);
      final config = await service.load();

      expect(config.appName, 'Mock App');
      expect(config.version, '1.4.3');
      expect(config.details['Author'], 'Mock Author');
    });

    test('load returns AppConfig.fallback on asset loading error', () async {
      Future<String> mockLoader(String path) async {
        throw Exception('Asset not found');
      }

      final service = ConfigService(loadAsset: mockLoader);
      final config = await service.load();

      expect(config.appName, AppConfig.fallback.appName);
      expect(config.version, AppConfig.fallback.version);
    });

    test(
      'loadAndVerify completes without error even on version mismatch',
      () async {
        Future<String> mockLoader(String path) async {
          return '''
        {
          "appName": "Mock App",
          "description": "Mock Desc",
          "version": "1.0.0",
          "build": "1",
          "details": {}
        }
        ''';
        }

        final service = ConfigService(loadAsset: mockLoader);
        final mockInfo = PackageInfo(
          appName: 'Mock App',
          packageName: 'in.sreerajp.qr_reader',
          version: '1.4.3',
          buildNumber: '2',
        );

        final config = await service.loadAndVerify(packageInfo: mockInfo);
        expect(config.version, '1.0.0');
      },
    );
  });
}
