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

  /// Share of the period already passed (1 for a past period), for the
  /// "where you should be today" mark on goals.
  double _elapsed(SpendingReport r) {
    final today = todayUtcMidnight();
    if (today.isBefore(r.start)) return 0;
    if (today.isAfter(r.last)) return 1;
    final days = r.last.difference(r.start).inDays + 1;
    return (today.difference(r.start).inDays + 1) / days;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final r = _report;
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  if (r != null) ..._body(context, l, r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _body(
    BuildContext context,
    AppLocalizations l,
    SpendingReport r,
  ) {
    final left = _left;
    final showLeft =
        left != null &&
        _period == BudgetPeriod.month &&
        !todayUtcMidnight().isBefore(r.start) &&
        !todayUtcMidnight().isAfter(r.last);
    const gap = SizedBox(height: 16);
    return [
      const SizedBox(height: 12),
      // Overview first: what came in, what went out, what is left.
      LayoutBuilder(
        builder: (context, box) {
          final wide = box.maxWidth >= 720;
          final balance = BalanceCard(
            report: r,
            previous: r.history.length >= 2
                ? r.history[r.history.length - 2]
                : null,
          );
          if (!showLeft) return balance;
          final leftCard = LeftToLiveCard(report: left);
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: balance),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: leftCard),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [balance, gap, leftCard],
                );
        },
      ),
      if (r.unclassifiedCount > 0) ...[
        gap,
        _UnclassifiedBanner(
          count: r.unclassifiedCount,
          cents: r.unclassifiedOutCents + r.unclassifiedInCents,
          onOpen: () => _showOperations(l.toClassify),
        ),
      ],
      if (_period == BudgetPeriod.month) ...[gap, _goals(context, l, r)],
      gap,
      _ranking(context, l, r, CategoryKind.expense),
      gap,
      _ranking(context, l, r, CategoryKind.income),
      gap,
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
    ];
  }

  Widget _controls(
    BuildContext context,
    AppLocalizations l,
    SpendingReport? r,
  ) {
    final theme = Theme.of(context);
    final today = todayUtcMidnight();
    void open(Widget screen) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SegmentedButton<BudgetPeriod>(
              segments: [
                ButtonSegment(
                  value: BudgetPeriod.week,
                  label: Text(l.periodWeek),
                ),
                ButtonSegment(
                  value: BudgetPeriod.month,
                  label: Text(l.periodMonth),
                ),
                ButtonSegment(
                  value: BudgetPeriod.year,
                  label: Text(l.periodYear),
                ),
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
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Text(
                    r == null ? '' : _periodLabel(context, r),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
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
          ],
        ),
        const SizedBox(height: 8),
        // Shortcuts to the other views of the budget.
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.fact_check_outlined, size: 18),
              label: Text(l.reviewTitle),
              onPressed: () => open(
                ReviewScreen(
                  membership: widget.membership,
                  accountId: _accountId,
                  date: _period == BudgetPeriod.month
                      ? _date
                      : todayUtcMidnight(),
                ),
              ),
            ),
            ActionChip(
              avatar: const Icon(Icons.calendar_month_outlined, size: 18),
              label: Text(l.calendarTitle),
              onPressed: () => open(
                CalendarScreen(
                  membership: widget.membership,
                  accounts: widget.accounts,
                  accountId: _accountId,
                ),
              ),
            ),
            ActionChip(
              avatar: const Icon(Icons.autorenew, size: 18),
              label: Text(l.subscriptionsTitle),
              onPressed: () => open(
                SubscriptionsScreen(
                  membership: widget.membership,
                  accounts: widget.accounts,
                ),
              ),
            ),
            if (_isAdmin)
              ActionChip(
                avatar: const Icon(Icons.event_repeat, size: 18),
                label: Text(l.monthStartTitle),
                onPressed: _settings,
              ),
          ],
        ),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    String title,
    Widget child, {
    Widget? trailing,
    String? subtitle,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
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

  /// Every goal of the month in one place, the most used first.
  Widget _goals(BuildContext context, AppLocalizations l, SpendingReport r) {
    final goals =
        [
          for (final f in r.categories)
            if (f.goalCents != null && _categories[f.categoryId] != null) f,
        ]..sort(
          (a, b) => (b.amountCents * 1000 ~/ b.goalCents!).compareTo(
            a.amountCents * 1000 ~/ a.goalCents!,
          ),
        );
    final levels = [
      for (final g in goals) core.goalLevel(g.amountCents, g.goalCents!),
    ];
    int count(core.GoalLevel v) => levels.where((x) => x == v).length;
    final add = _canWrite
        ? TextButton.icon(
            icon: const Icon(Icons.add),
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
                await _editGoal(
                  picked,
                  r.categories
                      .where((f) => f.categoryId == picked.id)
                      .firstOrNull,
                );
              }
            },
          )
        : null;
    final elapsed = _elapsed(r);
    return _card(
      context,
      l.goalsTitle,
      goals.isEmpty
          ? Text(l.goalsEmpty)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final g in goals)
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _canWrite
                        ? () => _editGoal(_categories[g.categoryId]!, g)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  categoryPath(
                                    context,
                                    _categories[g.categoryId]!,
                                    _categories,
                                  ),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                l.goalSpentOf(
                                  context.money(g.amountCents),
                                  context.money(g.goalCents!),
                                ),
                                style: const TextStyle(
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          GoalMeter(
                            spentCents: g.amountCents,
                            goalCents: g.goalCents!,
                            elapsed: elapsed < 1 ? elapsed : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (elapsed < 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l.goalPaceHelp,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
      subtitle: goals.isEmpty
          ? null
          : l.goalsSummary(
              count(core.GoalLevel.ok),
              count(core.GoalLevel.warning),
              count(core.GoalLevel.over),
            ),
      trailing: add,
    );
  }

  static const _shown = 6;

  Widget _ranking(
    BuildContext context,
    AppLocalizations l,
    SpendingReport r,
    CategoryKind kind,
  ) {
    final flows = {for (final f in r.categories) f.categoryId: f};
    final isExpense = kind == CategoryKind.expense;
    final total = isExpense ? r.expenseCents : r.incomeCents;
    final color = isExpense
        ? ChartColors.expense(context)
        : ChartColors.income(context);
    List<(Category, CategoryFlow)> rows(int? parentId) {
      final list = [
        for (final c in _categories.values)
          if (c.kind == kind && c.parentId == parentId && flows[c.id] != null)
            (c, flows[c.id]!),
      ]..removeWhere((e) => e.$2.amountCents <= 0);
      list.sort((a, b) => b.$2.amountCents.compareTo(a.$2.amountCents));
      return list;
    }

    final top = rows(null);
    final max = top.fold(
      0,
      (a, e) => a > e.$2.amountCents ? a : e.$2.amountCents,
    );
    final all = _expanded.contains(isExpense ? -1 : -2);
    final children = <Widget>[];
    for (final (c, f) in all ? top : top.take(_shown)) {
      final sub = rows(c.id);
      final open = _expanded.contains(c.id);
      final name = context.categoryName(c);
      children.add(
        RankRow(
          name: name,
          flow: f,
          max: max,
          total: total,
          color: color,
          expense: isExpense,
          expandable: sub.isNotEmpty,
          expanded: open,
          onTap: sub.isEmpty
              ? () => _showOperations(name, categoryId: c.id)
              : () => setState(
                  () => open ? _expanded.remove(c.id) : _expanded.add(c.id!),
                ),
          onOperations: () => _showOperations(name, categoryId: c.id),
          onGoal: isExpense && _canWrite && _period == BudgetPeriod.month
              ? () => _editGoal(c, f)
              : null,
        ),
      );
      if (open) {
        children.add(
          SubRows(
            children: [
              for (final (s, sf) in sub)
                RankRow(
                  name: context.categoryName(s),
                  flow: sf,
                  max: f.amountCents,
                  total: total,
                  color: color,
                  expense: isExpense,
                  child: true,
                  onTap: () => _showOperations(
                    '$name › ${context.categoryName(s)}',
                    categoryId: s.id,
                  ),
                  onOperations: () => _showOperations(
                    '$name › ${context.categoryName(s)}',
                    categoryId: s.id,
                  ),
                  onGoal:
                      isExpense && _canWrite && _period == BudgetPeriod.month
                      ? () => _editGoal(s, sf)
                      : null,
                ),
            ],
          ),
        );
      }
    }
    if (top.length > _shown) {
      children.add(
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: Icon(all ? Icons.expand_less : Icons.expand_more),
            label: Text(all ? l.rankingShowLess : l.rankingShowAll(top.length)),
            onPressed: () => setState(
              () => all
                  ? _expanded.remove(isExpense ? -1 : -2)
                  : _expanded.add(isExpense ? -1 : -2),
            ),
          ),
        ),
      );
    }
    return _card(
      context,
      isExpense ? l.rankingExpenses : l.rankingIncome,
      children.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(l.rankingEmpty, textAlign: TextAlign.center),
            )
          : Column(children: children),
      subtitle: l.rankingTotal(context.money(total)),
    );
  }
}

/// Income, expenses and savings of the period, and what is left: two bars on
/// one scale show at a glance whether spending stays below income.
class BalanceCard extends StatelessWidget {
  final SpendingReport report;
  final PeriodTotals? previous;
  const BalanceCard({super.key, required this.report, required this.previous});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = report;
    final p = previous;
    final out = r.expenseCents + r.savingsCents;
    final scale = r.incomeCents > out ? r.incomeCents : out;
    final negative = r.netCents < 0;
    String? delta(int now, int? before) {
      if (before == null || before == 0) return null;
      final pct = ((now - before) * 100 / before.abs()).round();
      return '${pct > 0 ? '+' : ''}$pct %';
    }

    Widget figure(
      String label,
      int cents,
      Color? color,
      int? before, {
      bool lowerIsBetter = false,
    }) {
      final d = delta(cents, before);
      final good = before == null || cents == before
          ? null
          : (cents > before) != lowerIsBetter;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (color != null) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(label, style: theme.textTheme.labelLarge),
            ],
          ),
          Text(
            context.money(cents),
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (d != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (good != null)
                  Icon(
                    cents > before! ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: good ? ChartColors.good : ChartColors.critical,
                  ),
                Flexible(
                  child: Text(
                    l.budgetVsPrevious(d),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.budgetBalanceTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  negative ? Icons.error : Icons.check_circle,
                  color: negative ? ChartColors.critical : ChartColors.good,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    negative
                        ? l.budgetOverspent(context.money(-r.netCents))
                        : l.budgetLeftOver(context.money(r.netCents)),
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Semantics(
              label: l.budgetBarsSemantic(
                context.money(r.incomeCents),
                context.money(out),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ThinBar(
                    fraction: scale <= 0 ? 0 : r.incomeCents / scale,
                    color: ChartColors.income(context),
                    height: 14,
                  ),
                  const SizedBox(height: 6),
                  ThinBar(
                    fraction: scale <= 0 ? 0 : out / scale,
                    color: ChartColors.expense(context),
                    height: 14,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 32,
              runSpacing: 12,
              children: [
                figure(
                  l.budgetIncome,
                  r.incomeCents,
                  ChartColors.income(context),
                  p?.incomeCents,
                ),
                figure(
                  l.budgetExpensesAndSavings,
                  out,
                  ChartColors.expense(context),
                  p == null ? null : p.expenseCents + p.savingsCents,
                  lowerIsBetter: true,
                ),
                if (r.savingsCents != 0)
                  figure(
                    l.budgetSavingsPart,
                    r.savingsCents,
                    null,
                    p?.savingsCents,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Operations not classified yet: they weigh in the totals, not in the
/// rankings.
class _UnclassifiedBanner extends StatelessWidget {
  final int count;
  final int cents;
  final VoidCallback onOpen;
  const _UnclassifiedBanner({
    required this.count,
    required this.cents,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer,
      child: ListTile(
        leading: Icon(
          Icons.label_off_outlined,
          color: theme.colorScheme.onSecondaryContainer,
        ),
        title: Text(l.unclassifiedBanner(count, context.money(cents))),
        subtitle: Text(l.unclassifiedBannerHelp),
        trailing: FilledButton.tonal(
          onPressed: onOpen,
          child: Text(l.classifyNow),
        ),
        onTap: onOpen,
      ),
    );
  }
}

/// Sub-categories under their parent: indented along a guide line, in a
/// lighter style, so the hierarchy reads at a glance.
class SubRows extends StatelessWidget {
  final List<Widget> children;
  const SubRows({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(left: 14, bottom: 8),
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.outlineVariant, width: 2),
        ),
      ),
      child: Column(children: children),
    );
  }
}

/// "Left to live on until pay day": the amount per day first, then how it
/// is made.
class LeftToLiveCard extends StatelessWidget {
  final LeftToLiveReport report;
  const LeftToLiveCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = report;
    final negative = r.leftCents < 0;
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.leftToLiveTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (negative) ...[
                  const Icon(Icons.error, color: ChartColors.critical),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.money(r.leftCents),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              l.leftToLiveBody(
                context.money(r.perDayCents),
                r.daysLeft,
                context.day(r.last),
              ),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l.leftToLiveDetail(
                context.money(r.balanceCents),
                context.money(r.plannedDebitsCents),
                context.money(r.plannedCreditsCents),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              l.leftToLiveHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One category of the ranking: amount, share of the total and change
/// against the average. A top-level category is bold with a thick bar; a
/// sub-category ([child]) is lighter, with a thin bar.
class RankRow extends StatelessWidget {
  final String name;
  final CategoryFlow flow;
  final int max;
  final int total;
  final Color color;
  final bool expense;
  final bool expandable;
  final bool expanded;
  final bool child;
  final VoidCallback onTap;
  final VoidCallback onOperations;
  final VoidCallback? onGoal;

  const RankRow({
    super.key,
    required this.name,
    required this.flow,
    required this.max,
    required this.total,
    required this.color,
    required this.expense,
    required this.onTap,
    required this.onOperations,
    this.onGoal,
    this.expandable = false,
    this.expanded = false,
    this.child = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final f = flow;
    final share = total <= 0 ? 0 : (f.amountCents * 100 / total).round();
    final goal = f.goalCents;
    final avg = f.averageCents;
    final change = avg <= 0
        ? null
        : ((f.amountCents - avg) * 100 / avg).round();
    // Spending above its average is bad news, income above it good news.
    final good = change == null || change.abs() < 10
        ? null
        : (change > 0) != expense;
    final nameStyle = child
        ? theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          )
        : theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700);
    final amountStyle =
        (child ? theme.textTheme.bodyMedium : theme.textTheme.titleSmall)
            ?.copyWith(
              fontFamily: 'Manrope',
              fontWeight: child ? FontWeight.w500 : FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: child ? 6 : 10, horizontal: 4),
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
                    style: nameStyle,
                  ),
                ),
                if (goal != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Tooltip(
                      message: l.goalProgress(
                        (f.amountCents * 100 / goal).round(),
                        context.money(goal),
                      ),
                      child: Icon(
                        Icons.flag,
                        size: 16,
                        color: switch (core.goalLevel(f.amountCents, goal)) {
                          core.GoalLevel.ok => ChartColors.good,
                          core.GoalLevel.warning => ChartColors.warning,
                          core.GoalLevel.over => ChartColors.critical,
                        },
                      ),
                    ),
                  ),
                Text(context.money(f.amountCents), style: amountStyle),
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
              color: child ? color.withValues(alpha: 0.6) : color,
              height: child ? 6 : 10,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  l.rankingShare(share),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (change != null) ...[
                  const SizedBox(width: 12),
                  if (good != null)
                    Icon(
                      change > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: good ? ChartColors.good : ChartColors.critical,
                    ),
                  Flexible(
                    child: Text(
                      l.rankingVsAverage(
                        '${change > 0 ? '+' : ''}$change',
                        context.money(avg),
                      ),
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Spent against the monthly goal: green, orange, then red, always with an
/// icon and a label.
class GoalMeter extends StatelessWidget {
  final int spentCents;
  final int goalCents;

  /// Share of the month passed: a mark where spending should be today.
  final double? elapsed;
  const GoalMeter({
    super.key,
    required this.spentCents,
    required this.goalCents,
    this.elapsed,
  });

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
        ThinBar(
          fraction: spentCents / goalCents,
          color: color,
          height: 10,
          marker: elapsed,
        ),
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
