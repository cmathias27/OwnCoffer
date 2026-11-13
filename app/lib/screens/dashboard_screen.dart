import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../help/help.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../navigation/search.dart';
import '../state/pepite.dart';
import '../state/pepite_messages.dart';
import '../state/ui_prefs.dart';
import '../theme/app_theme.dart';
import '../util/format.dart';
import '../widgets/budget_charts.dart';
import '../widgets/home_board_view.dart';
import '../widgets/pepite.dart';
import '../widgets/soft.dart';
import '../widgets/why.dart';
import 'pepite_screen.dart';

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

  /// The invoices (decision 0045).
  invoices,
}

/// The home page: where the money stands today and what comes next, on
/// the accounts the user may see, as widgets placed freely on a grid
/// (decision 0045). Every figure comes from the deterministic engine
/// (forecast, budget, due dates); each widget leads to its page.
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

  /// The functions this user may open (decision 0046: each one can be a
  /// widget), and how to open them; null: no such widget.
  final Set<AppFunction> functions;
  final ValueChanged<AppFunction>? onFunction;

  /// Opens the global search (null: no such widget).
  final VoidCallback? onSearch;

  const DashboardScreen({
    super.key,
    required this.membership,
    required this.onOpen,
    this.unread = 0,
    this.onAdvisor,
    this.advices = const [],
    this.newAdvices = 0,
    this.adviceTitle,
    this.functions = const {},
    this.onFunction,
    this.onSearch,
  });

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

/// The widgets whose figures are fetched only when they are on the board.
const _onDemand = {
  HomeTileKind.firstSteps,
  HomeTileKind.operations,
  HomeTileKind.invoices,
  HomeTileKind.imports,
  HomeTileKind.topSpending,
  HomeTileKind.budget,
  HomeTileKind.categories,
  HomeTileKind.split,
};

class DashboardScreenState extends State<DashboardScreen> {
  List<(Account, ForecastResult?)>? _accounts;
  LeftToLiveReport? _left;
  SpendingReport? _month;
  DueCalendar? _calendar;
  PepiteStart? _start;
  LoanOverview? _loans;

  /// Subscriptions debited this month above their planned amount.
  List<SubscriptionChange> _rises = const [];

  /// Loans with an instalment missing in the last two months.
  List<Loan> _missed = const [];

  /// Fetched only for the widgets on the board ([_onDemand]).
  List<(BankTransaction, Account)>? _recent;
  int? _unattached;
  DateTime? _lastImport;
  var _importsKnown = false;
  Map<int, Category> _categories = const {};
  Set<HomeTileKind> _fetched = const {};
  String? _error;

  /// Refreshes « Bien démarrer » with the rest of the page.
  var _reloads = 0;

  /// The board being arranged; null outside editing.
  HomeBoard? _draft;

  /// « Rétablir » chosen while arranging: every grid goes back to the
  /// home page as it comes once done.
  var _reset = false;

  int get _groupId => widget.membership.group.id!;

  bool get editing => _draft != null;

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

  /// The widgets on this device's boards (and the one being arranged).
  Set<HomeTileKind> get _wanted => {
    for (final b in [
      uiPrefs.homeBoard(2),
      uiPrefs.homeBoard(4),
      ?_draft,
    ])
      for (final t in b.tiles) t.kind,
  };

  Future<void> reload() async {
    final today = todayUtcMidnight();
    final want = _wanted;
    bool wants(HomeTileKind k) => want.contains(k);
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
        _loanState(today),
        wants(HomeTileKind.firstSteps)
            ? client.pepiteAdvice
                  .start(_groupId)
                  .then<PepiteStart?>((s) => s, onError: (_) => null)
            : Future.value(),
        wants(HomeTileKind.operations) ? _recentOf(accounts) : Future.value(),
        wants(HomeTileKind.invoices)
            ? client.invoice
                  .list(_groupId, unattached: true)
                  .then<int?>((l) => l.length, onError: (_) => null)
            : Future.value(),
        wants(HomeTileKind.imports) ? _lastImportOf(accounts) : Future.value(),
        wants(HomeTileKind.topSpending) ||
                wants(HomeTileKind.budget) ||
                wants(HomeTileKind.categories) ||
                wants(HomeTileKind.split)
            ? client.category
                  .list(_groupId)
                  .then<List<Category>?>((c) => c, onError: (_) => null)
            : Future.value(),
      ]);
      if (!mounted) return;
      final forecasts = results[0] as List<ForecastResult?>;
      pepite.overdrawn = forecasts.any(_overdrawn);
      final loans = results[5] as (LoanOverview?, List<Loan>);
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
        _loans = loans.$1;
        _missed = loans.$2;
        _start = results[6] as PepiteStart?;
        _recent = results[7] as List<(BankTransaction, Account)>?;
        _unattached = results[8] as int?;
        _importsKnown = wants(HomeTileKind.imports) && results[9] != null;
        _lastImport = switch (results[9]) {
          final (DateTime?,) r => r.$1,
          _ => null,
        };
        _categories = {
          for (final c in results[10] as List<Category>? ?? const <Category>[])
            c.id!: c,
        };
        _fetched = want;
        _error = null;
        _reloads++;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  /// The latest operations of every account, newest first.
  Future<List<(BankTransaction, Account)>?> _recentOf(
    List<Account> accounts,
  ) async {
    try {
      final pages = await Future.wait([
        for (final a in accounts) client.transaction.list(a.id!, limit: 8),
      ]);
      return [
        for (var i = 0; i < accounts.length; i++)
          for (final t in pages[i].items) (t, accounts[i]),
      ]..sort((a, b) => b.$1.date.compareTo(a.$1.date));
    } on Object {
      return null;
    }
  }

  /// The day of the last statement imported, in a record so that « never »
  /// (null inside) differs from « cannot be told » (null record).
  Future<(DateTime?,)?> _lastImportOf(List<Account> accounts) async {
    try {
      final lists = await Future.wait([
        for (final a in accounts) client.import.history(a.id!),
      ]);
      DateTime? last;
      for (final list in lists) {
        for (final i in list) {
          if (i.cancelledAt != null) continue;
          if (last == null || i.createdAt.isAfter(last)) last = i.createdAt;
        }
      }
      return (last,);
    } on Object {
      return null;
    }
  }

  /// The loans, and the running ones whose check (decision 0040) finds an
  /// instalment missing in the last two months; nothing when it cannot be
  /// told.
  Future<(LoanOverview?, List<Loan>)> _loanState(DateTime today) async {
    LoanOverview? overview;
    try {
      overview = await client.loan.overview(_groupId);
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
      return (
        overview,
        [
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
        ],
      );
    } on Object {
      return (overview, const <Loan>[]);
    }
  }

  /// All the money today, and its lowest point over the next 30 days.
  /// Below zero now or in the forecast: Pépite stays sober.
  static bool _overdrawn(ForecastResult? f) =>
      f != null && (f.currentBalanceCents < 0 || f.lowestBalanceCents < 0);

  // ---------------------------------------------------------------- page

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_accounts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return LayoutBuilder(
      builder: (context, box) {
        final width = math.min(box.maxWidth - 24, 1000.0);
        final columns = HomeBoard.columnsFor(width);
        final draft = _draft;
        final board = draft == null
            ? uiPrefs.homeBoard(columns)
            : HomeBoard.reflowed(draft, columns);
        final shown = board;
        final rowHeight = MediaQuery.textScalerOf(
          context,
        ).scale(136).clamp(136.0, 200.0);
        Widget centered(Widget child) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: child,
          ),
        );
        return RefreshIndicator(
          onRefresh: reload,
          child: ListView(
            key: const Key('home-list'),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
            children: [
              if (editing) centered(_editBar(context, l, board)),
              if (!editing)
                centered(
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      key: const Key('home-customize'),
                      onPressed: () => _edit(columns),
                      icon: const Icon(Icons.dashboard_customize_outlined),
                      label: Text(l.homeCustomize),
                    ),
                  ),
                ),
              if (shown.tiles.isEmpty)
                centered(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(l.homeEmpty, textAlign: TextAlign.center),
                  ),
                ),
              if (shown.tiles.isNotEmpty || editing)
                centered(
                  HomeBoardView(
                    key: const Key('home-board'),
                    board: shown,
                    editing: editing,
                    rowHeight: rowHeight,
                    nameOf: (k) => _name(l, k),
                    iconOf: _icon,
                    onChanged: (b) => setState(() => _draft = b),
                    tileBuilder: (context, t) => _tile(context, l, t),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Starts arranging the board of this grid.
  void _edit(int columns) => setState(() {
    _draft = uiPrefs.homeBoard(columns);
    _reset = false;
  });

  /// The bar on top while arranging: what to do, add, reset, cancel, done.
  Widget _editBar(BuildContext context, AppLocalizations l, HomeBoard board) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.homeBoardTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(l.homeCustomizeHelp, style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilledButton.tonalIcon(
                    key: const Key('home-board-add'),
                    onPressed: () => _add(board),
                    icon: const Icon(Icons.add),
                    label: Text(l.homeBoardAdd),
                  ),
                  TextButton(
                    key: const Key('home-board-reset'),
                    onPressed: () => setState(() {
                      _draft = HomeBoard.defaults(
                        board.columns,
                        simple: uiPrefs.simpleMode,
                      );
                      _reset = true;
                    }),
                    child: Text(l.homeCustomizeReset),
                  ),
                  TextButton(
                    key: const Key('home-board-cancel'),
                    onPressed: () => setState(() => _draft = null),
                    child: Text(l.cancel),
                  ),
                  FilledButton(
                    key: const Key('home-board-done'),
                    onPressed: () => _done(board),
                    child: Text(l.homeBoardDone),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Keeps the board arranged on this device; fetches what its new widgets
  /// need.
  Future<void> _done(HomeBoard board) async {
    // Kept in memory at once, written to the device's storage meanwhile.
    // After « Rétablir », the other grid goes back to the home page as it
    // comes; this one keeps what was arranged.
    final saved = _reset
        ? uiPrefs.resetHome(
            keep:
                board ==
                    HomeBoard.defaults(
                      board.columns,
                      simple: uiPrefs.simpleMode,
                    )
                ? null
                : board,
          )
        : uiPrefs.setHomeBoard(board);
    setState(() {
      _draft = null;
      _reset = false;
    });
    await saved;
    if (!mounted) return;
    if (!_fetched.containsAll(_wanted.intersection(_onDemand))) await reload();
  }

  /// The catalogue of the widgets not on the board.
  Future<void> _add(HomeBoard board) async {
    final l = AppLocalizations.of(context);
    final missing = [
      for (final k in board.missing)
        if (_available(k)) k,
    ];
    Widget entry(BuildContext context, HomeTileKind k) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            key: Key('home-add-${k.name}'),
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Icon(_icon(k))),
            title: Text(_name(l, k)),
            subtitle: Text(_help(l, k)),
            onTap: () => Navigator.pop(context, (k, k.defaultSize)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Wrap(
              spacing: 8,
              children: [
                for (final s in k.sizes)
                  ActionChip(
                    key: Key('home-add-${k.name}-${s.name}'),
                    avatar: Icon(
                      s == k.defaultSize ? Icons.add : Icons.crop_square,
                      size: 18,
                    ),
                    label: Text(homeSizeName(l, s)),
                    onPressed: () => Navigator.pop(context, (k, s)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    final chosen = await showSoftSheet<(HomeTileKind, TileSize)>(
      context,
      scroll: true,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(l.homeBoardAdd, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (missing.isEmpty) Text(l.homeBoardAddNone),
          // Decision 0046: the summaries of the pages, then the shortcuts.
          for (final (title, kinds) in [
            (
              l.homeAddSummaries,
              [
                for (final k in missing)
                  if (!k.isShortcut) k,
              ],
            ),
            (
              l.homeAddShortcuts,
              [
                for (final k in missing)
                  if (k.isShortcut) k,
              ],
            ),
          ])
            if (kinds.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              for (final k in kinds) entry(context, k),
            ],
        ],
      ),
    );
    if (chosen == null || !mounted || _draft == null) return;
    setState(() => _draft = board.added(chosen.$1, chosen.$2));
    if (_onDemand.contains(chosen.$1) && !_fetched.contains(chosen.$1)) {
      await reload();
    }
  }

  /// « Conseils du moment » only where Mon conseiller exists; Pépite only
  /// when it is on; a function only where this user may open it (decision
  /// 0046: the same rules as the search).
  bool _available(HomeTileKind k) => switch (k) {
    HomeTileKind.advices => widget.onAdvisor != null,
    HomeTileKind.pepite => pepite.enabled,
    HomeTileKind.search => widget.onSearch != null,
    _ => switch (_function(k)) {
      null => true,
      final f => widget.onFunction != null && widget.functions.contains(f),
    },
  };

  /// The function a shortcut widget opens (decision 0046).
  static AppFunction? _function(HomeTileKind k) => switch (k) {
    HomeTileKind.newOperation => AppFunction.newOperation,
    HomeTileKind.scanReceipt => AppFunction.scanReceipt,
    HomeTileKind.categories => AppFunction.categories,
    HomeTileKind.rules => AppFunction.rules,
    HomeTileKind.members => AppFunction.members,
    HomeTileKind.export => AppFunction.export,
    HomeTileKind.security => AppFunction.security,
    HomeTileKind.assistant => AppFunction.assistant,
    HomeTileKind.apps => AppFunction.apps,
    HomeTileKind.display => AppFunction.display,
    HomeTileKind.help => AppFunction.help,
    HomeTileKind.shortcuts => AppFunction.shortcuts,
    HomeTileKind.feedback => AppFunction.feedback,
    HomeTileKind.admin => AppFunction.admin,
    _ => null,
  };

  // ------------------------------------------------------------ catalogue

  static IconData _icon(HomeTileKind k) => switch (k) {
    HomeTileKind.pepite => Icons.pets_outlined,
    HomeTileKind.summary => Icons.check_circle_outline,
    HomeTileKind.firstSteps => Icons.flag_outlined,
    HomeTileKind.status => Icons.visibility_outlined,
    HomeTileKind.advices => Icons.lightbulb_outline,
    HomeTileKind.balance => Icons.account_balance_wallet_outlined,
    HomeTileKind.leftToLive => Icons.savings_outlined,
    HomeTileKind.monthBalance => Icons.balance_outlined,
    HomeTileKind.upcoming => Icons.event_outlined,
    HomeTileKind.topSpending => Icons.pie_chart_outline,
    HomeTileKind.accounts => Icons.account_balance_outlined,
    HomeTileKind.forecast => Icons.show_chart,
    HomeTileKind.operations => Icons.receipt_long_outlined,
    HomeTileKind.toClassify => Icons.label_off_outlined,
    HomeTileKind.subscriptions => Icons.autorenew,
    HomeTileKind.loans => Icons.real_estate_agent_outlined,
    HomeTileKind.invoices => Icons.description_outlined,
    HomeTileKind.imports => Icons.upload_file_outlined,
    HomeTileKind.notifications => Icons.notifications_outlined,
    HomeTileKind.budget => Icons.track_changes,
    HomeTileKind.split => Icons.donut_large,
    HomeTileKind.monthSummary => AppFunction.summary.icon,
    HomeTileKind.search => Icons.search,
    _ => _function(k)!.icon,
  };

  static String _name(AppLocalizations l, HomeTileKind k) => switch (k) {
    HomeTileKind.pepite => l.homeCardPepite,
    HomeTileKind.summary => l.homeCardSummary,
    HomeTileKind.firstSteps => l.homeCardFirstSteps,
    HomeTileKind.status => l.homeCardStatus,
    HomeTileKind.advices => l.homeCardAdvices,
    HomeTileKind.balance => l.homeCardBalance,
    HomeTileKind.leftToLive => l.homeCardLeftToLive,
    HomeTileKind.monthBalance => l.homeCardMonthBalance,
    HomeTileKind.upcoming => l.homeCardUpcoming,
    HomeTileKind.topSpending => l.homeCardTopSpending,
    HomeTileKind.accounts => l.homeCardAccounts,
    HomeTileKind.forecast => l.homeCardForecast,
    HomeTileKind.operations => l.homeCardOperations,
    HomeTileKind.toClassify => l.homeCardToClassify,
    HomeTileKind.subscriptions => l.homeCardSubscriptions,
    HomeTileKind.loans => l.homeCardLoans,
    HomeTileKind.invoices => l.homeCardInvoices,
    HomeTileKind.imports => l.homeCardImports,
    HomeTileKind.notifications => l.homeCardNotifications,
    HomeTileKind.budget => l.homeCardBudget,
    HomeTileKind.split => l.homeCardSplit,
    HomeTileKind.monthSummary => l.homeCardMonthSummary,
    HomeTileKind.search => l.globalSearchOpen,
    _ => _function(k)!.label(l),
  };

  static String _help(AppLocalizations l, HomeTileKind k) => switch (k) {
    HomeTileKind.pepite => l.homeCardPepiteHelp,
    HomeTileKind.summary => l.homeCardSummaryHelp,
    HomeTileKind.firstSteps => l.homeCardFirstStepsHelp,
    HomeTileKind.status => l.homeCardStatusHelp,
    HomeTileKind.advices => l.homeCardAdvicesHelp,
    HomeTileKind.balance => l.homeCardBalanceHelp,
    HomeTileKind.leftToLive => l.homeCardLeftToLiveHelp,
    HomeTileKind.monthBalance => l.homeCardMonthBalanceHelp,
    HomeTileKind.upcoming => l.homeCardUpcomingHelp,
    HomeTileKind.topSpending => l.homeCardTopSpendingHelp,
    HomeTileKind.accounts => l.homeCardAccountsHelp,
    HomeTileKind.forecast => l.homeCardForecastHelp,
    HomeTileKind.operations => l.homeCardOperationsHelp,
    HomeTileKind.toClassify => l.homeCardToClassifyHelp,
    HomeTileKind.subscriptions => l.homeCardSubscriptionsHelp,
    HomeTileKind.loans => l.homeCardLoansHelp,
    HomeTileKind.invoices => l.homeCardInvoicesHelp,
    HomeTileKind.imports => l.homeCardImportsHelp,
    HomeTileKind.notifications => l.homeCardNotificationsHelp,
    HomeTileKind.budget => l.homeCardBudgetHelp,
    HomeTileKind.split => l.homeCardSplitHelp,
    HomeTileKind.monthSummary => l.homeCardMonthSummaryHelp,
    HomeTileKind.search => l.homeCardSearchHelp,
    HomeTileKind.newOperation => l.homeCardNewOperationHelp,
    HomeTileKind.scanReceipt => l.homeCardScanReceiptHelp,
    HomeTileKind.categories => l.homeCardCategoriesHelp,
    HomeTileKind.rules => l.homeCardRulesHelp,
    HomeTileKind.members => l.homeCardMembersHelp,
    HomeTileKind.export => l.homeCardExportHelp,
    HomeTileKind.security => l.homeCardSecurityHelp,
    HomeTileKind.assistant => l.homeCardAssistantHelp,
    HomeTileKind.apps => l.homeCardAppsHelp,
    HomeTileKind.display => l.homeCardDisplayHelp,
    HomeTileKind.help => l.homeCardHelpHelp,
    HomeTileKind.shortcuts => l.homeCardShortcutsHelp,
    HomeTileKind.feedback => l.homeCardFeedbackHelp,
    HomeTileKind.admin => l.homeCardAdminHelp,
  };

  // --------------------------------------------------------------- tiles

  Widget _tile(BuildContext context, AppLocalizations l, HomeTile t) {
    final s = t.size;
    if (!_available(t.kind)) {
      // Pépite turned off, no advisor: only its place while arranging.
      return editing
          ? _frame(l, t.kind, s, child: const SizedBox.shrink())
          : const SizedBox.shrink();
    }
    return KeyedSubtree(
      key: Key('home-card-${t.kind.name}'),
      child: switch (t.kind) {
        HomeTileKind.pepite => _pepiteTile(context, l, s),
        HomeTileKind.summary => _summaryTile(context, l, s),
        HomeTileKind.firstSteps => _firstStepsTile(context, l, s),
        HomeTileKind.status => _statusTile(context, l, s),
        HomeTileKind.advices => _advicesTile(context, l, s),
        HomeTileKind.balance => _balanceTile(context, l, s),
        HomeTileKind.leftToLive => _leftTile(context, l, s),
        HomeTileKind.monthBalance => _monthTile(context, l, s),
        HomeTileKind.upcoming => _upcomingTile(context, l, s),
        HomeTileKind.topSpending => _spendingTile(context, l, s),
        HomeTileKind.accounts => _accountsTile(context, l, s),
        HomeTileKind.forecast => _forecastTile(context, l, s),
        HomeTileKind.operations => _operationsTile(context, l, s),
        HomeTileKind.toClassify => _toClassifyTile(context, l, s),
        HomeTileKind.subscriptions => _subscriptionsTile(context, l, s),
        HomeTileKind.loans => _loansTile(context, l, s),
        HomeTileKind.invoices => _invoicesTile(context, l, s),
        HomeTileKind.imports => _importsTile(context, l, s),
        HomeTileKind.notifications => _notificationsTile(context, l, s),
        HomeTileKind.budget => _budgetTile(context, l, s),
        HomeTileKind.split => _splitTile(context, l, s),
        HomeTileKind.monthSummary => _monthSummaryTile(context, l, s),
        _ => _shortcutTile(context, l, t.kind, s),
      },
    );
  }

  /// The frame of a widget; the « ? » only when there is room for it.
  Widget _frame(
    AppLocalizations l,
    HomeTileKind kind,
    TileSize size, {
    required Widget child,
    DashboardTarget? target,
    VoidCallback? onTap,
    String? help,
    HelpTopic? helpTopic,
    bool accent = false,
    String? title,
  }) => HomeTileFrame(
    icon: _icon(kind),
    title: title ?? _name(l, kind),
    accent: accent,
    help: size == TileSize.small ? null : help,
    helpTopic: helpTopic,
    onTap: onTap ?? (target == null ? null : () => widget.onOpen(target)),
    onLongPress: editing
        ? null
        : () => _edit(
            HomeBoard.columnsFor(
              math.min(MediaQuery.sizeOf(context).width - 24, 1000.0),
            ),
          ),
    child: child,
  );

  /// A figure and the line below it, the usual content of a small widget.
  Widget _figure(
    String figure,
    String? line, {
    Color? color,
    int lines = 2,
    List<Widget> more = const [],
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TileFigure(figure, color: color),
      if (line != null) TileLine(line, maxLines: lines),
      ...more,
    ],
  );

  /// A row of a list inside a widget: a label and its amount.
  Widget _row(
    BuildContext context,
    String label,
    String? trailing, {
    IconData? icon,
    Color? iconColor,
    VoidCallback? onTap,
    String? sub,
  }) {
    final theme = Theme.of(context);
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                if (sub != null)
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            Text(
              trailing,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return row;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: row,
    );
  }

  /// How many rows of a list fit: one for a medium widget, more for a
  /// large one.
  static int _rowsFor(TileSize s) => switch (s) {
    TileSize.small => 1,
    TileSize.medium => 2,
    TileSize.large => 6,
  };

  /// The rows of a list, the ones left over counted at the end.
  List<Widget> _list(
    AppLocalizations l,
    TileSize size,
    List<Widget> rows,
  ) {
    final n = _rowsFor(size);
    if (rows.length <= n) return rows;
    return [
      ...rows.take(n - 1),
      TileLine(l.homeTileOthers(rows.length - n + 1), maxLines: 1),
    ];
  }

  Widget _pepiteTile(BuildContext context, AppLocalizations l, TileSize s) {
    final accounts = _accounts!;
    final overdrawn = accounts.any((e) => _overdrawn(e.$2));
    if (s == TileSize.large) {
      // The whole card: ritual, apps, tip and « Bien démarrer ».
      return Material(
        color:
            Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: PepiteCard(
            key: ValueKey('pepite-${widget.membership.group.id}-$_reloads'),
            membership: widget.membership,
            overdrawn: overdrawn,
            onStep: (step) => widget.onOpen(switch (step) {
              PepiteStep.statements => DashboardTarget.imports,
              PepiteStep.check => DashboardTarget.operations,
              PepiteStep.forecast ||
              PepiteStep.celebrate => DashboardTarget.forecast,
            }),
            onOpenStart: () => widget.onOpen(DashboardTarget.start),
          ),
        ),
      );
    }
    return ListenableBuilder(
      listenable: pepite,
      builder: (context, _) {
        final status = pepite.status;
        final line = status == null
            ? null
            : pepiteLine(
                l,
                status,
                overdrawn: overdrawn,
                today: DateTime.now(),
              );
        return _frame(
          l,
          HomeTileKind.pepite,
          s,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const PepiteScreen()),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PepiteImage(
                line?.pose ?? PepitePose.wave,
                size: s == TileSize.small ? 56 : 72,
              ),
              if (s != TileSize.small && line != null) ...[
                const SizedBox(width: 8),
                Expanded(child: TileLine(line.text, maxLines: 4)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _summaryTile(BuildContext context, AppLocalizations l, TileSize s) {
    final theme = Theme.of(context);
    final issues = _issues(l, context, _accounts!, _month);
    final urgent = issues.any((i) => i.urgency <= 1);
    final colors = context.moneyColors;
    final icon = Icon(
      issues.isEmpty
          ? Icons.check_circle_outline
          : urgent
          ? Icons.error_outline
          : Icons.info_outline,
      size: s == TileSize.small ? 32 : 28,
      color: issues.isEmpty
          ? colors.positive
          : urgent
          ? colors.negative
          : colors.muted,
    );
    final text = Text(
      key: const Key('home-summary'),
      issues.isEmpty ? l.homeAllGood : l.homeIssuesCount(issues.length),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: s == TileSize.small
          ? theme.textTheme.bodyMedium
          : theme.textTheme.titleMedium,
    );
    return _frame(
      l,
      HomeTileKind.summary,
      s,
      target: issues.isEmpty ? DashboardTarget.summary : issues.first.target,
      child: s == TileSize.small
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [icon, const SizedBox(height: 4), text],
            )
          : Row(
              children: [
                icon,
                const SizedBox(width: 12),
                Expanded(child: text),
              ],
            ),
    );
  }

  Widget _statusTile(BuildContext context, AppLocalizations l, TileSize s) {
    final accounts = _accounts!;
    final month = _month;
    final issues = _issues(l, context, accounts, month);
    final colors = context.moneyColors;
    if (s == TileSize.small) {
      return _frame(
        l,
        HomeTileKind.status,
        s,
        target: issues.isEmpty ? DashboardTarget.summary : issues.first.target,
        child: _figure(
          issues.isEmpty ? '✓' : '${issues.length}',
          issues.isEmpty ? l.homeTileIssues(0) : issues.first.text,
          color: issues.any((i) => i.urgency <= 1) ? colors.negative : null,
        ),
      );
    }
    final noOverdraft = accounts.every(
      (e) => e.$2 == null || e.$2!.lowestBalanceCents >= 0,
    );
    final good = [
      if (noOverdraft) l.homeGoodNoOverdraft,
      if (month != null && month.unclassifiedCount == 0) l.homeGoodClassified,
      if (widget.unread == 0) l.homeGoodNoNotification,
    ];
    return _frame(
      l,
      HomeTileKind.status,
      s,
      title: l.dashboardWatch,
      help: l.cardHelpWatch,
      helpTopic: HelpTopic.home,
      target: DashboardTarget.summary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (issues.isEmpty) ...[
            TileLine(l.dashboardAllGood, maxLines: 2),
            if (s == TileSize.large)
              for (final g in good)
                _row(
                  context,
                  g,
                  null,
                  icon: Icons.check,
                  iconColor: colors.positive,
                ),
          ],
          ..._list(l, s, [
            for (final i in issues)
              _row(
                context,
                i.text,
                null,
                icon: i.icon,
                iconColor: i.urgency <= 1 ? colors.negative : null,
                onTap: () => widget.onOpen(i.target),
              ),
          ]),
          if (s == TileSize.large)
            _row(
              context,
              l.summaryOpen,
              null,
              icon: Icons.event_note_outlined,
              onTap: () => widget.onOpen(DashboardTarget.summary),
            ),
        ],
      ),
    );
  }

  /// The first launch, in three steps (decision 0041, point 15): an
  /// account, a statement, the categories. « Masquer » takes the widget
  /// off the board.
  Widget _firstStepsTile(
    BuildContext context,
    AppLocalizations l,
    TileSize s,
  ) {
    final start = _start;
    final accounts = _accounts!;
    final month = _month;
    final hasAccount = accounts.isNotEmpty;
    final imported = start?.done.contains('account') ?? false;
    final classified =
        imported &&
        ((start?.done.contains('rules') ?? false) ||
            (month != null && month.unclassifiedCount == 0));
    final steps = [
      (l.firstStepAccount, hasAccount, DashboardTarget.accounts),
      (l.firstStepImport, imported, DashboardTarget.imports),
      (l.firstStepCategories, classified, DashboardTarget.operations),
    ];
    final done = steps.where((e) => e.$2).length;
    final next = steps.indexWhere((e) => !e.$2);
    final colors = context.moneyColors;
    final hide = TextButton(
      key: const Key('first-steps-hide'),
      onPressed: _hideFirstSteps,
      child: Text(l.firstStepsHide),
    );
    return _frame(
      l,
      HomeTileKind.firstSteps,
      s,
      title: l.firstStepsTitle(done, steps.length),
      target: next < 0 ? null : steps[next].$3,
      child: KeyedSubtree(
        key: const Key('first-steps'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (next < 0)
              TileLine(l.homeTileStepsDone)
            else if (s == TileSize.medium)
              _row(
                context,
                steps[next].$1,
                null,
                icon: Icons.chevron_right,
                onTap: () => widget.onOpen(steps[next].$3),
              )
            else
              for (final (i, (title, ok, target)) in steps.indexed)
                InkWell(
                  key: Key('first-step-$i'),
                  onTap: ok ? null : () => widget.onOpen(target),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        ok
                            ? Icon(Icons.check_circle, color: colors.positive)
                            : CircleAvatar(radius: 12, child: Text('${i + 1}')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: ok
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const Spacer(),
            Align(alignment: Alignment.centerRight, child: hide),
          ],
        ),
      ),
    );
  }

  /// « Masquer » on « Premiers pas »: off the boards of this device.
  Future<void> _hideFirstSteps() async {
    for (final columns in const [2, 4]) {
      final board = uiPrefs.homeBoard(columns);
      if (board.contains(HomeTileKind.firstSteps)) {
        await uiPrefs.setHomeBoard(board.removed(HomeTileKind.firstSteps));
      }
    }
    if (mounted) setState(() {});
  }

  Widget _advicesTile(BuildContext context, AppLocalizations l, TileSize s) {
    final title = widget.adviceTitle;
    final shown = title == null ? const <ActionProposal>[] : widget.advices;
    if (s == TileSize.small) {
      return _frame(
        l,
        HomeTileKind.advices,
        s,
        onTap: widget.onAdvisor,
        child: _figure('${shown.length}', l.homeTileAdvices(shown.length)),
      );
    }
    final n = s == TileSize.medium ? 2 : 4;
    return _frame(
      l,
      HomeTileKind.advices,
      s,
      title: l.homeAdvicesTitle,
      help: l.cardHelpAdvices,
      helpTopic: HelpTopic.advisor,
      onTap: widget.onAdvisor,
      child: KeyedSubtree(
        key: const Key('home-advices'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (shown.isEmpty) TileLine(l.homeAdvicesNone),
            for (final p in shown.take(n))
              _row(
                context,
                title!(p),
                null,
                icon: Icons.tips_and_updates_outlined,
                onTap: widget.onAdvisor,
              ),
            if (shown.length > n)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const Key('home-advices-all'),
                  onPressed: widget.onAdvisor,
                  child: Text(l.homeAdvicesAllCount(shown.length)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// The accounts in euros with a forecast, their total and the lowest.
  ({
    List<(Account, ForecastResult)> known,
    int total,
    (Account, ForecastResult)? lowest,
  })
  _money() {
    final known = [
      for (final (a, f) in _accounts!)
        if (f != null && a.currency == 'EUR') (a, f),
    ];
    return (
      known: known,
      total: known.fold(0, (s, e) => s + e.$2.currentBalanceCents),
      lowest: known.isEmpty
          ? null
          : known.reduce(
              (a, b) =>
                  a.$2.lowestBalanceCents <= b.$2.lowestBalanceCents ? a : b,
            ),
    );
  }

  Widget _balanceTile(BuildContext context, AppLocalizations l, TileSize s) {
    final scheme = Theme.of(context).colorScheme;
    final m = _money();
    final lowest = m.lowest;
    return _frame(
      l,
      HomeTileKind.balance,
      s,
      accent: true,
      title: s == TileSize.small
          ? l.homeCardBalance
          : l.dashboardBalance(m.known.length),
      target: DashboardTarget.accounts,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TileFigure(
            context.money(m.total),
            large: s != TileSize.small,
            color: scheme.onPrimaryContainer,
          ),
          if (s != TileSize.small && lowest != null)
            TileLine(
              l.dashboardLowest(
                lowest.$1.name,
                context.money(lowest.$2.lowestBalanceCents),
                context.day(lowest.$2.lowestDate),
              ),
              color: scheme.onPrimaryContainer,
            ),
          if (s == TileSize.large) ...[
            WhyButton(
              key: const Key('why-balance'),
              color: scheme.onPrimaryContainer,
              title: l.whyBalanceTitle,
              lines: [
                for (final (a, f) in m.known)
                  WhyLine(a.name, f.currentBalanceCents),
                WhyLine(l.whyTotal, m.total, total: true),
              ],
              explanation: l.whyBalanceText,
            ),
            for (final (a, f) in _accounts!.take(3))
              _row(
                context,
                a.name,
                f == null
                    ? null
                    : context.money(
                        f.currentBalanceCents,
                        currency: a.currency,
                      ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _accountsTile(BuildContext context, AppLocalizations l, TileSize s) {
    final accounts = _accounts!;
    return _frame(
      l,
      HomeTileKind.accounts,
      s,
      target: DashboardTarget.accounts,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (accounts.isEmpty) TileLine(l.homeTileNoAccount),
          ..._list(l, s == TileSize.medium ? TileSize.medium : s, [
            for (final (a, f) in accounts)
              _row(
                context,
                a.name,
                f == null
                    ? null
                    : context.money(
                        f.currentBalanceCents,
                        currency: a.currency,
                      ),
                icon: Icons.account_balance_wallet_outlined,
              ),
          ]),
        ],
      ),
    );
  }

  Widget _leftTile(BuildContext context, AppLocalizations l, TileSize s) {
    final r = _left;
    final colors = context.moneyColors;
    if (r == null) {
      return _frame(
        l,
        HomeTileKind.leftToLive,
        s,
        target: DashboardTarget.budget,
        child: TileLine(l.homeTileNoForecast),
      );
    }
    return _frame(
      l,
      HomeTileKind.leftToLive,
      s,
      target: DashboardTarget.budget,
      help: l.leftToLiveHelp,
      helpTopic: HelpTopic.budget,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TileFigure(
            context.money(r.leftCents),
            large: s == TileSize.large,
            color: r.leftCents < 0 ? colors.negative : null,
          ),
          TileLine(
            s == TileSize.small
                ? l.homeTilePerDay(context.money(r.perDayCents))
                : '${l.homeTilePerDay(context.money(r.perDayCents))}, '
                      '${l.homeTileUntil(context.day(r.last))}',
          ),
          if (s == TileSize.large) ...[
            const SizedBox(height: 4),
            _row(context, l.whyLeftBalance, context.money(r.balanceCents)),
            _row(
              context,
              l.whyLeftDebits(context.day(r.last)),
              context.money(r.plannedDebitsCents),
            ),
            _row(
              context,
              l.whyLeftCredits(context.day(r.last)),
              context.money(r.plannedCreditsCents),
            ),
          ],
        ],
      ),
    );
  }

  Widget _monthTile(BuildContext context, AppLocalizations l, TileSize s) {
    final r = _month;
    final colors = context.moneyColors;
    if (r == null) {
      return _frame(
        l,
        HomeTileKind.monthBalance,
        s,
        target: DashboardTarget.budget,
        child: const SizedBox.shrink(),
      );
    }
    final out = r.expenseCents + r.savingsCents;
    final scale = math.max(1, math.max(r.incomeCents, out));
    return _frame(
      l,
      HomeTileKind.monthBalance,
      s,
      target: DashboardTarget.budget,
      help: l.homeCardMonthBalanceHelp,
      helpTopic: HelpTopic.budget,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TileFigure(
            context.money(r.netCents),
            large: s == TileSize.large,
            color: r.netCents < 0 ? colors.negative : colors.positive,
          ),
          TileLine(
            s == TileSize.small
                ? l.homeTileNet
                : l.dashboardMonthTotals(
                    context.money(r.expenseCents),
                    context.money(r.incomeCents),
                  ),
          ),
          if (s == TileSize.large) ...[
            const SizedBox(height: 8),
            _row(context, l.budgetIncome, context.money(r.incomeCents)),
            ThinBar(fraction: r.incomeCents / scale, color: ChartColors.good),
            const SizedBox(height: 6),
            _row(context, l.budgetExpenses, context.money(out)),
            ThinBar(fraction: out / scale, color: ChartColors.critical),
          ],
        ],
      ),
    );
  }

  /// The planned operations of the next 7 days.
  Widget _upcomingTile(BuildContext context, AppLocalizations l, TileSize s) {
    final today = todayUtcMidnight();
    final until = today.add(const Duration(days: 7));
    final items = [
      for (final i in _calendar?.items ?? const <CalendarItem>[])
        if (i.status == OccurrenceStatus.upcoming &&
            !i.date.isBefore(today) &&
            !i.date.isAfter(until))
          i,
    ]..sort((a, b) => a.date.compareTo(b.date));
    IconData icon(CalendarItem i) => i.loanId != null
        ? Icons.account_balance_outlined
        : i.subscription
        ? Icons.autorenew
        : Icons.event_repeat;
    if (s == TileSize.small) {
      return _frame(
        l,
        HomeTileKind.upcoming,
        s,
        target: DashboardTarget.forecast,
        child: _figure(
          '${items.length}',
          items.isEmpty
              ? l.homeTileUpcoming(0)
              : '${items.first.label} · ${context.shortDay(items.first.date)}',
        ),
      );
    }
    return _frame(
      l,
      HomeTileKind.upcoming,
      s,
      title: l.dashboardUpcoming,
      help: l.cardHelpUpcoming,
      helpTopic: HelpTopic.forecast,
      target: DashboardTarget.forecast,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (items.isEmpty) TileLine(l.dashboardUpcomingNone),
          ..._list(l, s, [
            for (final i in items)
              _row(
                context,
                i.label,
                context.money(i.amountCents),
                icon: icon(i),
                sub: s == TileSize.large ? context.day(i.date) : null,
              ),
          ]),
        ],
      ),
    );
  }

  /// The month's spending and income, and the categories where most goes.
  Widget _spendingTile(BuildContext context, AppLocalizations l, TileSize s) {
    final r = _month;
    if (r == null) {
      return _frame(
        l,
        HomeTileKind.topSpending,
        s,
        target: DashboardTarget.budget,
        child: const SizedBox.shrink(),
      );
    }
    final top = _spendingFlows(r);
    final most = top.isEmpty ? 1 : top.first.amountCents;
    return _frame(
      l,
      HomeTileKind.topSpending,
      s,
      title: l.dashboardMonthSpending,
      help: l.cardHelpTopSpending,
      helpTopic: HelpTopic.budget,
      target: DashboardTarget.budget,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (s == TileSize.small)
            _figure(context.money(r.expenseCents), l.homeTileSpent)
          else
            TileLine(
              l.dashboardMonthTotals(
                context.money(r.expenseCents),
                context.money(r.incomeCents),
              ),
            ),
          if (s != TileSize.small && r.unclassifiedCount > 0)
            TileLine(l.dashboardToClassify(r.unclassifiedCount), maxLines: 1),
          if (s == TileSize.large)
            for (final c in top.take(4)) ...[
              _row(
                context,
                context.categoryName(_categories[c.categoryId]!),
                context.money(c.amountCents),
              ),
              ThinBar(
                fraction: c.amountCents / most,
                color: Theme.of(context).colorScheme.primary,
                marker: c.goalCents == null || c.goalCents == 0
                    ? null
                    : c.goalCents!.abs() / most,
                height: 6,
              ),
            ],
        ],
      ),
    );
  }

  /// The balance of every account in euros, summed day by day.
  List<int> _totalDays() {
    final byDay = <DateTime, int>{};
    for (final (a, f) in _accounts!) {
      if (f == null || a.currency != 'EUR') continue;
      for (final d in f.days) {
        byDay[d.date] = (byDay[d.date] ?? 0) + d.balanceCents;
      }
    }
    final days = byDay.keys.toList()..sort();
    return [for (final d in days) byDay[d]!];
  }

  Widget _forecastTile(BuildContext context, AppLocalizations l, TileSize s) {
    final m = _money();
    final lowest = m.lowest;
    final days = _totalDays();
    final colors = context.moneyColors;
    if (lowest == null || days.length < 2) {
      return _frame(
        l,
        HomeTileKind.forecast,
        s,
        target: DashboardTarget.forecast,
        child: TileLine(l.homeTileNoForecast),
      );
    }
    final low = days.reduce(math.min);
    final lowDay = _lowestDay() ?? lowest.$2.lowestDate;
    final line = l.homeTileLowest(context.money(low), context.day(lowDay));
    if (s == TileSize.small) {
      return _frame(
        l,
        HomeTileKind.forecast,
        s,
        target: DashboardTarget.forecast,
        child: _figure(
          context.money(low),
          context.day(lowDay),
          color: low < 0 ? colors.negative : null,
        ),
      );
    }
    return _frame(
      l,
      HomeTileKind.forecast,
      s,
      help: l.homeCardForecastHelp,
      helpTopic: HelpTopic.forecast,
      target: DashboardTarget.forecast,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (s == TileSize.large) TileFigure(context.money(m.total)),
          TileLine(line, maxLines: 1, color: low < 0 ? colors.negative : null),
          const SizedBox(height: 4),
          Expanded(
            child: Sparkline(values: days, semanticLabel: line),
          ),
        ],
      ),
    );
  }

  /// The day the summed balance is lowest.
  DateTime? _lowestDay() {
    final byDay = <DateTime, int>{};
    for (final (a, f) in _accounts!) {
      if (f == null || a.currency != 'EUR') continue;
      for (final d in f.days) {
        byDay[d.date] = (byDay[d.date] ?? 0) + d.balanceCents;
      }
    }
    if (byDay.isEmpty) return null;
    final days = byDay.keys.toList()..sort();
    return days.reduce((a, b) => byDay[b]! < byDay[a]! ? b : a);
  }

  Widget _operationsTile(
    BuildContext context,
    AppLocalizations l,
    TileSize s,
  ) {
    final recent = _recent;
    return _frame(
      l,
      HomeTileKind.operations,
      s,
      target: DashboardTarget.operations,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (recent != null && recent.isEmpty) TileLine(l.homeTileNoOperation),
          for (final (t, a) in (recent ?? const []).take(
            _rowsFor(s) - (s == TileSize.large ? 1 : 0),
          ))
            _row(
              context,
              t.cleanLabel,
              context.money(t.amountCents, currency: a.currency),
              sub: s == TileSize.large
                  ? '${context.shortDay(t.date)} · ${a.name}'
                  : null,
            ),
        ],
      ),
    );
  }

  Widget _toClassifyTile(
    BuildContext context,
    AppLocalizations l,
    TileSize s,
  ) {
    final n = _month?.unclassifiedCount ?? 0;
    return _frame(
      l,
      HomeTileKind.toClassify,
      s,
      target: DashboardTarget.toClassify,
      child: _figure(
        '$n',
        s == TileSize.small
            ? l.homeTileToClassify(n)
            : n == 0
            ? l.homeGoodClassified
            : l.homeIssueToClassify(n),
        color: n > 0 ? context.moneyColors.negative : null,
      ),
    );
  }

  Widget _subscriptionsTile(
    BuildContext context,
    AppLocalizations l,
    TileSize s,
  ) {
    final subs = [
      for (final i in _calendar?.items ?? const <CalendarItem>[])
        if (i.subscription) i,
    ]..sort((a, b) => a.date.compareTo(b.date));
    final total = subs.fold(0, (sum, i) => sum + i.amountCents);
    final colors = context.moneyColors;
    return _frame(
      l,
      HomeTileKind.subscriptions,
      s,
      help: l.homeCardSubscriptionsHelp,
      helpTopic: HelpTopic.operations,
      target: DashboardTarget.subscriptions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TileFigure(context.money(total), large: s == TileSize.large),
          TileLine(l.homeTileSubscriptions(subs.length), maxLines: 1),
          if (s != TileSize.small && _rises.isNotEmpty)
            TileLine(
              l.homeTileRises(_rises.length),
              maxLines: 1,
              color: colors.negative,
            ),
          if (s == TileSize.large)
            ..._list(l, TileSize.medium, [
              for (final c in _rises)
                _row(
                  context,
                  c.label,
                  context.money(c.actualCents),
                  icon: Icons.trending_up,
                  iconColor: colors.negative,
                ),
            ]),
          if (s == TileSize.large)
            ..._list(l, TileSize.medium, [
              for (final i in subs)
                if (!_rises.any((c) => c.label == i.label))
                  _row(
                    context,
                    i.label,
                    context.money(i.amountCents),
                    icon: Icons.autorenew,
                  ),
            ]),
        ],
      ),
    );
  }

  Widget _loansTile(BuildContext context, AppLocalizations l, TileSize s) {
    final o = _loans;
    final running = [
      for (final i in o?.loans ?? const <LoanInfo>[])
        if (i.nextDueDate != null) i,
    ]..sort((a, b) => a.nextDueDate!.compareTo(b.nextDueDate!));
    if (o == null || running.isEmpty) {
      return _frame(
        l,
        HomeTileKind.loans,
        s,
        target: DashboardTarget.loans,
        child: TileLine(l.homeTileNoLoan),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return _frame(
      l,
      HomeTileKind.loans,
      s,
      help: l.homeCardLoansHelp,
      helpTopic: HelpTopic.loans,
      target: DashboardTarget.loans,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TileFigure(
            context.money(o.totalRemainingCents),
            large: s == TileSize.large,
          ),
          TileLine(
            s == TileSize.small
                ? l.loanRemainingShort
                : '${l.loanRemainingShort} · '
                      '${l.homeTileLoanMonthly(context.money(o.totalMonthlyCents))}',
            maxLines: 1,
          ),
          if (s != TileSize.small)
            TileLine(
              l.homeTileLoanNext(context.day(running.first.nextDueDate!)),
              maxLines: 1,
            ),
          if (s == TileSize.large)
            for (final i in running.take(3)) ...[
              _row(
                context,
                i.loan.label ?? i.loan.lender,
                context.money(i.remainingCents),
              ),
              ThinBar(
                fraction: i.repaidPerMille / 1000,
                color: scheme.primary,
                height: 6,
              ),
            ],
        ],
      ),
    );
  }

  Widget _invoicesTile(BuildContext context, AppLocalizations l, TileSize s) {
    final n = _unattached;
    return _frame(
      l,
      HomeTileKind.invoices,
      s,
      target: DashboardTarget.invoices,
      child: n == null
          ? const SizedBox.shrink()
          : _figure(
              '$n',
              s == TileSize.small
                  ? l.homeTileUnattached(n)
                  : l.homeCardInvoicesHelp,
            ),
    );
  }

  Widget _importsTile(BuildContext context, AppLocalizations l, TileSize s) {
    final last = _lastImport;
    return _frame(
      l,
      HomeTileKind.imports,
      s,
      target: DashboardTarget.imports,
      child: !_importsKnown
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (last == null)
                  TileLine(l.homeTileImportNever)
                else ...[
                  TileFigure(context.shortDay(last)),
                  TileLine(
                    l.homeTileImportLast(context.day(last)),
                    maxLines: 1,
                  ),
                ],
                if (s != TileSize.small)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => widget.onOpen(DashboardTarget.imports),
                    icon: const Icon(Icons.upload_file_outlined, size: 18),
                    label: Text(l.homeTileImportAction),
                  ),
              ],
            ),
    );
  }

  Widget _notificationsTile(
    BuildContext context,
    AppLocalizations l,
    TileSize s,
  ) {
    final n = widget.unread;
    return _frame(
      l,
      HomeTileKind.notifications,
      s,
      target: DashboardTarget.notifications,
      child: _figure(
        '$n',
        s == TileSize.small
            ? l.homeTileUnread(n)
            : n == 0
            ? l.homeGoodNoNotification
            : l.dashboardUnread(n),
      ),
    );
  }

  // ------------------------------------------------- decision 0046 tiles

  /// The spending goals of the month: what is left of them, spent against
  /// planned, the goals exceeded and, when large, the goals nearest to
  /// their limit (the same figures as the budget page).
  Widget _budgetTile(BuildContext context, AppLocalizations l, TileSize s) {
    final colors = context.moneyColors;
    final month = _month;
    if (month == null || !_fetched.contains(HomeTileKind.budget)) {
      return _frame(
        l,
        HomeTileKind.budget,
        s,
        target: DashboardTarget.budget,
        child: const SizedBox.shrink(),
      );
    }
    double used(CategoryFlow c) => c.amountCents.abs() / c.goalCents!.abs();
    final goals = [
      for (final c in month.categories)
        if ((c.goalCents ?? 0) != 0 && _categories[c.categoryId] != null) c,
    ]..sort((a, b) => used(b).compareTo(used(a)));
    final planned = goals.fold(0, (sum, c) => sum + c.goalCents!.abs());
    final spent = goals.fold(0, (sum, c) => sum + c.amountCents.abs());
    final over = goals.where((c) => used(c) > 1).length;
    final left = planned - spent;
    const shown = 3;
    return _frame(
      l,
      HomeTileKind.budget,
      s,
      help: l.homeCardBudgetHelp,
      helpTopic: HelpTopic.budget,
      target: DashboardTarget.budget,
      child: goals.isEmpty
          ? TileLine(l.homeTileBudgetNone, maxLines: 3)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TileFigure(
                  context.money(left),
                  color: left < 0 ? colors.negative : null,
                ),
                TileLine(
                  s == TileSize.small
                      ? l.homeTileBudgetLeft
                      : l.homeTileBudgetSpent(
                          context.money(spent),
                          context.money(planned),
                        ),
                  maxLines: s == TileSize.small ? 2 : 1,
                ),
                if (s != TileSize.small && over > 0)
                  TileLine(
                    l.homeTileBudgetOver(over),
                    maxLines: 1,
                    color: colors.negative,
                  ),
                if (s == TileSize.large)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final c in goals.take(
                            goals.length > shown ? shown - 1 : shown,
                          )) ...[
                            _row(
                              context,
                              context.categoryName(_categories[c.categoryId]!),
                              '${context.money(c.amountCents.abs())} / '
                              '${context.money(c.goalCents!.abs())}',
                            ),
                            ThinBar(
                              fraction: math.min(used(c), 1),
                              color: used(c) > 1
                                  ? colors.negative
                                  : Theme.of(context).colorScheme.primary,
                              height: 6,
                            ),
                          ],
                          if (goals.length > shown)
                            TileLine(
                              l.homeTileOthers(goals.length - shown + 1),
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  /// The summary of the next 30 days (decision 0035) in brief: the lowest
  /// point of the forecast, the notifications unread, the advices waiting.
  Widget _monthSummaryTile(
    BuildContext context,
    AppLocalizations l,
    TileSize s,
  ) {
    final colors = context.moneyColors;
    final days = _totalDays();
    final low = days.isEmpty ? null : days.reduce(math.min);
    final lowDay = _lowestDay();
    final lowColor = low != null && low < 0 ? colors.negative : null;
    final unread = widget.unread;
    final lowLine = low == null || lowDay == null
        ? l.homeTileNoForecast
        : l.homeTileLowest(context.money(low), context.day(lowDay));
    return _frame(
      l,
      HomeTileKind.monthSummary,
      s,
      help: l.homeCardMonthSummaryHelp,
      helpTopic: HelpTopic.home,
      target: DashboardTarget.summary,
      child: s == TileSize.small
          ? low == null || lowDay == null
                ? TileLine(l.homeTileNoForecast)
                : _figure(
                    context.money(low),
                    l.homeTileSummaryLowest(context.day(lowDay)),
                    color: lowColor,
                  )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (s == TileSize.large && low != null)
                  TileFigure(context.money(low), color: lowColor),
                TileLine(lowLine, maxLines: 1, color: lowColor),
                TileLine(
                  unread == 0
                      ? l.homeGoodNoNotification
                      : l.dashboardUnread(unread),
                  maxLines: 1,
                ),
                if (s == TileSize.large && widget.onAdvisor != null)
                  TileLine(
                    l.homeTileSummaryAdvices(widget.advices.length),
                    maxLines: 1,
                  ),
                if (s == TileSize.large && _rises.isNotEmpty)
                  TileLine(
                    l.homeTileRises(_rises.length),
                    maxLines: 1,
                    color: colors.negative,
                  ),
                if (s == TileSize.large && days.length >= 2) ...[
                  const SizedBox(height: 4),
                  Expanded(
                    child: Sparkline(values: days, semanticLabel: lowLine),
                  ),
                ],
              ],
            ),
    );
  }

  /// A widget that opens a function of the app: its icon and what it does,
  /// with a figure when there is one at hand (the number of categories).
  Widget _shortcutTile(
    BuildContext context,
    AppLocalizations l,
    HomeTileKind k,
    TileSize s,
  ) {
    final f = _function(k);
    final open = k == HomeTileKind.search
        ? widget.onSearch
        : f == null
        ? null
        : () => widget.onFunction?.call(f);
    final count = k == HomeTileKind.categories && _fetched.contains(k)
        ? _categories.length
        : null;
    return _frame(
      l,
      k,
      s,
      onTap: open,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (count != null)
            TileFigure('$count')
          else
            Icon(
              _icon(k),
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          const SizedBox(height: 4),
          if (k == HomeTileKind.members && s == TileSize.medium)
            TileLine(widget.membership.group.name, maxLines: 1),
          TileLine(_help(l, k), maxLines: count != null ? 1 : 2),
        ],
      ),
    );
  }

  /// The top-level expense categories of [r] with money spent, the
  /// largest first. Flows are positive (money spent).
  List<CategoryFlow> _spendingFlows(SpendingReport r) {
    bool topExpense(int id) {
      final c = _categories[id];
      return c != null && c.kind == CategoryKind.expense && c.parentId == null;
    }

    return [
      for (final c in r.categories)
        if (c.amountCents > 0 && topExpense(c.categoryId)) c,
    ]..sort((a, b) => b.amountCents.compareTo(a.amountCents));
  }

  /// The split of the month's spending by category (decision 0047): the
  /// same parts as the pie of the budget page, the smallest merged into
  /// « Autres ». A ring alone when small, with its legend otherwise.
  Widget _splitTile(BuildContext context, AppLocalizations l, TileSize s) {
    final r = _month;
    if (r == null || !_fetched.contains(HomeTileKind.split)) {
      return _frame(
        l,
        HomeTileKind.split,
        s,
        target: DashboardTarget.budget,
        child: const SizedBox.shrink(),
      );
    }
    final parts = core.sharesWithOthers({
      for (final c in _spendingFlows(r)) c.categoryId: c.amountCents,
    }, max: SeriesColors.count);
    final total = parts.fold(0, (a, p) => a + p.cents);
    final slices = [
      for (final (i, p) in parts.indexed)
        ChartSlice(
          label: p.id == null
              ? l.pieOthers
              : context.categoryName(_categories[p.id]!),
          cents: p.cents,
          color: p.id == null
              ? SeriesColors.others(context)
              : SeriesColors.of(context, i),
        ),
    ];
    final ring = MiniDonut(
      key: const Key('home-split-ring'),
      slices: slices,
      semanticLabel: [
        l.pieSemantic,
        for (final c in slices)
          '${c.label} ${l.sharePercent((c.cents * 100 / total).round())}',
      ].join(', '),
      center: s == TileSize.small
          ? null
          : Text(
              context.money(total),
              style: Theme.of(context).textTheme.titleSmall,
            ),
    );
    Widget legend(int lines) {
      final shown = slices.length <= lines
          ? slices
          : slices.take(lines - 1).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final c in shown)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: c.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: TileLine(c.label, maxLines: 1)),
                  const SizedBox(width: 4),
                  TileLine(
                    s == TileSize.large
                        ? '${context.money(c.cents)} · '
                              '${l.sharePercent((c.cents * 100 / total).round())}'
                        : l.sharePercent((c.cents * 100 / total).round()),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          if (slices.length > lines)
            TileLine(l.homeTileOthers(slices.length - lines + 1), maxLines: 1),
        ],
      );
    }

    return _frame(
      l,
      HomeTileKind.split,
      s,
      help: l.homeCardSplitHelp,
      helpTopic: HelpTopic.budget,
      target: DashboardTarget.budget,
      child: total <= 0
          ? TileLine(l.homeTileSplitNone, maxLines: 3)
          : switch (s) {
              TileSize.small => ring,
              TileSize.medium => Row(
                children: [
                  ring,
                  const SizedBox(width: 12),
                  Expanded(child: legend(3)),
                ],
              ),
              TileSize.large => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: ring),
                  const SizedBox(height: 8),
                  legend(4),
                ],
              ),
            },
    );
  }

  // -------------------------------------------------------------- issues

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
