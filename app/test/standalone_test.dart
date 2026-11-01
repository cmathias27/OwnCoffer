import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_server/embedded.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Decision 0022: the server inside the app, on SQLite, used through the
/// app's own client, as the standalone mode does at each start.
void main() {
  test(
    'standalone: starts, signs the owner in, keeps the data, local only',
    () async {
      final dir = Directory.systemTemp.createTempSync('owncoffer-standalone-');
      addTearDown(() => dir.deleteSync(recursive: true));

      var server = await EmbeddedServer.start(dataDir: dir);
      var client = Client(server.api.toString())
        ..authSessionManager = FlutterAuthSessionManager(storage: _Memory());
      expect((await client.setup.status()).needsSetup, isFalse);
      await client.auth.updateSignedInUser(
        AuthSuccess.fromJson(await server.signIn()),
      );
      expect((await client.twoFactor.status()).fullAccess, isTrue);
      expect(await client.group.myGroups(), isEmpty);
      final group = (await client.group.create('Mes comptes')).group;
      final account = await client.account.create(
        group.id!,
        'Courant',
        AccountKind.checking,
      );
      await client.transaction.create(
        account.id!,
        DateTime.utc(2026, 11, 2),
        -4250,
        'BOULANGERIE',
      );
      final forecast = await client.scheduled.forecast(
        account.id!,
        DateTime.utc(2026, 11, 2),
      );
      expect(forecast.currentBalanceCents, -4250);

      // Another device of the network: refused.
      final lan = (await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      )).expand((i) => i.addresses).where((a) => !a.isLoopback).firstOrNull;
      if (lan != null) {
        final r = await http.post(
          Uri.parse('http://${lan.address}:${server.api.port}/setup'),
          body: '{"method":"status"}',
        );
        expect(r.statusCode, 403);
      }

      // Next start, same folder: the data is there, one owner only.
      client.close();
      await server.stop();
      server = await EmbeddedServer.start(dataDir: dir);
      client = Client(server.api.toString())
        ..authSessionManager = FlutterAuthSessionManager(storage: _Memory());
      await client.auth.updateSignedInUser(
        AuthSuccess.fromJson(await server.signIn()),
      );
      final groups = await client.group.myGroups();
      expect(groups.map((g) => g.group.name), ['Mes comptes']);
      final page = await client.transaction.list(account.id!);
      expect(page.items.single.cleanLabel, 'BOULANGERIE');
      client.close();
      await server.stop();
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

/// The app keeps its session in the device's secure storage; here, memory.
class _Memory implements ClientAuthSuccessStorage {
  AuthSuccess? _value;

  @override
  Future<AuthSuccess?> get() async => _value;

  @override
  Future<void> set(AuthSuccess? data) async => _value = data;
}
