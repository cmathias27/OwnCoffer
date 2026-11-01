import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart' show RgbaImage;

import 'image_codec/image_codec_stub.dart'
    if (dart.library.js_interop) 'image_codec/image_codec_web.dart'
    if (dart.library.io) 'image_codec/image_codec_io.dart'
    as impl;

/// Decodes a photo (JPEG, PNG, WebP), turned upright from its EXIF
/// orientation, its longer side at most [maxSide] pixels. Done by the
/// device, nothing is sent anywhere.
Future<RgbaImage> decodeImage(Uint8List bytes, {int maxSide = 4000}) =>
    impl.decodeImage(bytes, maxSide);

/// Compressed file of a scanned document: JPEG on the web (quality 0 to 1),
/// PNG in the native apps. Its extension is [scanExtension].
Future<Uint8List> encodeScan(RgbaImage image, {double quality = 0.85}) =>
    impl.encodeScan(image, quality);

/// `jpg` or `png`, see [encodeScan].
String get scanExtension => impl.scanExtension;
