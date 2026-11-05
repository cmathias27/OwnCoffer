import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:owncoffer_server/embedded.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'backup_files.dart';

export 'backup_files.dart' show folderLabel;

/// Desktop and phone builds carry the server (not the tests' host, which
/// has no app folder: tests start [EmbeddedServer] themselves).
bool get standaloneAvailable => Platform.isAndroid || Platform.isWindows;

EmbeddedServer? _server;

bool get standaloneRunning => _server != null;

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

/// The Android folder picker and the files in the chosen folder
/// (MainActivity, BackupFolder.kt).
const _folder = MethodChannel('org.owncoffer.app/backup_folder');

const _suffix = '.${DeviceBackup.extension}';

/// A scratch file in the app's cache, cleared by the system.
Future<File> _scratch(String name) async {
  final dir = Directory('${(await getTemporaryDirectory()).path}/backups');
  await dir.create(recursive: true);
  return File('${dir.path}/$name');
}

Future<String> standaloneBackupTo(
  String folder,
  String name,
  String passphrase,
  Map<String, Object?> metadata,
) async {
  Future<void> seal(File out) =>
      _server!.backupTo(out, passphrase, metadata: metadata);
  if (!isFolderUri(folder)) return writeBackupFile(folder, name, seal);
  // A folder chosen with Android's picker: sealed in the cache, then
  // copied there a block at a time.
  final out = await _scratch(name);
  try {
    await seal(out);
    await _folder.invokeMethod<void>('write', {
      'tree': folder,
      'name': name,
      'source': out.path,
    });
    await _folder.invokeMethod<void>('prune', {
      'tree': folder,
      'suffix': _suffix,
      'keep': keepBackups,
    });
  } finally {
    if (out.existsSync()) await out.delete();
  }
  return '${folderLabel(folder)}/$name';
}

/// Replaces this device's data by the backup at [path]. Everything is
/// checked while the server still runs (passphrase, whole database, schema
/// this app knows); only then is it stopped, the data swapped (the
/// previous one put back on failure) and the server started again on what
/// is in place.
Future<void> standaloneRestore(String path, String passphrase) async {
  final dir = await _dataDir();
  try {
    await DeviceBackup.prepareRestoreFile(dir, path, passphrase);
  } finally {
    await forgetPickedBackup(path);
  }
  await _server?.stop();
  _server = null;
  await DeviceBackup.commitRestore(dir);
}

/// Removes the copy [pickBackupFile] made on Android; never the user's
/// own file.
Future<void> forgetPickedBackup(String path) async {
  final scratch = (await _scratch('x')).parent.path;
  if (File(path).parent.path == scratch && File(path).existsSync()) {
    await File(path).delete();
  }
}

/// A backup file chosen by the user: Windows, where it is; Android, a
/// copy in the cache (removed after the restore).
Future<String?> pickBackupFile() async {
  if (Platform.isAndroid) {
    final dest = await _scratch(
      'picked-${DateTime.now().microsecondsSinceEpoch}$_suffix',
    );
    final name = await _folder.invokeMethod<String>('open', {
      'dest': dest.path,
    });
    return name == null ? null : dest.path;
  }
  final f = await openFile(
    acceptedTypeGroups: [
      const XTypeGroup(
        label: 'OwnCoffer',
        extensions: [DeviceBackup.extension],
      ),
    ],
  );
  return f?.path;
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

/// Windows: any folder (a Nextcloud or OneDrive one). Android: the
/// system picker, which also offers the folders of synced apps
/// (Nextcloud, Drive…); the app keeps its right to write there.
Future<String?> chooseBackupFolder() async => Platform.isAndroid
    ? _folder.invokeMethod<String>('choose')
    : getDirectoryPath();

bool get canChooseBackupFolder => true;

/// Sends a copy of the newest backup of [folder]: Android, the share
/// sheet; Windows, "Save as". False if there is none.
Future<bool> shareLatestBackup(String folder) async {
  String name;
  File file;
  File? scratch;
  if (isFolderUri(folder)) {
    scratch = await _scratch('share$_suffix');
    final found = await _folder.invokeMethod<String>('latest', {
      'tree': folder,
      'suffix': _suffix,
      'dest': scratch.path,
    });
    if (found == null) return false;
    name = found;
    file = scratch;
  } else {
    final latest = latestBackupFile(folder);
    if (latest == null) return false;
    name = latest.uri.pathSegments.last;
    file = latest;
  }
  if (Platform.isAndroid) {
    // The share sheet reads the file later: a copy under its own name in
    // the cache, which the system clears.
    final shared = await _scratch(name);
    if (file.path != shared.path) await file.copy(shared.path);
    if (scratch != null && scratch.existsSync()) await scratch.delete();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(shared.path, mimeType: 'application/octet-stream')],
      ),
    );
    return true;
  }
  final location = await getSaveLocation(suggestedName: name);
  if (location != null) await file.copy(location.path);
  return true;
}

bool isWrongPassphrase(Object e) => e is BackupPassphraseException;

bool isBackupTooNew(Object e) => e is BackupTooNewException;
