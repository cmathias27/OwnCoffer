import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/file_pick.dart';
import '../util/file_save.dart';
import '../util/format.dart';
import '../widgets/budget_charts.dart';
import '../widgets/category_field.dart';
import '../widgets/undo.dart';
import '../widgets/ai_read.dart';

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

/// The three families of the Loans page.
enum LoanFamily { loans, consumer, installments }

LoanFamily loanFamily(LoanKind k) => switch (k) {
  LoanKind.consumer || LoanKind.revolving => LoanFamily.consumer,
  LoanKind.installments => LoanFamily.installments,
  _ => LoanFamily.loans,
};

enum LoanSort { remaining, monthly, end, lender }

class LoansScreenState extends State<LoansScreen> {
  LoanOverview? _data;

  /// Families shown (all by default) and the order inside each.
  final Set<LoanFamily> _shown = {...LoanFamily.values};
  var _sort = LoanSort.remaining;
  List<InstalmentCandidate> _found = [];
  String? _error;

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    try {
      final groupId = widget.membership.group.id!;
      final d = await client.loan.overview(groupId);
      // A hint only: the page works without it.
      final found = await client.loan
          .detectedInstalments(groupId)
          .catchError((Object _) => <InstalmentCandidate>[]);
      if (mounted) {
        setState(() => (_data = d, _found = found, _error = null));
      }
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

  /// Adds a payment in instalments found in the operations: the loan form,
  /// filled from its first debit, with the count to adjust.
  Future<void> _addFound(InstalmentCandidate c) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final r = await Navigator.of(context).push<LoanFromOperation>(
      MaterialPageRoute(
        builder: (_) => LoanFormScreen(
          groupId: widget.membership.group.id!,
          accounts: widget.accounts,
          fromOperation: c.first,
          initialKind: c.kind,
          initialCount: c.suggestedCount,
          initialLender: c.label,
        ),
      ),
    );
    if (r == null || !mounted) return;
    await reload();
    widget.onChanged?.call();
    showUndo(
      messenger,
      l,
      l.loanFromOperationDone(r.linkedCount, r.reclassifiedCount),
      () => client.loan.undoCreate(r.info.loan.id!).then((_) {}),
      after: () async {
        await reload();
        widget.onChanged?.call();
      },
    );
  }

  /// The loans of a family, in the chosen order; repaid ones last.
  List<LoanInfo> _of(List<LoanInfo> loans, LoanFamily f) {
    final list = [
      for (final x in loans)
        if (loanFamily(x.loan.kind) == f) x,
    ];
    int by(LoanInfo a, LoanInfo b) => switch (_sort) {
      LoanSort.remaining => b.remainingCents.compareTo(a.remainingCents),
      LoanSort.monthly =>
        (b.paymentCents + b.loan.insuranceMonthlyCents).compareTo(
          a.paymentCents + a.loan.insuranceMonthlyCents,
        ),
      LoanSort.end => a.endDate.compareTo(b.endDate),
      LoanSort.lender => a.loan.lender.toLowerCase().compareTo(
        b.loan.lender.toLowerCase(),
      ),
    };
    list.sort((a, b) {
      final done = (a.nextDueDate == null ? 1 : 0).compareTo(
        b.nextDueDate == null ? 1 : 0,
      );
      return done != 0 ? done : by(a, b);
    });
    return list;
  }

  static String familyText(AppLocalizations l, LoanFamily f) => switch (f) {
    LoanFamily.loans => l.loanFamilyLoans,
    LoanFamily.consumer => l.loanFamilyConsumer,
    LoanFamily.installments => l.loanSectionInstallments,
  };

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
                  if (_found.isNotEmpty) ...[
                    _FoundInstalments(
                      found: _found,
                      accounts: {for (final a in widget.accounts) a.id!: a},
                      onAdd: _canWrite ? _addFound : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (d.loans.isEmpty && _found.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(l.loansEmpty, textAlign: TextAlign.center),
                    ),
                  if (d.loans.isNotEmpty) ...[
                    // What to show, and in which order.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (final f in LoanFamily.values)
                          if (d.loans.any((x) => loanFamily(x.loan.kind) == f))
                            FilterChip(
                              label: Text(familyText(l, f)),
                              selected: _shown.contains(f),
                              onSelected: (v) => setState(
                                () => v ? _shown.add(f) : _shown.remove(f),
                              ),
                            ),
                        DropdownButton<LoanSort>(
                          value: _sort,
                          underline: const SizedBox.shrink(),
                          icon: const Icon(Icons.sort),
                          items: [
                            for (final o in LoanSort.values)
                              DropdownMenuItem(
                                value: o,
                                child: Text(switch (o) {
                                  LoanSort.remaining => l.loanSortRemaining,
                                  LoanSort.monthly => l.loanSortMonthly,
                                  LoanSort.end => l.loanSortEnd,
                                  LoanSort.lender => l.loanSortLender,
                                }),
                              ),
                          ],
                          onChanged: (o) => setState(() => _sort = o!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  for (final f in LoanFamily.values)
                    if (_shown.contains(f) && _of(d.loans, f).isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                familyText(l, f),
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            // What the family weighs each month and in all.
                            Text(
                              l.loanFamilyTotals(
                                context.money(
                                  _of(d.loans, f)
                                      .where((x) => x.nextDueDate != null)
                                      .fold(
                                        0,
                                        (a, x) =>
                                            a +
                                            x.paymentCents +
                                            x.loan.insuranceMonthlyCents,
                                      ),
                                ),
                                context.money(
                                  _of(d.loans, f).fold(
                                    0,
                                    (a, x) => a + x.remainingCents,
                                  ),
                                ),
                              ),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      for (final info in _of(d.loans, f))
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

/// Payments in instalments found in the operations, not in the loans yet.
class _FoundInstalments extends StatelessWidget {
  final List<InstalmentCandidate> found;
  final Map<int, Account> accounts;
  final ValueChanged<InstalmentCandidate>? onAdd;

  const _FoundInstalments({
    required this.found,
    required this.accounts,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.manage_search,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.loanFoundTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(l.loanFoundHelp, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            for (final c in found)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_kindIcon(c.kind)),
                title: Text(c.label),
                subtitle: Text(
                  [
                    l.loanFoundPaid(
                      c.paidCount,
                      context.money(c.amountCents),
                      context.day(c.firstDate),
                    ),
                    if (c.statedCount != null)
                      l.loanFoundStated(c.statedCount!),
                    if (accounts.length > 1 && accounts[c.accountId] != null)
                      accounts[c.accountId]!.name,
                  ].join(' · '),
                ),
                trailing: onAdd == null
                    ? null
                    : FilledButton.tonal(
                        onPressed: () => onAdd!(c),
                        child: Text(l.loanFoundAdd),
                      ),
              ),
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
  LoanKind.revolving => l.loanKindRevolving,
};

IconData _kindIcon(LoanKind k) => switch (k) {
  LoanKind.mortgage => Icons.house_outlined,
  LoanKind.car => Icons.directions_car_outlined,
  LoanKind.consumer => Icons.shopping_bag_outlined,
  LoanKind.student => Icons.school_outlined,
  LoanKind.personal => Icons.people_outline,
  LoanKind.other => Icons.account_balance_outlined,
  LoanKind.installments => Icons.splitscreen_outlined,
  LoanKind.revolving => Icons.credit_card_outlined,
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
  List<BankTransaction>? _operations;
  List<LoanDocument>? _documents;
  var _allOperations = false;
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
      final (s, ops, docs) = await (
        client.loan.schedule(_info.loan.id!),
        client.loan.operations(_info.loan.id!),
        client.loan.documents(_info.loan.id!),
      ).wait;
      if (mounted) {
        setState(() => (_schedule = s, _operations = ops, _documents = docs));
      }
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

  Future<void> _addDocument() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final f = await pickFile(
        extensions: const [
          '.pdf',
          '.png',
          '.jpg',
          '.jpeg',
          '.webp',
          '.csv',
          '.txt',
          '.xlsx',
          '.ods',
        ],
      );
      if (f == null) return;
      final doc = await client.loan.uploadDocument(
        _info.loan.id!,
        f.name,
        ByteData.sublistView(f.bytes),
      );
      if (!mounted) return;
      setState(() => _documents = [doc, ...?_documents]);
      messenger.showSnackBar(SnackBar(content: Text(l.loanDocumentAdded)));
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  Future<void> _openDocument(LoanDocument d) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final data = await client.loan.downloadDocument(d.id!);
      openOrSaveFile(
        d.fileName,
        d.mimeType,
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  Future<void> _deleteDocument(LoanDocument d) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.loanDocumentDeleteConfirm(d.fileName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.loanDocumentDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await client.loan.deleteDocument(d.id!);
      if (mounted) {
        setState(
          () => _documents = [
            for (final x in _documents ?? const <LoanDocument>[])
              if (x.id != d.id) x,
          ],
        );
      }
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  static String _size(AppLocalizations l, int bytes) => bytes >= 1024 * 1024
      ? l.sizeMb((bytes / (1024 * 1024)).toStringAsFixed(1))
      : l.sizeKb('${(bytes / 1024).ceil()}');

  /// Amortisation tables, offers, screenshots kept on the server.
  Future<void> _changeEvents(Future<LoanInfo> Function() call) async {
    final l = AppLocalizations.of(context);
    try {
      final saved = await call();
      if (!mounted) return;
      setState(() => (_info = saved, _changed = true, _simulation = null));
      await _load();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
      }
    }
  }

  Future<void> _addEvent() async {
    final event = await showDialog<LoanEvent>(
      context: context,
      builder: (_) => _LoanEventDialog(loan: _info.loan),
    );
    if (event == null) return;
    await _changeEvents(() => client.loan.addEvent(_info.loan.id!, event));
  }

  /// What a change did, in one line.
  String _eventText(AppLocalizations l, LoanEvent e) => [
    if (e.annualRateMilli != null)
      l.loanEventRate(rateText(context, e.annualRateMilli!)),
    if (e.paymentCents != null)
      l.loanEventPayment(context.money(e.paymentCents!)),
    if (e.remainingMonths != null)
      l.loanEventMonths(l.loanMonths(e.remainingMonths!)),
    if ((e.drawCents ?? 0) > 0) l.loanEventDraw(context.money(e.drawCents!)),
    if ((e.drawCents ?? 0) < 0) l.loanEventRepaid(context.money(-e.drawCents!)),
  ].join(' · ');

  Widget _eventsCard(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
  ) {
    final events = _info.loan.events ?? const <LoanEvent>[];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.loanEventsTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              events.isEmpty ? l.loanEventsEmpty : l.loanEventsHelp,
              style: theme.textTheme.bodySmall,
            ),
            for (final (i, e) in events.indexed)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.change_circle_outlined),
                title: Text(_eventText(l, e)),
                subtitle: Text(
                  [
                    context.day(e.date),
                    if (e.note != null) e.note!,
                  ].join(' · '),
                ),
                trailing: widget.canWrite
                    ? IconButton(
                        tooltip: l.loanEventRemove,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _changeEvents(
                          () => client.loan.removeEvent(_info.loan.id!, i),
                        ),
                      )
                    : null,
              ),
            if (widget.canWrite)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(
                    _info.loan.kind == LoanKind.revolving
                        ? l.loanEventAddRevolving
                        : l.loanEventAdd,
                  ),
                  onPressed: _addEvent,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _documentsCard(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
  ) {
    final docs = _documents;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.loanDocumentsTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (widget.canWrite)
                  TextButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: Text(l.loanDocumentAdd),
                    onPressed: _addDocument,
                  ),
              ],
            ),
            Text(
              l.loanDocumentsHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (docs == null)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (docs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(l.loanDocumentsEmpty),
              )
            else
              for (final d in docs)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    d.mimeType == 'application/pdf'
                        ? Icons.picture_as_pdf_outlined
                        : d.mimeType.startsWith('image/')
                        ? Icons.image_outlined
                        : Icons.table_chart_outlined,
                  ),
                  title: Text(d.fileName),
                  subtitle: Text(
                    l.loanDocumentInfo(
                      _size(l, d.sizeBytes),
                      context.day(d.createdAt),
                    ),
                  ),
                  onTap: () => _openDocument(d),
                  trailing: widget.canWrite
                      ? Wrap(
                          children: [
                            IconButton(
                              tooltip: l.aiReadLoan,
                              icon: const Icon(Icons.auto_awesome_outlined),
                              onPressed: () => readWithAi(
                                context,
                                mimeType: d.mimeType,
                                read: () => client.ai.readLoanDocument(d.id!),
                              ),
                            ),
                            IconButton(
                              tooltip: l.loanDocumentDelete,
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteDocument(d),
                            ),
                          ],
                        )
                      : null,
                ),
          ],
        ),
      ),
    );
  }

  /// The debits of the account that concern this loan, newest first.
  Widget _operationsCard(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
  ) {
    final ops = _operations;
    final currency =
        widget.accounts
            .where((a) => a.id == _info.loan.accountId)
            .firstOrNull
            ?.currency ??
        'EUR';
    final total = (ops ?? const <BankTransaction>[]).fold(
      0,
      (a, t) => a - t.amountCents,
    );
    const shown = 12;
    final visible = ops == null
        ? const <BankTransaction>[]
        : (_allOperations ? ops : ops.take(shown).toList());
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.loanOperationsTitle, style: theme.textTheme.titleMedium),
            if (ops == null)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (ops.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(l.loanOperationsEmpty),
              )
            else ...[
              Text(
                l.loanOperationsSummary(
                  ops.length,
                  context.money(total, currency: currency),
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              for (final t in visible)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          context.day(t.date),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          t.cleanLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        context.money(t.amountCents, currency: currency),
                        style: const TextStyle(
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              if (ops.length > shown)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () =>
                        setState(() => _allOperations = !_allOperations),
                    child: Text(
                      _allOperations
                          ? l.rankingShowLess
                          : l.loanOperationsMore(ops.length),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
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
                    if (loan.creditLimitCents != null) ...[
                      line(
                        l.loanCreditLimit,
                        context.money(loan.creditLimitCents!),
                      ),
                      line(
                        l.loanCreditAvailable,
                        context.money(
                          loan.creditLimitCents! - info.remainingCents,
                        ),
                      ),
                    ],
                    if (loan.kind != LoanKind.revolving)
                      line(l.loanDuration, l.loanMonths(loan.durationMonths)),
                    line(
                      info.paymentIsActual
                          ? l.loanPaymentActual
                          : l.loanPaymentComputed,
                      context.money(info.paymentCents),
                    ),
                    if (info.paymentIsActual &&
                        info.totalCount != loan.durationMonths)
                      line(
                        l.loanEstimatedDuration,
                        l.loanMonths(info.totalCount),
                      ),
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
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            info.paymentIsActual
                                ? l.loanEstimatesNote
                                : l.loanEstimatesNoteComputed,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _eventsCard(context, l, theme),
            const SizedBox(height: 12),
            _operationsCard(context, l, theme),
            const SizedBox(height: 12),
            _documentsCard(context, l, theme),
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

  /// For a new loan: its kind, number of instalments and lender, e.g. a
  /// payment in instalments found in the operations.
  final LoanKind? initialKind;
  final int? initialCount;
  final String? initialLender;

  const LoanFormScreen({
    super.key,
    required this.groupId,
    required this.accounts,
    this.loan,
    this.returnInfo = false,
    this.fromOperation,
    this.categories,
    this.initialKind,
    this.initialCount,
    this.initialLender,
  });

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  late final Loan? _l = widget.loan;
  late final BankTransaction? _op = widget.fromOperation;
  late var _kind = _l?.kind ?? widget.initialKind ?? LoanKind.mortgage;
  bool get _installments => _kind == LoanKind.installments;
  bool get _revolving => _kind == LoanKind.revolving;
  late final _limit = TextEditingController(
    text: _money(_l?.creditLimitCents),
  );
  late final _lender = TextEditingController(
    text: _l?.lender ?? widget.initialLender ?? _op?.cleanLabel,
  );
  late final _label = TextEditingController(text: _l?.label);
  late final _principal = TextEditingController(
    text: _money(_l?.principalCents),
  );
  late final _rate = TextEditingController(
    text: _l != null
        ? _rateInput(_l.annualRateMilli)
        : _installments
        ? '0'
        : '',
  );
  late final _apr = TextEditingController(
    text: _l?.aprMilli == null ? '' : _rateInput(_l!.aprMilli!),
  );
  late final _months = TextEditingController(
    text: _l != null
        ? '${_l.durationMonths}'
        : widget.initialCount == null
        ? ''
        : '${widget.initialCount}',
  );

  /// For a new payment in instalments, the total follows the instalment
  /// and the count until the user types one.
  late var _totalFollows = _l == null;
  late final _insurance = TextEditingController(
    text: _money(_l?.insuranceMonthlyCents),
  );
  late final _fees = TextEditingController(text: _money(_l?.feesCents));

  /// What leaves the account each month (instalment + insurance): the debit
  /// when declared from one, the stored actual instalment otherwise.
  late final _actual = TextEditingController(
    text: _l?.paymentCents != null
        ? _money(_l!.paymentCents! + _l.insuranceMonthlyCents)
        : _money(_op == null ? null : -_op.amountCents),
  );
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
    for (final c in [_principal, _rate, _months, _insurance, _actual]) {
      c.addListener(() => setState(() {}));
    }
    for (final c in [_months, _actual]) {
      c.addListener(_followTotal);
    }
    _followTotal();
  }

  void _followTotal() {
    if (!_installments || !_totalFollows) return;
    final pay = parseUserAmount(_actual.text);
    final n = int.tryParse(_months.text.trim());
    if (pay == null || pay <= 0 || n == null || n < 1) return;
    final total = _money(pay * n);
    if (_principal.text != total) _principal.text = total;
  }

  /// One instalment more or less (2 to the maximum).
  void _step(int delta) {
    final n = (int.tryParse(_months.text.trim()) ?? 1) + delta;
    if (n < 2 || n > core.maxLoanMonths) return;
    _months.text = '$n';
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
      _actual,
      _limit,
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

  /// The actual instalment (insurance taken out), or null when not entered.
  int? get _actualPayment {
    final total = parseUserAmount(_actual.text);
    if (total == null || total <= 0) return null;
    final p = total - (parseUserAmount(_insurance.text) ?? 0);
    return p > 0 ? p : null;
  }

  /// Instalments the actual one takes to repay the capital, when it can.
  int? get _actualMonths {
    final pay = _actualPayment;
    final p = parseUserAmount(_principal.text);
    final r = parseRateMilli(_rate.text);
    final n = int.tryParse(_months.text.trim());
    if (pay == null || p == null || r == null || n == null) return null;
    try {
      return core
          .amortize(
            core.LoanTerms(
              principalCents: p,
              annualRateMilli: r,
              months: n,
              firstDue: core.LocalDate(2000, 1, 1),
              paymentCents: pay,
            ),
          )
          .length;
    } on ArgumentError {
      return null;
    }
  }

  /// Capital whose instalment, insurance added, is the debit entered.
  void _deducePrincipal() {
    final l = AppLocalizations.of(context);
    final r = parseRateMilli(_rate.text);
    final n = int.tryParse(_months.text.trim());
    final insurance = parseUserAmount(_insurance.text) ?? 0;
    final p = r == null || n == null
        ? null
        : core.loanPrincipalForPaymentCents(
            (parseUserAmount(_actual.text) ?? 0) - insurance,
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
      // A revolving credit has no duration: the server computes it from
      // the instalment.
      durationMonths: _revolving
          ? (int.tryParse(_months.text.trim()) ?? 1)
          : int.parse(_months.text.trim()),
      creditLimitCents: _revolving ? parseUserAmount(_limit.text) : null,
      firstDueDate: _firstDue,
      insuranceMonthlyCents: parseUserAmount(_insurance.text) ?? 0,
      feesCents: parseUserAmount(_fees.text) ?? 0,
      paymentCents: _actualPayment,
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
    final observed = parseUserAmount(_actual.text);
    final mismatch =
        observed != null &&
        observed > 0 &&
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
                      isExpanded: true,
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
                          _followTotal();
                        }
                      }),
                    ),
                    if (_installments || _revolving)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _revolving
                              ? l.loanRevolvingHelp
                              : l.loanInstallmentsHelp,
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
                      controller: _actual,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l.loanActualPayment,
                        helperText: l.loanActualPaymentHelp,
                        helperMaxLines: 3,
                        suffixText: '€',
                      ),
                      validator: (v) =>
                          _revolving && (parseUserAmount(v ?? '') ?? 0) <= 0
                          ? l.loanRevolvingPaymentRequired
                          : optionalAmount(v),
                    ),
                    gap,
                    TextFormField(
                      controller: _principal,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: _installments
                            ? l.loanInstallmentsTotal
                            : _revolving
                            ? l.loanRevolvingUsed
                            : l.loanPrincipal,
                        helperText: _installments && _totalFollows
                            ? l.loanInstallmentsTotalHelp
                            : null,
                        helperMaxLines: 2,
                        suffixText: '€',
                      ),
                      onChanged: (_) => _totalFollows = false,
                      validator: (v) => (parseUserAmount(v ?? '') ?? 0) > 0
                          ? null
                          : l.amountInvalid,
                    ),
                    if ((parseUserAmount(_actual.text) ?? 0) > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          icon: const Icon(Icons.calculate_outlined),
                          label: Text(l.loanDeducePrincipal),
                          onPressed: _deducePrincipal,
                        ),
                      ),
                    if (_revolving) ...[
                      gap,
                      TextFormField(
                        controller: _limit,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l.loanCreditLimit,
                          helperText: l.optional,
                          suffixText: '€',
                        ),
                        validator: optionalAmount,
                      ),
                    ],
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
                    if (!_revolving)
                      TextFormField(
                        controller: _months,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _installments
                              ? l.loanInstallmentsCount
                              : l.loanDurationMonths,
                          helperText: _installments
                              ? l.loanInstallmentsCountHelp
                              : l.loanDurationHelp,
                          helperMaxLines: 2,
                          prefixIcon: _installments
                              ? IconButton(
                                  tooltip: l.loanInstallmentsLess,
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => _step(-1),
                                )
                              : null,
                          suffixIcon: _installments
                              ? IconButton(
                                  tooltip: l.loanInstallmentsMore,
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _step(1),
                                )
                              : null,
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
                          _actualMonths != null
                              ? l.loanActualPreview(
                                  context.money(_actualPayment! + insurance),
                                  _actualMonths!,
                                )
                              : preview == null
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

enum _EventKind { rate, renegotiation, draw, repayment }

/// One change of a loan: a new rate, a renegotiation, money drawn
/// (revolving credit) or repaid early.
class _LoanEventDialog extends StatefulWidget {
  final Loan loan;
  const _LoanEventDialog({required this.loan});

  @override
  State<_LoanEventDialog> createState() => _LoanEventDialogState();
}

class _LoanEventDialogState extends State<_LoanEventDialog> {
  late var _kind = widget.loan.kind == LoanKind.revolving
      ? _EventKind.draw
      : _EventKind.rate;
  var _date = todayUtcMidnight();
  final _rate = TextEditingController();
  final _payment = TextEditingController();
  final _months = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String? _error;

  @override
  void dispose() {
    for (final c in [_rate, _payment, _months, _amount, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  void _ok() {
    final l = AppLocalizations.of(context);
    String? text(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final rate = text(_rate) == null ? null : parseRateMilli(_rate.text);
    final payment = text(_payment) == null
        ? null
        : parseUserAmount(_payment.text);
    final months = text(_months) == null ? null : int.tryParse(_months.text);
    final amount = parseUserAmount(_amount.text);
    final LoanEvent e;
    switch (_kind) {
      case _EventKind.rate:
        if (rate == null) return setState(() => _error = l.loanRateInvalid);
        e = LoanEvent(date: _date, annualRateMilli: rate);
      case _EventKind.renegotiation:
        if ((text(_rate) != null && rate == null) ||
            (text(_payment) != null && (payment ?? 0) <= 0) ||
            (text(_months) != null && (months ?? 0) < 1) ||
            (rate == null && payment == null && months == null)) {
          return setState(() => _error = l.loanEventInvalid);
        }
        e = LoanEvent(
          date: _date,
          annualRateMilli: rate,
          paymentCents: payment,
          remainingMonths: payment == null ? months : null,
        );
      case _EventKind.draw || _EventKind.repayment:
        if (amount == null || amount <= 0) {
          return setState(() => _error = l.amountInvalid);
        }
        e = LoanEvent(
          date: _date,
          drawCents: _kind == _EventKind.draw ? amount : -amount,
        );
    }
    Navigator.of(context).pop(e.copyWith(note: text(_note)));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const gap = SizedBox(height: 12);
    TextField money(TextEditingController c, String label) => TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, suffixText: '€'),
    );
    final rate = TextField(
      controller: _rate,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: l.loanEventNewRate,
        suffixText: '%',
      ),
    );
    return AlertDialog(
      title: Text(l.loanEventAdd),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<_EventKind>(
                isExpanded: true,
                initialValue: _kind,
                decoration: InputDecoration(labelText: l.loanEventKind),
                items: [
                  for (final k in _EventKind.values)
                    DropdownMenuItem(
                      value: k,
                      child: Text(switch (k) {
                        _EventKind.rate => l.loanEventKindRate,
                        _EventKind.renegotiation =>
                          l.loanEventKindRenegotiation,
                        _EventKind.draw => l.loanEventKindDraw,
                        _EventKind.repayment => l.loanEventKindRepayment,
                      }),
                    ),
                ],
                onChanged: (k) => setState(() => (_kind = k!, _error = null)),
              ),
              const SizedBox(height: 6),
              Text(
                switch (_kind) {
                  _EventKind.rate => l.loanEventRateHelp,
                  _EventKind.renegotiation => l.loanEventRenegotiationHelp,
                  _EventKind.draw => l.loanEventDrawHelp,
                  _EventKind.repayment => l.loanEventRepaymentHelp,
                },
                style: Theme.of(context).textTheme.bodySmall,
              ),
              gap,
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: Text(l.loanEventDate),
                subtitle: Text(context.day(_date)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(_date.year, _date.month, _date.day),
                    firstDate: DateTime(1970),
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
              if (_kind == _EventKind.rate) rate,
              if (_kind == _EventKind.renegotiation) ...[
                rate,
                gap,
                money(_payment, l.loanEventNewPayment),
                gap,
                TextField(
                  controller: _months,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l.loanEventNewMonths,
                    helperText: l.loanEventNewMonthsHelp,
                    helperMaxLines: 2,
                  ),
                ),
              ],
              if (_kind == _EventKind.draw || _kind == _EventKind.repayment)
                money(_amount, l.loanEventAmount),
              gap,
              TextField(
                controller: _note,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText: l.loanEventNote,
                  helperText: l.optional,
                ),
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _ok, child: Text(l.save)),
      ],
    );
  }
}
