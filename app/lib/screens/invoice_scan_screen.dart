import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../l10n/app_localizations.dart';
import '../util/file_pick.dart';
import '../util/image_codec.dart';

/// Keeps only the invoice or ticket of a photo, like a scanner: the sheet
/// is found and, when it is found for sure, straightened and made easier
/// to read straight away; otherwise (or on request) the user drags its four
/// corners. A blurred photo is pointed out, with [retake] to take it again
/// (decision 0039). All on the device.
///
/// Returns the file to keep, the photo as it was, or null if cancelled.
Future<PickedFile?> scanInvoicePhoto(
  BuildContext context,
  PickedFile photo, {
  Future<PickedFile?> Function()? retake,
}) => Navigator.of(context).push<PickedFile>(
  MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => InvoiceScanScreen(photo: photo, retake: retake),
  ),
);

/// Whether [name] is a photo that can be cropped.
bool isScannable(String name) =>
    const {'jpg', 'jpeg', 'png', 'webp'}.contains(core.fileExtension(name));

/// Large enough for a readable invoice, small enough for a phone.
const _workSide = 2800;

typedef _Analysis = ({List<core.ScanPoint> corners, bool sure, double? blur});

/// Where the sheet is (found on a 400 px copy) and how blurred it is
/// (measured on a 1600 px copy, within the sheet). Run off the screen's
/// thread in the apps.
_Analysis _analyse(core.RgbaImage img) {
  final small = core.shrinkImage(img, 400);
  final found = core.findDocument(small);
  final k = img.width / small.width;
  final corners = [for (final p in found.corners) (x: p.x * k, y: p.y * k)];
  final medium = core.shrinkImage(img, 1600);
  final j = medium.width / img.width;
  final blur = core.blurLevel(
    medium,
    within: [for (final p in corners) (x: p.x * j, y: p.y * j)],
  );
  return (corners: corners, sure: found.sure, blur: blur);
}

typedef _Straighten = ({
  core.RgbaImage image,
  List<core.ScanPoint> corners,
  bool enhance,
});

core.RgbaImage _straighten(_Straighten job) {
  final size = core.scanOutputSize(job.corners);
  final out = core.warpDocument(
    job.image,
    job.corners,
    size.width,
    size.height,
  );
  if (job.enhance) core.enhanceDocument(out);
  return out;
}

Future<ui.Image> _toScreen(core.RgbaImage img) {
  final shown = core.shrinkImage(img, 1400);
  final done = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    shown.pixels,
    shown.width,
    shown.height,
    ui.PixelFormat.rgba8888,
    done.complete,
  );
  return done.future;
}

class InvoiceScanScreen extends StatefulWidget {
  final PickedFile photo;

  /// Takes another photo (the camera again); none when the photo came
  /// from a file.
  final Future<PickedFile?> Function()? retake;

  /// Tests decode without the platform's codecs.
  @visibleForTesting
  final Future<core.RgbaImage> Function(Uint8List bytes)? decode;

  const InvoiceScanScreen({
    super.key,
    required this.photo,
    this.retake,
    this.decode,
  });

  @override
  State<InvoiceScanScreen> createState() => _InvoiceScanScreenState();
}

class _InvoiceScanScreenState extends State<InvoiceScanScreen> {
  late PickedFile _photo = widget.photo;
  core.RgbaImage? _image;
  ui.Image? _preview;
  List<core.ScanPoint> _corners = const [];
  List<core.ScanPoint> _detected = const [];
  double? _blur;

  /// The straightened sheet, shown for review when it was found for sure.
  core.RgbaImage? _result;
  ui.Image? _resultPreview;
  var _review = false;

  var _enhance = true;
  var _busy = false;
  int? _dragging;
  String? _error;

  /// Each photo loaded; a retake makes earlier work stale.
  var _generation = 0;

  @override
  void initState() {
    super.initState();
    _load(_photo);
  }

  @override
  void dispose() {
    _preview?.dispose();
    _resultPreview?.dispose();
    super.dispose();
  }

  Future<void> _load(PickedFile photo) async {
    final generation = ++_generation;
    _preview?.dispose();
    _resultPreview?.dispose();
    setState(
      () => (
        _photo = photo,
        _image = null,
        _preview = null,
        _result = null,
        _resultPreview = null,
        _review = false,
        _blur = null,
        _error = null,
        _busy = false,
      ),
    );
    bool stale() => !mounted || generation != _generation;
    try {
      final img = await (widget.decode ?? _decode)(photo.bytes);
      if (stale()) return;
      final analysis = await compute(_analyse, img);
      if (stale()) return;
      final preview = await _toScreen(img);
      if (stale()) {
        preview.dispose();
        return;
      }
      core.RgbaImage? result;
      ui.Image? resultPreview;
      if (analysis.sure) {
        try {
          final straight = await compute(_straighten, (
            image: img,
            corners: analysis.corners,
            enhance: _enhance,
          ));
          resultPreview = await _toScreen(straight);
          result = straight;
        } on Object {
          // Then the corners are shown, as when not sure.
          result = null;
        }
      }
      if (stale()) {
        preview.dispose();
        resultPreview?.dispose();
        return;
      }
      setState(() {
        _image = img;
        _preview = preview;
        _corners = analysis.corners;
        _detected = analysis.corners;
        _blur = analysis.blur;
        _result = result;
        _resultPreview = resultPreview;
        _review = result != null;
      });
    } on Object {
      if (!stale()) {
        setState(() => _error = AppLocalizations.of(context).scanUnreadable);
      }
    }
  }

  static Future<core.RgbaImage> _decode(Uint8List bytes) =>
      decodeImage(bytes, maxSide: _workSide);

  List<core.ScanPoint> get _whole {
    final img = _image!;
    final w = img.width.toDouble(), h = img.height.toDouble();
    return [(x: 0, y: 0), (x: w, y: 0), (x: w, y: h), (x: 0, y: h)];
  }

  Future<void> _retake() async {
    final next = await widget.retake!();
    if (next == null || !mounted) return;
    if (!isScannable(next.name)) {
      Navigator.pop(context, next);
      return;
    }
    await _load(next);
  }

  /// In review, the straightened sheet again with or without the
  /// readability step.
  Future<void> _setEnhance(bool on) async {
    setState(() => _enhance = on);
    if (!_review) return;
    final generation = _generation;
    setState(() => _busy = true);
    try {
      final result = await compute(_straighten, (
        image: _image!,
        corners: _corners,
        enhance: on,
      ));
      final preview = await _toScreen(result);
      if (!mounted || generation != _generation) {
        preview.dispose();
        return;
      }
      _resultPreview?.dispose();
      setState(() => (_result = result, _resultPreview = preview));
    } on Object {
      if (mounted) setState(() => _review = false);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _done() async {
    final img = _image!;
    setState(() => _busy = true);
    // Let the progress indicator show before the work.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    try {
      final out = _review && _result != null
          ? _result!
          : await compute(_straighten, (
              image: img,
              corners: _corners,
              enhance: _enhance,
            ));
      final scan = await encodeScan(out);
      final name = _photo.name;
      final ext = core.fileExtension(name);
      final stem = ext.isEmpty
          ? name
          : name.substring(0, name.length - ext.length - 1);
      if (mounted) {
        Navigator.pop(context, PickedFile('$stem.$scanExtension', scan));
      }
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
    final resultPreview = _resultPreview;
    final blurred = (_blur ?? 0) > core.blurredAbove;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.scanTitle),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => Navigator.pop(context, _photo),
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
                      onPressed: () => Navigator.pop(context, _photo),
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
                if (blurred)
                  _BlurWarning(
                    onRetake: widget.retake == null ? null : _retake,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    _review ? l.scanFound : l.scanHelp,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _review && resultPreview != null
                        ? RawImage(image: resultPreview, fit: BoxFit.contain)
                        : _cornersEditor(img, preview, theme),
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
                          onChanged: _busy ? null : _setEnhance,
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (_review)
                              TextButton(
                                onPressed: _busy
                                    ? null
                                    : () => setState(() => _review = false),
                                child: Text(l.scanAdjust),
                              )
                            else ...[
                              TextButton(
                                onPressed: _busy
                                    ? null
                                    : () => setState(() => _corners = _whole),
                                child: Text(l.scanWholePhoto),
                              ),
                              TextButton(
                                onPressed: _busy
                                    ? null
                                    : () =>
                                          setState(() => _corners = _detected),
                                child: Text(l.scanDetectAgain),
                              ),
                            ],
                            FilledButton.icon(
                              icon: _busy
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(_review ? Icons.check : Icons.crop),
                              label: Text(_review ? l.scanKeep : l.scanApply),
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

  Widget _cornersEditor(
    core.RgbaImage img,
    ui.Image preview,
    ThemeData theme,
  ) => LayoutBuilder(
    builder: (context, box) {
      final scale = math.min(
        box.maxWidth / img.width,
        box.maxHeight / img.height,
      );
      final w = img.width * scale, h = img.height * scale;
      final left = (box.maxWidth - w) / 2;
      final top = (box.maxHeight - h) / 2;
      core.ScanPoint toImage(Offset o) => (
        x: ((o.dx - left) / scale).clamp(0, img.width).toDouble(),
        y: ((o.dy - top) / scale).clamp(0, img.height).toDouble(),
      );
      Offset toScreen(core.ScanPoint p) =>
          Offset(left + p.x * scale, top + p.y * scale);
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (d) {
          var best = -1;
          var bestDist = 48.0;
          for (var i = 0; i < _corners.length; i++) {
            final dist = (toScreen(_corners[i]) - d.localPosition).distance;
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
                k == i ? toImage(d.localPosition) : _corners[k],
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
  );
}

/// « The photo looks blurred », with a way to take it again.
class _BlurWarning extends StatelessWidget {
  final VoidCallback? onRetake;

  const _BlurWarning({required this.onRetake});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      child: Semantics(
        liveRegion: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
          child: Row(
            children: [
              Icon(Icons.blur_on, color: scheme.onErrorContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.scanBlurred,
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
              ),
              if (onRetake != null)
                TextButton(onPressed: onRetake, child: Text(l.scanRetake)),
            ],
          ),
        ),
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
