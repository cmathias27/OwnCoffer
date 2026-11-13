import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../assistant/chat_controller.dart';
import '../client.dart';
import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../navigation/search.dart';
import '../navigation/sections.dart';
import '../state/pepite.dart';
import '../state/pepite_advice.dart';
import '../state/session.dart';
import '../state/ui_prefs.dart';
import '../util/app_update.dart';
import '../util/app_versions.dart';
import '../util/file_pick.dart';
import '../util/incoming_file.dart';
import '../util/web_search.dart';
import '../widgets/app_update_flow.dart';
import '../widgets/form_card.dart';
import '../widgets/invoices.dart';
import '../widgets/pepite.dart' show showPepiteCheer;
import '../widgets/pepite_apps.dart';
import 'accounts_screen.dart';
import 'admin_screen.dart';
import 'advisor_screen.dart';
import 'apps_screen.dart';
import 'assistant_screen.dart';
import 'budget_screen.dart';
import 'categories_screen.dart';
import 'dashboard_screen.dart';
import 'export_screen.dart';
import 'feedback_screen.dart';
import 'forecast_screen.dart';
import 'getting_started_screen.dart';
import 'import_screen.dart';
import 'invoices_screen.dart';
import 'loans_screen.dart';
import 'members_screen.dart';
import 'month_summary_screen.dart';
import 'notifications_screen.dart';
import 'operations_screen.dart';
import 'pepite_screen.dart';
import 'security_screen.dart';
import 'settings_screen.dart';

/// Signed-in shell (decision 0041): five sections in a rail on wide screens
/// or a bottom bar on phones; the pages of a section as tabs under the top
/// bar; the household, « + », the search, the bell and « Réglages » above.
class HomeScreen extends StatefulWidget {
  final SessionController session;
  const HomeScreen({super.key, required this.session});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Shows the server administration.
  var _isServerAdmin = false;
  var _page = AppPage.home;

  /// The page last opened in each section, found again when coming back.
  final Map<AppSection, AppPage> _lastPage = {};
  List<Account> _accounts = [];
  Account? _openAccount;
  OperationsIntent? _opsIntent;
  var _opsRequest = 0;
  PickedFile? _pendingImportFile;
  StreamSubscription<PickedFile>? _incomingFileSub;
  var _imports = 0;
  var _unread = 0;

  /// Advices proposed since the last visit to « Conseiller ».
  var _newAdvices = 0;
  List<ActionProposal> _advices = const [];
  String Function(ActionProposal)? _adviceTitle;
  Timer? _unreadTimer;
  final _accountsKey = GlobalKey<AccountsScreenState>();
  final _forecastKey = GlobalKey<ForecastScreenState>();
  final _budgetKey = GlobalKey<BudgetScreenState>();
  final _loansKey = GlobalKey<LoansScreenState>();
  final _dashboardKey = GlobalKey<DashboardScreenState>();
  final _invoicesKey = GlobalKey<InvoicesScreenState>();
  final _advisorKey = GlobalKey<AdvisorScreenState>();
  final _shortcutsFocus = FocusNode(debugLabel: 'shortcuts');

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    client.admin.isServerAdmin().then((v) {
      if (mounted && v) setState(() => _isServerAdmin = true);
    }, onError: (_) {});
    _loadUnread();
    // The server checks forecasts every hour; a light refresh of the badges.
    _unreadTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      _loadUnread();
      _advisorKey.currentState?.reload();
    });
    pepite.addListener(_onPepite);
    IncomingFileHandler.init();
    _incomingFileSub = IncomingFileHandler.files.listen((file) {
      if (mounted) {
        setState(() {
          _show(AppPage.imports);
          _pendingImportFile = file;
        });
      }
    });
    final joined = widget.session.joinedGroupName;
    if (joined != null) {
      widget.session.joinedGroupName = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).invitationAccepted(joined),
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _unreadTimer?.cancel();
    _incomingFileSub?.cancel();
    _shortcutsFocus.dispose();
    pepite.removeListener(_onPepite);
    // Signed out: the conversation is forgotten.
    chat.detach();
    super.dispose();
  }

  bool get _canWrite =>
      widget.session.currentGroup != null &&
      widget.session.currentGroup!.role != MemberRole.reader;

  Future<void> _loadUnread() async {
    try {
      final n = await client.notification.unreadCount();
      if (mounted && n != _unread) setState(() => _unread = n);
    } on Object {
      // Offline or signed out: the badge keeps its last value.
    }
  }

  /// The advisor loaded its proposals: the badge counts those that came
  /// after the last visit (kept on the device), the home shows the first.
  void _advicesLoaded(
    List<ActionProposal> items,
    String Function(ActionProposal) title,
  ) {
    _adviceTitle = title;
    final pending = [
      for (final p in items)
        if (p.status == 'pending') p,
    ];
    final seen = uiPrefs.advisorSeenAt;
    var fresh = 0;
    if (_page == AppPage.advisor) {
      unawaited(uiPrefs.markAdvisorSeen(DateTime.now()));
    } else {
      fresh = pending
          .where((p) => seen == null || p.createdAt.isAfter(seen))
          .length;
    }
    setState(() => (_advices = pending, _newAdvices = fresh));
  }

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NotificationsScreen(
          onOpenForecast: (accountId) {
            _selectPage(AppPage.forecast);
            _forecastKey.currentState?.showAccount(accountId);
          },
        ),
      ),
    );
    await _loadUnread();
  }

  Future<void> _openSummary(GroupMembership membership) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (summaryContext) => MonthSummaryScreen(
          membership: membership,
          onOpenForecast: (accountId) {
            Navigator.of(summaryContext).pop();
            _selectPage(AppPage.forecast);
            if (accountId != null) {
              _forecastKey.currentState?.showAccount(accountId);
            }
          },
          onOpenNotifications: _openNotifications,
          onOpenAdvisor: () {
            Navigator.of(summaryContext).pop();
            _selectPage(AppPage.advisor);
          },
        ),
      ),
    );
    await _loadUnread();
  }

  Future<void> _loadAccounts() async {
    final g = widget.session.currentGroup;
    if (g == null) return;
    try {
      final list = await client.account.list(g.group.id!);
      if (mounted) setState(() => _accounts = list);
    } on Object {
      // Offline: the pages say it themselves; the "+" menu waits.
    }
  }

  /// Pépite notices by herself the steps of the week (decision 0029): the
  /// operations or the forecast opened; the server sees imports and
  /// changes, so she looks again.
  void _pepiteSees(AppPage page) {
    if (page == AppPage.operations) {
      unawaited(pepite.markStep(PepiteStep.check));
    }
    if (page == AppPage.forecast) {
      unawaited(pepite.markStep(PepiteStep.forecast));
    }
    unawaited(pepite.notice());
  }

  var _cheering = false;

  void _onPepite() {
    if (_cheering || !pepite.hasCheer) return;
    _cheering = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final cheer = pepite.takeCheer();
        if (!mounted || cheer == null) return;
        final apps = await showPepiteCheer(context, cheer);
        if (apps && mounted) {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => AppsScreen(serverVersion: AppVersions.server),
            ),
          );
        }
      } finally {
        _cheering = false;
      }
      if (mounted) _onPepite();
    });
  }

  /// Shows [page] without reloading (inside a `setState`).
  void _show(AppPage page) {
    _page = page;
    _lastPage[page.section] = page;
  }

  void _selectPage(AppPage page) {
    setState(() => _show(page));
    _pepiteSees(page);
    switch (page) {
      case AppPage.accounts:
        _accountsKey.currentState?.reload();
      case AppPage.forecast:
        _forecastKey.currentState?.reload();
      case AppPage.budget:
        _budgetKey.currentState?.reload();
      case AppPage.loans:
        _loansKey.currentState?.reload();
      case AppPage.home:
        _dashboardKey.currentState?.reload();
        _advisorKey.currentState?.reload();
      case AppPage.advisor:
        unawaited(uiPrefs.markAdvisorSeen(DateTime.now()));
        setState(() => _newAdvices = 0);
        _advisorKey.currentState?.reload();
      default:
    }
    _loadAccounts();
    _loadUnread();
  }

  void _selectSection(AppSection section) =>
      _selectPage(_lastPage[section] ?? section.pages.first);

  /// The operations, opened for one purpose; the page is built again.
  void _openOperations(OperationsIntent intent, {Account? account}) {
    setState(() {
      _opsIntent = intent;
      _opsRequest++;
      if (account != null) _openAccount = account;
    });
    _selectPage(AppPage.operations);
  }

  /// « Bien démarrer » (decision 0028): its steps lead to a page, or to
  /// their page on top of the list.
  Future<void> _openStart() async {
    final current = widget.session.currentGroup;
    if (current == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GettingStartedScreen(
          membership: current,
          onTab: (code) => switch (code) {
            'account' => _selectPage(
              _accounts.isEmpty ? AppPage.accounts : AppPage.imports,
            ),
            'rules' => _openCategories(rules: true),
            'scheduled' => _selectPage(AppPage.forecast),
            'goal' => _selectPage(AppPage.budget),
            _ => _selectPage(AppPage.home),
          },
        ),
      ),
    );
    _dashboardKey.currentState?.reload();
  }

  Future<void> _openCategories({bool rules = false}) async {
    final current = widget.session.currentGroup;
    if (current == null) return;
    final l = AppLocalizations.of(context);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: TrailTitle(
              trail: [l.settingsTitle],
              title: l.settingsCategories,
            ),
            actions: const [HelpButton(HelpTopic.categories)],
          ),
          body: CategoriesScreen(
            membership: current,
            initialTab: rules ? 1 : 0,
          ),
        ),
      ),
    );
    if (mounted) setState(() => _imports++);
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(
          session: widget.session,
          membership: widget.session.currentGroup,
          isServerAdmin: _isServerAdmin,
          onStart: widget.session.currentGroup == null ? null : _openStart,
          onFeedback: _feedback,
          onShortcuts: _showShortcuts,
          onCategoriesChanged: () {
            if (mounted) setState(() => _imports++);
          },
        ),
      ),
    );
  }

  Future<void> _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  /// « + » (decision 0041, point 4): a receipt photographed or chosen.
  Future<void> _scanReceipt() async {
    final current = widget.session.currentGroup;
    if (current == null) return;
    final saved = await addUnattachedInvoice(
      context,
      current.group.id!,
      camera: canUseCamera,
    );
    if (saved != null) _invoicesKey.currentState?.reload();
  }

  /// The functions the search may offer to this user.
  List<AppFunction> get _functions {
    final hasGroup = widget.session.currentGroup != null;
    final simple = uiPrefs.simpleMode;
    return [
      for (final f in AppFunction.values)
        if (switch (f) {
          AppFunction.admin => _isServerAdmin,
          AppFunction.members || AppFunction.security => !_isServerAdmin,
          AppFunction.newOperation || AppFunction.scanReceipt => _canWrite,
          AppFunction.rules => !simple && hasGroup,
          AppFunction.display ||
          AppFunction.help ||
          AppFunction.shortcuts ||
          AppFunction.feedback ||
          AppFunction.apps ||
          AppFunction.pepite => true,
          _ => hasGroup,
        })
          f,
    ];
  }

  Future<void> _openSearch() async {
    final current = widget.session.currentGroup;
    final pick = await Navigator.of(context).push<SearchPick>(
      MaterialPageRoute(
        builder: (_) => GlobalSearchScreen(
          groupId: current?.group.id,
          functions: _functions,
          accounts: {for (final a in _accounts) a.id!: a},
        ),
      ),
    );
    if (pick == null || !mounted) return;
    switch (pick) {
      case FunctionPick(:final function):
        await _openFunction(function);
      case OperationPick(:final operation):
        _openOperations(
          OperationsIntent(search: operation.cleanLabel),
          account: _accounts
              .where((a) => a.id == operation.accountId)
              .firstOrNull,
        );
      case LoanPick(:final loan):
        _selectPage(AppPage.loans);
        await _loansKey.currentState?.openLoan(loan.id!);
      case InvoicePick(:final invoice):
        await openInvoice(context, invoice);
    }
  }

  Future<void> _openFunction(AppFunction f) async {
    final current = widget.session.currentGroup;
    switch (f) {
      case AppFunction.home:
        _selectPage(AppPage.home);
      case AppFunction.accounts:
        _selectPage(AppPage.accounts);
      case AppFunction.operations:
        _selectPage(AppPage.operations);
      case AppFunction.forecast:
        _selectPage(AppPage.forecast);
      case AppFunction.budget:
        _selectPage(AppPage.budget);
      case AppFunction.loans:
        _selectPage(AppPage.loans);
      case AppFunction.invoices:
        _selectPage(AppPage.invoices);
      case AppFunction.imports:
        _selectPage(AppPage.imports);
      case AppFunction.advisor:
        _selectPage(AppPage.advisor);
      case AppFunction.toClassify:
        _openOperations(const OperationsIntent(toClassify: true));
      case AppFunction.subscriptions:
        _openOperations(const OperationsIntent(subscriptions: true));
      case AppFunction.newOperation:
        _openOperations(const OperationsIntent(add: true));
      case AppFunction.scanReceipt:
        await _scanReceipt();
      case AppFunction.categories:
        await _openCategories();
      case AppFunction.rules:
        await _openCategories(rules: true);
      case AppFunction.notifications:
        await _openNotifications();
      case AppFunction.summary:
        if (current != null) await _openSummary(current);
      case AppFunction.start:
        await _openStart();
      case AppFunction.display:
        await _openSettings();
      case AppFunction.shortcuts:
        await _showShortcuts();
      case AppFunction.help:
        await _push(HelpPage(topic: _page.help));
      case AppFunction.feedback:
        _feedback();
      case AppFunction.apps:
        await _push(AppsScreen(serverVersion: widget.session.serverVersion));
      case AppFunction.pepite:
        await _push(
          PepiteScreen(onStart: current == null ? null : _openStart),
        );
      case AppFunction.security:
        await _push(const SecurityScreen());
      case AppFunction.admin:
        await _push(AdminScreen(membership: current));
      case AppFunction.members:
        if (current != null) await _push(MembersScreen(membership: current));
      case AppFunction.export:
        if (current != null) {
          await _push(
            ExportScreen(
              membership: current,
              canImport: _isServerAdmin,
              onImported: widget.session.reloadGroups,
            ),
          );
        }
      case AppFunction.assistant:
        if (current != null) {
          await _push(AssistantScreen(membership: current));
          await chat.refreshStatus();
        }
    }
  }

  /// `?` (decision 0041, point 20): the keys of the app.
  Future<void> _showShortcuts() {
    final l = AppLocalizations.of(context);
    Widget row(String keys, String what) => ListTile(
      dense: true,
      leading: SizedBox(
        width: 56,
        child: Text(
          keys,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: Text(what),
    );
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.shortcutsTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            row('/', l.shortcutSearch),
            row('N', l.shortcutNew),
            row('1 – 5', l.shortcutSections),
            row('?', l.shortcutHelp),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          ),
        ],
      ),
    );
  }

  /// The keys of [_showShortcuts], ignored while a field is being typed in
  /// and when a page is open on top.
  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    if (FocusManager.instance.primaryFocus?.context?.widget is EditableText) {
      return KeyEventResult.ignored;
    }
    final keys = HardwareKeyboard.instance;
    if (keys.isControlPressed || keys.isMetaPressed || keys.isAltPressed) {
      return KeyEventResult.ignored;
    }
    if (ModalRoute.of(context)?.isCurrent == false) {
      return KeyEventResult.ignored;
    }
    final hasGroup = widget.session.currentGroup != null;
    final c = e.character;
    if (c == '/') {
      _openSearch();
    } else if (c == '?') {
      _showShortcuts();
    } else if ((c == 'n' || c == 'N') && _canWrite) {
      _openOperations(const OperationsIntent(add: true));
    } else if (hasGroup && c != null && '12345'.contains(c) && c.length == 1) {
      _selectSection(AppSection.values[int.parse(c) - 1]);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  /// The server's administrator reads the remarks; in standalone mode that
  /// is oneself, so they go to the project's issues on GitHub (opened only
  /// when asked).
  void _feedback() {
    if (isStandalone) {
      openLink(
        Uri.parse('https://github.com/cmathias27/OwnCoffer/issues/new/choose'),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FeedbackScreen(page: _page.help.name),
      ),
    );
  }

  Widget _sectionIcon(AppSection section, {required bool selected}) {
    final icon = Icon(selected ? section.selectedIcon : section.icon);
    if (section != AppSection.advisor) return icon;
    return Badge(
      key: const Key('advisor-badge'),
      isLabelVisible: _newAdvices > 0,
      label: Text('$_newAdvices'),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = widget.session;
    final current = s.currentGroup;
    // The chat bubble follows the household shown.
    if (current?.group.id != chat.membership?.group.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => chat.attach(current));
    }
    pepiteAdvice.setTopic(_page.help);
    final layout = navLayoutFor(MediaQuery.sizeOf(context).width);
    final wide = layout != NavLayout.bar;
    final section = _page.section;

    final Widget pages = current == null
        ? _CreateGroup(session: s)
        : IndexedStack(
            index: _page.index,
            children: [
              // In the order of AppPage.
              DashboardScreen(
                key: _dashboardKey,
                membership: current,
                unread: _unread,
                advices: _advices,
                newAdvices: _newAdvices,
                adviceTitle: _adviceTitle,
                onAdvisor: () => _selectPage(AppPage.advisor),
                onOpen: (target) => switch (target) {
                  DashboardTarget.accounts => _selectPage(AppPage.accounts),
                  DashboardTarget.operations => _selectPage(
                    AppPage.operations,
                  ),
                  DashboardTarget.forecast => _selectPage(AppPage.forecast),
                  DashboardTarget.budget => _selectPage(AppPage.budget),
                  DashboardTarget.notifications => _openNotifications(),
                  DashboardTarget.imports => _selectPage(AppPage.imports),
                  DashboardTarget.start => _openStart(),
                  DashboardTarget.summary => _openSummary(current),
                  DashboardTarget.toClassify => _openOperations(
                    const OperationsIntent(toClassify: true),
                  ),
                  DashboardTarget.subscriptions => _openOperations(
                    const OperationsIntent(subscriptions: true),
                  ),
                  DashboardTarget.loans => _selectPage(AppPage.loans),
                  DashboardTarget.advisor => _selectPage(AppPage.advisor),
                  DashboardTarget.invoices => _selectPage(AppPage.invoices),
                },
              ),
              AccountsScreen(
                key: _accountsKey,
                membership: current,
                onOpen: (a) {
                  setState(() => _openAccount = a);
                  unawaited(uiPrefs.setAccountId(a.id));
                  _selectPage(AppPage.operations);
                },
              ),
              OperationsScreen(
                key: ValueKey(
                  'ops-${current.group.id}-${_openAccount?.id}-${_accounts.length}-$_imports-$_opsRequest',
                ),
                membership: current,
                accounts: _accounts,
                initialAccount: _openAccount,
                intent: _opsIntent,
              ),
              ForecastScreen(
                key: _forecastKey,
                membership: current,
                accounts: _accounts,
                onChanged: () {
                  setState(() => _imports++);
                  _accountsKey.currentState?.reload();
                },
              ),
              BudgetScreen(
                key: _budgetKey,
                membership: current,
                accounts: _accounts,
              ),
              LoansScreen(
                key: _loansKey,
                membership: current,
                accounts: _accounts,
                onChanged: () {
                  setState(() => _imports++);
                  _forecastKey.currentState?.reload();
                  _accountsKey.currentState?.reload();
                },
              ),
              InvoicesScreen(key: _invoicesKey, membership: current),
              ImportScreen(
                key: ValueKey('import-${current.group.id}'),
                membership: current,
                accounts: _accounts,
                initialFile: _pendingImportFile,
                onFileHandled: () => setState(() => _pendingImportFile = null),
                onImported: () {
                  setState(() => _imports++);
                  unawaited(pepite.markStep(PepiteStep.statements));
                  unawaited(pepite.notice(force: true));
                  _forecastKey.currentState?.reload();
                  _accountsKey.currentState?.reload();
                },
              ),
              AdvisorScreen(
                key: _advisorKey,
                membership: current,
                embedded: true,
                onLoaded: _advicesLoaded,
              ),
            ],
          );
    final body = Column(
      children: [
        if (current != null && section.pages.length > 1)
          SectionBar(page: _page, onPage: _selectPage),
        Expanded(child: pages),
      ],
    );

    return Focus(
      focusNode: _shortcutsFocus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(
          title: s.groups.length > 1
              ? PopupMenuButton<int>(
                  key: const Key('group-menu'),
                  tooltip: l.groupLabel,
                  onSelected: (id) {
                    s.currentGroupId = id;
                    setState(() => _openAccount = null);
                    _loadAccounts();
                  },
                  itemBuilder: (_) => [
                    for (final g in s.groups)
                      CheckedPopupMenuItem(
                        value: g.group.id!,
                        checked: g.group.id == s.currentGroupId,
                        child: Text(g.group.name),
                      ),
                  ],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          current?.group.name ?? l.appTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                )
              : Text(current?.group.name ?? l.appTitle),
          actions: [
            if (current != null && _canWrite)
              PopupMenuButton<VoidCallback>(
                key: const Key('add-menu'),
                tooltip: l.addMenuTooltip,
                icon: const Icon(Icons.add_circle_outline),
                onSelected: (action) => action(),
                itemBuilder: (context) => [
                  if (_accounts.isNotEmpty)
                    PopupMenuItem(
                      key: const Key('add-operation'),
                      value: () =>
                          _openOperations(const OperationsIntent(add: true)),
                      child: ListTile(
                        leading: const Icon(Icons.edit_note),
                        title: Text(l.operationAdd),
                      ),
                    ),
                  PopupMenuItem(
                    key: const Key('add-receipt'),
                    value: _scanReceipt,
                    child: ListTile(
                      leading: const Icon(Icons.document_scanner_outlined),
                      title: Text(l.addScanReceipt),
                    ),
                  ),
                  PopupMenuItem(
                    key: const Key('add-statement'),
                    value: () => _selectPage(AppPage.imports),
                    child: ListTile(
                      leading: const Icon(Icons.upload_file_outlined),
                      title: Text(l.addImportStatement),
                    ),
                  ),
                ],
              ),
            IconButton(
              key: const Key('open-search'),
              tooltip: l.globalSearchOpen,
              icon: const Icon(Icons.search),
              onPressed: _openSearch,
            ),
            IconButton(
              tooltip: l.notificationsUnread(_unread),
              onPressed: _openNotifications,
              icon: Badge(
                isLabelVisible: _unread > 0,
                label: Text('$_unread'),
                child: Icon(
                  _unread > 0
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_none,
                ),
              ),
            ),
            // The help of a section with one page; the others have it in
            // their tabs bar.
            if (current == null || section.pages.length == 1)
              HelpButton(_page.help),
            IconButton(
              key: const Key('open-settings'),
              tooltip: l.settingsTitle,
              icon: const Icon(Icons.settings_outlined),
              onPressed: _openSettings,
            ),
          ],
        ),
        body: Column(
          children: [
            if (s.demo) const _DemoBanner(),
            AppUpdateBanner(serverVersion: s.serverVersion),
            const PepiteAppsBanner(),
            Expanded(
              child: wide && current != null
                  ? Row(
                      children: [
                        // Scrolls when the window is low (phone sideways).
                        LayoutBuilder(
                          builder: (context, box) => SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: box.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: NavigationRail(
                                  selectedIndex: section.index,
                                  onDestinationSelected: (i) =>
                                      _selectSection(AppSection.values[i]),
                                  extended: layout == NavLayout.extendedRail,
                                  labelType: layout == NavLayout.extendedRail
                                      ? NavigationRailLabelType.none
                                      : NavigationRailLabelType.all,
                                  destinations: [
                                    for (final sec in AppSection.values)
                                      NavigationRailDestination(
                                        icon: _sectionIcon(
                                          sec,
                                          selected: false,
                                        ),
                                        selectedIcon: _sectionIcon(
                                          sec,
                                          selected: true,
                                        ),
                                        label: Text(sec.label(l)),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(child: body),
                      ],
                    )
                  : body,
            ),
          ],
        ),
        bottomNavigationBar: wide || current == null
            ? null
            : NavigationBar(
                selectedIndex: section.index,
                onDestinationSelected: (i) =>
                    _selectSection(AppSection.values[i]),
                destinations: [
                  for (final sec in AppSection.values)
                    NavigationDestination(
                      icon: _sectionIcon(sec, selected: false),
                      selectedIcon: _sectionIcon(sec, selected: true),
                      label: sec.label(l),
                    ),
                ],
              ),
      ),
    );
  }
}

/// On a demonstration instance, on every page: the data is fictitious.
class _DemoBanner extends StatelessWidget {
  const _DemoBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Icon(
              Icons.science_outlined,
              size: 18,
              color: scheme.onTertiaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizations.of(context).demoBanner,
                style: TextStyle(color: scheme.onTertiaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// How the pages are reached for a window [width]: a bottom bar on a
/// phone, a rail on a tablet, an extended rail on a large screen.
enum NavLayout { bar, rail, extendedRail }

NavLayout navLayoutFor(double width) => width >= 1200
    ? NavLayout.extendedRail
    : width >= 600
    ? NavLayout.rail
    : NavLayout.bar;

/// No group yet (e.g. the page was reloaded during the first launch): the
/// server administrator creates the household here; others are told to ask
/// for an invitation (the server refuses them anyway).
class _CreateGroup extends StatefulWidget {
  final SessionController session;
  const _CreateGroup({required this.session});

  @override
  State<_CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<_CreateGroup> {
  final _action = AsyncAction();
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final m = await _action.run(
      context,
      setState,
      () => client.group.create(_name.text.trim()),
    );
    if (m == null) return;
    widget.session.currentGroupId = m.group.id;
    await widget.session.reloadGroups();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FormCard(
      title: l.groupCreateTitle,
      intro: '${l.homeNoGroup}\n\n${l.groupIntro}',
      children: [
        TextField(
          controller: _name,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l.groupNameLabel,
            hintText: l.groupNameHint,
          ),
          onSubmitted: (_) => _create(),
        ),
        ErrorText(_action.error),
        PrimaryButton(
          label: l.continueLabel,
          busy: _action.busy,
          onPressed: _create,
        ),
      ],
    );
  }
}

/// Windows and Android apps older than the server: says so, with the way
/// to the new version. Nothing on the web app, which the server serves.
class AppUpdateBanner extends StatefulWidget {
  final String? serverVersion;

  /// Tests give their own; the device's otherwise.
  final AppUpdater? updater;

  const AppUpdateBanner({super.key, required this.serverVersion, this.updater});

  @override
  State<AppUpdateBanner> createState() => _AppUpdateBannerState();
}

class _AppUpdateBannerState extends State<AppUpdateBanner> {
  String? _app;

  /// "Later": hidden until the server moves to yet another version.
  static String? _dismissedFor;

  @override
  void initState() {
    super.initState();
    AppVersions.app().then((v) {
      if (mounted) setState(() => _app = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final server = widget.serverVersion;
    if (!AppVersions.updateAvailable(_app, server) || _dismissedFor == server) {
      return const SizedBox.shrink();
    }
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
        child: Row(
          children: [
            Icon(
              Icons.system_update,
              size: 18,
              color: scheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l.appsBanner(server!),
                style: TextStyle(color: scheme.onPrimaryContainer),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _dismissedFor = server),
              child: Text(l.appsBannerLater),
            ),
            // Decision 0032: installed from here when the device can.
            if ((widget.updater ?? appUpdater).supported)
              TextButton(
                key: const Key('app-update-install'),
                onPressed: () => installAppUpdate(
                  context,
                  server,
                  updater: widget.updater,
                ),
                child: Text(l.appsInstallShort),
              )
            else
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AppsScreen(serverVersion: server),
                  ),
                ),
                child: Text(l.appsDownload),
              ),
          ],
        ),
      ),
    );
  }
}
