import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../i18n/messages.dart';
import '../mail/mail_service.dart';

/// Scope given to the server administrator (the first account).
const serverAdminScope = 'owncoffer.serverAdmin';

const invitationLifetime = Duration(days: 7);
const _setupLifetime = Duration(hours: 1);

/// First launch and invitations. Registration is closed to anyone without a
/// pending invitation; the very first account is invited through a one-time
/// setup code printed in the server log, so a freshly installed server
/// exposed on the Internet cannot be claimed by a stranger.
abstract final class Onboarding {
  static String? _setupCode;
  static int _setupFailures = 0;

  static String normalizeEmail(String email) => email.trim().toLowerCase();

  static String _token([int bytes = 24]) {
    final r = Random.secure();
    return base64UrlEncode(
      List<int>.generate(bytes, (_) => r.nextInt(256)),
    ).replaceAll('=', '');
  }

  static String hashToken(String token) =>
      sha256.convert(utf8.encode(token)).toString();

  static Future<bool> needsSetup(Session session) async =>
      await AuthUser.db.count(session) == 0;

  /// Called at start-up: prints a setup code while no account exists.
  static Future<void> announceSetupIfNeeded(Session session) async {
    if (!await needsSetup(session)) return;
    _newSetupCode(session);
  }

  static void _newSetupCode(Session session) {
    final r = Random.secure();
    _setupCode = List.generate(8, (_) => r.nextInt(10)).join();
    _setupFailures = 0;
    session.log(
      '=== OwnCoffer first launch — setup code: $_setupCode ===',
      level: LogLevel.warning,
    );
  }

  /// For tests.
  static String? get setupCodeForTests => _setupCode;

  /// Checks the setup code and invites [email] as server administrator.
  static Future<void> startSetup(
    Session session,
    String code,
    String email,
  ) async {
    if (!await needsSetup(session)) {
      throw InvalidInputException(code: 'setup_done');
    }
    final expected = _setupCode;
    if (expected == null || !_constantTimeEquals(code.trim(), expected)) {
      _setupFailures++;
      if (_setupFailures >= 5) _newSetupCode(session);
      throw InvalidInputException(code: 'setup_code_invalid', field: 'code');
    }
    final normalized = _checkEmail(email);
    await Invitation.db.insertRow(
      session,
      Invitation(
        email: normalized,
        role: MemberRole.admin,
        serverAdmin: true,
        tokenHash: hashToken(_token()),
        expiresAt: DateTime.now().toUtc().add(_setupLifetime),
      ),
    );
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String _checkEmail(String email) {
    final normalized = normalizeEmail(email);
    if (normalized.length > 254 || !_emailPattern.hasMatch(normalized)) {
      throw InvalidInputException(code: 'invalid_email', field: 'email');
    }
    return normalized;
  }

  static Expression _pending(InvitationTable i) =>
      i.acceptedAt.equals(null) &
      i.revokedAt.equals(null) &
      (i.expiresAt > DateTime.now().toUtc());

  /// Pending invitations for [email].
  static Future<List<Invitation>> pendingFor(
    Session session,
    String email, {
    Transaction? transaction,
  }) => Invitation.db.find(
    session,
    where: (i) => i.email.equals(normalizeEmail(email)) & _pending(i),
    transaction: transaction,
  );

  /// Whether [email] may create an account.
  static Future<bool> mayRegister(Session session, String email) async =>
      (await pendingFor(session, email)).isNotEmpty;

  /// Creates an invitation to [groupId] and emails its link.
  static Future<Invitation> invite(
    Session session, {
    required int groupId,
    required String email,
    required MemberRole role,
    required UuidValue invitedBy,
    required String publicUrl,
  }) async {
    final normalized = _checkEmail(email);
    final group = (await FinanceGroup.db.findById(session, groupId))!;
    final token = _token();
    final expires = DateTime.now().toUtc().add(invitationLifetime);
    final invitation = await Invitation.db.insertRow(
      session,
      Invitation(
        groupId: groupId,
        email: normalized,
        role: role,
        tokenHash: hashToken(token),
        expiresAt: expires,
        createdBy: invitedBy,
      ),
    );
    final base = publicUrl.endsWith('/') ? publicUrl : '$publicUrl/';
    final mail = Messages.bilingual('invitation', {
      'group': group.name,
      'expires': expires.toIso8601String().substring(0, 10),
      'link': '$base?invitation=$token',
    });
    await MailService.instance.send(
      session,
      to: normalized,
      subject: mail.subject,
      body: mail.body,
    );
    return invitation;
  }

  /// Applies every pending invitation of [email] to [userId]: group
  /// memberships, and the server administrator scope for the first account.
  static Future<void> applyInvitations(
    Session session, {
    required String email,
    required UuidValue userId,
    Transaction? transaction,
    int? onlyInvitationId,
  }) async {
    final invitations = await pendingFor(
      session,
      email,
      transaction: transaction,
    );
    for (final inv in invitations) {
      if (onlyInvitationId != null && inv.id != onlyInvitationId) continue;
      if (inv.serverAdmin) {
        final user = (await AuthUser.db.findById(
          session,
          userId,
          transaction: transaction,
        ))!;
        await AuthUser.db.updateRow(
          session,
          user.copyWith(scopeNames: {...user.scopeNames, serverAdminScope}),
          transaction: transaction,
        );
      }
      if (inv.groupId != null) {
        final existing = await GroupMember.db.findFirstRow(
          session,
          where: (m) =>
              m.groupId.equals(inv.groupId) & m.authUserId.equals(userId),
          transaction: transaction,
        );
        if (existing == null) {
          await GroupMember.db.insertRow(
            session,
            GroupMember(
              groupId: inv.groupId!,
              authUserId: userId,
              role: inv.role,
            ),
            transaction: transaction,
          );
        }
      }
      await Invitation.db.updateRow(
        session,
        inv.copyWith(acceptedAt: DateTime.now().toUtc(), acceptedBy: userId),
        transaction: transaction,
      );
      await AuditEntry.db.insertRow(
        session,
        AuditEntry(
          groupId: inv.groupId,
          authUserId: userId,
          action: inv.serverAdmin ? 'server_admin_created' : 'join_group',
          entity: 'invitation',
          rowId: '${inv.id}',
        ),
        transaction: transaction,
      );
    }
  }

  static Future<bool> isServerAdmin(Session session, UuidValue userId) async {
    final user = await AuthUser.db.findById(session, userId);
    return user != null && user.scopeNames.contains(serverAdminScope);
  }
}
