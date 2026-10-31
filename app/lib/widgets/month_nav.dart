import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../util/format.dart';

/// "‹ 27 oct. 2026 – 26 nov. 2026 ›": moves between budget months. The
/// server places [date] in its budget month (start day of the group).
class MonthNav extends StatelessWidget {
  final DateTime? start;
  final DateTime? last;
  final ValueChanged<int> onShift;

  const MonthNav({
    super.key,
    required this.start,
    required this.last,
    required this.onShift,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = start, e = last;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l.periodPrevious,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => onShift(-1),
        ),
        Text(
          s == null || e == null
              ? '…'
              : '${context.day(s)} – ${context.day(e)}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        IconButton(
          tooltip: l.periodNext,
          icon: const Icon(Icons.chevron_right),
          onPressed: () => onShift(1),
        ),
      ],
    );
  }
}

/// A day in the budget month [months] away from the one starting at
/// [start] (the 15th of its first month is always inside it).
DateTime shiftBudgetMonth(DateTime start, int months) =>
    DateTime.utc(start.year, start.month + months, start.day + 14);
