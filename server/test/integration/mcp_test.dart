import 'dart:convert';

import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/mcp/mcp_server.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('MCP server (0018)', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, bob, mallory;
    late int groupA;
    late Account shared, restricted;

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user(Set<String> scopes) async =>
        (await AuthUser.db.insertRow(
          db,
          AuthUser(
            createdAt: DateTime.now(),
            scopeNames: scopes,
            blocked: false,
          ),
        )).id!;
    Map<String, Object?> rpc(String method, [Object? params, int id = 1]) => {
      'jsonrpc': '2.0',
      'id': id,
      'method': method,
      'params': ?params,
    };
    // A fresh, unauthenticated session, as for a web request.
    Future<({int status, Map<String, Object?>? body})> send(
      String? secret,
      Object? message,
    ) => McpServer.handle(
      sessionBuilder.build(),
      secret == null ? null : 'Bearer $secret',
      message,
    );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({});
      bob = await user({});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      await GroupMember.db.insertRow(
        db,
        GroupMember(groupId: groupA, authUserId: bob, role: MemberRole.user),
      );
      shared = await endpoints.account.create(
        as(alice),
        groupA,
        'Courant',
        AccountKind.checking,
      );
      restricted = await endpoints.account.create(
        as(alice),
        groupA,
        'Perso',
        AccountKind.checking,
        visibility: AccountVisibility.restricted,
      );
      for (final (a, label) in [
        (shared, 'BOULANGERIE'),
        (restricted, 'SECRET'),
      ]) {
        await BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: a.id!,
            date: DateTime.utc(2026, 10, 20),
            amountCents: -1250,
            rawLabel: 'CB $label',
            cleanLabel: label,
            operationKind: 'card',
          ),
        );
      }
    });

    test('a token of bob: tools of OwnCoffer, his visible accounts only; '
        'revoked, it stops', () async {
      await expectLater(
        endpoints.mcp.create(as(mallory), groupA, 'x'),
        throwsA(isA<AccessDeniedException>()),
        reason: 'not a member',
      );
      final t = await endpoints.mcp.create(as(bob), groupA, 'Claude Desktop');
      expect(t.secret, startsWith('ocmcp_'));
      final row = await McpToken.db.findById(db, t.token.id!);
      expect(row!.tokenHash, isNot(contains(t.secret)), reason: 'hash only');

      expect((await send(null, rpc('initialize'))).status, 401);
      expect((await send('ocmcp_wrong', rpc('initialize'))).status, 401);

      final init = await send(t.secret, rpc('initialize', {}));
      expect(
        (init.body!['result'] as Map)['protocolVersion'],
        McpServer.protocolVersion,
      );
      final notified = await send(t.secret, {
        'jsonrpc': '2.0',
        'method': 'notifications/initialized',
      });
      expect((notified.status, notified.body), (202, null));

      final list = await send(t.secret, rpc('tools/list'));
      final names = [
        for (final x in ((list.body!['result'] as Map)['tools'] as List))
          (x as Map)['name'],
      ];
      expect(names, containsAll(['get_transactions', 'propose_category']));

      final call = await send(
        t.secret,
        rpc('tools/call', {
          'name': 'get_transactions',
          'arguments': {'limit': 10},
        }),
      );
      final text =
          (((call.body!['result'] as Map)['content'] as List).single
                  as Map)['text']
              as String;
      expect(text, contains('BOULANGERIE'));
      expect(text, isNot(contains('SECRET')), reason: 'restricted account');
      expect(jsonDecode(text), isA<Map>());

      final unknown = await send(
        t.secret,
        rpc('tools/call', {'name': 'drop_database'}),
      );
      expect(unknown.body!['error'], isNotNull);

      await expectLater(
        endpoints.mcp.revoke(as(mallory), t.token.id!),
        throwsA(isA<AccessDeniedException>()),
      );
      await endpoints.mcp.revoke(as(bob), t.token.id!);
      expect((await send(t.secret, rpc('tools/list'))).status, 401);
      final log = await endpoints.admin.audit(as(alice));
      expect(
        log.where((e) => e.action == 'mcp_call'),
        hasLength(1),
        reason: 'the unknown tool was refused before anything ran',
      );
    });

    test('a member who leaves the group loses the access', () async {
      final t = await endpoints.mcp.create(as(bob), groupA, 'Agent');
      await GroupMember.db.deleteWhere(
        db,
        where: (m) => m.authUserId.equals(bob),
      );
      expect((await send(t.secret, rpc('tools/list'))).status, 401);
    });
  });
}
