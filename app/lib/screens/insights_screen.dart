import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/soft.dart';

/// Analyses computed without AI: how reliable the forecasts were, the
/// debits that stand out, the bank fees of the year. Each figure says what
/// it is made of.
class InsightsScreen extends StatefulWidget {
  final GroupMembership membership;
  const InsightsScreen({super.key, required this.membership});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  Insights? _i;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final i = await client.analysis.insights(widget.membership.group.id!);
      if (mounted) setState(() => (_i = i, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final i = _i;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.insightsTitle),
        actions: const [HelpButton(HelpTopic.budget)],
      ),
      body: _error != null
          ? Center(child: Text(_error!))
          : i == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(l.insightsIntro),
                          _reliability(context, l, i),
                          _unusual(context, l, i),
                          _fees(context, l, i),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _reliability(BuildContext context, AppLocalizations l, Insights i) {
    final small = Theme.of(context).textTheme.bodySmall;
    final estimate = i.variableEstimateCents;
    final actual = i.variableActualCents;
    return SoftSection(
      icon: Icons.verified_outlined,
      title: l.insightsReliability,
      children: [
        Text(
          i.plannedDue == 0
              ? l.insightsPlannedNone
              : l.insightsPlanned(
                  i.plannedPaid,
                  i.plannedDue,
                  i.plannedPaid * 100 ~/ i.plannedDue,
                ),
        ),
        if (i.plannedLate > 0)
          Text(l.insightsPlannedLate(i.plannedLate), style: small),
        const SizedBox(height: 8),
        if (estimate != null && actual != null && i.variableMonth != null)
          Text(
            l.insightsVariable(
              context.monthName(i.variableMonth!),
              context.money(estimate),
              context.money(actual),
            ),
          )
        else
          Text(l.insightsVariableUnknown),
        const SizedBox(height: 4),
        Text(l.insightsReliabilityHow, style: small),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _unusual(BuildContext context, AppLocalizations l, Insights i) =>
      SoftSection(
        icon: Icons.troubleshoot,
        title: l.insightsUnusual,
        children: [
          if (i.unusual.isEmpty) Text(l.insightsUnusualNone),
          for (final u in i.unusual)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                u.kind == 'duplicate'
                    ? Icons.content_copy_outlined
                    : Icons.trending_up,
              ),
              title: Text(
                '${u.transaction.cleanLabel} · '
                '${context.money(u.transaction.amountCents)}',
              ),
              subtitle: Text(
                [
                  context.day(u.transaction.date),
                  u.kind == 'duplicate'
                      ? l.insightsDuplicate
                      : l.insightsAboveUsual(
                          context.money(u.usualCents),
                          u.basis,
                        ),
                ].join(' · '),
              ),
            ),
          const SizedBox(height: 8),
        ],
      );

  Widget _fees(BuildContext context, AppLocalizations l, Insights i) {
    final theme = Theme.of(context);
    final max = i.feePerMonthCents.fold(0, (a, c) => c > a ? c : a);
    return SoftSection(
      icon: Icons.account_balance_outlined,
      title: l.insightsFees,
      children: [
        Text(
          i.feeTotalCents == 0
              ? l.insightsFeesNone
              : l.insightsFeesTotal(context.money(i.feeTotalCents)),
          style: theme.textTheme.titleMedium,
        ),
        if (i.feeTotalCents > 0) ...[
          const SizedBox(height: 8),
          // One bar per month, oldest first.
          SizedBox(
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (k, c) in i.feePerMonthCents.indexed)
                  Expanded(
                    child: Tooltip(
                      message:
                          '${context.monthName(i.feeMonths[k])} : '
                          '${context.money(c)}',
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: max == 0 ? 0 : 4 + 56 * c / max,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (final f in i.feeLines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(child: Text('${f.label} (${f.count})')),
                  Text(context.money(f.cents)),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(l.insightsFeesHow, style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}
