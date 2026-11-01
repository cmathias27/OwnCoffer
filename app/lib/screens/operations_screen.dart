import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/category_field.dart';
import '../widgets/operation_sheet.dart';
import '../widgets/operation_tile.dart';
import '../widgets/undo.dart';
import 'subscriptions_screen.dart';
import 'trash_screen.dart';

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
  var _subscriptionsOnly = false;

  /// Subscriptions of the account, by id: their operations are marked.
  Map<int, ScheduledTransaction> _subscriptions = {};

  /// Operations with at least one invoice: marked with a clip.
  final Set<int> _withInvoices = {};
  int? _categoryFilter;

  /// Cleaned label of the provider whose operations are listed.
  String? _provider;
  int? _providerSum;
  final List<BankTransaction> _items = [];

  /// Operations selected to be checked together (empty: not selecting).
  final Set<int> _selected = {};
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
    _withInvoices.clear();
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
        subscriptions: _subscriptionsOnly,
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
        _subscriptions = {for (final s in page.subscriptions) s.id!: s};
        _withInvoices.addAll(page.withInvoices);
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Checks or unchecks one operation from the list, with undo.
  Future<void> _toggleCleared(BankTransaction t) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await client.transaction.setCleared(t.id!, !t.cleared);
      _replace(updated);
      showUndo(
        messenger,
        l,
        updated.cleared ? l.checkedOne : l.uncheckedOne,
        () => client.transaction.setCleared(t.id!, t.cleared).then(_replace),
      );
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  void _select(BankTransaction t) => setState(
    () => _selected.contains(t.id)
        ? _selected.remove(t.id)
        : _selected.add(t.id!),
  );

  /// Checks or unchecks the selected operations at once, with undo.
  Future<void> _clearSelected(bool cleared) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ids = _selected.toList();
    try {
      final before = await client.transaction.setClearedMany(ids, cleared);
      setState(() {
        for (var i = 0; i < _items.length; i++) {
          if (_selected.contains(_items[i].id)) {
            _items[i] = _items[i].copyWith(cleared: cleared);
          }
        }
        _selected.clear();
      });
      showUndo(
        messenger,
        l,
        cleared ? l.checkedMany(ids.length) : l.uncheckedMany(ids.length),
        () async {
          // Back to how each one was.
          for (final state in [true, false]) {
            final group = [
              for (final t in before)
                if (t.cleared == state) t.id!,
            ];
            if (group.isNotEmpty) {
              await client.transaction.setClearedMany(group, state);
            }
          }
        },
        after: _reload,
      );
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  /// While selecting: how many, all, check, uncheck, stop.
  Widget _selectionBar(BuildContext context, AppLocalizations l) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Material(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              IconButton(
                tooltip: l.selectionStop,
                icon: const Icon(Icons.close),
                onPressed: () => setState(_selected.clear),
              ),
              Text(l.selectedCount(_selected.length)),
              TextButton(
                onPressed: () => setState(
                  () => _selected.addAll([for (final t in _items) t.id!]),
                ),
                child: Text(l.selectAll),
              ),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.check_circle_outline),
                label: Text(l.checkSelected),
                onPressed: () => _clearSelected(true),
              ),
              TextButton.icon(
                icon: const Icon(Icons.radio_button_unchecked),
                label: Text(l.uncheckSelected),
                onPressed: () => _clearSelected(false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _replace(BankTransaction t) {
    final i = _items.indexWhere((x) => x.id == t.id);
    if (i >= 0) setState(() => _items[i] = t);
  }

  Future<void> _open(BankTransaction t) async {
    final changed = await showOperationSheet(
      context,
      membership: widget.membership,
      operation: t,
      accounts: widget.accounts,
      categories: _categories,
      subscription: _subscriptions[t.scheduledId],
      onUndone: _reload,
      onChanged: _replace,
      onOpenSubscriptions: _openSubscriptions,
      onHasInvoices: (has) => setState(
        () => has ? _withInvoices.add(t.id!) : _withInvoices.remove(t.id!),
      ),
      onSameProvider: () {
        setState(() => _provider = t.cleanLabel);
        _reload();
      },
    );
    if (changed) await _reload();
  }

  Future<void> _openSubscriptions() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SubscriptionsScreen(
          membership: widget.membership,
          accounts: widget.accounts,
        ),
      ),
    );
    // A subscription may have been stopped or unmarked there.
    if (mounted) await _reload();
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
                FilterChip(
                  avatar: _subscriptionsOnly
                      ? null
                      : const Icon(Icons.autorenew, size: 18),
                  label: Text(l.filterSubscriptions),
                  selected: _subscriptionsOnly,
                  onSelected: (v) {
                    setState(() => _subscriptionsOnly = v);
                    _reload();
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.list_alt, size: 18),
                  label: Text(l.subscriptionsOpen),
                  onPressed: _openSubscriptions,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(l.trashTitle),
                  onPressed: () async {
                    final changed = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => TrashScreen(
                          membership: widget.membership,
                          accounts: widget.accounts,
                        ),
                      ),
                    );
                    if (changed == true) _reload();
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
          if (_selected.isNotEmpty)
            _selectionBar(context, l)
          else if (_canWrite && _items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(
                l.operationsSelectHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
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
                      return OperationTile(
                        selected: _selected.isEmpty
                            ? null
                            : _selected.contains(_items[i].id),
                        onLongPress: _canWrite
                            ? () => _select(_items[i])
                            : null,
                        onToggleCleared: _canWrite
                            ? () => _toggleCleared(_items[i])
                            : null,
                        operation: _items[i],
                        category: _categories[_items[i].categoryId],
                        subscription: _subscriptions.containsKey(
                          _items[i].scheduledId,
                        ),
                        hasInvoice: _withInvoices.contains(_items[i].id),
                        currency: account?.currency ?? 'EUR',
                        onTap: () => _selected.isEmpty
                            ? _open(_items[i])
                            : _select(_items[i]),
                      );
                    },
                  ),
          ),
        ],
      ),
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
