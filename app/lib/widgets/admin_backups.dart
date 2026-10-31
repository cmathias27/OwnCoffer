import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../util/format.dart';

/// Backups kept on the host: state of the nightly one, a backup on demand,
/// the list, and how to restore (on the server only: too risky from the web).
class AdminBackupsView extends StatelessWidget {
  final BackupOverview overview;
  final VoidCallback onBackup;

  /// For tests: "now".
  final DateTime? now;

  const AdminBackupsView({
    super.key,
    required this.overview,
    required this.onBackup,
    this.now,
  });

  static String bytes(BuildContext context, int b) {
    final fr = Localizations.localeOf(context).languageCode == 'fr';
    String n(double v) {
      final t = v.toStringAsFixed(1);
      return fr ? t.replaceAll('.', ',') : t;
    }

    if (b < 1024 * 1024) return '${n(b / 1024)} ${fr ? 'Ko' : 'KB'}';
    if (b < 1024 * 1024 * 1024) {
      return '${n(b / 1024 / 1024)} ${fr ? 'Mo' : 'MB'}';
    }
    return '${n(b / 1024 / 1024 / 1024)} ${fr ? 'Go' : 'GB'}';
  }

  static String when(BuildContext context, DateTime t) {
    final local = t.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '${context.day(DateTime.utc(local.year, local.month, local.day))} '
        '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final o = overview;
    if (!o.available) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.adminBackupsUnavailable),
          const SizedBox(height: 8),
          SelectableText(
            'sudo docker/install-auto-update.sh',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ],
      );
    }
    final current = (now ?? DateTime.now()).toUtc();
    final nightly = o.lastDailyAt;
    final nightlyLate =
        nightly == null || current.difference(nightly).inHours >= 36;
    final lastFailed = o.lastOk == false;
    final label = {
      'daily': l.adminBackupDaily,
      'manual': l.adminBackupManual,
    };
    Widget status(bool bad, String text) => ListTile(
      leading: Icon(
        bad ? Icons.error_outline : Icons.check_circle_outline,
        color: bad ? theme.colorScheme.error : Colors.green.shade700,
      ),
      title: Text(
        text,
        style: bad ? TextStyle(color: theme.colorScheme.error) : null,
      ),
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              status(
                nightlyLate,
                nightly == null
                    ? l.adminBackupNoNightly
                    : nightlyLate
                    ? l.adminBackupNightlyLate(when(context, nightly))
                    : l.adminBackupNightlyOk(when(context, nightly)),
              ),
              if (lastFailed)
                status(
                  true,
                  l.adminBackupLastFailed(
                    when(context, o.lastAt!),
                    o.lastMessage ?? '',
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(Icons.backup_outlined),
                      label: Text(l.adminBackupNow),
                      onPressed: o.requestPending ? null : onBackup,
                    ),
                    if (o.requestPending)
                      Text(
                        l.adminBackupPending,
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(l.adminBackupsHelp, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        if (o.backups.isEmpty) Text(l.adminBackupsEmpty),
        for (final b in o.backups)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              b.label == 'daily'
                  ? Icons.nightlight_outlined
                  : b.label.startsWith('before-')
                  ? Icons.system_update_alt
                  : Icons.touch_app_outlined,
            ),
            title: Text(
              b.label.startsWith('before-')
                  ? l.adminBackupBefore(b.label.substring(7))
                  : label[b.label] ?? b.label,
            ),
            subtitle: Text(
              '${when(context, b.createdAt)} · ${bytes(context, b.bytes)}',
            ),
          ),
        const SizedBox(height: 16),
        Text(l.adminRestoreTitle, style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(l.adminRestoreHelp, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        SelectableText(
          'docker compose -f docker/compose.yaml stop owncoffer\n'
          'docker compose -f docker/compose.yaml exec -T postgres '
          'pg_restore -U owncoffer -d owncoffer --clean --if-exists '
          '--no-owner < docker/backups/<fichier>.dump\n'
          'docker compose -f docker/compose.yaml start owncoffer',
          style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
        ),
      ],
    );
  }
}
