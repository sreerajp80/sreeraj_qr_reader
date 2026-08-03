import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sreeraj_qr_reader/models/scan_record.dart';

/// Database service handling AES-256 field-encrypted persistent storage of scan history in SQLite.
class HistoryDatabaseService {
  static const String _tableName = 'scan_records';
  static const String _storageKeyName = 'db_encryption_key_v1';

  final FlutterSecureStorage _secureStorage;
  Database? _db;
  enc.Encrypter? _encrypter;
  enc.IV? _iv;

  HistoryDatabaseService({
    FlutterSecureStorage? secureStorage,
    Database? database,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _db = database;

  /// Initializes secure encryption key and opens SQLite database connection.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<void> _initEncryption() async {
    if (_encrypter != null && _iv != null) return;

    String? keyB64;
    try {
      keyB64 = await _secureStorage.read(key: _storageKeyName);
    } catch (e) {
      if (kDebugMode) debugPrint('Error reading secure storage key: $e');
    }

    if (keyB64 == null || keyB64.isEmpty) {
      final random = Random.secure();
      final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
      keyB64 = base64Url.encode(keyBytes);
      try {
        await _secureStorage.write(key: _storageKeyName, value: keyB64);
      } catch (e) {
        if (kDebugMode) debugPrint('Error writing secure storage key: $e');
      }
    }

    final keyBytes = base64Url.decode(keyB64);
    final key = enc.Key(Uint8List.fromList(keyBytes.take(32).toList()));
    // Fixed initial vector derived deterministically for AES-CBC field encryption
    final ivBytes = List<int>.generate(
      16,
      (i) => keyBytes[i % keyBytes.length],
    );
    _iv = enc.IV(Uint8List.fromList(ivBytes));
    _encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  }

  String _encryptString(String plainText) {
    if (plainText.isEmpty) return plainText;
    if (_encrypter == null || _iv == null) return plainText;
    try {
      return _encrypter!.encrypt(plainText, iv: _iv).base64;
    } catch (_) {
      return plainText;
    }
  }

  String _decryptString(String cipherText) {
    if (cipherText.isEmpty) return cipherText;
    if (_encrypter == null || _iv == null) return cipherText;
    try {
      return _encrypter!.decrypt64(cipherText, iv: _iv);
    } catch (_) {
      return cipherText;
    }
  }

  Future<Database> _initDatabase() async {
    await _initEncryption();
    String dbPath = '';
    try {
      final dbDir = await getApplicationDocumentsDirectory();
      dbPath = p.join(dbDir.path, 'sreeraj_scan_history.db');
    } catch (_) {
      dbPath = await getDatabasesPath();
      dbPath = p.join(dbPath, 'sreeraj_scan_history.db');
    }

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
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
  }

  /// Encrypts sensitive fields before saving to SQLite database.
  Map<String, dynamic> _toEncryptedMap(ScanRecord record) {
    return {
      'id': record.id,
      'timestamp': record.timestamp.millisecondsSinceEpoch,
      'rawContent': _encryptString(record.rawContent),
      'barcodeFormat': record.barcodeFormat,
      'category': record.category,
      'imageThumbnail': record.imageThumbnail != null
          ? _encryptString(record.imageThumbnail!)
          : null,
      'locationTag': record.locationTag != null
          ? _encryptString(record.locationTag!)
          : null,
      'safetyScore': record.safetyScore,
      'notes': record.notes != null ? _encryptString(record.notes!) : null,
      'isFavorite': record.isFavorite ? 1 : 0,
      'metadata': record.metadata != null
          ? _encryptString(jsonEncode(record.metadata))
          : null,
    };
  }

  /// Decrypts encrypted database fields back into ScanRecord domain object.
  ScanRecord _fromEncryptedMap(Map<String, dynamic> map) {
    final rawContentCipher = map['rawContent'] as String? ?? '';
    final thumbnailCipher = map['imageThumbnail'] as String?;
    final locationCipher = map['locationTag'] as String?;
    final notesCipher = map['notes'] as String?;
    final metadataCipher = map['metadata'] as String?;

    Map<String, dynamic>? parsedMetadata;
    if (metadataCipher != null && metadataCipher.isNotEmpty) {
      try {
        final decryptedMeta = _decryptString(metadataCipher);
        parsedMetadata = jsonDecode(decryptedMeta) as Map<String, dynamic>;
      } catch (_) {
        parsedMetadata = null;
      }
    }

    return ScanRecord(
      id: map['id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      rawContent: _decryptString(rawContentCipher),
      barcodeFormat: map['barcodeFormat'] as String? ?? 'qrCode',
      category: map['category'] as String? ?? 'text',
      imageThumbnail: thumbnailCipher != null
          ? _decryptString(thumbnailCipher)
          : null,
      locationTag: locationCipher != null
          ? _decryptString(locationCipher)
          : null,
      safetyScore: (map['safetyScore'] as num?)?.toInt() ?? 100,
      notes: notesCipher != null ? _decryptString(notesCipher) : null,
      isFavorite: (map['isFavorite'] == 1 || map['isFavorite'] == true),
      metadata: parsedMetadata,
    );
  }

  /// Inserts a new scan record or updates if already exists.
  Future<void> insertRecord(ScanRecord record) async {
    final db = await database;
    await _initEncryption();
    final data = _toEncryptedMap(record);
    await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetches all records with optional filtering by category, favorites, and search query.
  Future<List<ScanRecord>> getRecords({
    String? category,
    bool? onlyFavorites,
    String? searchQuery,
  }) async {
    final db = await database;
    await _initEncryption();

    String? whereClause;
    final List<dynamic> whereArgs = [];

    if (category != null &&
        category.toLowerCase() != 'all' &&
        category.toLowerCase() != 'favorites') {
      whereClause = 'category = ?';
      whereArgs.add(category.toLowerCase());
    }

    if (onlyFavorites == true ||
        (category != null && category.toLowerCase() == 'favorites')) {
      if (whereClause != null) {
        whereClause += ' AND isFavorite = 1';
      } else {
        whereClause = 'isFavorite = 1';
      }
    }

    final maps = await db.query(
      _tableName,
      where: whereClause,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'timestamp DESC',
    );

    final records = maps.map(_fromEncryptedMap).toList();

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      return records.where((r) {
        return r.rawContent.toLowerCase().contains(query) ||
            r.barcodeFormat.toLowerCase().contains(query) ||
            r.category.toLowerCase().contains(query) ||
            (r.notes != null && r.notes!.toLowerCase().contains(query)) ||
            (r.locationTag != null &&
                r.locationTag!.toLowerCase().contains(query));
      }).toList();
    }

    return records;
  }

  /// Toggles favorite status of a scan record.
  Future<void> toggleFavorite(String id, bool currentStatus) async {
    final db = await database;
    await db.update(
      _tableName,
      {'isFavorite': currentStatus ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Updates custom user notes for a scan record.
  Future<void> updateNotes(String id, String? notes) async {
    final db = await database;
    await _initEncryption();
    final encryptedNotes = notes != null ? _encryptString(notes) : null;
    await db.update(
      _tableName,
      {'notes': encryptedNotes},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Updates location tag for a scan record.
  Future<void> updateLocationTag(String id, String? locationTag) async {
    final db = await database;
    await _initEncryption();
    final encryptedLocation = locationTag != null
        ? _encryptString(locationTag)
        : null;
    await db.update(
      _tableName,
      {'locationTag': encryptedLocation},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Deletes a scan record by ID.
  Future<void> deleteRecord(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Clears all scan records from database.
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
