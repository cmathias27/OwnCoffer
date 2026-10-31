import 'dart:io';

import '../generated/protocol.dart';

/// The folder shared with the host scripts (docker/state/, mounted at
/// OWNCOFFER_STATE_DIR): they write what they did (backups, updates), the
/// administration page leaves requests that only trigger fixed actions on
/// the host (docker/handle-requests.sh). Never bank data.
class HostState {
  final Directory dir;

  HostState(String path) : dir = Directory(path);

  static HostState? _instance;
  static HostState get instance => _instance ??= HostState(
    Platform.environment['OWNCOFFER_STATE_DIR'] ?? '/app/state',
  );

  /// For tests.
  static set instance(HostState s) => _instance = s;

  bool get available => dir.existsSync();

  File _file(String name) => File('${dir.path}/$name');

  /// `key=value` lines of [name], or empty.
  Map<String, String> _keyValues(String name) {
    final f = _file(name);
    if (!f.existsSync()) return const {};
    return {
      for (final line in f.readAsLinesSync())
        if (line.indexOf('=') case final i when i > 0)
          line.substring(0, i): line.substring(i + 1),
    };
  }

  static DateTime? _epoch(String? seconds) {
    final s = int.tryParse(seconds ?? '');
    return s == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(s * 1000, isUtc: true);
  }

  static final _backupName = RegExp(
    r'^owncoffer-\d{8}-\d{6}-([a-z0-9.-]{1,40})\.dump$',
  );

  BackupOverview backups() {
    if (!available) {
      return BackupOverview(
        available: false,
        backups: const [],
        requestPending: false,
      );
    }
    final list = <BackupInfo>[];
    final tsv = _file('backups.tsv');
    if (tsv.existsSync()) {
      for (final line in tsv.readAsLinesSync()) {
        final parts = line.split('\t');
        if (parts.length != 3) continue;
        final m = _backupName.firstMatch(parts[0]);
        final bytes = int.tryParse(parts[1]);
        final at = _epoch(parts[2]);
        if (m == null || bytes == null || at == null) continue;
        list.add(
          BackupInfo(
            name: parts[0],
            label: m[1]!,
            bytes: bytes,
            createdAt: at,
          ),
        );
      }
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final last = _keyValues('backup-last');
    return BackupOverview(
      available: true,
      backups: list,
      lastAt: _epoch(last['at']),
      lastLabel: last['label'],
      lastOk: last['ok'] == null ? null : last['ok'] == 'true',
      lastMessage: (last['message'] ?? '').isEmpty ? null : last['message'],
      lastDailyAt: list.where((b) => b.label == 'daily').firstOrNull?.createdAt,
      requestPending: _file('request-backup').existsSync(),
    );
  }

  /// Leaves a request for the host. Throws when the folder is missing or
  /// not writable.
  void request(String name) {
    if (!available) throw const FileSystemException('state folder missing');
    _file('request-$name').writeAsStringSync(
      '${DateTime.now().toUtc().toIso8601String()}\n',
    );
  }
}
