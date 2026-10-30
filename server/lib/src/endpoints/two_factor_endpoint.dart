import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/ip_guard.dart';
import '../security/scopes.dart';
import '../security/two_factor.dart';

/// Two-factor authentication. Needs a signed-in user, but not [accessScope]:
/// [verify] is how a password-only session gets full access.
class TwoFactorEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  bool _fullAccess(Session session) =>
      session.authenticated?.scopes.contains(accessScope) ?? false;

  void _requireFullAccess(Session session) {
    if (!_fullAccess(session)) {
      throw AccessDeniedException(code: 'two_factor_required');
    }
  }

  Future<TwoFactorStatus> status(Session session) async {
    final user = Access.userId(session);
    return TwoFactorStatus(
      enabled: await TwoFactor.isEnabled(session, user),
      backupCodesLeft: await TwoFactor.backupCodesLeft(session, user),
      fullAccess: _fullAccess(session),
    );
  }

  /// Step 1: secret and QR code URI for the authenticator app.
  Future<TotpEnrollment> begin(Session session) async {
    _requireFullAccess(session);
    final user = Access.userId(session);
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(user),
    );
    return TwoFactor.begin(session, user, profile?.email ?? user.toString());
  }

  /// Step 2: first code from the app. Returns the 10 backup codes, shown
  /// only once.
  Future<List<String>> confirm(Session session, String code) async {
    _requireFullAccess(session);
    final codes = await TwoFactor.confirm(
      session,
      Access.userId(session),
      code,
    );
    if (codes.isEmpty) {
      await IpGuard.instance.recordFailure(session, 'totp');
      throw InvalidInputException(
        code: 'two_factor_code_invalid',
        field: 'code',
      );
    }
    await _audit(session, 'two_factor_enabled');
    return codes;
  }

  /// After the password sign-in: exchanges the partial session for a full
  /// one when [code] (TOTP or backup code) is valid.
  Future<AuthSuccess> verify(Session session, String code) async {
    final user = Access.userId(session);
    if (!await TwoFactor.check(session, user, code)) {
      await IpGuard.instance.recordFailure(session, 'totp');
      throw InvalidInputException(
        code: 'two_factor_code_invalid',
        field: 'code',
      );
    }
    final account = (await AuthUser.db.findById(session, user))!;
    final success = await AuthServices.instance.tokenManager.issueToken(
      session,
      authUserId: user,
      method: 'email+totp',
      scopes: {
        for (final name in account.scopeNames) Scope(name),
        accessScope,
      },
    );
    final partial = session.authenticated?.authId;
    if (partial != null) {
      await AuthServices.instance.tokenManager.revokeToken(
        session,
        tokenId: partial,
      );
    }
    return success;
  }

  /// New backup codes (the old ones stop working).
  Future<List<String>> renewBackupCodes(Session session, String code) async {
    _requireFullAccess(session);
    final user = Access.userId(session);
    if (!await TwoFactor.check(session, user, code, allowBackup: false)) {
      await IpGuard.instance.recordFailure(session, 'totp');
      throw InvalidInputException(
        code: 'two_factor_code_invalid',
        field: 'code',
      );
    }
    await _audit(session, 'two_factor_backup_renewed');
    return TwoFactor.newBackupCodes(session, user);
  }

  Future<void> disable(Session session, String code) async {
    _requireFullAccess(session);
    final user = Access.userId(session);
    if (!await TwoFactor.check(session, user, code)) {
      await IpGuard.instance.recordFailure(session, 'totp');
      throw InvalidInputException(
        code: 'two_factor_code_invalid',
        field: 'code',
      );
    }
    await TwoFactor.disable(session, user);
    await _audit(session, 'two_factor_disabled');
  }

  Future<void> _audit(Session session, String action) =>
      AuditEntry.db.insertRow(
        session,
        AuditEntry(
          authUserId: Access.userId(session),
          action: action,
          entity: 'two_factor',
        ),
      );
}
