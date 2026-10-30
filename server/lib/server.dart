import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/cache_busting.dart';
import 'src/generated/serverpod.dart';
import 'src/web/routes/app_config_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Email/password authentication. No third-party email service: until
      // SMTP sending is implemented (phase 2), verification codes are only
      // written to the server log, and only outside production.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _logVerificationCode,
        sendPasswordResetVerificationCode: _logPasswordResetCode,
      ),
    ],
  );

  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  // Behind the single-port proxy (decision 0015) the app calls the API on
  // the same origin, under OWNCOFFER_API_PATH (e.g. `/api/`).
  pod.webServer.addRoute(
    AppConfigRoute(
      apiConfig: pod.config.apiServer,
      sameOriginPath: Platform.environment['OWNCOFFER_API_PATH'],
    ),
    '/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under /.
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      '/',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    final defaultRoute = StaticRoute.file(
      File(
        Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
      ),
    );

    pod.webServer.addMiddleware(
      FallbackMiddleware(
        fallback: defaultRoute,
        on: (response) => response.statusCode == 404,
      ).call,
      '/',
    );

    pod.webServer.addRoute(
      defaultRoute,
      '/**',
    );
  }

  // File storage stays in the local PostgreSQL database: no cloud provider,
  // no outgoing network call.
  pod.addCloudStorage(DatabaseCloudStorage('private'));
  pod.addCloudStorage(DatabaseCloudStorage('public'));

  // Start the server.
  await pod.start();
}

void _logVerificationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  if (session.serverpod.runMode == ServerpodRunMode.production) return;
  session.log('[EmailIdp] Registration code for $email: $verificationCode');
}

void _logPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  if (session.serverpod.runMode == ServerpodRunMode.production) return;
  session.log('[EmailIdp] Password reset code for $email: $verificationCode');
}
