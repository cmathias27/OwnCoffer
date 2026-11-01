import 'goals.dart';

/// What the advisor may propose about a monthly goal.
enum GoalAdviceKind {
  /// A category spent on every month has no goal yet.
  suggest,

  /// The goal was exceeded in at least two of the last three months.
  raise,

  /// Spending stayed under half the goal three months in a row.
  lower,
}

/// One piece of advice on a goal, with the figures it rests on.
class GoalAdvice {
  final GoalAdviceKind kind;
  final int categoryId;

  /// The goal now (null: none) and the one proposed.
  final int? currentCents;
  final int proposedCents;

  /// Spending of the months considered, oldest first.
  final List<int> monthsCents;

  const GoalAdvice({
    required this.kind,
    required this.categoryId,
    required this.currentCents,
    required this.proposedCents,
    required this.monthsCents,
  });
}

/// Below this, a goal is not worth proposing (30 €).
const minAdvisedGoalCents = 3000;

/// Advice on the monthly goals from the spending of the last complete
/// months ([months]: category id → spending, oldest first, at least three
/// values each) and the goals set ([goals]: category id → amount). Only the
/// categories in [months] are considered (the caller picks top-level
/// expense categories). The proposed amount is always core.suggestedGoal
/// (average rounded up to the next 10 €). Largest proposal first.
List<GoalAdvice> adviseGoals(
  Map<int, List<int>> months,
  Map<int, int> goals,
) {
  final advice = <GoalAdvice>[];
  for (final MapEntry(key: id, value: spent) in months.entries) {
    if (spent.length < 3) continue;
    final last = spent.sublist(spent.length - 3);
    // The amount from up to six months (steadier), the decision on the
    // last three.
    // Empty months before the first spending (history not imported yet,
    // category not used) would only lower it.
    var basis = spent.sublist(spent.length > 6 ? spent.length - 6 : 0);
    final firstSpent = basis.indexWhere((c) => c > 0);
    if (firstSpent > 0 && basis.length - firstSpent >= 3) {
      basis = basis.sublist(firstSpent);
    }
    final proposed = suggestedGoal(basis);
    if (proposed == null) continue;
    final goal = goals[id];
    GoalAdviceKind? kind;
    if (goal == null) {
      if (last.every((c) => c > 0) && proposed >= minAdvisedGoalCents) {
        kind = GoalAdviceKind.suggest;
      }
    } else if (last.where((c) => c > goal).length >= 2 && proposed > goal) {
      kind = GoalAdviceKind.raise;
    } else if (last.every((c) => c * 2 < goal) &&
        proposed < goal &&
        proposed >= minAdvisedGoalCents) {
      kind = GoalAdviceKind.lower;
    }
    if (kind == null) continue;
    advice.add(
      GoalAdvice(
        kind: kind,
        categoryId: id,
        currentCents: goal,
        proposedCents: proposed,
        monthsCents: basis,
      ),
    );
  }
  advice.sort((a, b) {
    final c = b.proposedCents.compareTo(a.proposedCents);
    return c != 0 ? c : a.categoryId.compareTo(b.categoryId);
  });
  return advice;
}
