import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/budget_charts.dart';
import '../widgets/category_field.dart';
import 'budget_screen.dart';

/// What is compared: categories over time, periods, or accounts.
enum CompareMode { categories, periods, accounts }

/// Several selections side by side: a few categories over the last
/// periods, the same budget over several periods (this month, last month,
/// the same month last year…), or several accounts over one period. Every
/// figure comes from the budget report, computed by the server on the
/// accounts the user may see.
class CompareScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;
  final Map<int, Category> categories;
  final BudgetPeriod period;
  final DateTime date;
  final int? accountId;

  const CompareScreen({
    super.key,
    required this.membership,
    required this.accounts,
    required this.categories,
    required this.period,
    required this.date,
    this.accountId,
  });

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

/// One column of a comparison: its name and its report.
typedef _Column = ({String name, SpendingReport report});

class _CompareScreenState extends State<CompareScreen> {
  static const _max = 4;

  var _mode = CompareMode.categories;
  late var _period = widget.period;
  var _kind = CategoryKind.expense;
  var _periods = 12;
  late int? _accountId = widget.accountId;

  /// Categories compared over time.
  final List<int> _picked = [];

  /// Any day of each period compared, the reference first.
  late List<DateTime> _dates = _defaultDates();

  /// Accounts compared.
  late List<int> _accountIds = [
    for (final a in widget.accounts.take(_max)) a.id!,
  ];

  List<_Column>? _columns;
  String? _error;
  var _loading = false;

  int get _groupId => widget.membership.group.id!;
  int get _startDay => widget.membership.group.monthStartDay;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// This period, the previous one and, below a year, the same one a year
  /// earlier.
  List<DateTime> _defaultDates() {
    final d = widget.date;
    DateTime months(int n) =>
        DateTime.utc(d.year, d.month + n, d.day.clamp(1, 28));
    return switch (_period) {
      BudgetPeriod.week => [
        d,
        d.subtract(const Duration(days: 7)),
        d.subtract(const Duration(days: 364)),
      ],
      BudgetPeriod.month => [d, months(-1), months(-12)],
      BudgetPeriod.quarter => [d, months(-3), months(-12)],
      BudgetPeriod.year => [d, months(-12), months(-24)],
    };
  }

  Future<void> _load() async {
    setState(() => (_loading = true, _error = null));
    try {
      final List<_Column> columns;
      switch (_mode) {
        case CompareMode.categories:
          final r = await client.analysis.report(
            _groupId,
            _period,
            widget.date,
            accountId: _accountId,
            periods: _periods,
          );
          columns = [(name: '', report: r)];
          if (_picked.isEmpty) _picked.addAll(_leading(r));
        case CompareMode.periods:
          final reports = await Future.wait([
            for (final d in _dates)
              client.analysis.report(
                _groupId,
                _period,
                d,
                accountId: _accountId,
              ),
          ]);
          if (!mounted) return;
          columns = [
            for (final r in reports)
              (
                name: budgetPeriodLabel(context, _period, r.start, r.last),
                report: r,
              ),
          ];
        case CompareMode.accounts:
          final names = {for (final a in widget.accounts) a.id!: a.name};
          final reports = await Future.wait([
            for (final id in _accountIds)
              client.analysis.report(
                _groupId,
                _period,
                widget.date,
                accountId: id,
              ),
          ]);
          columns = [
            for (final (i, r) in reports.indexed)
              (name: names[_accountIds[i]] ?? '', report: r),
          ];
      }
      if (mounted) setState(() => _columns = columns);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// The three largest top-level categories of the kind over the report.
  List<int> _leading(SpendingReport r) {
    final tops = [
      for (final f in r.categories)
        if (widget.categories[f.categoryId] case final c?)
          if (c.kind == _kind && c.parentId == null)
            (f.categoryId, f.history.fold(0, (a, v) => a + v)),
    ]..removeWhere((e) => e.$2 <= 0);
    tops.sort((a, b) => b.$2.compareTo(a.$2));
    return [for (final e in tops.take(3)) e.$1];
  }

  String _name(int id) {
    final c = widget.categories[id];
    return c == null ? '?' : categoryPath(context, c, widget.categories);
  }

  // --- choices ---------------------------------------------------------------

  Future<void> _addCategory() async {
    final choice = await showCategoryPicker(
      context,
      categories: [
        for (final c in widget.categories.values)
          if (c.kind == _kind) c,
      ],
    );
    final id = choice?.id;
    if (id == null || _picked.contains(id) || _picked.length >= _max) return;
    setState(() => _picked.add(id));
  }

  Future<void> _addPeriod() async {
    final last = _dates.last;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(last.year, last.month, last.day),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: AppLocalizations.of(context).compareAddPeriodHelp,
    );
    if (picked == null) return;
    setState(
      () => _dates = [
        ..._dates,
        DateTime.utc(picked.year, picked.month, picked.day),
      ],
    );
    await _load();
  }

  // --- build -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final columns = _columns;
    return Scaffold(
      appBar: AppBar(title: Text(l.compareTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _controls(context, l),
                  const SizedBox(height: 16),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(_error!, textAlign: TextAlign.center),
                    )
                  else if (columns == null || _loading)
                    const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    switch (_mode) {
                      CompareMode.categories => _overTime(
                        context,
                        l,
                        columns.single.report,
                      ),
                      _ => _sideBySide(context, l, columns),
                    },
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controls(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.compareIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        SegmentedButton<CompareMode>(
          segments: [
            ButtonSegment(
              value: CompareMode.categories,
              icon: const Icon(Icons.category_outlined),
              label: Text(l.compareCategories),
            ),
            ButtonSegment(
              value: CompareMode.periods,
              icon: const Icon(Icons.date_range),
              label: Text(l.comparePeriods),
            ),
            if (widget.accounts.length > 1)
              ButtonSegment(
                value: CompareMode.accounts,
                icon: const Icon(Icons.account_balance_wallet_outlined),
                label: Text(l.compareAccounts),
              ),
          ],
          selected: {_mode},
          showSelectedIcon: false,
          onSelectionChanged: (s) {
            setState(() => (_mode = s.single, _columns = null));
            _load();
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropdownButton<BudgetPeriod>(
              value: _period,
              items: [
                for (final (p, name) in [
                  (BudgetPeriod.week, l.periodWeek),
                  (BudgetPeriod.month, l.periodMonth),
                  (BudgetPeriod.quarter, l.periodQuarter),
                  (BudgetPeriod.year, l.periodYear),
                ])
                  DropdownMenuItem(value: p, child: Text(name)),
              ],
              onChanged: (v) {
                if (v == null || v == _period) return;
                setState(() {
                  _period = v;
                  _dates = _defaultDates();
                });
                _load();
              },
            ),
            SegmentedButton<CategoryKind>(
              segments: [
                ButtonSegment(
                  value: CategoryKind.expense,
                  label: Text(l.budgetExpenses),
                ),
                ButtonSegment(
                  value: CategoryKind.income,
                  label: Text(l.budgetIncome),
                ),
              ],
              selected: {_kind},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() {
                _kind = s.single;
                _picked
                  ..clear()
                  ..addAll(
                    _mode == CompareMode.categories && _columns != null
                        ? _leading(_columns!.single.report)
                        : const [],
                  );
              }),
            ),
            if (_mode == CompareMode.categories)
              DropdownButton<int>(
                value: _periods,
                items: [
                  for (final n in const [6, 12, 24])
                    DropdownMenuItem(
                      value: n,
                      child: Text(l.spendingPeriods(n)),
                    ),
                ],
                onChanged: (v) {
                  if (v == null || v == _periods) return;
                  setState(() => _periods = v);
                  _load();
                },
              ),
            if (_mode != CompareMode.accounts && widget.accounts.length > 1)
              DropdownButton<int?>(
                value: _accountId,
                items: [
                  DropdownMenuItem(value: null, child: Text(l.allAccounts)),
                  for (final a in widget.accounts)
                    DropdownMenuItem(value: a.id, child: Text(a.name)),
                ],
                onChanged: (v) {
                  setState(() => _accountId = v);
                  _load();
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        // The selections, each removable; the first is the reference.
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: switch (_mode) {
            CompareMode.categories => [
              for (final (i, id) in _picked.indexed)
                InputChip(
                  avatar: CircleAvatar(
                    backgroundColor: SeriesColors.of(context, i),
                  ),
                  label: Text(_name(id)),
                  onDeleted: () => setState(() => _picked.remove(id)),
                ),
              if (_picked.length < _max)
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(l.compareAddCategory),
                  onPressed: _addCategory,
                ),
            ],
            CompareMode.periods => [
              for (final (i, d) in _dates.indexed)
                InputChip(
                  avatar: CircleAvatar(
                    backgroundColor: SeriesColors.of(context, i),
                  ),
                  label: Text(
                    _columns != null && i < _columns!.length
                        ? _columns![i].name
                        : context.day(d),
                  ),
                  onDeleted: _dates.length <= 2
                      ? null
                      : () {
                          setState(() => _dates = [..._dates]..removeAt(i));
                          _load();
                        },
                ),
              if (_dates.length < _max)
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(l.compareAddPeriod),
                  onPressed: _addPeriod,
                ),
            ],
            CompareMode.accounts => [
              for (final a in widget.accounts)
                FilterChip(
                  label: Text(a.name),
                  selected: _accountIds.contains(a.id),
                  onSelected: (on) {
                    final next = [
                      for (final b in widget.accounts)
                        if (b.id == a.id ? on : _accountIds.contains(b.id))
                          b.id!,
                    ];
                    if (next.length < 2 || next.length > _max) return;
                    setState(() => _accountIds = next);
                    _load();
                  },
                ),
            ],
          },
        ),
      ],
    );
  }

  /// Categories over the last periods: one line each, then the table.
  Widget _overTime(
    BuildContext context,
    AppLocalizations l,
    SpendingReport r,
  ) {
    final flows = {for (final f in r.categories) f.categoryId: f};
    final ids = [
      for (final id in _picked)
        if (widget.categories[id]?.kind == _kind) id,
    ];
    if (ids.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(l.compareNothing, textAlign: TextAlign.center),
      );
    }
    List<int> values(int id) =>
        flows[id]?.history ?? List.filled(r.history.length, 0);
    final labels = [
      for (final h in r.history)
        budgetPeriodShort(context, _period, h.start, _startDay),
    ];
    final figures = const TextStyle(
      fontFeatures: [FontFeature.tabularFigures()],
    );
    int total(int id) => values(id).fold(0, (a, v) => a + v);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card(
          context,
          l.compareOverTime,
          TrendChart(
            labels: labels,
            series: [
              for (final (i, id) in ids.indexed)
                ChartSeries(
                  label: _name(id),
                  color: SeriesColors.of(context, i),
                  values: values(id),
                ),
            ],
            semanticLabel: l.compareOverTime,
            money: (c) => context.money(c),
            axisMoney: (c) => budgetAxisMoney(context, c),
          ),
        ),
        const SizedBox(height: 16),
        _card(
          context,
          l.spendingViewTable,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              horizontalMargin: 8,
              headingRowHeight: 44,
              columns: [
                DataColumn(label: Text(l.compareColumnPeriod)),
                for (final id in ids)
                  DataColumn(label: Text(_name(id)), numeric: true),
              ],
              rows: [
                for (var p = labels.length - 1; p >= 0; p--)
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          budgetPeriodLabel(
                            context,
                            _period,
                            r.history[p].start,
                            _lastOf(r, p),
                          ),
                        ),
                      ),
                      for (final id in ids)
                        DataCell(
                          Text(
                            context.money(values(id)[p]),
                            style: figures,
                          ),
                        ),
                    ],
                  ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        l.compareTotal,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    for (final id in ids)
                      DataCell(
                        Text(
                          context.money(total(id)),
                          style: figures.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(l.compareAverage)),
                    for (final id in ids)
                      DataCell(
                        Text(
                          context.money(total(id) ~/ labels.length),
                          style: figures,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Last day of the [p]-th period of the history.
  DateTime _lastOf(SpendingReport r, int p) => p + 1 < r.history.length
      ? r.history[p + 1].start.subtract(const Duration(days: 1))
      : r.last;

  /// Periods or accounts side by side: the totals, then each category with
  /// one bar per column and the gap to the first one.
  Widget _sideBySide(
    BuildContext context,
    AppLocalizations l,
    List<_Column> columns,
  ) {
    final theme = Theme.of(context);
    final isExpense = _kind == CategoryKind.expense;
    int totalOf(SpendingReport r) => isExpense ? r.expenseCents : r.incomeCents;
    final byColumn = [
      for (final c in columns)
        {for (final f in c.report.categories) f.categoryId: f.amountCents},
    ];
    final tops = [
      for (final c in widget.categories.values)
        if (c.kind == _kind &&
            c.parentId == null &&
            byColumn.any((m) => (m[c.id] ?? 0) > 0))
          c.id!,
    ];
    int largest(int id) =>
        byColumn.fold(0, (a, m) => (m[id] ?? 0) > a ? m[id]! : a);
    tops.sort((a, b) => largest(b).compareTo(largest(a)));
    final max = tops.isEmpty ? 0 : largest(tops.first);

    Widget bars(List<int> amounts, int scale) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, cents) in amounts.indexed)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Expanded(
                  child: ThinBar(
                    fraction: scale <= 0 ? 0 : cents / scale,
                    color: SeriesColors.of(context, i),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 170,
                  child: Text(
                    i == 0
                        ? context.money(cents)
                        : '${context.money(cents)}  ${_gap(l, cents, amounts.first)}',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    final totals = [for (final c in columns) totalOf(c.report)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Legend: one colour per column, the first is the reference.
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            for (final (i, c) in columns.indexed)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: SeriesColors.of(context, i),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(i == 0 ? l.compareReference(c.name) : c.name),
                ],
              ),
          ],
        ),
        const SizedBox(height: 12),
        _card(
          context,
          isExpense ? l.budgetExpenses : l.budgetIncome,
          bars(totals, totals.fold(0, (a, v) => v > a ? v : a)),
        ),
        const SizedBox(height: 16),
        _card(
          context,
          l.compareByCategory,
          tops.isEmpty
              ? Text(l.rankingEmpty)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final id in tops)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(_name(id), style: theme.textTheme.titleSmall),
                            bars([for (final m in byColumn) m[id] ?? 0], max),
                          ],
                        ),
                      ),
                  ],
                ),
          subtitle: l.compareGapHelp,
        ),
      ],
    );
  }

  /// "+12 € · +8 %" against the reference.
  String _gap(AppLocalizations l, int cents, int reference) {
    final d = cents - reference;
    if (d == 0) return l.compareSame;
    final money = context.money(d.abs());
    final sign = d > 0 ? '+' : '−';
    if (reference <= 0) return '$sign$money';
    final pct = (d.abs() * 100 / reference).round();
    return '$sign$money · $sign${l.sharePercent(pct)}';
  }

  Widget _card(
    BuildContext context,
    String title,
    Widget child, {
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
            Text(title, style: theme.textTheme.titleMedium),
            if (subtitle != null)
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
