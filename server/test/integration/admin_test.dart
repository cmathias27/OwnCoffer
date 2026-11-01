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
        () => endpoints.admin.requestRestoreTest(as(mallory)),
        () => endpoints.admin.groups(as(mallory)),
        () => endpoints.admin.updates(as(mallory)),
        () => endpoints.admin.setAutoUpdate(as(mallory), false),
        () => endpoints.admin.requestUpdateCheck(as(mallory)),
        () => endpoints.admin.requestInstall(as(mallory), 'v9.0.0'),
        () => endpoints.admin.invitations(as(mallory)),
        () => endpoints.admin.invite(
          as(mallory),
          groupA,
          'eve@example.org',
          MemberRole.user,
        ),
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

    test(
      'invitations: any group, listed with who sent them, revoked',
      () async {
        // Another household the administrator is not a member of.
        final other = await FinanceGroup.db.insertRow(
          db,
          FinanceGroup(name: 'Voisins', createdBy: bob),
        );
        final i = await endpoints.admin.invite(
          as(admin),
          other.id!,
          'Eve@Example.org',
          MemberRole.admin,
        );
        expect(i.email, 'eve@example.org');
        expect(i.groupName, 'Voisins');
        expect(MailService.instance.outbox.last.to, 'eve@example.org');
        await endpoints.invitation.create(
          as(mallory),
          groupA,
          'zoe@example.org',
          MemberRole.reader,
        );
        final list = await endpoints.admin.invitations(as(admin));
        expect(list.map((x) => x.email), [
          'eve@example.org',
          'zoe@example.org',
        ]);
        expect(list.last.invitedBy, 'mallory@example.org');
        expect(list.last.groupName, 'Maison');

        final groups = await endpoints.admin.groups(as(admin));
        expect(groups.map((g) => g.name), ['Maison', 'Voisins']);
        expect(groups.first.members, 3);

        await expectLater(
          endpoints.admin.revokeInvitation(as(mallory), i.id),
          denied,
        );
        await endpoints.admin.revokeInvitation(as(admin), i.id);
        expect(
          (await endpoints.admin.invitations(as(admin))).map((x) => x.email),
          ['zoe@example.org'],
        );
        await expectLater(
          endpoints.admin.revokeInvitation(as(admin), i.id),
          throwsA(isA<InvalidInputException>()),
        );
        await expectLater(
          endpoints.admin.invite(
            as(admin),
            999999,
            'x@example.org',
            MemberRole.user,
          ),
          denied,
        );
      },
    );

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

      test('encrypted backups and the last restore test', () async {
        File('${dir.path}/backups.tsv').writeAsStringSync(
          'owncoffer-20261030-033000-daily.dump\t5000\t1793331000\n'
          'owncoffer-20261031-033000-daily.dump.gpg\t5100\t1793417400\n'
          'owncoffer-20261031-033000-daily.dump.gpg.part\t1\t1793417400\n',
        );
        var o = await endpoints.admin.backups(as(admin));
        expect(o.backups.map((b) => b.encrypted), [true, false]);
        expect(o.lastEncrypted, isTrue);
        expect(o.restoreTest, isNull);
        expect(o.restoreTestPending, isFalse);

        File('${dir.path}/restore-test').writeAsStringSync(
          'at=1793417500\nfile=owncoffer-20261031-033000-daily.dump.gpg\n'
          'ok=true\ntables=42\noperations=1234\nseconds=9\nmessage=\n',
        );
        await endpoints.admin.requestRestoreTest(as(admin));
        o = await endpoints.admin.backups(as(admin));
        final t = o.restoreTest!;
        expect(t.ok, isTrue);
        expect(t.at, DateTime.utc(2026, 10, 31, 3, 31, 40));
        expect(t.file, 'owncoffer-20261031-033000-daily.dump.gpg');
        expect((t.tables, t.operations, t.seconds), (42, 1234, 9));
        expect(t.message, isNull);
        expect(o.restoreTestPending, isTrue);
        expect(
          File('${dir.path}/request-restore-test').existsSync(),
          isTrue,
        );

        File('${dir.path}/restore-test').writeAsStringSync(
          'at=1793417500\nfile=x.dump.gpg\nok=false\ntables=\n'
          'message=the backup could not be restored\n',
        );
        final failed = (await endpoints.admin.backups(as(admin))).restoreTest!;
        expect(failed.ok, isFalse);
        expect(failed.tables, isNull);
        expect(failed.message, 'the backup could not be restored');
      });

      test('installation progress and free disk space, as the host wrote '
          'them; anything else ignored', () async {
        var o = await endpoints.admin.updates(as(admin));
        expect((o.progressTarget, o.progressStep), (null, null));
        var h = await endpoints.admin.health(as(admin));
        expect(h.diskTotalBytes, isNull);

        File('${dir.path}/update-progress').writeAsStringSync(
          'target=v0.4.0\nstep=backup\nat=1793448000\n',
        );
        File('${dir.path}/disk').writeAsStringSync(
          'total=100000000000\nfree=7000000000\nat=1793448000\n',
        );
        o = await endpoints.admin.updates(as(admin));
        expect(o.progressTarget, 'v0.4.0');
        expect(o.progressStep, 'backup');
        expect(o.progressAt, DateTime.utc(2026, 10, 31, 12));
        h = await endpoints.admin.health(as(admin));
        expect(h.diskTotalBytes, 100000000000);
        expect(h.diskFreeBytes, 7000000000);
        expect(h.diskAt, DateTime.utc(2026, 10, 31, 12));

        File('${dir.path}/update-progress').writeAsStringSync(
          'target=../etc\nstep=rm -rf\n',
        );
        File('${dir.path}/disk').writeAsStringSync('total=10\nfree=20\n');
        o = await endpoints.admin.updates(as(admin));
        expect((o.progressTarget, o.progressStep), (null, null));
        h = await endpoints.admin.health(as(admin));
        expect(h.diskFreeBytes, isNull, reason: 'free above total');
      });

      test('updates: state, notes, history, auto off, install', () async {
        File('${dir.path}/update-status').writeAsStringSync(
          'current=v0.3.9\nlatest=v0.4.0\nchecked=1793448000\nauto=true\n'
          'failed=v0.3.8\nmessage=automatic updates are off\n',
        );
        File('${dir.path}/update-history.tsv').writeAsStringSync(
          '1793440000\tv0.3.7\tv0.3.8\trollback\tdid not answer\n'
          '1793445000\tv0.3.8\tv0.3.9\tinstalled\t\n',
        );
        File('${dir.path}/CHANGELOG.md').writeAsStringSync(
          '# Nouveautés\n\nIntro.\n\n## 0.4.0 (1 novembre 2026)\n\n'
          '### Factures\n\n- Joindre une facture.\n\n'
          '## 0.3.9 (31 octobre 2026)\n\n- Invitations.\n',
        );
        final o = await endpoints.admin.updates(as(admin));
        expect(o.available, isTrue);
        expect(o.runningVersion, 'dev');
        expect((o.current, o.latest), ('v0.3.9', 'v0.4.0'));
        expect(o.auto, isTrue);
        expect(o.failedVersion, 'v0.3.8');
        expect(o.message, 'automatic updates are off');
        expect(o.history.map((h) => h.result), ['installed', 'rollback']);
        expect(o.history.last.message, 'did not answer');
        expect(o.releases.map((r) => r.version), ['0.4.0', '0.3.9']);
        expect(o.releases.first.body, contains('Joindre une facture'));
        expect(o.releases.first.date, '1 novembre 2026');

        await endpoints.admin.setAutoUpdate(as(admin), false);
        expect(
          File('${dir.path}/settings').readAsStringSync(),
          'auto=false\n',
        );
        expect((await endpoints.admin.updates(as(admin))).auto, isFalse);

        await endpoints.admin.requestUpdateCheck(as(admin));
        expect(File('${dir.path}/request-check').existsSync(), isTrue);
        expect(
          (await endpoints.admin.updates(as(admin))).requestPending,
          isTrue,
        );

        await endpoints.admin.requestInstall(as(admin), 'v0.4.0');
        expect(
          File('${dir.path}/request-update').readAsStringSync(),
          'v0.4.0\n',
        );
        for (final bad in ['v0.3.9', 'v0.3.1', '0.4.0', 'v0.4.0; rm -rf /']) {
          await expectLater(
            endpoints.admin.requestInstall(as(admin), bad),
            throwsA(isA<InvalidInputException>()),
            reason: bad,
          );
        }
        final log = await endpoints.admin.audit(as(admin));
        expect(log.first.action, 'request_install');
      });

      test('without the shared folder: said, and requests refused', () async {
        HostState.instance = HostState('${dir.path}/missing');
        final o = await endpoints.admin.backups(as(admin));
        expect(o.available, isFalse);
        await expectLater(
          endpoints.admin.requestBackup(as(admin)),
          throwsA(isA<InvalidInputException>()),
        );
        await expectLater(
          endpoints.admin.requestRestoreTest(as(admin)),
          throwsA(isA<InvalidInputException>()),
        );
        final u = await endpoints.admin.updates(as(admin));
        expect(u.available, isFalse);
        expect(u.auto, isTrue);
        await expectLater(
          endpoints.admin.setAutoUpdate(as(admin), false),
          throwsA(isA<InvalidInputException>()),
        );
        await expectLater(
          endpoints.admin.requestUpdateCheck(as(admin)),
          throwsA(isA<InvalidInputException>()),
        );
      });
    });

    test('remarks: sent by anyone, read and closed by the server '
        'administrator only', () async {
      final f = await endpoints.feedback.send(
        as(bob),
        'idea',
        '  Un mode sombre plus contrasté  ',
        'budget',
        '0.3.33',
      );
      expect(f.text, 'Un mode sombre plus contrasté');
      expect(f.status, 'open');
      expect(f.appVersion, 'dev', reason: "the server's own");
      await expectLater(
        endpoints.feedback.send(as(bob), 'spam', 'x', null, null),
        throwsA(isA<InvalidInputException>()),
      );
      expect(await endpoints.feedback.mine(as(bob)), hasLength(1));
      expect(await endpoints.feedback.mine(as(mallory)), isEmpty);
      await expectLater(
        endpoints.feedback.all(as(bob)),
        throwsA(isA<AccessDeniedException>()),
      );
      await expectLater(
        endpoints.feedback.setDone(as(bob), f.id!, true),
        throwsA(isA<AccessDeniedException>()),
      );
      final all = await endpoints.feedback.all(as(admin));
      expect(all.single.feedback.id, f.id);
      expect(all.single.email, 'bob@example.org');
      expect(
        (await endpoints.feedback.setDone(as(admin), f.id!, true)).status,
        'done',
      );
    });
  });
}
