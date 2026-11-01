/// One part of a whole: a category ([id]) or, when [id] is null, every
/// smaller one put together ("Others").
typedef Share = ({int? id, int cents});

/// The positive [amounts] largest first, for a pie: at most [max] parts,
/// the smallest ones merged into a last "Others" part when there are more.
/// Ties keep the smaller id first, so the order never flickers.
List<Share> sharesWithOthers(Map<int, int> amounts, {int max = 8}) {
  if (max < 2) throw ArgumentError.value(max, 'max');
  final parts = [
    for (final e in amounts.entries)
      if (e.value > 0) (id: e.key, cents: e.value),
  ]..sort(_largestFirst);
  if (parts.length <= max) return parts;
  final rest = parts.skip(max - 1).fold(0, (a, p) => a + p.cents);
  return [...parts.take(max - 1), (id: null, cents: rest)];
}

/// The [count] ids whose amounts add up the most over [history] (one map
/// per period), largest first: the series worth drawing over time.
List<int> leadingSeries(List<Map<int, int>> history, {int count = 5}) {
  final sums = <int, int>{};
  for (final period in history) {
    for (final e in period.entries) {
      if (e.value > 0) sums[e.key] = (sums[e.key] ?? 0) + e.value;
    }
  }
  final parts = [for (final e in sums.entries) (id: e.key, cents: e.value)]
    ..sort(_largestFirst);
  return [for (final p in parts.take(count)) p.id];
}

int _largestFirst(Share a, Share b) {
  final c = b.cents.compareTo(a.cents);
  return c != 0 ? c : a.id!.compareTo(b.id!);
}
