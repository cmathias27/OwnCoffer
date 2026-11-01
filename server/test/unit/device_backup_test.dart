import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:owncoffer_server/embedded.dart';
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

  test('backup: restored into a folder', () async {
    final dir = Directory.systemTemp.createTempSync('owncoffer-restore-');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/owncoffer.db').writeAsStringSync('old');
    File('${dir.path}/owncoffer.db-wal').writeAsStringSync('old wal');
    await DeviceBackup.restoreInto(dir, seal(), pass);
    expect(File('${dir.path}/owncoffer.db').readAsBytesSync(), db);
    expect(File('${dir.path}/owncoffer.db-wal').existsSync(), isFalse);
    expect(
      File('${dir.path}/config/passwords.yaml').readAsStringSync(),
      contains('serviceSecret'),
    );
  });
}
