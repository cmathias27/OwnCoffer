import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart' show RgbaImage;

import 'image_codec/image_codec_stub.dart'
    if (dart.library.js_interop) 'image_codec/image_codec_web.dart'
    as impl;

/// Decodes a photo (JPEG, PNG, WebP), turned upright from its EXIF
/// orientation, its longer side at most [maxSide] pixels. Done by the
/// device, nothing is sent anywhere.
Future<RgbaImage> decodeImage(Uint8List bytes, {int maxSide = 4000}) =>
    impl.decodeImage(bytes, maxSide);

/// JPEG of [image] (quality 0 to 1).
Future<Uint8List> encodeJpeg(RgbaImage image, {double quality = 0.85}) =>
    impl.encodeJpeg(image, quality);
