import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  test('challenges: distinct codes, positive targets, found by code', () {
    final codes = {for (final c in pepiteChallenges) c.code};
    expect(codes, hasLength(pepiteChallenges.length));
    for (final c in pepiteChallenges) {
      expect(c.target, greaterThan(0));
      expect(pepiteChallengeByCode(c.code), same(c));
    }
    expect(pepiteChallengeByCode('nope'), isNull);
    expect(pepiteChallengeSeeds, 10);
  });

  test('the month of a day', () {
    expect(pepiteChallengeMonth(DateTime.utc(2026, 11, 30)), '2026-11');
    expect(pepiteChallengeMonth(DateTime.utc(2027, 1, 1)), '2027-01');
  });
}
