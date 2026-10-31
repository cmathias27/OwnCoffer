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

  static final _version = RegExp(r'^v\d+\.\d+\.\d+$');

  /// Automatic updates on, unless the page turned them off.
  bool get autoUpdate {
    final f = _file('settings');
    return !(f.existsSync() &&
        f.readAsLinesSync().any((l) => l.trim() == 'auto=false'));
  }

  /// Saves the page's choice; the update script reads it at each run.
  void setAutoUpdate(bool on) {
    if (!available) throw const FileSystemException('state folder missing');
    _file('settings').writeAsStringSync('auto=$on\n');
  }

  UpdateOverview updates(String runningVersion) {
    final status = _keyValues('update-status');
    String? version(String? v) => v != null && _version.hasMatch(v) ? v : null;
    final history = <UpdateHistoryEntry>[];
    final tsv = _file('update-history.tsv');
    if (available && tsv.existsSync()) {
      for (final line in tsv.readAsLinesSync()) {
        final p = line.split('\t');
        if (p.length < 4) continue;
        final at = _epoch(p[0]);
        if (at == null) continue;
        history.add(
          UpdateHistoryEntry(
            at: at,
            fromVersion: p[1],
            toVersion: p[2],
            result: p[3],
            message: p.length > 4 && p[4].isNotEmpty ? p[4] : null,
          ),
        );
      }
    }
    history.sort((a, b) => b.at.compareTo(a.at));
    final changelog = _file('CHANGELOG.md');
    return UpdateOverview(
      available: available && status.isNotEmpty,
      runningVersion: runningVersion,
      current: version(status['current']),
      latest: version(status['latest']),
      checkedAt: _epoch(status['checked']),
      auto: available ? autoUpdate : true,
      failedVersion: version(status['failed']),
      message: (status['message'] ?? '').isEmpty ? null : status['message'],
      requestPending:
          available &&
          (_file('request-update').existsSync() ||
              _file('request-check').existsSync()),
      history: history,
      releases: available && changelog.existsSync()
          ? parseChangelog(changelog.readAsStringSync())
          : const [],
    );
  }

  /// The versions of CHANGELOG.md (`## X.Y.Z (date)` headings), newest
  /// first as written, at most [max].
  static List<ReleaseNotes> parseChangelog(String text, {int max = 30}) {
    final heading = RegExp(r'^## (\d+\.\d+\.\d+) \(([^)]*)\)\s*$');
    final result = <ReleaseNotes>[];
    String? version, date;
    final body = StringBuffer();
    void flush() {
      if (version != null) {
        result.add(
          ReleaseNotes(
            version: version,
            date: date!,
            body: body.toString().trim(),
          ),
        );
      }
      body.clear();
    }

    for (final line in text.split('\n')) {
      final m = heading.firstMatch(line);
      if (m != null) {
        flush();
        if (result.length >= max) return result;
        version = m[1];
        date = m[2];
      } else if (version != null) {
        body.writeln(line);
      }
    }
    flush();
    return result.take(max).toList();
  }

  /// Leaves a request for the host. Throws when the folder is missing or
  /// not writable.
  void request(String name, {String? content}) {
    if (!available) throw const FileSystemException('state folder missing');
    _file('request-$name').writeAsStringSync(
      '${content ?? DateTime.now().toUtc().toIso8601String()}\n',
    );
  }
}
