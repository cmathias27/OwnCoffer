import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../widgets/soft.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/budget_charts.dart';
import '../help/help.dart';
import '../widgets/notification_settings.dart';
import '../widgets/session_alert.dart';

/// The user's notifications. Texts are built here from the type and the
/// figures stored by the server, so they follow the user's language.
class NotificationsScreen extends StatefulWidget {
  /// Opens the forecast of an account (overdraft alerts).
  final void Function(int accountId) onOpenForecast;

  const NotificationsScreen({super.key, required this.onOpenForecast});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();

  /// Title and body of [n] in the user's language (also the monthly summary).
  static (String, String?) texts(BuildContext context, AppNotification n) =>
      _NotificationsScreenState.texts(context, n);
}

/// The families of notifications one can filter on (decision 0041,
/// point 16).
enum NotificationFamily { alerts, advice, system }

/// The family of a notification type: alerts need an action, advice is
/// something to know, the rest is about the app and the sessions.
NotificationFamily notificationFamily(String type) => switch (type) {
  'overdraft_forecast' ||
  'goal_warning' ||
  'goal_over' => NotificationFamily.alerts,
  'goal_forecast' || 'warranty_ending' => NotificationFamily.advice,
  _ => NotificationFamily.system,
};

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification>? _items;
  String? _error;

  /// Null: every notification.
  NotificationFamily? _family;

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
    final alert = SessionAlert.of(n);
    if (alert != null) {
      await showSessionAlert(context, alert, close: client.presence.close);
      await _reload();
    } else if (n.type == 'overdraft_forecast' && accountId != null) {
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
          IconButton(
            tooltip: AppLocalizations.of(context).notifSettingsTitle,
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NotificationSettingsScreen(),
              ),
            ),
          ),
          const HelpButton(HelpTopic.notifications),
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
          ? EmptyState(
              icon: Icons.notifications_none,
              text: l.notificationsEmpty,
              hint: l.emptyNotificationsHint,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _filters(l, items),
                Expanded(child: _list(context, l, theme, items)),
              ],
            ),
    );
  }

  Widget _filters(AppLocalizations l, List<AppNotification> items) {
    int count(NotificationFamily f) =>
        items.where((n) => notificationFamily(n.type) == f).length;
    Widget chip(Key key, String label, NotificationFamily? f) => ChoiceChip(
      key: key,
      label: Text(label),
      selected: _family == f,
      onSelected: (_) => setState(() => _family = f),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Wrap(
        spacing: 8,
        children: [
          chip(const Key('notif-all'), l.notifFilterAll, null),
          chip(
            const Key('notif-alerts'),
            l.notifFilterAlerts(count(NotificationFamily.alerts)),
            NotificationFamily.alerts,
          ),
          chip(
            const Key('notif-advice'),
            l.notifFilterAdvice(count(NotificationFamily.advice)),
            NotificationFamily.advice,
          ),
          chip(
            const Key('notif-system'),
            l.notifFilterSystem(count(NotificationFamily.system)),
            NotificationFamily.system,
          ),
        ],
      ),
    );
  }

  Widget _list(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
    List<AppNotification> all,
  ) {
    final family = _family;
    final items = family == null
        ? all
        : [
            for (final n in all)
              if (notificationFamily(n.type) == family) n,
          ];
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l.notifFilterEmpty, textAlign: TextAlign.center),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final n = items[i];
          final (title, body) = texts(context, n);
          final isUnread = n.readAt == null;
          return ListTile(
            leading: switch (n.type) {
              'overdraft_forecast' => Icon(
                Icons.warning_amber,
                color: theme.colorScheme.error,
              ),
              'goal_warning' => const Icon(
                Icons.flag_outlined,
                color: ChartColors.warning,
              ),
              'goal_over' => const Icon(
                Icons.flag,
                color: ChartColors.critical,
              ),
              'goal_forecast' => const Icon(
                Icons.trending_up,
                color: ChartColors.warning,
              ),
              'warranty_ending' => const Icon(
                Icons.verified_user_outlined,
                color: ChartColors.warning,
              ),
              SessionAlert.type => Icon(
                SessionAlert.of(n)?.unusualCountry ?? false
                    ? Icons.gpp_maybe
                    : Icons.devices_other,
                color: SessionAlert.of(n)?.unusualCountry ?? false
                    ? theme.colorScheme.error
                    : ChartColors.warning,
              ),
              _ => const Icon(Icons.notifications_none),
            },
            title: Text(
              title,
              style: TextStyle(
                fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
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
    );
  }

  static (String, String?) texts(BuildContext context, AppNotification n) {
    final l = AppLocalizations.of(context);
    if (n.type == 'goal_warning' ||
        n.type == 'goal_over' ||
        n.type == 'goal_forecast') {
      try {
        final d = jsonDecode(n.data) as Map<String, dynamic>;
        final name = context.categoryName(
          Category(
            groupId: n.groupId ?? 0,
            name: d['name'] as String?,
            standardCode: d['standardCode'] as String?,
            kind: CategoryKind.expense,
          ),
        );
        if (n.type == 'goal_forecast') {
          return (
            l.notifGoalForecastTitle(
              name,
              context.day(DateTime.parse(d['overDate'] as String)),
            ),
            l.notifGoalForecastBody(
              context.money(d['spentCents'] as int),
              context.money(d['goalCents'] as int),
              context.money(d['projectedCents'] as int),
            ),
          );
        }
        return (
          n.type == 'goal_over'
              ? l.notifGoalOverTitle(name)
              : l.notifGoalWarningTitle(name),
          l.notifGoalBody(
            context.money(d['spentCents'] as int),
            context.money(d['goalCents'] as int),
          ),
        );
      } on Object {
        return (l.notifUnknown, null);
      }
    }
    if (n.type == 'warranty_ending') {
      try {
        final d = jsonDecode(n.data) as Map<String, dynamic>;
        return (
          l.notifWarrantyTitle(
            d['name'] as String,
            context.day(DateTime.parse(d['until'] as String)),
          ),
          l.notifWarrantyBody,
        );
      } on Object {
        return (l.notifUnknown, null);
      }
    }
    final alert = SessionAlert.of(n);
    if (alert != null) return (alert.title(l), alert.body(l));
    if (n.type == 'session_closed_by_admin') {
      try {
        final d = jsonDecode(n.data) as Map<String, dynamic>;
        return (
          l.notifSessionClosedTitle(d['count'] as int),
          l.notifSessionClosedBody,
        );
      } on Object {
        return (l.notifUnknown, null);
      }
    }
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
