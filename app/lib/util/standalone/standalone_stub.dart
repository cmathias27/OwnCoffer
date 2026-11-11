bool get standaloneAvailable => false;

Never _unavailable() => throw UnsupportedError(
  'The standalone mode needs the Windows or Android app.',
);

Future<({Uri api, Future<Map<String, dynamic>> Function() signIn})>
startStandalone() async => _unavailable();

Future<String> standaloneBackupTo(
  String folder,
  String name,
  String passphrase,
  Map<String, Object?> metadata,
) async => _unavailable();

Future<void> standaloneRestore(String path, String passphrase) async =>
    _unavailable();

Future<String?> pickBackupFile() async => null;

Future<void> forgetPickedBackup(String path) async {}

Future<String> defaultBackupFolder() async => _unavailable();

Future<String?> chooseBackupFolder() async => null;

bool get canChooseBackupFolder => false;

String folderLabel(String folder) => folder;

Future<bool> shareLatestBackup(String folder) async => false;

bool isWrongPassphrase(Object e) => false;

bool isBackupTooNew(Object e) => false;

bool get standaloneRunning => false;

Future<void> stopStandalone() async {}
