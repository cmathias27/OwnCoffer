import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/ip_guard.dart';

/// The app's automatic lock (decision 0025): the session stays open on the
/// device, the screen is unlocked again with the account's password.
class AppLockEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Whether [password] is the signed-in user's own password. No new
  /// session is issued: the device keeps the one it has (with its
  /// two-factor access). A wrong password counts, like a failed sign-in,
  /// towards the account's attempt limit and the automatic IP ban.
  Future<bool> verifyPassword(Session session, String password) async {
    final user = Access.userId(session);
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (a) => a.authUserId.equals(user),
    );
    // Standalone mode: no password, the device's own lock is used instead.
    if (account == null) return false;
    try {
      final owner = await AuthServices.instance.emailIdp.utils.authentication
          .authenticate(
            session,
            email: account.email,
            password: password,
            transaction: null,
          );
      return owner == user;
    } on EmailAuthenticationTooManyAttemptsException {
      await IpGuard.instance.recordFailure(session, 'unlock');
      throw AccessDeniedException(code: 'unlock_too_many_attempts');
    } on EmailLoginServerException {
      await IpGuard.instance.recordFailure(session, 'unlock');
      return false;
    }
  }
}
