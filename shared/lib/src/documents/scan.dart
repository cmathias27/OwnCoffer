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

/// What [findDocument] saw in a photo.
class DocumentDetection {
  /// Clockwise from the top left, in pixels of the analysed image.
  final List<ScanPoint> corners;

  /// A whole four-sided sheet, clearly lighter than what surrounds it and
  /// filling its outline: the crop can be applied without asking
  /// (decision 0039). The corners stay adjustable either way.
  final bool sure;

  const DocumentDetection(this.corners, {required this.sure});
}

/// Corners of a document photographed on a darker background, clockwise
/// from the top left; the whole image (slightly inset) when no clear
/// document is found. Meant for a small preview (≈ 400 px): the user
/// can adjust the corners anyway. See [findDocument].
List<ScanPoint> detectDocument(RgbaImage img) => findDocument(img).corners;

/// [detectDocument], and whether the document was found for sure.
///
/// The paper is told apart by its lightness (Otsu threshold on a lightly
/// smoothed image, so that the print does not cut it into pieces); the
/// largest light region is kept, preferring one that does not run along
/// most of the frame (a light table). Its corners are those of the
/// largest quadrilateral inscribed in its convex outline, which follows
/// a tilted or turned ticket as well as a straight one.
DocumentDetection findDocument(RgbaImage img) {
  final w = img.width, h = img.height;
  final unsure = DocumentDetection([
    (x: w * 0.05, y: h * 0.05),
    (x: w * 0.95, y: h * 0.05),
    (x: w * 0.95, y: h * 0.95),
    (x: w * 0.05, y: h * 0.95),
  ], sure: false);
  if (w < 8 || h < 8) return unsure;
  final n = w * h;

  final luma = Uint8List(n);
  for (var i = 0; i < n; i++) {
    final p = i * 4;
    luma[i] =
        (img.pixels[p] * 299 +
            img.pixels[p + 1] * 587 +
            img.pixels[p + 2] * 114) ~/
        1000;
  }
  // 3 × 3 average.
  final gray = Uint8List(n);
  final histogram = List<int>.filled(256, 0);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      var sum = 0, count = 0;
      for (var yy = math.max(0, y - 1); yy <= math.min(h - 1, y + 1); yy++) {
        for (var xx = math.max(0, x - 1); xx <= math.min(w - 1, x + 1); xx++) {
          sum += luma[yy * w + xx];
          count++;
        }
      }
      final g = sum ~/ count;
      gray[y * w + x] = g;
      histogram[g]++;
    }
  }
  final threshold = _otsu(histogram, n);

  // 4-connected light regions, with the sides of the frame each touches.
  final label = Int32List(n);
  final sizes = <int>[0];
  final sides = <int>[0];
  final stack = <int>[];
  for (var start = 0; start < n; start++) {
    if (gray[start] <= threshold || label[start] != 0) continue;
    final current = sizes.length;
    var size = 0, touched = 0;
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

      if (x > 0) {
        visit(i - 1);
      } else {
        touched |= 1;
      }
      if (x < w - 1) {
        visit(i + 1);
      } else {
        touched |= 2;
      }
      if (y > 0) {
        visit(i - w);
      } else {
        touched |= 4;
      }
      if (y < h - 1) {
        visit(i + w);
      } else {
        touched |= 8;
      }
    }
    sizes.add(size);
    sides.add(touched);
  }
  int countSides(int mask) =>
      (mask & 1) + (mask >> 1 & 1) + (mask >> 2 & 1) + (mask >> 3 & 1);
  var best = 0;
  bool better(int c) {
    if (best == 0) return true;
    final framed = countSides(sides[c]) <= 2,
        bestFramed = countSides(sides[best]) <= 2;
    if (framed != bestFramed) return framed;
    return sizes[c] > sizes[best];
  }

  for (var c = 1; c < sizes.length; c++) {
    if (sizes[c] >= n * 0.08 && better(c)) best = c;
  }
  // No paper, or the whole frame (no background): no guess.
  if (best == 0 || sizes[best] > n * 0.97) return unsure;

  // Outline row by row (print inside the paper does not matter).
  final points = <ScanPoint>[];
  var spanArea = 0;
  var inside = 0, outside = 0;
  for (var y = 0; y < h; y++) {
    var left = -1, right = -1;
    for (var x = 0; x < w; x++) {
      final i = y * w + x;
      if (label[i] == best) {
        if (left < 0) left = x;
        right = x;
        inside += luma[i];
      } else {
        outside += luma[i];
      }
    }
    if (left < 0) continue;
    spanArea += right - left + 1;
    points
      ..add((x: left.toDouble(), y: y.toDouble()))
      ..add((x: left.toDouble(), y: y + 1.0))
      ..add((x: right + 1.0, y: y.toDouble()))
      ..add((x: right + 1.0, y: y + 1.0));
  }
  final hull = _convexHull(points);
  if (hull.length < 4) return unsure;
  final corners = _clockwiseFromTopLeft(_largestQuad(hull));
  final quadArea = _area(corners);
  if (quadArea < n * 0.05) return unsure;

  final size = sizes[best];
  final contrast = inside / size - outside / math.max(1, n - size);
  final fill = spanArea / quadArea;
  final sure =
      sides[best] == 0 &&
      contrast >= 40 &&
      fill >= 0.9 &&
      fill <= 1.1 &&
      quadArea / _area(hull) >= 0.95 &&
      _anglesBetween(corners, 40, 140);
  return DocumentDetection(corners, sure: sure);
}

/// Convex hull (Andrew's monotone chain), without collinear points.
List<ScanPoint> _convexHull(List<ScanPoint> points) {
  final p = [...points]
    ..sort((a, b) => a.x != b.x ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
  double cross(ScanPoint o, ScanPoint a, ScanPoint b) =>
      (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x);
  final hull = <ScanPoint>[];
  for (final pass in [p, p.reversed.toList()]) {
    final start = hull.length;
    for (final q in pass) {
      while (hull.length >= start + 2 &&
          cross(hull[hull.length - 2], hull.last, q) <= 0) {
        hull.removeLast();
      }
      hull.add(q);
    }
    hull.removeLast();
  }
  return hull;
}

/// The largest quadrilateral with its corners on the convex polygon [hull]
/// (at least 4 points), found in O(n²): for two opposite corners, the best
/// third and fourth corners only move forward along the outline.
List<ScanPoint> _largestQuad(List<ScanPoint> hull) {
  final n = hull.length;
  ScanPoint at(int i) => hull[i % n];
  double triangle(int a, int b, int c) {
    final p = at(a), q = at(b), r = at(c);
    return ((q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x)).abs();
  }

  var best = -1.0;
  var quad = hull.sublist(0, 4);
  for (var i = 0; i < n; i++) {
    var j = i + 1, l = i + 3;
    for (var k = i + 2; k <= i + n - 2; k++) {
      while (j + 1 < k && triangle(i, j + 1, k) >= triangle(i, j, k)) {
        j++;
      }
      if (l <= k) l = k + 1;
      while (l + 1 < i + n && triangle(k, l + 1, i) >= triangle(k, l, i)) {
        l++;
      }
      final area = triangle(i, j, k) + triangle(k, l, i);
      if (area > best) {
        best = area;
        quad = [at(i), at(j), at(k), at(l)];
      }
    }
  }
  return quad;
}

/// [quad] (convex) ordered clockwise on screen, starting with the corner
/// nearest the top left.
List<ScanPoint> _clockwiseFromTopLeft(List<ScanPoint> quad) {
  final cx = quad.fold(0.0, (s, p) => s + p.x) / quad.length;
  final cy = quad.fold(0.0, (s, p) => s + p.y) / quad.length;
  final sorted = [...quad]
    ..sort(
      (a, b) => math
          .atan2(a.y - cy, a.x - cx)
          .compareTo(math.atan2(b.y - cy, b.x - cx)),
    );
  var first = 0;
  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i].x + sorted[i].y < sorted[first].x + sorted[first].y) {
      first = i;
    }
  }
  return [...sorted.sublist(first), ...sorted.sublist(0, first)];
}

/// Whether every inner angle of [quad] is within [low]–[high] degrees.
bool _anglesBetween(List<ScanPoint> quad, double low, double high) {
  for (var i = 0; i < 4; i++) {
    final p = quad[(i + 3) % 4], q = quad[i], r = quad[(i + 1) % 4];
    final ax = p.x - q.x, ay = p.y - q.y, bx = r.x - q.x, by = r.y - q.y;
    final norms = math.sqrt((ax * ax + ay * ay) * (bx * bx + by * by));
    if (norms == 0) return false;
    final angle =
        math.acos(((ax * bx + ay * by) / norms).clamp(-1.0, 1.0)) *
        180 /
        math.pi;
    if (angle < low || angle > high) return false;
  }
  return true;
}

/// Blur level above which a photo is said to be blurred (decision 0039).
const blurredAbove = 0.5;

/// How blurred [img] looks, from 0 (sharp) to 1 (no detail left), within
/// the bounding box of [within] when given; null when there is too little
/// detail to tell (a blank sheet).
///
/// No-reference measure of Crété-Roffet et al. (2007): the image is
/// blurred again (9 pixels) and the loss of variation between neighbours
/// is measured; a sharp image loses much, a blurred one little.
/// Differences under 4 levels (sensor noise) are ignored.
double? blurLevel(RgbaImage img, {List<ScanPoint>? within}) {
  var x0 = 0, y0 = 0, x1 = img.width, y1 = img.height;
  if (within != null && within.isNotEmpty) {
    x0 = within.map((p) => p.x).reduce(math.min).floor().clamp(0, img.width);
    x1 = within.map((p) => p.x).reduce(math.max).ceil().clamp(0, img.width);
    y0 = within.map((p) => p.y).reduce(math.min).floor().clamp(0, img.height);
    y1 = within.map((p) => p.y).reduce(math.max).ceil().clamp(0, img.height);
  }
  final w = x1 - x0, h = y1 - y0;
  if (w < 16 || h < 16) return null;
  final f = Float64List(w * h);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final p = ((y + y0) * img.width + x + x0) * 4;
      f[y * w + x] =
          (img.pixels[p] * 299 +
              img.pixels[p + 1] * 587 +
              img.pixels[p + 2] * 114) /
          1000;
    }
  }

  // One direction: [count] lines of [length] pixels, [step] apart along
  // a line and [stride] apart between lines.
  ({double variation, double kept}) direction(
    int count,
    int length,
    int step,
    int stride,
  ) {
    var variation = 0.0, kept = 0.0;
    final line = Float64List(length), blurred = Float64List(length);
    for (var c = 0; c < count; c++) {
      for (var i = 0; i < length; i++) {
        line[i] = f[c * stride + i * step];
      }
      for (var i = 0; i < length; i++) {
        var sum = 0.0;
        for (var k = -4; k <= 4; k++) {
          sum += line[(i + k).clamp(0, length - 1)];
        }
        blurred[i] = sum / 9;
      }
      for (var i = 1; i < length; i++) {
        final d = (line[i] - line[i - 1]).abs();
        if (d < 4) continue;
        final b = (blurred[i] - blurred[i - 1]).abs();
        variation += d;
        kept += math.max(0, d - b);
      }
    }
    return (variation: variation, kept: kept);
  }

  final across = direction(h, w, 1, w);
  final down = direction(w, h, w, 1);
  // A direction with too little detail (under one edge per two lines, on
  // average) is not measured.
  final levels = [
    if (across.variation >= h * 50)
      (across.variation - across.kept) / across.variation,
    if (down.variation >= w * 50) (down.variation - down.kept) / down.variation,
  ];
  return levels.isEmpty ? null : levels.reduce(math.max);
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

/// A paper document made easier to read, in place: the lighting is evened
/// out (shadow of the phone, paper lit from one side), then the levels
/// are stretched so that the paper is white and the ink dark (2 % of the
/// pixels clipped on each side), colours kept. Faded thermal print comes
/// out dark again (decision 0039).
void enhanceDocument(RgbaImage img) {
  final p = img.pixels;
  final n = img.width * img.height;
  if (n == 0) return;
  _evenLighting(img);
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

/// Divides each pixel by the paper's colour around it. The paper's colour
/// is the lightest value of cells of about 1/24 of the image, then of
/// their neighbours (so that a large logo is not taken for paper),
/// interpolated between cell centres.
void _evenLighting(RgbaImage img) {
  final w = img.width, h = img.height, p = img.pixels;
  final cell = math.max(8, math.max(w, h) ~/ 24);
  final gw = (w + cell - 1) ~/ cell, gh = (h + cell - 1) ~/ cell;
  final lightest = Uint8List(gw * gh * 3);
  for (var y = 0; y < h; y++) {
    final row = y ~/ cell * gw;
    for (var x = 0; x < w; x++) {
      final g = (row + x ~/ cell) * 3, j = (y * w + x) * 4;
      for (var c = 0; c < 3; c++) {
        if (p[j + c] > lightest[g + c]) lightest[g + c] = p[j + c];
      }
    }
  }
  final paper = Float64List(gw * gh * 3);
  for (var gy = 0; gy < gh; gy++) {
    for (var gx = 0; gx < gw; gx++) {
      for (var c = 0; c < 3; c++) {
        var v = 0;
        for (
          var yy = math.max(0, gy - 1);
          yy <= math.min(gh - 1, gy + 1);
          yy++
        ) {
          for (
            var xx = math.max(0, gx - 1);
            xx <= math.min(gw - 1, gx + 1);
            xx++
          ) {
            v = math.max(v, lightest[(yy * gw + xx) * 3 + c]);
          }
        }
        // A black page stays black rather than being blown up.
        paper[(gy * gw + gx) * 3 + c] = math.max(v, 32).toDouble();
      }
    }
  }
  for (var y = 0; y < h; y++) {
    final fy = ((y + 0.5) / cell - 0.5).clamp(0.0, gh - 1.0);
    final y0 = fy.floor(), y1 = math.min(y0 + 1, gh - 1), ty = fy - y0;
    for (var x = 0; x < w; x++) {
      final fx = ((x + 0.5) / cell - 0.5).clamp(0.0, gw - 1.0);
      final x0 = fx.floor(), x1 = math.min(x0 + 1, gw - 1), tx = fx - x0;
      final j = (y * w + x) * 4;
      for (var c = 0; c < 3; c++) {
        final a = paper[(y0 * gw + x0) * 3 + c];
        final b = paper[(y0 * gw + x1) * 3 + c];
        final d = paper[(y1 * gw + x0) * 3 + c];
        final e = paper[(y1 * gw + x1) * 3 + c];
        final top = a + (b - a) * tx, bottom = d + (e - d) * tx;
        final light = top + (bottom - top) * ty;
        p[j + c] = (p[j + c] * 255 / light).round().clamp(0, 255);
      }
    }
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
