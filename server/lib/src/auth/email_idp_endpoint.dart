import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';

/// Email sign-in. Registration is closed except for emails with a pending
/// invitation (or the first launch setup).
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  @override
  Future<UuidValue> startRegistration(
    Session session, {
    required String email,
  }) async {
    if (!await Onboarding.mayRegister(session, email)) {
      throw InvalidInputException(code: 'registration_closed', field: 'email');
    }
    return super.startRegistration(
      session,
      email: Onboarding.normalizeEmail(email),
    );
  }
}
