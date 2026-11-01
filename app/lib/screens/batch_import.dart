import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/file_pick.dart';

/// One file of a batch: the account it goes to, what the preview found,
/// and how its import went.
class _Item {
  final PickedFile file;
  int? accountId;
  ImportPreview? preview;
  String? error;
  StatementImport? done;
  _Item(this.file, this.accountId);
}

/// Imports several statements at once (several months, several accounts):
/// each file is previewed first, on the account its number names (OFX) or
/// the one chosen; possible duplicates are left out, as by default for one
/// file. A CSV whose columns are not recognised is imported alone.
class BatchImportDialog extends StatefulWidget {
  final List<PickedFile> files;
  final List<Account> accounts;
  final int defaultAccountId;
  const BatchImportDialog({
    super.key,
    required this.files,
    required this.accounts,
    required this.defaultAccountId,
  });

  @override
  State<BatchImportDialog> createState() => _BatchImportDialogState();
}

class _BatchImportDialogState extends State<BatchImportDialog> {
  late final List<_Item> _items = [
    for (final f in widget.files) _Item(f, widget.defaultAccountId),
  ];
  var _busy = false;
  var _finished = false;

  @override
  void initState() {
    super.initState();
    _previewAll();
  }

  Future<void> _preview(_Item item, {bool follow = true}) async {
    final l = AppLocalizations.of(context);
    try {
      var p = await client.import.preview(
        item.accountId!,
        ByteData.sublistView(item.file.bytes),
      );
      final known = p.recognisedAccountId;
      if (follow &&
          known != null &&
          known != item.accountId &&
          widget.accounts.any((a) => a.id == known)) {
        item.accountId = known;
        p = await client.import.preview(
          known,
          ByteData.sublistView(item.file.bytes),
        );
      }
      item.preview = p;
      item.error = null;
    } on Object catch (e) {
      item.preview = null;
      item.error = errorText(l, e);
    }
    if (mounted) setState(() {});
  }

  Future<void> _previewAll() async {
    setState(() => _busy = true);
    for (final item in _items) {
      await _preview(item);
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _importAll() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    for (final item in _items) {
      if (item.preview == null || item.done != null) continue;
      try {
        item.done = await client.import.commit(
          item.accountId!,
          item.file.name,
          ByteData.sublistView(item.file.bytes),
        );
      } on Object catch (e) {
        item.error = errorText(l, e);
      }
      if (mounted) setState(() {});
    }
    if (mounted) setState(() => (_busy = false, _finished = true));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ready = _items.where((i) => i.preview != null && i.done == null);
    return AlertDialog(
      title: Text(l.batchImportTitle(_items.length)),
      content: SizedBox(
        width: 560,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(l.batchImportHelp, style: theme.textTheme.bodySmall),
            for (final item in _items)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(item.file.name, style: theme.textTheme.titleSmall),
                    DropdownButton<int>(
                      isExpanded: true,
                      value: item.accountId,
                      items: [
                        for (final a in widget.accounts)
                          DropdownMenuItem(value: a.id, child: Text(a.name)),
                      ],
                      onChanged: _busy || item.done != null
                          ? null
                          : (id) {
                              setState(() => item.accountId = id);
                              _preview(item, follow: false);
                            },
                    ),
                    Text(
                      item.done != null
                          ? l.importDone(
                              item.done!.addedCount,
                              item.done!.classifiedCount,
                            )
                          : item.error ??
                                (item.preview == null
                                    ? l.batchImportReading
                                    : l.batchImportPreview(
                                        item.preview!.newCount,
                                        item.preview!.duplicateCount,
                                        item.preview!.possibleDuplicateCount,
                                      )),
                      style: TextStyle(
                        color: item.error != null
                            ? theme.colorScheme.error
                            : item.done != null
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    if (item.preview?.sameFileAlreadyImported ?? false)
                      Text(
                        l.batchImportSameFile,
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, _finished),
          child: Text(_finished ? l.close : l.cancel),
        ),
        if (!_finished)
          FilledButton(
            onPressed: _busy || ready.isEmpty ? null : _importAll,
            child: Text(l.batchImportGo(ready.length)),
          ),
      ],
    );
  }
}
