import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/file_save.dart';
import '../widgets/invoices.dart';

/// Every invoice of the group the user may see, under names built from
/// their operations: search, year, running warranties, ZIP export.
class InvoicesScreen extends StatefulWidget {
  final GroupMembership membership;
  const InvoicesScreen({super.key, required this.membership});

  @override
  State<InvoicesScreen> createState() => InvoicesScreenState();
}

class InvoicesScreenState extends State<InvoicesScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  int? _year;
  var _warranty = false;
  var _unattached = false;
  List<InvoiceInfo>? _items;
  String? _error;

  /// Export in progress: files fetched so far.
  int? _exported;

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void dispose() {
    _search.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> reload() async {
    setState(() => _error = null);
    try {
      final items = await client.invoice.list(
        widget.membership.group.id!,
        year: _year,
        search: _search.text,
        warranty: _warranty,
        unattached: _unattached,
      );
      if (mounted) setState(() => _items = items);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  /// One ZIP of the invoices shown, under their names.
  Future<void> _export() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final items = _items ?? const <InvoiceInfo>[];
    if (items.isEmpty) return;
    setState(() => _exported = 0);
    try {
      final names = core.uniqueFileNames([for (final i in items) i.name]);
      final entries = <core.ZipEntry>[];
      for (final (n, i) in items.indexed) {
        final data = await client.invoice.download(i.invoice.id!);
        entries.add((
          name: names[n],
          bytes: data.buffer.asUint8List(
            data.offsetInBytes,
            data.lengthInBytes,
          ),
          modified: (i.transactionDate ?? i.invoice.createdAt).toUtc(),
        ));
        if (mounted) setState(() => _exported = n + 1);
      }
      final zip = core.buildZip(entries);
      openOrSaveFile(
        _year == null ? l.invoicesZipName : l.invoicesZipNameYear('$_year'),
        'application/zip',
        zip,
      );
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    } finally {
      if (mounted) setState(() => _exported = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final items = _items;
    final thisYear = DateTime.now().year;
    final exported = _exported;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.invoicesTitle, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(l.invoicesIntro, style: theme.textTheme.bodyMedium),
        if (_canWrite) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.note_add_outlined),
                label: Text(l.invoiceAddWaiting),
                onPressed: () async {
                  final saved = await addUnattachedInvoice(
                    context,
                    widget.membership.group.id!,
                  );
                  if (saved != null) await reload();
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(l.invoiceTakePhoto),
                onPressed: () async {
                  final saved = await addUnattachedInvoice(
                    context,
                    widget.membership.group.id!,
                    camera: true,
                  );
                  if (saved != null) await reload();
                },
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _search,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            labelText: l.invoicesSearch,
          ),
          onChanged: (_) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 350), reload);
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropdownButton<int?>(
              value: _year,
              items: [
                DropdownMenuItem(value: null, child: Text(l.invoicesAllYears)),
                for (var y = thisYear; y >= thisYear - 10; y--)
                  DropdownMenuItem(value: y, child: Text('$y')),
              ],
              onChanged: (y) {
                setState(() => _year = y);
                reload();
              },
            ),
            FilterChip(
              avatar: const Icon(Icons.pending_actions_outlined, size: 18),
              label: Text(l.invoicesWaitingFilter),
              selected: _unattached,
              onSelected: (v) {
                setState(() => _unattached = v);
                reload();
              },
            ),
            FilterChip(
              avatar: const Icon(Icons.verified_user_outlined, size: 18),
              label: Text(l.invoicesWarrantyFilter),
              selected: _warranty,
              onSelected: (v) {
                setState(() => _warranty = v);
                reload();
              },
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.folder_zip_outlined),
              label: Text(
                exported == null
                    ? l.invoicesExport
                    : l.invoicesExporting(exported, items?.length ?? 0),
              ),
              onPressed: exported != null || (items?.isEmpty ?? true)
                  ? null
                  : _export,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_error != null)
          Text(_error!, style: TextStyle(color: theme.colorScheme.error))
        else if (items == null)
          const Center(child: CircularProgressIndicator())
        else if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(l.invoicesEmpty),
          )
        else ...[
          Text(
            l.invoicesCount(items.length),
            style: theme.textTheme.bodySmall,
          ),
          for (final i in items)
            InvoiceTile(
              key: ValueKey(i.invoice.id),
              info: i,
              canWrite: _canWrite,
              showOperation: true,
              onChanged: (_) => reload(),
            ),
        ],
      ],
    );
  }
}
