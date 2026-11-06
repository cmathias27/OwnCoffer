import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../state/pepite.dart';
import '../state/pepite_messages.dart';
import '../widgets/pepite.dart';

/// Pépite's page: the reserve, the badges, how it works, and the settings
/// of this device (shown or hidden, the weekly reminder).
class PepiteScreen extends StatefulWidget {
  const PepiteScreen({super.key});

  @override
  State<PepiteScreen> createState() => _PepiteScreenState();
}

class _PepiteScreenState extends State<PepiteScreen> {
  String? _message;

  @override
  void initState() {
    super.initState();
    pepite.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.pepiteMenu)),
      body: ListenableBuilder(
        listenable: pepite,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ..._reserve(context, l),
            const Divider(height: 40),
            ..._settings(context, l),
          ],
        ),
      ),
    );
  }

  List<Widget> _reserve(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context);
    final s = pepite.status;
    if (s == null) return const [];
    final earned = {...s.badges};
    return [
      Center(
        child: PepiteImage(
          s.doneThisWeek ? PepitePose.cheer : PepitePose.happy,
          size: 140,
        ),
      ),
      const SizedBox(height: 8),
      Center(child: PepiteSeeds(s.seeds)),
      const SizedBox(height: 4),
      Center(child: Text(l.pepiteWeeks(s.weeks))),
      const SizedBox(height: 24),
      Text(l.pepiteBadgesTitle, style: theme.textTheme.titleMedium),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final code in pepiteBadges)
            _badge(context, l, code, earned.contains(code)),
        ],
      ),
      const SizedBox(height: 24),
      Text(l.pepiteHowTitle, style: theme.textTheme.titleMedium),
      const SizedBox(height: 8),
      Text(l.pepiteHow(pepiteRitualSeeds, pepiteBadgeSeeds)),
    ];
  }

  Widget _badge(
    BuildContext context,
    AppLocalizations l,
    String code,
    bool earned,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final (name, help) = pepiteBadgeText(l, code);
    return Tooltip(
      message: help,
      child: SizedBox(
        width: 150,
        child: Card(
          color: earned
              ? const Color(0xFFE9A04B).withValues(alpha: 0.18)
              : scheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Icon(
                  earned ? Icons.emoji_events : Icons.lock_outline,
                  color: earned ? const Color(0xFFC97F2E) : scheme.outline,
                ),
                const SizedBox(height: 4),
                Text(name, textAlign: TextAlign.center),
                if (!earned)
                  Text(
                    l.pepiteBadgeLocked,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _settings(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final material = MaterialLocalizations.of(context);
    // 2024-01-01 was a Monday.
    String dayName(int day) =>
        DateFormat.EEEE(locale).format(DateTime(2024, 1, day));
    return [
      Text(l.pepiteSettingsTitle, style: theme.textTheme.titleMedium),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l.pepiteEnable),
        subtitle: Text(l.pepiteEnableHelp),
        value: pepite.enabled,
        onChanged: pepite.setEnabled,
      ),
      if (!pepite.reminders.supported)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(l.pepiteReminderWeb),
        )
      else ...[
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.pepiteReminder),
          subtitle: Text(l.pepiteReminderHelp),
          value: pepite.reminderOn,
          onChanged: pepite.enabled
              ? (v) async {
                  final ok = await pepite.setReminder(v);
                  if (!mounted) return;
                  setState(() => _message = ok ? null : l.pepiteReminderDenied);
                }
              : null,
        ),
        if (_message != null)
          Text(_message!, style: TextStyle(color: theme.colorScheme.error)),
        if (pepite.reminderOn)
          Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l.pepiteReminderDay),
              DropdownButton<int>(
                value: pepite.reminderDay,
                items: [
                  for (var d = 1; d <= 7; d++)
                    DropdownMenuItem(value: d, child: Text(dayName(d))),
                ],
                onChanged: (d) => pepite.setReminderTime(day: d),
              ),
              Text(l.pepiteReminderHour),
              DropdownButton<int>(
                value: pepite.reminderHour,
                items: [
                  for (var h = 0; h < 24; h++)
                    DropdownMenuItem(
                      value: h,
                      child: Text(
                        material.formatTimeOfDay(
                          TimeOfDay(hour: h, minute: 0),
                          alwaysUse24HourFormat: true,
                        ),
                      ),
                    ),
                ],
                onChanged: (h) => pepite.setReminderTime(hour: h),
              ),
            ],
          ),
      ],
    ];
  }
}
