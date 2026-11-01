import 'package:flutter/material.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/file_pick.dart';
import '../util/file_save.dart';
import '../util/standalone.dart';
import '../util/standalone_backups.dart';
import '../widgets/admin_backups.dart';

/// Standalone mode: the daily encrypted backup to a folder, a backup now,
/// and a restore (decision 0022).
class DeviceBackupScreen extends StatefulWidget {
  const DeviceBackupScreen({super.key});

  @override
  State<DeviceBackupScreen> createState() => _DeviceBackupScreenState();
}

class _DeviceBackupScreenState extends State<DeviceBackupScreen> {
  final _pass = TextEditingController();
  final _again = TextEditingController();
  ({String? passphrase, String? folder, DateTime? last})? _settings;
  String? _folder;
  String? _error;
  String? _busy;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _pass.dispose();
    _again.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final s = await StandaloneBackups.settings();
    final folder = s.folder ?? await defaultBackupFolder();
    if (mounted) setState(() => (_settings = s, _folder = folder));
  }

  Future<void> _run(String what, Future<void> Function() action) async {
    setState(() => (_busy = what, _error = null));
    try {
      await action();
    } on Object catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context);
        setState(
          () => _error = isWrongPassphrase(e)
              ? l.deviceBackupWrongPassphrase
              : e is FormatException
              ? l.deviceBackupNotABackup
              : errorText(l, e),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _enable() async {
    final l = AppLocalizations.of(context);
    if (_pass.text.length < 12) {
      setState(() => _error = l.deviceBackupPassphraseTooShort);
      return;
    }
    if (_pass.text != _again.text) {
      setState(() => _error = l.deviceBackupPassphraseMismatch);
      return;
    }
    await _run('enable', () async {
      await StandaloneBackups.enable(_pass.text, _folder!);
      _pass.clear();
      _again.clear();
      await StandaloneBackups.backupNow();
      await _load();
    });
  }

  Future<void> _backupNow() => _run('now', () async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final path = await StandaloneBackups.backupNow();
    await _load();
    messenger.showSnackBar(SnackBar(content: Text(l.deviceBackupDone(path))));
  });

  Future<void> _share() => _run('share', () async {
    final latest = await latestBackup(_folder!);
    if (latest == null) return;
    await openOrSaveFile(latest.name, 'application/octet-stream', latest.bytes);
  });

  Future<void> _restore() async {
    final l = AppLocalizations.of(context);
    final file = await pickFile(extensions: const ['.ocbackup']);
    if (file == null || !mounted) return;
    final pass = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deviceBackupRestore),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.deviceBackupRestoreConfirm),
            const SizedBox(height: 12),
            TextField(
              controller: pass,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l.deviceBackupRestorePassphrase,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.deviceBackupReplace),
          ),
        ],
      ),
    );
    final passphrase = pass.text;
    pass.dispose();
    if (ok != true) return;
    var restored = false;
    await _run('restore', () async {
      await standaloneRestore(file.bytes, passphrase);
      restored = true;
    });
    // The app starts again on the restored data.
    if (restored) await restartStandalone();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = _settings;
    final on = s?.passphrase != null;
    Widget progress(String what, Widget icon) => _busy == what
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon;
    return Scaffold(
      appBar: AppBar(title: Text(l.deviceBackupTitle)),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(l.deviceBackupIntro),
                    const SizedBox(height: 12),
                    Text(l.deviceBackupFolder(_folder ?? '')),
                    if (canChooseBackupFolder)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          icon: const Icon(Icons.folder_open_outlined),
                          label: Text(l.deviceBackupChooseFolder),
                          onPressed: _busy != null
                              ? null
                              : () async {
                                  final f = await chooseBackupFolder();
                                  if (f == null) return;
                                  setState(() => _folder = f);
                                  if (on) {
                                    await StandaloneBackups.enable(
                                      s.passphrase!,
                                      f,
                                    );
                                    await _load();
                                  }
                                },
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (!on) ...[
                      TextField(
                        controller: _pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l.deviceBackupPassphrase,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _again,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l.deviceBackupPassphraseAgain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.deviceBackupPassphraseHelp,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        icon: progress(
                          'enable',
                          const Icon(Icons.lock_outline),
                        ),
                        label: Text(l.deviceBackupEnable),
                        onPressed: _busy == null ? _enable : null,
                      ),
                    ] else ...[
                      Text(
                        s.last == null
                            ? l.deviceBackupNever
                            : l.deviceBackupLast(
                                AdminBackupsView.when(context, s.last!),
                              ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.icon(
                            icon: progress('now', const Icon(Icons.backup)),
                            label: Text(l.deviceBackupNow),
                            onPressed: _busy == null ? _backupNow : null,
                          ),
                          OutlinedButton.icon(
                            icon: progress(
                              'share',
                              const Icon(Icons.share_outlined),
                            ),
                            label: Text(l.deviceBackupShare),
                            onPressed: _busy == null ? _share : null,
                          ),
                          TextButton(
                            onPressed: _busy == null
                                ? () async {
                                    await StandaloneBackups.disable();
                                    await _load();
                                  }
                                : null,
                            child: Text(l.deviceBackupDisable),
                          ),
                        ],
                      ),
                    ],
                    const Divider(height: 32),
                    Text(
                      l.deviceBackupRestore,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(l.deviceBackupRestoreHelp),
                    const SizedBox(height: 8),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: OutlinedButton.icon(
                        icon: progress(
                          'restore',
                          const Icon(Icons.settings_backup_restore),
                        ),
                        label: Text(l.deviceBackupRestore),
                        onPressed: _busy == null ? _restore : null,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
