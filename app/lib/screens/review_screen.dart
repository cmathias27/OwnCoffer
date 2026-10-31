import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/budget_charts.dart';
import '../widgets/month_nav.dart';

/// Month-end review: what changed against the previous months and what it
/// cost (computed by the engine, every figure shown).
class ReviewScreen extends StatefulWidget {
  final GroupMembership membership;
  final int? accountId;

  /// A day of the month to review.
  final DateTime date;

  const ReviewScreen({
    super.key,
    required this.membership,
    required this.date,
    this.accountId,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late var _date = widget.date;
  MonthReview? _data;
  Map<int, Category> _categories = {};
  String? _error;

  int get _groupId => widget.membership.group.id!;

  @override
  void initState() {
    super.initState();
    client.category.list(_groupId).then((list) {
      if (mounted) {
        setState(() => _categories = {for (final c in list) c.id!: c});
      }
    }, onError: (_) {});
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await client.analysis.review(
        _groupId,
        _date,
        accountId: widget.accountId,
      );
      if (mounted) setState(() => (_data = d, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  void _shift(int months) {
    final start = _data?.start ?? _date;
    setState(() => (_date = shiftBudgetMonth(start, months), _data = null));
    _load();
  }

  String _name(int id) {
    final c = _categories[id];
    return c == null ? '…' : context.categoryName(c);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final d = _data;
    return Scaffold(
      appBar: AppBar(title: Text(l.reviewTitle)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Center(
              child: MonthNav(start: d?.start, last: d?.last, onShift: _shift),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, textAlign: TextAlign.center),
              )
            else if (d == null)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              ..._sections(context, l, d),
          ],
        ),
      ),
    );
  }

  List<Widget> _sections(
    BuildContext context,
    AppLocalizations l,
    MonthReview d,
  ) {
    final theme = Theme.of(context);
    Widget section(String title, List<Widget> children) => Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
    Widget line(String left, String right, {IconData? icon, Color? color}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
              ],
              Expanded(child: Text(left)),
              const SizedBox(width: 8),
              Text(
                right,
                style: const TextStyle(
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
    String money(int c) => context.money(c);
    final nothing =
        d.rises.isEmpty &&
        d.drops.isEmpty &&
        d.goalsOver.isEmpty &&
        d.bankFeesCents == 0 &&
        d.subscriptionChanges.isEmpty &&
        d.newSubscriptions.isEmpty;
    return [
      section(l.budgetNet, [
        Text(
          l.reviewNet(money(d.netCents), money(d.previousNetCents)),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        line(l.budgetIncome, money(d.incomeCents)),
        line(l.budgetExpenses, money(d.expenseCents)),
        line(l.budgetSavings, money(d.savingsCents)),
        if (d.unclassifiedCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l.reviewUnclassified(d.unclassifiedCount)),
          ),
      ]),
      if (nothing)
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l.reviewNothing, textAlign: TextAlign.center),
        ),
      if (d.goalsOver.isNotEmpty)
        section(l.reviewGoalsOver, [
          for (final g in d.goalsOver)
            line(
              _name(g.categoryId),
              l.reviewGoalOver(money(g.amountCents), money(g.goalCents ?? 0)),
              icon: Icons.error,
              color: ChartColors.critical,
            ),
        ]),
      if (d.rises.isNotEmpty)
        section(l.reviewRises, [
          for (final c in d.rises)
            line(
              _name(c.categoryId),
              l.reviewChange(money(c.amountCents), money(c.averageCents)),
              icon: Icons.trending_up,
            ),
        ]),
      if (d.drops.isNotEmpty)
        section(l.reviewDrops, [
          for (final c in d.drops)
            line(
              _name(c.categoryId),
              l.reviewChange(money(c.amountCents), money(c.averageCents)),
              icon: Icons.trending_down,
            ),
        ]),
      section(l.reviewFees, [
        Text(
          d.bankFeesCents == 0
              ? l.reviewNoFees
              : l.reviewFeesTotal(money(d.bankFeesCents)),
        ),
        for (final t in d.bankFees)
          line(
            '${context.day(t.date)} · ${t.cleanLabel}',
            money(t.amountCents),
          ),
      ]),
      if (d.subscriptionChanges.isNotEmpty || d.newSubscriptions.isNotEmpty)
        section(l.reviewSubscriptions, [
          for (final c in d.subscriptionChanges)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                l.reviewSubscriptionChange(
                  c.label,
                  money(c.actualCents),
                  money(c.plannedCents),
                ),
              ),
            ),
          for (final s in d.newSubscriptions)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                l.reviewNewSubscription(s.label, money(s.amountCents)),
              ),
            ),
        ]),
      if (d.biggestExpenses.isNotEmpty)
        section(l.reviewBiggest, [
          for (final t in d.biggestExpenses)
            line(
              '${context.day(t.date)} · ${t.cleanLabel}',
              money(t.amountCents),
            ),
        ]),
    ];
  }
}
