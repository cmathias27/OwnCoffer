import 'dart:io';

import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

/// Sends emails through the SMTP server configured in docker/.env.
///
/// Without SMTP configuration, emails are written to the server log instead,
/// so the administrator can read codes with `docker compose logs owncoffer`.
/// Nothing is ever sent to a third-party service by default.
class MailService {
  final SmtpServer? _smtp;
  final String _from;

  /// Emails "sent" when SMTP is not configured; read by tests.
  final List<({String to, String subject, String body})> outbox = [];

  MailService._(this._smtp, this._from);

  static MailService? _instance;
  static MailService get instance =>
      _instance ??= MailService.fromEnvironment(Platform.environment);

  /// For tests.
  static set instance(MailService service) => _instance = service;

  factory MailService.fromEnvironment(Map<String, String> env) {
    final host = env['OWNCOFFER_SMTP_HOST'] ?? '';
    final from = env['OWNCOFFER_SMTP_FROM'] ?? 'owncoffer@localhost';
    if (host.isEmpty) return MailService._(null, from);
    final security = (env['OWNCOFFER_SMTP_SECURITY'] ?? 'starttls')
        .toLowerCase();
    final port =
        int.tryParse(env['OWNCOFFER_SMTP_PORT'] ?? '') ??
        (security == 'ssl' ? 465 : 587);
    final user = env['OWNCOFFER_SMTP_USER'];
    return MailService._(
      SmtpServer(
        host,
        port: port,
        ssl: security == 'ssl',
        allowInsecure: security == 'none',
        username: (user == null || user.isEmpty) ? null : user,
        password: env['OWNCOFFER_SMTP_PASSWORD'],
      ),
      from,
    );
  }

  bool get isConfigured => _smtp != null;

  Future<void> send(
    Session session, {
    required String to,
    required String subject,
    required String body,
  }) async {
    final smtp = _smtp;
    if (smtp == null) {
      outbox.add((to: to, subject: subject, body: body));
      session.log(
        '[mail] SMTP not configured — email to $to\n'
        'Subject: $subject\n$body',
        level: LogLevel.warning,
      );
      return;
    }
    final message = mailer.Message()
      ..from = mailer.Address(_from, 'OwnCoffer')
      ..recipients.add(to)
      ..subject = subject
      ..text = body;
    try {
      await mailer.send(message, smtp);
    } on Object catch (e) {
      // Never log the body: it holds codes and links.
      session.log(
        '[mail] sending to $to failed: ${e.runtimeType}',
        level: LogLevel.error,
      );
      rethrow;
    }
  }
}
