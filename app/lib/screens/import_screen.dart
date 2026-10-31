import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/file_pick.dart';
import '../util/format.dart';

/// Same limit as the server (ImportEndpoint.maxFileBytes), checked first to
/// avoid sending a file that will be refused.
const _maxFileBytes = 4 * 1024 * 1024;

/// Bank statement import: choose a file, check the preview, import; and the
/// account's previous imports, which can be cancelled.
class ImportScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;

  /// Called after an import or a cancellation, to refresh the other tabs.
  final VoidCallback onImported;

  const ImportScreen({
    super.key,
    required this.membership,
    required this.accounts,
    required this.onImported,
  });

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  late Account? _account = widget.accounts.firstOrNull;
  PickedFile? _file;
  CsvColumns? _columns;
  ImportPreview? _preview;
  final Set<int> _accepted = {};
  List<StatementImport> _history = [];
  Map<int, Category> _categories = {};
  var _busy = false;
  String? _error;

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadHistory();
  }

  @override
  void didUpdateWidget(ImportScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_account == null || !widget.accounts.any((a) => a.id == _account!.id)) {
      _account = widget.accounts.firstOrNull;
      _reset();
      _loadHistory();
    }
  }

  Future<void> _loadCategories() async {
    final list = await client.category.list(widget.membership.group.id!);
    if (mounted) setState(() => _categories = {for (final c in list) c.id!: c});
  }

  Future<void> _loadHistory() async {
    final account = _account;
    if (account == null) return;
    try {
      final list = await client.import.history(account.id!);
      if (mounted && _account?.id == account.id) {
        setState(() => _history = list);
      }
    } on Object catch (e) {
      if (mounted) _fail(e);
    }
  }

  void _reset() {
    _file = null;
    _columns = null;
    _preview = null;
    _accepted.clear();
    _error = null;
  }

  void _fail(Object e) =>
      setState(() => _error = errorText(AppLocalizations.of(context), e));

  Future<void> _pick() async {
    final l = AppLocalizations.of(context);
    final file = await pickFile(extensions: ['.qif', '.ofx', '.csv', '.txt']);
    if (file == null || !mounted) return;
    setState(_reset);
    if (file.bytes.isEmpty) {
      setState(() => _error = l.import_format_empty_file);
      return;
    }
    if (file.bytes.length > _maxFileBytes) {
      setState(() => _error = l.error_import_file_too_large);
      return;
    }
    _file = file;
    await _runPreview();
  }

  Future<void> _runPreview() async {
    final file = _file;
    final account = _account;
    if (file == null || account == null) return;
    setState(() => (_busy = true, _error = null));
    try {
      final preview = await client.import.preview(
        account.id!,
        ByteData.sublistView(file.bytes),
        columns: _columns,
      );
      if (!mounted) return;
      setState(() {
        _preview = preview;
        _accepted.clear();
      });
    } on InvalidInputException catch (e) {
      if (e.code == 'import_csv_columns_unknown' && _columns == null) {
        setState(() => _busy = false);
        await _chooseColumns();
        return;
      }
      if (mounted) _fail(e);
    } on Object catch (e) {
      if (mounted) _fail(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _chooseColumns() async {
    final file = _file;
    if (file == null) return;
    final columns = await showDialog<CsvColumns>(
      context: context,
      builder: (_) => _CsvColumnsDialog(bytes: file.bytes, initial: _columns),
    );
    if (columns == null || !mounted) return;
    _columns = columns;
    await _runPreview();
  }

  Future<void> _commit() async {
    final l = AppLocalizations.of(context);
    final file = _file;
    final account = _account;
    if (file == null || account == null) return;
    setState(() => (_busy = true, _error = null));
    try {
      final record = await client.import.commit(
        account.id!,
        file.name,
        ByteData.sublistView(file.bytes),
        columns: _columns,
        acceptedPossibleDuplicates: _accepted.toList(),
      );
      if (!mounted) return;
      setState(_reset);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l.importDone(record.addedCount, record.classifiedCount),
          ),
        ),
      );
      widget.onImported();
      await _loadHistory();
    } on Object catch (e) {
      if (mounted) _fail(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancel(StatementImport record) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.importCancel),
        content: Text(l.importCancelConfirm(record.addedCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.close),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.importCancel),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await client.import.cancel(record.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.importCancelDone)));
      widget.onImported();
      await _loadHistory();
    } on Object catch (e) {
      if (mounted) _fail(e);
    }
  }

  /// Which account the file belongs to (OFX account number, compared by
  /// the server without storing it).
  List<Widget> _accountNotice(
    BuildContext context,
    Account account,
    ImportPreview preview,
  ) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final id = preview.recognisedAccountId;
    if (id == account.id) {
      return [
        _Notice(
          icon: Icons.check_circle_outline,
          text: l.importAccountRecognised,
          color: Colors.green.shade700,
        ),
      ];
    }
    final match = widget.accounts.where((a) => a.id == id).firstOrNull;
    if (match != null) {
      return [
        _Notice(
          icon: Icons.swap_horiz,
          text: l.importOtherAccountMatch(match.name),
          color: theme.colorScheme.tertiary,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _busy
                ? null
                : () {
                    setState(() {
                      _account = match;
                      _history = [];
                    });
                    _loadHistory();
                    _runPreview();
                  },
            child: Text(l.importSwitchAccount(match.name)),
          ),
        ),
      ];
    }
    if (preview.otherBankAccount) {
      return [
        _Notice(
          icon: Icons.warning_amber,
          text: l.importWrongBankAccount(account.name),
          color: theme.colorScheme.error,
        ),
      ];
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final account = _account;
    if (account == null) {
      return Center(child: Text(l.importNoAccount));
    }
    final preview = _preview;
    final toImport = preview == null ? 0 : preview.newCount + _accepted.length;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverList.list(
            children: [
              Text(l.importTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (widget.accounts.length > 1)
                    DropdownButton<int>(
                      value: account.id,
                      items: [
                        for (final a in widget.accounts)
                          DropdownMenuItem(value: a.id, child: Text(a.name)),
                      ],
                      onChanged: _busy
                          ? null
                          : (id) {
                              setState(() {
                                _account = widget.accounts.firstWhere(
                                  (a) => a.id == id,
                                );
                                _reset();
                                _history = [];
                              });
                              _loadHistory();
                            },
                    ),
                  if (_canWrite)
                    FilledButton.tonalIcon(
                      onPressed: _busy ? null : _pick,
                      icon: const Icon(Icons.upload_file),
                      label: Text(
                        _file == null ? l.importChooseFile : l.importOtherFile,
                      ),
                    ),
                  if (_canWrite && _columns != null)
                    TextButton.icon(
                      onPressed: _busy ? null : _chooseColumns,
                      icon: const Icon(Icons.view_column_outlined),
                      label: Text(l.csvChangeColumns),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _canWrite ? l.importFormats : l.importReaderOnly,
                style: theme.textTheme.bodySmall,
              ),
              if (_busy) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              if (preview != null) ...[
                const SizedBox(height: 16),
                _Summary(
                  fileName: _file?.name ?? '',
                  preview: preview,
                  currency: account.currency,
                ),
                ..._accountNotice(context, account, preview),
                const SizedBox(height: 12),
                if (preview.possibleDuplicateCount > 0) ...[
                  Text(l.importPossibleHelp, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                ],
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: _busy || toImport == 0 ? null : _commit,
                    icon: const Icon(Icons.download_done),
                    label: Text(l.importConfirm(toImport)),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (preview != null)
          SliverList.builder(
            itemCount: preview.lines.length,
            itemBuilder: (context, i) {
              final line = preview.lines[i];
              return _PreviewTile(
                line: line,
                category: _categories[line.categoryId],
                currency: account.currency,
                accepted: _accepted.contains(line.index),
                onAccept: line.status == 'possibleDuplicate' && !_busy
                    ? (v) => setState(
                        () => v
                            ? _accepted.add(line.index)
                            : _accepted.remove(line.index),
                      )
                    : null,
              );
            },
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Text(l.importHistory, style: theme.textTheme.titleMedium),
          ),
        ),
        if (_history.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: Text(l.importHistoryEmpty)),
          ),
        SliverList.builder(
          itemCount: _history.length,
          itemBuilder: (context, i) {
            final h = _history[i];
            final cancelled = h.cancelledAt != null;
            return ListTile(
              leading: Icon(
                cancelled ? Icons.block : Icons.description_outlined,
                color: cancelled ? theme.disabledColor : null,
              ),
              title: Text(
                h.fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                l.importHistoryLine(
                  context.day(h.createdAt.toLocal()),
                  h.addedCount,
                  h.duplicateCount,
                ),
              ),
              trailing: cancelled
                  ? Text(l.importCancelled)
                  : _canWrite
                  ? IconButton(
                      tooltip: l.importCancel,
                      icon: const Icon(Icons.undo),
                      onPressed: () => _cancel(h),
                    )
                  : null,
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

/// Counts, file problems and the bank's balance compared with OwnCoffer's.
class _Summary extends StatelessWidget {
  final String fileName;
  final ImportPreview preview;
  final String currency;

  const _Summary({
    required this.fileName,
    required this.preview,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = preview;
    final stated = p.statedBalanceCents;
    final statedDate = p.statedBalanceDate;
    final after = p.balanceAfterImportCents;
    Widget chip(String text, {Color? color}) => Chip(
      label: Text(text),
      visualDensity: VisualDensity.compact,
      side: color == null ? null : BorderSide(color: color),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.importFileInfo(fileName, p.format.toUpperCase(), p.encoding),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                chip(l.importCountRead(p.readCount)),
                chip(l.importCountNew(p.newCount)),
                if (p.duplicateCount > 0)
                  chip(l.importCountDuplicate(p.duplicateCount)),
                if (p.possibleDuplicateCount > 0)
                  chip(
                    l.importCountPossible(p.possibleDuplicateCount),
                    color: theme.colorScheme.tertiary,
                  ),
                chip(l.importCountClassified(p.classifiedCount)),
                if (p.errorCount > 0)
                  chip(
                    l.importCountErrors(p.errorCount),
                    color: theme.colorScheme.error,
                  ),
              ],
            ),
            if (p.sameFileAlreadyImported) ...[
              const SizedBox(height: 8),
              _Notice(icon: Icons.info_outline, text: l.importSameFile),
            ],
            if (stated != null && statedDate != null) ...[
              const SizedBox(height: 8),
              Text(
                l.importBankBalance(
                  context.day(statedDate),
                  context.money(stated, currency: currency),
                ),
              ),
              if (after != null)
                after == stated
                    ? _Notice(
                        icon: Icons.check_circle_outline,
                        text: l.importBalanceMatches,
                        color: Colors.green.shade700,
                      )
                    : _Notice(
                        icon: Icons.warning_amber,
                        text: l.importBalanceDiffers(
                          context.money(after, currency: currency),
                          context.money(after - stated, currency: currency),
                        ),
                        color: theme.colorScheme.error,
                      ),
            ],
            if (p.issues.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l.importIssues, style: theme.textTheme.titleSmall),
              for (final issue in p.issues)
                _Notice(
                  icon: issue.severity == 'error'
                      ? Icons.error_outline
                      : Icons.info_outline,
                  text: importIssueText(l, issue.code, issue.line),
                  color: issue.severity == 'error'
                      ? theme.colorScheme.error
                      : null,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _Notice({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(color: color)),
        ),
      ],
    ),
  );
}

class _PreviewTile extends StatelessWidget {
  final ImportPreviewLine line;
  final Category? category;
  final String currency;
  final bool accepted;
  final ValueChanged<bool>? onAccept;

  const _PreviewTile({
    required this.line,
    required this.category,
    required this.currency,
    required this.accepted,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final c = category;
    final duplicate = line.status == 'duplicate';
    final possible = line.status == 'possibleDuplicate';
    final status = switch (line.status) {
      'duplicate' => l.importStatusDuplicate,
      'possibleDuplicate' => l.importStatusPossible,
      _ => l.importStatusNew,
    };
    final classification = c == null
        ? l.toClassify
        : '${context.categoryName(c)} (${context.categorySourceName(line.categorySource)})';
    return Opacity(
      opacity: duplicate ? 0.5 : 1,
      child: ListTile(
        leading: possible
            ? Checkbox(
                value: accepted,
                onChanged: onAccept == null ? null : (v) => onAccept!(v!),
              )
            : Icon(
                duplicate ? Icons.content_copy : Icons.fiber_new_outlined,
                color: duplicate
                    ? theme.disabledColor
                    : theme.colorScheme.primary,
              ),
        title: Text(
          line.cleanLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${context.shortDay(line.date)} · $status · $classification',
          maxLines: 2,
          style: possible ? TextStyle(color: theme.colorScheme.tertiary) : null,
        ),
        trailing: Text(
          context.money(line.amountCents, currency: currency),
          style: theme.textTheme.titleSmall?.copyWith(
            fontFamily: 'Manrope',
            color: line.amountCents > 0 ? Colors.green.shade700 : null,
          ),
        ),
      ),
    );
  }
}

/// Lets the user say which column holds what, for a CSV file whose header
/// OwnCoffer does not recognise. The file is read here, in the browser, only
/// to show the first rows.
class _CsvColumnsDialog extends StatefulWidget {
  final Uint8List bytes;
  final CsvColumns? initial;

  const _CsvColumnsDialog({required this.bytes, this.initial});

  @override
  State<_CsvColumnsDialog> createState() => _CsvColumnsDialogState();
}

class _CsvColumnsDialogState extends State<_CsvColumnsDialog> {
  late final String _text = core.decodeBankFile(widget.bytes).text;
  late String _delimiter =
      widget.initial?.delimiter ?? core.detectDelimiter(_text);
  late List<List<String>> _rows;
  late int _headerRow = widget.initial?.headerRow ?? 0;
  late int? _date = widget.initial?.dateColumn;
  late int? _label = widget.initial?.labelColumn;
  late int? _memo = widget.initial?.memoColumn;
  late int? _amount = widget.initial?.amountColumn;
  late int? _debit = widget.initial?.debitColumn;
  late int? _credit = widget.initial?.creditColumn;
  late bool _split =
      widget.initial != null && widget.initial!.amountColumn == null;
  late bool _monthFirst = widget.initial?.monthFirst ?? false;
  var _incomplete = false;

  @override
  void initState() {
    super.initState();
    _readRows();
  }

  void _readRows() {
    _rows = core
        .splitCsv(_text, _delimiter)
        .where((r) => r.any((c) => c.trim().isNotEmpty))
        .take(12)
        .toList();
    if (_headerRow >= _rows.length) _headerRow = _rows.isEmpty ? -1 : 0;
  }

  int get _columnCount => _rows.fold(0, (m, r) => r.length > m ? r.length : m);

  /// First data row, to show an example of each column.
  List<String> get _sample {
    final i = _headerRow + 1;
    return i < _rows.length ? _rows[i] : (_rows.firstOrNull ?? const []);
  }

  String _columnName(AppLocalizations l, int i) {
    final header = _headerRow >= 0 && _headerRow < _rows.length
        ? _rows[_headerRow].elementAtOrNull(i)
        : null;
    final sample = _sample.elementAtOrNull(i) ?? '';
    final text = [
      if (header != null && header.trim().isNotEmpty) header.trim(),
      if (sample.trim().isNotEmpty) sample.trim(),
    ].join(' · ');
    final short = text.length > 40 ? '${text.substring(0, 40)}…' : text;
    return l.csvColumn(i + 1, short);
  }

  Widget _columnField(
    AppLocalizations l,
    String label,
    int? value,
    ValueChanged<int?> onChanged, {
    bool optional = false,
  }) => DropdownButtonFormField<int?>(
    initialValue: value,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      if (optional) DropdownMenuItem(value: null, child: Text(l.csvNone)),
      for (var i = 0; i < _columnCount; i++)
        DropdownMenuItem(
          value: i,
          child: Text(_columnName(l, i), overflow: TextOverflow.ellipsis),
        ),
    ],
    onChanged: onChanged,
  );

  void _validate() {
    final date = _date;
    final label = _label;
    final hasAmount = _split
        ? (_debit != null || _credit != null)
        : _amount != null;
    if (date == null || label == null || !hasAmount) {
      setState(() => _incomplete = true);
      return;
    }
    Navigator.pop(
      context,
      CsvColumns(
        delimiter: _delimiter,
        headerRow: _headerRow,
        dateColumn: date,
        labelColumn: label,
        memoColumn: _memo,
        amountColumn: _split ? null : _amount,
        debitColumn: _split ? _debit : null,
        creditColumn: _split ? _credit : null,
        monthFirst: _monthFirst,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const gap = SizedBox(height: 12);
    return AlertDialog(
      title: Text(l.csvTitle),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.csvHelp),
              gap,
              DropdownButtonFormField<String>(
                initialValue: _delimiter,
                decoration: InputDecoration(labelText: l.csvDelimiter),
                items: [
                  const DropdownMenuItem(value: ';', child: Text(';')),
                  const DropdownMenuItem(value: ',', child: Text(',')),
                  DropdownMenuItem(value: '\t', child: Text(l.csvTab)),
                ],
                onChanged: (v) => setState(() {
                  _delimiter = v!;
                  _readRows();
                  _date = _label = _memo = _amount = _debit = _credit = null;
                }),
              ),
              gap,
              DropdownButtonFormField<int>(
                key: ValueKey('header-$_delimiter'),
                initialValue: _headerRow,
                decoration: InputDecoration(labelText: l.csvHeaderRow),
                items: [
                  DropdownMenuItem(value: -1, child: Text(l.csvNoHeader)),
                  for (var i = 0; i < _rows.length; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text(
                        l.csvRowSample(i + 1, _rows[i].join(' | ')),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _headerRow = v!),
              ),
              gap,
              KeyedSubtree(
                key: ValueKey('columns-$_delimiter-$_headerRow'),
                child: Column(
                  children: [
                    _columnField(l, l.csvDate, _date, (v) => _date = v),
                    gap,
                    _columnField(l, l.csvLabel, _label, (v) => _label = v),
                    gap,
                    _columnField(
                      l,
                      l.csvMemo,
                      _memo,
                      (v) => _memo = v,
                      optional: true,
                    ),
                    gap,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SegmentedButton<bool>(
                        segments: [
                          ButtonSegment(
                            value: false,
                            label: Text(l.csvOneColumn),
                          ),
                          ButtonSegment(
                            value: true,
                            label: Text(l.csvDebitCredit),
                          ),
                        ],
                        selected: {_split},
                        onSelectionChanged: (s) =>
                            setState(() => _split = s.first),
                      ),
                    ),
                    gap,
                    if (!_split)
                      _columnField(
                        l,
                        l.csvAmount,
                        _amount,
                        (v) => _amount = v,
                      )
                    else ...[
                      _columnField(
                        l,
                        l.csvDebit,
                        _debit,
                        (v) => _debit = v,
                        optional: true,
                      ),
                      gap,
                      _columnField(
                        l,
                        l.csvCredit,
                        _credit,
                        (v) => _credit = v,
                        optional: true,
                      ),
                    ],
                  ],
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _monthFirst,
                title: Text(l.csvMonthFirst),
                onChanged: (v) => setState(() => _monthFirst = v!),
              ),
              if (_incomplete)
                Text(
                  l.csvIncomplete,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _validate, child: Text(l.validate)),
      ],
    );
  }
}
