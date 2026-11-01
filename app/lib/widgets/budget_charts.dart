import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Chart colours (dataviz reference palette): categorical slots 1 and 2,
/// stepped for the dark surface, and the fixed status palette. Text never
/// wears these colours; a status colour always comes with an icon and a
/// label.
abstract final class ChartColors {
  static Color income(BuildContext c) =>
      _dark(c) ? const Color(0xFF3987E5) : const Color(0xFF2A78D6);
  static Color expense(BuildContext c) =>
      _dark(c) ? const Color(0xFFD95926) : const Color(0xFFEB6834);

  /// One hue for ranked bars.
  static Color rank(BuildContext c) => income(c);

  static const good = Color(0xFF0CA30C);
  static const warning = Color(0xFFFAB219);
  static const critical = Color(0xFFD03B3B);

  static Color track(BuildContext c) =>
      Theme.of(c).colorScheme.surfaceContainerHighest;

  static bool _dark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;
}

/// A thin horizontal bar, rounded data end, on a recessive track.
class ThinBar extends StatelessWidget {
  /// 0 to 1.
  final double fraction;
  final Color color;

  /// Optional marker (0 to 1), e.g. the goal on a spending bar.
  final double? marker;
  final double height;

  const ThinBar({
    super.key,
    required this.fraction,
    required this.color,
    this.marker,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final f = fraction.clamp(0.0, 1.0);
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ChartColors.track(context),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              if (f > 0)
                Container(
                  width: math.max(height, w * f),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              if (marker != null)
                Positioned(
                  left: (w * marker!.clamp(0.0, 1.0)) - 1,
                  top: -3,
                  bottom: -3,
                  child: Container(
                    width: 2,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// One period of the income / expense chart.
class IncomeExpensePoint {
  final String label;
  final String tooltipTitle;
  final int incomeCents;
  final int expenseCents;
  const IncomeExpensePoint({
    required this.label,
    required this.tooltipTitle,
    required this.incomeCents,
    required this.expenseCents,
  });
}

/// Income and expenses side by side over a few periods, the current one
/// last. Two series: legend above, tooltip on hover or tap.
class IncomeExpenseChart extends StatefulWidget {
  final List<IncomeExpensePoint> points;
  final String incomeLabel;
  final String expenseLabel;
  final String netLabel;
  final String semanticLabel;
  final String Function(int cents) money;
  final String Function(int cents) axisMoney;

  const IncomeExpenseChart({
    super.key,
    required this.points,
    required this.incomeLabel,
    required this.expenseLabel,
    required this.netLabel,
    required this.semanticLabel,
    required this.money,
    required this.axisMoney,
  });

  @override
  State<IncomeExpenseChart> createState() => _IncomeExpenseChartState();
}

class _IncomeExpenseChartState extends State<IncomeExpenseChart> {
  int? _hover;
  static const _height = 200.0;
  static const _axis = 56.0;
  static const _bottom = 24.0;

  void _track(Offset p, double width) {
    final n = widget.points.length;
    if (n == 0) return;
    final slot = (width - _axis) / n;
    final i = ((p.dx - _axis) / slot).floor();
    setState(() => _hover = i >= 0 && i < n ? i : null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inc = ChartColors.income(context);
    final exp = ChartColors.expense(context);
    Widget key(Color c, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: theme.textTheme.bodySmall),
      ],
    );
    final hover = _hover;
    return Semantics(
      label: widget.semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            children: [
              key(inc, widget.incomeLabel),
              key(exp, widget.expenseLabel),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, box) {
              final width = box.maxWidth;
              return MouseRegion(
                onHover: (e) => _track(e.localPosition, width),
                onExit: (_) => setState(() => _hover = null),
                child: GestureDetector(
                  onTapDown: (d) => _track(d.localPosition, width),
                  onHorizontalDragUpdate: (d) => _track(d.localPosition, width),
                  child: SizedBox(
                    height: _height,
                    width: width,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: Size(width, _height),
                          painter: _BarsPainter(
                            points: widget.points,
                            income: inc,
                            expense: exp,
                            grid: theme.colorScheme.outlineVariant,
                            text: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            surface: theme.colorScheme.surface,
                            highlight: hover,
                            axisMoney: widget.axisMoney,
                          ),
                        ),
                        if (hover != null)
                          _tooltip(context, width, hover, inc, exp),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tooltip(
    BuildContext context,
    double width,
    int i,
    Color inc,
    Color exp,
  ) {
    final theme = Theme.of(context);
    final p = widget.points[i];
    final slot = (width - _axis) / widget.points.length;
    const w = 190.0;
    final center = _axis + slot * (i + 0.5);
    final left = (center - w / 2)
        .clamp(0.0, math.max(0.0, width - w))
        .toDouble();
    Widget row(Color? c, String label, int cents) => Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          if (c != null)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(2),
              ),
            )
          else
            const SizedBox(width: 14),
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(
            widget.money(cents),
            style: theme.textTheme.bodySmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
    return Positioned(
      left: left,
      top: 0,
      width: w,
      child: IgnorePointer(
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(p.tooltipTitle, style: theme.textTheme.labelMedium),
                row(inc, widget.incomeLabel, p.incomeCents),
                row(exp, widget.expenseLabel, p.expenseCents),
                row(null, widget.netLabel, p.incomeCents - p.expenseCents),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  final List<IncomeExpensePoint> points;
  final Color income, expense, grid, surface;
  final TextStyle text;
  final int? highlight;
  final String Function(int) axisMoney;

  _BarsPainter({
    required this.points,
    required this.income,
    required this.expense,
    required this.grid,
    required this.text,
    required this.surface,
    required this.highlight,
    required this.axisMoney,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const axis = _IncomeExpenseChartState._axis;
    const bottom = _IncomeExpenseChartState._bottom;
    final plotH = size.height - bottom - 8;
    final top = 8.0;
    var max = 0;
    for (final p in points) {
      max = math.max(max, math.max(p.incomeCents, p.expenseCents));
    }
    final scale = _niceMax(max);

    // Recessive grid with three labelled lines.
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var k = 0; k <= 3; k++) {
      final v = scale * k ~/ 3;
      final y = top + plotH - plotH * k / 3;
      canvas.drawLine(Offset(axis, y), Offset(size.width, y), gridPaint);
      _label(canvas, axisMoney(v), Offset(axis - 6, y), TextAlign.right);
    }

    if (points.isEmpty) return;
    final slot = (size.width - axis) / points.length;
    final barW = math.max(2.0, math.min(18.0, (slot - 12) / 2));
    // Labels thinned out so that they never overlap (12 or 24 periods).
    final every = math.max(1, (44 / slot).ceil());
    for (final (i, p) in points.indexed) {
      final x = axis + slot * i;
      if (highlight == i) {
        canvas.drawRect(
          Rect.fromLTWH(x, top, slot, plotH),
          Paint()..color = grid.withValues(alpha: 0.35),
        );
      }
      final cx = x + slot / 2;
      // 2 px surface gap between the two bars.
      _bar(
        canvas,
        cx - 1 - barW,
        barW,
        p.incomeCents,
        scale,
        top,
        plotH,
        income,
      );
      _bar(canvas, cx + 1, barW, p.expenseCents, scale, top, plotH, expense);
      if ((points.length - 1 - i) % every != 0) continue;
      _label(
        canvas,
        p.label,
        Offset(cx, top + plotH + 4),
        TextAlign.center,
        below: true,
      );
    }
  }

  void _bar(
    Canvas canvas,
    double x,
    double w,
    int cents,
    int scale,
    double top,
    double plotH,
    Color color,
  ) {
    if (cents <= 0 || scale <= 0) return;
    final h = math.max(2.0, plotH * cents / scale);
    final r = RRect.fromRectAndCorners(
      Rect.fromLTWH(x, top + plotH - h, w, h),
      topLeft: const Radius.circular(4),
      topRight: const Radius.circular(4),
    );
    canvas.drawRRect(r, Paint()..color = color);
  }

  void _label(
    Canvas canvas,
    String s,
    Offset at,
    TextAlign align, {
    bool below = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: text),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    final dx = switch (align) {
      TextAlign.right => at.dx - tp.width,
      TextAlign.center => at.dx - tp.width / 2,
      _ => at.dx,
    };
    tp.paint(canvas, Offset(dx, below ? at.dy : at.dy - tp.height / 2));
  }

  /// A round axis maximum in cents (1, 2 or 5 × 10^n euros).
  static int _niceMax(int cents) {
    if (cents <= 0) return 10000;
    final euros = (cents + 99) ~/ 100;
    var step = 1;
    while (step * 10 <= euros) {
      step *= 10;
    }
    for (final m in [1, 2, 5, 10]) {
      if (step * m >= euros) return step * m * 100;
    }
    return step * 10 * 100;
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.points != points || old.highlight != highlight;
}

/// Categorical colours for up to eight series, in a fixed order (dataviz
/// reference palette, validated on adjacent pairs in both modes); "Others"
/// stays neutral.
abstract final class SeriesColors {
  static const _light = [
    Color(0xFF2A78D6),
    Color(0xFFEB6834),
    Color(0xFF1BAF7A),
    Color(0xFFEDA100),
    Color(0xFFE87BA4),
    Color(0xFF008300),
    Color(0xFF6250D6),
    Color(0xFFE34948),
  ];
  static const _dark = [
    Color(0xFF3987E5),
    Color(0xFFD95926),
    Color(0xFF199E70),
    Color(0xFFC98500),
    Color(0xFFD55181),
    Color(0xFF008300),
    Color(0xFF9085E9),
    Color(0xFFE66767),
  ];

  static const count = 8;

  static Color of(BuildContext c, int slot) =>
      (ChartColors._dark(c) ? _dark : _light)[slot % count];

  static Color others(BuildContext c) => Theme.of(c).colorScheme.outline;
}

/// One part of a [DonutChart].
class ChartSlice {
  final String label;
  final int cents;
  final Color color;
  const ChartSlice({
    required this.label,
    required this.cents,
    required this.color,
  });
}

/// A whole split into a few parts: a ring with the total in its centre and,
/// beside it, a legend giving each part's amount and share. Hovering or
/// touching a part shows it in the centre; [onTap] opens it.
class DonutChart extends StatefulWidget {
  final List<ChartSlice> slices;
  final String totalLabel;
  final String semanticLabel;
  final String Function(int cents) money;
  final String Function(int percent) percent;
  final ValueChanged<int> onTap;

  const DonutChart({
    super.key,
    required this.slices,
    required this.totalLabel,
    required this.semanticLabel,
    required this.money,
    required this.percent,
    required this.onTap,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int? _hover;
  static const _size = 220.0;
  static const _ring = 34.0;

  int get _total => widget.slices.fold(0, (a, s) => a + s.cents);

  int _share(int cents) => _total <= 0 ? 0 : (cents * 100 / _total).round();

  /// The slice under [p] (relative to the chart's box), if any.
  int? _at(Offset p) {
    final c = const Offset(_size / 2, _size / 2);
    final d = p - c;
    final r = d.distance;
    if (r < _size / 2 - _ring - 6 || r > _size / 2 + 4 || _total <= 0) {
      return null;
    }
    // Clockwise from the top.
    var a = math.atan2(d.dy, d.dx) + math.pi / 2;
    if (a < 0) a += 2 * math.pi;
    var start = 0.0;
    for (final (i, s) in widget.slices.indexed) {
      final sweep = 2 * math.pi * s.cents / _total;
      if (a >= start && a < start + sweep) return i;
      start += sweep;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hover = _hover;
    final shown = hover == null ? null : widget.slices[hover];
    final ring = MouseRegion(
      onHover: (e) => setState(() => _hover = _at(e.localPosition)),
      onExit: (_) => setState(() => _hover = null),
      cursor: hover == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTapUp: (d) {
          final i = _at(d.localPosition);
          if (i != null) widget.onTap(i);
        },
        child: SizedBox.square(
          dimension: _size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size.square(_size),
                painter: _DonutPainter(
                  slices: widget.slices,
                  ring: _ring,
                  surface: theme.colorScheme.surfaceContainerLow,
                  track: ChartColors.track(context),
                  highlight: hover,
                ),
              ),
              SizedBox(
                width: _size - 2 * _ring - 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shown?.label ?? widget.totalLabel,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      widget.money(shown?.cents ?? _total),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (shown != null)
                      Text(
                        widget.percent(_share(shown.cents)),
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final legend = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, s) in widget.slices.indexed)
          MouseRegion(
            onEnter: (_) => setState(() => _hover = i),
            onExit: (_) => setState(() => _hover = null),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => widget.onTap(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                decoration: BoxDecoration(
                  color: hover == i
                      ? theme.colorScheme.surfaceContainerHighest
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: s.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.percent(_share(s.cents)),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.money(s.cents),
                      style: const TextStyle(
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
    return Semantics(
      label: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, box) => box.maxWidth >= 560
            ? Row(
                children: [
                  ring,
                  const SizedBox(width: 24),
                  Expanded(child: legend),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: ring),
                  const SizedBox(height: 12),
                  legend,
                ],
              ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<ChartSlice> slices;
  final double ring;
  final Color surface, track;
  final int? highlight;

  _DonutPainter({
    required this.slices,
    required this.ring,
    required this.surface,
    required this.track,
    required this.highlight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - ring / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final total = slices.fold(0, (a, s) => a + s.cents);
    if (total <= 0) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring
          ..color = track,
      );
      return;
    }
    var start = -math.pi / 2;
    for (final (i, s) in slices.indexed) {
      final sweep = 2 * math.pi * s.cents / total;
      final dim = highlight != null && highlight != i;
      canvas.drawArc(
        highlight == i ? rect.inflate(3) : rect,
        start,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = highlight == i ? ring + 6 : ring
          ..color = dim ? s.color.withValues(alpha: 0.45) : s.color,
      );
      start += sweep;
    }
    // 2 px surface gaps between the parts.
    if (slices.length > 1) {
      final gap = Paint()
        ..color = surface
        ..strokeWidth = 2;
      var a = -math.pi / 2;
      for (final s in slices) {
        final d = Offset(math.cos(a), math.sin(a));
        canvas.drawLine(
          center + d * (radius - ring / 2 - 4),
          center + d * (radius + ring / 2 + 4),
          gap,
        );
        a += 2 * math.pi * s.cents / total;
      }
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.slices != slices ||
      old.highlight != highlight ||
      old.surface != surface;
}

/// One line of a [TrendChart]: an amount per period, oldest first.
class ChartSeries {
  final String label;
  final Color color;
  final List<int> values;
  const ChartSeries({
    required this.label,
    required this.color,
    required this.values,
  });
}

/// A few categories over the same periods, one line each on one scale.
/// Legend above (touching an entry opens it); a crosshair and a tooltip
/// with every value of the period under the pointer.
class TrendChart extends StatefulWidget {
  final List<String> labels;
  final List<ChartSeries> series;
  final String semanticLabel;
  final String Function(int cents) money;
  final String Function(int cents) axisMoney;
  final ValueChanged<int>? onTapSeries;

  const TrendChart({
    super.key,
    required this.labels,
    required this.series,
    required this.semanticLabel,
    required this.money,
    required this.axisMoney,
    this.onTapSeries,
  });

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  int? _hover;
  static const _height = 220.0;
  static const _axis = 56.0;
  static const _right = 12.0;

  void _track(Offset p, double width) {
    final n = widget.labels.length;
    if (n == 0) return;
    final step = n == 1 ? 0.0 : (width - _axis - _right) / (n - 1);
    final i = step == 0 ? 0 : ((p.dx - _axis) / step).round();
    setState(() => _hover = i >= 0 && i < n ? i : null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hover = _hover;
    return Semantics(
      label: widget.semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (final (i, s) in widget.series.indexed)
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: widget.onTapSeries == null
                      ? null
                      : () => widget.onTapSeries!(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 14, height: 3, color: s.color),
                        const SizedBox(width: 6),
                        Text(s.label, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, box) {
              final width = box.maxWidth;
              return MouseRegion(
                onHover: (e) => _track(e.localPosition, width),
                onExit: (_) => setState(() => _hover = null),
                child: GestureDetector(
                  onTapDown: (d) => _track(d.localPosition, width),
                  onHorizontalDragUpdate: (d) => _track(d.localPosition, width),
                  child: SizedBox(
                    height: _height,
                    width: width,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: Size(width, _height),
                          painter: _LinesPainter(
                            labels: widget.labels,
                            series: widget.series,
                            grid: theme.colorScheme.outlineVariant,
                            surface: theme.colorScheme.surfaceContainerLow,
                            text: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            highlight: hover,
                            axisMoney: widget.axisMoney,
                          ),
                        ),
                        if (hover != null) _tooltip(context, width, hover),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tooltip(BuildContext context, double width, int i) {
    final theme = Theme.of(context);
    final n = widget.labels.length;
    final step = n == 1 ? 0.0 : (width - _axis - _right) / (n - 1);
    const w = 210.0;
    final x = _axis + step * i;
    // Beside the crosshair, on the side with room.
    final left = x + 12 + w <= width ? x + 12 : math.max(0.0, x - 12 - w);
    final rows = [
      for (final s in widget.series)
        if (i < s.values.length) (s, s.values[i]),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    return Positioned(
      left: left,
      top: 0,
      width: w,
      child: IgnorePointer(
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.labels[i], style: theme.textTheme.labelMedium),
                for (final (s, v) in rows)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: s.color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            s.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          widget.money(v),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
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

class _LinesPainter extends CustomPainter {
  final List<String> labels;
  final List<ChartSeries> series;
  final Color grid, surface;
  final TextStyle text;
  final int? highlight;
  final String Function(int) axisMoney;

  _LinesPainter({
    required this.labels,
    required this.series,
    required this.grid,
    required this.surface,
    required this.text,
    required this.highlight,
    required this.axisMoney,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const axis = _TrendChartState._axis;
    const right = _TrendChartState._right;
    const bottom = 24.0, top = 8.0;
    final plotH = size.height - bottom - top;
    var max = 0;
    for (final s in series) {
      for (final v in s.values) {
        max = math.max(max, v);
      }
    }
    final scale = _BarsPainter._niceMax(max);
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var k = 0; k <= 3; k++) {
      final y = top + plotH - plotH * k / 3;
      canvas.drawLine(Offset(axis, y), Offset(size.width, y), gridPaint);
      _label(canvas, axisMoney(scale * k ~/ 3), Offset(axis - 6, y - 7), 1);
    }
    final n = labels.length;
    if (n == 0) return;
    final step = n == 1 ? 0.0 : (size.width - axis - right) / (n - 1);
    double x(int i) => axis + step * i;
    double y(int v) => top + plotH - plotH * v.clamp(0, scale) / scale;

    // Labels thinned out so that they never overlap.
    final every = step <= 0 ? 1 : math.max(1, (44 / step).ceil());
    for (var i = 0; i < n; i++) {
      if ((n - 1 - i) % every != 0) continue;
      _label(canvas, labels[i], Offset(x(i), top + plotH + 4), 0);
    }
    if (highlight != null) {
      canvas.drawLine(
        Offset(x(highlight!), top),
        Offset(x(highlight!), top + plotH),
        Paint()
          ..color = grid
          ..strokeWidth = 1.5,
      );
    }
    for (final s in series) {
      final path = Path();
      for (var i = 0; i < s.values.length && i < n; i++) {
        final p = Offset(x(i), y(s.values[i]));
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeJoin = StrokeJoin.round
          ..color = s.color,
      );
      final h = highlight;
      if (h != null && h < s.values.length) {
        final p = Offset(x(h), y(s.values[h]));
        // 2 px surface ring so that close markers stay apart.
        canvas.drawCircle(p, 6, Paint()..color = surface);
        canvas.drawCircle(p, 4, Paint()..color = s.color);
      }
    }
  }

  /// [align]: 0 centred below [at], 1 right-aligned to it.
  void _label(Canvas canvas, String s, Offset at, int align) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: text),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = align == 1 ? at.dx - tp.width : at.dx - tp.width / 2;
    tp.paint(canvas, Offset(dx, at.dy));
  }

  @override
  bool shouldRepaint(_LinesPainter old) =>
      old.series != series ||
      old.labels != labels ||
      old.highlight != highlight;
}
