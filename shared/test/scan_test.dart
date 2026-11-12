import 'dart:math' as math;

import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

/// A dark image with a light quadrilateral [q] (convex, clockwise).
RgbaImage _photo(
  int w,
  int h,
  List<ScanPoint> q, {
  int light = 235,
  int dark = 40,
}) {
  final img = RgbaImage.blank(w, h);
  bool inside(double x, double y) {
    for (var i = 0; i < 4; i++) {
      final a = q[i], b = q[(i + 1) % 4];
      if ((b.x - a.x) * (y - a.y) - (b.y - a.y) * (x - a.x) < 0) return false;
    }
    return true;
  }

  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final on = inside(x + 0.5, y + 0.5);
      final p = (y * w + x) * 4;
      img.pixels[p] = on ? light : dark;
      img.pixels[p + 1] = on ? light - 5 : dark + 5;
      img.pixels[p + 2] = on ? light - 10 : dark + 10;
      img.pixels[p + 3] = 255;
    }
  }
  return img;
}

/// Corners of a [halfWidth] × [halfHeight] rectangle centred on
/// ([cx], [cy]) and turned by [degrees], clockwise on screen.
List<ScanPoint> _turned(
  double cx,
  double cy,
  double halfWidth,
  double halfHeight,
  double degrees,
) {
  final a = degrees * math.pi / 180;
  final c = math.cos(a), s = math.sin(a);
  return [
    for (final (dx, dy) in [
      (-halfWidth, -halfHeight),
      (halfWidth, -halfHeight),
      (halfWidth, halfHeight),
      (-halfWidth, halfHeight),
    ])
      (x: cx + dx * c - dy * s, y: cy + dx * s + dy * c),
  ];
}

/// [found] are [expected] within 3 pixels, in the same clockwise order;
/// with [anyStart], the first corner may be any of them.
void _expectCorners(
  List<ScanPoint> found,
  List<ScanPoint> expected, {
  bool anyStart = false,
}) {
  expect(found, hasLength(4));
  var shift = 0;
  if (anyStart) {
    double gap(ScanPoint a, ScanPoint b) =>
        math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    for (var k = 1; k < 4; k++) {
      if (gap(found[0], expected[k]) < gap(found[0], expected[shift])) {
        shift = k;
      }
    }
  }
  for (var i = 0; i < 4; i++) {
    final e = expected[(i + shift) % 4];
    expect(found[i].x, closeTo(e.x, 3), reason: 'corner $i x');
    expect(found[i].y, closeTo(e.y, 3), reason: 'corner $i y');
  }
}

/// White paper with lines of dark "letters" (2 to 4 pixels wide).
RgbaImage _print(int w, int h) {
  final img = RgbaImage.blank(w, h);
  final random = math.Random(7);
  img.pixels.fillRange(0, img.pixels.length, 245);
  for (var top = 8; top + 12 < h; top += 20) {
    var x = 8;
    while (x + 8 < w) {
      final width = 2 + random.nextInt(3);
      final height = 6 + random.nextInt(7);
      for (var y = top; y < top + height; y++) {
        for (var xx = x; xx < x + width; xx++) {
          final p = (y * w + xx) * 4;
          img.pixels
            ..[p] = 20
            ..[p + 1] = 20
            ..[p + 2] = 20;
        }
      }
      x += width + 2 + random.nextInt(5);
    }
  }
  return img;
}

/// [img] averaged over (2·[r] + 1)² squares (a copy).
RgbaImage _boxBlur(RgbaImage img, int r) {
  final w = img.width, h = img.height;
  final out = RgbaImage.blank(w, h);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      for (var c = 0; c < 3; c++) {
        var sum = 0, count = 0;
        for (var yy = math.max(0, y - r); yy <= math.min(h - 1, y + r); yy++) {
          for (
            var xx = math.max(0, x - r);
            xx <= math.min(w - 1, x + r);
            xx++
          ) {
            sum += img.pixels[(yy * w + xx) * 4 + c];
            count++;
          }
        }
        out.pixels[(y * w + x) * 4 + c] = sum ~/ count;
      }
      out.pixels[(y * w + x) * 4 + 3] = 255;
    }
  }
  return out;
}

void main() {
  final paper = <ScanPoint>[
    (x: 60, y: 30),
    (x: 230, y: 50),
    (x: 250, y: 270),
    (x: 40, y: 250),
  ];

  test('finds the corners of a sheet on a darker background', () {
    final found = detectDocument(_photo(300, 300, paper));
    for (var i = 0; i < 4; i++) {
      expect(found[i].x, closeTo(paper[i].x, 3), reason: 'corner $i x');
      expect(found[i].y, closeTo(paper[i].y, 3), reason: 'corner $i y');
    }
  });

  test('no sheet: the whole image, slightly inset', () {
    final flat = RgbaImage.blank(100, 50);
    final found = detectDocument(flat);
    expect(found.first, (x: 5.0, y: 2.5));
    expect(found[2], (x: 95.0, y: 47.5));
  });

  test('the perspective sends the rectangle onto the corners', () {
    final t = perspectiveFromRect(paper, 200, 300);
    ScanPoint map(double u, double v) {
      final d = t[6] * u + t[7] * v + 1;
      return (
        x: (t[0] * u + t[1] * v + t[2]) / d,
        y: (t[3] * u + t[4] * v + t[5]) / d,
      );
    }

    final r = [map(0, 0), map(200, 0), map(200, 300), map(0, 300)];
    for (var i = 0; i < 4; i++) {
      expect(r[i].x, closeTo(paper[i].x, 1e-6));
      expect(r[i].y, closeTo(paper[i].y, 1e-6));
    }
    expect(
      () => perspectiveFromRect(
        [
          (x: 0, y: 0),
          (x: 1, y: 1),
          (x: 2, y: 2),
          (x: 3, y: 3),
        ],
        10,
        10,
      ),
      throwsArgumentError,
    );
  });

  test('straightened: only paper is left, sized by its sides', () {
    final src = _photo(300, 300, paper);
    final size = scanOutputSize(paper);
    expect(size.width, 211, reason: 'longest of top and bottom sides');
    expect(size.height, 221);
    final out = warpDocument(src, paper, size.width, size.height);
    var dark = 0;
    for (var i = 0; i < size.width * size.height; i++) {
      if (out.pixels[i * 4] < 128) dark++;
    }
    // Only the anti-aliased border may touch the background.
    expect(dark / (size.width * size.height), lessThan(0.02));
    expect(scanOutputSize(paper, maxSide: 100).height, 100);
  });

  test('contrast: paper white, ink dark', () {
    final img = RgbaImage.blank(10, 10);
    for (var i = 0; i < 100; i++) {
      final v = i < 20 ? 90 : 180;
      img.pixels
        ..[i * 4] = v
        ..[i * 4 + 1] = v
        ..[i * 4 + 2] = v
        ..[i * 4 + 3] = 255;
    }
    enhanceDocument(img);
    expect(img.pixels[0], 0);
    expect(img.pixels[99 * 4], 255);
  });

  test('shrunk by averaging blocks', () {
    final img = RgbaImage.blank(4, 2);
    for (var i = 0; i < 8; i++) {
      img.pixels[i * 4] = i.isEven ? 0 : 200;
    }
    final small = shrinkImage(img, 2);
    expect((small.width, small.height), (2, 1));
    expect(small.pixels[0], 100);
    expect(identical(shrinkImage(img, 10), img), isTrue);
  });

  group('found for sure (decision 0039)', () {
    test('a straight sheet', () {
      final d = findDocument(_photo(300, 300, paper));
      expect(d.sure, isTrue);
      _expectCorners(d.corners, paper);
    });

    test('a ticket turned by 40°, which diagonals alone miss', () {
      final turned = _turned(150, 150, 45, 105, 40);
      final d = findDocument(_photo(300, 300, turned));
      expect(d.sure, isTrue);
      _expectCorners(d.corners, turned, anyStart: true);
    });

    test('printed lines on the ticket do not matter', () {
      final ticket = _turned(150, 150, 60, 120, -12);
      final img = _photo(300, 300, ticket);
      // Dark lines across the middle of the ticket, as print.
      for (var y = 70; y < 230; y += 9) {
        for (var x = 120; x < 180; x++) {
          for (var t = 0; t < 2; t++) {
            final p = ((y + t) * 300 + x) * 4;
            img.pixels
              ..[p] = 30
              ..[p + 1] = 30
              ..[p + 2] = 30;
          }
        }
      }
      final d = findDocument(img);
      expect(d.sure, isTrue);
      _expectCorners(d.corners, ticket, anyStart: true);
    });

    test('a ticket cut by the frame: found, but not for sure', () {
      final cut = <ScanPoint>[
        (x: 80, y: -40),
        (x: 220, y: -40),
        (x: 220, y: 260),
        (x: 80, y: 260),
      ];
      final d = findDocument(_photo(300, 300, cut));
      expect(d.sure, isFalse);
      expect(d.corners.first.x, closeTo(80, 3));
      expect(d.corners.first.y, closeTo(0, 3));
    });

    test('too little contrast: not for sure', () {
      final d = findDocument(_photo(300, 300, paper, light: 125, dark: 100));
      expect(d.sure, isFalse);
      _expectCorners(d.corners, paper);
    });

    test('a round light spot is not a sheet', () {
      final img = RgbaImage.blank(300, 300);
      for (var y = 0; y < 300; y++) {
        for (var x = 0; x < 300; x++) {
          final dx = (x - 150) / 110, dy = (y - 150) / 80;
          final v = dx * dx + dy * dy <= 1 ? 230 : 40;
          final p = (y * 300 + x) * 4;
          img.pixels
            ..[p] = v
            ..[p + 1] = v
            ..[p + 2] = v
            ..[p + 3] = 255;
        }
      }
      expect(findDocument(img).sure, isFalse);
    });

    test('nothing to find: not for sure', () {
      expect(findDocument(RgbaImage.blank(100, 50)).sure, isFalse);
    });
  });

  group('blur (decision 0039)', () {
    test('sharp print is sharp, blurred print is blurred', () {
      final sharp = _print(600, 400);
      final level = blurLevel(sharp)!;
      expect(level, lessThan(blurredAbove));
      final blurred = _boxBlur(_boxBlur(_print(600, 400), 3), 3);
      expect(blurLevel(blurred)!, greaterThan(blurredAbove));
      expect(blurLevel(blurred)!, greaterThan(level));
    });

    test('only within the corners', () {
      final img = _print(600, 400);
      // Left half blurred, right half sharp.
      final left = _boxBlur(_boxBlur(_print(600, 400), 3), 3);
      for (var y = 0; y < 400; y++) {
        for (var x = 0; x < 300; x++) {
          for (var c = 0; c < 4; c++) {
            img.pixels[(y * 600 + x) * 4 + c] =
                left.pixels[(y * 600 + x) * 4 + c];
          }
        }
      }
      ScanPoint p(double x, double y) => (x: x, y: y);
      final leftPart = [p(10, 10), p(280, 10), p(280, 390), p(10, 390)];
      final rightPart = [p(320, 10), p(590, 10), p(590, 390), p(320, 390)];
      expect(blurLevel(img, within: leftPart)!, greaterThan(blurredAbove));
      expect(blurLevel(img, within: rightPart)!, lessThan(blurredAbove));
    });

    test('a blank sheet cannot tell', () {
      final img = RgbaImage.blank(200, 200);
      img.pixels.fillRange(0, img.pixels.length, 240);
      expect(blurLevel(img), isNull);
      expect(blurLevel(_print(200, 200), within: [(x: 0, y: 0)]), isNull);
    });
  });

  test('contrast: a shadow over half the ticket is evened out', () {
    // Paper from 250 (left) down to 110 (right, in the shadow); print at
    // 45 % of the paper around it: darker than the shadowed paper on the
    // left only.
    const w = 240, h = 120;
    final img = RgbaImage.blank(w, h);
    final ink = <int>{};
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        final light = 250 - 140 * x / (w - 1);
        final printed = y % 12 < 3 && x % 10 < 6;
        if (printed) ink.add(y * w + x);
        final v = (printed ? light * 0.45 : light).round();
        final p = (y * w + x) * 4;
        img.pixels
          ..[p] = v
          ..[p + 1] = v
          ..[p + 2] = v
          ..[p + 3] = 255;
      }
    }
    enhanceDocument(img);
    for (var i = 0; i < w * h; i++) {
      final v = img.pixels[i * 4];
      if (ink.contains(i)) {
        expect(v, lessThan(60), reason: 'ink at ${i % w}');
      } else {
        expect(v, greaterThan(200), reason: 'paper at ${i % w}');
      }
    }
  });

  test('contrast: faded thermal print comes out dark', () {
    final img = RgbaImage.blank(100, 100);
    for (var i = 0; i < 100 * 100; i++) {
      final printed = (i ~/ 100) % 10 < 2 && i % 7 < 4;
      final v = printed ? 190 : 225;
      img.pixels
        ..[i * 4] = v
        ..[i * 4 + 1] = v
        ..[i * 4 + 2] = v - 10
        ..[i * 4 + 3] = 255;
    }
    enhanceDocument(img);
    expect(img.pixels[0], lessThan(30), reason: 'print');
    expect(img.pixels[(5 * 100 + 5) * 4], greaterThan(240), reason: 'paper');
  });
}
