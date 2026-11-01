import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Windows: the "Save as" dialog. Android: the system share sheet (save to
/// Files, a drive, an e-mail…), from a copy in the app's cache that the
/// system clears.
Future<void> openOrSaveFile(
  String name,
  String mimeType,
  Uint8List bytes,
) async {
  if (Platform.isAndroid || Platform.isIOS) {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: mimeType)]),
    );
    return;
  }
  final location = await getSaveLocation(suggestedName: name);
  if (location == null) return;
  await File(location.path).writeAsBytes(bytes, flush: true);
}
