import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/standalone/backup_files.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('owncoffer-files-'));
  tearDown(() => dir.deleteSync(recursive: true));

  List<String> names() =>
      [for (final f in dir.listSync()) f.uri.pathSegments.last]..sort();

  test('written whole, the ten newest kept, cut ones removed', () async {
    File(
      '${dir.path}/owncoffer-20260101-000000.ocbackup.part',
    ).writeAsStringSync('cut short');
    File('${dir.path}/notes.txt').writeAsStringSync('not ours');
    for (var day = 1; day <= 12; day++) {
      final name = 'owncoffer-202611${'$day'.padLeft(2, '0')}-0800.ocbackup';
      final path = await writeBackupFile(dir.path, name, (out) async {
        // The backup is written under a temporary name.
        expect(out.path, endsWith('$name.part'));
        await out.writeAsString('backup $day');
      });
      expect(File(path).readAsStringSync(), 'backup $day');
    }
    final kept = names();
    expect(kept, contains('notes.txt'));
    expect(kept.where((n) => n.endsWith('.ocbackup')), hasLength(10));
    expect(kept.any((n) => n.endsWith('.part')), isFalse);
    expect(kept, isNot(contains('owncoffer-20261101-0800.ocbackup')));
    expect(
      latestBackupFile(dir.path)!.uri.pathSegments.last,
      'owncoffer-20261112-0800.ocbackup',
    );
  });

  test('a failed backup leaves nothing that looks like one', () async {
    await expectLater(
      writeBackupFile(dir.path, 'owncoffer-x.ocbackup', (out) async {
        await out.writeAsString('half');
        throw const FileSystemException('disk full');
      }),
      throwsA(isA<FileSystemException>()),
    );
    expect(names(), isEmpty);
    expect(latestBackupFile(dir.path), isNull);
    expect(latestBackupFile('${dir.path}/none'), isNull);
  });

  test('the folder as the user reads it', () {
    expect(folderLabel(r'C:\Users\x\Nextcloud'), r'C:\Users\x\Nextcloud');
    expect(
      folderLabel(
        'content://com.android.externalstorage.documents/tree/'
        'primary%3ADocuments%2FOwnCoffer',
      ),
      'Documents/OwnCoffer',
    );
    expect(
      folderLabel('content://com.nextcloud.android.providers/tree/42'),
      '42',
    );
    expect(isFolderUri('content://x/tree/y'), isTrue);
    expect(isFolderUri('/storage/emulated/0/backups'), isFalse);
  });
}
