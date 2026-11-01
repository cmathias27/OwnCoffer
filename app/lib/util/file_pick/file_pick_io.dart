import 'package:file_selector/file_selector.dart';

import '../file_pick.dart';

// Windows and Android: the system's file dialog. [camera] has no meaning
// here: Android's dialog offers the camera itself when images are accepted.

XTypeGroup _group(List<String> extensions) => XTypeGroup(
  label: 'OwnCoffer',
  extensions: [for (final e in extensions) e.replaceFirst('.', '')],
);

Future<PickedFile?> pickFile(
  List<String> extensions, {
  bool camera = false,
}) async {
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
