import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_server/src/mail/mail_service.dart';
import 'package:owncoffer_server/src/onboarding/onboarding.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Onboarding', (sessionBuilder, endpoints) {
    late Session db;
    late MailService mail;

    TestSessionBuilder as(UuidValue user) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        user.toString(),
        {accessScope},
      ),
    );

    /// What the email sign-in does once the code is verified.
    Future<UuidValue> register(String email) async {
      final user = await AuthUser.db.insertRow(
        db,
        AuthUser(createdAt: DateTime.now(), scopeNames: {}, blocked: false),
      );
      await UserProfile.db.insertRow(
        db,
        UserProfile(authUserId: user.id!, email: email),
      );
      await Onboarding.applyInvitations(db, email: email, userId: user.id!);
      return user.id!;
    }

    String tokenFromMail() {
      final body = mail.outbox.last.body;
      return RegExp(r'invitation=([A-Za-z0-9_-]+)').firstMatch(body)![1]!;
    }

    setUp(() async {
      db = sessionBuilder.build();
      mail = MailService.fromEnvironment(const {});
      MailService.instance = mail;
    });

    test('first launch: setup code, then admin, then first group', () async {
      expect((await endpoints.setup.status(sessionBuilder)).needsSetup, isTrue);
      // No published build in tests: the apps compare with "dev".
      expect(
        (await endpoints.setup.status(sessionBuilder)).serverVersion,
        'dev',
      );
      expect(await Onboarding.mayRegister(db, 'admin@example.org'), isFalse);

      await Onboarding.announceSetupIfNeeded(db);
      final code = Onboarding.setupCodeForTests!;
      await expectLater(
        endpoints.setup.start(sessionBuilder, '00000000', 'admin@example.org'),
        throwsA(isA<InvalidInputException>()),
      );
      await endpoints.setup.start(sessionBuilder, code, ' Admin@Example.org ');
      expect(await Onboarding.mayRegister(db, 'admin@example.org'), isTrue);
      expect(await Onboarding.mayRegister(db, 'other@example.org'), isFalse);

      final admin = await register('admin@example.org');
      expect(await Onboarding.isServerAdmin(db, admin), isTrue);
      expect(
        (await endpoints.setup.status(sessionBuilder)).needsSetup,
        isFalse,
      );
      await expectLater(
        endpoints.setup.start(sessionBuilder, code, 'late@example.org'),
        throwsA(isA<InvalidInputException>()),
      );

      final g = await endpoints.group.create(as(admin), 'Notre foyer');
      expect(g.role, MemberRole.admin);
      expect(
        (await endpoints.group.myGroups(as(admin))).single.group.name,
        'Notre foyer',
      );
    });

    group('with a group', () {
      late UuidValue admin;
      late int groupId;

      setUp(() async {
        await Onboarding.announceSetupIfNeeded(db);
        await endpoints.setup.start(
          sessionBuilder,
          Onboarding.setupCodeForTests!,
          'admin@example.org',
        );
        admin = await register('admin@example.org');
        groupId = (await endpoints.group.create(as(admin), 'Foyer')).group.id!;
      });

      test('only the server admin creates groups', () async {
        final bob = await register('bob@example.org');
        await expectLater(
          endpoints.group.create(as(bob), 'Mine'),
          throwsA(isA<AccessDeniedException>()),
        );
      });

      test('an invited email may register and joins with its role', () async {
        await endpoints.invitation.create(
          as(admin),
          groupId,
          'Bob@Example.org',
          MemberRole.user,
        );
        expect(mail.outbox.last.to, 'bob@example.org');
        expect(mail.outbox.last.body, contains('Foyer'));
        expect(await Onboarding.mayRegister(db, 'bob@example.org'), isTrue);

        final bob = await register('bob@example.org');
        final groups = await endpoints.group.myGroups(as(bob));
        expect(groups.single.role, MemberRole.user);
        final members = await endpoints.group.members(as(bob), groupId);
        expect(
          {for (final m in members) m.email: m.role},
          {
            'admin@example.org': MemberRole.admin,
            'bob@example.org': MemberRole.user,
          },
        );
        // Used: the email cannot register a second time with it.
        expect(await Onboarding.mayRegister(db, 'bob@example.org'), isFalse);
        expect(await Onboarding.isServerAdmin(db, bob), isFalse);
      });

      test('existing account accepts with the link token', () async {
        final carol = await register('carol@example.org');
        await endpoints.invitation.create(
          as(admin),
          groupId,
          'carol@example.org',
          MemberRole.reader,
        );
        final token = tokenFromMail();
        final m = await endpoints.invitation.accept(as(carol), token);
        expect(m.role, MemberRole.reader);
        await expectLater(
          endpoints.invitation.accept(as(carol), token),
          throwsA(isA<InvalidInputException>()),
        );
      });

      test('a link cannot be used by another account', () async {
        final eve = await register('eve@example.org');
        await endpoints.invitation.create(
          as(admin),
          groupId,
          'dave@example.org',
          MemberRole.admin,
        );
        await expectLater(
          endpoints.invitation.accept(as(eve), tokenFromMail()),
          throwsA(isA<InvalidInputException>()),
        );
        await expectLater(
          endpoints.group.members(as(eve), groupId),
          throwsA(isA<AccessDeniedException>()),
        );
      });

      test('revoked or expired invitations do not open registration', () async {
        final inv = await endpoints.invitation.create(
          as(admin),
          groupId,
          'frank@example.org',
          MemberRole.user,
        );
        await endpoints.invitation.revoke(as(admin), inv.id);
        expect(await Onboarding.mayRegister(db, 'frank@example.org'), isFalse);

        await endpoints.invitation.create(
          as(admin),
          groupId,
          'gina@example.org',
          MemberRole.user,
        );
        final row = (await Invitation.db.find(
          db,
          where: (i) => i.email.equals('gina@example.org'),
        )).single;
        await Invitation.db.updateRow(
          db,
          row.copyWith(
            expiresAt: DateTime.now().toUtc().subtract(
              const Duration(minutes: 1),
            ),
          ),
        );
        expect(await Onboarding.mayRegister(db, 'gina@example.org'), isFalse);
      });

      test('only group admins invite, list and revoke', () async {
        await endpoints.invitation.create(
          as(admin),
          groupId,
          'henri@example.org',
          MemberRole.user,
        );
        final henri = await register('henri@example.org');
        await expectLater(
          endpoints.invitation.create(
            as(henri),
            groupId,
            'x@example.org',
            MemberRole.admin,
          ),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.invitation.list(as(henri), groupId),
          throwsA(isA<AccessDeniedException>()),
        );
      });

      test('the token is never stored in clear', () async {
        await endpoints.invitation.create(
          as(admin),
          groupId,
          'ivy@example.org',
          MemberRole.user,
        );
        final token = tokenFromMail();
        final rows = await Invitation.db.find(db);
        expect(rows.any((r) => r.tokenHash == token), isFalse);
        expect(
          rows.any((r) => r.tokenHash == Onboarding.hashToken(token)),
          isTrue,
        );
      });

      test('invalid emails are refused', () async {
        await expectLater(
          endpoints.invitation.create(
            as(admin),
            groupId,
            'not-an-email',
            MemberRole.user,
          ),
          throwsA(isA<InvalidInputException>()),
        );
      });
    });
  });
}
