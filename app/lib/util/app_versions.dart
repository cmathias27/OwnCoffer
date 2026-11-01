import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Versions of this app and of the server it talks to (Windows and Android
/// apps are installed by the user, so they can lag behind the server).
abstract final class AppVersions {
  /// Where the published versions are (decision 0021).
  static const releases = 'https://github.com/cmathias27/OwnCoffer/releases';

  static String? _app;

  /// This app's version (1.0.3), from its build.
  static Future<String> app() async =>
      _app ??= (await PackageInfo.fromPlatform()).version;

  /// `web`, `android`, `windows`…: sent with a feedback message.
  static String get platform => kIsWeb ? 'web' : defaultTargetPlatform.name;

  /// For tests.
  @visibleForTesting
  static set appForTests(String? v) => _app = v;

  /// `1.0.3` → [1, 0, 3]; null for anything else (`dev`, `edge`…).
  static List<int>? parse(String? v) {
    final m = RegExp(r'^v?(\d+)\.(\d+)\.(\d+)').firstMatch(v?.trim() ?? '');
    return m == null ? null : [for (var i = 1; i <= 3; i++) int.parse(m[i]!)];
  }

  /// -1 if [a] is older than [b], 0 if the same, 1 if newer; null when one
  /// of them is not a published version.
  static int? compare(String? a, String? b) {
    final x = parse(a), y = parse(b);
    if (x == null || y == null) return null;
    for (var i = 0; i < 3; i++) {
      if (x[i] != y[i]) return x[i] < y[i] ? -1 : 1;
    }
    return 0;
  }

  /// The native app is older than the server: a new one is available.
  static bool updateAvailable(String? app, String? server) =>
      !kIsWeb && compare(app, server) == -1;

  /// Page of the version [server] runs (or of the latest one).
  static Uri releasePage(String? server) {
    final v = parse(server);
    return Uri.parse(
      v == null ? '$releases/latest' : '$releases/tag/v${v.join('.')}',
    );
  }

  /// Download of the app for [platform] (`android` or `windows`), in the
  /// version the server runs; null when it is not a published version.
  static Uri? download(String? server, String platform) {
    final v = parse(server);
    if (v == null) return null;
    final version = v.join('.');
    final file = platform == 'android'
        ? 'owncoffer-$version-android.apk'
        : 'owncoffer-$version-windows-x64.zip';
    return Uri.parse('$releases/download/v$version/$file');
  }
}
