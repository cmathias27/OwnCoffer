import 'dart:async';
import 'dart:js_interop';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart' show RgbaImage;
import 'package:web/web.dart' as web;

Future<RgbaImage> decodeImage(Uint8List bytes, int maxSide) async {
  final blob = web.Blob([bytes.toJS].toJS);
  final url = web.URL.createObjectURL(blob);
  try {
    final img = web.HTMLImageElement()..src = url;
    // Browsers draw an <img> upright (EXIF orientation applied).
    await img.decode().toDart;
    final w0 = img.naturalWidth, h0 = img.naturalHeight;
    if (w0 == 0 || h0 == 0) throw const FormatException('Empty image');
    final scale = math.min(1.0, maxSide / math.max(w0, h0));
    final w = math.max(1, (w0 * scale).round());
    final h = math.max(1, (h0 * scale).round());
    final canvas = web.HTMLCanvasElement()
      ..width = w
      ..height = h;
    final ctx = canvas.getContext('2d')! as web.CanvasRenderingContext2D;
    ctx.drawImage(img, 0, 0, w, h);
    final data = ctx.getImageData(0, 0, w, h).data.toDart;
    return RgbaImage(w, h, Uint8List.fromList(data));
  } finally {
    web.URL.revokeObjectURL(url);
  }
}

Future<Uint8List> encodeJpeg(RgbaImage image, double quality) async {
  final canvas = web.HTMLCanvasElement()
    ..width = image.width
    ..height = image.height;
  final ctx = canvas.getContext('2d')! as web.CanvasRenderingContext2D;
  final data = web.ImageData(
    Uint8ClampedList.sublistView(image.pixels).toJS,
    image.width,
  );
  ctx.putImageData(data, 0, 0);
  final done = Completer<Uint8List>();
  canvas.toBlob(
    (web.Blob? blob) {
      if (blob == null) {
        done.completeError(const FormatException('JPEG encoding failed'));
        return;
      }
      blob.arrayBuffer().toDart.then(
        (b) => done.complete(b.toDart.asUint8List()),
        onError: done.completeError,
      );
    }.toJS,
    'image/jpeg',
    quality.toJS,
  );
  return done.future;
}
