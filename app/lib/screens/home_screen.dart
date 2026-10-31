import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../state/session.dart';
import 'accounts_screen.dart';
import 'import_screen.dart';
import 'members_screen.dart';
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
  var _tab = 0;
  List<Account> _accounts = [];
  Account? _openAccount;
  var _imports = 0;
  final _accountsKey = GlobalKey<AccountsScreenState>();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
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

  Future<void> _loadAccounts() async {
    final g = widget.session.currentGroup;
    if (g == null) return;
    final list = await client.account.list(g.group.id!);
    if (mounted) setState(() => _accounts = list);
  }

  void _selectTab(int i) {
    setState(() => _tab = i);
    if (i == 0) _accountsKey.currentState?.reload();
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = widget.session;
    final current = s.currentGroup;
    final wide = MediaQuery.sizeOf(context).width >= 840;

    final destinations = [
      (Icons.account_balance_wallet_outlined, l.navAccounts),
      (Icons.receipt_long_outlined, l.navOperations),
      (Icons.upload_file_outlined, l.navImport),
    ];

    final Widget body = current == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l.homeNoGroup, textAlign: TextAlign.center),
            ),
          )
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
              ImportScreen(
                key: ValueKey('import-${current.group.id}'),
                membership: current,
                accounts: _accounts,
                onImported: () {
                  setState(() => _imports++);
                  _accountsKey.currentState?.reload();
                },
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
          if (current != null)
            IconButton(
              tooltip: l.menuMembers,
              icon: const Icon(Icons.people_outline),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => MembersScreen(membership: current),
                ),
              ),
            ),
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
                  selectedIndex: _tab,
                  onDestinationSelected: _selectTab,
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
              selectedIndex: _tab,
              onDestinationSelected: _selectTab,
              destinations: [
                for (final (icon, label) in destinations)
                  NavigationDestination(icon: Icon(icon), label: label),
              ],
            ),
    );
  }
}
