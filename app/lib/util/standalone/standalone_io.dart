import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:owncoffer_server/embedded.dart';
import 'package:path_provider/path_provider.dart';

/// Desktop and phone builds carry the server (not the tests' host, which
/// has no app folder: tests start [EmbeddedServer] themselves).
bool get standaloneAvailable => Platform.isAndroid || Platform.isWindows;

EmbeddedServer? _server;

Future<Directory> _dataDir() async => Directory(
  '${(await getApplicationSupportDirectory()).path}/standalone',
);

Future<({Uri api, Future<Map<String, dynamic>> Function() signIn})>
startStandalone() async {
  final server = _server ??= await EmbeddedServer.start(
    dataDir: await _dataDir(),
  );
  return (api: server.api, signIn: server.signIn);
}

Future<Uint8List> standaloneBackup(
  String passphrase,
  Map<String, Object?> metadata,
) => _server!.backup(passphrase, metadata: metadata);

/// Stops the server and replaces its data; the app then starts it again.
/// Checks the passphrase before anything is replaced.
Future<void> standaloneRestore(Uint8List file, String passphrase) async {
  await Isolate.run(() => DeviceBackup.open(file, passphrase));
  await _server?.stop();
  _server = null;
  await DeviceBackup.restoreInto(await _dataDir(), file, passphrase);
}

/// Windows: Documents\OwnCoffer. Android: the app's folder on the shared
/// storage (Android/data/org.owncoffer.app/files/backups), reachable from a
/// computer by USB; the share button sends a copy anywhere.
Future<String> defaultBackupFolder() async {
  if (Platform.isAndroid) {
    final external = await getExternalStorageDirectory();
    final base = external ?? await getApplicationSupportDirectory();
    return '${base.path}/backups';
  }
  return '${(await getApplicationDocumentsDirectory()).path}'
      '${Platform.pathSeparator}OwnCoffer';
}

/// Windows only: the user's folder (a Nextcloud or OneDrive one).
Future<String?> chooseBackupFolder() async =>
    Platform.isAndroid ? null : getDirectoryPath();

bool get canChooseBackupFolder => !Platform.isAndroid;

/// Writes [bytes] as [name] in [folder]; keeps the [keep] newest backups.
Future<String> writeBackup(
  String folder,
  String name,
  Uint8List bytes, {
  int keep = 10,
}) async {
  final dir = Directory(folder);
  await dir.create(recursive: true);
  final file = File('${dir.path}${Platform.pathSeparator}$name');
  final part = File('${file.path}.part');
  await part.writeAsBytes(bytes, flush: true);
  await part.rename(file.path);
  final backups =
      dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.${DeviceBackup.extension}'))
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path));
  for (final old in backups.skip(keep)) {
    await old.delete();
  }
  return file.path;
}

/// The newest backup of [folder], if any.
Future<({String name, Uint8List bytes})?> latestBackup(String folder) async {
  final dir = Directory(folder);
  if (!dir.existsSync()) return null;
  final backups =
      dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.${DeviceBackup.extension}'))
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path));
  if (backups.isEmpty) return null;
  final f = backups.first;
  return (
    name: f.uri.pathSegments.last,
    bytes: await f.readAsBytes(),
  );
}

bool isWrongPassphrase(Object e) => e is BackupPassphraseException;
