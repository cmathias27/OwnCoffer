import 'dart:io';

import 'package:owncoffer_server/embedded.dart';
import 'package:path_provider/path_provider.dart';

/// Desktop and phone builds carry the server (not the tests' host, which
/// has no app folder: tests start [EmbeddedServer] themselves).
bool get standaloneAvailable => Platform.isAndroid || Platform.isWindows;

EmbeddedServer? _server;

Future<({Uri api, Future<Map<String, dynamic>> Function() signIn})>
startStandalone() async {
  final server = _server ??= await EmbeddedServer.start(
    dataDir: Directory(
      '${(await getApplicationSupportDirectory()).path}/standalone',
    ),
  );
  return (api: server.api, signIn: server.signIn);
}
