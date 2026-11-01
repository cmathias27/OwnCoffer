import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

/// Address of the user's OwnCoffer server, for the Windows and Android apps
/// (decision 0020). The web app is served by the server itself and never
/// needs it. Kept in the device's secure storage, sent nowhere else.
abstract final class ServerAddress {
  static const _key = 'owncoffer.serverUrl';
  static const _storage = FlutterSecureStorage();

  /// Set at build time (`--dart-define=SERVER_URL=…`): no question asked.
  static const builtIn = String.fromEnvironment('SERVER_URL');

  /// The native apps ask for the address once.
  static bool get needed => !kIsWeb && builtIn.isEmpty;

  static Future<String?> load() => _storage.read(key: _key);

  static Future<void> save(Uri api) =>
      _storage.write(key: _key, value: api.toString());

  static Future<void> forget() => _storage.delete(key: _key);

  /// The API address from what the user typed: `comptes.example.org` or
  /// `https://comptes.example.org/` give `https://comptes.example.org/api/`
  /// (the single-port proxy serves the API under /api/, decision 0015).
  /// Null if it is not an address. Plain http is accepted only for the
  /// device itself and the local network (a test server at home): bank
  /// data never travels unencrypted over the internet.
  static Uri? parse(String input) {
    var text = input.trim();
    if (text.isEmpty || text.contains(' ')) return null;
    if (!text.contains('://')) text = 'https://$text';
    final Uri uri;
    try {
      uri = Uri.parse(text);
    } on FormatException {
      return null;
    }
    if (uri.host.isEmpty || uri.hasQuery || uri.hasFragment) return null;
    if (uri.scheme != 'https' && !(uri.scheme == 'http' && isLocal(uri.host))) {
      return null;
    }
    var path = uri.path;
    if (!path.endsWith('/')) path = '$path/';
    if (!path.endsWith('/api/')) path = '${path}api/';
    return uri.replace(path: path, userInfo: '');
  }

  /// localhost, 127.x, 10.x, 192.168.x, 172.16–31.x, *.local, *.lan.
  static bool isLocal(String host) {
    final h = host.toLowerCase();
    if (h == 'localhost' || h.endsWith('.local') || h.endsWith('.lan')) {
      return true;
    }
    final p = h.split('.').map(int.tryParse).toList();
    if (p.length != 4 || p.any((n) => n == null || n < 0 || n > 255)) {
      return false;
    }
    return p[0] == 127 ||
        p[0] == 10 ||
        (p[0] == 192 && p[1] == 168) ||
        (p[0] == 172 && p[1]! >= 16 && p[1]! <= 31);
  }

  /// Whether an OwnCoffer server answers at [api] (its public setup status,
  /// which needs no account).
  static Future<bool> check(Uri api) async {
    final probe = Client(api.toString());
    try {
      await probe.setup.status().timeout(const Duration(seconds: 15));
      return true;
    } on Object {
      return false;
    } finally {
      probe.close();
    }
  }
}
