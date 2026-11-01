import 'dart:typed_data';

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

/// An encrypted backup of everything on this device.
Future<Uint8List> standaloneBackup(
  String passphrase,
  Map<String, Object?> metadata,
) => impl.standaloneBackup(passphrase, metadata);

/// Replaces this device's data by a backup (the server is stopped; start
/// the standalone mode again afterwards).
Future<void> standaloneRestore(Uint8List file, String passphrase) =>
    impl.standaloneRestore(file, passphrase);

Future<String> defaultBackupFolder() => impl.defaultBackupFolder();

Future<String?> chooseBackupFolder() => impl.chooseBackupFolder();

bool get canChooseBackupFolder => impl.canChooseBackupFolder;

Future<String> writeBackup(String folder, String name, Uint8List bytes) =>
    impl.writeBackup(folder, name, bytes);

Future<({String name, Uint8List bytes})?> latestBackup(String folder) =>
    impl.latestBackup(folder);

/// The passphrase did not open the backup (or the file was changed).
bool isWrongPassphrase(Object e) => impl.isWrongPassphrase(e);
