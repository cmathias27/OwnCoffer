import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../state/session.dart';
import '../widgets/form_card.dart';
import 'accounts_screen.dart';
import 'admin_screen.dart';
import 'budget_screen.dart';
import 'categories_screen.dart';
import 'forecast_screen.dart';
import 'import_screen.dart';
import 'invoices_screen.dart';
import 'loans_screen.dart';
import 'members_screen.dart';
import 'notifications_screen.dart';
import 'operations_screen.dart';
import 'security_screen.dart';

/// Signed-in shell: navigation rail on wide screens, bottom bar on phones.
class HomeScreen extends StatefulWidget {
  final SessionController session;
  const HomeScreen({super.key, required this.session});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Shows the server administration button.
  var _isServerAdmin = false;
  var _tab = 0;
  List<Account> _accounts = [];
  Account? _openAccount;
  var _imports = 0;
  var _unread = 0;
  Timer? _unreadTimer;
  final _accountsKey = GlobalKey<AccountsScreenState>();
  final _forecastKey = GlobalKey<ForecastScreenState>();
  final _categoriesKey = GlobalKey<CategoriesScreenState>();
  final _budgetKey = GlobalKey<BudgetScreenState>();
  final _loansKey = GlobalKey<LoansScreenState>();
  final _invoicesKey = GlobalKey<InvoicesScreenState>();

  /// Tabs in display order (indexes of the stack below): budget next to the
  /// operations, loans next to the forecast, then invoices.
  static const _order = [0, 1, 5, 2, 6, 7, 3, 4];

  /// Tabs of the phone's bottom bar; the others are under "More".
  static const _phoneTabs = 4;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    client.admin.isServerAdmin().then((v) {
      if (mounted && v) setState(() => _isServerAdmin = true);
    }, onError: (_) {});
    _loadUnread();
    // The server checks forecasts every hour; a light refresh of the badge.
    _unreadTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _loadUnread(),
    );
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
    super.dispose();
  }

  Future<void> _loadUnread() async {
    try {
      final n = await client.notification.unreadCount();
      if (mounted && n != _unread) setState(() => _unread = n);
    } on Object {
      // Offline or signed out: the badge keeps its last value.
    }
  }

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NotificationsScreen(
          onOpenForecast: (accountId) {
            setState(() => _tab = 2);
            _forecastKey.currentState?.showAccount(accountId);
          },
        ),
      ),
    );
    await _loadUnread();
  }

  Future<void> _loadAccounts() async {
    final g = widget.session.currentGroup;
    if (g == null) return;
    final list = await client.account.list(g.group.id!);
    if (mounted) setState(() => _accounts = list);
  }

  void _selectTab(int i) {
    setState(() => _tab = i);
    if (i == 0) _accountsKey.currentState?.reload();
    if (i == 2) _forecastKey.currentState?.reload();
    if (i == 4) _categoriesKey.currentState?.reload();
    if (i == 5) _budgetKey.currentState?.reload();
    if (i == 6) _loansKey.currentState?.reload();
    _loadAccounts();
    _loadUnread();
  }

  /// Phone: the tabs that do not fit in the bottom bar.
  Future<void> _more(
    BuildContext context,
    List<(IconData, String)> destinations,
  ) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = _phoneTabs; i < destinations.length; i++)
              ListTile(
                leading: Icon(destinations[i].$1),
                title: Text(destinations[i].$2),
                selected: _order[i] == _tab,
                onTap: () => Navigator.of(context).pop(_order[i]),
              ),
          ],
        ),
      ),
    );
    if (picked != null) _selectTab(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = widget.session;
    final current = s.currentGroup;
    final wide = MediaQuery.sizeOf(context).width >= 840;

    final tabs = [
      (Icons.account_balance_wallet_outlined, l.navAccounts),
      (Icons.receipt_long_outlined, l.navOperations),
      (Icons.show_chart, l.navForecast),
      (Icons.upload_file_outlined, l.navImport),
      (Icons.label_outline, l.navCategories),
      (Icons.pie_chart_outline, l.navBudget),
      (Icons.account_balance_outlined, l.navLoans),
      (Icons.description_outlined, l.navInvoices),
    ];
    final destinations = [for (final i in _order) tabs[i]];
    final shown = _order.indexOf(_tab);

    final Widget body = current == null
        ? _CreateGroup(session: s)
        : IndexedStack(
            index: _tab,
            children: [
              AccountsScreen(
                key: _accountsKey,
                membership: current,
                onOpen: (a) => setState(() => (_openAccount = a, _tab = 1)),
              ),
              OperationsScreen(
                key: ValueKey(
                  'ops-${current.group.id}-${_openAccount?.id}-${_accounts.length}-$_imports',
                ),
                membership: current,
                accounts: _accounts,
                initialAccount: _openAccount,
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
              ImportScreen(
                key: ValueKey('import-${current.group.id}'),
                membership: current,
                accounts: _accounts,
                onImported: () {
                  setState(() => _imports++);
                  _forecastKey.currentState?.reload();
                  _accountsKey.currentState?.reload();
                },
              ),
              CategoriesScreen(key: _categoriesKey, membership: current),
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
              InvoicesScreen(
                key: _invoicesKey,
                membership: current,
              ),
            ],
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(current?.group.name ?? l.appTitle),
        actions: [
          if (s.groups.length > 1)
            PopupMenuButton<int>(
              tooltip: l.groupLabel,
              icon: const Icon(Icons.groups_outlined),
              onSelected: (id) {
                s.selectGroup(id);
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
          // The server administrator finds members and security in the
          // administration page.
          if (current != null && !_isServerAdmin)
            IconButton(
              tooltip: l.menuMembers,
              icon: const Icon(Icons.people_outline),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => MembersScreen(membership: current),
                ),
              ),
            ),
          if (_isServerAdmin)
            IconButton(
              tooltip: l.menuAdmin,
              icon: const Icon(Icons.admin_panel_settings_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AdminScreen(membership: current),
                ),
              ),
            ),
          if (!_isServerAdmin)
            IconButton(
              tooltip: l.menuSecurity,
              icon: const Icon(Icons.shield_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SecurityScreen()),
              ),
            ),
          IconButton(
            tooltip: l.signOut,
            icon: const Icon(Icons.logout),
            onPressed: s.signOut,
          ),
        ],
      ),
      body: wide && current != null
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: shown,
                  onDestinationSelected: (i) => _selectTab(_order[i]),
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final (icon, label) in destinations)
                      NavigationRailDestination(
                        icon: Icon(icon),
                        label: Text(label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            )
          : body,
      bottomNavigationBar: wide || current == null
          ? null
          : NavigationBar(
              selectedIndex: shown < _phoneTabs ? shown : _phoneTabs,
              onDestinationSelected: (i) => i < _phoneTabs
                  ? _selectTab(_order[i])
                  : _more(context, destinations),
              destinations: [
                for (final (icon, label) in destinations.take(_phoneTabs))
                  NavigationDestination(icon: Icon(icon), label: label),
                NavigationDestination(
                  icon: const Icon(Icons.more_horiz),
                  label: shown >= _phoneTabs
                      ? destinations[shown].$2
                      : l.navMore,
                ),
              ],
            ),
    );
  }
}

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
