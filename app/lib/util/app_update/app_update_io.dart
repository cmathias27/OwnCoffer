import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../app_update.dart';
import '../app_versions.dart';
import '../standalone.dart';

AppUpdater platformUpdater() => IoAppUpdater();

/// Downloads from the GitHub release, checks, installs (decision 0032).
class IoAppUpdater implements AppUpdater {
  static const _channel = MethodChannel('org.owncoffer.app/app_update');

  final http.Client _client;
  final Future<Directory> Function() _cache;

  @override
  final String? platform;

  /// The running executable (Windows): its folder is the one replaced.
  final String Function() _executable;

  /// Unpacks a zip into a folder (Windows: PowerShell's Expand-Archive).
  final Future<bool> Function(String zip, String folder) _unzip;

  /// Starts the swap script and closes the app (Windows).
  final Future<void> Function(String script) _restart;

  /// Above it, a download is stopped (tests use a small one).
  final int maxBytes;

  IoAppUpdater({
    http.Client? client,
    Future<Directory> Function()? cache,
    String? platform,
    String Function()? executable,
    Future<bool> Function(String zip, String folder)? unzip,
    Future<void> Function(String script)? restart,
    this.maxBytes = AppUpdates.maxBytes,
  }) : _client = client ?? http.Client(),
       _cache = cache ?? getTemporaryDirectory,
       platform =
           platform ??
           (Platform.isAndroid
               ? 'android'
               : Platform.isWindows
               ? 'windows'
               : null),
       _executable = executable ?? (() => Platform.resolvedExecutable),
       _unzip = unzip ?? _expandArchive,
       _restart = restart ?? _runAndExit;

  @override
  bool get supported => platform == 'android' || platform == 'windows';

  @override
  bool get restarts => platform == 'windows';

  Future<Directory> _updates() async =>
      Directory('${(await _cache()).path}${Platform.pathSeparator}updates');

  @override
  Future<String?> latest() async {
    try {
      final request = http.Request('GET', AppUpdates.latest)
        ..followRedirects = false;
      final response = await _client.send(request);
      await response.stream.drain<void>();
      return AppUpdates.versionFromLocation(response.headers['location']);
    } on Exception {
      throw const AppUpdateException('network');
    }
  }

  @override
  Future<AppUpdateReady> prepare(
    String version, {
    AppUpdateProgress? progress,
  }) async {
    final platform = this.platform;
    if (!supported || platform == null) {
      throw const AppUpdateException('unsupported');
    }
    final file = await download(version, platform, progress: progress);
    if (platform == 'android') return AppUpdateReady(version, file.path);
    return AppUpdateReady(version, await _unpack(file));
  }

  /// Downloads the file of [platform] in [version] into the cache and checks
  /// its SHA-256 against the release's SHA256SUMS; deleted if it differs.
  Future<File> download(
    String version,
    String platform, {
    AppUpdateProgress? progress,
  }) async {
    final name = AppUpdates.fileName(version, platform);
    final dir = await _updates();
    await dir.create(recursive: true);
    final file = File('${dir.path}${Platform.pathSeparator}$name');
    final String? expected;
    final http.StreamedResponse response;
    try {
      final sums = await _client.get(AppUpdates.sums(version));
      if (sums.statusCode != 200) throw const AppUpdateException('network');
      expected = AppUpdates.parseSums(utf8.decode(sums.bodyBytes))[name];
      if (expected == null) throw const AppUpdateException('checksum');
      response = await _client.send(
        http.Request('GET', AppVersions.download(version, platform)!),
      );
    } on AppUpdateException {
      rethrow;
    } on Exception {
      throw const AppUpdateException('network');
    }
    if (response.statusCode != 200) {
      await response.stream.drain<void>().catchError((_) {});
      throw const AppUpdateException('network');
    }
    final total = response.contentLength;
    if (total != null && total > maxBytes) {
      await response.stream.drain<void>().catchError((_) {});
      throw const AppUpdateException('too_large');
    }
    final digest = _DigestSink();
    final hasher = sha256.startChunkedConversion(digest);
    final sink = file.openWrite();
    var received = 0;
    try {
      await for (final chunk in response.stream) {
        received += chunk.length;
        if (received > maxBytes) {
          throw const AppUpdateException('too_large');
        }
        hasher.add(chunk);
        sink.add(chunk);
        progress?.call(
          total != null && total > 0 ? received / total : null,
        );
      }
      hasher.close();
      await sink.close();
    } catch (e) {
      await sink.close().catchError((_) {});
      await _delete(file);
      if (e is AppUpdateException) rethrow;
      throw const AppUpdateException('network');
    }
    if (digest.value.toString() != expected) {
      await _delete(file);
      throw const AppUpdateException('checksum');
    }
    return file;
  }

  /// Windows: unpacks next to the app's folder, as `<folder>.update`.
  Future<String> _unpack(File zip) async {
    final exe = _executable();
    final current = File(exe).parent.path;
    if (!AppUpdates.safeWindowsPath(current) ||
        !AppUpdates.safeWindowsPath(zip.path)) {
      throw const AppUpdateException('folder');
    }
    final fresh = Directory('$current.update');
    try {
      if (await fresh.exists()) await fresh.delete(recursive: true);
      await fresh.create();
    } on FileSystemException {
      throw const AppUpdateException('folder');
    }
    final name = _name(exe);
    if (!await _unzip(zip.path, fresh.path) ||
        !await File('${fresh.path}${Platform.pathSeparator}$name').exists() ||
        AppUpdates.foreignEntries(
          await _entries(Directory(current)),
          await _entries(fresh),
        ).isNotEmpty) {
      await fresh.delete(recursive: true).catchError((_) => fresh);
      throw const AppUpdateException('folder');
    }
    await _delete(zip);
    return fresh.path;
  }

  @override
  Future<void> install(AppUpdateReady ready) async {
    if (platform == 'android') {
      final String? result;
      try {
        result = await _channel.invokeMethod<String>('install', {
          'path': ready.path,
          'version': ready.version,
        });
      } on PlatformException {
        throw const AppUpdateException('install');
      }
      if (result != 'ok') throw AppUpdateException(result ?? 'install');
      return;
    }
    if (platform != 'windows') throw const AppUpdateException('unsupported');
    final exe = _executable();
    final current = File(exe).parent.path;
    final script = AppUpdates.windowsScript(
      pid: pid,
      current: current,
      fresh: ready.path,
      previous: '$current.previous',
      exe: _name(exe),
    );
    await _restart(script);
  }

  @override
  Future<void> cleanup() async {
    try {
      final updates = await _updates();
      if (await updates.exists()) await updates.delete(recursive: true);
      if (platform == 'windows') {
        final exe = _executable();
        final current = File(exe).parent.path;
        for (final old in ['$current.previous', '$current.update']) {
          final dir = Directory(old);
          // Only a folder of OwnCoffer, never anything else by that name.
          final ours = await File(
            '$old${Platform.pathSeparator}${_name(exe)}',
          ).exists();
          if (ours) await dir.delete(recursive: true);
        }
      }
    } on FileSystemException {
      // Tried again at the next start.
    }
  }

  static String _name(String path) => path.split(RegExp(r'[\\/]')).last;

  static Future<List<String>> _entries(Directory dir) async => [
    await for (final e in dir.list()) _name(e.path),
  ];

  static Future<void> _delete(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // The cache is emptied at the next start.
    }
  }

  static Future<bool> _expandArchive(String zip, String folder) async {
    String quote(String s) => "'${s.replaceAll("'", "''")}'";
    try {
      final r = await Process.run('powershell', [
        '-NoProfile',
        '-NonInteractive',
        '-Command',
        'Expand-Archive -LiteralPath ${quote(zip)} '
            '-DestinationPath ${quote(folder)} -Force',
      ]);
      return r.exitCode == 0;
    } on ProcessException {
      return false;
    }
  }

  static Future<void> _runAndExit(String script) async {
    final temp = Directory.systemTemp;
    final file = File(
      '${temp.path}${Platform.pathSeparator}owncoffer-update.cmd',
    );
    await file.writeAsString(script, flush: true);
    await Process.start(
      'cmd',
      ['/c', file.path],
      workingDirectory: temp.path,
      mode: ProcessStartMode.detached,
    );
    // The embedded server (standalone) closes its database first.
    await stopStandalone();
    exit(0);
  }
}

class _DigestSink implements Sink<Digest> {
  Digest? value;

  @override
  void add(Digest data) => value = data;

  @override
  void close() {}
}
