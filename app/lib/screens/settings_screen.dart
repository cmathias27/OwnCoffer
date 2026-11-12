import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../assistant/chat_controller.dart';
import '../client.dart';
import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../navigation/sections.dart';
import '../state/app_lock.dart';
import '../state/session.dart';
import '../state/ui_prefs.dart';
import '../widgets/notification_settings.dart';
import '../widgets/soft.dart';
import 'admin_screen.dart';
import 'apps_screen.dart';
import 'assistant_screen.dart';
import 'categories_screen.dart';
import 'export_screen.dart';
import 'members_screen.dart';
import 'outbox_screen.dart';
import 'pepite_screen.dart';
import 'security_screen.dart';

/// « Réglages » (decision 0041, point 2): the screens one opens rarely,
/// gathered in one place so that the top bar keeps only the household,
/// the bell, the search and this page.
class SettingsScreen extends StatelessWidget {
  final SessionController session;
  final GroupMembership? membership;
  final bool isServerAdmin;
  final VoidCallback? onStart;
  final VoidCallback onFeedback;
  final VoidCallback onShortcuts;

  /// Categories or rules changed: the other pages reload.
  final VoidCallback? onCategoriesChanged;

  const SettingsScreen({
    super.key,
    required this.session,
    required this.membership,
    required this.isServerAdmin,
    required this.onFeedback,
    required this.onShortcuts,
    this.onStart,
    this.onCategoriesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final current = membership;
    Future<void> open(Widget page) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => page));
    Widget tile(
      Key key,
      IconData icon,
      String title,
      VoidCallback onTap, {
      String? subtitle,
    }) => ListTile(
      key: key,
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListenableBuilder(
        listenable: uiPrefs,
        builder: (context, _) {
          final simple = uiPrefs.simpleMode;
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SoftSection(
                        icon: Icons.text_fields,
                        title: l.settingsDisplay,
                        children: [
                          SwitchListTile(
                            key: const Key('setting-simple'),
                            contentPadding: EdgeInsets.zero,
                            title: Text(l.settingsSimpleMode),
                            subtitle: Text(l.settingsSimpleModeHelp),
                            value: simple,
                            onChanged: uiPrefs.setSimpleMode,
                          ),
                          SwitchListTile(
                            key: const Key('setting-large-text'),
                            contentPadding: EdgeInsets.zero,
                            title: Text(l.settingsLargeText),
                            value: uiPrefs.largeText,
                            onChanged: uiPrefs.setLargeText,
                          ),
                          SwitchListTile(
                            key: const Key('setting-contrast'),
                            contentPadding: EdgeInsets.zero,
                            title: Text(l.settingsHighContrast),
                            value: uiPrefs.highContrast,
                            onChanged: uiPrefs.setHighContrast,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (current != null) ...[
                        SoftSection(
                          icon: Icons.groups_outlined,
                          title: l.settingsHousehold,
                          children: [
                            tile(
                              const Key('setting-categories'),
                              Icons.label_outline,
                              simple ? l.navCategories : l.settingsCategories,
                              () async {
                                await open(
                                  _SettingsPage(
                                    title: simple
                                        ? l.navCategories
                                        : l.settingsCategories,
                                    child: CategoriesScreen(
                                      membership: current,
                                    ),
                                  ),
                                );
                                onCategoriesChanged?.call();
                              },
                            ),
                            if (!isServerAdmin)
                              tile(
                                const Key('setting-members'),
                                Icons.people_outline,
                                l.menuMembers,
                                () => open(MembersScreen(membership: current)),
                              ),
                            tile(
                              const Key('setting-export'),
                              Icons.download_outlined,
                              l.exportTitle,
                              () => open(
                                ExportScreen(
                                  membership: current,
                                  canImport: isServerAdmin,
                                  onImported: session.reloadGroups,
                                ),
                              ),
                            ),
                            if (onStart != null)
                              tile(
                                const Key('setting-start'),
                                Icons.flag_outlined,
                                l.startTitle,
                                onStart!,
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      SoftSection(
                        icon: Icons.person_outline,
                        title: l.menuAccount,
                        children: [
                          // The server administrator finds security in the
                          // administration page.
                          if (!isServerAdmin)
                            tile(
                              const Key('setting-security'),
                              Icons.shield_outlined,
                              l.menuSecurity,
                              () => open(const SecurityScreen()),
                            ),
                          tile(
                            const Key('setting-notifications'),
                            Icons.notifications_none,
                            l.notifSettingsTitle,
                            () => open(const NotificationSettingsScreen()),
                          ),
                          if (current != null)
                            tile(
                              const Key('setting-assistant'),
                              Icons.auto_awesome_outlined,
                              l.assistantSettingsTitle,
                              () async {
                                await open(
                                  AssistantScreen(membership: current),
                                );
                                await chat.refreshStatus();
                              },
                            ),
                          tile(
                            const Key('setting-pepite'),
                            Icons.pets_outlined,
                            l.pepiteMenu,
                            () => open(PepiteScreen(onStart: onStart)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SoftSection(
                        icon: Icons.apps_outlined,
                        title: l.settingsApp,
                        children: [
                          tile(
                            const Key('setting-apps'),
                            Icons.devices_outlined,
                            l.appsTitle,
                            () => open(
                              AppsScreen(serverVersion: session.serverVersion),
                            ),
                          ),
                          tile(
                            const Key('setting-help'),
                            Icons.help_outline,
                            l.helpTitle,
                            () => open(const HelpScreen()),
                          ),
                          tile(
                            const Key('setting-shortcuts'),
                            Icons.keyboard_outlined,
                            l.shortcutsTitle,
                            onShortcuts,
                          ),
                          tile(
                            const Key('setting-feedback'),
                            Icons.feedback_outlined,
                            l.feedbackTitle,
                            onFeedback,
                          ),
                          if (isServerAdmin && !simple)
                            tile(
                              const Key('setting-admin'),
                              Icons.admin_panel_settings_outlined,
                              l.menuAdmin,
                              () => open(AdminScreen(membership: current)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListenableBuilder(
                        listenable: appLock,
                        builder: (context, _) => Column(
                          children: [
                            if (appLock.enabled)
                              ListTile(
                                leading: const Icon(Icons.lock_outline),
                                title: Text(l.lockNow),
                                onTap: appLock.lockNow,
                              ),
                            // Standalone: no password to sign in again; the
                            // data stays on the device.
                            ListTile(
                              key: const Key('setting-sign-out'),
                              leading: Icon(
                                isStandalone ? Icons.swap_horiz : Icons.logout,
                              ),
                              title: Text(
                                isStandalone
                                    ? l.standaloneChangeMode
                                    : l.signOut,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                if (isStandalone) {
                                  changeServer();
                                } else {
                                  signOutAfterOutbox(context, session.signOut);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A page opened from the settings, under « Réglages › … ».
class _SettingsPage extends StatelessWidget {
  final String title;
  final Widget child;
  const _SettingsPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TrailTitle(
        trail: [AppLocalizations.of(context).settingsTitle],
        title: title,
      ),
    ),
    body: child,
  );
}
