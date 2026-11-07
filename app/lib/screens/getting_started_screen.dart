import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../state/getting_started.dart';
import '../state/start_device.dart';
export '../state/start_device.dart' show startDevice;
import '../util/app_versions.dart';
import 'admin_screen.dart';
import 'apps_screen.dart';
import 'device_backup_screen.dart';
import 'members_screen.dart';
import 'pepite_screen.dart';
import 'security_screen.dart';

/// The steps that lead to a tab of the home page; the others open their
/// own page on top of this one.
const startTabSteps = {'account', 'rules', 'scheduled', 'goal'};

/// The label of a step.
String startStepLabel(AppLocalizations l, String code) => switch (code) {
  'account' => l.startStepAccount,
  'rules' => l.startStepRules,
  'scheduled' => l.startStepScheduled,
  'goal' => l.startStepGoal,
  'two_factor' => l.startStepTwoFactor,
  'device_unlock' => l.startStepDeviceUnlock,
  'backup' => l.startStepBackup,
  'app' => l.startStepApp,
  'reminder' => l.startStepReminder,
  'members' => l.startStepMembers,
  'backups' => l.startAdminBackups,
  'restore_test' => l.startAdminRestoreTest,
  'auto_update' => l.startAdminAutoUpdate,
  'invitations' => l.startAdminInvitations,
  'ai' => l.startAdminAi,
  'proxy' => l.startAdminProxy,
  _ => code,
};

String? _stepHelp(AppLocalizations l, String code) => switch (code) {
  'rules' => l.startStepRulesHelp,
  'ai' => l.startAdminAiHelp,
  'proxy' => l.startAdminProxyHelp,
  _ => null,
};

/// « Bien démarrer » (decision 0028, point 12): the setup of the app, each
/// step ticked from the data and leading to its page by « Ouvrir »; the
/// server's own list apart, for its administrator. About the app, never
/// about money.
class GettingStartedScreen extends StatefulWidget {
  final GroupMembership membership;

  /// Opens the tab of a step of [startTabSteps] (this page is closed first).
  final void Function(String code) onTab;

  /// Tests give their own; the server's and the device's otherwise.
  final Future<PepiteStart> Function(int groupId)? load;
  final Future<StartDevice> Function()? device;

  const GettingStartedScreen({
    super.key,
    required this.membership,
    required this.onTab,
    this.load,
    this.device,
  });

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  Future<(List<StartStep>, List<StartStep>)>? _steps;

  @override
  void initState() {
    super.initState();
    _steps = _fetch();
  }

  void _reload() {
    final steps = _fetch();
    setState(() => _steps = steps);
  }

  Future<(List<StartStep>, List<StartStep>)> _fetch() async {
    final groupId = widget.membership.group.id!;
    final server = await (widget.load ?? client.pepiteAdvice.start)(groupId);
    final device = await (widget.device ?? startDevice)();
    return (startSteps(server, device), adminSteps(server));
  }

  Future<void> _open(String code) async {
    if (startTabSteps.contains(code)) {
      Navigator.of(context).pop();
      widget.onTab(code);
      return;
    }
    final Widget page = switch (code) {
      'two_factor' || 'device_unlock' => const SecurityScreen(),
      'backup' => const DeviceBackupScreen(),
      'app' => AppsScreen(serverVersion: AppVersions.server, why: true),
      'reminder' => const PepiteScreen(),
      'members' => MembersScreen(membership: widget.membership),
      'proxy' => const HelpPage(topic: HelpTopic.admin),
      _ => AdminScreen(
        membership: widget.membership,
        tab: switch (code) {
          'auto_update' => AdminTab.updates,
          'backups' || 'restore_test' => AdminTab.backups,
          'ai' => AdminTab.ai,
          'invitations' => AdminTab.invitations,
          _ => AdminTab.health,
        },
      ),
    };
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => page));
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.startTitle)),
      body: FutureBuilder(
        future: _steps,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l.error_generic, textAlign: TextAlign.center),
              ),
            );
          }
          final data = snap.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final (steps, admin) = data;
          final done = steps.where((s) => s.done).length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              Text(l.startIntro, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 16),
              _Progress(done: done, total: steps.length),
              const SizedBox(height: 8),
              for (final s in steps) _row(context, s),
              if (admin.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  l.startAdminTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                _Progress(
                  done: admin.where((s) => s.done).length,
                  total: admin.length,
                ),
                const SizedBox(height: 8),
                for (final s in admin) _row(context, s),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _row(BuildContext context, StartStep s) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final help = _stepHelp(l, s.code);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        s.done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: s.done ? scheme.primary : scheme.outline,
      ),
      title: Text(startStepLabel(l, s.code)),
      subtitle: help == null ? null : Text(help),
      trailing: s.done
          ? null
          : TextButton(
              onPressed: () => _open(s.code),
              child: Text(l.startOpen),
            ),
    );
  }
}

class _Progress extends StatelessWidget {
  final int done;
  final int total;

  const _Progress({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          done == total && total > 0
              ? l.startAllDone
              : l.startProgress(done, total),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: total == 0 ? 0 : done / total),
      ],
    );
  }
}
