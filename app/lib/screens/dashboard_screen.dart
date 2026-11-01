import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/soft.dart';
import 'budget_screen.dart';

/// Where to go from the home page.
enum DashboardTarget { accounts, operations, budget, forecast, notifications }

/// The home page: where the money stands today and what comes next, on
/// the accounts the user may see. Every figure comes from the deterministic
/// engine (forecast, budget, due dates); each card leads to its page.
class DashboardScreen extends StatefulWidget {
  final GroupMembership membership;
  final ValueChanged<DashboardTarget> onOpen;

  /// Unread notifications, kept by the home screen.
  final int unread;

  /// Opens "Mon conseiller" (null: not available yet).
  final VoidCallback? onAdvisor;

  const DashboardScreen({
    super.key,
    required this.membership,
    required this.onOpen,
    this.unread = 0,
    this.onAdvisor,
  });

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<(Account, ForecastResult?)>? _accounts;
  LeftToLiveReport? _left;
  SpendingReport? _month;
  DueCalendar? _calendar;
  String? _error;

  int get _groupId => widget.membership.group.id!;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membership.group.id != widget.membership.group.id) reload();
  }

  Future<void> reload() async {
    final today = todayUtcMidnight();
    try {
      final accounts = await client.account.list(_groupId);
      final results = await Future.wait<Object?>([
        Future.wait([
          for (final a in accounts)
            client.scheduled
                .forecast(a.id!, today)
                .then<ForecastResult?>((f) => f, onError: (_) => null),
        ]),
        client.analysis
            .leftToLive(_groupId)
            .then<LeftToLiveReport?>((r) => r, onError: (_) => null),
        client.analysis.report(_groupId, BudgetPeriod.month, today),
        client.scheduled
            .calendar(_groupId, today)
            .then<DueCalendar?>((c) => c, onError: (_) => null),
      ]);
      if (!mounted) return;
      final forecasts = results[0] as List<ForecastResult?>;
      setState(() {
        _accounts = [
          for (var i = 0; i < accounts.length; i++) (accounts[i], forecasts[i]),
        ];
        _left = results[1] as LeftToLiveReport?;
        _month = results[2] as SpendingReport?;
        _calendar = results[3] as DueCalendar?;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accounts = _accounts;
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (accounts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final left = _left;
    final month = _month;
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: LayoutBuilder(
                builder: (context, box) {
                  final wide = box.maxWidth >= 720;
                  final cards = <Widget>[
                    _balance(context, l, accounts),
                    if (left != null)
                      _tap(
                        LeftToLiveCard(report: left),
                        () => widget.onOpen(DashboardTarget.budget),
                      ),
                    if (month != null)
                      _tap(
                        BalanceCard(
                          report: month,
                          previous: month.history.length >= 2
                              ? month.history[month.history.length - 2]
                              : null,
                        ),
                        () => widget.onOpen(DashboardTarget.budget),
                      ),
                    _upcoming(context, l),
                    if (month != null) _topSpending(context, l, month),
                    _watch(context, l, accounts),
                  ];
                  if (!wide) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final c in cards)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: c,
                          ),
                      ],
                    );
                  }
                  // Two columns on a large screen.
                  final first = [
                    for (var i = 0; i < cards.length; i += 2) cards[i],
                  ];
                  final second = [
                    for (var i = 1; i < cards.length; i += 2) cards[i],
                  ];
                  Widget column(List<Widget> list) => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final c in list)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: c,
                          ),
                      ],
                    ),
                  );
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      column(first),
                      const SizedBox(width: 12),
                      column(second),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tap(Widget child, VoidCallback onTap) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(24),
    clipBehavior: Clip.antiAlias,
    child: InkWell(onTap: onTap, child: child),
  );

  /// All the money today, and its lowest point over the next 30 days.
  Widget _balance(
    BuildContext context,
    AppLocalizations l,
    List<(Account, ForecastResult?)> accounts,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final known = [
      for (final (a, f) in accounts)
        if (f != null && a.currency == 'EUR') (a, f),
    ];
    final total = known.fold(0, (s, e) => s + e.$2.currentBalanceCents);
    final lowest = known.isEmpty
        ? null
        : known.reduce(
            (a, b) =>
                a.$2.lowestBalanceCents <= b.$2.lowestBalanceCents ? a : b,
          );
    Widget blob(double size, double alpha) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.onPrimaryContainer.withValues(alpha: alpha),
      ),
    );
    return Material(
      color: scheme.primaryContainer,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.onOpen(DashboardTarget.accounts),
        child: Stack(
          children: [
            Positioned(right: -50, top: -60, child: blob(180, 0.08)),
            Positioned(right: 70, bottom: -70, child: blob(120, 0.05)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.dashboardBalance(known.length),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.money(total),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (lowest != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          lowest.$2.lowestBalanceCents < 0
                              ? Icons.warning_amber_rounded
                              : Icons.trending_flat,
                          size: 18,
                          color: scheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l.dashboardLowest(
                              lowest.$1.name,
                              context.money(lowest.$2.lowestBalanceCents),
                              context.day(lowest.$2.lowestDate),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final (a, f) in accounts)
                        Chip(
                          avatar: const Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 16,
                          ),
                          label: Text(
                            f == null
                                ? a.name
                                : '${a.name} · ${context.money(f.currentBalanceCents, currency: a.currency)}',
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The planned operations of the next 7 days.
  Widget _upcoming(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context);
    final today = todayUtcMidnight();
    final until = today.add(const Duration(days: 7));
    final items = [
      for (final i in _calendar?.items ?? const <CalendarItem>[])
        if (i.status == OccurrenceStatus.upcoming &&
            !i.date.isBefore(today) &&
            !i.date.isAfter(until))
          i,
    ]..sort((a, b) => a.date.compareTo(b.date));
    return SoftSection(
      icon: Icons.event_outlined,
      title: l.dashboardUpcoming,
      children: [
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.dashboardUpcomingNone),
          ),
        for (final i in items.take(6))
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              i.loanId != null
                  ? Icons.account_balance_outlined
                  : i.subscription
                  ? Icons.autorenew
                  : Icons.event_repeat,
            ),
            title: Text(i.label, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(context.day(i.date)),
            trailing: Text(
              context.money(i.amountCents),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => widget.onOpen(DashboardTarget.forecast),
            child: Text(l.dashboardSeeForecast),
          ),
        ),
      ],
    );
  }

  /// The month's spending and income, and what is left to classify.
  Widget _topSpending(
    BuildContext context,
    AppLocalizations l,
    SpendingReport month,
  ) {
    return SoftSection(
      icon: Icons.pie_chart_outline,
      title: l.dashboardMonthSpending,
      children: [
        Text(
          l.dashboardMonthTotals(
            context.money(month.expenseCents),
            context.money(month.incomeCents),
          ),
        ),
        if (month.unclassifiedCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l.dashboardToClassify(month.unclassifiedCount),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => widget.onOpen(DashboardTarget.budget),
            child: Text(l.dashboardSeeBudget),
          ),
        ),
      ],
    );
  }

  /// What deserves a look: notifications, accounts going below their
  /// alert threshold.
  Widget _watch(
    BuildContext context,
    AppLocalizations l,
    List<(Account, ForecastResult?)> accounts,
  ) {
    final below = [
      for (final (a, f) in accounts)
        if (f?.firstBelowThresholdDate case final d?) (a, d),
    ];
    return SoftSection(
      icon: Icons.visibility_outlined,
      title: l.dashboardWatch,
      children: [
        if (below.isEmpty && widget.unread == 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.dashboardAllGood),
          ),
        for (final (a, d) in below)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.warning_amber_rounded),
            title: Text(l.dashboardBelow(a.name, context.day(d))),
            onTap: () => widget.onOpen(DashboardTarget.forecast),
          ),
        if (widget.unread > 0)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.notifications_active_outlined),
            title: Text(l.dashboardUnread(widget.unread)),
            onTap: () => widget.onOpen(DashboardTarget.notifications),
          ),
        if (widget.onAdvisor != null)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lightbulb_outline),
            title: Text(l.dashboardAdvisor),
            onTap: widget.onAdvisor,
          ),
      ],
    );
  }
}
