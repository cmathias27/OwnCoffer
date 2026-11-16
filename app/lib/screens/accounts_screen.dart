import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../widgets/soft.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/balance_check_dialog.dart';

/// Accounts of the group with their balance and 30-day forecast.
class AccountsScreen extends StatefulWidget {
  final GroupMembership membership;
  final void Function(Account account) onOpen;

  const AccountsScreen({
    super.key,
    required this.membership,
    required this.onOpen,
  });

  @override
  State<AccountsScreen> createState() => AccountsScreenState();
}

class AccountsScreenState extends State<AccountsScreen> {
  List<(Account, ForecastResult?)>? _rows;
  String? _error;

  bool get _isAdmin => widget.membership.role == MemberRole.admin;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(AccountsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membership.group.id != widget.membership.group.id) reload();
  }

  Future<void> reload() async {
    try {
      final accounts = await client.account.list(widget.membership.group.id!);
      final today = todayUtcMidnight();
      final forecasts = await Future.wait([
        for (final a in accounts)
          client.scheduled
              .forecast(a.id!, today)
              .then<ForecastResult?>((f) => f, onError: (_) => null),
      ]);
      if (!mounted) return;
      setState(() {
        _rows = [
          for (var i = 0; i < accounts.length; i++) (accounts[i], forecasts[i]),
        ];
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _edit([Account? account]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => AccountDialog(
        groupId: widget.membership.group.id!,
        account: account,
        existingAccounts: _rows?.map((r) => r.$1).toList(),
      ),
    );
    if (saved == true) await reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = _rows;
    return Scaffold(
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _edit,
              icon: const Icon(Icons.add),
              label: Text(l.accountAdd),
            )
          : null,
      body: _error != null
          ? Center(child: Text(_error!))
          : rows == null
          ? const Center(child: CircularProgressIndicator())
          : rows.isEmpty
          ? EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              text: l.accountsEmpty,
              hint: l.emptyAccountsHint,
              actionLabel: _isAdmin ? l.accountAdd : null,
              onAction: _isAdmin ? () => _edit() : null,
            )
          : RefreshIndicator(
              onRefresh: reload,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  for (final (a, f) in rows)
                    _AccountCard(
                      account: a,
                      forecast: f,
                      onTap: () => widget.onOpen(a),
                      onEdit: _isAdmin ? () => _edit(a) : null,
                      onCheck: widget.membership.role == MemberRole.reader
                          ? null
                          : () => showDialog<void>(
                              context: context,
                              builder: (_) => BalanceCheckDialog(account: a),
                            ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final Account account;
  final ForecastResult? forecast;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onCheck;

  const _AccountCard({
    required this.account,
    required this.forecast,
    required this.onTap,
    required this.onEdit,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final f = forecast;
    final overdraft = f?.firstBelowThresholdDate;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      account.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (account.visibility == AccountVisibility.restricted)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.lock_outline, size: 18),
                    ),
                  if (onCheck != null)
                    IconButton(
                      tooltip: l.balanceCheckAction,
                      icon: const Icon(Icons.fact_check_outlined),
                      onPressed: onCheck,
                    ),
                  if (onEdit != null)
                    IconButton(
                      tooltip: l.accountEdit,
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: onEdit,
                    ),
                ],
              ),
              if (f == null)
                Text(
                  l.forecastUnavailable,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              if (f != null) ...[
                if (account.kind == AccountKind.deferredCard) ...[
                  Text(
                    l.deferredCardOutstanding,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    context.money(
                      f.currentBalanceCents,
                      currency: account.currency,
                    ),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: f.currentBalanceCents < 0
                          ? theme.colorScheme.error
                          : null,
                    ),
                  ),
                  if (f.deferredCutoffDate != null &&
                      f.deferredDebitDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        l.deferredCardCycleInfo(
                          context.shortDay(f.deferredCutoffDate!),
                          context.shortDay(f.deferredDebitDate!),
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  if (f.deferredPendingDebitCents != null &&
                      f.deferredPendingDebitDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l.deferredCardPendingDebit(
                            context.shortDay(f.deferredPendingDebitDate!),
                            context.money(
                              f.deferredPendingDebitCents!,
                              currency: account.currency,
                            ),
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ] else ...[
                  Text(
                    context.money(
                      f.currentBalanceCents,
                      currency: account.currency,
                    ),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: f.currentBalanceCents < 0
                          ? theme.colorScheme.error
                          : null,
                    ),
                  ),
                  Text(
                    l.clearedBalanceValue(
                      context.money(
                        f.clearedBalanceCents,
                        currency: account.currency,
                      ),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.forecastLowest(
                      context.money(
                        f.lowestBalanceCents,
                        currency: account.currency,
                      ),
                      context.shortDay(f.lowestDate),
                    ),
                  ),
                  if (overdraft != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.overdraftExpected(context.day(overdraft)),
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Create or edit an account (administrators).
class AccountDialog extends StatefulWidget {
  final int groupId;
  final Account? account;
  final List<Account>? existingAccounts;

  const AccountDialog({
    super.key,
    required this.groupId,
    this.account,
    this.existingAccounts,
  });

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  late final _name = TextEditingController(text: widget.account?.name);
  late final _bank = TextEditingController(
    text: widget.account?.bank ?? "Caisse d'Épargne",
  );
  late final _initial = TextEditingController(
    text: _plain(widget.account?.initialBalanceCents ?? 0),
  );
  late final _threshold = TextEditingController(
    text: _plain(widget.account?.alertThresholdCents ?? 0),
  );
  late final _cutoffDay = TextEditingController(
    text: widget.account?.statementCutoffDay?.toString() ?? '',
  );
  late final _debitDay = TextEditingController(
    text: widget.account?.statementDebitDay?.toString() ?? '',
  );
  late int? _linkedAccountId = widget.account?.linkedAccountId;
  late var _kind = widget.account?.kind ?? AccountKind.checking;
  late var _restricted =
      widget.account?.visibility == AccountVisibility.restricted;
  String? _error;
  var _busy = false;

  static String _plain(int cents) {
    final abs = cents.abs();
    final s = '${abs ~/ 100},${(abs % 100).toString().padLeft(2, '0')}';
    return cents < 0 ? '-$s' : s;
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _bank,
      _initial,
      _threshold,
      _cutoffDay,
      _debitDay,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final initial = parseUserAmount(_initial.text);
    final threshold = parseUserAmount(_threshold.text);
    if (initial == null || threshold == null) {
      setState(() => _error = l.amountInvalid);
      return;
    }
    int? cutoff;
    int? debit;
    if (_kind == AccountKind.deferredCard) {
      if (_cutoffDay.text.trim().isNotEmpty) {
        cutoff = int.tryParse(_cutoffDay.text.trim());
        if (cutoff == null || cutoff < 1 || cutoff > 31) {
          setState(() => _error = l.amountInvalid);
          return;
        }
      }
      if (_debitDay.text.trim().isNotEmpty) {
        debit = int.tryParse(_debitDay.text.trim());
        if (debit == null || debit < 1 || debit > 31) {
          setState(() => _error = l.amountInvalid);
          return;
        }
      }
    }
    setState(() => (_busy = true, _error = null));
    try {
      final visibility = _restricted
          ? AccountVisibility.restricted
          : AccountVisibility.shared;
      final a = widget.account;
      if (a == null) {
        await client.account.create(
          widget.groupId,
          _name.text,
          _kind,
          bank: _bank.text,
          initialBalanceCents: initial,
          alertThresholdCents: threshold,
          visibility: visibility,
          statementCutoffDay: cutoff,
          statementDebitDay: debit,
          linkedAccountId: _linkedAccountId,
        );
      } else {
        await client.account.update(
          a.id!,
          name: _name.text,
          bank: _bank.text,
          clearBank: _bank.text.trim().isEmpty,
          initialBalanceCents: initial,
          alertThresholdCents: threshold,
          visibility: visibility,
          statementCutoffDay: cutoff,
          clearStatementCutoffDay: cutoff == null,
          statementDebitDay: debit,
          clearStatementDebitDay: debit == null,
          linkedAccountId: _linkedAccountId,
          clearLinkedAccountId: _linkedAccountId == null,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (e) {
      setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String kindName(AccountKind k) => switch (k) {
      AccountKind.checking => l.kindChecking,
      AccountKind.savings => l.kindSavings,
      AccountKind.deferredCard => l.kindDeferredCard,
      AccountKind.cash => l.kindCash,
    };
    return AlertDialog(
      title: Text(widget.account == null ? l.accountAdd : l.accountEdit),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _name,
                autofocus: true,
                decoration: InputDecoration(labelText: l.accountName),
              ),
              const SizedBox(height: 12),
              if (widget.account == null)
                DropdownButtonFormField<AccountKind>(
                  isExpanded: true,
                  initialValue: _kind,
                  decoration: InputDecoration(labelText: l.accountKind),
                  items: [
                    for (final k in AccountKind.values)
                      DropdownMenuItem(value: k, child: Text(kindName(k))),
                  ],
                  onChanged: (k) => setState(() => _kind = k ?? _kind),
                ),
              if (_kind == AccountKind.deferredCard) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cutoffDay,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l.deferredCardCutoffDay,
                          helperText: l.deferredCardCutoffDayHelp,
                          helperMaxLines: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _debitDay,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l.deferredCardDebitDay,
                          helperText: l.deferredCardDebitDayHelp,
                          helperMaxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.existingAccounts != null &&
                    widget.existingAccounts!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    isExpanded: true,
                    initialValue: _linkedAccountId,
                    decoration: InputDecoration(
                      labelText: l.deferredCardLinkedAccount,
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(l.deferredCardNoLinkedAccount),
                      ),
                      for (final a in widget.existingAccounts!)
                        if (a.id != widget.account?.id)
                          DropdownMenuItem<int?>(
                            value: a.id,
                            child: Text(a.name),
                          ),
                    ],
                    onChanged: (id) => setState(() => _linkedAccountId = id),
                  ),
                ],
              ],
              TextField(
                controller: _bank,
                decoration: InputDecoration(labelText: l.accountBank),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _initial,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.initialBalance,
                  helperText: l.initialBalanceHelp,
                  helperMaxLines: 2,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _threshold,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.alertThreshold,
                  helperText: l.alertThresholdHelp,
                  helperMaxLines: 3,
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _restricted,
                onChanged: (v) => setState(() => _restricted = v ?? false),
                title: Text(l.visibilityRestricted),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
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
