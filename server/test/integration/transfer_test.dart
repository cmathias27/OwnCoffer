import 'dart:convert';
import 'dart:typed_data';

import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' show ExportSummary;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Decision 0022: an export recreated in a new group (standalone app →
/// server, back, or between servers), every link renumbered.
void main() {
  withServerpod('Transfer of a group', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, bob, mallory;
    late int groupA;
    final denied = throwsA(isA<AccessDeniedException>());
    final invalid = throwsA(isA<InvalidInputException>());

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user(String email, {bool admin = false}) async {
      final id = (await AuthUser.db.insertRow(
        db,
        AuthUser(
          createdAt: DateTime.now(),
          scopeNames: {if (admin) 'owncoffer.serverAdmin'},
          blocked: false,
        ),
      )).id!;
      await UserProfile.db.insertRow(
        db,
        UserProfile(authUserId: id, email: email),
      );
      return id;
    }

    ByteData bytes(List<int> b) => ByteData.sublistView(Uint8List.fromList(b));
    final pdf = bytes([...ascii.encode('%PDF-1.7\n'), 1, 2, 3, 4, 5]);

    /// Sends [json] in parts of [size] characters, then finishes.
    Future<ImportResult> send(
      UuidValue u,
      String json, {
      int size = 5000,
    }) async {
      final token = await endpoints.transfer.begin(as(u));
      for (var i = 0; i < json.length; i += size) {
        await endpoints.transfer.part(
          as(u),
          token,
          json.substring(i, (i + size).clamp(0, json.length)),
        );
      }
      return endpoints.transfer.finish(as(u), token, null);
    }

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user('alice@example.org', admin: true);
      mallory = await user('mallory@example.org', admin: true);
      bob = await user('bob@example.org');
      groupA = (await endpoints.group.create(as(alice), 'Foyer')).group.id!;
      await GroupMember.db.insertRow(
        db,
        GroupMember(groupId: groupA, authUserId: bob, role: MemberRole.user),
      );
    });

    test('round trip: everything and every link, then the files', () async {
      final courant = await endpoints.account.create(
        as(alice),
        groupA,
        'Courant',
        AccountKind.checking,
        initialBalanceCents: 10000,
      );
      final livret = await endpoints.account.create(
        as(alice),
        groupA,
        'Livret',
        AccountKind.savings,
      );
      final parent = await endpoints.category.create(
        as(alice),
        groupA,
        'Loisirs perso',
        CategoryKind.expense,
      );
      final child = await endpoints.category.create(
        as(alice),
        groupA,
        'Escalade',
        CategoryKind.expense,
        parentId: parent.id,
      );
      final rule = await endpoints.rule.create(
        as(alice),
        groupA,
        child.id!,
        'BLOC',
        RuleMatchType.contains,
      );
      final op = await endpoints.transaction.create(
        as(alice),
        courant.id!,
        DateTime.utc(2026, 10, 30),
        -2500,
        'SALLE DE BLOC',
      );
      final classified = (await BankTransaction.db.findById(db, op.id!))!;
      expect(classified.categorySource, CategorySource.groupRule);
      expect(classified.categoryRuleRef, '${rule.id}');
      // A transfer between the two accounts.
      final out = await endpoints.transaction.create(
        as(alice),
        courant.id!,
        DateTime.utc(2026, 10, 31),
        -5000,
        'VIR LIVRET',
      );
      final into = await endpoints.transaction.create(
        as(alice),
        livret.id!,
        DateTime.utc(2026, 10, 31),
        5000,
        'VIR LIVRET',
      );
      await BankTransaction.db.updateRow(
        db,
        out.copyWith(transferPairId: into.id),
      );
      await BankTransaction.db.updateRow(
        db,
        into.copyWith(transferPairId: out.id),
      );
      final invoice = await endpoints.invoice.upload(
        as(alice),
        op.id!,
        'ticket.pdf',
        pdf,
      );
      final loan = await endpoints.loan.create(
        as(alice),
        groupA,
        Loan(
          groupId: 0,
          accountId: courant.id,
          kind: LoanKind.car,
          lender: 'Banque',
          principalCents: 1200000,
          annualRateMilli: 4000,
          durationMonths: 48,
          firstDueDate: DateTime.utc(2026, 1, 5),
        ),
      );
      await endpoints.loan.uploadDocument(
        as(alice),
        loan.loan.id!,
        'offre.pdf',
        pdf,
      );

      // Planned operation and goal: the forecast and the goals follow.
      await endpoints.scheduled.create(
        as(alice),
        courant.id!,
        -80000,
        'LOYER',
        ScheduleFrequency.monthly,
        DateTime.utc(2026, 10, 5),
        categoryId: child.id,
      );
      await endpoints.goal.set(as(alice), groupA, child.id!, 30000);

      final json = await endpoints.export.groupJson(as(alice), groupA);
      final result = await send(alice, json);
      expect(result.groupName, 'Foyer');
      expect(result.accounts, 2);
      expect(result.transactions, 3);
      expect(result.documents.map((d) => d.kind).toSet(), {
        'invoice',
        'loanDocument',
      });
      final g = result.groupId;
      expect(g, isNot(groupA));
      expect(
        (await endpoints.group.myGroups(as(alice))).map((m) => m.group.id),
        containsAll([groupA, g]),
      );

      // Links: renumbered, never pointing back at the old group.
      final accounts = await endpoints.account.list(as(alice), g);
      final newCourant = accounts.firstWhere((a) => a.name == 'Courant');
      expect(newCourant.initialBalanceCents, 10000);
      final categories = await endpoints.category.list(as(alice), g);
      final newChild = categories.firstWhere((c) => c.name == 'Escalade');
      final newParent = categories.firstWhere((c) => c.name == 'Loisirs perso');
      expect(newChild.parentId, newParent.id);
      final rules = await endpoints.rule.list(as(alice), g);
      expect(rules.single.categoryId, newChild.id);
      final ops = (await endpoints.transaction.list(
        as(alice),
        newCourant.id!,
      )).items;
      final bloc = ops.firstWhere((t) => t.cleanLabel.contains('BLOC'));
      expect(bloc.categoryId, newChild.id);
      expect(bloc.categoryRuleRef, '${rules.single.id}');
      final vir = ops.firstWhere((t) => t.amountCents == -5000);
      final pair = (await BankTransaction.db.findById(
        db,
        vir.transferPairId!,
      ))!;
      expect(pair.amountCents, 5000);
      expect(pair.accountId, isNot(newCourant.id));
      final loans = (await endpoints.loan.overview(as(alice), g)).loans;
      expect(loans.single.loan.accountId, newCourant.id);

      // The engine gives the same figures on the copy (decision 0022):
      // the export, then each account's forecast, the spending report and
      // the loan's schedule, ids aside.
      final copy = await endpoints.export.groupJson(as(alice), g);
      expect(
        ExportSummary.of(jsonDecode(json) as Map<String, dynamic>).differences(
          ExportSummary.of(jsonDecode(copy) as Map<String, dynamic>),
        ),
        isEmpty,
      );
      final now = DateTime.now().toUtc();
      final today = DateTime.utc(now.year, now.month, now.day);
      final oldAccounts = await endpoints.account.list(as(alice), groupA);
      for (final a in oldAccounts) {
        final b = accounts.singleWhere((x) => x.name == a.name);
        final before = await endpoints.scheduled.forecast(
          as(alice),
          a.id!,
          today,
          horizonDays: 60,
        );
        final after = await endpoints.scheduled.forecast(
          as(alice),
          b.id!,
          today,
          horizonDays: 60,
        );
        expect(after.currentBalanceCents, before.currentBalanceCents);
        expect(after.lowestBalanceCents, before.lowestBalanceCents);
        expect(after.lowestDate, before.lowestDate);
        expect(
          [for (final d in after.days) d.balanceCents],
          [for (final d in before.days) d.balanceCents],
        );
        expect(
          [for (final e in after.events) (e.date, e.amountCents, e.label)],
          [for (final e in before.events) (e.date, e.amountCents, e.label)],
        );
      }
      final reportBefore = await endpoints.analysis.report(
        as(alice),
        groupA,
        BudgetPeriod.month,
        today,
      );
      final reportAfter = await endpoints.analysis.report(
        as(alice),
        g,
        BudgetPeriod.month,
        today,
      );
      expect(reportAfter.incomeCents, reportBefore.incomeCents);
      expect(reportAfter.expenseCents, reportBefore.expenseCents);
      expect(reportAfter.netCents, reportBefore.netCents);
      expect(reportAfter.unclassifiedCount, reportBefore.unclassifiedCount);
      expect(
        [for (final h in reportAfter.history) h.toJson()],
        [for (final h in reportBefore.history) h.toJson()],
      );
      final oldLoan = (await endpoints.loan.overview(as(alice), groupA)).loans;
      final scheduleBefore = await endpoints.loan.schedule(
        as(alice),
        oldLoan.single.loan.id!,
      );
      final scheduleAfter = await endpoints.loan.schedule(
        as(alice),
        loans.single.loan.id!,
      );
      expect(
        [for (final i in scheduleAfter) i.toJson()],
        [for (final i in scheduleBefore) i.toJson()],
      );

      // The files, one by one, then no second time.
      for (final d in result.documents) {
        await endpoints.transfer.document(as(alice), g, d.kind, d.newId, pdf);
      }
      final newInvoice = (await endpoints.invoice.forTransaction(
        as(alice),
        bloc.id!,
      )).single;
      final content = await endpoints.invoice.download(
        as(alice),
        newInvoice.invoice.id!,
      );
      expect(content.lengthInBytes, pdf.lengthInBytes);
      expect(newInvoice.invoice.id, isNot(invoice.invoice.id));
      final first = result.documents.first;
      await expectLater(
        endpoints.transfer.document(as(alice), g, first.kind, first.newId, pdf),
        invalid,
      );
    });

    test('isolation and checks', () async {
      final json = await endpoints.export.groupJson(as(alice), groupA);
      // Not the server administrator: no import.
      await expectLater(endpoints.transfer.begin(as(bob)), denied);
      // Another administrator cannot use or finish someone else's upload.
      final token = await endpoints.transfer.begin(as(alice));
      await expectLater(
        endpoints.transfer.part(as(mallory), token, json),
        invalid,
      );
      await expectLater(
        endpoints.transfer.finish(as(mallory), token, null),
        invalid,
      );
      // Not an export, or from a newer version.
      await expectLater(send(alice, '{"hello": 1}'), invalid);
      final newer = (jsonDecode(json) as Map<String, dynamic>)
        ..['formatVersion'] = 99;
      await expectLater(send(alice, jsonEncode(newer)), invalid);
      // A file for a document of another group: refused.
      final result = await send(alice, json);
      final other = (await endpoints.group.create(as(mallory), 'B')).group.id!;
      await expectLater(
        endpoints.transfer.document(as(mallory), other, 'invoice', 1, pdf),
        denied,
      );
      await expectLater(
        endpoints.transfer.document(
          as(mallory),
          result.groupId,
          'invoice',
          1,
          pdf,
        ),
        denied,
      );
      // The original group is untouched.
      expect(
        (await endpoints.group.myGroups(as(bob))).map((m) => m.group.id),
        [groupA],
      );
    });
  });
}
