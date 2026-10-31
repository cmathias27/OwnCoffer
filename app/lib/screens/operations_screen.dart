import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../util/web_search.dart';
import '../widgets/category_field.dart';
import '../widgets/split_dialog.dart';
import '../widgets/undo.dart';
import 'loans_screen.dart';

/// Operations of one account: search, filters, corrections, manual entry.
class OperationsScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;
  final Account? initialAccount;

  const OperationsScreen({
    super.key,
    required this.membership,
    required this.accounts,
    this.initialAccount,
  });

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  static const _page = 100;
  late Account? _account = widget.initialAccount ?? widget.accounts.firstOrNull;
  final _search = TextEditingController();
  Timer? _debounce;
  var _toClassify = false;
  var _uncleared = false;
  int? _categoryFilter;

  /// Cleaned label of the provider whose operations are listed.
  String? _provider;
  int? _providerSum;
  final List<BankTransaction> _items = [];
  var _total = 0;
  var _loading = false;
  String? _error;
  Map<int, Category> _categories = {};

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _reload();
  }

  @override
  void dispose() {
    _search.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final list = await client.category.list(widget.membership.group.id!);
    if (mounted) setState(() => _categories = {for (final c in list) c.id!: c});
  }

  Future<void> _reload() async {
    _items.clear();
    _total = 0;
    await _more();
  }

  Future<void> _more() async {
    final account = _account;
    if (account == null) return;
    setState(() => (_loading = true, _error = null));
    try {
      final page = await client.transaction.list(
        account.id!,
        search: _search.text,
        sameLabel: _provider,
        toClassify: _toClassify,
        uncleared: _uncleared,
        categoryId: _toClassify ? null : _categoryFilter,
        includeSubcategories: true,
        limit: _page,
        offset: _items.length,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _total = page.total;
        _providerSum = page.amountSumCents;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _replace(BankTransaction t) {
    final i = _items.indexWhere((x) => x.id == t.id);
    if (i >= 0) setState(() => _items[i] = t);
  }

  Future<void> _open(BankTransaction t) async {
    final messenger = ScaffoldMessenger.of(context);
    // Resizable by dragging, always within the screen (small phones,
    // keyboard open): the content scrolls inside the sheet.
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 1,
        snap: true,
        snapSizes: const [0.7],
        // Own messenger: "undo" bars show inside the sheet, above it.
        builder: (_, scroll) => ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _OperationSheet(
              groupId: widget.membership.group.id!,
              messenger: messenger,
              onUndone: _reload,
              operation: t,
              accounts: widget.accounts,
              categories: _categories,
              currency: _account!.currency,
              canWrite: _canWrite,
              onChanged: _replace,
              onSameProvider: () {
                Navigator.of(context).pop();
                setState(() => _provider = t.cleanLabel);
                _reload();
              },
              scrollController: scroll,
            ),
          ),
        ),
      ),
    );
    if (changed == true) await _reload();
  }

  Future<void> _add() async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ManualEntryDialog(
        accountId: _account!.id!,
        categories: _categories,
      ),
    );
    if (saved == true) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final account = _account;
    return Scaffold(
      floatingActionButton: _canWrite && account != null
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.add),
              label: Text(l.operationAdd),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (widget.accounts.length > 1)
                  DropdownButton<int>(
                    value: account?.id,
                    hint: Text(l.chooseAccount),
                    items: [
                      for (final a in widget.accounts)
                        DropdownMenuItem(value: a.id, child: Text(a.name)),
                    ],
                    onChanged: (id) {
                      setState(
                        () => _account = widget.accounts.firstWhere(
                          (a) => a.id == id,
                        ),
                      );
                      _reload();
                    },
                  ),
                SizedBox(
                  width: 280,
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: l.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (_) {
                      _debounce?.cancel();
                      _debounce = Timer(
                        const Duration(milliseconds: 350),
                        _reload,
                      );
                    },
                  ),
                ),
                FilterChip(
                  label: Text(l.filterToClassify),
                  selected: _toClassify,
                  onSelected: (v) {
                    setState(() => _toClassify = v);
                    _reload();
                  },
                ),
                InputChip(
                  avatar: const Icon(Icons.label_outline, size: 18),
                  label: Text(
                    _categories[_categoryFilter] == null
                        ? l.filterCategory
                        : context.categoryName(_categories[_categoryFilter]!),
                  ),
                  selected: _categoryFilter != null,
                  showCheckmark: false,
                  onPressed: () async {
                    final choice = await showCategoryPicker(
                      context,
                      categories: _categories.values.toList(),
                      selected: _categoryFilter,
                    );
                    if (choice == null) return;
                    setState(
                      () => (_categoryFilter = choice.id, _toClassify = false),
                    );
                    _reload();
                  },
                  onDeleted: _categoryFilter == null
                      ? null
                      : () {
                          setState(() => _categoryFilter = null);
                          _reload();
                        },
                ),
                if (_provider != null)
                  InputChip(
                    avatar: const Icon(Icons.storefront_outlined, size: 18),
                    label: Text(l.sameProviderFilter(_provider!)),
                    selected: true,
                    showCheckmark: false,
                    onDeleted: () {
                      setState(() => _provider = null);
                      _reload();
                    },
                  ),
                FilterChip(
                  label: Text(l.filterUncleared),
                  selected: _uncleared,
                  onSelected: (v) {
                    setState(() => _uncleared = v);
                    _reload();
                  },
                ),
                Text(
                  _provider != null && _providerSum != null && _total > 0
                      ? l.sameProviderSummary(
                          _total,
                          context.money(
                            _providerSum!,
                            currency: account?.currency ?? 'EUR',
                          ),
                          context.money(
                            (_providerSum! / _total).round(),
                            currency: account?.currency ?? 'EUR',
                          ),
                        )
                      : l.operationsCount(_total),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _error != null
                ? Center(child: Text(_error!))
                : _items.isEmpty && !_loading
                ? Center(child: Text(l.operationsEmpty))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 96),
                    itemCount: _items.length + 1,
                    itemBuilder: (context, i) {
                      if (i == _items.length) {
                        if (_loading) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return _items.length < _total
                            ? Center(
                                child: TextButton(
                                  onPressed: _more,
                                  child: Text(l.loadMore),
                                ),
                              )
                            : const SizedBox.shrink();
                      }
                      return _OperationTile(
                        operation: _items[i],
                        category: _categories[_items[i].categoryId],
                        currency: account?.currency ?? 'EUR',
                        onTap: () => _open(_items[i]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _OperationTile extends StatelessWidget {
  final BankTransaction operation;
  final Category? category;
  final String currency;
  final VoidCallback onTap;

  const _OperationTile({
    required this.operation,
    required this.category,
    required this.currency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final t = operation;
    final c = category;
    return ListTile(
      onTap: onTap,
      leading: Icon(
        t.cleared ? Icons.check_circle : Icons.radio_button_unchecked,
        color: t.cleared ? theme.colorScheme.primary : theme.disabledColor,
      ),
      title: Text(t.cleanLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${context.shortDay(t.date)} · ${c == null ? l.toClassify : context.categoryName(c)}',
        style: c == null ? TextStyle(color: theme.colorScheme.tertiary) : null,
      ),
      trailing: Text(
        context.money(t.amountCents, currency: currency),
        style: theme.textTheme.titleSmall?.copyWith(
          fontFamily: 'Manrope',
          color: t.amountCents > 0 ? Colors.green.shade700 : null,
        ),
      ),
    );
  }
}

/// Details of an operation: category, rule, checking, note, trash.
class _OperationSheet extends StatefulWidget {
  final int groupId;
  final BankTransaction operation;
  final List<Account> accounts;

  /// The screen's messenger, for actions that close the sheet.
  final ScaffoldMessengerState messenger;

  /// Refreshes the screen after an undo.
  final VoidCallback onUndone;

  /// The screen's categories; a category created here is added to it.
  final Map<int, Category> categories;
  final String currency;
  final bool canWrite;
  final void Function(BankTransaction) onChanged;

  /// Lists the operations with the same cleaned label (closes the sheet).
  final VoidCallback onSameProvider;
  final ScrollController scrollController;

  const _OperationSheet({
    required this.groupId,
    required this.operation,
    required this.accounts,
    required this.messenger,
    required this.onUndone,
    required this.categories,
    required this.currency,
    required this.canWrite,
    required this.onChanged,
    required this.onSameProvider,
    required this.scrollController,
  });

  @override
  State<_OperationSheet> createState() => _OperationSheetState();
}

class _OperationSheetState extends State<_OperationSheet> {
  late BankTransaction _t = widget.operation;
  late final _note = TextEditingController(text: widget.operation.note);
  List<TransactionSplit> _splits = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    client.transaction.splits(widget.operation.id!).then((s) {
      if (mounted) setState(() => _splits = s);
    }, onError: (_) {});
  }

  /// The classification as it is now, to undo a change.
  ({
    int? categoryId,
    CategorySource source,
    String? ruleRef,
    List<TransactionSplit> splits,
  })
  get _snapshot => (
    categoryId: _t.categoryId,
    source: _t.categorySource,
    ruleRef: _t.categoryRuleRef,
    splits: List.of(_splits),
  );

  Future<BankTransaction> _restore(
    ({
      int? categoryId,
      CategorySource source,
      String? ruleRef,
      List<TransactionSplit> splits,
    })
    s,
  ) => client.transaction.restoreClassification(
    _t.id!,
    s.categoryId,
    s.source,
    s.ruleRef,
    s.splits,
  );

  /// Undo inside the sheet: restores and shows the result here.
  void _undoHere(
    String message,
    ({
      int? categoryId,
      CategorySource source,
      String? ruleRef,
      List<TransactionSplit> splits,
    })
    before,
  ) {
    final l = AppLocalizations.of(context);
    showUndo(ScaffoldMessenger.of(context), l, message, () async {
      final t = await _restore(before);
      widget.onChanged(t);
      if (mounted) setState(() => (_t = t, _splits = before.splits));
    });
  }

  Future<void> _split() async {
    final before = _snapshot;
    final t = await showDialog<BankTransaction>(
      context: context,
      builder: (_) => SplitDialog(
        operation: _t,
        current: _splits,
        categories: widget.categories.values.toList(),
        currency: widget.currency,
      ),
    );
    if (t == null || !mounted) return;
    final parts = await client.transaction.splits(t.id!);
    widget.onChanged(t);
    setState(() => (_t = t, _splits = parts));
    if (mounted) {
      _undoHere(AppLocalizations.of(context).splitSaved, before);
    }
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _do(Future<BankTransaction> Function() call) async {
    try {
      final t = await call();
      setState(() => (_t = t, _error = null));
      widget.onChanged(t);
    } on Object catch (e) {
      setState(() => _error = errorText(AppLocalizations.of(context), e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final t = _t;
    return ListView(
      controller: widget.scrollController,
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      children: [
        Text(t.cleanLabel, style: theme.textTheme.titleLarge),
        Text(
          '${context.day(t.date)} · ${context.money(t.amountCents, currency: widget.currency)}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l.bankLabelValue(t.rawLabel),
          style: theme.textTheme.bodySmall,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.storefront_outlined),
            label: Text(l.sameProvider),
            onPressed: widget.onSameProvider,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Tooltip(
            message: l.webSearchHelp,
            child: TextButton.icon(
              icon: const Icon(Icons.travel_explore),
              label: Text(l.webSearch),
              onPressed: () => openWebSearch(t.cleanLabel),
            ),
          ),
        ),
        const SizedBox(height: 8),
        CategoryFormField(
          // Rebuilt with the saved value after each change.
          key: ValueKey('category-${t.categoryId}'),
          categories: widget.categories.values.toList(),
          initialValue: t.categoryId,
          label: l.categoryLabel,
          noneLabel: l.noCategory,
          helperText: t.categoryId == null
              ? null
              : context.categorySourceName(t.categorySource),
          onChanged: widget.canWrite
              ? (id) async {
                  final before = _snapshot;
                  await _do(() => client.transaction.setCategory(t.id!, id));
                  if (!mounted || _error != null) return;
                  setState(() => _splits = []);
                  _undoHere(l.categoryChanged, before);
                }
              : null,
          onCreate: widget.canWrite
              ? (context, name) async {
                  final c = await showNewCategoryDialog(
                    context,
                    groupId: widget.groupId,
                    name: name,
                    kind: t.amountCents < 0
                        ? CategoryKind.expense
                        : CategoryKind.income,
                    categories: widget.categories.values.toList(),
                  );
                  if (c != null) widget.categories[c.id!] = c;
                  return c;
                }
              : null,
        ),
        if (_splits.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.splitPartsSummary(_splits.length),
                  style: theme.textTheme.labelLarge,
                ),
                for (final p in _splits)
                  Text(
                    '${widget.categories[p.categoryId] == null ? l.noCategory : context.categoryName(widget.categories[p.categoryId]!)}'
                    ' · ${context.money(p.amountCents, currency: widget.currency)}'
                    '${p.note == null ? '' : ' · ${p.note}'}',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        if (widget.canWrite)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.call_split),
              label: Text(l.splitAction),
              onPressed: _split,
            ),
          ),
        if (widget.canWrite && t.categoryId != null && _splits.isEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.rule),
              label: Text(l.alwaysClassify),
              onPressed: () async {
                final before = _snapshot;
                try {
                  final r = await client.transaction.createRuleFrom(
                    t.id!,
                    t.categoryId!,
                  );
                  if (!context.mounted) return;
                  Navigator.of(context).pop(true);
                  showUndo(
                    widget.messenger,
                    l,
                    l.ruleCreated(r.reclassifiedCount),
                    () async {
                      // The operation first, so its manual choice no longer
                      // teaches the history.
                      await _restore(before);
                      await client.rule.undoCreate(r.rule.id!);
                    },
                    after: widget.onUndone,
                  );
                } on Object catch (e) {
                  setState(() => _error = errorText(l, e));
                }
              },
            ),
          ),
        if (widget.canWrite && t.amountCents < 0)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.autorenew),
              label: Text(
                t.scheduledId == null
                    ? l.subscriptionFromOperation
                    : l.subscriptionMarkPlanned,
              ),
              onPressed: () async {
                final wasPlanned = t.scheduledId != null;
                try {
                  final s = await client.scheduled.subscribeFrom(t.id!);
                  if (!context.mounted) return;
                  Navigator.of(context).pop(true);
                  showUndo(
                    widget.messenger,
                    l,
                    l.subscriptionCreated(
                      s.label,
                      s.nextDue == null ? '' : context.day(s.nextDue!),
                    ),
                    () => wasPlanned
                        ? client.scheduled
                              .update(s.id!, subscription: false)
                              .then((_) {})
                        : client.scheduled.delete(s.id!),
                    after: widget.onUndone,
                  );
                } on Object catch (e) {
                  setState(() => _error = errorText(l, e));
                }
              },
            ),
          ),
        if (widget.canWrite && t.amountCents < 0)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.account_balance_outlined),
              label: Text(l.loanFromOperation),
              onPressed: () async {
                final before = _snapshot;
                final r = await Navigator.of(context).push<LoanFromOperation>(
                  MaterialPageRoute(
                    builder: (_) => LoanFormScreen(
                      groupId: widget.groupId,
                      accounts: widget.accounts,
                      fromOperation: t,
                      categories: widget.categories.values.toList(),
                    ),
                  ),
                );
                if (r == null || !context.mounted) return;
                Navigator.of(context).pop(true);
                showUndo(
                  widget.messenger,
                  l,
                  l.loanFromOperationDone(r.linkedCount, r.reclassifiedCount),
                  () async {
                    await _restore(before);
                    await client.loan.undoCreate(r.info.loan.id!);
                  },
                  after: widget.onUndone,
                );
              },
            ),
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.cleared),
          value: t.cleared,
          onChanged: widget.canWrite
              ? (v) async {
                  final messenger = ScaffoldMessenger.of(context);
                  await _do(() => client.transaction.setCleared(t.id!, v));
                  if (!mounted || _error != null) return;
                  showUndo(
                    messenger,
                    l,
                    l.clearedChanged,
                    () async {
                      final back = await client.transaction.setCleared(
                        t.id!,
                        !v,
                      );
                      widget.onChanged(back);
                      if (mounted) setState(() => _t = back);
                    },
                  );
                }
              : null,
        ),
        TextField(
          controller: _note,
          enabled: widget.canWrite,
          decoration: InputDecoration(labelText: l.noteLabel),
          onSubmitted: (v) =>
              _do(() => client.transaction.update(t.id!, note: v)),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        if (widget.canWrite)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: Text(l.trash),
                onPressed: () async {
                  await client.transaction.trash(t.id!);
                  if (!context.mounted) return;
                  Navigator.of(context).pop(true);
                  showUndo(
                    widget.messenger,
                    l,
                    l.trashed,
                    () => client.transaction.restore(t.id!).then((_) {}),
                    after: widget.onUndone,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _ManualEntryDialog extends StatefulWidget {
  final int accountId;
  final Map<int, Category> categories;
  const _ManualEntryDialog({required this.accountId, required this.categories});

  @override
  State<_ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<_ManualEntryDialog> {
  final _amount = TextEditingController();
  final _label = TextEditingController();
  var _date = todayUtcMidnight();
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _label.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final cents = parseUserAmount(_amount.text);
    if (cents == null || cents == 0) {
      setState(() => _error = l.amountInvalid);
      return;
    }
    setState(() => (_busy = true, _error = null));
    try {
      await client.transaction.create(
        widget.accountId,
        _date,
        cents,
        _label.text,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (e) {
      setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.operationAdd),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(l.dateValue(context.day(_date))),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(_date.year, _date.month, _date.day),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(
                    () => _date = DateTime.utc(
                      picked.year,
                      picked.month,
                      picked.day,
                    ),
                  );
                }
              },
            ),
            TextField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l.amountLabel,
                helperText: l.amountHelp,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _label,
              decoration: InputDecoration(labelText: l.labelLabel),
              onSubmitted: (_) => _save(),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _busy ? null : _save, child: Text(l.save)),
      ],
    );
  }
}
