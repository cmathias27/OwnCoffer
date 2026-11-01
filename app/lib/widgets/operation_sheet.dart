import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../screens/loans_screen.dart';
import '../util/format.dart';
import '../util/web_search.dart';
import 'category_field.dart';
import 'invoices.dart';
import 'split_dialog.dart';
import 'undo.dart';

/// Opens the details of [operation] in a sheet that can be resized by
/// dragging, always within the screen (small phones, keyboard open).
/// [onOpenSubscriptions] and [onSameProvider] close the sheet first.
///
/// Returns whether the operation was moved, trashed or attached elsewhere
/// (the caller then reloads); [onChanged] reports the smaller changes.
Future<bool> showOperationSheet(
  BuildContext context, {
  required GroupMembership membership,
  required BankTransaction operation,
  required List<Account> accounts,
  required Map<int, Category> categories,
  required VoidCallback onUndone,
  required void Function(BankTransaction) onChanged,
  ScheduledTransaction? subscription,
  VoidCallback? onOpenSubscriptions,
  ValueChanged<bool>? onHasInvoices,
  VoidCallback? onSameProvider,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final currency =
      accounts
          .where((a) => a.id == operation.accountId)
          .firstOrNull
          ?.currency ??
      'EUR';
  VoidCallback? closing(VoidCallback? then) => then == null
      ? null
      : () {
          Navigator.of(context).pop();
          then();
        };
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
          body: OperationSheet(
            groupId: membership.group.id!,
            messenger: messenger,
            onUndone: onUndone,
            operation: operation,
            subscription: subscription,
            onOpenSubscriptions: closing(onOpenSubscriptions),
            accounts: accounts,
            categories: categories,
            currency: currency,
            canWrite: membership.role != MemberRole.reader,
            onChanged: onChanged,
            onHasInvoices: onHasInvoices,
            onSameProvider: closing(onSameProvider),
            scrollController: scroll,
          ),
        ),
      ),
    ),
  );
  return changed == true;
}

/// Details of an operation: category, rule, checking, note, trash. Shown
/// by the Operations page and wherever an operation is listed (Budget).
class OperationSheet extends StatefulWidget {
  final int groupId;
  final BankTransaction operation;
  final List<Account> accounts;

  /// The screen's messenger, for actions that close the sheet.
  final ScaffoldMessengerState messenger;

  /// Refreshes the screen after an undo.
  final VoidCallback onUndone;

  /// The subscription this operation realises, if any.
  final ScheduledTransaction? subscription;

  /// Opens the subscriptions list (closes the sheet).
  final VoidCallback? onOpenSubscriptions;

  /// The screen's categories; a category created here is added to it.
  final Map<int, Category> categories;
  final String currency;
  final bool canWrite;
  final void Function(BankTransaction) onChanged;

  /// Whether the operation has invoices, after one is added or deleted.
  final ValueChanged<bool>? onHasInvoices;

  /// Lists the operations with the same cleaned label (closes the sheet);
  /// hidden when null.
  final VoidCallback? onSameProvider;
  final ScrollController scrollController;

  const OperationSheet({
    super.key,
    required this.groupId,
    required this.operation,
    required this.accounts,
    required this.messenger,
    required this.onUndone,
    required this.subscription,
    this.onOpenSubscriptions,
    required this.categories,
    required this.currency,
    required this.canWrite,
    required this.onChanged,
    this.onHasInvoices,
    this.onSameProvider,
    required this.scrollController,
  });

  @override
  State<OperationSheet> createState() => _OperationSheetState();
}

class _OperationSheetState extends State<OperationSheet> {
  late BankTransaction _t = widget.operation;
  late ScheduledTransaction? _subscription = _subscription;
  late final _note = TextEditingController(text: widget.operation.note);
  List<TransactionSplit> _splits = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    client.transaction.splits(widget.operation.id!).then((s) {
      if (mounted) setState(() => _splits = s);
    }, onError: (_) {});
    // Opened from another page: find the subscription it realises.
    final planned = widget.operation.scheduledId;
    if (_subscription == null && planned != null) {
      client.scheduled.list(widget.operation.accountId).then((list) {
        final s = list.where((s) => s.id == planned && s.subscription);
        if (mounted && s.isNotEmpty) setState(() => _subscription = s.first);
      }, onError: (_) {});
    }
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
        if (_subscription != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(
                  avatar: Icon(
                    Icons.autorenew,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    l.subscriptionOfOperation(_subscription!.label),
                  ),
                ),
                if (widget.onOpenSubscriptions != null)
                  TextButton(
                    onPressed: widget.onOpenSubscriptions,
                    child: Text(l.subscriptionsOpen),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Text(
          l.bankLabelValue(t.rawLabel),
          style: theme.textTheme.bodySmall,
        ),
        if (widget.onSameProvider != null)
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
        if (widget.canWrite && t.amountCents < 0 && _subscription == null)
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
                // A loan already entered, or a new one.
                final loans = await client.loan
                    .overview(widget.groupId)
                    .then((o) => o.loans, onError: (_) => <LoanInfo>[]);
                if (!context.mounted) return;
                if (loans.isNotEmpty) {
                  final choice = await showDialog<({LoanInfo? loan})>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text(l.loanAttachTitle),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                          child: Text(l.loanAttachHelp),
                        ),
                        for (final info in loans)
                          SimpleDialogOption(
                            onPressed: () =>
                                Navigator.of(context).pop((loan: info)),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.account_balance_outlined,
                              ),
                              title: Text(
                                info.loan.label == null
                                    ? info.loan.lender
                                    : '${info.loan.lender} · ${info.loan.label}',
                              ),
                              subtitle: Text(
                                '${loanKindText(l, info.loan.kind)} · '
                                '${context.money(info.paymentCents + info.loan.insuranceMonthlyCents)}',
                              ),
                            ),
                          ),
                        SimpleDialogOption(
                          onPressed: () =>
                              Navigator.of(context).pop((loan: null)),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.add),
                            title: Text(l.loanAttachNew),
                          ),
                        ),
                      ],
                    ),
                  );
                  // Dismissed without a choice: nothing.
                  if (choice == null || !context.mounted) return;
                  final picked = choice.loan;
                  if (picked != null) {
                    try {
                      final r = await client.loan.attachTransaction(
                        picked.loan.id!,
                        t.id!,
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pop(true);
                      showUndo(
                        widget.messenger,
                        l,
                        l.loanAttachDone(r.linkedCount, r.reclassifiedCount),
                        () async {
                          await _restore(before);
                          await client.loan.undoAttach(
                            picked.loan.id!,
                            t.id!,
                            ruleId: r.ruleId,
                          );
                        },
                        after: widget.onUndone,
                      );
                    } on Object catch (e) {
                      setState(() => _error = errorText(l, e));
                    }
                    return;
                  }
                }
                if (!context.mounted) return;
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
        InvoiceSection(
          transactionId: t.id!,
          canWrite: widget.canWrite,
          onHasInvoices: widget.onHasInvoices ?? (_) {},
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
