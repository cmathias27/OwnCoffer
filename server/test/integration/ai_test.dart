import 'package:owncoffer_server/src/ai/ai_adapter.dart';
import 'package:owncoffer_server/src/ai/ai_gateway.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// A model that follows a script: each call returns the next answer, and
/// what it received is kept to check what left the server.
class _ScriptedModel implements AiAdapter {
  final List<Map<String, Object?>> answers;
  final List<List<Map<String, Object?>>> received = [];
  final List<String?> keys = [];
  var fail = false;

  _ScriptedModel(this.answers);

  @override
  Future<Map<String, Object?>> chat({
    required String baseUrl,
    required String? apiKey,
    required String model,
    required List<Map<String, Object?>> messages,
    List<Map<String, Object?>>? tools,
  }) async {
    if (fail) throw const AiUnavailable('down');
    received.add([...messages]);
    keys.add(apiKey);
    return answers.removeAt(0);
  }

  @override
  Future<List<String>> models({
    required String baseUrl,
    String? apiKey,
  }) async => ['llama3.1', 'mistral'];
}

Map<String, Object?> _call(String id, String name, String args) => {
  'role': 'assistant',
  'content': null,
  'tool_calls': [
    {
      'id': id,
      'type': 'function',
      'function': {'name': name, 'arguments': args},
    },
  ],
};

void main() {
  withServerpod('AI gateway (0008, 0017)', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue admin, bob, mallory;
    late int groupA;
    late Account shared, restricted;
    final denied = throwsA(isA<AccessDeniedException>());
    Matcher code(String c) => throwsA(
      isA<InvalidInputException>().having((e) => e.code, 'code', c),
    );

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

    AiProvider local({int cap = 0, bool vision = false}) => AiProvider(
      name: 'Ollama maison',
      kind: 'ollama',
      baseUrl: 'http://192.168.1.10:11434/v1',
      models: 'llama3.1, mistral',
      toolCalling: true,
      vision: vision,
      monthlyCap: cap,
      enabled: true,
    );

    setUp(() async {
      db = sessionBuilder.build();
      admin = await user({'owncoffer.serverAdmin'});
      mallory = await user({});
      bob = await user({});
      groupA = (await endpoints.group.create(as(admin), 'A')).group.id!;
      await GroupMember.db.insertRow(
        db,
        GroupMember(groupId: groupA, authUserId: bob, role: MemberRole.user),
      );
      shared = await endpoints.account.create(
        as(admin),
        groupA,
        'Courant',
        AccountKind.checking,
      );
      restricted = await endpoints.account.create(
        as(admin),
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

    test('only the server administrator sets providers up; the key is '
        'encrypted and never sent back', () async {
      await expectLater(
        endpoints.ai.saveProvider(as(bob), local(), 'sk-x'),
        denied,
      );
      final p = await endpoints.ai.saveProvider(
        as(admin),
        local(),
        'sk-secret-123',
      );
      expect(p.hasKey, isTrue);
      expect(p.apiKeyBox, isNull);
      expect(p.models, 'llama3.1,mistral');
      final row = await AiProvider.db.findById(db, p.id!);
      expect(row!.apiKeyBox, isNot(contains('sk-secret')));
      final seen = await endpoints.ai.status(as(bob));
      expect(seen.providers.single.apiKeyBox, isNull);
      expect(seen.canConfigure, isFalse);
      for (final bad in ['ftp://x', 'http://user:pw@host', 'not a url']) {
        await expectLater(
          endpoints.ai.saveProvider(
            as(admin),
            local().copyWith(baseUrl: bad),
            null,
          ),
          code('ai_invalid_url'),
          reason: bad,
        );
      }
      await expectLater(endpoints.ai.testProvider(as(bob), p.id!), denied);
      final log = await AuditEntry.db.find(
        db,
        where: (e) => e.entity.equals('ai_provider'),
      );
      expect(log, isNotEmpty);
      expect(
        log.every((e) => !(e.after ?? '').contains('sk-secret')),
        isTrue,
        reason: 'the key is never logged',
      );
    });

    test('the assistant sees only the visible accounts, proposes, never '
        'changes; off by default; the key reaches the provider only', () async {
      final p = await endpoints.ai.saveProvider(as(admin), local(), 'k-1');
      final model = _ScriptedModel([
        _call('1', 'get_transactions', '{"unclassified": true}'),
        _call('2', 'propose_category', '{"transaction_id": 0}'),
        {'role': 'assistant', 'content': 'Une opération à classer.'},
      ]);
      AiGateway.adapter = model;
      final ask = AiMessage(role: 'user', content: 'Que dois-je classer ?');
      await expectLater(
        endpoints.ai.chat(as(bob), groupA, [], ask),
        code('ai_off'),
      );
      await expectLater(
        endpoints.ai.setPreference(as(bob), p.id, 'gpt-x', true),
        code('ai_provider_unavailable'),
      );
      await endpoints.ai.setPreference(as(bob), p.id, 'mistral', true);
      final reply = await endpoints.ai.chat(as(bob), groupA, [], ask);
      expect(reply.text, 'Une opération à classer.');
      expect(reply.tools, ['get_transactions', 'propose_category']);
      expect(reply.isExternal, isFalse, reason: 'a model on the local network');
      expect(model.keys.toSet(), {'k-1'});
      final sent = model.received.last.toString();
      expect(sent, contains('BOULANGERIE'));
      expect(sent, isNot(contains('SECRET')), reason: 'restricted account');
      expect(reply.proposals, isEmpty, reason: 'unknown operation refused');
      expect(
        (await endpoints.transaction.list(
          as(admin),
          shared.id!,
        )).items.single.categoryId,
        isNull,
        reason: 'the AI changed nothing',
      );
      await expectLater(
        endpoints.ai.chat(as(mallory), groupA, [], ask),
        denied,
      );
      expect((await endpoints.ai.status(as(bob))).usedThisMonth, 1);
    });

    test(
      'a proposal from the AI goes to Mon conseiller, with its origin',
      () async {
        final p = await endpoints.ai.saveProvider(as(admin), local(), null);
        final op = (await endpoints.transaction.list(
          as(bob),
          shared.id!,
        )).items.single;
        final food = (await endpoints.category.list(
          as(bob),
          groupA,
        )).firstWhere((c) => c.standardCode == 'food');
        AiGateway.adapter = _ScriptedModel([
          _call(
            '1',
            'propose_category',
            '{"transaction_id": ${op.id}, "category_id": ${food.id}, '
                '"reason": "Une boulangerie."}',
          ),
          {'role': 'assistant', 'content': 'Proposé.'},
        ]);
        await endpoints.ai.setPreference(as(bob), p.id, 'llama3.1', true);
        final reply = await endpoints.ai.chat(
          as(bob),
          groupA,
          [],
          AiMessage(role: 'user', content: 'Classe-la'),
        );
        final proposal = reply.proposals.single;
        expect(proposal.origin, 'ai');
        expect(
          (proposal.provider, proposal.model),
          ('Ollama maison', 'llama3.1'),
        );
        expect(proposal.kind, 'set_category');
        await endpoints.advisor.accept(as(bob), proposal.id!);
        expect(
          (await endpoints.transaction.list(
            as(bob),
            shared.id!,
          )).items.single.categoryId,
          food.id,
        );
      },
    );

    test('cap, no vision, provider down: said plainly, never another '
        'provider', () async {
      final p = await endpoints.ai.saveProvider(as(admin), local(cap: 1), null);
      final model = _ScriptedModel([
        {'role': 'assistant', 'content': 'Bonjour.'},
      ]);
      AiGateway.adapter = model;
      await endpoints.ai.setPreference(as(bob), p.id, 'llama3.1', true);
      final ask = AiMessage(role: 'user', content: 'Bonjour');
      await endpoints.ai.chat(as(bob), groupA, [], ask);
      await expectLater(
        endpoints.ai.chat(as(bob), groupA, [], ask),
        code('ai_cap_reached'),
      );
      await endpoints.ai.saveProvider(
        as(admin),
        local().copyWith(id: p.id),
        null,
      );
      await expectLater(
        endpoints.ai.chat(
          as(bob),
          groupA,
          [],
          ask.copyWith(imageBase64: 'aGVsbG8=', imageMimeType: 'image/png'),
        ),
        code('ai_no_vision'),
      );
      model.fail = true;
      await expectLater(
        endpoints.ai.chat(as(bob), groupA, [], ask),
        code('ai_unavailable'),
      );
    });

    test('external or local', () {
      expect(AiGateway.isExternal('https://api.mistral.ai/v1'), isTrue);
      expect(AiGateway.isExternal('http://192.168.1.10:11434/v1'), isFalse);
      expect(AiGateway.isExternal('http://ollama:11434/v1'), isFalse);
      expect(AiGateway.isExternal('http://localhost:11434/v1'), isFalse);
      expect(AiGateway.isExternal('http://172.20.0.5:11434/v1'), isFalse);
    });
  });
}
