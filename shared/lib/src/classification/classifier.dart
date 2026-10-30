import '../labels/label_cleaner.dart';
import '../local_date.dart';
import '../text.dart';

/// Where a category comes from, shown next to each operation.
enum CategorySource { manual, groupRule, communityRule, history, ai, none }

enum MatchType {
  /// Pattern appears as whole words anywhere in the full label.
  contains,

  /// Cleaned label starts with the pattern (whole words).
  startsWith,

  /// Cleaned label is exactly the pattern.
  equals,
}

/// Restricts a rule to debits or credits.
enum Direction { any, debit, credit }

bool _directionMatches(Direction d, int amountCents) => switch (d) {
  Direction.any => true,
  Direction.debit => amountCents < 0,
  Direction.credit => amountCents > 0,
};

bool _patternMatches(MatchType type, String pattern, CleanedLabel label) =>
    switch (type) {
      MatchType.contains => containsWords(label.full, pattern),
      MatchType.startsWith => startsWithWords(label.display, pattern),
      MatchType.equals => label.display == pattern,
    };

/// A classification rule of the group.
class GroupRule<C> {
  final Object id;
  final C categoryId;
  final MatchType matchType;

  /// Normalised with [normalizeForMatch] at construction.
  final String pattern;
  final Direction direction;

  /// Optional amount bounds, in absolute cents, inclusive.
  final int? minAbsCents;
  final int? maxAbsCents;

  /// Lower runs first. Rules with the same priority: the most specific
  /// (longest pattern, with amount bounds) wins.
  final int priority;

  GroupRule({
    required this.id,
    required this.categoryId,
    required String pattern,
    this.matchType = MatchType.contains,
    this.direction = Direction.any,
    this.minAbsCents,
    this.maxAbsCents,
    this.priority = 100,
  }) : pattern = normalizeForMatch(pattern) {
    if (this.pattern.isEmpty) throw ArgumentError('Empty rule pattern');
  }

  bool matches(CleanedLabel label, int amountCents) {
    if (!_directionMatches(direction, amountCents)) return false;
    final abs = amountCents.abs();
    if (minAbsCents != null && abs < minAbsCents!) return false;
    if (maxAbsCents != null && abs > maxAbsCents!) return false;
    return _patternMatches(matchType, pattern, label);
  }

  int get _specificity =>
      pattern.length * 4 +
      (minAbsCents != null || maxAbsCents != null ? 2 : 0) +
      (direction != Direction.any ? 1 : 0);
}

/// A shared rule: pattern → standard category id (e.g. `food.groceries`).
class CommunityRule {
  final String id;
  final String pattern;
  final MatchType matchType;
  final String standardCategoryId;
  final Direction direction;

  /// 0–100, from reviews and "wrong rule" reports.
  final int confidence;

  CommunityRule({
    required this.id,
    required String pattern,
    required this.standardCategoryId,
    this.matchType = MatchType.contains,
    this.direction = Direction.any,
    this.confidence = 50,
  }) : pattern = normalizeForMatch(pattern) {
    if (this.pattern.isEmpty) throw ArgumentError('Empty rule pattern');
  }

  bool matches(CleanedLabel label, int amountCents) =>
      _directionMatches(direction, amountCents) &&
      _patternMatches(matchType, pattern, label);
}

/// An operation whose category the user set or confirmed.
class HistoryEntry<C> {
  final String labelKey;
  final int amountCents;
  final C categoryId;
  final LocalDate date;

  const HistoryEntry({
    required this.labelKey,
    required this.amountCents,
    required this.categoryId,
    required this.date,
  });
}

class Classification<C> {
  final C? categoryId;
  final CategorySource source;

  /// Group rule id, community rule id, or null.
  final Object? ruleId;

  const Classification(this.categoryId, this.source, [this.ruleId]);

  static Classification<C> none<C>() =>
      Classification<C>(null, CategorySource.none);

  bool get isClassified => categoryId != null;

  @override
  String toString() => 'Classification($categoryId, $source, $ruleId)';
}

/// Deterministic classification: group rules → community rules → history.
/// The AI (optional) only ever sees what is left unclassified.
class Classifier<C> {
  final List<GroupRule<C>> _groupRules;
  final List<CommunityRule> _communityRules;

  /// Standard category id → the group's category.
  final Map<String, C> standardToGroup;

  /// Label key + direction → category counts and latest date.
  final Map<String, Map<C, _HistoryStat>> _history = {};

  /// History needs at least this many identical choices when it is not
  /// unanimous, to avoid flip-flopping on a single correction.
  final int minHistoryOccurrences;

  Classifier({
    required List<GroupRule<C>> groupRules,
    List<CommunityRule> communityRules = const [],
    this.standardToGroup = const {},
    Iterable<HistoryEntry<C>> history = const [],
    this.minHistoryOccurrences = 1,
  }) : _groupRules = [...groupRules]..sort(_compareGroupRules),
       _communityRules = [...communityRules]..sort(_compareCommunityRules) {
    for (final h in history) {
      if (h.labelKey.length < 3) continue;
      final key = '${h.amountCents < 0 ? 'D' : 'C'}|${h.labelKey}';
      final stats = _history.putIfAbsent(key, () => {});
      final stat = stats.putIfAbsent(h.categoryId, () => _HistoryStat());
      stat.count++;
      if (stat.latest == null || h.date > stat.latest!) stat.latest = h.date;
    }
  }

  static int _compareGroupRules<C>(GroupRule<C> a, GroupRule<C> b) {
    final p = a.priority.compareTo(b.priority);
    if (p != 0) return p;
    final s = b._specificity.compareTo(a._specificity);
    if (s != 0) return s;
    return a.id.toString().compareTo(b.id.toString());
  }

  static int _compareCommunityRules(CommunityRule a, CommunityRule b) {
    final s = b.pattern.length.compareTo(a.pattern.length);
    if (s != 0) return s;
    final c = b.confidence.compareTo(a.confidence);
    if (c != 0) return c;
    return a.id.compareTo(b.id);
  }

  Classification<C> classify(CleanedLabel label, int amountCents) {
    for (final rule in _groupRules) {
      if (rule.matches(label, amountCents)) {
        return Classification(
          rule.categoryId,
          CategorySource.groupRule,
          rule.id,
        );
      }
    }
    for (final rule in _communityRules) {
      if (!rule.matches(label, amountCents)) continue;
      final category = _mapStandard(rule.standardCategoryId);
      if (category != null) {
        return Classification(
          category,
          CategorySource.communityRule,
          rule.id,
        );
      }
    }
    final fromHistory = _fromHistory(label.key, amountCents);
    if (fromHistory != null) {
      return Classification(fromHistory, CategorySource.history);
    }
    return Classification.none<C>();
  }

  /// `food.groceries` falls back to `food` when the group has no mapping for
  /// the sub-category.
  C? _mapStandard(String standardId) {
    var id = standardId;
    while (true) {
      final c = standardToGroup[id];
      if (c != null) return c;
      final dot = id.lastIndexOf('.');
      if (dot < 0) return null;
      id = id.substring(0, dot);
    }
  }

  C? _fromHistory(String labelKey, int amountCents) {
    final stats = _history['${amountCents < 0 ? 'D' : 'C'}|$labelKey'];
    if (stats == null || stats.isEmpty) return null;
    final ranked = stats.entries.toList()
      ..sort((a, b) {
        final c = b.value.count.compareTo(a.value.count);
        if (c != 0) return c;
        return b.value.latest!.compareTo(a.value.latest!);
      });
    final best = ranked.first;
    if (ranked.length > 1 && best.value.count < minHistoryOccurrences) {
      return null;
    }
    return best.key;
  }
}

class _HistoryStat {
  int count = 0;
  LocalDate? latest;
}

/// Share of operations classified without user action (decision 0014).
double automaticClassificationRate(Iterable<Classification<Object?>> results) {
  var total = 0;
  var automatic = 0;
  for (final r in results) {
    total++;
    if (r.isClassified &&
        r.source != CategorySource.manual &&
        r.source != CategorySource.ai) {
      automatic++;
    }
  }
  return total == 0 ? 0 : automatic / total;
}
