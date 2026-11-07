import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../state/pepite.dart';
import '../state/pepite_advice.dart';
import '../state/pepite_messages.dart';
import '../widgets/pepite.dart';

/// Pépite's page: the reserve, the badges, how it works, and the settings
/// of this device (shown or hidden, the weekly reminder).
class PepiteScreen extends StatefulWidget {
  /// Opens « Bien démarrer » (with a group open).
  final VoidCallback? onStart;

  final Pepite? controller;

  const PepiteScreen({super.key, this.onStart, this.controller});

  @override
  State<PepiteScreen> createState() => _PepiteScreenState();
}

class _PepiteScreenState extends State<PepiteScreen> {
  String? _message;

  Pepite get _pepite => widget.controller ?? pepite;

  @override
  void initState() {
    super.initState();
    _pepite.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.pepiteMenu)),
      body: ListenableBuilder(
        listenable: Listenable.merge([_pepite, pepiteAdvice]),
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ..._reserve(context, l),
            if (widget.onStart != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.checklist),
                title: Text(l.startTitle),
                subtitle: Text(l.startIntro),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onStart!();
                },
              ),
            const Divider(height: 40),
            ..._settings(context, l),
          ],
        ),
      ),
    );
  }

  List<Widget> _reserve(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context);
    final s = _pepite.status;
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
    final hint = pepiteBadgeHint(l, code);
    final icon = pepiteBadgeIcon(code);
    return Tooltip(
      message: earned ? help : (hint != null ? '$help\n\n💡 $hint' : help),
      child: SizedBox(
        width: 156,
        child: Card(
          color: earned
              ? const Color(0xFFE9A04B).withValues(alpha: 0.18)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Icon(
                  earned ? Icons.emoji_events : icon,
                  color: earned
                      ? const Color(0xFFC97F2E)
                      : scheme.outline.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: earned ? FontWeight.w600 : FontWeight.normal,
                    color: earned ? null : scheme.onSurfaceVariant,
                  ),
                ),
                if (!earned) ...[
                  const SizedBox(height: 2),
                  Text(
                    hint ?? l.pepiteBadgeLocked,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: scheme.outline,
                    ),
                  ),
                ],
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
        value: _pepite.enabled,
        onChanged: _pepite.setEnabled,
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l.pepiteTipsSetting),
        subtitle: Text(l.pepiteTipsSettingHelp),
        value: pepiteAdvice.tipsOn,
        onChanged: pepiteAdvice.setTipsOn,
      ),
      if (!_pepite.reminders.supported)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(l.pepiteReminderWeb),
        )
      else ...[
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.pepiteReminder),
          subtitle: Text(l.pepiteReminderHelp),
          value: _pepite.reminderOn,
          onChanged: _pepite.enabled
              ? (v) async {
                  final ok = await _pepite.setReminder(v);
                  if (!mounted) return;
                  setState(() => _message = ok ? null : l.pepiteReminderDenied);
                }
              : null,
        ),
        if (_message != null)
          Text(_message!, style: TextStyle(color: theme.colorScheme.error)),
        if (_pepite.reminderOn)
          Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l.pepiteReminderDay),
              DropdownButton<int>(
                value: _pepite.reminderDay,
                items: [
                  for (var d = 1; d <= 7; d++)
                    DropdownMenuItem(value: d, child: Text(dayName(d))),
                ],
                onChanged: (d) => _pepite.setReminderTime(day: d),
              ),
              Text(l.pepiteReminderHour),
              DropdownButton<int>(
                value: _pepite.reminderHour,
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
                onChanged: (h) => _pepite.setReminderTime(hour: h),
              ),
            ],
          ),
      ],
    ];
  }
}
