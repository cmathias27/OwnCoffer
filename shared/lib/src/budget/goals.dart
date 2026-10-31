/// Monthly spending goals per category (cahier des charges : objectifs par
/// catégorie, jauge verte, orange puis rouge).
library;

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
