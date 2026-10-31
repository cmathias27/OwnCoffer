import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import 'admin_backups.dart';

/// Versions and updates: what runs, what is available, automatic updates
/// on or off, install now, release notes and history. The host does the
/// work (docker/auto-update.sh): it backs up first and rolls back if the
/// new version does not start.
class AdminUpdatesView extends StatelessWidget {
  final UpdateOverview overview;
  final ValueChanged<bool> onAuto;
  final VoidCallback onCheck;
  final ValueChanged<String> onInstall;

  const AdminUpdatesView({
    super.key,
    required this.overview,
    required this.onAuto,
    required this.onCheck,
    required this.onInstall,
  });

  static int _cmp(String a, String b) {
    List<int> p(String v) => [
      for (final x in v.replaceFirst('v', '').split('.')) int.tryParse(x) ?? 0,
    ];
    final x = p(a), y = p(b);
    for (var i = 0; i < 3 && i < x.length && i < y.length; i++) {
      if (x[i] != y[i]) return x[i].compareTo(y[i]);
    }
    return 0;
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
          Text(l.adminVersionRunning(o.runningVersion)),
          const SizedBox(height: 8),
          Text(l.adminUpdatesUnavailable),
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
    final current = o.current, latest = o.latest;
    final newer =
        current != null && latest != null && _cmp(latest, current) > 0;
    final upcoming = [
      for (final r in o.releases)
        if (current != null && _cmp(r.version, current) > 0) r,
    ];
    final installed = [
      for (final r in o.releases)
        if (current == null || _cmp(r.version, current) <= 0) r,
    ];
    final resultText = {
      'installed': l.adminUpdateInstalled,
      'rollback': l.adminUpdateRollback,
      'rollback-failed': l.adminUpdateRollbackFailed,
      'refused': l.adminUpdateRefused,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.adminVersionRunning(o.runningVersion),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      newer ? Icons.new_releases_outlined : Icons.verified,
                      color: newer
                          ? theme.colorScheme.primary
                          : Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        newer
                            ? l.adminUpdateAvailable(latest)
                            : l.adminUpToDate,
                      ),
                    ),
                  ],
                ),
                if (o.checkedAt != null)
                  Text(
                    l.adminUpdateChecked(
                      AdminBackupsView.when(context, o.checkedAt!),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                if (o.message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(o.message!, style: theme.textTheme.bodySmall),
                  ),
                if (o.failedVersion != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l.adminUpdateFailedVersion(o.failedVersion!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (newer)
                      FilledButton.icon(
                        icon: const Icon(Icons.system_update_alt),
                        label: Text(l.adminInstallNow(latest)),
                        onPressed: o.requestPending
                            ? null
                            : () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(l.adminInstallTitle(latest)),
                                    content: Text(l.adminInstallHelp),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(l.cancel),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text(l.adminInstall),
                                      ),
                                    ],
                                  ),
                                );
                                if (ok == true) onInstall(latest);
                              },
                      ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(l.adminCheckNow),
                      onPressed: o.requestPending ? null : onCheck,
                    ),
                    if (o.requestPending)
                      Text(
                        l.adminUpdatePending,
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
                const Divider(height: 24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.adminAutoUpdate),
                  subtitle: Text(
                    o.auto ? l.adminAutoUpdateOn : l.adminAutoUpdateOff,
                  ),
                  value: o.auto,
                  onChanged: onAuto,
                ),
              ],
            ),
          ),
        ),
        if (upcoming.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l.adminReleasesUpcoming, style: theme.textTheme.titleMedium),
          for (final r in upcoming) _Release(notes: r, expanded: true),
        ],
        if (installed.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l.adminReleasesInstalled, style: theme.textTheme.titleMedium),
          for (final (i, r) in installed.indexed)
            _Release(notes: r, expanded: i == 0 && upcoming.isEmpty),
        ],
        if (o.history.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l.adminUpdateHistory, style: theme.textTheme.titleMedium),
          for (final h in o.history)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                h.result == 'installed'
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                color: h.result == 'installed'
                    ? Colors.green.shade700
                    : theme.colorScheme.error,
              ),
              title: Text(
                '${h.fromVersion} → ${h.toVersion} · '
                '${resultText[h.result] ?? h.result}',
              ),
              subtitle: Text(
                [
                  AdminBackupsView.when(context, h.at),
                  ?h.message,
                ].join(' · '),
              ),
            ),
        ],
      ],
    );
  }
}

class _Release extends StatelessWidget {
  final ReleaseNotes notes;
  final bool expanded;
  const _Release({required this.notes, required this.expanded});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        initiallyExpanded: expanded,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text('${notes.version} · ${notes.date}'),
        children: [ReleaseNotesText(notes.body)],
      ),
    );
  }
}

/// The few markdown forms of CHANGELOG.md: `###` headings, `-` bullets
/// (indented ones too) and **bold**.
class ReleaseNotesText extends StatelessWidget {
  final String markdown;
  const ReleaseNotesText(this.markdown, {super.key});

  static List<TextSpan> _inline(String text, TextStyle? base) {
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (final (i, p) in parts.indexed) {
      if (p.isEmpty) continue;
      spans.add(
        TextSpan(
          text: p.replaceAll('`', ''),
          style: i.isOdd ? base?.copyWith(fontWeight: FontWeight.w700) : base,
        ),
      );
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = theme.textTheme.bodyMedium;
    final children = <Widget>[];
    for (final raw in markdown.split('\n')) {
      final line = raw.trimRight();
      if (line.trim().isEmpty) continue;
      if (line.startsWith('#')) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 2),
            child: Text(
              line.replaceFirst(RegExp(r'^#+\s*'), ''),
              style: theme.textTheme.titleSmall,
            ),
          ),
        );
        continue;
      }
      final bullet = RegExp(r'^(\s*)[-*]\s+(.*)$').firstMatch(line);
      final indent = bullet == null ? 0 : bullet[1]!.length ~/ 2;
      final text = bullet == null ? line.trim() : bullet[2]!;
      children.add(
        Padding(
          padding: EdgeInsets.only(left: 12.0 * indent, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bullet != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(indent == 0 ? '•' : '◦', style: body),
                ),
              Expanded(
                child: Text.rich(TextSpan(children: _inline(text, body))),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
