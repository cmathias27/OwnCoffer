import 'dart:convert';
import 'dart:typed_data';

import 'package:owncoffer_server/src/ai/ai_adapter.dart';
import 'package:owncoffer_server/src/ai/ai_gateway.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// A model that answers with one function call, and keeps what it was sent.
class _Reader implements AiAdapter {
  final String name;
  final Map<String, Object?> args;
  final List<List<Map<String, Object?>>> received = [];
  _Reader(this.name, this.args);

  @override
  Future<Map<String, Object?>> chat({
    required String baseUrl,
    required String? apiKey,
    required String model,
    required List<Map<String, Object?>> messages,
    List<Map<String, Object?>>? tools,
  }) async {
    received.add(messages);
    return {
      'role': 'assistant',
      'content': '',
      'tool_calls': [
        {
          'id': '1',
          'type': 'function',
          'function': {'name': name, 'arguments': jsonEncode(args)},
        },
      ],
    };
  }

  @override
  Future<List<String>> models({
    required String baseUrl,
    String? apiKey,
  }) async => ['vision'];
}

/// A tiny file with the magic bytes of a PNG image (never decoded here).
ByteData _png() => ByteData.sublistView(
  Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 1, 2]),
);

/// A tiny file with the magic bytes of a JPEG image (never decoded here).
ByteData _jpeg() => ByteData.sublistView(
  Uint8List.fromList([0xFF, 0xD8, 0xFF, 1, 2]),
);

void main() {
  withServerpod('Documents read by the AI (0008, 0009)', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue admin, bob, reader, mallory;
    late int groupA;
    late Account shared;
    late BankTransaction op;
    late Category food, other;
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

    setUp(() async {
      db = sessionBuilder.build();
      admin = await user({'owncoffer.serverAdmin'});
      bob = await user({});
      reader = await user({});
      mallory = await user({'owncoffer.serverAdmin'});
      groupA = (await endpoints.group.create(as(admin), 'A')).group.id!;
      await endpoints.group.create(as(mallory), 'B');
      for (final (u, role) in [
        (bob, MemberRole.user),
        (reader, MemberRole.reader),
      ]) {
        await GroupMember.db.insertRow(
          db,
          GroupMember(groupId: groupA, authUserId: u, role: role),
        );
      }
      shared = await endpoints.account.create(
        as(admin),
        groupA,
        'Courant',
        AccountKind.checking,
      );
      op = await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: shared.id!,
          date: DateTime.utc(2026, 10, 20),
          amountCents: -4250,
          rawLabel: 'CB CARREFOUR',
          cleanLabel: 'CARREFOUR',
          operationKind: 'card',
        ),
      );
      final categories = await endpoints.category.list(as(bob), groupA);
      food = categories.firstWhere((c) => c.standardCode == 'food');
      other = categories.firstWhere(
        (c) =>
            c.kind == CategoryKind.expense &&
            c.parentId == null &&
            c.id != food.id,
      );
      final p = await endpoints.ai.saveProvider(
        as(admin),
        AiProvider(
          name: 'Vision',
          kind: 'openai',
          baseUrl: 'https://api.example.org/v1',
          models: 'vision',
          toolCalling: true,
          vision: true,
          monthlyCap: 0,
          enabled: true,
        ),
        'k',
      );
      for (final u in [bob, reader, mallory]) {
        await endpoints.ai.setPreference(as(u), p.id, 'vision', true);
      }
    });

    test('a receipt becomes a proposed split; the engine adds what the '
        'lines leave; applied on accept, undone cleanly', () async {
      final invoice = await endpoints.invoice.upload(
        as(bob),
        op.id!,
        'ticket.png',
        _png(),
      );
      final model = _Reader('receipt_lines', {
        'merchant': 'Carrefour',
        'total_cents': 4250,
        'lines': [
          {'label': 'Pain', 'amount_cents': 2000, 'category_id': food.id},
          {'label': 'Lait', 'amount_cents': 1000, 'category_id': food.id},
          {'label': 'Éponges', 'amount_cents': 1000, 'category_id': other.id},
          {'label': 'Inconnu', 'amount_cents': 100, 'category_id': 999999},
        ],
      });
      AiGateway.adapter = model;
      await expectLater(
        endpoints.ai.readInvoice(as(mallory), invoice.invoice.id!),
        denied,
      );
      await expectLater(
        endpoints.ai.readInvoice(as(reader), invoice.invoice.id!),
        denied,
      );
      expect(model.received, isEmpty, reason: 'nothing sent when refused');
      final reply = await endpoints.ai.readInvoice(
        as(bob),
        invoice.invoice.id!,
        pageImagesBase64: [base64Encode(_png().buffer.asUint8List())],
      );
      expect(reply.isExternal, isTrue);
      final sent = model.received.single.toString();
      expect(sent, contains('data:image/png;base64,'));
      expect(sent, isNot(contains('Courant')), reason: 'only the document');
      model.received.clear();
      await endpoints.ai.readInvoice(
        as(bob),
        invoice.invoice.id!,
        pageImagesBase64: [base64Encode(_jpeg().buffer.asUint8List())],
      );
      final sentJpeg = model.received.single.toString();
      expect(sentJpeg, contains('data:image/jpeg;base64,'));
      // Counted apart from the conversation (0048).
      final used = await endpoints.ai.usage(as(bob));
      expect(used.map((l) => l.feature), contains(AiFunctions.invoice));
      expect(used.map((l) => l.feature), isNot(contains(AiFunctions.chat)));
      await expectLater(
        endpoints.ai.readInvoice(
          as(bob),
          invoice.invoice.id!,
          pageImagesBase64: ['not-base64!'],
        ),
        code('ai_document_invalid_image'),
      );
      await expectLater(
        endpoints.ai.readInvoice(
          as(bob),
          invoice.invoice.id!,
          pageImagesBase64: List.filled(13, base64Encode([1])),
        ),
        code('ai_document_too_many_pages'),
      );
      expect(
        model.received,
        hasLength(1),
        reason: 'invalid images are not sent',
      );
      final p = reply.proposals.single;
      expect(p.kind, 'set_split');
      final parts = (jsonDecode(p.proposedData!) as Map)['parts'] as List;
      expect(
        {for (final x in parts) x['category_id']: x['amount_cents']},
        {food.id: -3000, other.id: -1000, null: -250},
        reason:
            'by category; the unknown category and the 1.50 the lines '
            'leave are to classify',
      );
      expect(await TransactionSplit.db.count(db), 0, reason: 'not yet');
      await endpoints.advisor.accept(as(bob), p.id!);
      expect(await TransactionSplit.db.count(db), 3);
      await endpoints.advisor.undo(as(bob), p.id!);
      expect(await TransactionSplit.db.count(db), 0);
      expect(
        (await BankTransaction.db.findById(db, op.id!))!.categoryId,
        isNull,
      );
    });

    test('lines adding up to more than the operation are refused; without '
        'image reading, nothing is sent', () async {
      final invoice = await endpoints.invoice.upload(
        as(bob),
        op.id!,
        'ticket.png',
        _png(),
      );
      AiGateway.adapter = _Reader('receipt_lines', {
        'lines': [
          {'label': 'Télé', 'amount_cents': 49900},
        ],
      });
      await expectLater(
        endpoints.ai.readInvoice(as(bob), invoice.invoice.id!),
        code('receipt_mismatch'),
      );
      final p = (await AiProvider.db.find(db)).single;
      await AiProvider.db.updateRow(db, p.copyWith(vision: false));
      await expectLater(
        endpoints.ai.readInvoice(as(bob), invoice.invoice.id!),
        code('ai_no_vision'),
      );
      expect(await ActionProposal.db.count(db), 0);
    });

    test(
      'a waiting invoice: its amount, date and merchant are proposed',
      () async {
        final invoice = await endpoints.invoice.uploadUnattached(
          as(bob),
          groupA,
          'facture.png',
          _png(),
        );
        AiGateway.adapter = _Reader('invoice_fields', {
          'amount_cents': 49900,
          'date': '2026-10-28',
          'merchant': 'Darty',
        });
        final p = (await endpoints.ai.readInvoice(
          as(bob),
          invoice.invoice.id!,
        )).proposals.single;
        expect(p.kind, 'set_invoice_hints');
        await endpoints.advisor.accept(as(bob), p.id!);
        final saved = (await Invoice.db.findById(db, invoice.invoice.id!))!;
        expect(saved.hintAmountCents, 49900);
        expect(saved.hintMerchant, 'Darty');
        expect(saved.hintDate, DateTime.utc(2026, 10, 28));
      },
    );

    test('a loan document: the terms it states are proposed for the loan, '
        'checked by the loan engine, undone cleanly', () async {
      final loan = (await endpoints.loan.create(
        as(bob),
        groupA,
        Loan(
          groupId: 0,
          kind: LoanKind.mortgage,
          lender: 'Banque',
          principalCents: 10000000,
          annualRateMilli: 1000,
          durationMonths: 120,
          firstDueDate: DateTime.utc(2026, 1, 5),
        ),
      )).loan;
      final doc = await endpoints.loan.uploadDocument(
        as(bob),
        loan.id!,
        'tableau.png',
        _png(),
      );
      AiGateway.adapter = _Reader('loan_terms', {
        'principal_cents': 10000000,
        'annual_rate_milli': 1250,
        'duration_months': 120,
        'insurance_monthly_cents': 1800,
      });
      await expectLater(
        endpoints.ai.readLoanDocument(as(mallory), doc.id!),
        denied,
      );
      final p = (await endpoints.ai.readLoanDocument(
        as(bob),
        doc.id!,
      )).proposals.single;
      expect(p.kind, 'update_loan');
      expect(jsonDecode(p.proposedData!), {
        'annual_rate_milli': 1250,
        'insurance_monthly_cents': 1800,
      }, reason: 'only what differs');
      await endpoints.advisor.accept(as(bob), p.id!);
      var now = (await Loan.db.findById(db, loan.id!))!;
      expect((now.annualRateMilli, now.insuranceMonthlyCents), (1250, 1800));
      await endpoints.advisor.undo(as(bob), p.id!);
      now = (await Loan.db.findById(db, loan.id!))!;
      expect((now.annualRateMilli, now.insuranceMonthlyCents), (1000, 0));

      AiGateway.adapter = _Reader('loan_terms', {'annual_rate_milli': 900000});
      await expectLater(
        endpoints.ai.readLoanDocument(as(bob), doc.id!),
        code('document_nothing_read'),
        reason: 'a rate out of range is not read',
      );
    });

    test('an amortisation table is compared with the engine: only the gaps '
        'are reported, and reading changes nothing', () async {
      final loan = (await endpoints.loan.create(
        as(bob),
        groupA,
        Loan(
          groupId: 0,
          kind: LoanKind.mortgage,
          lender: 'Banque',
          principalCents: 10000000,
          annualRateMilli: 1000,
          durationMonths: 120,
          firstDueDate: DateTime.utc(2026, 1, 5),
        ),
      )).loan;
      final doc = await endpoints.loan.uploadDocument(
        as(bob),
        loan.id!,
        'tableau.png',
        _png(),
      );
      // The table is checked against the engine: a row that matches is not
      // reported, a wrong one is, with the engine's figure.
      final terms = core.LoanTerms(
        principalCents: 10000000,
        annualRateMilli: 1250,
        months: 120,
        firstDue: core.LocalDate(2026, 1, 5),
        insuranceMonthlyCents: 1800,
      );
      final schedule = core.amortize(terms);
      AiGateway.adapter = _Reader('loan_terms', {
        'principal_cents': 10000000,
        'annual_rate_milli': 1250,
        'duration_months': 120,
        'insurance_monthly_cents': 1800,
        'total_interest_cents': 1,
        'schedule': [
          {
            'number': 1,
            'payment_cents': schedule[0].paymentCents,
            'interest_cents': schedule[0].interestCents,
            'remaining_cents': schedule[0].remainingCents,
          },
          {
            'number': 2,
            'payment_cents': schedule[1].paymentCents + 5000,
            'interest_cents': schedule[1].interestCents,
            'remaining_cents': schedule[1].remainingCents,
          },
        ],
      });
      final checked = (await endpoints.ai.readLoanDocument(
        as(bob),
        doc.id!,
      )).proposals.single;
      final check =
          (jsonDecode(checked.data) as Map)['check'] as Map<String, dynamic>;
      expect(check['rows_compared'], 2);
      expect(check['mismatches'], [
        {
          'number': 2,
          'field': 'payment_cents',
          'read': schedule[1].paymentCents + 5000,
          'computed': schedule[1].paymentCents,
        },
      ]);
      expect(check['total_interest_differs'], isTrue);
      expect(
        check['total_interest_computed'],
        schedule.fold<int>(0, (a, i) => a + i.interestCents),
      );
      // Reading changes nothing: the loan is as it was until accepted.
      final now = (await Loan.db.findById(db, loan.id!))!;
      expect(now.annualRateMilli, 1000);
    });

    test(
      'the whole table read: the engine finds the rate change and the '
      'pause, proposes them as the loan\'s changes, undone cleanly',
      () async {
        final loan = (await endpoints.loan.create(
          as(bob),
          groupA,
          Loan(
            groupId: 0,
            kind: LoanKind.mortgage,
            lender: 'Banque',
            principalCents: 10000000,
            annualRateMilli: 1000,
            durationMonths: 120,
            firstDueDate: DateTime.utc(2026, 1, 5),
          ),
        )).loan;
        // A change the user entered, before the rows of the table: kept.
        await endpoints.loan.addEvent(
          as(bob),
          loan.id!,
          LoanEvent(date: DateTime.utc(2026, 3, 1), paymentCents: 90000),
        );
        final doc = await endpoints.loan.uploadDocument(
          as(bob),
          loan.id!,
          'tableau.png',
          _png(),
        );
        final terms = core.LoanTerms(
          principalCents: 10000000,
          annualRateMilli: 1000,
          months: 120,
          firstDue: core.LocalDate(2026, 1, 5),
        );
        final real = core.amortize(
          terms,
          changes: [
            core.LoanChange(
              date: core.LocalDate(2026, 3, 1),
              paymentCents: 90000,
            ),
            core.LoanChange(
              date: core.LocalDate(2027, 1, 5),
              annualRateMilli: 2400,
            ),
            core.LoanChange(
              date: core.LocalDate(2028, 6, 5),
              pauseMonths: 3,
              pauseCapitalized: true,
            ),
          ],
        );
        // The table from row 6 on, as printed.
        AiGateway.adapter = _Reader('loan_terms', {
          'schedule': [
            for (final i in real.skip(5))
              {
                'number': i.number,
                'payment_cents': i.paymentCents,
                'interest_cents': i.interestCents,
                'remaining_cents': i.remainingCents,
              },
          ],
        });
        final p = (await endpoints.ai.readLoanDocument(
          as(bob),
          doc.id!,
        )).proposals.single;
        final proposed = jsonDecode(p.proposedData!) as Map;
        expect(proposed.keys, ['events']);
        expect(proposed['events'], [
          {'date': '2026-03-01', 'payment_cents': 90000},
          {'date': '2027-01-05', 'annual_rate_milli': 2400},
          {'date': '2028-06-05', 'pause_months': 3, 'pause_capitalized': true},
        ]);
        final check =
            (jsonDecode(p.data) as Map)['check'] as Map<String, dynamic>;
        expect(check['rows_compared'], real.length - 5);
        expect((check['first_number'], check['last_number']), (6, real.length));
        expect(check['gap_count'], 0);
        expect(check['events_found'], 2);
        expect(check['mismatches'], isEmpty);

        await endpoints.advisor.accept(as(bob), p.id!);
        final schedule = await endpoints.loan.schedule(as(bob), loan.id!);
        expect(schedule, hasLength(real.length));
        expect(
          schedule.where((i) => i.paused == true).map((i) => i.number),
          [
            for (final i in real)
              if (i.paused) i.number,
          ],
        );
        expect(schedule.last.remainingCents, 0);
        // Read again, the same table proposes nothing new once accepted.
        expect(
          (await endpoints.ai.readLoanDocument(as(bob), doc.id!)).proposals,
          isEmpty,
        );
        await endpoints.advisor.undo(as(bob), p.id!);
        final now = (await Loan.db.findById(db, loan.id!))!;
        expect(now.events!.map((e) => e.paymentCents), [90000]);
      },
    );

    test('the early repayment penalty of the offer is proposed, accepted '
        'and undone (0043)', () async {
      final loan = (await endpoints.loan.create(
        as(bob),
        groupA,
        Loan(
          groupId: 0,
          kind: LoanKind.mortgage,
          lender: 'Banque',
          principalCents: 10000000,
          annualRateMilli: 1000,
          durationMonths: 120,
          firstDueDate: DateTime.utc(2026, 1, 5),
        ),
      )).loan;
      final doc = await endpoints.loan.uploadDocument(
        as(bob),
        loan.id!,
        'offre.png',
        _png(),
      );
      AiGateway.adapter = _Reader('loan_terms', {
        'prepayment_interest_months': 6,
        'prepayment_percent_milli': 3000,
      });
      final p = (await endpoints.ai.readLoanDocument(
        as(bob),
        doc.id!,
      )).proposals.single;
      expect(jsonDecode(p.proposedData!), {
        'prepayment_interest_months': 6,
        'prepayment_percent_milli': 3000,
      });
      await endpoints.advisor.accept(as(bob), p.id!);
      var now = (await Loan.db.findById(db, loan.id!))!;
      expect(
        (now.prepaymentInterestMonths, now.prepaymentPercentMilli),
        (6, 3000),
      );
      await endpoints.advisor.undo(as(bob), p.id!);
      now = (await Loan.db.findById(db, loan.id!))!;
      expect(now.prepaymentInterestMonths, isNull);
      expect(now.prepaymentPercentMilli, isNull);
    });

    test('a pause entered by hand: the loan lasts longer, it is refused '
        'out of the limits', () async {
      final loan = (await endpoints.loan.create(
        as(bob),
        groupA,
        Loan(
          groupId: 0,
          kind: LoanKind.mortgage,
          lender: 'Banque',
          principalCents: 10000000,
          annualRateMilli: 1000,
          durationMonths: 120,
          firstDueDate: DateTime.utc(2026, 1, 5),
        ),
      )).loan;
      final info = await endpoints.loan.addEvent(
        as(bob),
        loan.id!,
        LoanEvent(
          date: DateTime.utc(2026, 6, 1),
          pauseMonths: 6,
          pauseCapitalized: false,
        ),
      );
      expect(info.loan.events!.single.pauseMonths, 6);
      final s = await endpoints.loan.schedule(as(bob), loan.id!);
      expect(s, hasLength(126));
      expect(s.where((i) => i.paused == true), hasLength(6));
      await expectLater(
        endpoints.loan.addEvent(
          as(bob),
          loan.id!,
          LoanEvent(date: DateTime.utc(2027, 6, 1), pauseMonths: 500),
        ),
        code('loan_event_invalid'),
      );
      await expectLater(
        endpoints.loan.addEvent(
          as(mallory),
          loan.id!,
          LoanEvent(date: DateTime.utc(2027, 6, 1), pauseMonths: 2),
        ),
        denied,
        reason: 'another group cannot pause the loan',
      );
      final kept = (await Loan.db.findById(db, loan.id!))!;
      expect(kept.events, hasLength(1));
    });
  });
}
