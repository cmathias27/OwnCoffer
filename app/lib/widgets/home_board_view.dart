import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../state/home_board.dart';
import 'why.dart';

/// The home page's grid of widgets (decision 0045). Each widget takes its
/// cells; in [editing], each one can be dragged by its handle to any cell,
/// resized, moved from its menu or removed, and every change is given to
/// [onChanged].
class HomeBoardView extends StatefulWidget {
  final HomeBoard board;
  final bool editing;

  /// Height of one row of cells.
  final double rowHeight;
  final double gap;
  final Widget Function(BuildContext context, HomeTile tile) tileBuilder;
  final ValueChanged<HomeBoard> onChanged;
  final String Function(HomeTileKind kind) nameOf;
  final IconData Function(HomeTileKind kind) iconOf;

  const HomeBoardView({
    super.key,
    required this.board,
    required this.editing,
    required this.rowHeight,
    required this.tileBuilder,
    required this.onChanged,
    required this.nameOf,
    required this.iconOf,
    this.gap = 12,
  });

  @override
  State<HomeBoardView> createState() => _HomeBoardViewState();
}

class _HomeBoardViewState extends State<HomeBoardView> {
  final _stack = GlobalKey();

  /// Where the widget being dragged would land.
  HomeTile? _ghost;

  /// The handle's place in its widget: the dragged shape keeps the widget's
  /// top left corner where it was relative to the pointer.
  static const _handleOffset = Offset(6, 6);

  HomeBoard get _board => widget.board;

  double _cell(double width) =>
      (width - widget.gap * (_board.columns - 1)) / _board.columns;

  Rect _rect(HomeTile t, double cell) {
    final g = widget.gap;
    return Rect.fromLTWH(
      t.x * (cell + g),
      t.y * (widget.rowHeight + g),
      t.size.width * cell + (t.size.width - 1) * g,
      t.size.height * widget.rowHeight + (t.size.height - 1) * g,
    );
  }

  /// The cell under the top left corner of a dragged widget.
  HomeTile? _landing(HomeTileKind kind, Offset global, double cell) {
    final tile = _board.tileOf(kind);
    final box = _stack.currentContext?.findRenderObject() as RenderBox?;
    if (tile == null || box == null) return null;
    final local = box.globalToLocal(global);
    final x = (local.dx / (cell + widget.gap)).round().clamp(
      0,
      _board.columns - tile.size.width,
    );
    final y = (local.dy / (widget.rowHeight + widget.gap)).round().clamp(
      0,
      _board.rows,
    );
    return tile.copyWith(x: x, y: y);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final cell = _cell(box.maxWidth);
        // One more row to drop below the last widget.
        final rows = _board.rows + (widget.editing ? 1 : 0);
        final height = rows == 0
            ? 0.0
            : rows * (widget.rowHeight + widget.gap) - widget.gap;
        final scheme = Theme.of(context).colorScheme;
        final stack = SizedBox(
          key: _stack,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (widget.editing)
                for (var y = 0; y < rows; y++)
                  for (var x = 0; x < _board.columns; x++)
                    Positioned.fromRect(
                      rect: _rect(
                        HomeTile(HomeTileKind.summary, TileSize.small, x, y),
                        cell,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: scheme.outlineVariant.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ),
              if (_ghost case final g?)
                Positioned.fromRect(
                  rect: _rect(g, cell),
                  child: DecoratedBox(
                    key: const Key('home-board-ghost'),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: scheme.primary, width: 2),
                    ),
                  ),
                ),
              for (final t in _board.reading)
                AnimatedPositioned.fromRect(
                  key: ValueKey('home-tile-${t.kind.name}'),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  rect: _rect(t, cell),
                  child: widget.editing
                      ? _editTile(context, t, _rect(t, cell).size)
                      : widget.tileBuilder(context, t),
                ),
            ],
          ),
        );
        if (!widget.editing) return stack;
        return DragTarget<HomeTileKind>(
          onMove: (d) =>
              setState(() => _ghost = _landing(d.data, d.offset, cell)),
          onLeave: (_) => setState(() => _ghost = null),
          onAcceptWithDetails: (d) {
            final to = _landing(d.data, d.offset, cell);
            setState(() => _ghost = null);
            if (to != null) {
              widget.onChanged(_board.moved(d.data, to.x, to.y));
            }
          },
          builder: (context, _, _) => stack,
        );
      },
    );
  }

  /// A widget being arranged: its content, not touchable, under a frame
  /// with a handle to drag it, a button for its size, a menu and a cross.
  Widget _editTile(BuildContext context, HomeTile t, Size size) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final name = widget.nameOf(t.kind);
    Widget round(Widget child, {Color? color}) => Material(
      color: color ?? scheme.primary,
      shape: const CircleBorder(),
      elevation: 2,
      child: child,
    );
    final kind = t.kind.name;
    return Semantics(
      label: name,
      child: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: Opacity(
              opacity: 0.85,
              child: widget.tileBuilder(context, t),
            ),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: scheme.primary, width: 2),
              ),
            ),
          ),
          Positioned(
            left: _handleOffset.dx,
            top: _handleOffset.dy,
            child: Draggable<HomeTileKind>(
              data: t.kind,
              dragAnchorStrategy: (draggable, context, position) {
                final box = context.findRenderObject()! as RenderBox;
                return box.globalToLocal(position) + _handleOffset;
              },
              onDragEnd: (_) => setState(() => _ghost = null),
              feedback: _feedback(context, t, size),
              childWhenDragging: const SizedBox(width: 36, height: 36),
              child: Tooltip(
                message: l.homeBoardDrag,
                child: round(
                  SizedBox(
                    key: Key('home-tile-drag-$kind'),
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.open_with,
                      size: 20,
                      color: scheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: round(
              color: scheme.errorContainer,
              IconButton(
                key: Key('home-tile-remove-$kind'),
                tooltip: l.homeBoardRemove(name),
                visualDensity: VisualDensity.compact,
                iconSize: 18,
                color: scheme.onErrorContainer,
                icon: const Icon(Icons.close),
                onPressed: () => widget.onChanged(_board.removed(t.kind)),
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (t.kind.sizes.length > 1)
                  round(
                    IconButton(
                      key: Key('home-tile-size-$kind'),
                      tooltip: l.homeBoardResize(
                        _sizeName(l, t.kind.after(t.size)),
                      ),
                      visualDensity: VisualDensity.compact,
                      iconSize: 18,
                      color: scheme.onPrimary,
                      icon: Icon(
                        t.kind.after(t.size).width *
                                    t.kind.after(t.size).height >
                                t.size.width * t.size.height
                            ? Icons.open_in_full
                            : Icons.close_fullscreen,
                      ),
                      onPressed: () => widget.onChanged(
                        _board.resized(t.kind, t.kind.after(t.size)),
                      ),
                    ),
                  ),
                const SizedBox(width: 6),
                round(
                  color: scheme.secondaryContainer,
                  PopupMenuButton<void Function()>(
                    key: Key('home-tile-menu-$kind'),
                    tooltip: l.homeBoardMenu(name),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.more_horiz,
                      color: scheme.onSecondaryContainer,
                    ),
                    onSelected: (act) => act(),
                    itemBuilder: (_) => _menu(l, t),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<void Function()>> _menu(AppLocalizations l, HomeTile t) {
    PopupMenuItem<void Function()> move(
      String key,
      IconData icon,
      String label,
      int dx,
      int dy, {
      required bool enabled,
    }) => PopupMenuItem(
      key: Key('home-tile-$key-${t.kind.name}'),
      enabled: enabled,
      value: () => widget.onChanged(_board.moved(t.kind, t.x + dx, t.y + dy)),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon),
        title: Text(label),
      ),
    );
    return [
      move('up', Icons.arrow_upward, l.homeBoardUp, 0, -1, enabled: t.y > 0),
      move(
        'down',
        Icons.arrow_downward,
        l.homeBoardDown,
        0,
        1,
        enabled: true,
      ),
      move(
        'left',
        Icons.arrow_back,
        l.homeBoardLeft,
        -1,
        0,
        enabled: t.x > 0,
      ),
      move(
        'right',
        Icons.arrow_forward,
        l.homeBoardRight,
        1,
        0,
        enabled: t.right < _board.columns,
      ),
      if (t.kind.sizes.length > 1) ...[
        const PopupMenuDivider(),
        for (final s in t.kind.sizes)
          PopupMenuItem(
            key: Key('home-tile-size-${s.name}-${t.kind.name}'),
            value: () => widget.onChanged(_board.resized(t.kind, s)),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                s == t.size
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(_sizeName(l, s)),
            ),
          ),
      ],
    ];
  }

  Widget _feedback(BuildContext context, HomeTile t, Size size) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox.fromSize(
      size: size,
      child: Material(
        color: scheme.primaryContainer.withValues(alpha: 0.92),
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.iconOf(t.kind), color: scheme.onPrimaryContainer),
                const SizedBox(height: 4),
                Text(
                  widget.nameOf(t.kind),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _sizeName(AppLocalizations l, TileSize s) => switch (s) {
  TileSize.small => l.homeSizeSmall,
  TileSize.medium => l.homeSizeMedium,
  TileSize.large => l.homeSizeLarge,
};

/// The name of a size, for the catalogue and the menus.
String homeSizeName(AppLocalizations l, TileSize s) => _sizeName(l, s);

/// The look of a widget of the home page: a rounded tonal card, its icon
/// and name on top, its content below, cut at the widget's height. A tap
/// opens its page; a long press arranges the home page.
class HomeTileFrame extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? help;
  final HelpTopic? helpTopic;

  /// The main figure of the page (the money today): stronger colours.
  final bool accent;

  const HomeTileFrame({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.help,
    this.helpTopic,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final ink = accent ? scheme.onPrimaryContainer : scheme.onSurface;
    return Material(
      color: accent ? scheme.primaryContainer : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: ink),
            child: IconTheme.merge(
              data: IconThemeData(color: ink),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          size: 18,
                          color: accent ? ink : scheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: ink,
                            ),
                          ),
                        ),
                        if (help != null)
                          CardHelp(title: title, text: help!, topic: helpTopic),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ClipRect(child: child),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The main figure of a widget, made smaller rather than cut when the
/// widget is narrow.
class TileFigure extends StatelessWidget {
  final String text;
  final Color? color;
  final bool large;
  const TileFigure(this.text, {super.key, this.color, this.large = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = large
        ? theme.textTheme.headlineMedium
        : theme.textTheme.headlineSmall;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: 1,
        style: style?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// A line of small text under a figure.
class TileLine extends StatelessWidget {
  final String text;
  final int maxLines;
  final Color? color;
  const TileLine(this.text, {super.key, this.maxLines = 2, this.color});

  @override
  Widget build(BuildContext context) => Text(
    text,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: color),
  );
}

/// The balance of the coming days as a small line, the area below it
/// washed, zero marked when crossed and the lowest point dotted.
class Sparkline extends StatelessWidget {
  final List<int> values;
  final String semanticLabel;
  const Sparkline({
    super.key,
    required this.values,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: semanticLabel,
      child: CustomPaint(
        size: Size.infinite,
        painter: _SparkPainter(
          values,
          line: scheme.primary,
          low: scheme.error,
          zero: scheme.outline,
        ),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  final List<int> values;
  final Color line;
  final Color low;
  final Color zero;
  _SparkPainter(
    this.values, {
    required this.line,
    required this.low,
    required this.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.isEmpty) return;
    final top = values.reduce(math.max);
    final bottom = values.reduce(math.min);
    final span = math.max(1, top - bottom);
    const pad = 4.0;
    double dx(int i) => i * size.width / (values.length - 1);
    double dy(int v) => pad + (top - v) / span * (size.height - 2 * pad);
    final path = Path()..moveTo(0, dy(values.first));
    for (var i = 1; i < values.length; i++) {
      path.lineTo(dx(i), dy(values[i]));
    }
    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, Paint()..color = line.withValues(alpha: 0.12));
    if (bottom < 0 && top > 0) {
      final y = dy(0);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = zero
          ..strokeWidth = 1,
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );
    final lowest = values.indexOf(bottom);
    canvas.drawCircle(
      Offset(dx(lowest), dy(bottom)),
      3.5,
      Paint()..color = bottom < 0 ? low : line,
    );
  }

  @override
  bool shouldRepaint(_SparkPainter old) =>
      old.values != values || old.line != line;
}
