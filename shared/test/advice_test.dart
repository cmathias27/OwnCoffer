import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  test('a goal is suggested for a category spent on every month', () {
    final a = adviseGoals({
      1: [0, 21000, 19000, 23000],
      2: [5000, 0, 6000],
      3: [1000, 1200, 900],
    }, {});
    expect(a, hasLength(1), reason: 'a month without spending; too small');
    expect(a.single.kind, GoalAdviceKind.suggest);
    expect(a.single.categoryId, 1);
    expect(a.single.currentCents, isNull);
    expect(a.single.proposedCents, 21000, reason: 'average rounded up');
    expect(a.single.monthsCents, [21000, 19000, 23000]);
  });

  test('raised when exceeded twice, lowered when far below', () {
    final a = adviseGoals(
      {
        1: [26000, 24000, 18000],
        2: [4000, 3500, 4200],
        3: [21000, 19000, 20000],
      },
      {1: 20000, 2: 10000, 3: 20000},
    );
    expect(a.map((x) => (x.categoryId, x.kind, x.proposedCents)), [
      (1, GoalAdviceKind.raise, 23000),
      (2, GoalAdviceKind.lower, 4000),
    ], reason: 'category 3 sits around its goal: nothing to say');
  });

  test('nothing without three months', () {
    expect(
      adviseGoals({
        1: [10000, 10000],
      }, {}),
      isEmpty,
    );
  });
}
