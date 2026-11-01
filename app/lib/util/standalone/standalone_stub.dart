bool get standaloneAvailable => false;

Future<({Uri api, Future<Map<String, dynamic>> Function() signIn})>
startStandalone() => throw UnsupportedError(
  'The standalone mode needs the Windows or Android app.',
);
