import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../onboarding/onboarding.dart';
import '../security/scopes.dart';

/// The one person of a standalone app (decision 0022): no password, no
/// e-mail, since the server only answers this device. Server administrator
/// of their own data, as the owner of a Docker server is.
abstract final class LocalOwner {
  /// Never a real address (.invalid is reserved): nothing is ever sent.
  static const email = 'moi@appareil.invalid';

  /// The owner's account, created on the first start.
  static Future<UuidValue> ensure(Session session) async {
    final existing = await AuthUser.db.findFirstRow(session);
    if (existing != null) return existing.id!;
    final user = await AuthUser.db.insertRow(
      session,
      AuthUser(
        createdAt: DateTime.now().toUtc(),
        scopeNames: {serverAdminScope, accessScope.name!},
        blocked: false,
      ),
    );
    await UserProfile.db.insertRow(
      session,
      UserProfile(authUserId: user.id!, email: email, fullName: 'Moi'),
    );
    return user.id!;
  }

  /// A session for the app on this device, with full access.
  static Future<AuthSuccess> signIn(Session session) async {
    final user = await ensure(session);
    return AuthServices.instance.tokenManager.issueToken(
      session,
      authUserId: user,
      method: 'standalone',
      scopes: {Scope(serverAdminScope), accessScope},
    );
  }
}
