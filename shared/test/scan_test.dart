import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

/// A dark image with a light quadrilateral [q] (convex, clockwise).
RgbaImage _photo(int w, int h, List<ScanPoint> q) {
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
      final light = inside(x + 0.5, y + 0.5);
      final p = (y * w + x) * 4;
      img.pixels[p] = light ? 235 : 40;
      img.pixels[p + 1] = light ? 230 : 45;
      img.pixels[p + 2] = light ? 225 : 50;
      img.pixels[p + 3] = 255;
    }
  }
  return img;
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
}
