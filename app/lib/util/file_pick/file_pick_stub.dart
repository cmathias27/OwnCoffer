import '../file_pick.dart';

bool get canUseCamera => false;

Future<PickedFile?> pickFile(
  List<String> extensions, {
  bool camera = false,
}) async =>
    throw UnsupportedError('File picking is only available on the web.');

Future<List<PickedFile>> pickFiles(List<String> extensions) async =>
    throw UnsupportedError('File picking is only available on the web.');
