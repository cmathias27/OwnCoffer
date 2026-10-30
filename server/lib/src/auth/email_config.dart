import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../i18n/messages.dart';
import '../mail/mail_service.dart';
import '../onboarding/onboarding.dart';

/// Email/password sign-in: codes sent by [MailService] (SMTP from .env, or
/// the server log), invitations applied as soon as the account exists.
EmailIdpConfigFromPasswords buildEmailIdpConfig() =>
    EmailIdpConfigFromPasswords(
      sendRegistrationVerificationCode: _sendRegistrationCode,
      sendPasswordResetVerificationCode: _sendPasswordResetCode,
      onAfterAccountCreated: _afterAccountCreated,
    );

Future<void> _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) async {
  final mail = Messages.bilingual('registration', {'code': verificationCode});
  await MailService.instance.send(
    session,
    to: email,
    subject: mail.subject,
    body: mail.body,
  );
}

Future<void> _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) async {
  final mail = Messages.bilingual('reset', {'code': verificationCode});
  await MailService.instance.send(
    session,
    to: email,
    subject: mail.subject,
    body: mail.body,
  );
}

Future<void> _afterAccountCreated(
  Session session, {
  required String email,
  required UuidValue authUserId,
  required UuidValue emailAccountId,
  required Transaction? transaction,
}) => Onboarding.applyInvitations(
  session,
  email: email,
  userId: authUserId,
  transaction: transaction,
);
