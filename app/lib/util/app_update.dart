import 'app_update/app_update_stub.dart'
    if (dart.library.js_interop) 'app_update/app_update_stub.dart'
    if (dart.library.io) 'app_update/app_update_io.dart'
    as impl;
import 'app_versions.dart';

/// Why an update could not be installed (decision 0032, point 6).
class AppUpdateException implements Exception {
  /// `network`, `checksum`, `too_large`, `permission`, `signature`,
  /// `package`, `version`, `folder`, `install` or `unsupported`.
  final String code;

  const AppUpdateException(this.code);

  @override
  String toString() => 'AppUpdateException($code)';
}

/// A new version, downloaded and checked, ready to install.
class AppUpdateReady {
  final String version;

  /// The APK (Android) or the unpacked folder (Windows).
  final String path;

  const AppUpdateReady(this.version, this.path);
}

/// How far a download is, from 0 to 1; null when its size is unknown.
typedef AppUpdateProgress = void Function(double? fraction);

/// Installs a new version of the Windows or Android app from the app itself
/// (decision 0032), only when the user asks.
abstract class AppUpdater {
  /// Android or Windows; false on the web and elsewhere.
  bool get supported;

  /// `android` or `windows`: the file to download by hand.
  String? get platform;

  /// Windows: the app closes and starts again in the new version.
  bool get restarts;

  /// The latest published version (`releases/latest`), for the standalone
  /// mode which has no server to tell; null if GitHub does not say.
  Future<String?> latest();

  /// Downloads [version] and checks it against its SHA256SUMS; on Windows,
  /// also unpacks it next to the app's folder.
  Future<AppUpdateReady> prepare(String version, {AppUpdateProgress? progress});

  /// Android: opens the system installer (which asks the user). Windows:
  /// closes the app, swaps its folder and starts it again.
  Future<void> install(AppUpdateReady ready);

  /// At start: forgets the downloads and the previous folder.
  Future<void> cleanup();

  static AppUpdater platformUpdater() => impl.platformUpdater();
}

/// Pure helpers, tested without a device.
abstract final class AppUpdates {
  /// Above it, a download is stopped (a bigger file is not ours).
  static const maxBytes = 300 * 1024 * 1024;

  /// Where GitHub sends to the latest version (decision 0032, point 1).
  static Uri get latest => Uri.parse('${AppVersions.releases}/latest');

  /// The sums of the files of [version] (decision 0021).
  static Uri sums(String version) =>
      Uri.parse('${AppVersions.releases}/download/v$version/SHA256SUMS');

  /// `owncoffer-1.17.0-android.apk` or `owncoffer-1.17.0-windows-x64.zip`.
  static String fileName(String version, String platform) =>
      AppVersions.download(version, platform)!.pathSegments.last;

  /// The lines of `sha256sum` (`<hex>  <name>`, or `<hex> *<name>`): file
  /// name → lowercase hex.
  static Map<String, String> parseSums(String text) {
    final pattern = RegExp(r'^([0-9a-fA-F]{64}) [ *](.+)$');
    return {
      for (final line in text.split('\n'))
        if (pattern.firstMatch(line.trimRight()) case final m?)
          m[2]!.trim(): m[1]!.toLowerCase(),
    };
  }

  /// `…/releases/tag/v1.17.0` → `1.17.0`; null for anything else.
  static String? versionFromLocation(String? location) {
    final m = RegExp(
      r'/releases/tag/v?(\d+\.\d+\.\d+)/?$',
    ).firstMatch(location?.trim() ?? '');
    return m?[1];
  }

  /// What the app's folder holds besides the files of the new version
  /// (names compared without case, as Windows does). The folder is swapped
  /// whole and the previous one deleted later: anything else in it (the
  /// app unpacked in Downloads or on the desktop) refuses the update, so
  /// that nothing of the user's is ever moved or deleted.
  static List<String> foreignEntries(
    Iterable<String> current,
    Iterable<String> fresh,
  ) {
    final known = {for (final n in fresh) n.toLowerCase()};
    return [
      for (final n in current)
        if (!known.contains(n.toLowerCase())) n,
    ];
  }

  /// A folder the swap script can name safely (`%` and `"` would break it).
  static bool safeWindowsPath(String path) =>
      !path.contains('%') && !path.contains('"') && !path.contains('\n');

  /// The script that waits for the app ([pid]) to close, puts [fresh] in
  /// place of [current] (kept as [previous]) and starts [exe] again; if a
  /// rename fails, puts [current] back and starts the new version from
  /// [fresh] (decision 0032, point 4).
  static String windowsScript({
    required int pid,
    required String current,
    required String fresh,
    required String previous,
    required String exe,
  }) => [
    '@echo off',
    'chcp 65001 >nul',
    'setlocal',
    'set "CUR=$current"',
    'set "NEW=$fresh"',
    'set "OLD=$previous"',
    ':wait',
    'tasklist /FI "PID eq $pid" /NH 2>nul | find " $pid " >nul',
    'if not errorlevel 1 (',
    '  ping -n 2 127.0.0.1 >nul',
    '  goto wait',
    ')',
    'if exist "%OLD%" rmdir /s /q "%OLD%"',
    'move "%CUR%" "%OLD%" >nul 2>&1 || goto fallback',
    'move "%NEW%" "%CUR%" >nul 2>&1 || goto restore',
    'start "" "%CUR%\\$exe"',
    'goto end',
    ':restore',
    'move "%OLD%" "%CUR%" >nul 2>&1',
    ':fallback',
    'start "" "%NEW%\\$exe"',
    ':end',
    'del "%~f0"',
    '',
  ].join('\r\n');
}
