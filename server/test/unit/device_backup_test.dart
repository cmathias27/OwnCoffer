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

    Uint8List backupOf(Uint8List database) => DeviceBackup.seal(
      passphrase: pass,
      database: database,
      passwords: "shared:\n  serviceSecret: 'restored'\n",
      metadata: const {},
    );

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
