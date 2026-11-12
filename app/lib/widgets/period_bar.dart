import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../state/ui_prefs.dart';

/// The budget period and a day inside it for a shared period (decision
/// 0041, point 8); the server finds the bounds from the household's first
/// day of the month.
(BudgetPeriod, DateTime) sharedPeriodRange(SharedPeriod p, DateTime today) =>
    switch (p) {
      SharedPeriod.thisMonth => (BudgetPeriod.month, today),
      // The same day one month earlier falls in the previous period,
      // whatever the first day of the household's month.
      SharedPeriod.lastMonth => (
        BudgetPeriod.month,
        DateTime.utc(today.year, today.month - 1, today.day.clamp(1, 28)),
      ),
      SharedPeriod.thisYear => (BudgetPeriod.year, today),
    };

/// « Ce mois · Mois précédent · Cette année », the same on every screen
/// that shows a period, and kept on the device. [selected] is null when the
/// screen shows another period (chosen with its own controls).
class PeriodBar extends StatelessWidget {
  final SharedPeriod? selected;
  final ValueChanged<SharedPeriod> onChanged;

  const PeriodBar({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SegmentedButton<SharedPeriod>(
      key: const Key('period-bar'),
      segments: [
        ButtonSegment(
          value: SharedPeriod.thisMonth,
          label: Text(l.periodThisMonth),
        ),
        ButtonSegment(
          value: SharedPeriod.lastMonth,
          label: Text(l.periodLastMonth),
        ),
        ButtonSegment(
          value: SharedPeriod.thisYear,
          label: Text(l.periodThisYear),
        ),
      ],
      selected: {?selected},
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      onSelectionChanged: (s) {
        if (s.isEmpty) return;
        uiPrefs.setPeriod(s.single);
        onChanged(s.single);
      },
    );
  }
}
