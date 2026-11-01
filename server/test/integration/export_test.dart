import 'dart:convert';

import 'package:owncoffer_server/src/export/export_service.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Export', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, bob, mallory;
    late int groupA, groupB;
    late Account shared, restricted;
    final denied = throwsA(isA<AccessDeniedException>());

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
        UserProfile(authUserId: id, email: email, fullName: email[0]),
      );
      return id;
    }

    Future<BankTransaction> op(
      Account a,
      String label,
      int cents, {
      String? note,
      int day = 1,
    }) => BankTransaction.db.insertRow(
      db,
      BankTransaction(
        accountId: a.id!,
        date: DateTime.utc(2026, 10, day),
        amountCents: cents,
        rawLabel: 'PRLV $label',
        cleanLabel: label,
        note: note,
        operationKind: 'directDebit',
      ),
    );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user('alice@example.org', admin: true);
      bob = await user('bob@example.org');
      mallory = await user('mallory@example.org', admin: true);
      groupA = (await endpoints.group.create(as(alice), 'Foyer')).group.id!;
      groupB = (await endpoints.group.create(as(mallory), 'B')).group.id!;
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
      await op(shared, 'EDF', -6543, day: 5);
      await op(shared, 'SALAIRE', 250000, note: '=HYPERLINK("x")', day: 2);
      final trashed = await op(shared, 'ERREUR', -100, day: 3);
      await BankTransaction.db.updateRow(
        db,
        trashed.copyWith(deletedAt: DateTime.now()),
      );
      await op(restricted, 'BIJOUX', -12000);
    });

    test('JSON: everything the member sees, nothing else, no secret', () async {
      final doc =
          jsonDecode(await endpoints.export.groupJson(as(bob), groupA))
              as Map<String, dynamic>;
      expect(doc['format'], 'owncoffer-export');
      expect(doc['formatVersion'], ExportService.formatVersion);
      expect(doc['amounts'], 'cents');
      expect((doc['group'] as Map)['name'], 'Foyer');
      final accounts = [
        for (final a in doc['accounts'] as List) (a as Map)['name'],
      ];
      expect(accounts, ['Courant']);
      for (final a in doc['accounts'] as List) {
        expect((a as Map).containsKey('bankAccountKey'), isFalse);
      }
      final ops = [
        for (final t in doc['transactions'] as List)
          ((t as Map)['cleanLabel'], t['amountCents']),
      ];
      // Oldest first, the trash included (marked by deletedAt).
      expect(ops, [('SALAIRE', 250000), ('ERREUR', -100), ('EDF', -6543)]);
      expect((doc['categories'] as List), isNotEmpty);
      for (final key in [
        'rules',
        'goals',
        'scheduledTransactions',
        'transactionSplits',
        'balanceChecks',
        'imports',
        'loans',
        'loanDocuments',
        'invoices',
        'aiMemories',
        'aiConversations',
        'members',
      ]) {
        expect(doc[key], isA<List>(), reason: key);
      }
      final text = jsonEncode(doc);
      expect(text, isNot(contains('BIJOUX')));
      expect(text, isNot(contains('secret')));

      // The administrator sees the restricted account too.
      final all =
          jsonDecode(await endpoints.export.groupJson(as(alice), groupA))
              as Map<String, dynamic>;
      expect((all['accounts'] as List).length, 2);
      expect(jsonEncode(all), contains('BIJOUX'));

      final log = await AuditEntry.db.find(
        db,
        where: (e) => e.groupId.equals(groupA) & e.action.equals('export_json'),
      );
      expect(log.length, 2);
    });

    test('CSV: French and English layouts, formulas neutralised', () async {
      final fr = await endpoints.export.transactionsCsv(as(bob), groupA, null);
      expect(fr.startsWith('\uFEFF'), isTrue);
      final lines = fr.substring(1).split('\r\n')
        ..removeWhere((l) => l.isEmpty);
      expect(lines.first, startsWith('date;compte;libellé;'));
      // Trash left out, restricted account left out.
      expect(lines.length, 3);
      expect(lines[1], startsWith('2026-10-02;Courant;SALAIRE;PRLV SALAIRE;;'));
      expect(lines[1], contains(';2500,00;250000;'));
      expect(lines[1], contains(';"\'=HYPERLINK(""x"")";'));
      expect(lines[2], contains(';-65,43;-6543;'));
      expect(fr, isNot(contains('BIJOUX')));
      expect(fr, isNot(contains('ERREUR')));

      final en = await endpoints.export.transactionsCsv(as(bob), groupA, 'en');
      expect(en.substring(1), startsWith('date,account,label,'));
      expect(en, contains(',-65.43,-6543,'));
    });

    test('cells are quoted and guarded', () {
      expect(ExportService.csvCell('a;b', ';'), '"a;b"');
      expect(ExportService.csvCell('say "hi"', ';'), '"say ""hi"""');
      expect(ExportService.csvCell('-12,50', ';'), '-12,50');
      expect(ExportService.csvCell('-12.50', ','), '-12.50');
      expect(ExportService.csvCell('+33 6', ','), "'+33 6");
      expect(ExportService.csvCell('@SUM(A1)', ','), "'@SUM(A1)");
      expect(ExportService.csvCell('EDF', ','), 'EDF');
    });

    test('isolation: another group is refused, its data untouched', () async {
      await expectLater(
        endpoints.export.groupJson(as(mallory), groupA),
        denied,
      );
      await expectLater(
        endpoints.export.transactionsCsv(as(mallory), groupA, 'fr'),
        denied,
      );
      await expectLater(endpoints.export.groupJson(as(bob), groupB), denied);
      expect(
        await BankTransaction.db.count(
          db,
          where: (t) => t.accountId.equals(shared.id!),
        ),
        3,
      );
      expect(
        await AuditEntry.db.count(
          db,
          where: (e) => e.action.like('export_%'),
        ),
        0,
      );
    });
  });
}
