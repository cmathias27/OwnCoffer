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
