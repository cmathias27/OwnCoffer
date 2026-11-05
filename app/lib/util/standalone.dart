import 'standalone/standalone_stub.dart'
    if (dart.library.io) 'standalone/standalone_io.dart'
    as impl;

/// Whether this build carries the embedded server (decision 0022): the
/// Windows and Android apps; never the web app.
bool get standaloneAvailable => impl.standaloneAvailable;

/// Starts the server inside the app, on this device's private folder.
/// Returns its address and a session for the device's owner (the JSON of
/// an AuthSuccess).
Future<({Uri api, Future<Map<String, dynamic>> Function() signIn})>
startStandalone() => impl.startStandalone();

/// An encrypted backup of everything on this device, documents included,
/// written as [name] in [folder] (a path, or a folder chosen on Android);
/// the ten newest kept. Returns where it was written.
Future<String> standaloneBackupTo(
  String folder,
  String name,
  String passphrase,
  Map<String, Object?> metadata,
) => impl.standaloneBackupTo(folder, name, passphrase, metadata);

/// Replaces this device's data by the backup at [path] (from
/// [pickBackupFile]); the server is stopped: start the standalone mode
/// again afterwards.
Future<void> standaloneRestore(String path, String passphrase) =>
    impl.standaloneRestore(path, passphrase);

/// A backup file chosen by the user, or null.
Future<String?> pickBackupFile() => impl.pickBackupFile();

/// The restore was cancelled: the copy of [path] made on Android goes.
Future<void> forgetPickedBackup(String path) => impl.forgetPickedBackup(path);

Future<String> defaultBackupFolder() => impl.defaultBackupFolder();

Future<String?> chooseBackupFolder() => impl.chooseBackupFolder();

bool get canChooseBackupFolder => impl.canChooseBackupFolder;

/// [folder] as the user reads it.
String folderLabel(String folder) => impl.folderLabel(folder);

/// Sends a copy of the newest backup of [folder]; false if there is none.
Future<bool> shareLatestBackup(String folder) => impl.shareLatestBackup(folder);

/// The passphrase did not open the backup (or the file was changed).
bool isWrongPassphrase(Object e) => impl.isWrongPassphrase(e);

/// The backup comes from a newer version of the app: update this one first.
bool isBackupTooNew(Object e) => impl.isBackupTooNew(e);

/// Whether the embedded server is running (false after a restore stopped
/// it, even a failed one: the app must start it again).
bool get standaloneRunning => impl.standaloneRunning;
