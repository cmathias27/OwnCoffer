import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// The user's notifications. Texts are built here from the type and the
/// figures stored by the server, so they follow the user's language.
class NotificationsScreen extends StatefulWidget {
  /// Opens the forecast of an account (overdraft alerts).
  final void Function(int accountId) onOpenForecast;

  const NotificationsScreen({super.key, required this.onOpenForecast});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification>? _items;
  String? _error;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    try {
      final items = await client.notification.list();
      if (mounted) setState(() => (_items = items, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _markAll() async {
    try {
      await client.notification.markAllRead();
      await _reload();
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _open(AppNotification n) async {
    try {
      if (n.readAt == null) await client.notification.markRead(n.id!);
    } on Object {
      // Opening still works; the badge catches up at the next refresh.
    }
    if (!mounted) return;
    final accountId = n.accountId;
    if (n.type == 'overdraft_forecast' && accountId != null) {
      Navigator.pop(context);
      widget.onOpenForecast(accountId);
    } else {
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final items = _items;
    final unread = items?.where((n) => n.readAt == null).length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationsTitle),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: _markAll,
              child: Text(l.notificationsMarkAll),
            ),
        ],
      ),
      body: _error != null
          ? Center(child: Text(_error!))
          : items == null
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? Center(child: Text(l.notificationsEmpty))
          : RefreshIndicator(
              onRefresh: _reload,
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final n = items[i];
                  final (title, body) = _texts(context, n);
                  final isUnread = n.readAt == null;
                  return ListTile(
                    leading: Icon(
                      n.type == 'overdraft_forecast'
                          ? Icons.warning_amber
                          : Icons.notifications_none,
                      color: n.type == 'overdraft_forecast'
                          ? theme.colorScheme.error
                          : null,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: isUnread
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      [
                        ?body,
                        context.day(n.createdAt.toLocal()),
                      ].join('\n'),
                    ),
                    isThreeLine: body != null,
                    trailing: isUnread
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () => _open(n),
                  );
                },
              ),
            ),
    );
  }

  static (String, String?) _texts(BuildContext context, AppNotification n) {
    final l = AppLocalizations.of(context);
    if (n.type != 'overdraft_forecast') return (l.notifUnknown, null);
    try {
      final d = jsonDecode(n.data) as Map<String, dynamic>;
      String day(String iso) => context.day(DateTime.parse(iso));
      return (
        l.notifOverdraftTitle(d['accountName'] as String, day(d['date'])),
        l.notifOverdraftBody(
          context.money(d['balanceCents'] as int),
          context.money(d['thresholdCents'] as int),
        ),
      );
    } on Object {
      return (l.notifUnknown, null);
    }
  }
}
