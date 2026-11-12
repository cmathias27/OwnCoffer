import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../state/ui_prefs.dart';
import '../l10n/app_localizations.dart';
import '../widgets/soft.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../util/offline.dart';
import '../util/outbox.dart';
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

  /// Opened from elsewhere for one purpose (search, filter, new operation).
  final OperationsIntent? intent;

  const OperationsScreen({
    super.key,
    required this.membership,
    required this.accounts,
    this.initialAccount,
    this.intent,
  });

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

/// Why the operations are opened: a search, the operations to classify,
/// the subscriptions, or a new operation to enter at once.
class OperationsIntent {
  final String? search;
  final bool toClassify;
  final bool subscriptions;
  final bool add;
  const OperationsIntent({
    this.search,
    this.toClassify = false,
    this.subscriptions = false,
    this.add = false,
  });
}

/// The remembered filters (decision 0041, point 20), kept on the device as
/// `toClassify,uncleared,subscriptions,category`.
({bool toClassify, bool uncleared, bool subscriptions, int? category})
decodeOperationFilters(String s) {
  final parts = s.split(',');
  bool on(int i) => parts.length > i && parts[i] == '1';
  return (
    toClassify: on(0),
    uncleared: on(1),
    subscriptions: on(2),
    category: parts.length > 3 ? int.tryParse(parts[3]) : null,
  );
}

String encodeOperationFilters({
  required bool toClassify,
  required bool uncleared,
  required bool subscriptions,
  int? category,
}) => [
  toClassify ? '1' : '0',
  uncleared ? '1' : '0',
  subscriptions ? '1' : '0',
  category?.toString() ?? '',
].join(',');

class _OperationsScreenState extends State<OperationsScreen> {
  static const _page = 100;
  // The account opened last on this device (decision 0041, point 9).
  late Account? _account =
      widget.initialAccount ??
      widget.accounts.where((a) => a.id == uiPrefs.accountId).firstOrNull ??
      widget.accounts.firstOrNull;
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
    final intent = widget.intent;
    if (intent != null) {
      _search.text = intent.search ?? '';
      _toClassify = intent.toClassify;
      _subscriptionsOnly = intent.subscriptions;
    } else {
      final f = decodeOperationFilters(uiPrefs.operationFilters);
      _toClassify = f.toClassify;
      _uncleared = f.uncleared;
      _subscriptionsOnly = f.subscriptions;
      _categoryFilter = f.toClassify ? null : f.category;
    }
    if (intent?.add ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadCategories();
        if (mounted && _account != null && _canWrite) await _add();
      });
    } else {
      _loadCategories();
    }
    _reload();
    // Operations entered offline reached the server.
    outbox.sent.addListener(_reload);
  }

  @override
  void dispose() {
    outbox.sent.removeListener(_reload);
    _search.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final List<Category> list;
    try {
      list = await client.category.list(widget.membership.group.id!);
    } on Object {
      // Offline with no kept copy: operations are shown without categories.
      return;
    }
    if (mounted) setState(() => _categories = {for (final c in list) c.id!: c});
  }

  bool get _filtered =>
      _search.text.trim().isNotEmpty ||
      _toClassify ||
      _uncleared ||
      _subscriptionsOnly ||
      _categoryFilter != null;

  /// Nothing to show: either the filters hide everything, or the account
  /// has no operation yet (decision 0041, point 13).
  Widget _empty(AppLocalizations l, Account? account) => _filtered
      ? EmptyState(
          icon: Icons.filter_alt_off_outlined,
          text: l.emptyOperationsFiltered,
          actionLabel: l.emptyClearFilters,
          onAction: _clearFilters,
        )
      : EmptyState(
          icon: Icons.receipt_long_outlined,
          text: l.operationsEmpty,
          hint: l.emptyOperationsHint,
          actionLabel: _canWrite && account != null ? l.operationAdd : null,
          onAction: _canWrite && account != null ? _add : null,
        );

  void _clearFilters() {
    _search.clear();
    setState(() {
      _toClassify = false;
      _uncleared = false;
      _subscriptionsOnly = false;
      _categoryFilter = null;
    });
    _reload();
  }

  Future<void> _reload() async {
    unawaited(
      uiPrefs.setOperationFilters(
        encodeOperationFilters(
          toClassify: _toClassify,
          uncleared: _uncleared,
          subscriptions: _subscriptionsOnly,
          category: _categoryFilter,
        ),
      ),
    );
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
      onSubscriptionChanged: (s) {
        if (mounted && _subscriptions.containsKey(s.id)) {
          setState(() => _subscriptions[s.id!] = s);
        }
      },
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

  /// Swipe right: the category at once, with undo.
  Future<void> _classify(BankTransaction t) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final choice = await showCategoryPicker(
      context,
      categories: _categories.values.toList(),
      selected: t.categoryId,
    );
    if (choice == null || !mounted || choice.id == t.categoryId) return;
    try {
      final saved = await client.transaction.setCategory(t.id!, choice.id);
      if (!mounted) return;
      _classified(saved);
      showUndo(
        messenger,
        l,
        l.categoryChanged,
        () => client.transaction.setCategory(t.id!, t.categoryId),
        after: () {
          if (mounted) _reload();
        },
      );
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  void _classified(BankTransaction t) => setState(() {
    final i = _items.indexWhere((x) => x.id == t.id);
    // Classified: no longer in the operations to classify.
    if (i >= 0) {
      if (_toClassify && t.categoryId != null) {
        _items.removeAt(i);
        _total--;
      } else {
        _items[i] = t;
      }
    }
  });

  Widget _swipeBackground(
    BuildContext context,
    IconData icon,
    String label,
    Alignment alignment,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.secondaryContainer,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: scheme.onSecondaryContainer),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: scheme.onSecondaryContainer)),
        ],
      ),
    );
  }

  Future<void> _add() async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ManualEntryDialog(
        account: _account!,
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
                      unawaited(uiPrefs.setAccountId(id));
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
          if (_subscriptionsOnly)
            _subscriptionsSummaryCard(context, l, theme, account),
          Expanded(
            child: _error != null
                ? Center(child: Text(_error!))
                : _items.isEmpty && !_loading
                ? _empty(l, account)
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
                      final op = _items[i];
                      final sub = _subscriptions[op.scheduledId];
                      final isRise =
                          sub != null &&
                          op.amountCents.abs() > sub.amountCents.abs();
                      final diff = isRise
                          ? (op.amountCents.abs() - sub.amountCents.abs())
                          : null;
                      final tile = OperationTile(
                        selected: _selected.isEmpty
                            ? null
                            : _selected.contains(op.id),
                        onLongPress: _canWrite ? () => _select(op) : null,
                        onToggleCleared: _canWrite
                            ? () => _toggleCleared(op)
                            : null,
                        operation: op,
                        category: _categories[op.categoryId],
                        subscription: sub != null,
                        priceRiseDiffCents: diff,
                        hasInvoice: _withInvoices.contains(op.id),
                        currency: account?.currency ?? 'EUR',
                        onTap: () =>
                            _selected.isEmpty ? _open(op) : _select(op),
                      );
                      if (!_canWrite ||
                          _selected.isNotEmpty ||
                          MediaQuery.sizeOf(context).width >= 600) {
                        return tile;
                      }
                      return Dismissible(
                        key: ValueKey('swipe-${op.id}'),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            await _classify(op);
                          } else {
                            await _open(op);
                          }
                          return false;
                        },
                        background: _swipeBackground(
                          context,
                          Icons.label_outline,
                          l.classifyNow,
                          Alignment.centerLeft,
                        ),
                        secondaryBackground: _swipeBackground(
                          context,
                          Icons.open_in_new,
                          l.swipeOpen,
                          Alignment.centerRight,
                        ),
                        child: tile,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionsSummaryCard(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
    Account? account,
  ) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final active = _subscriptions.values
        .where(
          (s) =>
              s.subscription &&
              (s.endDate == null || !s.endDate!.isBefore(today)),
        )
        .toList();
    final monthlyTotal = active.fold<int>(
      0,
      (sum, s) =>
          sum +
          core.monthlyEquivalentCents(
            s.amountCents,
            core.Frequency.values.byName(s.frequency.name),
            s.interval,
          ),
    );
    final upcomingRises =
        active
            .where(
              (s) =>
                  s.priceRiseDate != null &&
                  s.priceRiseAmountCents != null &&
                  !s.priceRiseDate!.isBefore(
                    today.subtract(const Duration(days: 7)),
                  ),
            )
            .toList()
          ..sort((a, b) => a.priceRiseDate!.compareTo(b.priceRiseDate!));

    final curr = account?.currency ?? 'EUR';
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      color: theme.colorScheme.surfaceContainerHighest,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.autorenew,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.subscriptionMonthlyTotal(
                          context.money(monthlyTotal.abs(), currency: curr),
                        ),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l.subscriptionMonthlyCount(active.length),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _openSubscriptions,
                  child: Text(l.subscriptionsOpen),
                ),
              ],
            ),
            if (upcomingRises.isNotEmpty) ...[
              const Divider(height: 16),
              for (final rise in upcomingRises) ...[
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.campaign_outlined,
                        size: 20,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.subscriptionUpcomingRiseAlert(
                            context.shortDay(rise.priceRiseDate!),
                            rise.label,
                            context.money(
                              rise.priceRiseAmountCents!.abs(),
                              currency: curr,
                            ),
                            context.money(
                              (rise.priceRiseAmountCents!.abs() -
                                      rise.amountCents.abs())
                                  .abs(),
                              currency: curr,
                            ),
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (_canWrite && !rise.priceRiseDate!.isAfter(today))
                        TextButton(
                          onPressed: () async {
                            try {
                              await client.scheduled.applyPriceRise(rise.id!);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l.subscriptionAmountUpdated(
                                        context.money(
                                          rise.priceRiseAmountCents!.abs(),
                                          currency: curr,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                _reload();
                              }
                            } on Object catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorText(l, e))),
                                );
                              }
                            }
                          },
                          child: Text(l.subscriptionApplyRiseAction),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ManualEntryDialog extends StatefulWidget {
  final Account account;
  final Map<int, Category> categories;
  const _ManualEntryDialog({required this.account, required this.categories});

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
    // Known offline: kept at once, sent when the server answers.
    if (offlineSince.value != null && await _keep()) return;
    try {
      await client.transaction.create(
        widget.account.id!,
        _date,
        cents,
        _label.text,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (e) {
      if (cannotReach(e) && await _keep()) return;
      if (mounted) setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  /// Offline entry (decision 0038): the operation waits on the device.
  Future<bool> _keep() async {
    final kept = await outbox.keep(
      accountId: widget.account.id!,
      accountName: widget.account.name,
      date: _date,
      amountCents: parseUserAmount(_amount.text)!,
      label: _label.text,
    );
    if (!kept || !mounted) return kept;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).outboxKept)),
    );
    Navigator.of(context).pop(false);
    return true;
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
