import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/budget_charts.dart';
import '../widgets/undo.dart';
import '../widgets/category_field.dart';
import 'calendar_screen.dart';
import 'review_screen.dart';
import 'subscriptions_screen.dart';

/// Where the money comes from and goes: a week, a month (from the group's
/// start day) or a year, ranked by category, with the monthly goals.
class BudgetScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;

  const BudgetScreen({
    super.key,
    required this.membership,
    required this.accounts,
  });

  @override
  State<BudgetScreen> createState() => BudgetScreenState();
}

class BudgetScreenState extends State<BudgetScreen> {
  var _period = BudgetPeriod.month;
  var _date = todayUtcMidnight();
  int? _accountId;
  SpendingReport? _report;
  LeftToLiveReport? _left;
  Map<int, Category> _categories = {};
  final Set<int> _expanded = {};
  String? _error;
  var _loading = false;
  late var _startDay = widget.membership.group.monthStartDay;

  int get _groupId => widget.membership.group.id!;
  bool get _canWrite => widget.membership.role != MemberRole.reader;
  bool get _isAdmin => widget.membership.role == MemberRole.admin;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    setState(() => (_loading = true, _error = null));
    try {
      final results = await Future.wait([
        client.analysis.report(
          _groupId,
          _period,
          _date,
          accountId: _accountId,
        ),
        client.category.list(_groupId),
        client.analysis.leftToLive(_groupId, accountId: _accountId),
      ]);
      if (!mounted) return;
      setState(() {
        _report = results[0] as SpendingReport;
        _left = results[2] as LeftToLiveReport;
        _categories = {
          for (final c in results[1] as List<Category>) c.id!: c,
        };
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _shift(int n) {
    final r = _report;
    if (r == null) return;
    // Any day of the target period: the server finds its bounds.
    final d = n < 0
        ? r.start.subtract(const Duration(days: 1))
        : r.last.add(const Duration(days: 1));
    setState(() => _date = d);
    reload();
  }

  String _periodLabel(BuildContext context, SpendingReport r) {
    final lang = Localizations.localeOf(context).languageCode;
    DateTime local(DateTime d) => DateTime(d.year, d.month, d.day);
    return switch (r.period) {
      BudgetPeriod.year => '${r.start.year}',
      BudgetPeriod.month when r.start.day == 1 => toBeginningOfSentenceCase(
        DateFormat.yMMMM(lang).format(local(r.start)),
      ),
      _ =>
        '${DateFormat.MMMd(lang).format(local(r.start))} – '
            '${DateFormat.yMMMd(lang).format(local(r.last))}',
    };
  }

  String _historyLabel(BuildContext context, DateTime start) {
    final lang = Localizations.localeOf(context).languageCode;
    final d = DateTime(start.year, start.month, start.day);
    return switch (_period) {
      BudgetPeriod.week => DateFormat.Md(lang).format(d),
      BudgetPeriod.month =>
        _startDay == 1
            ? DateFormat.MMM(lang).format(d)
            : DateFormat.Md(lang).format(d),
      BudgetPeriod.year => '${d.year}',
    };
  }

  String _axisMoney(BuildContext context, int cents) {
    final euros = cents ~/ 100;
    final lang = Localizations.localeOf(context).languageCode;
    return euros >= 1000
        ? '${NumberFormat.decimalPattern(lang).format(euros ~/ 1000)} k'
        : NumberFormat.decimalPattern(lang).format(euros);
  }

  // --- actions ----------------------------------------------------------------

  Future<void> _showOperations(String title, {int? categoryId}) async {
    final r = _report;
    if (r == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 1,
        builder: (context, scroll) => _OperationsList(
          title: title,
          load: client.analysis.operations(
            _groupId,
            _period,
            r.start,
            categoryId: categoryId,
            unclassified: categoryId == null,
            accountId: _accountId,
          ),
          categories: _categories,
          accounts: {for (final a in widget.accounts) a.id!: a},
          scroll: scroll,
        ),
      ),
    );
  }

  Future<void> _editGoal(Category c, CategoryFlow? flow) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final before = flow?.goalCents;
    final done = await showDialog<String>(
      context: context,
      builder: (_) => _GoalDialog(
        groupId: _groupId,
        category: c,
        flow: flow,
        name: context.categoryName(c),
      ),
    );
    if (done == null) return;
    await reload();
    showUndo(
      messenger,
      l,
      done == 'removed' ? l.goalRemoved : l.goalSaved,
      () => before == null
          ? client.goal.remove(_groupId, c.id!)
          : client.goal.set(_groupId, c.id!, before).then((_) {}),
      after: reload,
    );
  }

  Future<void> _settings() async {
    final l = AppLocalizations.of(context);
    var day = _startDay;
    final picked = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: Text(l.monthStartTitle),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.monthStartHelp),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: day,
                  decoration: InputDecoration(labelText: l.monthStartLabel),
                  items: [
                    for (var d = 1; d <= 28; d++)
                      DropdownMenuItem(
                        value: d,
                        child: Text(
                          d == 1 ? l.monthStartFirst : l.monthStartDay(d),
                        ),
                      ),
                  ],
                  onChanged: (v) => setLocal(() => day = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(day),
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
    if (picked == null || picked == _startDay) return;
    try {
      final g = await client.group.setMonthStartDay(_groupId, picked);
      setState(() => (_startDay = g.monthStartDay, _date = todayUtcMidnight()));
      await reload();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
      }
    }
  }

  // --- build -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final r = _report;
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _controls(context, l, r),
          if (_loading && r == null)
            const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(_error!, textAlign: TextAlign.center),
            ),
          if (r != null) ...[
            const SizedBox(height: 12),
            _summary(context, l, r),
            if (_left case final left?)
              if (_period == BudgetPeriod.month &&
                  !todayUtcMidnight().isBefore(r.start) &&
                  !todayUtcMidnight().isAfter(r.last)) ...[
                const SizedBox(height: 16),
                _LeftToLiveCard(report: left),
              ],
            const SizedBox(height: 16),
            _card(
              context,
              l.budgetHistoryTitle,
              IncomeExpenseChart(
                points: [
                  for (final h in r.history)
                    IncomeExpensePoint(
                      label: _historyLabel(context, h.start),
                      tooltipTitle: _historyLabel(context, h.start),
                      incomeCents: h.incomeCents,
                      expenseCents: h.expenseCents,
                    ),
                ],
                incomeLabel: l.budgetIncome,
                expenseLabel: l.budgetExpenses,
                netLabel: l.budgetNet,
                semanticLabel: l.budgetHistorySemantic,
                money: (c) => context.money(c),
                axisMoney: (c) => _axisMoney(context, c),
              ),
            ),
            const SizedBox(height: 16),
            _ranking(context, l, r, CategoryKind.expense),
            const SizedBox(height: 16),
            _ranking(context, l, r, CategoryKind.income),
          ],
        ],
      ),
    );
  }

  Widget _controls(
    BuildContext context,
    AppLocalizations l,
    SpendingReport? r,
  ) {
    final theme = Theme.of(context);
    final today = todayUtcMidnight();
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SegmentedButton<BudgetPeriod>(
          segments: [
            ButtonSegment(value: BudgetPeriod.week, label: Text(l.periodWeek)),
            ButtonSegment(
              value: BudgetPeriod.month,
              label: Text(l.periodMonth),
            ),
            ButtonSegment(value: BudgetPeriod.year, label: Text(l.periodYear)),
          ],
          selected: {_period},
          showSelectedIcon: false,
          onSelectionChanged: (s) {
            setState(() {
              _period = s.single;
              _expanded.clear();
            });
            reload();
          },
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: l.periodPrevious,
              icon: const Icon(Icons.chevron_left),
              onPressed: r == null ? null : () => _shift(-1),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 140),
              child: Text(
                r == null ? '' : _periodLabel(context, r),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l.periodNext,
              icon: const Icon(Icons.chevron_right),
              onPressed: r == null || !r.last.isBefore(today)
                  ? null
                  : () => _shift(1),
            ),
          ],
        ),
        if (widget.accounts.length > 1)
          DropdownButton<int?>(
            value: _accountId,
            items: [
              DropdownMenuItem(value: null, child: Text(l.allAccounts)),
              for (final a in widget.accounts)
                DropdownMenuItem(value: a.id, child: Text(a.name)),
            ],
            onChanged: (v) {
              setState(() => _accountId = v);
              reload();
            },
          ),
        OutlinedButton.icon(
          icon: const Icon(Icons.autorenew),
          label: Text(l.subscriptionsTitle),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SubscriptionsScreen(
                membership: widget.membership,
                accounts: widget.accounts,
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text(l.calendarTitle),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CalendarScreen(
                membership: widget.membership,
                accounts: widget.accounts,
                accountId: _accountId,
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.fact_check_outlined),
          label: Text(l.reviewTitle),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReviewScreen(
                membership: widget.membership,
                accountId: _accountId,
                // The month shown, or the one just ended early in a month.
                date: _period == BudgetPeriod.month
                    ? _date
                    : todayUtcMidnight(),
              ),
            ),
          ),
        ),
        if (_isAdmin)
          IconButton(
            tooltip: l.monthStartTitle,
            icon: const Icon(Icons.event_repeat),
            onPressed: _settings,
          ),
      ],
    );
  }

  Widget _summary(BuildContext context, AppLocalizations l, SpendingReport r) {
    final prev = r.history.length >= 2 ? r.history[r.history.length - 2] : null;
    Widget tile(
      String label,
      int cents,
      int? before, {
      bool lowerIsBetter = false,
    }) => _StatTile(
      label: label,
      value: context.money(cents),
      delta: before == null ? null : _delta(l, cents, before),
      // A rise in spending is bad news; in income, good news.
      good: before == null || cents == before
          ? null
          : (cents > before) != lowerIsBetter,
    );
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        tile(l.budgetIncome, r.incomeCents, prev?.incomeCents),
        tile(
          l.budgetExpenses,
          r.expenseCents,
          prev?.expenseCents,
          lowerIsBetter: true,
        ),
        tile(l.budgetSavings, r.savingsCents, prev?.savingsCents),
        tile(
          l.budgetNet,
          r.netCents,
          prev == null
              ? null
              : prev.incomeCents - prev.expenseCents - prev.savingsCents,
        ),
      ],
    );
  }

  /// "+12 % vs previous period", in whole percent; null when meaningless.
  String? _delta(AppLocalizations l, int now, int before) {
    if (before == 0) return null;
    final pct = ((now - before) * 100 / before.abs()).round();
    return l.budgetDeltaPrevious('${pct > 0 ? '+' : ''}$pct');
  }

  Widget _card(
    BuildContext context,
    String title,
    Widget child, {
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
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
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _ranking(
    BuildContext context,
    AppLocalizations l,
    SpendingReport r,
    CategoryKind kind,
  ) {
    final flows = {for (final f in r.categories) f.categoryId: f};
    final isExpense = kind == CategoryKind.expense;
    final total = isExpense ? r.expenseCents : r.incomeCents;
    List<(Category, CategoryFlow)> rows(int? parentId) {
      final list = [
        for (final c in _categories.values)
          if (c.kind == kind && c.parentId == parentId && flows[c.id] != null)
            (c, flows[c.id]!),
      ]..removeWhere((e) => e.$2.amountCents <= 0 && e.$2.goalCents == null);
      list.sort((a, b) => b.$2.amountCents.compareTo(a.$2.amountCents));
      return list;
    }

    final top = rows(null);
    final unclassified = isExpense
        ? r.unclassifiedOutCents
        : r.unclassifiedInCents;
    final max = [
      for (final (_, f) in top) f.amountCents,
      unclassified,
    ].fold(0, (a, b) => a > b ? a : b);

    final children = <Widget>[];
    for (final (c, f) in top) {
      final sub = rows(c.id);
      final open = _expanded.contains(c.id);
      children.add(
        _RankRow(
          name: context.categoryName(c),
          flow: f,
          max: max,
          total: total,
          period: _period,
          expense: isExpense,
          expandable: sub.isNotEmpty,
          expanded: open,
          onTap: sub.isEmpty
              ? () => _showOperations(context.categoryName(c), categoryId: c.id)
              : () => setState(
                  () => open ? _expanded.remove(c.id) : _expanded.add(c.id!),
                ),
          onOperations: () =>
              _showOperations(context.categoryName(c), categoryId: c.id),
          onGoal: isExpense && _canWrite && _period == BudgetPeriod.month
              ? () => _editGoal(c, f)
              : null,
        ),
      );
      if (open) {
        for (final (s, sf) in sub) {
          children.add(
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: _RankRow(
                name: context.categoryName(s),
                flow: sf,
                max: f.amountCents,
                total: total,
                period: _period,
                expense: isExpense,
                onTap: () => _showOperations(
                  context.categoryName(s),
                  categoryId: s.id,
                ),
                onOperations: () => _showOperations(
                  context.categoryName(s),
                  categoryId: s.id,
                ),
                onGoal: isExpense && _canWrite && _period == BudgetPeriod.month
                    ? () => _editGoal(s, sf)
                    : null,
              ),
            ),
          );
        }
      }
    }
    if (unclassified > 0) {
      children.add(
        _RankRow(
          name: l.toClassify,
          flow: CategoryFlow(
            categoryId: -1,
            amountCents: unclassified,
            count: 0,
            previousCents: 0,
            averageCents: 0,
          ),
          max: max,
          total: total,
          period: _period,
          expense: isExpense,
          muted: true,
          onTap: () => _showOperations(l.toClassify),
          onOperations: () => _showOperations(l.toClassify),
        ),
      );
    }
    final goalButton = isExpense && _canWrite && _period == BudgetPeriod.month
        ? TextButton.icon(
            icon: const Icon(Icons.flag_outlined),
            label: Text(l.goalAdd),
            onPressed: () async {
              final expenses = [
                for (final c in _categories.values)
                  if (c.kind == CategoryKind.expense) c,
              ];
              final choice = await showCategoryPicker(
                context,
                categories: expenses,
              );
              final picked = _categories[choice?.id];
              if (picked != null && mounted) {
                await _editGoal(picked, flows[picked.id]);
              }
            },
          )
        : null;
    return _card(
      context,
      isExpense ? l.rankingExpenses : l.rankingIncome,
      children.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(l.rankingEmpty, textAlign: TextAlign.center),
            )
          : Column(children: children),
      trailing: goalButton,
    );
  }
}

/// "Left to live on until pay day", the figure and how it is made.
class _LeftToLiveCard extends StatelessWidget {
  final LeftToLiveReport report;
  const _LeftToLiveCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = report;
    final negative = r.leftCents < 0;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.leftToLiveTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Row(
              children: [
                if (negative) ...[
                  const Icon(Icons.error, color: ChartColors.critical),
                  const SizedBox(width: 8),
                ],
                Text(
                  context.money(r.leftCents),
                  style: theme.textTheme.headlineMedium,
                ),
              ],
            ),
            Text(
              l.leftToLiveBody(
                context.money(r.perDayCents),
                r.daysLeft,
                context.day(r.last),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.leftToLiveDetail(
                context.money(r.balanceCents),
                context.money(r.plannedDebitsCents),
                context.money(r.plannedCreditsCents),
              ),
              style: theme.textTheme.bodySmall,
            ),
            Text(l.leftToLiveHelp, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? delta;

  /// Whether the change is good news (null: neutral).
  final bool? good;

  const _StatTile({
    required this.label,
    required this.value,
    this.delta,
    this.good,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final g = good;
    return SizedBox(
      width: 170,
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
              if (delta != null)
                Row(
                  children: [
                    if (g != null)
                      Icon(
                        g ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: g ? ChartColors.good : ChartColors.critical,
                      ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        delta!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One category of the ranking: amount, share, change, and its goal.
class _RankRow extends StatelessWidget {
  final String name;
  final CategoryFlow flow;
  final int max;
  final int total;
  final BudgetPeriod period;
  final bool expense;
  final bool expandable;
  final bool expanded;
  final bool muted;
  final VoidCallback onTap;
  final VoidCallback onOperations;
  final VoidCallback? onGoal;

  const _RankRow({
    required this.name,
    required this.flow,
    required this.max,
    required this.total,
    required this.period,
    required this.expense,
    required this.onTap,
    required this.onOperations,
    this.onGoal,
    this.expandable = false,
    this.expanded = false,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final f = flow;
    final share = total <= 0 ? 0 : (f.amountCents * 100 / total).round();
    final goal = f.goalCents;
    final details = <String>[
      l.rankingShare(share),
      if (!muted && f.previousCents != 0)
        l.rankingPrevious(context.money(f.previousCents)),
      if (!muted && f.averageCents > 0)
        l.rankingAverage(context.money(f.averageCents)),
    ];
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (expandable)
                  Icon(
                    expanded ? Icons.expand_more : Icons.chevron_right,
                    size: 20,
                  ),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: muted ? theme.colorScheme.tertiary : null,
                    ),
                  ),
                ),
                Text(
                  context.money(f.amountCents),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontFamily: 'Manrope',
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                PopupMenuButton<int>(
                  tooltip: l.moreActions,
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (v) => v == 0 ? onOperations() : onGoal?.call(),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 0, child: Text(l.rankingOperations)),
                    if (onGoal != null)
                      PopupMenuItem(
                        value: 1,
                        child: Text(goal == null ? l.goalSet : l.goalEdit),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            ThinBar(
              fraction: max <= 0 ? 0 : f.amountCents / max,
              color: muted
                  ? theme.colorScheme.outline
                  : ChartColors.rank(context),
            ),
            const SizedBox(height: 4),
            Text(
              details.join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (goal != null) ...[
              const SizedBox(height: 6),
              _GoalMeter(spentCents: f.amountCents, goalCents: goal),
            ],
          ],
        ),
      ),
    );
  }
}

/// Spent against the monthly goal: green, orange, then red, always with an
/// icon and a label.
class _GoalMeter extends StatelessWidget {
  final int spentCents;
  final int goalCents;
  const _GoalMeter({required this.spentCents, required this.goalCents});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final level = core.goalLevel(spentCents, goalCents);
    final (color, icon, status) = switch (level) {
      core.GoalLevel.ok => (ChartColors.good, Icons.check_circle, l.goalOk),
      core.GoalLevel.warning => (
        ChartColors.warning,
        Icons.warning_amber,
        l.goalWarning,
      ),
      core.GoalLevel.over => (ChartColors.critical, Icons.error, l.goalOver),
    };
    final pct = (spentCents * 100 / goalCents).round();
    final left = goalCents - spentCents;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ThinBar(fraction: spentCents / goalCents, color: color, height: 6),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '$status · ${l.goalProgress(pct, context.money(goalCents))} · '
                '${left >= 0 ? l.goalLeft(context.money(left)) : l.goalExceeded(context.money(-left))}',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GoalDialog extends StatefulWidget {
  final int groupId;
  final Category category;
  final CategoryFlow? flow;
  final String name;

  const _GoalDialog({
    required this.groupId,
    required this.category,
    required this.flow,
    required this.name,
  });

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  late final _amount = TextEditingController(
    text: widget.flow?.goalCents == null
        ? ''
        : core.formatCents(widget.flow!.goalCents!, decimalSeparator: ','),
  );
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  /// Pops with [result] ('saved' or 'removed') once [call] succeeded.
  Future<void> _run(Future<void> Function() call, String result) async {
    setState(() => (_busy = true, _error = null));
    try {
      await call();
      if (mounted) Navigator.of(context).pop(result);
    } on Object catch (e) {
      if (mounted) {
        setState(
          () => (
            _busy = false,
            _error = errorText(AppLocalizations.of(context), e),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final f = widget.flow;
    final suggestion = f == null || f.averageCents <= 0
        ? null
        : core.suggestedGoal([f.averageCents]);
    return AlertDialog(
      title: Text(l.goalTitle(widget.name)),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.goalHelp),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l.goalAmountLabel,
                suffixText: '€',
              ),
            ),
            if (suggestion != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: Text(
                    l.goalSuggestion(
                      context.money(suggestion),
                      context.money(f!.averageCents),
                    ),
                  ),
                  onPressed: () => _amount.text = core.formatCents(
                    suggestion,
                    decimalSeparator: ',',
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        if (f?.goalCents != null)
          TextButton(
            onPressed: _busy
                ? null
                : () => _run(
                    () =>
                        client.goal.remove(widget.groupId, widget.category.id!),
                    'removed',
                  ),
            child: Text(l.goalRemove),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _busy
              ? null
              : () {
                  final cents = parseUserAmount(_amount.text);
                  if (cents == null || cents <= 0) {
                    setState(() => _error = l.amountInvalid);
                    return;
                  }
                  _run(
                    () => client.goal
                        .set(widget.groupId, widget.category.id!, cents)
                        .then((_) {}),
                    'saved',
                  );
                },
          child: Text(l.save),
        ),
      ],
    );
  }
}

/// The operations behind a figure, largest first.
class _OperationsList extends StatelessWidget {
  final String title;
  final Future<List<BankTransaction>> load;
  final Map<int, Category> categories;
  final Map<int, Account> accounts;
  final ScrollController scroll;

  const _OperationsList({
    required this.title,
    required this.load,
    required this.categories,
    required this.accounts,
    required this.scroll,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return FutureBuilder<List<BankTransaction>>(
      future: load,
      builder: (context, snap) {
        final items = snap.data;
        return ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            if (items != null)
              Text(
                l.operationsCount(items.length),
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(height: 8),
            if (snap.hasError)
              Text(errorText(l, snap.error!))
            else if (items == null)
              const Center(child: CircularProgressIndicator())
            else
              for (final t in items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    t.cleanLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    [
                      context.shortDay(t.date),
                      if (categories[t.categoryId] != null)
                        context.categoryName(categories[t.categoryId]!),
                      if (accounts.length > 1 && accounts[t.accountId] != null)
                        accounts[t.accountId]!.name,
                    ].join(' · '),
                  ),
                  trailing: Text(
                    context.money(
                      t.amountCents,
                      currency: accounts[t.accountId]?.currency ?? 'EUR',
                    ),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}
