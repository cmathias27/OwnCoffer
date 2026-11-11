/// Pépite's monthly challenges (decision 0028, point 8; decision 0030).
///
/// Optional: the user picks one for the month from this fixed list. Each
/// is measured from their own doings since they chose it, never from an
/// amount, so none is about spending (and all can be offered when an
/// account is overdrawn). Done: [pepiteChallengeSeeds] seeds, once a month.
/// Failed or dropped: nothing is lost.
library;

/// A challenge of the list: [code] names it, [target] is how many times.
class PepiteChallenge {
  final String code;
  final int target;

  const PepiteChallenge(this.code, this.target);
}

/// Seeds for a challenge done.
const pepiteChallengeSeeds = 10;

/// The challenges offered every month.
const pepiteChallenges = [
  // Classify 20 operations by hand.
  PepiteChallenge('classify_20', 20),
  // Attach 5 invoices or receipts to their operations.
  PepiteChallenge('invoices_5', 5),
  // Create 3 classification rules.
  PepiteChallenge('rules_3', 3),
  // Declare 2 subscriptions.
  PepiteChallenge('subscriptions_2', 2),
  // Set a budget goal.
  PepiteChallenge('goal_1', 1),
];

PepiteChallenge? pepiteChallengeByCode(String code) {
  for (final c in pepiteChallenges) {
    if (c.code == code) return c;
  }
  return null;
}

/// The month of [day], as the key of its challenge: `2026-11`.
String pepiteChallengeMonth(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}';
