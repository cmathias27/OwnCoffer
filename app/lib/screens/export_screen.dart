import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/file_pick.dart';
import '../util/file_save.dart';
import '../util/group_transfer.dart';
import 'device_backup_screen.dart';
import 'migrate_screen.dart';

/// Download of the member's data in the current group: complete JSON, or
/// the operations as CSV. Made by the server, saved on the device only.
class ExportScreen extends StatefulWidget {
  final GroupMembership membership;

  /// For tests: what the server returns.
  final Future<String> Function(int groupId)? json;
  final Future<String> Function(int groupId, String language)? csv;

  /// For tests: where the file goes.
  final Future<void> Function(String name, String mime, List<int> bytes)? save;

  /// For tests: today.
  final DateTime? now;

  /// The server administrator may import an export into a new group (the
  /// standalone owner is one); [onImported] reloads the groups.
  final bool canImport;
  final Future<void> Function()? onImported;

  const ExportScreen({
    super.key,
    required this.membership,
    this.json,
    this.csv,
    this.save,
    this.now,
    this.canImport = false,
    this.onImported,
  });

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String? _busy;
  String? _error;

  /// `owncoffer-<group>-<yyyy-mm-dd>.<ext>`, the group name made file-safe.
  String _name(String ext) {
    final d = widget.now ?? DateTime.now();
    final day =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
    final group = widget.membership.group.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return 'owncoffer${group.isEmpty ? '' : '-$group'}-$day.$ext';
  }

  Future<void> _export(String kind) async {
    final l = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final messenger = ScaffoldMessenger.of(context);
    final groupId = widget.membership.group.id!;
    setState(() => (_busy = kind, _error = null));
    try {
      final String text;
      final String name;
      final String mime;
      if (kind == 'json') {
        text = await (widget.json ?? client.export.groupJson)(groupId);
        name = _name('json');
        mime = 'application/json';
      } else {
        text = await (widget.csv ?? client.export.transactionsCsv)(
          groupId,
          language,
        );
        name = _name('csv');
        mime = 'text/csv';
      }
      final bytes = utf8.encode(text);
      if (widget.save != null) {
        await widget.save!(name, mime, bytes);
      } else {
        await openOrSaveFile(name, mime, bytes);
      }
      messenger.showSnackBar(SnackBar(content: Text(l.exportDone(name))));
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _import() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final file = await pickFile(extensions: const ['.json']);
    if (file == null || !mounted) return;
    setState(() => (_busy = 'import', _error = null));
    try {
      final result = await GroupTransfer.importJson(
        client,
        utf8.decode(file.bytes),
      );
      await widget.onImported?.call();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l.importExportDone(
              result.groupName,
              result.accounts,
              result.transactions,
            ),
          ),
        ),
      );
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget card(String kind, IconData icon, String title, String help) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(help),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.icon(
                icon: _busy == kind
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
                label: Text(l.exportDownload),
                onPressed: _busy == null ? () => _export(kind) : null,
              ),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.exportTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.exportIntro(widget.membership.group.name)),
              const SizedBox(height: 16),
              card(
                'json',
                Icons.data_object,
                l.exportJsonTitle,
                l.exportJsonHelp,
              ),
              const SizedBox(height: 12),
              card(
                'csv',
                Icons.table_chart_outlined,
                l.exportCsvTitle,
                l.exportCsvHelp,
              ),
              if (isStandalone) ...[
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.lock_clock_outlined),
                    title: Text(l.deviceBackupTitle),
                    subtitle: Text(l.deviceBackupIntro),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const DeviceBackupScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.cloud_upload_outlined),
                    title: Text(l.migrateTitle),
                    subtitle: Text(l.migrateIntro),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const MigrateScreen(),
                      ),
                    ),
                  ),
                ),
              ],
              if (widget.canImport) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.upload_file_outlined),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l.importExportTitle,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(l.importExportHelp),
                        const SizedBox(height: 12),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: OutlinedButton.icon(
                            icon: _busy == 'import'
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.folder_open_outlined),
                            label: Text(l.importExportChoose),
                            onPressed: _busy == null ? _import : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ],
              const SizedBox(height: 16),
              Text(l.exportNote, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
