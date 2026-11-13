/// The cards of the home page the user may show, hide and order
/// (decision 0044). Kept on this device with the other display choices.
enum HomeCard {
  pepite,
  summary,
  firstSteps,
  status,
  advices,
  balance,
  leftToLive,
  monthBalance,
  upcoming,
  topSpending;

  /// Shown across the whole width; the others share two columns on a
  /// large screen.
  bool get wide => this == pepite || this == summary;
}

/// The order of the home cards and the ones shown.
class HomeLayout {
  /// Every card, once, in the order chosen.
  final List<HomeCard> order;
  final Set<HomeCard> hidden;

  HomeLayout._(this.order, this.hidden);

  /// The home page as it comes: every card, the spending ranking left out
  /// in simple mode.
  factory HomeLayout.defaults({bool simple = false}) => HomeLayout._(
    List.of(HomeCard.values),
    {if (simple) HomeCard.topSpending},
  );

  /// Reads `name,-name,…` (a `-` hides the card). Unknown names are
  /// skipped; a card missing from the text (added by a later version)
  /// comes last, shown.
  factory HomeLayout.parse(String? text, {bool simple = false}) {
    if (text == null || text.trim().isEmpty) {
      return HomeLayout.defaults(simple: simple);
    }
    final order = <HomeCard>[];
    final hidden = <HomeCard>{};
    for (final raw in text.split(',')) {
      final part = raw.trim();
      final off = part.startsWith('-');
      final name = off ? part.substring(1) : part;
      final card = HomeCard.values.where((c) => c.name == name).firstOrNull;
      if (card == null || order.contains(card)) continue;
      order.add(card);
      if (off) hidden.add(card);
    }
    for (final c in HomeCard.values) {
      if (!order.contains(c)) order.add(c);
    }
    return HomeLayout._(order, hidden);
  }

  @override
  String toString() => [
    for (final c in order) hidden.contains(c) ? '-${c.name}' : c.name,
  ].join(',');

  bool shows(HomeCard c) => !hidden.contains(c);

  /// The cards shown, in order.
  List<HomeCard> get visible => [
    for (final c in order)
      if (shows(c)) c,
  ];

  HomeLayout toggled(HomeCard c, bool show) => HomeLayout._(
    List.of(order),
    show ? ({...hidden}..remove(c)) : {...hidden, c},
  );

  /// The cards in a new [order]; a card left out of it keeps its place.
  HomeLayout reordered(List<HomeCard> order) {
    final list = {...order}.toList();
    for (final c in this.order) {
      if (!list.contains(c)) {
        list.insert(this.order.indexOf(c).clamp(0, list.length), c);
      }
    }
    return HomeLayout._(list, {...hidden});
  }

  @override
  bool operator ==(Object other) =>
      other is HomeLayout && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;
}
