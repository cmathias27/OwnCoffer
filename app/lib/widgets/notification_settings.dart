import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';

/// The user's choices about alerts: which ones, and which also by email.
/// Saved at each change.
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  NotificationSettings? _s;
  String? _error;

  @override
  void initState() {
    super.initState();
    client.notification.settings().then(
      (s) => mounted ? setState(() => _s = s) : null,
      onError: (Object e) => mounted
          ? setState(() => _error = errorText(AppLocalizations.of(context), e))
          : null,
    );
  }

  Future<void> _save(NotificationSettings next) async {
    final l = AppLocalizations.of(context);
    final before = _s;
    setState(() => _s = next);
    try {
      final saved = await client.notification.saveSettings(next);
      if (mounted) setState(() => _s = saved);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _s = before);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = _s;
    Widget title(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
      child: Text(
        t,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
    Widget toggle(
      String label,
      bool value,
      NotificationSettings Function(bool) change, {
      String? help,
      bool enabled = true,
    }) => SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: help == null ? null : Text(help),
      value: value,
      onChanged: enabled ? (v) => _save(change(v)) : null,
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.notifSettingsTitle)),
      body: _error != null
          ? Center(child: Text(_error!))
          : s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(l.notifSettingsIntro),
                        title(l.notifSettingsOverdraft),
                        toggle(
                          l.notifSettingsInApp,
                          s.overdraftApp,
                          (v) => s.copyWith(
                            overdraftApp: v,
                            overdraftEmail: v && s.overdraftEmail,
                          ),
                          help: l.notifSettingsOverdraftHelp,
                        ),
                        toggle(
                          l.notifSettingsByEmail,
                          s.overdraftEmail,
                          (v) => s.copyWith(overdraftEmail: v),
                          enabled: s.overdraftApp,
                        ),
                        title(l.notifSettingsGoals),
                        toggle(
                          l.notifSettingsGoalWarning,
                          s.goalWarning,
                          (v) => s.copyWith(goalWarning: v),
                        ),
                        toggle(
                          l.notifSettingsGoalOver,
                          s.goalOver,
                          (v) => s.copyWith(goalOver: v),
                        ),
                        toggle(
                          l.notifSettingsGoalForecast,
                          s.goalForecast,
                          (v) => s.copyWith(goalForecast: v),
                          help: l.notifSettingsGoalForecastHelp,
                        ),
                        title(l.notifSettingsWarranty),
                        toggle(
                          l.notifSettingsInApp,
                          s.warrantyApp,
                          (v) => s.copyWith(
                            warrantyApp: v,
                            warrantyEmail: v && s.warrantyEmail,
                          ),
                          help: l.notifSettingsWarrantyHelp,
                        ),
                        toggle(
                          l.notifSettingsByEmail,
                          s.warrantyEmail,
                          (v) => s.copyWith(warrantyEmail: v),
                          enabled: s.warrantyApp,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l.notifSettingsEmailNote,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
