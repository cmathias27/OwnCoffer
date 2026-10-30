import 'package:owncoffer_server/src/finance/alert_service.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/mail/mail_service.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' show LocalDate;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Overdraft alert', (sessionBuilder, endpoints) {
    late Session db;
    late MailService mail;
    late UuidValue alice, bob, outsider;
    late int groupA;
    late Account account;
    final now = DateTime.now().toUtc();
    final todayUtc = DateTime.utc(now.year, now.month, now.day);
    final today = LocalDate(now.year, now.month, now.day);

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user(String email, Set<String> scopes) async {
      final id = (await AuthUser.db.insertRow(
        db,
        AuthUser(createdAt: DateTime.now(), scopeNames: scopes, blocked: false),
      )).id!;
      await UserProfile.db.insertRow(
        db,
        UserProfile(authUserId: id, email: email),
      );
      return id;
    }

    setUp(() async {
      db = sessionBuilder.build();
      mail = MailService.fromEnvironment(const {});
      MailService.instance = mail;
      alice = await user('alice@example.org', {'owncoffer.serverAdmin'});
      bob = await user('bob@example.org', {});
      outsider = await user('eve@example.org', {'owncoffer.serverAdmin'});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      await endpoints.group.create(as(outsider), 'B');
      await GroupMember.db.insertRow(
        db,
        GroupMember(groupId: groupA, authUserId: bob, role: MemberRole.user),
      );
      account = await endpoints.account.create(
        as(alice),
        groupA,
        'Courant',
        AccountKind.checking,
        initialBalanceCents: 30000,
      );
    });

    Future<void> planRent() => endpoints.scheduled.create(
      as(alice),
      account.id!,
      -65000,
      'Loyer',
      ScheduleFrequency.once,
      todayUtc.add(const Duration(days: 4)),
    );

    test('no alert while the forecast stays above the threshold', () async {
      expect(await AlertService.checkAccount(db, account, today), 0);
      expect(await AppNotification.db.count(db), 0);
    });

    test('one notification and one email per member, only once', () async {
      await planRent();
      expect(await AlertService.checkAccount(db, account, today), 2);
      expect(mail.outbox.map((m) => m.to).toSet(), {
        'alice@example.org',
        'bob@example.org',
      });
      final body = mail.outbox.first.body;
      expect(body, contains('Courant'));
      expect(body, contains('-350,00 EUR'));
      expect(body, contains('${today.addDays(4)}'));

      // Recomputed every hour: no repeat for the same date.
      expect(await AlertService.checkAccount(db, account, today), 0);
      expect(mail.outbox, hasLength(2));

      final mine = await endpoints.notification.list(as(bob));
      expect(mine.single.type, AlertService.overdraftType);
      expect(mine.single.data, contains('"balanceCents":-35000'));
      expect(await endpoints.notification.unreadCount(as(bob)), 1);
      await endpoints.notification.markRead(as(bob), mine.single.id!);
      expect(await endpoints.notification.unreadCount(as(bob)), 0);
    });

    test('restricted account: only admins and users given access', () async {
      await endpoints.account.update(
        as(alice),
        account.id!,
        visibility: AccountVisibility.restricted,
      );
      account = (await Account.db.findById(db, account.id!))!;
      await planRent();
      await AlertService.checkAccount(db, account, today);
      expect(mail.outbox.map((m) => m.to), ['alice@example.org']);
    });

    test('authorised overdraft: alert only below the threshold', () async {
      await endpoints.account.update(
        as(alice),
        account.id!,
        alertThresholdCents: -50000,
      );
      account = (await Account.db.findById(db, account.id!))!;
      await planRent();
      expect(await AlertService.checkAccount(db, account, today), 0);
    });

    test('nobody reads or marks another user\'s notifications', () async {
      await planRent();
      await AlertService.checkAccount(db, account, today);
      final bobs = await endpoints.notification.list(as(bob));
      expect(await endpoints.notification.list(as(outsider)), isEmpty);
      await expectLater(
        endpoints.notification.markRead(as(outsider), bobs.single.id!),
        throwsA(isA<AccessDeniedException>()),
      );
      await endpoints.notification.markAllRead(as(outsider));
      expect(await endpoints.notification.unreadCount(as(bob)), 1);
    });
  });
}
