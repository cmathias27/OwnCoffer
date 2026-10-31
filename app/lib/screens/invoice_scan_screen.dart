import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../l10n/app_localizations.dart';
import '../util/file_pick.dart';
import '../util/image_codec.dart';

/// Keeps only the invoice of a photo, like a scanner: the sheet is found,
/// the user drags its four corners if needed, then it is straightened and
/// made easier to read. All on the device.
///
/// Returns the JPEG to keep, the photo as it was, or null if cancelled.
Future<PickedFile?> scanInvoicePhoto(BuildContext context, PickedFile photo) =>
    Navigator.of(context).push<PickedFile>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => InvoiceScanScreen(photo: photo),
      ),
    );

/// Whether [name] is a photo that can be cropped.
bool isScannable(String name) =>
    const {'jpg', 'jpeg', 'png', 'webp'}.contains(core.fileExtension(name));

class InvoiceScanScreen extends StatefulWidget {
  final PickedFile photo;
  const InvoiceScanScreen({super.key, required this.photo});

  @override
  State<InvoiceScanScreen> createState() => _InvoiceScanScreenState();
}

class _InvoiceScanScreenState extends State<InvoiceScanScreen> {
  /// Large enough for a readable invoice, small enough for a phone.
  static const _workSide = 2800;

  core.RgbaImage? _image;
  ui.Image? _preview;
  List<core.ScanPoint> _corners = const [];
  List<core.ScanPoint> _detected = const [];
  var _enhance = true;
  var _busy = false;
  int? _dragging;
  String? _error;

  @override
  void initState() {
    super.initState();
    _decode();
  }

  @override
  void dispose() {
    _preview?.dispose();
    super.dispose();
  }

  Future<void> _decode() async {
    try {
      final img = await decodeImage(widget.photo.bytes, maxSide: _workSide);
      final small = core.shrinkImage(img, 320);
      final k = img.width / small.width;
      final found = [
        for (final p in core.detectDocument(small)) (x: p.x * k, y: p.y * k),
      ];
      final shown = core.shrinkImage(img, 1400);
      final done = Completer<ui.Image>();
      ui.decodeImageFromPixels(
        shown.pixels,
        shown.width,
        shown.height,
        ui.PixelFormat.rgba8888,
        done.complete,
      );
      final preview = await done.future;
      if (!mounted) {
        preview.dispose();
        return;
      }
      setState(() {
        _image = img;
        _preview = preview;
        _corners = found;
        _detected = found;
      });
    } on Object {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).scanUnreadable);
      }
    }
  }

  List<core.ScanPoint> get _whole {
    final img = _image!;
    final w = img.width.toDouble(), h = img.height.toDouble();
    return [(x: 0, y: 0), (x: w, y: 0), (x: w, y: h), (x: 0, y: h)];
  }

  Future<void> _done() async {
    final img = _image!;
    setState(() => _busy = true);
    // Let the progress indicator show before the work.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    try {
      final size = core.scanOutputSize(_corners);
      final out = core.warpDocument(img, _corners, size.width, size.height);
      if (_enhance) core.enhanceDocument(out);
      final jpeg = await encodeJpeg(out);
      final name = widget.photo.name;
      final ext = core.fileExtension(name);
      final stem = ext.isEmpty
          ? name
          : name.substring(0, name.length - ext.length - 1);
      if (mounted) Navigator.pop(context, PickedFile('$stem.jpg', jpeg));
    } on Object {
      if (mounted) {
        setState(
          () => (
            _busy = false,
            _error = AppLocalizations.of(context).scanFailed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final preview = _preview;
    final img = _image;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.scanTitle),
        actions: [
          TextButton(
            onPressed: _busy
                ? null
                : () => Navigator.pop(context, widget.photo),
            child: Text(l.scanKeepAsIs),
          ),
        ],
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, widget.photo),
                      child: Text(l.scanKeepAsIs),
                    ),
                  ],
                ),
              ),
            )
          : preview == null || img == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(l.scanLoading),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(l.scanHelp, style: theme.textTheme.bodySmall),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final scale = math.min(
                          box.maxWidth / img.width,
                          box.maxHeight / img.height,
                        );
                        final w = img.width * scale, h = img.height * scale;
                        final left = (box.maxWidth - w) / 2;
                        final top = (box.maxHeight - h) / 2;
                        core.ScanPoint toImage(Offset o) => (
                          x: ((o.dx - left) / scale)
                              .clamp(0, img.width)
                              .toDouble(),
                          y: ((o.dy - top) / scale)
                              .clamp(0, img.height)
                              .toDouble(),
                        );
                        Offset toScreen(core.ScanPoint p) =>
                            Offset(left + p.x * scale, top + p.y * scale);
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (d) {
                            var best = -1;
                            var bestDist = 48.0;
                            for (var i = 0; i < _corners.length; i++) {
                              final dist =
                                  (toScreen(_corners[i]) - d.localPosition)
                                      .distance;
                              if (dist < bestDist) {
                                best = i;
                                bestDist = dist;
                              }
                            }
                            _dragging = best < 0 ? null : best;
                          },
                          onPanUpdate: (d) {
                            final i = _dragging;
                            if (i == null) return;
                            setState(
                              () => _corners = [
                                for (var k = 0; k < 4; k++)
                                  k == i
                                      ? toImage(d.localPosition)
                                      : _corners[k],
                              ],
                            );
                          },
                          onPanEnd: (_) => _dragging = null,
                          child: CustomPaint(
                            size: Size(box.maxWidth, box.maxHeight),
                            painter: _ScanPainter(
                              image: preview,
                              rect: Rect.fromLTWH(left, top, w, h),
                              corners: [for (final c in _corners) toScreen(c)],
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l.scanEnhance),
                          value: _enhance,
                          onChanged: _busy
                              ? null
                              : (v) => setState(() => _enhance = v),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            TextButton(
                              onPressed: _busy
                                  ? null
                                  : () => setState(() => _corners = _whole),
                              child: Text(l.scanWholePhoto),
                            ),
                            TextButton(
                              onPressed: _busy
                                  ? null
                                  : () => setState(() => _corners = _detected),
                              child: Text(l.scanDetectAgain),
                            ),
                            FilledButton.icon(
                              icon: _busy
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.crop),
                              label: Text(l.scanApply),
                              onPressed: _busy ? null : _done,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  final ui.Image image;
  final Rect rect;
  final List<Offset> corners;
  final Color color;

  _ScanPainter({
    required this.image,
    required this.rect,
    required this.corners,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
      canvas: canvas,
      rect: rect,
      image: image,
      filterQuality: FilterQuality.medium,
    );
    if (corners.length != 4) return;
    final outline = Path()..addPolygon(corners, true);
    // Outside the document dimmed.
    canvas.drawPath(
      Path.combine(PathOperation.difference, Path()..addRect(rect), outline),
      Paint()..color = Colors.black.withValues(alpha: 0.45),
    );
    canvas.drawPath(
      outline,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = color,
    );
    for (final c in corners) {
      canvas.drawCircle(c, 14, Paint()..color = Colors.white);
      canvas.drawCircle(
        c,
        14,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_ScanPainter old) =>
      old.image != image || old.rect != rect || old.corners != corners;
}
