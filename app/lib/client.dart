import 'dart:async';

import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'util/server_address.dart';

// When you are running the app on a physical device, you need to set the
// server URL to the IP address of your computer. You can find the IP
// address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
//
// You can set the variable when running or building your app like this:
// E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`.
//
// Otherwise, the server URL is fetched from the assets/config.json file or
// defaults to http://$localhost:8080/ if not found.

/// A relative URL (`/api/`, sent by the server behind the single-port proxy)
/// is resolved against the page's own origin.
///
/// The Windows and Android apps use the address given at build time, or the
/// one the user typed at first launch (decision 0020).
Future<String> _resolveServerUrl() async {
  if (ServerAddress.builtIn.isNotEmpty) return ServerAddress.builtIn;
  if (ServerAddress.needed) {
    final saved = await ServerAddress.load();
    if (saved != null) return saved;
  }
  final url = await getServerUrl();
  final uri = Uri.parse(url);
  if (uri.hasScheme) return url;
  return Uri.base.resolveUri(uri).toString();
}

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.
late Client client;

/// Standalone mode (decision 0022): the server runs inside this app, on
/// this device only.
bool isStandalone = false;

/// [url]: the embedded server of the standalone mode; otherwise the server
/// found as above.
Future<void> initializeClient({String? url}) async {
  client = Client(url ?? await _resolveServerUrl())
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  unawaited(client.auth.initialize());
}

/// Set by main(): shows the first launch choice again (native apps).
late Future<void> Function() askServerAddress;

/// Native apps: signs out of this server, forgets its address and the
/// mode, and asks again. In standalone mode the data stays on the device
/// and comes back when the standalone mode is chosen again.
Future<void> changeServer() async {
  if (!isStandalone) {
    try {
      await client.auth.signOutDevice();
    } on Object {
      // Server unreachable: the local session is dropped with the address.
    }
  }
  await ServerAddress.forget();
  await askServerAddress();
}
