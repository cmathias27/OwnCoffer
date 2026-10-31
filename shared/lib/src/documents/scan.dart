import 'dart:math' as math;
import 'dart:typed_data';

/// A point of an image, in pixels (fractions allowed).
typedef ScanPoint = ({double x, double y});

/// An image as RGBA bytes, 4 per pixel, rows from the top.
class RgbaImage {
  final int width;
  final int height;
  final Uint8List pixels;

  RgbaImage(this.width, this.height, this.pixels) {
    if (pixels.length != width * height * 4) {
      throw ArgumentError('RGBA buffer does not match the size');
    }
  }

  factory RgbaImage.blank(int width, int height) =>
      RgbaImage(width, height, Uint8List(width * height * 4));
}

/// Corners of a document photographed on a darker background, clockwise
/// from the top left; the whole image (slightly inset) when no clear
/// document is found. Meant for a small preview (≈ 300 px): the user
/// adjusts the corners anyway.
///
/// The paper is told apart by its lightness (Otsu threshold), the largest
/// light region is kept, and its corners are its extreme points along the
/// two diagonals.
List<ScanPoint> detectDocument(RgbaImage img) {
  final w = img.width, h = img.height;
  final fallback = <ScanPoint>[
    (x: w * 0.05, y: h * 0.05),
    (x: w * 0.95, y: h * 0.05),
    (x: w * 0.95, y: h * 0.95),
    (x: w * 0.05, y: h * 0.95),
  ];
  if (w < 8 || h < 8) return fallback;

  final gray = Uint8List(w * h);
  final histogram = List<int>.filled(256, 0);
  for (var i = 0; i < w * h; i++) {
    final p = i * 4;
    final g =
        (img.pixels[p] * 299 +
            img.pixels[p + 1] * 587 +
            img.pixels[p + 2] * 114) ~/
        1000;
    gray[i] = g;
    histogram[g]++;
  }
  final threshold = _otsu(histogram, w * h);

  // Largest 4-connected light region.
  final label = Int32List(w * h);
  var best = 0, bestSize = 0, current = 0;
  final stack = <int>[];
  for (var start = 0; start < w * h; start++) {
    if (gray[start] <= threshold || label[start] != 0) continue;
    current++;
    var size = 0;
    stack.add(start);
    label[start] = current;
    while (stack.isNotEmpty) {
      final i = stack.removeLast();
      size++;
      final x = i % w, y = i ~/ w;
      void visit(int j) {
        if (label[j] == 0 && gray[j] > threshold) {
          label[j] = current;
          stack.add(j);
        }
      }

      if (x > 0) visit(i - 1);
      if (x < w - 1) visit(i + 1);
      if (y > 0) visit(i - w);
      if (y < h - 1) visit(i + w);
    }
    if (size > bestSize) {
      bestSize = size;
      best = current;
    }
  }
  // Too small (no paper) or the whole frame (no background): no guess.
  if (bestSize < w * h * 0.08 || bestSize > w * h * 0.97) return fallback;

  var tl = (s: double.infinity, p: fallback[0]);
  var tr = (s: -double.infinity, p: fallback[1]);
  var br = (s: -double.infinity, p: fallback[2]);
  var bl = (s: double.infinity, p: fallback[3]);
  for (var i = 0; i < w * h; i++) {
    if (label[i] != best) continue;
    final x = (i % w).toDouble(), y = (i ~/ w).toDouble();
    final p = (x: x + 0.5, y: y + 0.5);
    if (x + y < tl.s) tl = (s: x + y, p: p);
    if (x + y > br.s) br = (s: x + y, p: p);
    if (x - y > tr.s) tr = (s: x - y, p: p);
    if (x - y < bl.s) bl = (s: x - y, p: p);
  }
  final corners = [tl.p, tr.p, br.p, bl.p];
  return _area(corners) < w * h * 0.05 ? fallback : corners;
}

int _otsu(List<int> histogram, int total) {
  var sum = 0.0;
  for (var i = 0; i < 256; i++) {
    sum += i * histogram[i];
  }
  var sumB = 0.0, wB = 0, best = 0.0, threshold = 127;
  for (var t = 0; t < 256; t++) {
    wB += histogram[t];
    if (wB == 0) continue;
    final wF = total - wB;
    if (wF == 0) break;
    sumB += t * histogram[t];
    final mB = sumB / wB, mF = (sum - sumB) / wF;
    final between = wB * wF * (mB - mF) * (mB - mF);
    if (between > best) {
      best = between;
      threshold = t;
    }
  }
  return threshold;
}

double _area(List<ScanPoint> q) {
  var a = 0.0;
  for (var i = 0; i < q.length; i++) {
    final p = q[i], n = q[(i + 1) % q.length];
    a += p.x * n.y - n.x * p.y;
  }
  return a.abs() / 2;
}

double _dist(ScanPoint a, ScanPoint b) =>
    math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));

/// Size of the straightened document for [corners] (clockwise from the top
/// left), its longer side at most [maxSide] pixels.
({int width, int height}) scanOutputSize(
  List<ScanPoint> corners, {
  int maxSide = 2000,
}) {
  final [tl, tr, br, bl] = corners;
  var w = math.max(_dist(tl, tr), _dist(bl, br));
  var h = math.max(_dist(tl, bl), _dist(tr, br));
  final longest = math.max(w, h);
  if (longest > maxSide) {
    w = w * maxSide / longest;
    h = h * maxSide / longest;
  }
  return (width: math.max(1, w.round()), height: math.max(1, h.round()));
}

/// The perspective transform sending the output rectangle (0,0)-(w,h) to
/// [corners] of the source: 8 coefficients of a homography (h33 = 1).
List<double> perspectiveFromRect(List<ScanPoint> corners, int w, int h) {
  final src = <ScanPoint>[
    (x: 0, y: 0),
    (x: w.toDouble(), y: 0),
    (x: w.toDouble(), y: h.toDouble()),
    (x: 0, y: h.toDouble()),
  ];
  // a·x + b·y + c − g·x·X − h·y·X = X ; d·x + e·y + f − g·x·Y − h·y·Y = Y
  final m = List.generate(8, (_) => List<double>.filled(9, 0));
  for (var i = 0; i < 4; i++) {
    final (x: x, y: y) = src[i];
    final (x: X, y: Y) = corners[i];
    m[2 * i]
      ..[0] = x
      ..[1] = y
      ..[2] = 1
      ..[6] = -x * X
      ..[7] = -y * X
      ..[8] = X;
    m[2 * i + 1]
      ..[3] = x
      ..[4] = y
      ..[5] = 1
      ..[6] = -x * Y
      ..[7] = -y * Y
      ..[8] = Y;
  }
  // Gaussian elimination with partial pivoting.
  for (var c = 0; c < 8; c++) {
    var pivot = c;
    for (var r = c + 1; r < 8; r++) {
      if (m[r][c].abs() > m[pivot][c].abs()) pivot = r;
    }
    if (m[pivot][c].abs() < 1e-12) {
      throw ArgumentError('Corners are aligned: no perspective');
    }
    final tmp = m[c];
    m[c] = m[pivot];
    m[pivot] = tmp;
    for (var r = 0; r < 8; r++) {
      if (r == c) continue;
      final f = m[r][c] / m[c][c];
      if (f == 0) continue;
      for (var k = c; k < 9; k++) {
        m[r][k] -= f * m[c][k];
      }
    }
  }
  return [for (var i = 0; i < 8; i++) m[i][8] / m[i][i]];
}

/// The document inside [corners] of [src], straightened to [width] ×
/// [height] (bilinear sampling).
RgbaImage warpDocument(
  RgbaImage src,
  List<ScanPoint> corners,
  int width,
  int height,
) {
  final t = perspectiveFromRect(corners, width, height);
  final out = RgbaImage.blank(width, height);
  final s = src.pixels, o = out.pixels;
  final sw = src.width, sh = src.height;
  var k = 0;
  for (var y = 0; y < height; y++) {
    final v = y + 0.5;
    for (var x = 0; x < width; x++) {
      final u = x + 0.5;
      final d = t[6] * u + t[7] * v + 1;
      var sx = (t[0] * u + t[1] * v + t[2]) / d - 0.5;
      var sy = (t[3] * u + t[4] * v + t[5]) / d - 0.5;
      sx = sx.clamp(0, sw - 1).toDouble();
      sy = sy.clamp(0, sh - 1).toDouble();
      final x0 = sx.floor(), y0 = sy.floor();
      final x1 = math.min(x0 + 1, sw - 1), y1 = math.min(y0 + 1, sh - 1);
      final fx = sx - x0, fy = sy - y0;
      final p00 = (y0 * sw + x0) * 4, p10 = (y0 * sw + x1) * 4;
      final p01 = (y1 * sw + x0) * 4, p11 = (y1 * sw + x1) * 4;
      for (var c = 0; c < 3; c++) {
        final top = s[p00 + c] + (s[p10 + c] - s[p00 + c]) * fx;
        final bottom = s[p01 + c] + (s[p11 + c] - s[p01 + c]) * fx;
        o[k + c] = (top + (bottom - top) * fy).round();
      }
      o[k + 3] = 255;
      k += 4;
    }
  }
  return out;
}

/// A paper document made easier to read: levels stretched so that the
/// paper is white and the ink dark (2 % of the pixels clipped on each
/// side), colours kept. In place.
void enhanceDocument(RgbaImage img) {
  final p = img.pixels;
  final n = img.width * img.height;
  if (n == 0) return;
  final histogram = List<int>.filled(256, 0);
  for (var i = 0; i < n; i++) {
    final j = i * 4;
    histogram[(p[j] * 299 + p[j + 1] * 587 + p[j + 2] * 114) ~/ 1000]++;
  }
  int at(double share) {
    var count = 0;
    for (var i = 0; i < 256; i++) {
      count += histogram[i];
      if (count >= n * share) return i;
    }
    return 255;
  }

  final low = at(0.02), high = at(0.98);
  if (high - low < 16) return;
  final table = Uint8List(256);
  for (var i = 0; i < 256; i++) {
    table[i] = ((i - low) * 255 / (high - low)).round().clamp(0, 255);
  }
  for (var i = 0; i < n; i++) {
    final j = i * 4;
    p[j] = table[p[j]];
    p[j + 1] = table[p[j + 1]];
    p[j + 2] = table[p[j + 2]];
  }
}

/// [img] reduced so that its longer side is at most [maxSide] (each pixel
/// the average of the block it covers); [img] itself when already small.
RgbaImage shrinkImage(RgbaImage img, int maxSide) {
  final longest = math.max(img.width, img.height);
  if (longest <= maxSide) return img;
  final scale = maxSide / longest;
  final w = math.max(1, (img.width * scale).round());
  final h = math.max(1, (img.height * scale).round());
  final out = RgbaImage.blank(w, h);
  final s = img.pixels, o = out.pixels;
  for (var y = 0; y < h; y++) {
    final y0 = y * img.height ~/ h;
    final y1 = math.max(y0 + 1, (y + 1) * img.height ~/ h);
    for (var x = 0; x < w; x++) {
      final x0 = x * img.width ~/ w;
      final x1 = math.max(x0 + 1, (x + 1) * img.width ~/ w);
      var r = 0, g = 0, b = 0;
      for (var yy = y0; yy < y1; yy++) {
        for (var xx = x0; xx < x1; xx++) {
          final p = (yy * img.width + xx) * 4;
          r += s[p];
          g += s[p + 1];
          b += s[p + 2];
        }
      }
      final n = (y1 - y0) * (x1 - x0);
      final q = (y * w + x) * 4;
      o[q] = r ~/ n;
      o[q + 1] = g ~/ n;
      o[q + 2] = b ~/ n;
      o[q + 3] = 255;
    }
  }
  return out;
}
