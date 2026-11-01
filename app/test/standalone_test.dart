import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_app/util/group_transfer.dart';
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
      // A document of a few MB, as a scanned invoice (limit of the server).
      final big = Uint8List(3 * 1024 * 1024)
        ..setAll(0, ascii.encode('%PDF-1.7\n'));
      final tx = (await client.transaction.list(account.id!)).items.single;
      final invoice = await client.invoice.upload(
        tx.id!,
        'facture.pdf',
        ByteData.sublistView(big),
      );
      expect(invoice.invoice.sizeBytes, big.length);
      final forecast = await client.scheduled.forecast(
        account.id!,
        DateTime.utc(2026, 11, 2),
      );
      expect(forecast.currentBalanceCents, -4250);

      // Moved to a server (here the same one): a new group with everything,
      // the invoice's file included; the source group stays.
      final moved = await GroupTransfer.send(
        from: client,
        to: client,
        groupId: group.id!,
      );
      expect(moved.transactions, 1);
      expect(moved.documents.single.kind, 'invoice');
      final copy = (await client.account.list(moved.groupId)).single;
      final copied = (await client.transaction.list(copy.id!)).items.single;
      final file = (await client.invoice.forTransaction(copied.id!)).single;
      expect(
        (await client.invoice.download(file.invoice.id!)).lengthInBytes,
        big.length,
      );

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
      // The group and its copy made by the move.
      expect(groups.map((g) => g.group.name), ['Mes comptes', 'Mes comptes']);
      final page = await client.transaction.list(account.id!);
      expect(page.items.single.cleanLabel, 'BOULANGERIE');
      expect(groups.map((g) => g.group.id), contains(moved.groupId));
      client.close();
      await server.stop();
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'standalone backup: encrypted, restored on another device',
    () async {
      final here = Directory.systemTemp.createTempSync('owncoffer-here-');
      final there = Directory.systemTemp.createTempSync('owncoffer-there-');
      addTearDown(() {
        here.deleteSync(recursive: true);
        there.deleteSync(recursive: true);
      });
      const pass = 'ma phrase de sauvegarde';
      var server = await EmbeddedServer.start(dataDir: here);
      var client = Client(server.api.toString())
        ..authSessionManager = FlutterAuthSessionManager(storage: _Memory());
      await client.auth.updateSignedInUser(
        AuthSuccess.fromJson(await server.signIn()),
      );
      final group = (await client.group.create('Mes comptes')).group;
      final account = await client.account.create(
        group.id!,
        'Courant',
        AccountKind.checking,
      );
      await client.transaction.create(
        account.id!,
        DateTime.utc(2026, 11, 2),
        -990,
        'CAFE',
      );
      final backup = await server.backup(pass, metadata: {'app': 'test'});
      expect(
        latin1.decode(backup, allowInvalid: true),
        isNot(contains('CAFE')),
      );
      client.close();
      await server.stop();

      expect(
        () => DeviceBackup.restoreInto(there, backup, 'pas la bonne phrase'),
        throwsA(isA<BackupPassphraseException>()),
      );
      await DeviceBackup.restoreInto(there, backup, pass);
      server = await EmbeddedServer.start(dataDir: there);
      client = Client(server.api.toString())
        ..authSessionManager = FlutterAuthSessionManager(storage: _Memory());
      await client.auth.updateSignedInUser(
        AuthSuccess.fromJson(await server.signIn()),
      );
      final groups = await client.group.myGroups();
      expect(groups.single.group.name, 'Mes comptes');
      final restored = (await client.account.list(groups.single.group.id!));
      final ops = await client.transaction.list(restored.single.id!);
      expect(ops.items.single.cleanLabel, 'CAFE');
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
