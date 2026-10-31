import 'dart:io';

import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/host/host_state.dart';
import 'package:owncoffer_server/src/mail/mail_service.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Server administration', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue admin, bob, mallory;
    late int groupA;
    final denied = throwsA(isA<AccessDeniedException>());

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user(Set<String> scopes, String email) async {
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
      MailService.instance = MailService.fromEnvironment(const {});
      admin = await user({'owncoffer.serverAdmin'}, 'admin@example.org');
      bob = await user({}, 'bob@example.org');
      // Administrator of his own group, not of the server.
      mallory = await user({}, 'mallory@example.org');
      groupA = (await endpoints.group.create(as(admin), 'Maison')).group.id!;
      await GroupMember.db.insertRow(
        db,
        GroupMember(groupId: groupA, authUserId: bob, role: MemberRole.user),
      );
      await GroupMember.db.insertRow(
        db,
        GroupMember(
          groupId: groupA,
          authUserId: mallory,
          role: MemberRole.admin,
        ),
      );
    });

    test('only the server administrator, for every function', () async {
      expect(await endpoints.admin.isServerAdmin(as(admin)), isTrue);
      expect(await endpoints.admin.isServerAdmin(as(mallory)), isFalse);
      for (final call in <Future<Object?> Function()>[
        () => endpoints.admin.users(as(mallory)),
        () => endpoints.admin.health(as(mallory)),
        () => endpoints.admin.stats(as(mallory)),
        () => endpoints.admin.audit(as(mallory)),
        () => endpoints.admin.sendTestEmail(as(mallory)),
        () => endpoints.admin.setBlocked(as(mallory), bob, true),
        () => endpoints.admin.backups(as(mallory)),
        () => endpoints.admin.requestBackup(as(mallory)),
      ]) {
        await expectLater(call(), denied);
      }
      expect((await AuthUser.db.findById(db, bob))!.blocked, isFalse);
    });

    test('accounts: email, groups and roles, block and unblock', () async {
      final users = await endpoints.admin.users(as(admin));
      expect(users.map((u) => u.email), [
        'admin@example.org',
        'bob@example.org',
        'mallory@example.org',
      ]);
      final b = users[1];
      expect(b.groupNames, ['Maison']);
      expect(b.roles, [MemberRole.user]);
      expect(b.serverAdmin, isFalse);
      expect(users.first.serverAdmin, isTrue);

      await endpoints.admin.setBlocked(as(admin), bob, true);
      expect((await AuthUser.db.findById(db, bob))!.blocked, isTrue);
      await endpoints.admin.setBlocked(as(admin), bob, false);
      expect((await AuthUser.db.findById(db, bob))!.blocked, isFalse);
      await expectLater(
        endpoints.admin.setBlocked(as(admin), admin, true),
        throwsA(isA<InvalidInputException>()),
      );
      final log = await endpoints.admin.audit(as(admin));
      expect(log.take(2).map((a) => a.action), ['unblock_user', 'block_user']);
      expect(log.first.email, 'admin@example.org');
    });

    test('health and figures, counts only', () async {
      final account = await endpoints.account.create(
        as(admin),
        groupA,
        'Courant',
        AccountKind.checking,
      );
      await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: account.id!,
          date: DateTime.utc(2026, 10, 1),
          amountCents: -1000,
          rawLabel: 'CB X',
          cleanLabel: 'X',
          operationKind: 'card',
        ),
      );
      final h = await endpoints.admin.health(as(admin));
      expect(h.databaseOk, isTrue);
      expect(h.databaseBytes, greaterThan(0));
      expect(h.version, 'dev');
      expect(h.smtpConfigured, isFalse);
      final s = await endpoints.admin.stats(as(admin));
      expect(s.users, 3);
      expect(s.groups, 1);
      expect(s.accounts, 1);
      expect(s.operations, 1);
      expect(s.operationsLast30Days, 1);
    });

    test('test email goes to the administrator', () async {
      final to = await endpoints.admin.sendTestEmail(as(admin));
      expect(to, 'admin@example.org');
      expect(MailService.instance.outbox.single.to, 'admin@example.org');
    });

    group('backups (docker/state)', () {
      late Directory dir;
      setUp(() {
        dir = Directory.systemTemp.createTempSync('owncoffer-state-');
        HostState.instance = HostState(dir.path);
      });
      tearDown(() => dir.deleteSync(recursive: true));

      test('listed newest first, last result, nightly, request', () async {
        File('${dir.path}/backups.tsv').writeAsStringSync(
          'owncoffer-20261030-033000-daily.dump\t5000\t1793331000\n'
          'owncoffer-20261031-120000-manual.dump\t6000\t1793448000\n'
          'not-a-backup.txt\t1\t1\n',
        );
        File('${dir.path}/backup-last').writeAsStringSync(
          'at=1793448000\nlabel=manual\nok=true\nmessage=\n',
        );
        final o = await endpoints.admin.backups(as(admin));
        expect(o.available, isTrue);
        expect(o.backups.map((b) => b.label), ['manual', 'daily']);
        expect(o.backups.first.bytes, 6000);
        expect(o.lastOk, isTrue);
        expect(o.lastMessage, isNull);
        expect(o.lastDailyAt, DateTime.utc(2026, 10, 30, 3, 30));
        expect(o.requestPending, isFalse);

        await endpoints.admin.requestBackup(as(admin));
        expect(File('${dir.path}/request-backup').existsSync(), isTrue);
        expect(
          (await endpoints.admin.backups(as(admin))).requestPending,
          isTrue,
        );
      });

      test('without the shared folder: said, and requests refused', () async {
        HostState.instance = HostState('${dir.path}/missing');
        final o = await endpoints.admin.backups(as(admin));
        expect(o.available, isFalse);
        await expectLater(
          endpoints.admin.requestBackup(as(admin)),
          throwsA(isA<InvalidInputException>()),
        );
      });
    });
  });
}
