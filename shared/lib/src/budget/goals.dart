/// Monthly spending goals per category (cahier des charges : objectifs par
/// catégorie, jauge verte, orange puis rouge).
library;

import '../local_date.dart';

enum GoalLevel {
  /// Under 80 % of the goal.
  ok,

  /// From 80 % to 100 %.
  warning,

  /// Over the goal.
  over,
}

GoalLevel goalLevel(int spentCents, int goalCents) {
  if (goalCents <= 0) return GoalLevel.over;
  if (spentCents > goalCents) return GoalLevel.over;
  if (spentCents * 100 >= goalCents * 80) return GoalLevel.warning;
  return GoalLevel.ok;
}

/// A realistic goal from the previous months' spending: their average,
/// rounded up to the next 10 €. Null without history or without spending.
int? suggestedGoal(List<int> previousMonthsCents) {
  if (previousMonthsCents.isEmpty) return null;
  final total = previousMonthsCents.fold(0, (a, b) => a + b);
  if (total <= 0) return null;
  final n = previousMonthsCents.length;
  final average = (total + n - 1) ~/ n;
  return (average + 999) ~/ 1000 * 1000;
}

/// Where the spending of a goal's category should end the period.
class GoalProjection {
  /// Spending expected at the end of the period.
  final int projectedCents;

  /// First day the spending is expected to go over the goal; null when it
  /// should not, or when it already has.
  final LocalDate? overDate;

  /// The current pace was counted (enough days passed); otherwise only the
  /// planned operations were.
  final bool fromPace;

  const GoalProjection(this.projectedCents, this.overDate, this.fromPace);

  int overByCents(int goalCents) => projectedCents - goalCents;
}

/// Projects the spending of a category to the end of the period
/// [start] – [end] (exclusive): what was spent, plus the planned operations
/// still expected ([plannedCents], by day, spending flows), plus the current
/// pace of the other spending ([variableSpentCents] since [start]) for each
/// day left. The pace is used once [minDays] days have passed, so a single
/// large purchase at the start of the month is not multiplied.
GoalProjection projectGoal({
  required int spentCents,
  required int variableSpentCents,
  required int goalCents,
  required LocalDate start,
  required LocalDate end,
  required LocalDate today,
  Map<LocalDate, int> plannedCents = const {},
  int minDays = 7,
}) {
  if (today < start || today >= end) {
    return GoalProjection(spentCents, null, false);
  }
  final elapsed = start.daysUntil(today) + 1;
  final usePace = elapsed >= minDays && variableSpentCents > 0;
  // Planned operations already late are still expected: counted today.
  int plannedOn(LocalDate day) => day == today
      ? plannedCents.entries
            .where((e) => e.key <= today)
            .fold(0, (a, e) => a + e.value)
      : plannedCents[day] ?? 0;
  var planned = 0;
  LocalDate? overDate;
  var projected = spentCents;
  for (var day = today, k = 0; day < end; day = day.addDays(1), k++) {
    planned += plannedOn(day);
    final pace = usePace ? variableSpentCents * k ~/ elapsed : 0;
    projected = spentCents + planned + pace;
    if (overDate == null && spentCents <= goalCents && projected > goalCents) {
      overDate = day;
    }
  }
  return GoalProjection(projected, overDate, usePace);
}
