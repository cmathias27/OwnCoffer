import 'dart:typed_data';

bool get standaloneAvailable => false;

Never _unavailable() => throw UnsupportedError(
  'The standalone mode needs the Windows or Android app.',
);

Future<({Uri api, Future<Map<String, dynamic>> Function() signIn})>
startStandalone() async => _unavailable();

Future<Uint8List> standaloneBackup(
  String passphrase,
  Map<String, Object?> metadata,
) async => _unavailable();

Future<void> standaloneRestore(Uint8List file, String passphrase) async =>
    _unavailable();

Future<String> defaultBackupFolder() async => _unavailable();

Future<String?> chooseBackupFolder() async => null;

bool get canChooseBackupFolder => false;

Future<String> writeBackup(
  String folder,
  String name,
  Uint8List bytes, {
  int keep = 10,
}) async => _unavailable();

Future<({String name, Uint8List bytes})?> latestBackup(String folder) async =>
    null;

bool isWrongPassphrase(Object e) => false;
