/// The home page as a board of widgets placed freely on a grid (decision
/// 0045, replacing the ordered cards of decision 0044). Kept on this device
/// with the other display choices; never any bank data.
library;

/// The size of a widget, in cells of the grid: small 1×1, medium 2×1,
/// large 2×2.
enum TileSize {
  small(1, 1),
  medium(2, 1),
  large(2, 2);

  final int width;
  final int height;
  const TileSize(this.width, this.height);

  /// One letter in the saved text.
  String get code => name[0];
}

/// What a widget of the home page shows. The first ten are the cards of
/// decision 0044 (same names, so that its saved choice can be read); the
/// next ones each sum up a page of the app (decision 0045); the last ones
/// open the other functions of the app (decision 0046), then the split of
/// the spending (decision 0047), then the last month's review, the
/// comparison and the trends (decision 0049). New kinds are only ever added
/// at the end.
enum HomeTileKind {
  pepite,
  summary,
  firstSteps,
  status,
  advices,
  balance,
  leftToLive,
  monthBalance,
  upcoming,
  topSpending,
  accounts,
  forecast,
  operations,
  toClassify,
  subscriptions,
  loans,
  invoices,
  imports,
  notifications,

  /// Decision 0046: the goals of the budget and the 30-day summary, live.
  budget,
  monthSummary,

  /// Decision 0046: the other functions of the app, one tap away.
  search,
  newOperation,
  scanReceipt,
  categories,
  rules,
  members,
  export,
  security,
  assistant,
  apps,
  display,
  help,
  shortcuts,
  feedback,
  admin,

  /// Decision 0047: the split of the month's spending, as on the budget
  /// page.
  split,

  /// Decision 0049: the review of the last month over, this month against
  /// the three before, income and spending over six months.
  review,
  comparison,
  trends;

  /// A widget that opens a function rather than summing up a page
  /// (decision 0046).
  bool get isShortcut => switch (this) {
    search ||
    newOperation ||
    scanReceipt ||
    categories ||
    rules ||
    members ||
    export ||
    security ||
    assistant ||
    apps ||
    display ||
    help ||
    shortcuts ||
    feedback ||
    admin => true,
    _ => false,
  };

  /// The sizes it can take, smallest first.
  List<TileSize> get sizes => switch (this) {
    summary || toClassify || imports || notifications || invoices => const [
      TileSize.small,
      TileSize.medium,
    ],
    _ when isShortcut => const [TileSize.small, TileSize.medium],
    firstSteps || accounts || operations => const [
      TileSize.medium,
      TileSize.large,
    ],
    _ => TileSize.values,
  };

  /// Its size when added.
  TileSize get defaultSize => switch (this) {
    pepite || firstSteps || upcoming => TileSize.large,
    toClassify || notifications || leftToLive || monthBalance => TileSize.small,
    _ when isShortcut => TileSize.small,
    _ => TileSize.medium,
  };

  /// The next size, back to the smallest after the largest.
  TileSize after(TileSize size) {
    final i = sizes.indexOf(size);
    return sizes[(i + 1) % sizes.length];
  }
}

/// One widget placed on the board: column [x] and row [y] of its top left
/// cell.
class HomeTile {
  final HomeTileKind kind;
  final TileSize size;
  final int x;
  final int y;
  const HomeTile(this.kind, this.size, this.x, this.y);

  int get right => x + size.width;
  int get bottom => y + size.height;

  bool overlaps(HomeTile o) =>
      x < o.right && o.x < right && y < o.bottom && o.y < bottom;

  HomeTile copyWith({TileSize? size, int? x, int? y}) =>
      HomeTile(kind, size ?? this.size, x ?? this.x, y ?? this.y);

  @override
  String toString() => '${kind.name}:${size.code}:$x:$y';
}

/// The widgets of the home page and where they stand, for a grid of
/// [columns] columns (2 on a phone, 4 on a large screen). Free placement:
/// holes are kept; a widget put over others pushes them down.
class HomeBoard {
  final int columns;

  /// At most one widget of each kind, none overlapping.
  final List<HomeTile> tiles;

  HomeBoard._(this.columns, this.tiles);

  /// The number of columns for a width, in logical pixels.
  static int columnsFor(double width) => width >= 600 ? 4 : 2;

  /// The widgets of the home page as it comes, in reading order.
  static List<(HomeTileKind, TileSize)> defaultItems({
    bool simple = false,
    bool firstSteps = true,
  }) => [
    (HomeTileKind.pepite, TileSize.large),
    (HomeTileKind.balance, TileSize.medium),
    (HomeTileKind.leftToLive, TileSize.small),
    (HomeTileKind.monthBalance, TileSize.small),
    (HomeTileKind.summary, TileSize.medium),
    if (firstSteps) (HomeTileKind.firstSteps, TileSize.large),
    (HomeTileKind.status, TileSize.medium),
    (HomeTileKind.advices, TileSize.medium),
    (HomeTileKind.upcoming, TileSize.large),
    if (!simple) (HomeTileKind.topSpending, TileSize.large),
  ];

  /// The widgets one after the other, each in the first place free
  /// (reading order).
  factory HomeBoard.packed(
    int columns,
    Iterable<(HomeTileKind, TileSize)> items,
  ) {
    var board = HomeBoard._(columns, const []);
    for (final (kind, size) in items) {
      board = board.added(kind, size);
    }
    return board;
  }

  factory HomeBoard.defaults(
    int columns, {
    bool simple = false,
    bool firstSteps = true,
  }) => HomeBoard.packed(
    columns,
    defaultItems(simple: simple, firstSteps: firstSteps),
  );

  /// The same widgets on another grid, in their reading order (a board
  /// arranged on a large screen, seen for the first time on a phone).
  factory HomeBoard.reflowed(HomeBoard other, int columns) =>
      other.columns == columns
      ? other
      : HomeBoard.packed(columns, [
          for (final t in other._reading) (t.kind, t.size),
        ]);

  /// The cards chosen with decision 0044 (`name,-name,…`, a `-` hiding the
  /// card), packed in their order with their usual size. Null when there
  /// is no such choice.
  static HomeBoard? fromCards(String? text, int columns) {
    if (text == null || text.trim().isEmpty) return null;
    final seen = <HomeTileKind>{};
    final items = <(HomeTileKind, TileSize)>[];
    for (final raw in text.split(',')) {
      final part = raw.trim();
      final off = part.startsWith('-');
      final kind = _kind(off ? part.substring(1) : part);
      if (kind == null || !seen.add(kind) || off) continue;
      items.add((kind, _cardSize(kind)));
    }
    return HomeBoard.packed(columns, items);
  }

  static TileSize _cardSize(HomeTileKind kind) => switch (kind) {
    HomeTileKind.pepite ||
    HomeTileKind.firstSteps ||
    HomeTileKind.upcoming ||
    HomeTileKind.topSpending => TileSize.large,
    _ => TileSize.medium,
  };

  /// Reads `kind:size:x:y,…` (size `s`, `m` or `l`). Unknown widgets are
  /// skipped, a size it cannot take becomes its usual size, a widget
  /// outside the grid is brought back in and overlaps are pushed down.
  /// Null when nothing was saved; an empty text is an empty board (every
  /// widget removed).
  static HomeBoard? parse(String? text, int columns) {
    if (text == null) return null;
    if (text.trim().isEmpty) return HomeBoard._(columns, const []);
    final tiles = <HomeTile>[];
    for (final raw in text.split(',')) {
      final parts = raw.trim().split(':');
      if (parts.length != 4) continue;
      final kind = _kind(parts[0]);
      if (kind == null || tiles.any((t) => t.kind == kind)) continue;
      var size = TileSize.values.where((s) => s.code == parts[1]).firstOrNull;
      if (size == null || !kind.sizes.contains(size)) size = kind.defaultSize;
      final x = int.tryParse(parts[2]);
      final y = int.tryParse(parts[3]);
      if (x == null || y == null) continue;
      tiles.add(
        HomeTile(
          kind,
          size,
          x.clamp(0, columns - size.width),
          y.clamp(0, 999),
        ),
      );
    }
    return HomeBoard._(columns, _settle(tiles));
  }

  static HomeTileKind? _kind(String name) =>
      HomeTileKind.values.where((k) => k.name == name).firstOrNull;

  @override
  String toString() => _reading.join(',');

  /// Top to bottom, left to right.
  List<HomeTile> get _reading =>
      [...tiles]
        ..sort((a, b) => a.y != b.y ? a.y.compareTo(b.y) : a.x.compareTo(b.x));

  /// The tiles in reading order (what a screen reader goes through).
  List<HomeTile> get reading => _reading;

  /// Rows used, holes included.
  int get rows => tiles.fold(0, (r, t) => t.bottom > r ? t.bottom : r);

  bool contains(HomeTileKind kind) => tiles.any((t) => t.kind == kind);

  HomeTile? tileOf(HomeTileKind kind) =>
      tiles.where((t) => t.kind == kind).firstOrNull;

  /// The widgets not on the board, to add.
  List<HomeTileKind> get missing => [
    for (final k in HomeTileKind.values)
      if (!contains(k)) k,
  ];

  /// [kind] moved to column [x], row [y] (brought back inside the grid);
  /// the widgets it covers are pushed down.
  HomeBoard moved(HomeTileKind kind, int x, int y) {
    final tile = tileOf(kind);
    if (tile == null) return this;
    return _with(
      tile.copyWith(
        x: x.clamp(0, columns - tile.size.width),
        y: y < 0 ? 0 : y,
      ),
    );
  }

  /// [kind] at another size, kept inside the grid; the widgets it now
  /// covers are pushed down.
  HomeBoard resized(HomeTileKind kind, TileSize size) {
    final tile = tileOf(kind);
    if (tile == null || !kind.sizes.contains(size)) return this;
    return _with(
      tile.copyWith(
        size: size,
        x: tile.x.clamp(0, columns - size.width),
      ),
    );
  }

  /// [kind] added in the first place free, in reading order; nothing
  /// changes when it is already there.
  HomeBoard added(HomeTileKind kind, [TileSize? size]) {
    if (contains(kind)) return this;
    final s = size != null && kind.sizes.contains(size)
        ? size
        : kind.defaultSize;
    for (var y = 0; ; y++) {
      for (var x = 0; x + s.width <= columns; x++) {
        final t = HomeTile(kind, s, x, y);
        if (!tiles.any(t.overlaps)) {
          return HomeBoard._(columns, [...tiles, t]);
        }
      }
    }
  }

  HomeBoard removed(HomeTileKind kind) =>
      HomeBoard._(columns, [...tiles.where((t) => t.kind != kind)]);

  /// [tile] placed first, the others kept where they are unless covered.
  HomeBoard _with(HomeTile tile) => HomeBoard._(
    columns,
    _settle([tile, ...tiles.where((t) => t.kind != tile.kind)]),
  );

  /// Places the first tile where it is, then the others in reading order,
  /// each pushed down below whatever it would cover.
  static List<HomeTile> _settle(List<HomeTile> tiles) {
    if (tiles.isEmpty) return const [];
    final rest = tiles.skip(1).toList()
      ..sort((a, b) => a.y != b.y ? a.y.compareTo(b.y) : a.x.compareTo(b.x));
    final placed = <HomeTile>[tiles.first];
    for (var t in rest) {
      while (true) {
        final hit = placed.where(t.overlaps).firstOrNull;
        if (hit == null) break;
        t = t.copyWith(y: hit.bottom);
      }
      placed.add(t);
    }
    return placed;
  }

  @override
  bool operator ==(Object other) =>
      other is HomeBoard &&
      other.columns == columns &&
      other.toString() == toString();

  @override
  int get hashCode => Object.hash(columns, toString());
}
