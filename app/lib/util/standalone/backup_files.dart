import 'dart:io';

/// The backups kept in a folder: the newest ones, older ones removed.
const keepBackups = 10;

const _suffix = '.ocbackup';

/// A folder chosen with Android's picker: a `content://` address, not a
/// path (decision 0022).
bool isFolderUri(String folder) => folder.startsWith('content://');

/// What the user reads for [folder]: the path, or for a folder chosen on
/// Android its place as the picker shows it (`Documents/OwnCoffer`).
String folderLabel(String folder) {
  if (!isFolderUri(folder)) return folder;
  final at = folder.indexOf('/tree/');
  if (at < 0) return folder;
  final id = Uri.decodeComponent(folder.substring(at + 6).split('/').first);
  // "primary:Documents/OwnCoffer": the phone's storage, then the path.
  final colon = id.indexOf(':');
  final path = colon < 0 ? id : id.substring(colon + 1);
  return path.isEmpty ? id : path;
}

/// Writes a backup named [name] in [folder] through [seal], which writes
/// the file it is given: first as `name.part`, renamed once whole, so a
/// backup cut short (app closed, disk full) is never taken for one. Keeps
/// the [keep] newest backups. Returns the backup's path.
Future<String> writeBackupFile(
  String folder,
  String name,
  Future<void> Function(File out) seal, {
  int keep = keepBackups,
}) async {
  final dir = Directory(folder);
  await dir.create(recursive: true);
  final file = File('${dir.path}${Platform.pathSeparator}$name');
  for (final stale in dir.listSync().whereType<File>()) {
    if (stale.path.endsWith('$_suffix.part')) await stale.delete();
  }
  final part = File('${file.path}.part');
  try {
    await seal(part);
    await part.rename(file.path);
  } on Object {
    if (part.existsSync()) await part.delete();
    rethrow;
  }
  for (final old in _backups(dir).skip(keep)) {
    await old.delete();
  }
  return file.path;
}

/// The newest backup of [folder], if any.
File? latestBackupFile(String folder) {
  final dir = Directory(folder);
  if (!dir.existsSync()) return null;
  final all = _backups(dir);
  return all.isEmpty ? null : all.first;
}

/// Newest first: the names hold the date.
List<File> _backups(Directory dir) =>
    dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith(_suffix))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path));
