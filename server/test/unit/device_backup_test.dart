import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:owncoffer_server/embedded.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:test/test.dart';

void main() {
  const pass = 'une phrase assez longue';
  final db = Uint8List.fromList(List.generate(5000, (i) => i % 251));
  Uint8List seal({String passphrase = pass}) => DeviceBackup.seal(
    passphrase: passphrase,
    database: db,
    passwords: "shared:\n  serviceSecret: 'x'\n",
    metadata: {'app': '1.1.0'},
  );

  group('format 2, a chunk at a time', () {
    late Directory tmp;
    setUp(() => tmp = Directory.systemTemp.createTempSync('owncoffer-f2-'));
    tearDown(() => tmp.deleteSync(recursive: true));
    var n = 0;

    Uint8List sealed(
      Uint8List database, {
      String passphrase = pass,
      int chunk = 1024,
    }) {
      final source = File('${tmp.path}/db-${n++}')..writeAsBytesSync(database);
      final out = '${tmp.path}/out-${n++}';
      DeviceBackup.sealFile(
        passphrase: passphrase,
        databasePath: source.path,
        passwords: "shared:\n  serviceSecret: 'x'\n",
        metadata: {'app': '1.4.4'},
        outPath: out,
        chunk: chunk,
      );
      return File(out).readAsBytesSync();
    }

    ({Map<String, Object?> metadata, String passwords, Uint8List database})
    opened(Uint8List file, [String passphrase = pass]) {
      final path = '${tmp.path}/in-${n++}';
      File(path).writeAsBytesSync(file);
      final out = '${tmp.path}/db-${n++}';
      final b = DeviceBackup.openFile(path, passphrase, databaseOut: out);
      return (
        metadata: b.metadata,
        passwords: b.passwords,
        database: File(out).readAsBytesSync(),
      );
    }

    test('round trip on and around chunk boundaries', () {
      // Metadata and secrets take 64 bytes: sizes cross the 1024 limit.
      for (final size in [0, 1, 959, 960, 961, 1024, 2048 - 64, 5000]) {
        final data = Uint8List.fromList(List.generate(size, (i) => i % 253));
        final file = sealed(data);
        expect(file[4], 2);
        final b = opened(file);
        expect(b.database, data, reason: '$size bytes');
        expect(b.passwords, contains('serviceSecret'));
        expect(b.metadata['app'], '1.4.4');
      }
      // The default size: one chunk per MB.
      final big = Uint8List.fromList(
        List.generate(3 * DeviceBackup.chunkSize + 7, (i) => i % 241),
      );
      expect(opened(sealed(big, chunk: DeviceBackup.chunkSize)).database, big);
    });

    test('nothing readable, wrong passphrase, every change refused', () {
      final file = sealed(db);
      expect(
        latin1.decode(file, allowInvalid: true),
        isNot(contains('serviceSecret')),
      );
      expect(
        () => opened(file, 'une autre phrase longue'),
        throwsA(isA<BackupPassphraseException>()),
      );
      final refused = throwsA(
        anyOf(isA<BackupPassphraseException>(), isA<FormatException>()),
      );
      for (final at in [4, 6, 20, 30, 35, 40, 1100, 2200, file.length - 1]) {
        final changed = Uint8List.fromList(file)..[at] ^= 1;
        expect(() => opened(changed), refused, reason: 'byte $at');
      }
      const sealedChunk = 1024 + 16;
      const head = 37;
      // Cut after a whole chunk, or within one.
      for (final end in [head + sealedChunk, head + 2 * sealedChunk, 3000]) {
        expect(
          () => opened(Uint8List.sublistView(file, 0, end)),
          refused,
          reason: 'cut at $end',
        );
      }
      // Two chunks swapped.
      final swapped = Uint8List.fromList(file)
        ..setRange(head, head + sealedChunk, file, head + sealedChunk)
        ..setRange(head + sealedChunk, head + 2 * sealedChunk, file, head);
      expect(() => opened(swapped), refused);
      expect(() => sealed(db, passphrase: 'court'), throwsArgumentError);
    });

    test('format 1 backups are still read', () {
      final b = opened(seal());
      expect(b.database, db);
      expect(b.metadata['app'], '1.1.0');
    });
  });

  test('backup: sealed, opened with the passphrase only', () {
    final file = seal();
    expect(utf8.decode(file.sublist(0, 4)), 'OCBK');
    // Nothing readable inside.
    expect(
      latin1.decode(file, allowInvalid: true),
      isNot(contains('serviceSecret')),
    );
    final b = DeviceBackup.open(file, pass);
    expect(b.database, db);
    expect(b.passwords, contains('serviceSecret'));
    expect(b.metadata['app'], '1.1.0');
    // Two backups of the same data differ (salt and nonce).
    expect(seal(), isNot(file));
  });

  test('backup: wrong passphrase, changed file, not a backup, short', () {
    final file = seal();
    expect(
      () => DeviceBackup.open(file, 'une autre phrase longue'),
      throwsA(isA<BackupPassphraseException>()),
    );
    for (final at in [6, 20, 40, file.length - 1]) {
      final changed = Uint8List.fromList(file)..[at] ^= 1;
      expect(
        () => DeviceBackup.open(changed, pass),
        throwsA(
          anyOf(isA<BackupPassphraseException>(), isA<FormatException>()),
        ),
        reason: 'byte $at',
      );
    }
    expect(
      () => DeviceBackup.open(
        Uint8List.fromList(utf8.encode('%PDF-1.7 ...' * 9)),
        pass,
      ),
      throwsA(isA<FormatException>()),
    );
    expect(() => seal(passphrase: 'court'), throwsArgumentError);
  });

  group('restore', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('owncoffer-bk-'));
    tearDown(() => dir.deleteSync(recursive: true));

    /// A small OwnCoffer-like SQLite file at schema [version].
    Uint8List database(String version, {String note = 'restored'}) {
      final path = '${dir.path}/make-${DateTime.now().microsecondsSinceEpoch}';
      final d = sqlite3.sqlite3.open(path);
      d.execute(
        'CREATE TABLE serverpod_migrations '
        '(module TEXT, version TEXT, timestamp TEXT)',
      );
      d.execute(
        "INSERT INTO serverpod_migrations VALUES "
        "('owncoffer', '$version', 'now')",
      );
      d.execute('CREATE TABLE notes (text TEXT)');
      d.execute("INSERT INTO notes VALUES ('$note')");
      d.close();
      final bytes = File(path).readAsBytesSync();
      File(path).deleteSync();
      return bytes;
    }

    Uint8List backupOf(Uint8List database, {bool format1 = false}) {
      if (format1) {
        return DeviceBackup.seal(
          passphrase: pass,
          database: database,
          passwords: "shared:\n  serviceSecret: 'restored'\n",
          metadata: const {},
        );
      }
      final source = File('${dir.path}/source.db')..writeAsBytesSync(database);
      final out = File('${dir.path}/sealed.ocbackup');
      DeviceBackup.sealFile(
        passphrase: pass,
        databasePath: source.path,
        passwords: "shared:\n  serviceSecret: 'restored'\n",
        metadata: const {},
        outPath: out.path,
      );
      final bytes = out.readAsBytesSync();
      source.deleteSync();
      out.deleteSync();
      return bytes;
    }

    void current() {
      File('${dir.path}/owncoffer.db').writeAsStringSync('current');
      File('${dir.path}/owncoffer.db-wal').writeAsStringSync('current wal');
      Directory('${dir.path}/config').createSync();
      File(
        '${dir.path}/config/passwords.yaml',
      ).writeAsStringSync("shared:\n  serviceSecret: 'current'\n");
    }

    String text(String path) => File('${dir.path}/$path').readAsStringSync();

    test('replaces the data, keeps the previous one aside', () async {
      current();
      final version = DeviceBackup.knownVersions.first;
      final bytes = database(version);
      await DeviceBackup.restoreInto(dir, backupOf(bytes), pass);
      expect(File('${dir.path}/owncoffer.db').readAsBytesSync(), bytes);
      expect(File('${dir.path}/owncoffer.db-wal').existsSync(), isFalse);
      expect(text('config/passwords.yaml'), contains("'restored'"));
      expect(text('before-restore/owncoffer.db'), 'current');
      expect(text('before-restore/owncoffer.db-wal'), 'current wal');
      expect(text('before-restore/passwords.yaml'), contains("'current'"));
      expect(Directory('${dir.path}/restore-incoming').existsSync(), isFalse);
      expect(DeviceBackup.schemaVersion('${dir.path}/owncoffer.db'), version);
    });

    test('a format 1 backup, and one picked as a file', () async {
      final version = DeviceBackup.knownVersions.first;
      current();
      final old = database(version, note: 'format 1');
      await DeviceBackup.restoreInto(dir, backupOf(old, format1: true), pass);
      expect(File('${dir.path}/owncoffer.db').readAsBytesSync(), old);
      final now = database(version, note: 'from a file');
      final picked = File('${Directory.systemTemp.path}/picked-${dir.hashCode}')
        ..writeAsBytesSync(backupOf(now));
      addTearDown(picked.deleteSync);
      await DeviceBackup.prepareRestoreFile(dir, picked.path, pass);
      await DeviceBackup.commitRestore(dir);
      expect(File('${dir.path}/owncoffer.db').readAsBytesSync(), now);
      expect(picked.existsSync(), isTrue, reason: 'the chosen file stays');
    });

    test('a newer schema is refused, nothing touched', () async {
      current();
      await expectLater(
        DeviceBackup.restoreInto(dir, backupOf(database('29991231')), pass),
        throwsA(
          isA<BackupTooNewException>().having(
            (e) => e.version,
            'version',
            '29991231',
          ),
        ),
      );
      expect(text('owncoffer.db'), 'current');
      expect(text('owncoffer.db-wal'), 'current wal');
      expect(text('config/passwords.yaml'), contains("'current'"));
      expect(Directory('${dir.path}/restore-incoming').existsSync(), isFalse);
    });

    test('a damaged or foreign database is refused, nothing touched', () async {
      current();
      final notOurs = sqlite3.sqlite3.open('${dir.path}/other.db')
        ..execute('CREATE TABLE t (x INTEGER)');
      notOurs.close();
      for (final bytes in [
        db, // not SQLite at all
        File('${dir.path}/other.db').readAsBytesSync(), // no migrations
      ]) {
        await expectLater(
          DeviceBackup.restoreInto(dir, backupOf(bytes), pass),
          throwsA(isA<FormatException>()),
        );
        expect(text('owncoffer.db'), 'current');
      }
    });

    test('a wrong passphrase touches nothing', () async {
      current();
      await expectLater(
        DeviceBackup.restoreInto(
          dir,
          backupOf(database(DeviceBackup.knownVersions.first)),
          'une autre phrase longue',
        ),
        throwsA(isA<BackupPassphraseException>()),
      );
      expect(text('owncoffer.db'), 'current');
    });

    test('a failed swap puts the data back', () async {
      current();
      await DeviceBackup.prepareRestore(
        dir,
        backupOf(database(DeviceBackup.knownVersions.first)),
        pass,
      );
      // The prepared secrets disappear before the swap ends.
      File('${dir.path}/restore-incoming/passwords.yaml').deleteSync();
      await expectLater(
        DeviceBackup.commitRestore(dir),
        throwsA(isA<FileSystemException>()),
      );
      expect(text('owncoffer.db'), 'current');
      expect(text('owncoffer.db-wal'), 'current wal');
      expect(text('config/passwords.yaml'), contains("'current'"));
    });

    test('the schema versions are the shipped migrations', () {
      expect(DeviceBackup.knownVersions, isNotEmpty);
      expect(
        DeviceBackup.knownVersions.every((v) => RegExp(r'^\d+$').hasMatch(v)),
        isTrue,
      );
    });
  });
}
