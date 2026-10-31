import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/admin_backups.dart';

/// Server administration (server administrator only): health, figures,
/// accounts, banned IPs and the audit log. Never a group's financial data.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  AdminHealth? _health;
  AdminStats? _stats;
  List<AdminUserInfo> _users = [];
  List<IpBanInfo> _bans = [];
  List<AdminAuditInfo> _audit = [];
  BackupOverview? _backups;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final health = await client.admin.health();
      final stats = await client.admin.stats();
      final users = await client.admin.users();
      final bans = await client.admin.bannedIps();
      final audit = await client.admin.audit(limit: 100);
      final backups = await client.admin.backups();
      if (!mounted) return;
      setState(() {
        _health = health;
        _stats = stats;
        _users = users;
        _bans = bans;
        _audit = audit;
        _backups = backups;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _act(Future<void> Function() call, String done) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await call();
      messenger.showSnackBar(SnackBar(content: Text(done)));
      await _load();
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.adminTitle),
          actions: [
            IconButton(
              tooltip: l.adminRefresh,
              icon: const Icon(Icons.refresh),
              onPressed: _load,
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l.adminTabHealth),
              Tab(text: l.adminTabBackups),
              Tab(text: l.adminTabUsers),
              Tab(text: l.adminTabSecurity),
              Tab(text: l.adminTabAudit),
            ],
          ),
        ),
        body: _error != null
            ? Center(child: Text(_error!))
            : _health == null
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  AdminHealthView(
                    health: _health!,
                    stats: _stats!,
                    onTestEmail: () async {
                      final l = AppLocalizations.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        final to = await client.admin.sendTestEmail();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              _health!.smtpConfigured
                                  ? l.adminTestEmailSent(to)
                                  : l.adminTestEmailLogged,
                            ),
                          ),
                        );
                      } on Object catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(errorText(l, e))),
                        );
                      }
                    },
                  ),
                  AdminBackupsView(
                    overview: _backups!,
                    onBackup: () => _act(
                      () => client.admin.requestBackup(),
                      l.adminBackupRequested,
                    ),
                  ),
                  _UsersView(
                    users: _users,
                    onBlock: (u, blocked) => _act(
                      () => client.admin.setBlocked(u.authUserId, blocked),
                      blocked ? l.adminUserBlocked : l.adminUserUnblocked,
                    ),
                  ),
                  _BansView(
                    bans: _bans,
                    onUnban: (ip) =>
                        _act(() => client.admin.unbanIp(ip), l.adminUnbanned),
                  ),
                  _AuditView(entries: _audit),
                ],
              ),
      ),
    );
  }
}

String _bytes(BuildContext context, int b) {
  final lang = Localizations.localeOf(context).languageCode;
  String n(double v) => v
      .toStringAsFixed(1)
      .replaceAll(
        '.',
        lang == 'fr' ? ',' : '.',
      );
  if (b < 1024 * 1024) return '${n(b / 1024)} ${lang == 'fr' ? 'Ko' : 'KB'}';
  if (b < 1024 * 1024 * 1024) {
    return '${n(b / 1024 / 1024)} ${lang == 'fr' ? 'Mo' : 'MB'}';
  }
  return '${n(b / 1024 / 1024 / 1024)} ${lang == 'fr' ? 'Go' : 'GB'}';
}

String _when(BuildContext context, DateTime t) {
  final local = t.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '${context.day(DateTime.utc(local.year, local.month, local.day))} $hh:$mm';
}

/// Health of the server and figures of the whole installation.
class AdminHealthView extends StatelessWidget {
  final AdminHealth health;
  final AdminStats stats;
  final VoidCallback onTestEmail;

  const AdminHealthView({
    super.key,
    required this.health,
    required this.stats,
    required this.onTestEmail,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final h = health, s = stats;
    final drift = h.serverTime.difference(DateTime.now().toUtc()).inSeconds;
    final uptime = h.serverTime.difference(h.startedAt);
    Widget row(IconData icon, String label, String value, {bool? ok}) =>
        ListTile(
          dense: true,
          leading: Icon(
            ok == false ? Icons.error_outline : icon,
            color: ok == false
                ? theme.colorScheme.error
                : ok == true
                ? Colors.green.shade700
                : null,
          ),
          title: Text(label),
          subtitle: Text(
            value,
            style: ok == false
                ? TextStyle(color: theme.colorScheme.error)
                : null,
          ),
        );
    final classified =
        s.classifiedAutomatically + s.classifiedManually + s.unclassified;
    final auto = classified == 0
        ? null
        : (s.classifiedAutomatically * 100 / classified).round();
    Widget card(String title, List<Widget> children) => Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            ...children,
          ],
        ),
      ),
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        card(l.adminHealth, [
          row(Icons.sell_outlined, l.adminVersion, h.version),
          row(
            Icons.timer_outlined,
            l.adminUptime,
            l.adminUptimeValue(uptime.inDays, uptime.inHours % 24),
          ),
          row(
            Icons.storage,
            l.adminDatabase,
            h.databaseOk
                ? (h.databaseBytes == null
                      ? l.adminOk
                      : _bytes(context, h.databaseBytes!))
                : l.adminUnreachable,
            ok: h.databaseOk,
          ),
          row(
            Icons.attach_file,
            l.adminDocuments,
            _bytes(context, h.documentsBytes),
          ),
          row(
            Icons.notifications_active_outlined,
            l.adminAlertsJob,
            h.alertsRunAt == null
                ? l.adminNotYet
                : '${_when(context, h.alertsRunAt!)} · '
                      '${h.alertsRunOk == true ? l.adminOk : l.adminFailed}',
            ok: h.alertsRunAt == null ? null : h.alertsRunOk == true,
          ),
          row(
            Icons.schedule,
            l.adminClock,
            l.adminClockDrift(drift),
            ok: drift.abs() < 120,
          ),
          row(
            Icons.mail_outline,
            l.adminEmail,
            h.smtpConfigured ? l.adminEmailSmtp : l.adminEmailLog,
            ok: h.smtpConfigured ? true : null,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.send_outlined),
                label: Text(l.adminTestEmail),
                onPressed: onTestEmail,
              ),
            ),
          ),
          if (h.publicUrl.isNotEmpty)
            row(Icons.public, l.adminPublicUrl, h.publicUrl),
        ]),
        card(l.adminStats, [
          row(
            Icons.person_outline,
            l.adminStatUsers,
            l.adminStatUsersValue(s.users, s.twoFactorUsers, s.blockedUsers),
          ),
          row(Icons.groups_outlined, l.adminStatGroups, '${s.groups}'),
          row(
            Icons.account_balance_outlined,
            l.adminStatAccounts,
            '${s.accounts}',
          ),
          row(
            Icons.receipt_long_outlined,
            l.adminStatOperations,
            l.adminStatOperationsValue(s.operations, s.operationsLast30Days),
          ),
          row(
            Icons.upload_file,
            l.adminStatImports,
            '${s.importsLast30Days}',
          ),
          row(Icons.rule, l.adminStatRules, '${s.rules}'),
          row(
            Icons.mail_lock_outlined,
            l.adminStatInvitations,
            '${s.pendingInvitations}',
          ),
          row(
            Icons.auto_awesome_outlined,
            l.adminStatAuto,
            auto == null ? l.adminNotYet : '$auto %',
            ok: auto == null ? null : auto >= 70,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              l.adminStatAutoHelp(
                s.classifiedAutomatically,
                s.classifiedManually,
                s.unclassified,
              ),
              style: theme.textTheme.bodySmall,
            ),
          ),
        ]),
      ],
    );
  }
}

class _UsersView extends StatelessWidget {
  final List<AdminUserInfo> users;
  final void Function(AdminUserInfo, bool blocked) onBlock;

  const _UsersView({required this.users, required this.onBlock});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    String role(MemberRole r) => switch (r) {
      MemberRole.admin => l.roleAdmin,
      MemberRole.user => l.roleUser,
      MemberRole.reader => l.roleReader,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.adminUsersHelp, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final u in users)
          Card(
            child: ListTile(
              leading: Icon(
                u.blocked
                    ? Icons.block
                    : u.serverAdmin
                    ? Icons.admin_panel_settings_outlined
                    : Icons.person_outline,
                color: u.blocked ? theme.colorScheme.error : null,
              ),
              title: Text(u.email ?? '?'),
              subtitle: Text(
                [
                  if (u.serverAdmin) l.adminServerAdmin,
                  for (final (i, g) in u.groupNames.indexed)
                    '$g (${role(u.roles[i])})',
                  u.twoFactor ? l.adminTwoFactorOn : l.adminTwoFactorOff,
                  l.adminCreated(context.day(u.createdAt)),
                  u.lastActiveAt == null
                      ? l.adminNeverActive
                      : l.adminLastActive(_when(context, u.lastActiveAt!)),
                  if (u.blocked) l.adminBlocked,
                ].join(' · '),
              ),
              trailing: u.serverAdmin && !u.blocked
                  ? null
                  : TextButton(
                      onPressed: () async {
                        if (!u.blocked) {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(l.adminBlockTitle(u.email ?? '?')),
                              content: Text(l.adminBlockHelp),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(l.cancel),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(l.adminBlock),
                                ),
                              ],
                            ),
                          );
                          if (ok != true) return;
                        }
                        onBlock(u, !u.blocked);
                      },
                      child: Text(u.blocked ? l.adminUnblock : l.adminBlock),
                    ),
            ),
          ),
      ],
    );
  }
}

class _BansView extends StatelessWidget {
  final List<IpBanInfo> bans;
  final void Function(String ip) onUnban;

  const _BansView({required this.bans, required this.onUnban});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.adminBansHelp, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        if (bans.isEmpty) Text(l.adminBansEmpty),
        for (final b in bans)
          Card(
            child: ListTile(
              leading: const Icon(Icons.gpp_bad_outlined),
              title: Text(b.ip),
              subtitle: Text(
                l.adminBanUntil(_when(context, b.bannedUntil), b.banCount),
              ),
              trailing: TextButton(
                onPressed: () => onUnban(b.ip),
                child: Text(l.adminUnban),
              ),
            ),
          ),
      ],
    );
  }
}

class _AuditView extends StatelessWidget {
  final List<AdminAuditInfo> entries;
  const _AuditView({required this.entries});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.adminAuditHelp, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        if (entries.isEmpty) Text(l.adminAuditEmpty),
        for (final a in entries)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text('${a.action} · ${a.entity}'),
            subtitle: Text(
              [
                _when(context, a.createdAt),
                a.email ?? l.adminSystem,
                if (a.groupId != null) l.adminAuditGroup(a.groupId!),
              ].join(' · '),
            ),
          ),
      ],
    );
  }
}
