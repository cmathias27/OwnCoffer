import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:owncoffer_shared/owncoffer_shared.dart' show RgbaImage;

/// Flutter has no JPEG encoder: the native apps keep scans as PNG.
const scanExtension = 'png';

Future<RgbaImage> decodeImage(Uint8List bytes, int maxSide) async {
  final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
  final descriptor = await ui.ImageDescriptor.encoded(buffer);
  try {
    final w0 = descriptor.width, h0 = descriptor.height;
    if (w0 == 0 || h0 == 0) throw const FormatException('Empty image');
    final scale = math.min(1.0, maxSide / math.max(w0, h0));
    // The platform codecs turn the photo upright (EXIF orientation).
    final codec = await descriptor.instantiateCodec(
      targetWidth: math.max(1, (w0 * scale).round()),
      targetHeight: math.max(1, (h0 * scale).round()),
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final out = RgbaImage(
      image.width,
      image.height,
      Uint8List.fromList(data!.buffer.asUint8List()),
    );
    image.dispose();
    codec.dispose();
    return out;
  } finally {
    descriptor.dispose();
    buffer.dispose();
  }
}

Future<Uint8List> encodeScan(RgbaImage image, double quality) async {
  final done = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    image.pixels,
    image.width,
    image.height,
    ui.PixelFormat.rgba8888,
    done.complete,
  );
  final img = await done.future;
  final png = await img.toByteData(format: ui.ImageByteFormat.png);
  img.dispose();
  if (png == null) throw const FormatException('PNG encoding failed');
  return png.buffer.asUint8List();
}
