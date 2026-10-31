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
    final barW = math.min(18.0, (slot - 12) / 2);
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
