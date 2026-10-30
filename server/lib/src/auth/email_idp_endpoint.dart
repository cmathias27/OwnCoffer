import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';
import '../security/ip_guard.dart';

/// Email sign-in. Registration is closed except for emails with a pending
/// invitation (or the first launch setup). Every failed attempt counts
/// towards the automatic IP ban.
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  Future<T> _guard<T>(
    Session session,
    String kind,
    Future<T> Function() call,
  ) async {
    try {
      return await call();
    } on SerializableException {
      await IpGuard.instance.recordFailure(session, kind);
      rethrow;
    }
  }

  @override
  Future<AuthSuccess> login(
    Session session, {
    required String email,
    required String password,
  }) => _guard(
    session,
    'login',
    () => super.login(
      session,
      email: Onboarding.normalizeEmail(email),
      password: password,
    ),
  );

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

  @override
  Future<String> verifyRegistrationCode(
    Session session, {
    required UuidValue accountRequestId,
    required String verificationCode,
  }) => _guard(
    session,
    'registration_code',
    () => super.verifyRegistrationCode(
      session,
      accountRequestId: accountRequestId,
      verificationCode: verificationCode,
    ),
  );

  @override
  Future<String> verifyPasswordResetCode(
    Session session, {
    required UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => _guard(
    session,
    'reset_code',
    () => super.verifyPasswordResetCode(
      session,
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode,
    ),
  );
}
