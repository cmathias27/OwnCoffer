import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

/// Day-by-day forecast balance: one series, so no legend (the card title
/// names it). Step line (a balance holds for the whole day), light area
/// wash, hairline grid, the alert threshold as a labelled line, the lowest
/// point marked, and a crosshair with a tooltip on hover or touch.
class BalanceChart extends StatefulWidget {
  final List<ForecastDay> days;
  final int thresholdCents;
  final String thresholdLabel;
  final String lowestLabel;
  final String semanticLabel;

  /// Exact amount, for the tooltip.
  final String Function(int cents) money;

  /// Rounded amount, for the axis.
  final String Function(int cents) axisMoney;
  final String Function(DateTime date) day;

  const BalanceChart({
    super.key,
    required this.days,
    required this.thresholdCents,
    required this.thresholdLabel,
    required this.lowestLabel,
    required this.semanticLabel,
    required this.money,
    required this.axisMoney,
    required this.day,
  });

  @override
  State<BalanceChart> createState() => _BalanceChartState();
}

class _BalanceChartState extends State<BalanceChart> {
  int? _hover;

  void _track(Offset p, Size size) {
    final n = widget.days.length;
    if (n == 0) return;
    final plot = _Layout(size).plot;
    final t = ((p.dx - plot.left) / plot.width).clamp(0.0, 1.0);
    setState(() => _hover = (t * (n - 1)).round());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, box) {
          final size = Size(box.maxWidth, 240);
          return MouseRegion(
            onHover: (e) => _track(e.localPosition, size),
            onExit: (_) => setState(() => _hover = null),
            child: GestureDetector(
              onTapDown: (e) => _track(e.localPosition, size),
              onHorizontalDragUpdate: (e) => _track(e.localPosition, size),
              onHorizontalDragEnd: (_) => setState(() => _hover = null),
              child: CustomPaint(
                size: size,
                painter: _ChartPainter(
                  days: widget.days,
                  threshold: widget.thresholdCents,
                  thresholdLabel: widget.thresholdLabel,
                  lowestLabel: widget.lowestLabel,
                  money: widget.money,
                  axisMoney: widget.axisMoney,
                  day: widget.day,
                  hover: _hover,
                  line: theme.colorScheme.primary,
                  critical: theme.colorScheme.error,
                  grid: theme.colorScheme.outlineVariant,
                  surface: theme.colorScheme.surface,
                  ink: theme.colorScheme.onSurface,
                  muted: theme.colorScheme.onSurfaceVariant,
                  tooltipBg: theme.colorScheme.inverseSurface,
                  tooltipInk: theme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Layout {
  final Rect plot;
  _Layout(Size size)
    : plot = Rect.fromLTRB(72, 12, size.width - 12, size.height - 28);
}

class _ChartPainter extends CustomPainter {
  final List<ForecastDay> days;
  final int threshold;
  final String thresholdLabel;
  final String lowestLabel;
  final String Function(int) money;
  final String Function(int) axisMoney;
  final String Function(DateTime) day;
  final int? hover;
  final Color line, critical, grid, surface, ink, muted, tooltipBg, tooltipInk;

  _ChartPainter({
    required this.days,
    required this.threshold,
    required this.thresholdLabel,
    required this.lowestLabel,
    required this.money,
    required this.axisMoney,
    required this.day,
    required this.hover,
    required this.line,
    required this.critical,
    required this.grid,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.tooltipBg,
    required this.tooltipInk,
  });

  TextPainter _text(String s, Color color, {double size = 11}) => TextPainter(
    text: TextSpan(
      text: s,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Inter'),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    if (days.isEmpty) return;
    final plot = _Layout(size).plot;
    final values = days.map((d) => d.balanceCents);
    var lo = math.min(values.reduce(math.min), threshold);
    var hi = math.max(values.reduce(math.max), threshold);
    if (hi == lo) hi = lo + 10000;
    final pad = (hi - lo) * 0.1;
    lo = (lo - pad).floor();
    hi = (hi + pad).ceil();
    final n = days.length;
    double x(num i) => plot.left + plot.width * (n == 1 ? 0 : i / (n - 1));
    double y(int cents) => plot.bottom - plot.height * (cents - lo) / (hi - lo);

    // Recessive grid: three hairlines with their amounts.
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var k = 0; k <= 2; k++) {
      final v = lo + (hi - lo) * k ~/ 2;
      final gy = y(v);
      canvas.drawLine(Offset(plot.left, gy), Offset(plot.right, gy), gridPaint);
      final t = _text(axisMoney(v), muted);
      t.paint(canvas, Offset(plot.left - t.width - 8, gy - t.height / 2));
    }
    for (final i in {0, (n - 1) ~/ 2, n - 1}) {
      final t = _text(day(days[i].date), muted);
      final left = (x(i) - t.width / 2).clamp(
        plot.left,
        plot.right - t.width,
      );
      t.paint(canvas, Offset(left, plot.bottom + 8));
    }

    // Step line: the balance holds during the day, then jumps.
    final path = Path()..moveTo(x(0), y(days[0].balanceCents));
    for (var i = 1; i < n; i++) {
      path
        ..lineTo(x(i), y(days[i - 1].balanceCents))
        ..lineTo(x(i), y(days[i].balanceCents));
    }
    final area = Path.from(path)
      ..lineTo(x(n - 1), plot.bottom)
      ..lineTo(x(0), plot.bottom)
      ..close();
    canvas.drawPath(area, Paint()..color = line.withValues(alpha: 0.10));

    // Alert threshold, labelled (never colour alone).
    final ty = y(threshold);
    canvas.drawLine(
      Offset(plot.left, ty),
      Offset(plot.right, ty),
      Paint()
        ..color = critical
        ..strokeWidth = 1,
    );
    final tl = _text(thresholdLabel, critical);
    tl.paint(canvas, Offset(plot.right - tl.width, ty - tl.height - 2));

    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // Lowest point: marker with a surface ring and a direct label.
    var low = 0;
    for (var i = 1; i < n; i++) {
      if (days[i].balanceCents < days[low].balanceCents) low = i;
    }
    final lp = Offset(x(low), y(days[low].balanceCents));
    canvas.drawCircle(lp, 6, Paint()..color = surface);
    canvas.drawCircle(lp, 4, Paint()..color = line);
    final ll = _text(lowestLabel, ink);
    final lx = (lp.dx - ll.width / 2).clamp(plot.left, plot.right - ll.width);
    final below = lp.dy + 8 + ll.height <= plot.bottom;
    ll.paint(canvas, Offset(lx, below ? lp.dy + 8 : lp.dy - 8 - ll.height));

    // Crosshair and tooltip.
    final h = hover;
    if (h != null && h < n) {
      final hx = x(h);
      canvas.drawLine(
        Offset(hx, plot.top),
        Offset(hx, plot.bottom),
        Paint()
          ..color = muted
          ..strokeWidth = 1,
      );
      final hp = Offset(hx, y(days[h].balanceCents));
      canvas.drawCircle(hp, 6, Paint()..color = surface);
      canvas.drawCircle(hp, 4, Paint()..color = line);
      final a = _text(day(days[h].date), tooltipInk);
      final b = _text(money(days[h].balanceCents), tooltipInk, size: 13);
      final w = math.max(a.width, b.width) + 16;
      final ht = a.height + b.height + 12;
      var left = hx + 10;
      if (left + w > plot.right) left = hx - 10 - w;
      final top = plot.top;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, w, ht),
          const Radius.circular(6),
        ),
        Paint()..color = tooltipBg,
      );
      a.paint(canvas, Offset(left + 8, top + 6));
      b.paint(canvas, Offset(left + 8, top + 6 + a.height));
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.days != days || old.hover != hover || old.threshold != threshold;
}
