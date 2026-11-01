import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:serverpod_auth_idp_server/core.dart';

import 'src/auth/email_config.dart';
import 'src/generated/serverpod.dart';
import 'src/standalone/local_owner.dart';
import 'src/standalone/sqlite_migrations.g.dart';
import 'src/startup.dart';

/// The OwnCoffer server running inside the Windows or Android app, on a
/// SQLite file, for one person on one device (decision 0022). Same
/// endpoints, same engine as the Docker server; only this device may call
/// it.
class EmbeddedServer {
  final Serverpod pod;

  /// Where the app's client sends its calls (random local port).
  final Uri api;

  EmbeddedServer._(this.pod, this.api);

  /// A session for the device's owner, as the JSON of an AuthSuccess (the
  /// app turns it into its own client class).
  Future<Map<String, dynamic>> signIn() async {
    final session = await pod.createSession(enableLogging: false);
    try {
      return (await LocalOwner.signIn(session)).toJson();
    } finally {
      await session.close();
    }
  }

  Future<void> stop() => pod.shutdown(exitProcess: false);

  /// Starts the server on [dataDir], the app's private folder: it receives
  /// the secrets (config/passwords.yaml, created once and never sent), the
  /// migrations (written at each start) and the database file.
  static Future<EmbeddedServer> start({
    required Directory dataDir,
    Map<String, String> migrations = sqliteMigrations,
  }) async {
    await dataDir.create(recursive: true);
    final config = Directory('${dataDir.path}/config')..createSync();
    final passwords = File('${config.path}/passwords.yaml');
    if (!passwords.existsSync()) {
      final random = Random.secure();
      String secret() =>
          base64Url.encode(List<int>.generate(32, (_) => random.nextInt(256)));
      passwords.writeAsStringSync('''
shared:
  serviceSecret: '${secret()}'
  emailSecretHashPepper: '${secret()}'
  jwtHmacSha512PrivateKey: '${secret()}'
  jwtRefreshTokenHashPepper: '${secret()}'
''');
    }
    final dir = Directory('${dataDir.path}/migrations');
    if (dir.existsSync()) await dir.delete(recursive: true);
    for (final e in migrations.entries) {
      final f = File('${dir.path}/${e.key}');
      await f.parent.create(recursive: true);
      await f.writeAsString(e.value);
    }

    final pod = Serverpod(
      const ['--apply-migrations'],
      serverDirectory: dataDir,
      config: ServerpodConfig(
        runMode: 'production',
        // Port 0: the system picks a free one at each start.
        apiServer: ServerConfig(
          port: 0,
          publicHost: '127.0.0.1',
          publicPort: 0,
          publicScheme: 'http',
        ),
        database: SqliteDatabaseConfig(
          filePath: '${dataDir.path}/owncoffer.db',
        ),
        applyMigrations: true,
        // As the Docker server: a 10 MB document once base64-encoded.
        maxRequestSize: 14 * 1024 * 1024,
        // SQLite allows one writer: no session log in the database.
        sessionLogs: SessionLogConfig.buildDefault(
          databaseEnabled: false,
          runMode: 'production',
        ),
      ),
    );
    pod.initializeAuthServices(
      tokenManagerBuilders: [JwtConfigFromPasswords()],
      identityProviderBuilders: [buildEmailIdpConfig()],
    );
    // Documents stay in the database file, as on the Docker server.
    pod.addCloudStorage(DatabaseCloudStorage('private'));
    pod.addCloudStorage(DatabaseCloudStorage('public'));
    // Serverpod listens on every interface: only this device may talk to it.
    pod.server.addMiddleware((Handler next) {
      return (Request req) async {
        if (!isLocalBytes(req.connectionInfo.remote.address.bytes)) {
          return Response.forbidden(body: Body.fromString('local_only'));
        }
        return next(req);
      };
    });
    await pod.start();
    await afterStart(pod, announceSetup: false);
    final session = await pod.createSession(enableLogging: false);
    try {
      await LocalOwner.ensure(session);
    } finally {
      await session.close();
    }
    return EmbeddedServer._(
      pod,
      Uri.parse('http://127.0.0.1:${pod.server.port}/'),
    );
  }
}

/// This device only, from the raw address: 127.x.x.x, ::1, and 127.x.x.x
/// seen through an IPv6 socket (::ffff:127.0.0.1, however it is written),
/// as on any machine with IPv6.
bool isLocalBytes(List<int> b) {
  if (b.length == 4) return b[0] == 127;
  if (b.length != 16) return false;
  final zeros = b.take(10).every((x) => x == 0);
  if (zeros && b[10] == 0xff && b[11] == 0xff) return b[12] == 127;
  return zeros && b.skip(10).take(5).every((x) => x == 0) && b[15] == 1;
}

/// [isLocalBytes] of a written address; false if it is not one.
bool isLocalAddress(String address) {
  final ip = InternetAddress.tryParse(address.trim());
  return ip != null && isLocalBytes(ip.rawAddress);
}
