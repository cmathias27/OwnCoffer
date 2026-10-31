import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/budget_charts.dart';
import '../widgets/category_field.dart';

/// Indicative debt ratio above which French banks usually refuse a new loan
/// (HCSF recommendation: 35 %).
const _debtRatioLimitPerMille = 350;

/// Everything left to repay: loans, with what they cost and when they end.
class LoansScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;
  final VoidCallback? onChanged;

  const LoansScreen({
    super.key,
    required this.membership,
    required this.accounts,
    this.onChanged,
  });

  @override
  State<LoansScreen> createState() => LoansScreenState();
}

class LoansScreenState extends State<LoansScreen> {
  LoanOverview? _data;
  String? _error;

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    try {
      final d = await client.loan.overview(widget.membership.group.id!);
      if (mounted) setState(() => (_data = d, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _edit([Loan? loan]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LoanFormScreen(
          groupId: widget.membership.group.id!,
          accounts: widget.accounts,
          loan: loan,
        ),
      ),
    );
    if (saved == true) {
      await reload();
      widget.onChanged?.call();
    }
  }

  Future<void> _open(LoanInfo info) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LoanDetailScreen(
          info: info,
          canWrite: _canWrite,
          accounts: widget.accounts,
          groupId: widget.membership.group.id!,
        ),
      ),
    );
    if (changed == true) {
      await reload();
      widget.onChanged?.call();
    }
  }

  static List<LoanInfo> _ordered(List<LoanInfo> loans) => [
    ...loans.where((x) => x.loan.kind != LoanKind.installments),
    ...loans.where((x) => x.loan.kind == LoanKind.installments),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final d = _data;
    return Scaffold(
      floatingActionButton: _canWrite
          ? FloatingActionButton.extended(
              onPressed: _edit,
              icon: const Icon(Icons.add),
              label: Text(l.loanAdd),
            )
          : null,
      body: _error != null
          ? Center(child: Text(_error!))
          : d == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: reload,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _Figure(
                        label: l.loansRemaining,
                        value: context.money(d.totalRemainingCents),
                      ),
                      _Figure(
                        label: l.loansMonthly,
                        value: context.money(d.totalMonthlyCents),
                      ),
                      _DebtRatio(overview: d),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (d.loans.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(l.loansEmpty, textAlign: TextAlign.center),
                    ),
                  for (final (i, info) in _ordered(d.loans).indexed) ...[
                    // Payments in instalments come last, under their title.
                    if (info.loan.kind == LoanKind.installments &&
                        (i == 0 ||
                            _ordered(d.loans)[i - 1].loan.kind !=
                                LoanKind.installments))
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                        child: Text(
                          l.loanSectionInstallments,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _open(info),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _LoanSummary(info: info),
                        ),
                      ),
                    ),
                  ],
                  Text(l.loansDisclaimer, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
    );
  }
}

String loanKindText(AppLocalizations l, LoanKind k) => switch (k) {
  LoanKind.mortgage => l.loanKindMortgage,
  LoanKind.car => l.loanKindCar,
  LoanKind.consumer => l.loanKindConsumer,
  LoanKind.student => l.loanKindStudent,
  LoanKind.personal => l.loanKindPersonal,
  LoanKind.other => l.loanKindOther,
  LoanKind.installments => l.loanKindInstallments,
};

IconData _kindIcon(LoanKind k) => switch (k) {
  LoanKind.mortgage => Icons.house_outlined,
  LoanKind.car => Icons.directions_car_outlined,
  LoanKind.consumer => Icons.shopping_bag_outlined,
  LoanKind.student => Icons.school_outlined,
  LoanKind.personal => Icons.people_outline,
  LoanKind.other => Icons.account_balance_outlined,
  LoanKind.installments => Icons.splitscreen_outlined,
};

/// `3,45 %` from thousandths of a percent.
String rateText(BuildContext context, int milli) {
  final fr = Localizations.localeOf(context).languageCode == 'fr';
  final s =
      '${milli ~/ 1000}${fr ? ',' : '.'}'
      '${(milli % 1000).toString().padLeft(3, '0')}';
  // Keep at least two decimals: 3,450 → 3,45 ; 3,125 stays.
  final trimmed = s.endsWith('0') ? s.substring(0, s.length - 1) : s;
  return '$trimmed %';
}

/// Parses "3,45" or "3.125" (up to three decimals) into thousandths of a
/// percent, without going through double. Null if unreadable.
int? parseRateMilli(String text) {
  final m = RegExp(
    r'^\s*(\d{1,2})(?:[.,](\d{1,3}))?\s*%?\s*$',
  ).firstMatch(text);
  if (m == null) return null;
  return int.parse(m[1]!) * 1000 + int.parse((m[2] ?? '').padRight(3, '0'));
}

class _Figure extends StatelessWidget {
  final String label;
  final String value;
  final Widget? footer;
  const _Figure({required this.label, required this.value, this.footer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelMedium),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ?footer,
            ],
          ),
        ),
      ),
    );
  }
}

class _DebtRatio extends StatelessWidget {
  final LoanOverview overview;
  const _DebtRatio({required this.overview});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = overview.debtRatioPerMille;
    if (r == null) {
      return _Figure(
        label: l.loansDebtRatio,
        value: '—',
        footer: Text(l.loansDebtRatioUnknown, style: theme.textTheme.bodySmall),
      );
    }
    final high = r > _debtRatioLimitPerMille;
    final color = high ? ChartColors.critical : ChartColors.good;
    return _Figure(
      label: l.loansDebtRatio,
      value: '${(r / 10).toStringAsFixed(1)} %',
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          ThinBar(
            fraction: r / 1000,
            marker: _debtRatioLimitPerMille / 1000,
            color: color,
            height: 6,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                high ? Icons.error : Icons.check_circle,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  high ? l.loansDebtRatioHigh : l.loansDebtRatioOk,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          Text(
            l.loansDebtRatioBasis(context.money(overview.monthlyIncomeCents)),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanSummary extends StatelessWidget {
  final LoanInfo info;
  const _LoanSummary({required this.info});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final loan = info.loan;
    final next = info.nextDueDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(_kindIcon(loan.kind)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loan.label ?? loanKindText(l, loan.kind),
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    '${loan.lender} · ${rateText(context, loan.annualRateMilli)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.money(info.remainingCents),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Manrope',
                  ),
                ),
                Text(l.loanRemainingShort, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ThinBar(
          fraction: info.repaidPerMille / 1000,
          color: ChartColors.rank(context),
        ),
        const SizedBox(height: 6),
        Text(
          [
            l.loanRepaid((info.repaidPerMille / 10).round()),
            l.loanInstallments(info.paidCount, info.totalCount),
            next == null
                ? l.loanFinished
                : l.loanNext(
                    context.day(next),
                    context.money(
                      info.paymentCents + loan.insuranceMonthlyCents,
                    ),
                  ),
            l.loanEnd(context.day(info.endDate)),
          ].join(' · '),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// One loan: figures, early repayment simulation, amortisation table.
class LoanDetailScreen extends StatefulWidget {
  final LoanInfo info;
  final bool canWrite;
  final List<Account> accounts;
  final int groupId;

  const LoanDetailScreen({
    super.key,
    required this.info,
    required this.canWrite,
    required this.accounts,
    required this.groupId,
  });

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  late LoanInfo _info = widget.info;
  List<LoanInstallment>? _schedule;
  final _extra = TextEditingController();
  EarlyRepayment? _simulation;
  String? _error;
  var _changed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _extra.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final s = await client.loan.schedule(_info.loan.id!);
      if (mounted) setState(() => _schedule = s);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _simulate() async {
    final l = AppLocalizations.of(context);
    final cents = parseUserAmount(_extra.text);
    if (cents == null || cents <= 0) {
      setState(() => _error = l.amountInvalid);
      return;
    }
    try {
      final r = await client.loan.simulate(_info.loan.id!, cents);
      if (mounted) setState(() => (_simulation = r, _error = null));
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    }
  }

  Future<void> _edit() async {
    final saved = await Navigator.of(context).push<LoanInfo>(
      MaterialPageRoute(
        builder: (_) => LoanFormScreen(
          groupId: widget.groupId,
          accounts: widget.accounts,
          loan: _info.loan,
          returnInfo: true,
        ),
      ),
    );
    if (saved != null) {
      setState(() => (_info = saved, _changed = true, _simulation = null));
      await _load();
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.loanDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.loanDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await client.loan.delete(_info.loan.id!);
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final info = _info;
    final loan = info.loan;
    final account = widget.accounts
        .where((a) => a.id == loan.accountId)
        .firstOrNull;
    Widget line(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
    final years = <int, List<LoanInstallment>>{};
    for (final i in _schedule ?? const <LoanInstallment>[]) {
      years.putIfAbsent(i.date.year, () => []).add(i);
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_changed);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(loan.label ?? loanKindText(l, loan.kind)),
          actions: [
            if (widget.canWrite) ...[
              IconButton(
                tooltip: l.loanEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: _edit,
              ),
              IconButton(
                tooltip: l.loanDelete,
                icon: const Icon(Icons.delete_outline),
                onPressed: _delete,
              ),
            ],
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _LoanSummary(info: info),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    line(l.loanPrincipal, context.money(loan.principalCents)),
                    line(l.loanRate, rateText(context, loan.annualRateMilli)),
                    if (loan.aprMilli != null)
                      line(l.loanApr, rateText(context, loan.aprMilli!)),
                    line(l.loanDuration, l.loanMonths(loan.durationMonths)),
                    line(l.loanPayment, context.money(info.paymentCents)),
                    if (loan.insuranceMonthlyCents > 0)
                      line(
                        l.loanInsurance,
                        context.money(loan.insuranceMonthlyCents),
                      ),
                    const Divider(),
                    line(
                      l.loanInterestPaid,
                      context.money(info.interestPaidCents),
                    ),
                    line(
                      l.loanInterestLeft,
                      context.money(info.interestRemainingCents),
                    ),
                    line(l.loanCost, context.money(info.costCents)),
                    if (account != null) line(l.loanAccount, account.name),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (info.nextDueDate != null)
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l.loanSimulationTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.loanSimulationHelp,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _extra,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l.loanSimulationAmount,
                                suffixText: '€',
                              ),
                              onSubmitted: (_) => _simulate(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.tonal(
                            onPressed: _simulate,
                            child: Text(l.loanSimulate),
                          ),
                        ],
                      ),
                      if (_simulation != null) ...[
                        const SizedBox(height: 12),
                        line(
                          l.loanSimulationSaved,
                          context.money(_simulation!.interestSavedCents),
                        ),
                        line(
                          l.loanSimulationEnd,
                          _simulation!.endDate == null
                              ? l.loanSimulationRepaid
                              : context.day(_simulation!.endDate!),
                        ),
                        line(
                          l.loanSimulationLeft,
                          '${_simulation!.installmentsLeft}',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            const SizedBox(height: 12),
            Text(l.loanScheduleTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_schedule == null)
              const Center(child: CircularProgressIndicator())
            else
              for (final MapEntry(key: year, value: rows) in years.entries)
                Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ExpansionTile(
                    initiallyExpanded:
                        year == (info.nextDueDate ?? info.endDate).year,
                    title: Text('$year'),
                    subtitle: Text(
                      l.loanYearSummary(
                        context.money(
                          rows.fold(0, (a, i) => a + i.principalCents),
                        ),
                        context.money(
                          rows.fold(0, (a, i) => a + i.interestCents),
                        ),
                        context.money(rows.last.remainingCents),
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingTextStyle: theme.textTheme.labelMedium,
                          columns: [
                            DataColumn(
                              label: Text(l.loanColNumber),
                              numeric: true,
                            ),
                            DataColumn(label: Text(l.loanColDate)),
                            DataColumn(
                              label: Text(l.loanColPayment),
                              numeric: true,
                            ),
                            DataColumn(
                              label: Text(l.loanColPrincipal),
                              numeric: true,
                            ),
                            DataColumn(
                              label: Text(l.loanColInterest),
                              numeric: true,
                            ),
                            if (loan.insuranceMonthlyCents > 0)
                              DataColumn(
                                label: Text(l.loanColInsurance),
                                numeric: true,
                              ),
                            DataColumn(
                              label: Text(l.loanColRemaining),
                              numeric: true,
                            ),
                          ],
                          rows: [
                            for (final i in rows)
                              DataRow(
                                selected: i.date == info.nextDueDate,
                                cells: [
                                  DataCell(Text('${i.number}')),
                                  DataCell(Text(context.day(i.date))),
                                  DataCell(Text(context.money(i.paymentCents))),
                                  DataCell(
                                    Text(context.money(i.principalCents)),
                                  ),
                                  DataCell(
                                    Text(context.money(i.interestCents)),
                                  ),
                                  if (loan.insuranceMonthlyCents > 0)
                                    DataCell(
                                      Text(context.money(i.insuranceCents)),
                                    ),
                                  DataCell(
                                    Text(context.money(i.remainingCents)),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

/// Entry or change of a loan, with the instalment computed as one types.
class LoanFormScreen extends StatefulWidget {
  final int groupId;
  final List<Account> accounts;
  final Loan? loan;

  /// Pop with the saved [LoanInfo] instead of `true`.
  final bool returnInfo;

  /// Declares a new loan from this debit (one of its instalments): the
  /// account is the operation's, and the form pops with the
  /// [LoanFromOperation] result.
  final BankTransaction? fromOperation;

  /// The group's categories when the caller has them (else loaded).
  final List<Category>? categories;

  const LoanFormScreen({
    super.key,
    required this.groupId,
    required this.accounts,
    this.loan,
    this.returnInfo = false,
    this.fromOperation,
    this.categories,
  });

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  late final Loan? _l = widget.loan;
  late final BankTransaction? _op = widget.fromOperation;
  late var _kind = _l?.kind ?? LoanKind.mortgage;
  bool get _installments => _kind == LoanKind.installments;
  late final _lender = TextEditingController(
    text: _l?.lender ?? _op?.cleanLabel,
  );
  late final _label = TextEditingController(text: _l?.label);
  late final _principal = TextEditingController(
    text: _money(_l?.principalCents),
  );
  late final _rate = TextEditingController(
    text: _l == null ? '' : _rateInput(_l.annualRateMilli),
  );
  late final _apr = TextEditingController(
    text: _l?.aprMilli == null ? '' : _rateInput(_l!.aprMilli!),
  );
  late final _months = TextEditingController(
    text: _l == null ? '' : '${_l.durationMonths}',
  );
  late final _insurance = TextEditingController(
    text: _money(_l?.insuranceMonthlyCents),
  );
  late final _fees = TextEditingController(text: _money(_l?.feesCents));
  late var _firstDue = _l?.firstDueDate ?? _op?.date ?? todayUtcMidnight();
  late int? _account = _l?.accountId ?? _op?.accountId;
  late int? _category = _l?.categoryId ?? _op?.categoryId;
  late List<Category> _categories = widget.categories ?? [];
  final _form = GlobalKey<FormState>();
  String? _error;
  var _busy = false;

  static String _money(int? cents) => cents == null || cents == 0
      ? ''
      : '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';

  static String _rateInput(int milli) {
    var s = '${milli ~/ 1000},${(milli % 1000).toString().padLeft(3, '0')}';
    while (s.endsWith('0') && !s.endsWith(',0')) {
      s = s.substring(0, s.length - 1);
    }
    return s.endsWith(',0') ? s.substring(0, s.length - 2) : s;
  }

  @override
  void initState() {
    super.initState();
    if (widget.categories == null) {
      client.category.list(widget.groupId).then((list) {
        if (mounted) setState(() => _categories = list);
      }, onError: (_) {});
    }
    for (final c in [_principal, _rate, _months, _insurance]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [
      _lender,
      _label,
      _principal,
      _rate,
      _apr,
      _months,
      _insurance,
      _fees,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  int? get _previewPayment {
    final p = parseUserAmount(_principal.text);
    final r = parseRateMilli(_rate.text);
    final n = int.tryParse(_months.text.trim());
    if (p == null || r == null || n == null) return null;
    if (p <= 0 || p > core.maxLoanPrincipalCents) return null;
    if (r > core.maxLoanRateMilli || n < 1 || n > core.maxLoanMonths) {
      return null;
    }
    return core.loanPaymentCents(p, r, n);
  }

  /// Capital whose instalment, insurance added, is the observed debit.
  void _deducePrincipal() {
    final l = AppLocalizations.of(context);
    final r = parseRateMilli(_rate.text);
    final n = int.tryParse(_months.text.trim());
    final insurance = parseUserAmount(_insurance.text) ?? 0;
    final p = r == null || n == null
        ? null
        : core.loanPrincipalForPaymentCents(
            -_op!.amountCents - insurance,
            r,
            n,
          );
    if (p == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.loanDeduceNeedsTerms)));
      return;
    }
    _principal.text = _money(p);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    if (!_form.currentState!.validate()) return;
    final loan = Loan(
      groupId: widget.groupId,
      id: _l?.id,
      accountId: _account,
      kind: _kind,
      lender: _lender.text,
      label: _label.text,
      principalCents: parseUserAmount(_principal.text)!,
      annualRateMilli: parseRateMilli(_rate.text)!,
      aprMilli: _apr.text.trim().isEmpty ? null : parseRateMilli(_apr.text),
      durationMonths: int.parse(_months.text.trim()),
      firstDueDate: _firstDue,
      insuranceMonthlyCents: parseUserAmount(_insurance.text) ?? 0,
      feesCents: parseUserAmount(_fees.text) ?? 0,
      categoryId: _category,
    );
    setState(() => (_busy = true, _error = null));
    try {
      final op = _op;
      if (op != null) {
        final r = await client.loan.createFromTransaction(op.id!, loan);
        if (mounted) Navigator.of(context).pop(r);
        return;
      }
      final info = _l == null
          ? await client.loan.create(widget.groupId, loan)
          : await client.loan.update(loan);
      if (!mounted) return;
      if (widget.returnInfo) {
        Navigator.of(context).pop(info);
      } else {
        Navigator.of(context).pop(true);
      }
    } on Object catch (e) {
      if (mounted) setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const gap = SizedBox(height: 12);
    String? required(String? v) =>
        v == null || v.trim().isEmpty ? l.fieldRequired : null;
    String? optionalAmount(String? v) =>
        v == null || v.trim().isEmpty || (parseUserAmount(v) ?? -1) >= 0
        ? null
        : l.amountInvalid;
    final preview = _previewPayment;
    final insurance = parseUserAmount(_insurance.text) ?? 0;
    final op = _op;
    final observed = op == null ? null : -op.amountCents;
    final mismatch =
        observed != null &&
        preview != null &&
        ((preview + insurance) - observed).abs() * 20 > observed;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          op != null
              ? l.loanFromOperationTitle
              : _l == null
              ? l.loanAdd
              : l.loanEdit,
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (op != null) ...[
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.loanObservedInstalment(
                                  context.money(observed!),
                                ),
                                style: theme.textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(l.loanFromOperationIntro(op.cleanLabel)),
                            ],
                          ),
                        ),
                      ),
                      gap,
                    ],
                    DropdownButtonFormField<LoanKind>(
                      initialValue: _kind,
                      decoration: InputDecoration(labelText: l.loanKind),
                      items: [
                        for (final k in LoanKind.values)
                          DropdownMenuItem(
                            value: k,
                            child: Text(loanKindText(l, k)),
                          ),
                      ],
                      onChanged: (v) => setState(() {
                        _kind = v!;
                        if (_installments) {
                          _rate.text = '0';
                          _apr.clear();
                          _insurance.clear();
                        }
                      }),
                    ),
                    if (_installments)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          l.loanInstallmentsHelp,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    gap,
                    TextFormField(
                      controller: _lender,
                      maxLength: 80,
                      decoration: InputDecoration(labelText: l.loanLender),
                      validator: required,
                    ),
                    TextFormField(
                      controller: _label,
                      maxLength: 80,
                      decoration: InputDecoration(
                        labelText: l.loanLabel,
                        hintText: l.loanLabelHint,
                      ),
                    ),
                    TextFormField(
                      controller: _principal,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: _installments
                            ? l.loanInstallmentsTotal
                            : l.loanPrincipal,
                        suffixText: '€',
                      ),
                      validator: (v) => (parseUserAmount(v ?? '') ?? 0) > 0
                          ? null
                          : l.amountInvalid,
                    ),
                    if (op != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          icon: const Icon(Icons.calculate_outlined),
                          label: Text(l.loanDeducePrincipal),
                          onPressed: _deducePrincipal,
                        ),
                      ),
                    gap,
                    if (!_installments) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _rate,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l.loanRate,
                                suffixText: '%',
                                helperText: l.loanRateHelp,
                              ),
                              validator: (v) => parseRateMilli(v ?? '') == null
                                  ? l.loanRateInvalid
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _apr,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l.loanApr,
                                suffixText: '%',
                                helperText: l.optional,
                              ),
                              validator: (v) =>
                                  v == null ||
                                      v.trim().isEmpty ||
                                      parseRateMilli(v) != null
                                  ? null
                                  : l.loanRateInvalid,
                            ),
                          ),
                        ],
                      ),
                      gap,
                    ],
                    TextFormField(
                      controller: _months,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _installments
                            ? l.loanInstallmentsCount
                            : l.loanDurationMonths,
                        helperText: _installments ? null : l.loanDurationHelp,
                      ),
                      validator: (v) {
                        final n = int.tryParse(v?.trim() ?? '');
                        return n == null || n < 1 || n > core.maxLoanMonths
                            ? l.loanDurationInvalid
                            : null;
                      },
                    ),
                    gap,
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event),
                      title: Text(l.loanFirstDue),
                      subtitle: Text(
                        op == null
                            ? context.day(_firstDue)
                            : '${context.day(_firstDue)}\n'
                                  '${l.loanFirstDueFromOperationHelp}',
                      ),
                      isThreeLine: op != null,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(
                            _firstDue.year,
                            _firstDue.month,
                            _firstDue.day,
                          ),
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(
                            () => _firstDue = DateTime.utc(
                              picked.year,
                              picked.month,
                              picked.day,
                            ),
                          );
                        }
                      },
                    ),
                    Row(
                      children: [
                        if (!_installments) ...[
                          Expanded(
                            child: TextFormField(
                              controller: _insurance,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l.loanInsuranceMonthly,
                                suffixText: '€',
                              ),
                              validator: optionalAmount,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: TextFormField(
                            controller: _fees,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: l.loanFees,
                              suffixText: '€',
                            ),
                            validator: optionalAmount,
                          ),
                        ),
                      ],
                    ),
                    gap,
                    DropdownButtonFormField<int?>(
                      initialValue: _account,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l.loanAccount,
                        helperText: l.loanAccountHelp,
                        helperMaxLines: 3,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(l.loanNoAccount),
                        ),
                        for (final a in widget.accounts)
                          DropdownMenuItem(value: a.id, child: Text(a.name)),
                      ],
                      onChanged: op != null
                          ? null
                          : (v) => setState(() => _account = v),
                    ),
                    gap,
                    if (_categories.isNotEmpty)
                      CategoryFormField(
                        categories: _categories,
                        initialValue: _category,
                        label: l.categoryLabel,
                        noneLabel: l.noCategory,
                        helperText: op == null
                            ? null
                            : l.loanCategoryDefaultHelp,
                        onChanged: (v) => _category = v,
                      ),
                    const SizedBox(height: 20),
                    Card(
                      margin: EdgeInsets.zero,
                      color: theme.colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          preview == null
                              ? l.loanPreviewEmpty
                              : l.loanPreview(
                                  context.money(preview),
                                  context.money(preview + insurance),
                                ),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    if (mismatch)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l.loanInstalmentMismatch(
                                  context.money(preview + insurance),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _error!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _busy ? null : _save,
                      child: Text(l.save),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
