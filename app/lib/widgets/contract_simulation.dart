import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../screens/budget_screen.dart';
import '../screens/loans_screen.dart';
import '../util/format.dart';
import 'budget_charts.dart';
import 'soft.dart';

/// "What if I replaced this contract?": a subscription (or any monthly
/// amount) kept or replaced by another offer, over 1 to 10 years. Computed
/// by the shared engine (core.simulateContractSwitch); nothing is changed.
class ContractSimulation extends StatefulWidget {
  final GroupMembership membership;

  /// Starts from this subscription, and offers to apply the new price to it.
  final int? scheduledId;

  /// After the new price is applied.
  final VoidCallback? onApplied;

  const ContractSimulation({
    super.key,
    required this.membership,
    this.scheduledId,
    this.onApplied,
  });

  @override
  State<ContractSimulation> createState() => _ContractSimulationState();
}

class _ContractSimulationState extends State<ContractSimulation> {
  SubscriptionOverview? _subscriptions;
  int? _picked;
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _cost = TextEditingController();
  final _currentRise = TextEditingController();
  final _nextRise = TextEditingController();
  var _years = 5;

  @override
  void initState() {
    super.initState();
    client.scheduled.subscriptions(widget.membership.group.id!).then((o) {
      if (!mounted) return;
      setState(() => _subscriptions = o);
      final i = o.items.indexWhere((s) => s.id == widget.scheduledId);
      if (i >= 0) _pick(i);
    }, onError: (_) {});
    for (final c in [_current, _next, _cost, _currentRise, _nextRise]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_current, _next, _cost, _currentRise, _nextRise]) {
      c.dispose();
    }
    super.dispose();
  }

  static String _input(int cents) =>
      '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';

  void _pick(int? i) {
    setState(() => _picked = i);
    final o = _subscriptions;
    if (i == null || o == null) return;
    _current.text = _input(o.monthlyCents[i].abs());
  }

  /// Per mille from a percentage typed by the user ("3" or "2,5").
  static int? _perMille(String text) {
    if (text.trim().isEmpty) return 0;
    final milli = parseRateMilli(text);
    return milli == null ? null : milli ~/ 100;
  }

  core.ContractSwitch? get _result {
    final current = parseUserAmount(_current.text);
    final next = parseUserAmount(_next.text);
    final cost = _cost.text.trim().isEmpty ? 0 : parseUserAmount(_cost.text);
    final a = _perMille(_currentRise.text), b = _perMille(_nextRise.text);
    if (current == null || next == null || cost == null) return null;
    if (a == null || b == null) return null;
    try {
      return core.simulateContractSwitch(
        currentMonthlyCents: current,
        newMonthlyCents: next,
        months: _years * 12,
        switchCostCents: cost,
        currentYearlyIncreasePerMille: a,
        newYearlyIncreasePerMille: b,
      );
    } on ArgumentError {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final o = _subscriptions;
    final r = _result;
    Widget field(TextEditingController c, String label, {String? help}) =>
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TextField(
            controller: c,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: label,
              helperText: help,
              helperMaxLines: 2,
              suffixText: c == _currentRise || c == _nextRise ? '%' : '€',
            ),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.simIntro, style: theme.textTheme.bodyMedium),
        SoftSection(
          icon: Icons.description_outlined,
          title: l.simContract,
          children: [
            DropdownButtonFormField<int?>(
              isExpanded: true,
              initialValue: _picked,
              decoration: InputDecoration(labelText: l.simFrom),
              items: [
                DropdownMenuItem(value: null, child: Text(l.simFreeAmount)),
                if (o != null)
                  for (final (i, s) in o.items.indexed)
                    DropdownMenuItem(
                      value: i,
                      child: Text(
                        '${s.label} · ${context.money(o.monthlyCents[i].abs())}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              ],
              onChanged: _pick,
            ),
            field(_current, l.simCurrentMonthly),
            field(_currentRise, l.simCurrentRise, help: l.simRiseHelp),
            const SizedBox(height: 8),
          ],
        ),
        SoftSection(
          icon: Icons.swap_horiz,
          title: l.simOffer,
          children: [
            field(_next, l.simNewMonthly),
            field(_cost, l.simSwitchCost, help: l.simSwitchCostHelp),
            field(_nextRise, l.simNewRise),
            const SizedBox(height: 8),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l.simOver, style: theme.textTheme.labelLarge),
            SegmentedButton<int>(
              segments: [
                for (final y in const [1, 3, 5, 10])
                  ButtonSegment(value: y, label: Text(l.simYears(y))),
              ],
              selected: {_years},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _years = s.single),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (r == null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l.simFillIn, textAlign: TextAlign.center),
          )
        else ...[
          _results(context, l, r),
          if (_applicable != null) _apply(context, l),
        ],
      ],
    );
  }

  /// The subscription picked, when the new price can be applied to it.
  ScheduledTransaction? get _applicable {
    final o = _subscriptions, i = _picked;
    if (o == null || i == null || widget.membership.role == MemberRole.reader) {
      return null;
    }
    final s = o.items[i];
    return s.frequency == ScheduleFrequency.once ? null : s;
  }

  /// The new monthly price as the amount of one debit of the subscription.
  static int _perDebit(ScheduledTransaction s, int monthly) =>
      switch (s.frequency) {
        ScheduleFrequency.yearly => monthly * 12,
        ScheduleFrequency.weekly => (monthly * 12 + 26) ~/ 52,
        _ => monthly,
      };

  Widget _apply(BuildContext context, AppLocalizations l) {
    final s = _applicable!;
    final monthly = parseUserAmount(_next.text);
    if (monthly == null || monthly <= 0) return const SizedBox.shrink();
    final amount = -_perDebit(s, monthly);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            icon: const Icon(Icons.published_with_changes),
            label: Text(l.simApply(s.label, context.money(amount))),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await client.scheduled.update(s.id!, amountCents: amount);
                messenger.showSnackBar(
                  SnackBar(content: Text(l.simApplied(s.label))),
                );
                widget.onApplied?.call();
              } on Object catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text(errorText(l, e))),
                );
              }
            },
          ),
          const SizedBox(height: 4),
          Text(l.simApplyHelp, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _results(
    BuildContext context,
    AppLocalizations l,
    core.ContractSwitch r,
  ) {
    final theme = Theme.of(context);
    final saving = r.totalSavingCents;
    final good = saving > 0;
    final even = r.breakEvenMonth;
    Widget figure(String label, int cents) => Expanded(
      child: Column(
        children: [
          Text(
            context.money(cents),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  good ? Icons.savings_outlined : Icons.trending_up,
                  color: good ? ChartColors.good : ChartColors.critical,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    good
                        ? l.simSaves(context.money(saving), l.simYears(_years))
                        : l.simCostsMore(
                            context.money(-saving),
                            l.simYears(_years),
                          ),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                figure(l.simPerMonth, saving ~/ r.months),
                figure(l.simPerYear, r.yearlySavingCents),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              even == null
                  ? l.simNeverPaysOff
                  : even <= 1
                  ? l.simPaysOffNow
                  : l.simPaysOffAfter(even),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TrendChart(
              labels: [
                for (var m = 1; m <= r.months; m++) l.simMonthLabel(m),
              ],
              series: [
                ChartSeries(
                  label: l.simKeep,
                  color: SeriesColors.of(context, 1),
                  values: r.keepCents,
                ),
                ChartSeries(
                  label: l.simSwitch,
                  color: SeriesColors.of(context, 0),
                  values: r.switchCents,
                ),
              ],
              semanticLabel: l.simChart,
              money: (c) => context.money(c),
              axisMoney: (c) => budgetAxisMoney(context, c),
            ),
            const SizedBox(height: 8),
            Text(l.simHow, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
