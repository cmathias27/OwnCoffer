import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart' show RgbaImage;

Future<RgbaImage> decodeImage(Uint8List bytes, int maxSide) async =>
    throw UnsupportedError('Image decoding is only available on the web.');

const scanExtension = 'jpg';

Future<Uint8List> encodeScan(RgbaImage image, double quality) async =>
    throw UnsupportedError('Image encoding is only available on the web.');
