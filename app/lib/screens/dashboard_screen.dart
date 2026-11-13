import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../state/ui_prefs.dart';
import '../theme/app_theme.dart';
import '../util/format.dart';
import '../widgets/why.dart';
import '../state/pepite.dart';
import '../widgets/pepite.dart';
import '../widgets/soft.dart';
import '../widgets/home_layout_dialog.dart';
import 'budget_screen.dart';

/// Where to go from the home page.
enum DashboardTarget {
  accounts,
  operations,
  budget,
  forecast,
  notifications,
  imports,

  /// « Bien démarrer » (decision 0028).
  start,

  /// Monthly summary (decision 0035).
  summary,

  /// The operations to classify, the subscriptions, the loans, the advisor
  /// (decision 0041, point 6).
  toClassify,
  subscriptions,
  loans,
  advisor,
}

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

  /// The advices waiting for an answer, best first (decision 0041, point 6),
  /// and how to name them.
  final List<ActionProposal> advices;

  /// The advices found since the last visit of « Mon conseiller ».
  final int newAdvices;
  final String Function(ActionProposal)? adviceTitle;

  const DashboardScreen({
    super.key,
    required this.membership,
    required this.onOpen,
    this.unread = 0,
    this.onAdvisor,
    this.advices = const [],
    this.newAdvices = 0,
    this.adviceTitle,
  });

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<(Account, ForecastResult?)>? _accounts;
  LeftToLiveReport? _left;
  SpendingReport? _month;
  DueCalendar? _calendar;
  PepiteStart? _start;

  /// Subscriptions debited this month above their planned amount.
  List<SubscriptionChange> _rises = const [];

  /// Loans with an instalment missing in the last two months.
  List<Loan> _missed = const [];
  String? _error;

  /// Refreshes « Bien démarrer » with the rest of the page.
  var _reloads = 0;

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
    // A new import may have earned Pépite's first badge.
    unawaited(pepite.refresh());
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
        client.analysis
            .review(_groupId, today)
            .then<MonthReview?>((r) => r, onError: (_) => null),
        _missedLoans(today),
        if (!uiPrefs.firstStepsHidden)
          client.pepiteAdvice
              .start(_groupId)
              .then<PepiteStart?>((s) => s, onError: (_) => null),
      ]);
      if (!mounted) return;
      final forecasts = results[0] as List<ForecastResult?>;
      pepite.overdrawn = forecasts.any(_overdrawn);
      setState(() {
        _accounts = [
          for (var i = 0; i < accounts.length; i++) (accounts[i], forecasts[i]),
        ];
        _left = results[1] as LeftToLiveReport?;
        _month = results[2] as SpendingReport?;
        _calendar = results[3] as DueCalendar?;
        _rises = [
          for (final c
              in (results[4] as MonthReview?)?.subscriptionChanges ??
                  const <SubscriptionChange>[])
            // Amounts are negative: a rise is a larger debit.
            if (c.actualCents < c.plannedCents) c,
        ];
        _missed = results[5] as List<Loan>;
        _start = results.length > 6 ? results[6] as PepiteStart? : null;
        _error = null;
        _reloads++;
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
    final layout = uiPrefs.homeLayout;
    Widget? card(HomeCard c) => switch (c) {
      HomeCard.pepite => PepiteCard(
        key: ValueKey('pepite-${widget.membership.group.id}-$_reloads'),
        membership: widget.membership,
        overdrawn: accounts.any((e) => _overdrawn(e.$2)),
        onStep: (step) => widget.onOpen(switch (step) {
          PepiteStep.statements => DashboardTarget.imports,
          PepiteStep.check => DashboardTarget.operations,
          PepiteStep.forecast ||
          PepiteStep.celebrate => DashboardTarget.forecast,
        }),
        onOpenStart: () => widget.onOpen(DashboardTarget.start),
      ),
      HomeCard.summary => _summarySentence(context, l, accounts, month),
      HomeCard.firstSteps => _firstSteps(l, accounts, month),
      HomeCard.status => _status(context, l, accounts, month),
      HomeCard.advices =>
        widget.onAdvisor == null ? null : _advicesCard(context, l),
      HomeCard.balance => _balance(context, l, accounts),
      HomeCard.leftToLive =>
        left == null
            ? null
            : _tap(
                LeftToLiveCard(report: left),
                () => widget.onOpen(DashboardTarget.budget),
              ),
      HomeCard.monthBalance =>
        month == null
            ? null
            : _tap(
                BalanceCard(
                  report: month,
                  previous: month.history.length >= 2
                      ? month.history[month.history.length - 2]
                      : null,
                ),
                () => widget.onOpen(DashboardTarget.budget),
              ),
      HomeCard.upcoming => _upcoming(context, l),
      HomeCard.topSpending =>
        month == null ? null : _topSpending(context, l, month),
    };
    // The wide cards stand alone; the cards between them share two
    // columns on a large screen.
    final blocks = <Object>[];
    for (final c in layout.visible) {
      final w = card(c);
      if (w == null) continue;
      if (c.wide) {
        blocks.add(w);
      } else if (blocks.isNotEmpty && blocks.last is List<Widget>) {
        (blocks.last as List<Widget>).add(w);
      } else {
        blocks.add(<Widget>[w]);
      }
    }
    Widget centered(Widget child) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: child,
      ),
    );
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
        children: [
          for (final b in blocks)
            centered(b is Widget ? b : _grid(b as List<Widget>)),
          if (blocks.isEmpty)
            centered(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(l.homeEmpty, textAlign: TextAlign.center),
              ),
            ),
          centered(
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                key: const Key('home-customize'),
                onPressed: _customize,
                icon: const Icon(Icons.tune),
                label: Text(l.homeCustomize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the editor of the home page; saved on this device.
  Future<void> _customize() async {
    final before = uiPrefs.homeLayout;
    final chosen = await showDialog<HomeLayoutChoice>(
      context: context,
      builder: (_) => HomeLayoutDialog(
        layout: before,
        advices: widget.onAdvisor != null,
        simple: uiPrefs.simpleMode,
      ),
    );
    if (chosen == null || !mounted) return;
    final firstStepsBack =
        !before.shows(HomeCard.firstSteps) &&
        (chosen.layout?.shows(HomeCard.firstSteps) ?? true);
    await uiPrefs.setHomeLayout(chosen.layout);
    if (!mounted) return;
    setState(() {});
    // « Premiers pas » shown again: its steps are fetched with the page.
    if (firstStepsBack) await reload();
  }

  /// One block of cards: a column on a phone, two on a large screen.
  Widget _grid(List<Widget> cards) => LayoutBuilder(
    builder: (context, box) {
      final wide = box.maxWidth >= 720;
      Widget column(List<Widget> list) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in list)
            Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
        ],
      );
      if (!wide) return column(cards);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: column([
              for (var i = 0; i < cards.length; i += 2) cards[i],
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: column([
              for (var i = 1; i < cards.length; i += 2) cards[i],
            ]),
          ),
        ],
      );
    },
  );

  Widget _tap(Widget child, VoidCallback onTap) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(24),
    clipBehavior: Clip.antiAlias,
    child: InkWell(onTap: onTap, child: child),
  );

  /// All the money today, and its lowest point over the next 30 days.
  /// Below zero now or in the forecast: Pépite stays sober.
  static bool _overdrawn(ForecastResult? f) =>
      f != null && (f.currentBalanceCents < 0 || f.lowestBalanceCents < 0);

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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: WhyButton(
                      key: const Key('why-balance'),
                      color: scheme.onPrimaryContainer,
                      title: l.whyBalanceTitle,
                      lines: [
                        for (final (a, f) in known)
                          WhyLine(a.name, f.currentBalanceCents),
                        WhyLine(l.whyTotal, total, total: true),
                      ],
                      explanation: l.whyBalanceText,
                    ),
                  ),
                  const SizedBox(height: 4),
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
      help: l.cardHelpUpcoming,
      helpTopic: HelpTopic.forecast,
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
      help: l.cardHelpTopSpending,
      helpTopic: HelpTopic.budget,
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

  /// What deserves a look, the most urgent first (decision 0041, point 6):
  /// an account below zero today, then below zero later, then below its
  /// alert threshold, then operations to classify and notifications.
  List<_Issue> _issues(
    AppLocalizations l,
    BuildContext context,
    List<(Account, ForecastResult?)> accounts,
    SpendingReport? month,
  ) {
    final issues = <_Issue>[];
    for (final (a, f) in accounts) {
      if (f == null) continue;
      if (f.currentBalanceCents < 0) {
        issues.add(
          _Issue(
            0,
            Icons.error_outline,
            l.homeIssueOverdrawn(
              a.name,
              context.money(f.currentBalanceCents, currency: a.currency),
            ),
            DashboardTarget.forecast,
          ),
        );
      } else if (f.lowestBalanceCents < 0) {
        issues.add(
          _Issue(
            1,
            Icons.trending_down,
            l.homeIssueWillOverdraw(a.name, context.day(f.lowestDate)),
            DashboardTarget.forecast,
          ),
        );
      } else if (f.firstBelowThresholdDate case final d?) {
        issues.add(
          _Issue(
            2,
            Icons.warning_amber_rounded,
            l.dashboardBelow(a.name, context.day(d)),
            DashboardTarget.forecast,
          ),
        );
      }
    }
    for (final loan in _missed) {
      issues.add(
        _Issue(
          1,
          Icons.event_busy_outlined,
          l.homeIssueLoanMissed(loan.label ?? loan.lender),
          DashboardTarget.loans,
        ),
      );
    }
    if (month != null && month.unclassifiedCount > 0) {
      issues.add(
        _Issue(
          3,
          Icons.label_off_outlined,
          l.homeIssueToClassify(month.unclassifiedCount),
          DashboardTarget.toClassify,
        ),
      );
    }
    for (final c in _rises) {
      issues.add(
        _Issue(
          3,
          Icons.trending_up,
          l.homeIssueSubscriptionRise(
            c.label,
            context.money(-c.plannedCents),
            context.money(-c.actualCents),
          ),
          DashboardTarget.subscriptions,
        ),
      );
    }
    if (widget.newAdvices > 0) {
      issues.add(
        _Issue(
          4,
          Icons.lightbulb_outline,
          l.homeIssueNewAdvices(widget.newAdvices),
          DashboardTarget.advisor,
        ),
      );
    }
    if (widget.unread > 0) {
      issues.add(
        _Issue(
          4,
          Icons.notifications_active_outlined,
          l.dashboardUnread(widget.unread),
          DashboardTarget.notifications,
        ),
      );
    }
    issues.sort((a, b) => a.urgency.compareTo(b.urgency));
    return issues;
  }

  /// The running loans whose check (decision 0040) finds an instalment
  /// missing in the last two months; nothing when it cannot be told.
  Future<List<Loan>> _missedLoans(DateTime today) async {
    try {
      final overview = await client.loan.overview(_groupId);
      final since = today.subtract(const Duration(days: 62));
      final running = [
        for (final i in overview.loans)
          if (i.nextDueDate != null && i.loan.accountId != null) i.loan,
      ];
      final checks = await Future.wait([
        for (final loan in running)
          client.loan
              .check(loan.id!)
              .then<LoanCheckReport?>((r) => r, onError: (_) => null),
      ]);
      return [
        for (var i = 0; i < running.length; i++)
          if (checks[i]?.lines.any(
                (line) =>
                    line.status == LoanCheckStatus.missing &&
                    line.dueDate != null &&
                    !line.dueDate!.isBefore(since) &&
                    line.dueDate!.isBefore(today),
              ) ??
              false)
            running[i],
      ];
    } on Object {
      return const [];
    }
  }

  /// « Tout va bien ? » answered in one sentence, at the top of the page.
  Widget _summarySentence(
    BuildContext context,
    AppLocalizations l,
    List<(Account, ForecastResult?)> accounts,
    SpendingReport? month,
  ) {
    final theme = Theme.of(context);
    final issues = _issues(l, context, accounts, month);
    final urgent = issues.any((i) => i.urgency <= 1);
    final colors = context.moneyColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Row(
        children: [
          Icon(
            issues.isEmpty
                ? Icons.check_circle_outline
                : urgent
                ? Icons.error_outline
                : Icons.info_outline,
            color: issues.isEmpty
                ? colors.positive
                : urgent
                ? colors.negative
                : colors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              key: const Key('home-summary'),
              issues.isEmpty ? l.homeAllGood : l.homeIssuesCount(issues.length),
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// The points to look at, most urgent first; what goes well is folded.
  Widget _status(
    BuildContext context,
    AppLocalizations l,
    List<(Account, ForecastResult?)> accounts,
    SpendingReport? month,
  ) {
    final issues = _issues(l, context, accounts, month);
    final colors = context.moneyColors;
    final noOverdraft = accounts.every(
      (e) => e.$2 == null || e.$2!.lowestBalanceCents >= 0,
    );
    final good = [
      if (noOverdraft) l.homeGoodNoOverdraft,
      if (month != null && month.unclassifiedCount == 0) l.homeGoodClassified,
      if (widget.unread == 0) l.homeGoodNoNotification,
    ];
    return SoftSection(
      icon: Icons.visibility_outlined,
      title: l.dashboardWatch,
      help: l.cardHelpWatch,
      helpTopic: HelpTopic.home,
      children: [
        if (issues.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.dashboardAllGood),
          ),
        for (final i in issues)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              i.icon,
              color: i.urgency <= 1 ? colors.negative : null,
            ),
            title: Text(i.text),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => widget.onOpen(i.target),
          ),
        if (good.isNotEmpty)
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: const Key('home-good'),
              tilePadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(
                Icons.thumb_up_alt_outlined,
                color: colors.positive,
              ),
              title: Text(l.homeGoodTitle(good.length)),
              children: [
                for (final g in good)
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 16),
                    leading: Icon(Icons.check, color: colors.positive),
                    title: Text(g),
                  ),
              ],
            ),
          ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event_note_outlined),
          title: Text(l.summaryOpen),
          onTap: () => widget.onOpen(DashboardTarget.summary),
        ),
      ],
    );
  }

  /// The first launch, in three steps (decision 0041, point 15): an
  /// account, a statement, the categories. Shown until they are done or
  /// hidden on this device.
  Widget? _firstSteps(
    AppLocalizations l,
    List<(Account, ForecastResult?)> accounts,
    SpendingReport? month,
  ) {
    final start = _start;
    if (start == null || uiPrefs.firstStepsHidden) return null;
    final hasAccount = accounts.isNotEmpty;
    final imported = start.done.contains('account');
    final classified =
        imported &&
        (start.done.contains('rules') ||
            (month != null && month.unclassifiedCount == 0));
    if (hasAccount && imported && classified) return null;
    final steps = [
      (
        l.firstStepAccount,
        l.firstStepAccountHelp,
        hasAccount,
        DashboardTarget.accounts,
      ),
      (
        l.firstStepImport,
        l.firstStepImportHelp,
        imported,
        DashboardTarget.imports,
      ),
      (
        l.firstStepCategories,
        l.firstStepCategoriesHelp,
        classified,
        DashboardTarget.operations,
      ),
    ];
    final next = steps.indexWhere((s) => !s.$3);
    final colors = context.moneyColors;
    return SoftSection(
      key: const Key('first-steps'),
      icon: Icons.flag_outlined,
      title: l.firstStepsTitle(steps.where((s) => s.$3).length, steps.length),
      children: [
        for (final (i, (title, help, done, target)) in steps.indexed)
          ListTile(
            key: Key('first-step-$i'),
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: done
                ? Icon(Icons.check_circle, color: colors.positive)
                : CircleAvatar(radius: 12, child: Text('${i + 1}')),
            title: Text(
              title,
              style: done
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
            subtitle: i == next ? Text(help) : null,
            trailing: done ? null : const Icon(Icons.chevron_right),
            onTap: done ? null : () => widget.onOpen(target),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            key: const Key('first-steps-hide'),
            onPressed: () async {
              await uiPrefs.setFirstStepsHidden(true);
              if (mounted) setState(() {});
            },
            child: Text(l.firstStepsHide),
          ),
        ),
      ],
    );
  }

  /// « Conseils du moment »: the first three advices, the others behind
  /// « Voir tout ».
  Widget _advicesCard(BuildContext context, AppLocalizations l) {
    final title = widget.adviceTitle;
    final shown = title == null ? const <ActionProposal>[] : widget.advices;
    return SoftSection(
      key: const Key('home-advices'),
      icon: Icons.lightbulb_outline,
      title: l.homeAdvicesTitle,
      help: l.cardHelpAdvices,
      helpTopic: HelpTopic.advisor,
      children: [
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.homeAdvicesNone),
          ),
        for (final p in shown.take(3))
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.tips_and_updates_outlined),
            title: Text(
              title!(p),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: widget.onAdvisor,
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            key: const Key('home-advices-all'),
            onPressed: widget.onAdvisor,
            child: Text(
              shown.length > 3
                  ? l.homeAdvicesAllCount(shown.length)
                  : l.homeAdvicesAll,
            ),
          ),
        ),
      ],
    );
  }
}

/// A point to look at on the home page.
class _Issue {
  /// 0 is the most urgent.
  final int urgency;
  final IconData icon;
  final String text;
  final DashboardTarget target;
  const _Issue(this.urgency, this.icon, this.text, this.target);
}
