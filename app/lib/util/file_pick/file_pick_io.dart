import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;

import '../file_pick.dart';

// Windows and Android: the system's file dialog; on Android, [camera] opens
// the camera app instead (Windows has none to offer: see canUseCamera).

/// Android (and iOS) phones open the camera; Windows has only the file
/// dialog.
bool get canUseCamera => Platform.isAndroid || Platform.isIOS;

XTypeGroup _group(List<String> extensions) => XTypeGroup(
  label: 'OwnCoffer',
  extensions: [for (final e in extensions) e.replaceFirst('.', '')],
);

Future<PickedFile?> pickFile(
  List<String> extensions, {
  bool camera = false,
}) async {
  if (camera && canUseCamera) {
    // A photo of a few MB at most: the scan keeps 2000 px, and the server
    // takes 10 MB per file.
    final photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 3000,
      maxHeight: 3000,
      imageQuality: 85,
    );
    if (photo == null) return null;
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return PickedFile(
      'photo-${now.year}${two(now.month)}${two(now.day)}-'
      '${two(now.hour)}${two(now.minute)}${two(now.second)}.jpg',
      await photo.readAsBytes(),
    );
  }
  final f = await openFile(
    acceptedTypeGroups: [if (extensions.isNotEmpty) _group(extensions)],
  );
  if (f == null) return null;
  return PickedFile(f.name, await f.readAsBytes());
}

Future<List<PickedFile>> pickFiles(List<String> extensions) async {
  final files = await openFiles(
    acceptedTypeGroups: [if (extensions.isNotEmpty) _group(extensions)],
  );
  return [for (final f in files) PickedFile(f.name, await f.readAsBytes())];
}
