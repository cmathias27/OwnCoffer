import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../screens/account_flow.dart';
import 'sessions_list.dart';

/// « Nouvel appareil » or « pays inhabituel » (decision 0027, point 7): the
/// session told about, where it was seen, and whether its IP was banned.
class SessionAlert {
  final String session;
  final String? platform;
  final String? city;
  final String? country;
  final String? ip;
  final bool unusualCountry;
  final bool banned;

  const SessionAlert({
    required this.session,
    this.platform,
    this.city,
    this.country,
    this.ip,
    this.unusualCountry = false,
    this.banned = false,
  });

  static const type = 'session_alert';

  /// The alert in [n], or null when it is not one (or is damaged).
  static SessionAlert? of(AppNotification n) {
    if (n.type != type) return null;
    try {
      final d = jsonDecode(n.data) as Map<String, dynamic>;
      return SessionAlert(
        session: d['session'] as String,
        platform: d['platform'] as String?,
        city: d['city'] as String?,
        country: d['country'] as String?,
        ip: d['ip'] as String?,
        unusualCountry: d['unusualCountry'] == true,
        banned: d['banned'] == true,
      );
    } on Object {
      return null;
    }
  }

  String title(AppLocalizations l) => unusualCountry && country != null
      ? l.notifSessionCountryTitle(country!)
      : l.notifSessionDeviceTitle(sessionPlatformName(l, platform));

  /// `Application Android, environ Rouen, FR (82.64.1.1).`
  String body(AppLocalizations l) {
    final place = [?city, ?country].join(', ');
    return [
      l.notifSessionAlertBody(
        sessionPlatformName(l, platform),
        place.isEmpty ? l.sessionsPlaceUnknown : l.sessionsPlaceAbout(place),
        ip ?? '?',
      ),
      if (banned) l.notifSessionBanned,
    ].join(' ');
  }
}

/// « C'est vous ? »: **Oui** does nothing more; **Non, déconnecter** closes
/// that session with [close], then offers to change the password (which
/// closes every session, this one too).
Future<void> showSessionAlert(
  BuildContext context,
  SessionAlert alert, {
  required Future<void> Function(String sessionId) close,
}) async {
  final l = AppLocalizations.of(context);
  final mine = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        alert.unusualCountry ? Icons.gpp_maybe : Icons.devices_other,
        color: alert.unusualCountry || alert.banned
            ? Theme.of(context).colorScheme.error
            : null,
      ),
      title: Text(l.sessionAlertTitle),
      content: Text('${alert.title(l)}\n\n${alert.body(l)}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.sessionAlertNo),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.sessionAlertYes),
        ),
      ],
    ),
  );
  if (mine != false || !context.mounted) return;
  var gone = false;
  try {
    await close(alert.session);
  } on InvalidInputException catch (e) {
    if (e.code != 'session_not_found') rethrow;
    gone = true;
  } on Object catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return;
  }
  if (!context.mounted) return;
  final change = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(gone ? l.sessionAlertGone : l.sessionAlertClosed),
      content: Text(l.sessionAlertPasswordHelp),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.sessionAlertLater),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.sessionAlertChangePassword),
        ),
      ],
    ),
  );
  if (change != true || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (page) => Scaffold(
        appBar: AppBar(title: Text(l.resetTitle)),
        body: SafeArea(
          child: AccountFlow(
            mode: AccountFlowMode.reset,
            onCancel: () => Navigator.pop(page),
            onDone: (_) async {
              ScaffoldMessenger.of(
                page,
              ).showSnackBar(SnackBar(content: Text(l.resetDone)));
              Navigator.pop(page);
            },
          ),
        ),
      ),
    ),
  );
}
