import 'standalone/standalone_stub.dart'
    if (dart.library.io) 'standalone/standalone_io.dart'
    as impl;

/// TRIAL (decision 0022): whether this build carries the embedded server
/// (Windows and Android; never the web app).
bool get standaloneAvailable => impl.standaloneAvailable;

/// TRIAL: see standalone_io.dart.
Future<Uri?> startStandaloneTrial() => impl.startStandaloneTrial();
