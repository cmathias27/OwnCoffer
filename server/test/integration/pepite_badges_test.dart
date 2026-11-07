import 'package:owncoffer_server/src/endpoints/pepite_endpoint.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/pepite/pepite_badges.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_server/src/security/session_devices.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// The badges of decision 0028 (point 1): each from the user's own doings,
/// never another's, never an amount.
void main() {
  withServerpod('Pépite: the new badges', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, mallory, bob;
    late int groupA, groupB;
    late Account account, other;
    late Map<String, Category> cats;
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user(Set<String> scopes) async =>
        (await AuthUser.db.insertRow(
          db,
          AuthUser(createdAt: now, scopeNames: scopes, blocked: false),
        )).id!;
    Future<List<String>> fresh(UuidValue u) async =>
        (await endpoints.pepite.status(as(u), today)).newBadges;
    Future<void> rule(UuidValue u, int group, int category, String p) =>
        endpoints.rule.create(
          as(u),
          group,
          category,
          p,
          RuleMatchType.contains,
        );
    Future<ScheduledTransaction> planned(
      UuidValue u,
      Account a, {
      bool subscription = false,
    }) => endpoints.scheduled.create(
      as(u),
      a.id!,
      -999,
      'Abonnement',
      ScheduleFrequency.monthly,
      today,
      subscription: subscription,
    );
    Future<BankTransaction> operation(
      Account a,
      DateTime date,
      int cents, [
      String code = 'food',
    ]) => BankTransaction.db.insertRow(
      db,
      BankTransaction(
        accountId: a.id!,
        date: date,
        amountCents: -cents,
        rawLabel: 'CB MAGASIN',
        cleanLabel: 'MAGASIN',
        operationKind: 'card',
        categoryId: cats[code]!.id,
      ),
    );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({'owncoffer.serverAdmin'});
      bob = await user({});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      groupB = (await endpoints.group.create(as(mallory), 'B')).group.id!;
      account = await endpoints.account.create(
        as(alice),
        groupA,
        'Courant',
        AccountKind.checking,
      );
      other = await endpoints.account.create(
        as(mallory),
        groupB,
        'Courant',
        AccountKind.checking,
      );
      cats = {
        for (final c in await endpoints.category.list(as(alice), groupA))
          c.standardCode!: c,
      };
    });

    test('a new user has none of them', () async {
      expect(await fresh(alice), isEmpty);
      expect(
        PepiteEndpoint.badgeCodes.toSet(),
        hasLength(PepiteEndpoint.badgeCodes.length),
      );
      expect(PepiteEndpoint.badgeCodes, containsAll(PepiteBadges.codes));
    });

    test('« Bien rangé »: ten rules of their own', () async {
      final food = cats['food']!.id!;
      for (var i = 0; i < PepiteBadges.tidyRules - 1; i++) {
        await rule(alice, groupA, food, 'MAGASIN $i');
      }
      expect(await fresh(alice), isEmpty);
      await rule(alice, groupA, food, 'MAGASIN 9');
      final s = await endpoints.pepite.status(as(alice), today);
      expect(s.newBadges, ['tidy']);
      expect(s.seeds, PepiteEndpoint.badgeSeeds);
      expect(await fresh(alice), isEmpty);
    });

    test('« Voyant », « Chasseur » and « Coup de ciseaux »', () async {
      final first = await planned(alice, account);
      expect(await fresh(alice), ['seer']);
      final subs = [
        for (var i = 0; i < PepiteBadges.declaredSubscriptions - 1; i++)
          await planned(alice, account, subscription: true),
      ];
      expect(await fresh(alice), isEmpty);
      // A planned operation made a subscription counts too.
      await endpoints.scheduled.update(
        as(alice),
        first.id!,
        subscription: true,
      );
      expect(await fresh(alice), ['subscription_hunter']);
      // Given an end: cancelled.
      await endpoints.scheduled.update(
        as(alice),
        subs.first.id!,
        endDate: today.add(const Duration(days: 40)),
      );
      expect(await fresh(alice), ['scissors']);
    });

    test('« Coup de ciseaux »: a subscription deleted', () async {
      final plain = await planned(alice, account);
      await endpoints.scheduled.delete(as(alice), plain.id!);
      await fresh(alice);
      // Not a subscription: nothing cancelled.
      expect(
        (await endpoints.pepite.status(as(alice), today)).badges,
        isNot(contains('scissors')),
      );
      final sub = await planned(alice, account, subscription: true);
      await endpoints.scheduled.delete(as(alice), sub.id!);
      expect(await fresh(alice), ['scissors']);
    });

    test('« Archiviste »: ten invoices attached to an operation', () async {
      Future<void> invoice({int? transactionId}) async => Invoice.db.insertRow(
        db,
        Invoice(
          groupId: groupA,
          transactionId: transactionId,
          fileName: 'facture.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 10,
          uploadedBy: alice,
        ),
      );
      final t = await operation(account, today, 1000);
      for (var i = 0; i < PepiteBadges.archivedInvoices - 1; i++) {
        await invoice(transactionId: t.id);
      }
      await invoice();
      expect(await fresh(alice), isEmpty);
      await invoice(transactionId: t.id);
      expect(await fresh(alice), ['archivist']);
    });

    test('« Maître des prêts »: a loan created', () async {
      await AuditEntry.db.insertRow(
        db,
        AuditEntry(
          groupId: groupA,
          authUserId: alice,
          action: 'create',
          entity: 'loan',
        ),
      );
      expect(await fresh(alice), ['loan_master']);
    });

    test('« Coffre-fort »: two-factor authentication on', () async {
      final secret = await TotpSecret.db.insertRow(
        db,
        TotpSecret(authUserId: alice, secretBox: 'x'),
      );
      expect(await fresh(alice), isEmpty);
      await TotpSecret.db.updateRow(db, secret.copyWith(enabled: true));
      expect(await fresh(alice), ['vault']);
    });

    test('what the device vouches for, and nothing else', () async {
      final s = await endpoints.pepite.status(
        as(alice),
        today,
        device: ['device_unlock', 'backup', 'backup', 'weeks_52', 'forged'],
      );
      expect(s.newBadges, unorderedEquals(['velvet', 'provident']));
      final marks = await PepiteMark.db.find(
        db,
        where: (m) => m.authUserId.equals(alice),
      );
      expect(
        marks.map((m) => m.code),
        unorderedEquals(['device_unlock', 'backup']),
      );
      expect(await fresh(mallory), isEmpty);
    });

    test('« Vigilant »: a sign-in alert opened, not all marked read', () async {
      Future<AppNotification> alert(String key) => AppNotification.db.insertRow(
        db,
        AppNotification(
          authUserId: alice,
          type: SessionDevices.alert,
          data: '{}',
          dedupKey: key,
        ),
      );
      await alert('a');
      await endpoints.notification.markAllRead(as(alice));
      expect(await fresh(alice), isEmpty);
      final n = await alert('b');
      await expectLater(
        endpoints.notification.markRead(as(mallory), n.id!),
        throwsA(isA<AccessDeniedException>()),
      );
      expect(await fresh(alice), isEmpty);
      await endpoints.notification.markRead(as(alice), n.id!);
      expect(await fresh(alice), ['vigilant']);
      expect(await fresh(mallory), isEmpty);
    });

    test('« Au centime près »: a balance reconciled', () async {
      Future<void> check(int difference) async => BalanceCheck.db.insertRow(
        db,
        BalanceCheck(
          accountId: account.id!,
          date: today,
          bankBalanceCents: 0,
          computedCents: 0,
          differenceCents: difference,
          unclearedManualCents: 0,
          createdBy: alice,
        ),
      );
      await check(150);
      expect(await fresh(alice), isEmpty);
      await check(0);
      expect(await fresh(alice), ['to_the_cent']);
    });

    test('« Bilan du mois »: three months reviewed', () async {
      DateTime month(int back) =>
          DateTime.utc(today.year, today.month - back, 15);
      await endpoints.analysis.review(as(alice), groupA, month(1));
      await endpoints.analysis.review(as(alice), groupA, month(1));
      // A month not begun is not reviewed.
      await endpoints.analysis.review(as(alice), groupA, month(-2));
      await endpoints.analysis.review(as(alice), groupA, month(2));
      expect(await fresh(alice), isEmpty);
      // Another's group: refused, nothing recorded.
      await expectLater(
        endpoints.analysis.review(as(mallory), groupA, month(3)),
        throwsA(isA<AccessDeniedException>()),
      );
      expect(await fresh(mallory), isEmpty);
      await endpoints.analysis.review(as(alice), groupA, month(0));
      expect(await fresh(alice), ['month_reviews']);
    });

    test('« Premier objectif »', () async {
      await endpoints.goal.set(as(alice), groupA, cats['food']!.id!, 20000);
      expect(await fresh(alice), ['first_goal']);
    });

    test(
      '« Objectif atteint »: last month within a goal, at the ritual',
      () async {
        final start = DateTime.utc(today.year, today.month - 1);
        await Goal.db.insertRow(
          db,
          Goal(
            groupId: groupA,
            categoryId: cats['food']!.id!,
            amountCents: 20000,
            createdAt: start.subtract(const Duration(days: 3)),
          ),
        );
        await operation(account, start.add(const Duration(days: 4)), 19000);
        // Not at each look at the home page.
        expect(await fresh(alice), isEmpty);
        final s = await endpoints.pepite.completeRitual(as(alice), today);
        expect(s.newBadges, containsAll(['goal_kept', 'first_ritual']));
        // Mallory's ritual reads only her own groups.
        final m = await endpoints.pepite.completeRitual(as(mallory), today);
        expect(m.newBadges, ['first_ritual']);
      },
    );

    test('a goal exceeded, or set during the month, earns nothing', () async {
      final start = DateTime.utc(today.year, today.month - 1);
      final food = cats['food']!.id!;
      await Goal.db.insertRow(
        db,
        Goal(
          groupId: groupA,
          categoryId: food,
          amountCents: 20000,
          createdAt: start.subtract(const Duration(days: 3)),
        ),
      );
      await Goal.db.insertRow(
        db,
        Goal(
          groupId: groupA,
          categoryId: cats['shopping.clothing']!.id!,
          amountCents: 20000,
          createdAt: start.add(const Duration(days: 2)),
        ),
      );
      await operation(account, start.add(const Duration(days: 4)), 20001);
      final s = await endpoints.pepite.completeRitual(as(alice), today);
      expect(s.newBadges, isNot(contains('goal_kept')));
      // Half the month gone and at most half spent; else nothing yet.
      final days = DateTime.utc(today.year, today.month + 1, 0).day;
      expect(
        s.newBadges.contains('goal_half'),
        today.day * 2 >= days,
        reason: 'clothing has no spending, but was set during last month',
      );
    });

    test("« En équipe »: someone accepted the user's invitation", () async {
      Future<void> invite(UuidValue by, UuidValue? acceptedBy) async =>
          Invitation.db.insertRow(
            db,
            Invitation(
              groupId: groupA,
              email: 'invite@example.org',
              role: MemberRole.user,
              tokenHash: 'h${acceptedBy ?? 'none'}$by',
              expiresAt: today.add(const Duration(days: 7)),
              createdBy: by,
              acceptedBy: acceptedBy,
              acceptedAt: acceptedBy == null ? null : now,
            ),
          );
      await invite(alice, null);
      await invite(alice, alice);
      expect(await fresh(alice), isEmpty);
      await invite(alice, bob);
      expect(await fresh(alice), ['team']);
      // The badge of who invites, not of who joins.
      expect(await fresh(bob), isEmpty);
    });

    test("another's doings are never the user's", () async {
      final food = (await endpoints.category.list(
        as(mallory),
        groupB,
      )).firstWhere((c) => c.standardCode == 'food').id!;
      for (var i = 0; i < PepiteBadges.tidyRules; i++) {
        await rule(mallory, groupB, food, 'M $i');
      }
      await planned(mallory, other, subscription: true);
      await endpoints.goal.set(as(mallory), groupB, food, 100);
      expect(await fresh(alice), isEmpty);
      expect(
        await fresh(mallory),
        unorderedEquals(['tidy', 'seer', 'first_goal']),
      );
      // Mallory cannot set rules in Alice's group: refused, nothing changed.
      await expectLater(
        rule(mallory, groupA, cats['food']!.id!, 'X'),
        throwsA(isA<AccessDeniedException>()),
      );
      expect(await fresh(alice), isEmpty);
    });

    test('adopt keeps the new badges, clamped to known codes', () async {
      final ok = await endpoints.pepite.adopt(
        as(alice),
        PepiteStatus(
          seeds: 15,
          weeks: 0,
          doneThisWeek: false,
          badges: ['tidy', 'vault', 'made_up'],
          earnedSeeds: 0,
          newBadges: [],
          items: const [],
          equipped: const [],
        ),
      );
      expect(ok, isTrue);
      final s = await endpoints.pepite.status(as(alice), today);
      expect(s.badges, unorderedEquals(['tidy', 'vault']));
      expect(s.seeds, 15);
    });
  });
}
