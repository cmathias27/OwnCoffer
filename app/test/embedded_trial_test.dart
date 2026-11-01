import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_server/embedded.dart';

/// TRIAL: the server started inside the Flutter process, on SQLite, and
/// the app's own client talking to it.
void main() {
  test(
    'embedded server: starts, migrates, answers, refuses the network',
    () async {
      final dir = Directory.systemTemp.createTempSync('owncoffer-standalone-');
      final migrations = <String, String>{
        for (final f in Directory(
          '../server/standalone/migrations',
        ).listSync(recursive: true).whereType<File>())
          f.path.substring('../server/standalone/migrations/'.length): f
              .readAsStringSync(),
      };
      final watch = Stopwatch()..start();
      final s = await startEmbedded(dataDir: dir, migrations: migrations);
      // ignore: avoid_print
      print('[trial] started in ${watch.elapsedMilliseconds} ms at ${s.api}');
      final client = Client(s.api.toString());
      final status = await client.setup.status();
      // ignore: avoid_print
      print('[trial] setup status: $status');
      expect(File('${dir.path}/owncoffer.db').existsSync(), isTrue);

      // Another device of the network: refused.
      final lan = (await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      )).expand((i) => i.addresses).where((a) => !a.isLoopback).firstOrNull;
      if (lan != null) {
        final r = await http.post(
          Uri.parse('http://${lan.address}:${s.api.port}/setup'),
          body: '{"method":"status"}',
        );
        // ignore: avoid_print
        print('[trial] from ${lan.address}: ${r.statusCode} ${r.body}');
        expect(r.statusCode, 403);
      }

      // Restart on the same file: data kept, migrations already applied.
      client.close();
      await s.pod.shutdown(exitProcess: false);
      final again = await startEmbedded(dataDir: dir, migrations: migrations);
      expect(await Client(again.api.toString()).setup.status(), isNotNull);
      await again.pod.shutdown(exitProcess: false);
      dir.deleteSync(recursive: true);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
