import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';
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

  group('HistoryDatabaseService Tests', () {
    late HistoryDatabaseService dbService;
    late FakeFlutterSecureStorage fakeStorage;

    setUp(() async {
      fakeStorage = FakeFlutterSecureStorage();
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

      dbService = HistoryDatabaseService(
        secureStorage: fakeStorage,
        database: inMemoryDb,
      );
      await dbService.clearAll();
    });

    tearDown(() async {
      await dbService.clearAll();
    });

    test('insertRecord and getRecords retrieves decrypted record', () async {
      final record = ScanRecord(
        id: 'rec-db-1',
        timestamp: DateTime(2026, 7, 31, 10),
        rawContent: 'https://encrypted-test.org',
        barcodeFormat: 'qrCode',
        category: 'url',
        safetyScore: 90,
        notes: 'Secret Note',
        isFavorite: true,
      );

      await dbService.insertRecord(record);

      final records = await dbService.getRecords();
      expect(records.length, 1);
      expect(records.first.id, 'rec-db-1');
      expect(records.first.rawContent, 'https://encrypted-test.org');
      expect(records.first.notes, 'Secret Note');
      expect(records.first.isFavorite, true);
    });

    test('getRecords filters by category and search query', () async {
      await dbService.insertRecord(
        ScanRecord(
          id: '1',
          timestamp: DateTime.now(),
          rawContent: 'WIFI:S:HomeNet;;',
          barcodeFormat: 'qrCode',
          category: 'wifi',
        ),
      );
      await dbService.insertRecord(
        ScanRecord(
          id: '2',
          timestamp: DateTime.now(),
          rawContent: 'https://google.com',
          barcodeFormat: 'qrCode',
          category: 'url',
        ),
      );

      final wifiOnly = await dbService.getRecords(category: 'wifi');
      expect(wifiOnly.length, 1);
      expect(wifiOnly.first.category, 'wifi');

      final searchGoogle = await dbService.getRecords(searchQuery: 'google');
      expect(searchGoogle.length, 1);
      expect(searchGoogle.first.rawContent, contains('google.com'));
    });

    test('toggleFavorite updates favorite status', () async {
      await dbService.insertRecord(
        ScanRecord(
          id: 'fav-1',
          timestamp: DateTime.now(),
          rawContent: 'Test',
          barcodeFormat: 'qrCode',
          category: 'text',
        ),
      );

      await dbService.toggleFavorite('fav-1', false);
      final updated = await dbService.getRecords();
      expect(updated.first.isFavorite, true);
    });

    test('updateNotes updates custom user notes', () async {
      await dbService.insertRecord(
        ScanRecord(
          id: 'note-1',
          timestamp: DateTime.now(),
          rawContent: 'Test',
          barcodeFormat: 'qrCode',
          category: 'text',
        ),
      );

      await dbService.updateNotes('note-1', 'Added new note');
      final updated = await dbService.getRecords();
      expect(updated.first.notes, 'Added new note');
    });

    test('deleteRecord removes record from database', () async {
      await dbService.insertRecord(
        ScanRecord(
          id: 'del-1',
          timestamp: DateTime.now(),
          rawContent: 'Test',
          barcodeFormat: 'qrCode',
          category: 'text',
        ),
      );

      await dbService.deleteRecord('del-1');
      final list = await dbService.getRecords();
      expect(list.isEmpty, true);
    });

    test('clearAll wipes database table', () async {
      await dbService.insertRecord(
        ScanRecord(
          id: 'c-1',
          timestamp: DateTime.now(),
          rawContent: 'Test 1',
          barcodeFormat: 'qrCode',
          category: 'text',
        ),
      );
      await dbService.insertRecord(
        ScanRecord(
          id: 'c-2',
          timestamp: DateTime.now(),
          rawContent: 'Test 2',
          barcodeFormat: 'qrCode',
          category: 'text',
        ),
      );

      await dbService.clearAll();
      final list = await dbService.getRecords();
      expect(list.isEmpty, true);
    });
  });
}
