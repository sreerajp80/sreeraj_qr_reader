import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';
import 'package:sreeraj_qr_reader/providers/history_provider.dart';
import 'package:sreeraj_qr_reader/services/history_database_service.dart';

class FakeFlutterSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    } else {
      _storage.remove(key);
    }
  }
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('HistoryProvider Tests', () {
    late HistoryProvider provider;

    setUp(() async {
      final fakeStorage = FakeFlutterSecureStorage();
      final inMemoryDb = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE scan_records (
              id TEXT PRIMARY KEY,
              timestamp INTEGER NOT NULL,
              rawContent TEXT NOT NULL,
              barcodeFormat TEXT NOT NULL,
              category TEXT NOT NULL,
              imageThumbnail TEXT,
              locationTag TEXT,
              safetyScore INTEGER NOT NULL,
              notes TEXT,
              isFavorite INTEGER NOT NULL DEFAULT 0,
              metadata TEXT
            )
          ''');
        },
      );

      final dbService = HistoryDatabaseService(
        secureStorage: fakeStorage,
        database: inMemoryDb,
      );
      await dbService.clearAll();

      provider = HistoryProvider(dbService: dbService);
    });

    tearDown(() async {
      await provider.clearAll();
    });

    test('addScanRecord inserts and notifies listeners', () async {
      final record = ScanRecord(
        id: 'p-1',
        timestamp: DateTime.now(),
        rawContent: 'https://flutter.dev',
        barcodeFormat: 'qrCode',
        category: 'url',
      );

      await provider.addScanRecord(record);

      expect(provider.totalCount, 1);
      expect(provider.records.first.rawContent, 'https://flutter.dev');
    });

    test('setCategory filters records', () async {
      await provider.addScanRecord(
        ScanRecord(
          id: 'url-1',
          timestamp: DateTime.now(),
          rawContent: 'https://site.com',
          barcodeFormat: 'qrCode',
          category: 'url',
        ),
      );
      await provider.addScanRecord(
        ScanRecord(
          id: 'wifi-1',
          timestamp: DateTime.now(),
          rawContent: 'WIFI:S:MyWifi;;',
          barcodeFormat: 'qrCode',
          category: 'wifi',
        ),
      );

      provider.setCategory('wifi');
      // Wait for async loadRecords triggered by setCategory
      await Future.delayed(const Duration(milliseconds: 50));

      expect(provider.records.length, 1);
      expect(provider.records.first.category, 'wifi');
    });

    test('toggleFavorite updates record state', () async {
      await provider.addScanRecord(
        ScanRecord(
          id: 'fav-p1',
          timestamp: DateTime.now(),
          rawContent: 'Sample',
          barcodeFormat: 'qrCode',
          category: 'text',
        ),
      );

      await provider.toggleFavorite('fav-p1');

      expect(provider.favoritesCount, 1);
      expect(provider.records.first.isFavorite, true);
    });
  });
}
