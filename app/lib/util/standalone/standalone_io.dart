import 'dart:io';

import 'package:owncoffer_server/embedded.dart';
import 'package:path_provider/path_provider.dart';

/// TRIAL: compiled into the Windows and Android apps.
bool get standaloneAvailable => true;

/// TRIAL: starts the embedded server only when asked
/// (OWNCOFFER_STANDALONE_TRIAL=1), so the code is really in the build.
Future<Uri?> startStandaloneTrial() async {
  if (Platform.environment['OWNCOFFER_STANDALONE_TRIAL'] != '1') return null;
  final dir = await getApplicationSupportDirectory();
  final s = await startEmbedded(
    dataDir: Directory('${dir.path}/standalone'),
    migrations: const {},
  );
  return s.api;
}
