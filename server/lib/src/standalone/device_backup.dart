import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import 'sqlite_migrations.g.dart';

/// Backups of the standalone app (decision 0022): the whole SQLite file and
/// the server's secrets, encrypted with a passphrase chosen by the user, so
/// that a copy in a cloud folder (Nextcloud, OneDrive…) reveals nothing and
/// can be restored on another device.
///
/// The database holds everything, the documents too (invoices, loan
/// offers: stored in its tables, as on the Docker server).
///
/// File layout, format 2 (all integers big-endian):
///   "OCBK" · 2 · PBKDF2 iterations (4) · salt (16) · nonce prefix (8) ·
///   chunk size (4) · chunks
/// Each chunk is [chunkSize] plain bytes (the last one fewer) encrypted
/// with AES-256-GCM, its nonce the prefix and the chunk's number (4), its
/// authenticated data the header and whether it is the last one: chunks
/// cannot be swapped, removed or cut without the backup being refused.
/// Written and read a chunk at a time, a backup of a few GB never sits in
/// the phone's memory.
///
/// Format 1, still read: "OCBK" · 1 · iterations (4) · salt (16) ·
/// nonce (12) · one AES-256-GCM ciphertext and tag, header authenticated.
///
/// The plain content, in both: length (4) · metadata JSON · length (4) ·
/// passwords.yaml · database
abstract final class DeviceBackup {
  static const _magic = [0x4F, 0x43, 0x42, 0x4B]; // OCBK
  static const _version1 = 1;
  static const _version2 = 2;

  /// Plain bytes per chunk of format 2.
  static const chunkSize = 1 << 20;
  static const _head2 = 4 + 1 + 4 + 16 + 8 + 4;

  /// PBKDF2-HMAC-SHA256: a second or two on a phone, once a day.
  static const iterations = 210000;

  /// Shortest passphrase accepted.
  static const minPassphrase = 12;

  /// File extension of a backup.
  static const extension = 'ocbackup';

  static Uint8List _key(String passphrase, Uint8List salt, int rounds) {
    final kdf = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, rounds, 32));
    return kdf.process(Uint8List.fromList(utf8.encode(passphrase)));
  }

  static Uint8List _random(int n) {
    final r = Random.secure();
    return Uint8List.fromList(List.generate(n, (_) => r.nextInt(256)));
  }

  /// Encrypts the SQLite file at [databasePath] (a consistent copy) and
  /// [passwords] (config/passwords.yaml) into [outPath], format 2, a chunk
  /// at a time. Synchronous: run it in an isolate.
  static void sealFile({
    required String passphrase,
    required String databasePath,
    required String passwords,
    required Map<String, Object?> metadata,
    required String outPath,
    int chunk = chunkSize,
  }) {
    if (passphrase.length < minPassphrase) {
      throw ArgumentError('passphrase too short');
    }
    final head =
        (BytesBuilder()
              ..add(_magic)
              ..addByte(_version2)
              ..add(_u32(iterations))
              ..add(_random(16))
              ..add(_random(8))
              ..add(_u32(chunk)))
            .toBytes();
    final key = _key(
      passphrase,
      Uint8List.sublistView(head, 9, 25),
      iterations,
    );
    final meta = utf8.encode(jsonEncode(metadata));
    final secrets = utf8.encode(passwords);
    final prefix =
        (BytesBuilder()
              ..add(_u32(meta.length))
              ..add(meta)
              ..add(_u32(secrets.length))
              ..add(secrets))
            .toBytes();
    final db = File(databasePath).openSync();
    final out = File(outPath).openSync(mode: FileMode.write);
    try {
      out.writeFromSync(head);
      final total = prefix.length + db.lengthSync();
      final buffer = Uint8List(chunk);
      var done = 0;
      var fromPrefix = 0;
      for (var index = 0; done < total; index++) {
        final n = min(chunk, total - done);
        var filled = 0;
        if (fromPrefix < prefix.length) {
          filled = min(n, prefix.length - fromPrefix);
          buffer.setRange(0, filled, prefix, fromPrefix);
          fromPrefix += filled;
        }
        while (filled < n) {
          final read = db.readIntoSync(buffer, filled, n);
          if (read == 0) {
            throw FileSystemException('Database shorter than expected');
          }
          filled += read;
        }
        done += n;
        out.writeFromSync(
          _chunkCipher(
            true,
            key,
            head,
            index,
            done == total,
          ).process(Uint8List.sublistView(buffer, 0, n)),
        );
      }
      out.flushSync();
    } finally {
      db.closeSync();
      out.closeSync();
    }
  }

  /// Decrypts the backup at [path] (format 1 or 2): the database goes to
  /// [databaseOut], a chunk at a time. Throws [FormatException] if it is
  /// not a backup, and [BackupPassphraseException] if the passphrase is
  /// wrong or the file was changed (then [databaseOut] may hold a part).
  /// Synchronous: run it in an isolate.
  static ({Map<String, Object?> metadata, String passwords}) openFile(
    String path,
    String passphrase, {
    required String databaseOut,
  }) {
    final f = File(path).openSync();
    try {
      final length = f.lengthSync();
      final start = f.readSync(min(length, _head2));
      if (start.length < 5 || !_startsWith(start, _magic)) {
        throw const FormatException('Not an OwnCoffer backup');
      }
      if (start[4] == _version1) {
        f.setPositionSync(0);
        final b = open(f.readSync(length), passphrase);
        File(databaseOut).writeAsBytesSync(b.database, flush: true);
        return (metadata: b.metadata, passwords: b.passwords);
      }
      if (start[4] != _version2 || length < _head2 + 16) {
        throw const FormatException('Not an OwnCoffer backup');
      }
      final head = start;
      final view = ByteData.sublistView(head);
      final rounds = view.getUint32(5);
      final chunk = view.getUint32(33);
      if (rounds < 10000 ||
          rounds > 10000000 ||
          chunk < 1024 ||
          chunk > 64 << 20) {
        throw const FormatException('Not an OwnCoffer backup');
      }
      final key = _key(passphrase, Uint8List.sublistView(head, 9, 25), rounds);
      final out = File(databaseOut).openSync(mode: FileMode.write);
      try {
        Uint8List? pending = Uint8List(0);
        Map<String, Object?>? metadata;
        String? passwords;
        var position = _head2;
        for (var index = 0; position < length; index++) {
          final n = min(chunk + 16, length - position);
          final sealed = f.readSync(n);
          position += n;
          final Uint8List plain;
          try {
            plain = _chunkCipher(
              false,
              key,
              head,
              index,
              position == length,
            ).process(sealed);
          } on Object {
            // Wrong key, changed, cut or swapped chunk: all fail the tag.
            throw const BackupPassphraseException();
          }
          if (pending == null) {
            out.writeFromSync(plain);
            continue;
          }
          // Metadata and passwords first, then the database.
          final b =
              (BytesBuilder(copy: false)
                    ..add(pending)
                    ..add(plain))
                  .toBytes();
          final p = ByteData.sublistView(b);
          if (b.length < 4) {
            pending = b;
            continue;
          }
          final metaEnd = 4 + p.getUint32(0);
          if (b.length < metaEnd + 4) {
            pending = b;
            continue;
          }
          final secretsEnd = metaEnd + 4 + p.getUint32(metaEnd);
          if (b.length < secretsEnd) {
            pending = b;
            continue;
          }
          metadata =
              (jsonDecode(
                        utf8.decode(Uint8List.sublistView(b, 4, metaEnd)),
                      )
                      as Map)
                  .cast<String, Object?>();
          passwords = utf8.decode(
            Uint8List.sublistView(b, metaEnd + 4, secretsEnd),
          );
          out.writeFromSync(Uint8List.sublistView(b, secretsEnd));
          pending = null;
        }
        out.flushSync();
        if (metadata == null || passwords == null) {
          throw const FormatException('Not an OwnCoffer backup');
        }
        return (metadata: metadata, passwords: passwords);
      } finally {
        out.closeSync();
      }
    } finally {
      f.closeSync();
    }
  }

  /// AES-256-GCM for chunk [index] of format 2.
  static GCMBlockCipher _chunkCipher(
    bool encrypt,
    Uint8List key,
    Uint8List head,
    int index,
    bool last,
  ) {
    final nonce = Uint8List(12)
      ..setRange(0, 8, head, 25)
      ..buffer.asByteData().setUint32(8, index);
    final aad = Uint8List(head.length + 1)
      ..setRange(0, head.length, head)
      ..[head.length] = last ? 1 : 0;
    return GCMBlockCipher(AESEngine())
      ..init(encrypt, AEADParameters(KeyParameter(key), 128, nonce, aad));
  }

  /// Format 1, in memory: what backups were until 1.4.4, kept to check
  /// they are still read.
  static Uint8List seal({
    required String passphrase,
    required Uint8List database,
    required String passwords,
    required Map<String, Object?> metadata,
  }) {
    if (passphrase.length < minPassphrase) {
      throw ArgumentError('passphrase too short');
    }
    final salt = _random(16);
    final nonce = _random(12);
    final header = BytesBuilder()
      ..add(_magic)
      ..addByte(_version1)
      ..add(_u32(iterations))
      ..add(salt)
      ..add(nonce);
    final head = header.toBytes();
    final meta = utf8.encode(jsonEncode(metadata));
    final secrets = utf8.encode(passwords);
    final plain =
        (BytesBuilder(copy: false)
              ..add(_u32(meta.length))
              ..add(meta)
              ..add(_u32(secrets.length))
              ..add(secrets)
              ..add(database))
            .toBytes();
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(_key(passphrase, salt, iterations)),
          128,
          nonce,
          head,
        ),
      );
    return (BytesBuilder(copy: false)
          ..add(head)
          ..add(cipher.process(plain)))
        .toBytes();
  }

  /// Decrypts a backup of format 1, in memory. Throws [FormatException] if
  /// it is not one, and [BackupPassphraseException] if the passphrase is
  /// wrong or the file was changed.
  static ({
    Map<String, Object?> metadata,
    String passwords,
    Uint8List database,
  })
  open(Uint8List file, String passphrase) {
    const headLength = 4 + 1 + 4 + 16 + 12;
    if (file.length < headLength + 16 ||
        !_startsWith(file, _magic) ||
        file[4] != _version1) {
      throw const FormatException('Not an OwnCoffer backup');
    }
    final view = ByteData.sublistView(file);
    final rounds = view.getUint32(5);
    if (rounds < 10000 || rounds > 10000000) {
      throw const FormatException('Not an OwnCoffer backup');
    }
    final salt = Uint8List.sublistView(file, 9, 25);
    final nonce = Uint8List.sublistView(file, 25, 37);
    final head = Uint8List.sublistView(file, 0, headLength);
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(_key(passphrase, salt, rounds)),
          128,
          nonce,
          head,
        ),
      );
    final Uint8List plain;
    try {
      plain = cipher.process(Uint8List.sublistView(file, headLength));
    } on InvalidCipherTextException {
      throw const BackupPassphraseException();
    }
    final p = ByteData.sublistView(plain);
    final metaLength = p.getUint32(0);
    final meta = utf8.decode(Uint8List.sublistView(plain, 4, 4 + metaLength));
    final at = 4 + metaLength;
    final secretsLength = p.getUint32(at);
    final secrets = utf8.decode(
      Uint8List.sublistView(plain, at + 4, at + 4 + secretsLength),
    );
    return (
      metadata: (jsonDecode(meta) as Map).cast<String, Object?>(),
      passwords: secrets,
      database: Uint8List.sublistView(plain, at + 4 + secretsLength),
    );
  }

  /// The schema versions this build can open: a database made by a newer
  /// app has one it does not know, and Serverpod would refuse to start on
  /// it.
  static Set<String> get knownVersions => {
    for (final path in sqliteMigrations.keys)
      if (path.contains('/')) path.split('/').first,
  };

  /// The schema version of a SQLite file, after checking it is whole
  /// (`PRAGMA integrity_check`). Throws [FormatException] if it is not an
  /// OwnCoffer database or is damaged.
  static String schemaVersion(String path) {
    final sqlite3.Database db;
    try {
      db = sqlite3.sqlite3.open(path, mode: sqlite3.OpenMode.readOnly);
    } on Object {
      throw const FormatException('Not an OwnCoffer database');
    }
    try {
      final check = db.select('PRAGMA integrity_check');
      if (check.length != 1 || check.first.values.first != 'ok') {
        throw const FormatException('Damaged database');
      }
      final rows = db.select(
        'SELECT version FROM serverpod_migrations WHERE module = ?',
        ['owncoffer'],
      );
      if (rows.isEmpty) {
        throw const FormatException('Not an OwnCoffer database');
      }
      return rows.first['version'] as String;
    } on sqlite3.SqliteException {
      throw const FormatException('Not an OwnCoffer database');
    } finally {
      db.close();
    }
  }

  static const _db = 'owncoffer.db';
  static const _incoming = 'restore-incoming';
  static const _previous = 'before-restore';

  /// First step of a restore, while the server still runs: decrypts the
  /// backup at [path] beside the data, then checks the database is whole
  /// and of a schema this build knows. Nothing of the current data is
  /// touched; throws [BackupPassphraseException], [FormatException] or
  /// [BackupTooNewException].
  static Future<void> prepareRestoreFile(
    Directory dataDir,
    String path,
    String passphrase, {
    Set<String>? versions,
  }) async {
    final dir = Directory('${dataDir.path}/$_incoming');
    if (dir.existsSync()) await dir.delete(recursive: true);
    await dir.create(recursive: true);
    await _prepare(dir, path, passphrase, versions);
  }

  /// [prepareRestoreFile] of a backup read in memory.
  static Future<void> prepareRestore(
    Directory dataDir,
    Uint8List file,
    String passphrase, {
    Set<String>? versions,
  }) async {
    final dir = Directory('${dataDir.path}/$_incoming');
    if (dir.existsSync()) await dir.delete(recursive: true);
    await dir.create(recursive: true);
    final upload = File('${dir.path}/upload.$extension');
    try {
      await upload.writeAsBytes(file, flush: true);
    } on Object {
      await dir.delete(recursive: true);
      rethrow;
    }
    await _prepare(dir, upload.path, passphrase, versions);
    if (upload.existsSync()) await upload.delete();
  }

  static Future<void> _prepare(
    Directory dir,
    String backup,
    String passphrase,
    Set<String>? versions,
  ) async {
    try {
      final path = '${dir.path}/$_db';
      // The key derivation takes a second or two, the decryption longer:
      // off the app's thread.
      final b = await Isolate.run(
        () => openFile(backup, passphrase, databaseOut: path),
      );
      await File(
        '${dir.path}/passwords.yaml',
      ).writeAsString(b.passwords, flush: true);
      final version = await Isolate.run(() => schemaVersion(path));
      if (!(versions ?? knownVersions).contains(version)) {
        throw BackupTooNewException(version);
      }
    } on Object {
      await dir.delete(recursive: true);
      rethrow;
    }
  }

  /// Second step, the embedded server stopped: puts the prepared backup in
  /// place. The current data is moved aside first (kept in
  /// `before-restore/` until the next restore) and put back if anything
  /// fails, so a restore never leaves the device without data.
  static Future<void> commitRestore(Directory dataDir) async {
    final incoming = Directory('${dataDir.path}/$_incoming');
    if (!File('${incoming.path}/$_db').existsSync()) {
      throw StateError('no prepared restore');
    }
    final previous = Directory('${dataDir.path}/$_previous');
    if (previous.existsSync()) await previous.delete(recursive: true);
    await previous.create(recursive: true);
    final config = Directory('${dataDir.path}/config');
    await config.create(recursive: true);
    // Current file → its place in before-restore/.
    final current = <String, String>{
      for (final suffix in ['', '-wal', '-shm', '-journal'])
        '${dataDir.path}/$_db$suffix': '${previous.path}/$_db$suffix',
      '${config.path}/passwords.yaml': '${previous.path}/passwords.yaml',
    };
    final moved = <String, String>{};
    final placed = <String>[];
    Future<void> place(String from, String to) async {
      await File(from).rename(to);
      placed.add(to);
    }

    try {
      for (final e in current.entries) {
        final f = File(e.key);
        if (f.existsSync()) {
          await f.rename(e.value);
          moved[e.key] = e.value;
        }
      }
      await place(
        '${incoming.path}/passwords.yaml',
        '${config.path}/passwords.yaml',
      );
      await place('${incoming.path}/$_db', '${dataDir.path}/$_db');
    } on Object {
      // Back to the data as it was.
      for (final path in placed) {
        await File(path).delete();
      }
      for (final e in moved.entries) {
        await File(e.value).rename(e.key);
      }
      rethrow;
    }
    await incoming.delete(recursive: true);
  }

  /// [prepareRestore] then [commitRestore]; the embedded server must be
  /// stopped.
  static Future<void> restoreInto(
    Directory dataDir,
    Uint8List file,
    String passphrase, {
    Set<String>? versions,
  }) async {
    await prepareRestore(dataDir, file, passphrase, versions: versions);
    await commitRestore(dataDir);
  }

  static Uint8List _u32(int v) =>
      Uint8List(4)..buffer.asByteData().setUint32(0, v);

  static bool _startsWith(Uint8List data, List<int> prefix) {
    for (var i = 0; i < prefix.length; i++) {
      if (data[i] != prefix[i]) return false;
    }
    return true;
  }
}

/// Wrong passphrase, or a changed file.
class BackupPassphraseException implements Exception {
  const BackupPassphraseException();
}

/// The backup was made by a newer version of the app: its database has a
/// schema this one does not know. Update the app, then restore.
class BackupTooNewException implements Exception {
  final String version;
  const BackupTooNewException(this.version);

  @override
  String toString() => 'BackupTooNewException($version)';
}
