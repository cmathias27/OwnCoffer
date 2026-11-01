import 'dart:convert';

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

/// A provider that refuses the key, as Gemini does.
class _RefusingModel implements AiAdapter {
  @override
  Future<Map<String, Object?>> chat({
    required String baseUrl,
    required String? apiKey,
    required String model,
    required List<Map<String, Object?>> messages,
    List<Map<String, Object?>>? tools,
  }) async => throw const AiUnavailable('HTTP 400: API key not valid.');

  @override
  Future<List<String>> models({
    required String baseUrl,
    String? apiKey,
  }) async => throw const AiUnavailable('HTTP 400: API key not valid.');
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

    test('a rule suggested with a category is checked and counted by the '
        'engine, applied on accept to the visible accounts only, undone '
        'cleanly', () async {
      final p = await endpoints.ai.saveProvider(as(admin), local(), null);
      final categories = await endpoints.category.list(as(bob), groupA);
      final food = categories.firstWhere((c) => c.standardCode == 'food');
      final other = categories.firstWhere(
        (c) => c.id != food.id && c.kind == CategoryKind.expense,
      );
      Future<BankTransaction> op(
        Account a,
        String label,
        int day, {
        int? manual,
      }) => BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: a.id!,
          date: DateTime.utc(2026, 10, day),
          amountCents: -830,
          rawLabel: 'CB $label',
          cleanLabel: label,
          operationKind: 'card',
          categoryId: manual,
          categorySource: manual == null
              ? CategorySource.none
              : CategorySource.manual,
        ),
      );
      final example = (await endpoints.transaction.list(
        as(bob),
        shared.id!,
      )).items.single;
      final again = await op(shared, 'BOULANGERIE DU PORT', 22);
      final byHand = await op(shared, 'BOULANGERIE', 23, manual: other.id);
      final hidden = await op(restricted, 'BOULANGERIE SECRETE', 24);
      String args(String pattern) =>
          '{"transaction_id": ${example.id}, "category_id": ${food.id}, '
          '"reason": "Une boulangerie.", "rule_pattern": "$pattern"}';
      final model = _ScriptedModel([
        _call('1', 'propose_category', args('xyz')),
        _call('2', 'propose_category', args('bo')),
        _call('3', 'propose_category', args('Boulangerie')),
        {'role': 'assistant', 'content': 'Proposé, avec une règle.'},
      ]);
      AiGateway.adapter = model;
      await endpoints.ai.setPreference(as(bob), p.id, 'llama3.1', true);
      final reply = await endpoints.ai.chat(
        as(bob),
        groupA,
        [],
        AiMessage(role: 'user', content: 'Classe les boulangeries'),
      );
      final sent = model.received.last.toString();
      expect(sent, contains('pattern does not match the label'));
      expect(sent, contains('pattern too short'));
      expect(sent, isNot(contains('SECRET')), reason: 'restricted account');
      expect(
        [for (final x in reply.proposals) x.kind],
        [
          'set_category',
          'create_rule',
        ],
        reason: 'the bad patterns proposed no rule',
      );
      final rule = reply.proposals.last;
      expect(rule.proposedValue, food.id);
      final data = jsonDecode(rule.data) as Map<String, Object?>;
      expect(data['pattern'], 'BOULANGERIE');
      expect(data['match_type'], 'startsWith');
      expect(data['direction'], 'debit');
      expect(
        data['reclassified_count'],
        2,
        reason:
            'the example and the other visible one, not the manual '
            'choice, not the restricted account',
      );
      expect(data.toString(), isNot(contains('SECRET')));
      expect(await Rule.db.count(db), 0, reason: 'nothing written yet');

      await expectLater(
        endpoints.advisor.accept(as(mallory), rule.id!),
        denied,
      );
      final done = await endpoints.advisor.accept(as(bob), rule.id!);
      expect(done.status, 'executed');
      expect(
        (await endpoints.advisor.accept(as(bob), rule.id!)).resultId,
        done.resultId,
        reason: 'applied once',
      );
      final created = (await Rule.db.find(db)).single;
      expect(created.id, done.resultId);
      expect(created.groupId, groupA);
      Future<int?> cat(BankTransaction t) async =>
          (await BankTransaction.db.findById(db, t.id!))!.categoryId;
      expect(await cat(example), food.id);
      expect(await cat(again), food.id);
      expect(await cat(byHand), other.id, reason: 'a manual choice stays');
      expect(await cat(hidden), isNull, reason: 'not visible to bob');
      expect(
        (await ActionProposal.db.findById(
          db,
          reply.proposals.first.id!,
        ))!.status,
        'expired',
        reason: 'the category proposal is fulfilled by the rule',
      );

      await endpoints.advisor.undo(as(bob), rule.id!);
      expect(await Rule.db.count(db), 0);
      // Classified again without the rule (here by the history of the
      // manual choice), never left with the rule's category.
      for (final t in [example, again]) {
        final now = (await BankTransaction.db.findById(db, t.id!))!;
        expect(now.categorySource, isNot(CategorySource.groupRule));
        expect(now.categoryId, isNot(food.id));
      }
      expect(await cat(byHand), other.id);
    });

    test('a suggested rule is refused when the same rule was made since, '
        'and a reader may not accept it', () async {
      final p = await endpoints.ai.saveProvider(as(admin), local(), null);
      final food = (await endpoints.category.list(
        as(bob),
        groupA,
      )).firstWhere((c) => c.standardCode == 'food');
      final example = (await endpoints.transaction.list(
        as(bob),
        shared.id!,
      )).items.single;
      final reader = await user({});
      await GroupMember.db.insertRow(
        db,
        GroupMember(
          groupId: groupA,
          authUserId: reader,
          role: MemberRole.reader,
        ),
      );
      AiGateway.adapter = _ScriptedModel([
        _call(
          '1',
          'propose_category',
          '{"transaction_id": ${example.id}, "category_id": ${food.id}, '
              '"reason": "r", "rule_pattern": "boulangerie", '
              '"rule_match": "contains"}',
        ),
        {'role': 'assistant', 'content': 'ok'},
        _call(
          '1',
          'propose_category',
          '{"transaction_id": ${example.id}, "category_id": ${food.id}, '
              '"reason": "r", "rule_pattern": "boulangerie"}',
        ),
        {'role': 'assistant', 'content': 'ok'},
      ]);
      final ask = AiMessage(role: 'user', content: 'Classe');
      await endpoints.ai.setPreference(as(reader), p.id, 'llama3.1', true);
      final byReader = await endpoints.ai.chat(as(reader), groupA, [], ask);
      await expectLater(
        endpoints.advisor.accept(as(reader), byReader.proposals.last.id!),
        denied,
      );
      expect(await Rule.db.count(db), 0);

      await endpoints.ai.setPreference(as(bob), p.id, 'llama3.1', true);
      final reply = await endpoints.ai.chat(as(bob), groupA, [], ask);
      final rule = reply.proposals.last;
      expect(rule.kind, 'create_rule');
      await endpoints.rule.create(
        as(bob),
        groupA,
        food.id!,
        'boulangerie',
        RuleMatchType.startsWith,
        direction: RuleDirection.debit,
      );
      await expectLater(
        endpoints.advisor.accept(as(bob), rule.id!),
        code('proposal_stale'),
      );
      expect(await Rule.db.count(db), 1);
    });

    test('only the key typed: the models are asked to the provider, which '
        "also checks the key; its reason is shown, the key never", () async {
      final model = _ScriptedModel([]);
      AiGateway.adapter = model;
      final gemini = AiProvider(
        name: 'Gemini',
        kind: 'openai',
        baseUrl: 'https://generativelanguage.googleapis.com/v1beta/openai/',
        models: '',
        toolCalling: true,
        vision: true,
        monthlyCap: 0,
        enabled: true,
      );
      final saved = await endpoints.ai.saveProvider(
        as(admin),
        gemini,
        'AIza-secret',
      );
      expect(saved.models, 'llama3.1,mistral');
      expect(model.keys, isEmpty, reason: 'no chat, only the list');
      final claude = await endpoints.ai.saveProvider(
        as(admin),
        gemini.copyWith(
          name: 'Claude',
          kind: 'anthropic',
          baseUrl: 'https://api.anthropic.com/v1',
          models: 'claude-opus-5-5',
        ),
        'sk-ant-secret',
      );
      expect(claude.kind, 'anthropic');
      expect(AiGateway.isExternal(claude.baseUrl), isTrue);

      AiGateway.adapter = _RefusingModel();
      await expectLater(
        endpoints.ai.saveProvider(
          as(admin),
          gemini.copyWith(name: 'Gemini 2'),
          'AIza-wrong',
        ),
        throwsA(
          isA<InvalidInputException>()
              .having((e) => e.code, 'code', 'ai_unavailable')
              .having((e) => e.field, 'reason', contains('API key not valid'))
              .having((e) => e.field, 'reason', isNot(contains('AIza'))),
        ),
      );
      expect(
        await AiProvider.db.count(
          db,
          where: (p) => p.name.equals('Gemini 2'),
        ),
        0,
        reason: 'nothing saved with a key the provider refuses',
      );
      await expectLater(
        endpoints.ai.testProvider(as(admin), saved.id!),
        throwsA(
          isA<InvalidInputException>().having(
            (e) => e.field,
            'reason',
            contains('API key not valid'),
          ),
        ),
      );
    });

    test("memory and history: the user's own, sent to the model, never "
        "seen or deleted by anyone else", () async {
      final p = await endpoints.ai.saveProvider(as(admin), local(), null);
      final model = _ScriptedModel([
        {'role': 'assistant', 'content': 'Noté.'},
      ]);
      AiGateway.adapter = model;
      await endpoints.ai.setPreference(as(bob), p.id, 'llama3.1', true);
      final m = await endpoints.ai.addMemory(
        as(bob),
        groupA,
        ' Je suis payé le 28 ',
      );
      expect(m.text, 'Je suis payé le 28');
      await expectLater(
        endpoints.ai.memories(as(mallory), groupA),
        denied,
      );
      await endpoints.ai.deleteMemory(as(admin), m.id!);
      expect(await endpoints.ai.memories(as(bob), groupA), hasLength(1));
      expect(await endpoints.ai.memories(as(admin), groupA), isEmpty);
      await endpoints.ai.chat(
        as(bob),
        groupA,
        [],
        AiMessage(role: 'user', content: 'Quand suis-je payé ?'),
      );
      expect(
        model.received.single.first['content'],
        contains('Je suis payé le 28'),
      );

      final talk = [
        AiMessage(role: 'user', content: 'Quand suis-je payé ?'),
        AiMessage(role: 'assistant', content: 'Le 28.'),
      ];
      final c = await endpoints.ai.saveConversation(
        as(bob),
        groupA,
        null,
        talk,
      );
      expect(c.title, 'Quand suis-je payé ?');
      await expectLater(
        endpoints.ai.saveConversation(as(admin), groupA, c.id, talk),
        denied,
      );
      expect(await endpoints.ai.conversations(as(admin), groupA), isEmpty);
      await endpoints.ai.deleteConversation(as(admin), c.id!);
      expect(await endpoints.ai.conversations(as(bob), groupA), hasLength(1));
      for (var i = 0; i < 31; i++) {
        await endpoints.ai.saveConversation(as(bob), groupA, null, talk);
      }
      expect(
        await endpoints.ai.conversations(as(bob), groupA),
        hasLength(30),
        reason: 'the latest 30',
      );
      await endpoints.ai.deleteMemory(as(bob), m.id!);
      expect(await endpoints.ai.memories(as(bob), groupA), isEmpty);
    });

    test('loans, subscriptions and analyses are read on the visible '
        'accounts only', () async {
      final p = await endpoints.ai.saveProvider(as(admin), local(), null);
      for (final (a, lender) in [
        (shared, 'BanqueCommune'),
        (restricted, 'BanqueSecrete'),
      ]) {
        await endpoints.loan.create(
          as(admin),
          groupA,
          Loan(
            groupId: 0,
            accountId: a.id,
            kind: LoanKind.car,
            lender: lender,
            principalCents: 1000000,
            annualRateMilli: 3000,
            durationMonths: 48,
            firstDueDate: DateTime.utc(2026, 1, 5),
          ),
        );
      }
      final model = _ScriptedModel([
        _call('1', 'get_loans', '{}'),
        _call('2', 'get_subscriptions', '{}'),
        _call('3', 'get_insights', '{}'),
        {'role': 'assistant', 'content': 'Voilà.'},
      ]);
      AiGateway.adapter = model;
      await endpoints.ai.setPreference(as(bob), p.id, 'llama3.1', true);
      final reply = await endpoints.ai.chat(
        as(bob),
        groupA,
        [],
        AiMessage(role: 'user', content: 'Mes crédits ?'),
      );
      expect(reply.tools, ['get_loans', 'get_subscriptions', 'get_insights']);
      final sent = model.received.last.toString();
      expect(sent, contains('BanqueCommune'));
      expect(sent, contains('monthly_total_cents'));
      expect(sent, contains('bank_fees_12_months_cents'));
      expect(sent, isNot(contains('BanqueSecrete')), reason: 'restricted');
    });

    test(
      'advisor tools: scenarios computed by the engine, nothing saved',
      () async {
        final p = await endpoints.ai.saveProvider(as(admin), local(), null);
        final loan = (await endpoints.loan.create(
          as(admin),
          groupA,
          Loan(
            groupId: 0,
            accountId: shared.id,
            kind: LoanKind.car,
            lender: 'Banque',
            principalCents: 1000000,
            annualRateMilli: 4000,
            durationMonths: 48,
            firstDueDate: DateTime.utc(2026, 1, 5),
          ),
        )).loan;
        final scheduledBefore = await ScheduledTransaction.db.count(db);
        final model = _ScriptedModel([
          _call('1', 'simulate_purchase', '{"amount_cents": 50000}'),
          _call(
            '2',
            'simulate_early_repayment',
            '{"loan_id": ${loan.id}, "amount_cents": 200000}',
          ),
          _call('3', 'get_advice', '{}'),
          _call(
            '4',
            'simulate_contract_switch',
            '{"current_monthly_cents": 4999, "new_monthly_cents": 2999, '
                '"switch_cost_cents": 5000, "years": 3}',
          ),
          _call(
            '5',
            'simulate_loan_change',
            '{"loan_id": ${loan.id}, "annual_rate_milli": 2500, '
                '"fees_cents": 10000}',
          ),
          {'role': 'assistant', 'content': 'Mon conseil.'},
        ]);
        AiGateway.adapter = model;
        await endpoints.ai.setPreference(as(bob), p.id, 'llama3.1', true);
        await endpoints.ai.chat(
          as(bob),
          groupA,
          [],
          AiMessage(role: 'user', content: 'Puis-je acheter un vélo ?'),
        );
        final results = [
          for (final m in model.received.last)
            if (m['role'] == 'tool') jsonDecode(m['content']! as String) as Map,
        ];
        expect(results[0]['scenarios'], hasLength(5));
        expect(results[0]['account'], 'Courant');
        expect(results[1]['interest_saved_cents'], greaterThan(0));
        expect(results[2]['advice'], isA<List>());
        expect(results[3]['total_saving_cents'], 2000 * 36 - 5000);
        expect(results[3]['break_even_month'], 3);
        expect(
          results[4]['instalment_after_cents'],
          lessThan(results[4]['instalment_before_cents'] as int),
        );
        expect(
          model.received.first.first['content'],
          contains('personal financial advisor'),
        );
        expect(
          await ScheduledTransaction.db.count(db),
          scheduledBefore,
          reason: 'a simulation saves nothing',
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
