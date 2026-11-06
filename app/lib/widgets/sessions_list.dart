import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// The open sessions of one person (decision 0027): on what, where, since
/// when; close one or all the others. Used for « Mes sessions » and by the
/// server administrator for a member (IP masked by the server, no rename).
class SessionsList extends StatefulWidget {
  final Future<List<SessionInfo>> Function() load;
  final Future<void> Function(SessionInfo s) onClose;

  /// Closes every session but the current one; how many were closed.
  final Future<int> Function() onCloseOthers;

  /// Null: names cannot be changed (administrator).
  final Future<void> Function(SessionInfo s, String label)? onRename;

  /// Label of the button that closes the others.
  final String? closeOthersLabel;

  const SessionsList({
    super.key,
    required this.load,
    required this.onClose,
    required this.onCloseOthers,
    this.onRename,
    this.closeOthersLabel,
  });

  @override
  State<SessionsList> createState() => _SessionsListState();
}

/// `Application Android`, `Navigateur`…
String sessionPlatformName(AppLocalizations l, String? platform) =>
    switch (platform) {
      'web' => l.sessionsPlatformWeb,
      'android' => l.sessionsPlatformAndroid,
      'windows' => l.sessionsPlatformWindows,
      'ios' => l.sessionsPlatformIos,
      'macos' => l.sessionsPlatformMacos,
      'linux' => l.sessionsPlatformLinux,
      _ => l.sessionsPlatformUnknown,
    };

/// `environ Rouen, FR`: the place of an IP is only indicative.
String _place(AppLocalizations l, SessionInfo s) {
  final place = [?s.city, ?s.country].join(', ');
  return place.isEmpty ? l.sessionsPlaceUnknown : l.sessionsPlaceAbout(place);
}

IconData _icon(String? platform) => switch (platform) {
  'web' => Icons.language,
  'android' || 'ios' => Icons.smartphone,
  'windows' || 'macos' || 'linux' => Icons.computer,
  _ => Icons.devices_other,
};

String _when(BuildContext context, DateTime t) {
  final local = t.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '${context.day(DateTime.utc(local.year, local.month, local.day))} $hh:$mm';
}

class _SessionsListState extends State<SessionsList> {
  List<SessionInfo>? _sessions;
  Object? _error;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    try {
      final s = await widget.load();
      if (mounted) setState(() => (_sessions = s, _error = null));
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _run(Future<String?> Function() call) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final done = await call();
      if (done != null) {
        messenger.showSnackBar(SnackBar(content: Text(done)));
      }
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    await _reload();
  }

  Future<bool> _confirm(String title) async {
    final l = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(l.sessionsCloseHelp),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l.sessionsClose),
              ),
            ],
          ),
        ) ==
        true;
  }

  Future<void> _rename(SessionInfo s) async {
    final label = await showDialog<String>(
      context: context,
      builder: (context) => _RenameDialog(initial: s.deviceLabel ?? ''),
    );
    if (label == null) return;
    await _run(() async {
      await widget.onRename!(s, label.trim());
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final sessions = _sessions;
    if (_error != null && sessions == null) {
      return Text(
        errorText(l, _error!),
        style: TextStyle(color: theme.colorScheme.error),
      );
    }
    if (sessions == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final others = sessions.where((s) => !s.current).length;
    // Only a session the app told about has a name to change.
    bool canRename(SessionInfo s) =>
        widget.onRename != null && s.platform != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sessions.isEmpty) Text(l.sessionsEmpty),
        for (final s in sessions)
          Card(
            child: ListTile(
              leading: Icon(_icon(s.platform)),
              title: Text(
                [
                  s.deviceLabel ?? sessionPlatformName(l, s.platform),
                  if (s.current) l.sessionsCurrent,
                ].join(' · '),
                style: s.current
                    ? const TextStyle(fontWeight: FontWeight.w600)
                    : null,
              ),
              subtitle: Text(
                [
                  [
                    if (s.deviceLabel != null)
                      sessionPlatformName(l, s.platform),
                    if (s.appVersion != null) l.sessionsVersion(s.appVersion!),
                  ].join(' · '),
                  [
                    _place(l, s),
                    ?s.ip,
                  ].join(' · '),
                  l.sessionsSince(_when(context, s.connectedSince)),
                  l.sessionsLastActive(_when(context, s.lastActiveAt)),
                ].where((line) => line.isNotEmpty).join('\n'),
              ),
              isThreeLine: true,
              trailing: _busy || (s.current && !canRename(s))
                  ? null
                  : PopupMenuButton<String>(
                      onSelected: (action) async {
                        if (action == 'rename') {
                          await _rename(s);
                        } else if (await _confirm(l.sessionsCloseTitle)) {
                          await _run(() async {
                            await widget.onClose(s);
                            return l.sessionsClosedCount(1);
                          });
                        }
                      },
                      itemBuilder: (context) => [
                        if (canRename(s))
                          PopupMenuItem(
                            value: 'rename',
                            child: Text(l.sessionsRename),
                          ),
                        if (!s.current)
                          PopupMenuItem(
                            value: 'close',
                            child: Text(l.sessionsClose),
                          ),
                      ],
                    ),
            ),
          ),
        if (sessions.any((s) => s.city != null || s.country != null))
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Text(l.geoipCredit, style: theme.textTheme.bodySmall),
          ),
        if (others > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: Text(widget.closeOthersLabel ?? l.sessionsCloseOthers),
              onPressed: _busy
                  ? null
                  : () async {
                      if (!await _confirm(l.sessionsCloseOthersTitle)) return;
                      await _run(
                        () async =>
                            l.sessionsClosedCount(await widget.onCloseOthers()),
                      );
                    },
            ),
          ),
      ],
    );
  }
}

class _RenameDialog extends StatefulWidget {
  final String initial;
  const _RenameDialog({required this.initial});

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _field = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.sessionsRename),
      content: TextField(
        controller: _field,
        autofocus: true,
        maxLength: 60,
        decoration: InputDecoration(labelText: l.sessionsRenameLabel),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _field.text),
          child: Text(l.save),
        ),
      ],
    );
  }
}
