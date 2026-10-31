import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

void openOrSaveFile(String name, String mimeType, Uint8List bytes) {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
  final url = web.URL.createObjectURL(blob);
  final viewable =
      mimeType == 'application/pdf' || mimeType.startsWith('image/');
  final a = web.HTMLAnchorElement()
    ..href = url
    ..rel = 'noopener';
  if (viewable) {
    a.target = '_blank';
  } else {
    a.download = name;
  }
  a.click();
  // Let the new tab or the download start before freeing the URL.
  Future<void>.delayed(
    const Duration(minutes: 1),
    () => web.URL.revokeObjectURL(url),
  );
}
