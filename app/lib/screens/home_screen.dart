import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../state/session.dart';
import 'members_screen.dart';
import 'security_screen.dart';

/// Shell of the app once signed in: group selector and menu. The accounts
/// and operations screens come with phase 3.
class HomeScreen extends StatefulWidget {
  final SessionController session;
  const HomeScreen({super.key, required this.session});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = widget.session;
    final current = s.currentGroup;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          if (s.groups.length > 1)
            PopupMenuButton<int>(
              tooltip: l.groupLabel,
              icon: const Icon(Icons.groups_outlined),
              onSelected: s.selectGroup,
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (current != null)
                Text(
                  current.group.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              const SizedBox(height: 12),
              Text(
                current == null ? l.homeNoGroup : l.accountsComingSoon,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
