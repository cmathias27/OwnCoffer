import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart'
    show LicenseEntry, LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'client.dart';
import 'l10n/app_localizations.dart';
import 'l10n/error_messages.dart';
import 'screens/home_screen.dart';
import 'screens/first_launch_screen.dart';
import 'screens/server_address_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/two_factor_screen.dart';
import 'state/app_lock.dart';
import 'state/pepite.dart';
import 'state/pepite_advice.dart';
import 'state/presence.dart';
import 'state/session.dart';
import 'assistant/chat_bubble.dart';
import 'util/server_address.dart';
import 'util/standalone.dart';
import 'util/standalone_backups.dart';
import 'widgets/app_lock_layer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(_dbIpLicense);
  // Before any page: a web page reloaded while locked stays locked.
  await appLock.load();
  askServerAddress = () async => runApp(
    OwnCofferApp(
      home: FirstLaunchScreen(
        standalone: standaloneAvailable,
        onServer: _askAddress,
        onStandalone: _startStandalone,
      ),
    ),
  );
  restartStandalone = _startStandalone;
  switchToServer = (api, session) async {
    await ServerAddress.save(api);
    await ServerAddress.saveMode('server');
    isStandalone = false;
    await initializeClient();
    await client.auth.updateSignedInUser(session);
    runApp(const OwnCofferApp());
  };
  // Windows and Android: the first launch asks how to work (decisions
  // 0020 and 0022); the web app is served by its server.
  if (ServerAddress.needed) {
    final mode = await ServerAddress.mode();
    if (mode == 'standalone' && standaloneAvailable) {
      await _startStandalone();
      return;
    }
    if (mode != 'server' || await ServerAddress.load() == null) {
      await askServerAddress();
      return;
    }
  }
  await _start();
}

Future<void> _start() async {
  await initializeClient();
  runApp(const OwnCofferApp());
}

Future<void> _askAddress() async => runApp(
  OwnCofferApp(
    home: ServerAddressScreen(
      onSaved: () async {
        await ServerAddress.saveMode('server');
        await _start();
      },
      onBack: standaloneAvailable ? askServerAddress : null,
    ),
  ),
);

/// Standalone mode: the server starts inside the app, the device's owner
/// is signed in, and their first group is created (decision 0022). A
/// failure or a step that never ends shows the reason instead of waiting
/// forever.
Future<void> _startStandalone() async {
  runApp(const OwnCofferApp(home: StartingScreen()));
  try {
    await _openStandalone();
  } on Object catch (e, stack) {
    debugPrint('Standalone start failed: $e\n$stack');
    runApp(
      OwnCofferApp(
        home: StartingScreen(
          error: '$e',
          onRetry: _startStandalone,
          onBack: askServerAddress,
        ),
      ),
    );
  }
}

Future<void> _openStandalone() async {
  // The first start creates the database: allow a slow phone some time.
  final local = await _step(
    'start',
    startStandalone(),
    const Duration(minutes: 3),
  );
  isStandalone = true;
  await initializeClient(url: local.api.toString());
  // A fresh session at each start: the server only answers this device.
  final session = await _step('sign-in', local.signIn());
  await _step(
    'session',
    client.auth.updateSignedInUser(AuthSuccess.fromJson(session)),
  );
  if ((await _step('groups', client.group.myGroups())).isEmpty) {
    final fr = PlatformDispatcher.instance.locale.languageCode != 'en';
    await _step(
      'group',
      client.group.create(fr ? 'Mes comptes' : 'My accounts'),
    );
  }
  await _step('mode', ServerAddress.saveMode('standalone'));
  runApp(const OwnCofferApp());
  // The daily encrypted backup, once the app is shown, then checked every
  // hour while it stays open.
  StandaloneBackups.schedule();
}

/// One step of the standalone start, named in the error shown if it fails
/// or takes longer than [limit].
Future<T> _step<T>(
  String name,
  Future<T> future, [
  Duration limit = const Duration(seconds: 30),
]) async {
  try {
    return await future.timeout(limit);
  } on TimeoutException {
    throw StandaloneStartError(name, 'no answer after ${limit.inSeconds} s');
  } on Object catch (e) {
    throw StandaloneStartError(name, e);
  }
}

class StandaloneStartError implements Exception {
  final String step;
  final Object cause;
  StandaloneStartError(this.step, this.cause);

  @override
  String toString() => '[$step] $cause';
}

/// Indigo main colour (docs/MAQUETTES.md).
const _brand = Color(0xFF3346C8);

ThemeData _buildTheme(Brightness brightness) {
  final base = ThemeData(
    // `fidelity` keeps the brand indigo instead of a desaturated tone.
    colorScheme: ColorScheme.fromSeed(
      seedColor: _brand,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ),
    fontFamily: 'Inter',
  );
  final scheme = base.colorScheme;
  final soft = BorderRadius.circular(16);
  // Titles and figures in Manrope, text in Inter (docs/MAQUETTES.md). The
  // soft look: round cards without hard shadow, round dialogs, filled
  // fields, pill chips, floating messages.
  return base.copyWith(
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(shape: const StadiumBorder()),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: soft),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: soft),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: soft,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: soft,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: soft,
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: soft,
        borderSide: BorderSide(color: scheme.error),
      ),
    ),
    textTheme: base.textTheme.copyWith(
      displayLarge: base.textTheme.displayLarge?.copyWith(
        fontFamily: 'Manrope',
      ),
      displayMedium: base.textTheme.displayMedium?.copyWith(
        fontFamily: 'Manrope',
      ),
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontFamily: 'Manrope',
      ),
      headlineLarge: base.textTheme.headlineLarge?.copyWith(
        fontFamily: 'Manrope',
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontFamily: 'Manrope',
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontFamily: 'Manrope',
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(fontFamily: 'Manrope'),
    ),
  );
}

/// The pages' navigator, for the chat window above them.
final _navigator = GlobalKey<NavigatorState>();

class OwnCofferApp extends StatelessWidget {
  /// Another first page (the server address of the native apps), shown
  /// before the client exists: no assistant bubble then.
  final Widget? home;

  const OwnCofferApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // French by default when the browser language is not supported.
      localeResolutionCallback: (locale, supported) => supported.firstWhere(
        (s) => s.languageCode == locale?.languageCode,
        orElse: () => const Locale('fr'),
      ),
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      navigatorKey: _navigator,
      // The assistant's bubble stays above every page, the lock above all.
      builder: home != null
          ? null
          : (context, child) => AppLockLayer(
              lock: appLock,
              child: ChatLayer(
                navigator: _navigator,
                child: child ?? const SizedBox(),
              ),
            ),
      home: home ?? const _Root(),
    );
  }
}

/// Shows the screen matching the session: setup, sign-in, code, or the app.
class _Root extends StatefulWidget {
  const _Root();

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  final _session = SessionController();

  @override
  void initState() {
    super.initState();
    _session.addListener(_followSession);
    _session.refresh();
  }

  @override
  void dispose() {
    _session.removeListener(_followSession);
    _session.dispose();
    super.dispose();
  }

  /// The lock applies to a signed-in session. Only a sign-out ends it: an
  /// error page (no network) under the lock must not lift it.
  /// Pépite too: where the user stands, and the reminder of this device.
  void _followSession() {
    final stage = _session.stage;
    final changed = stage != _followed;
    _followed = stage;
    switch (stage) {
      case SessionStage.ready:
        unawaited(appLock.attach(_session.signOut));
        if (changed) unawaited(pepite.signedIn());
        if (changed) unawaited(pepiteAdvice.signedIn());
        if (changed) unawaited(presence.attach());
      case SessionStage.signedOut || SessionStage.setup:
        appLock.detach();
        presence.detach();
        if (changed) unawaited(pepite.signedOut());
        if (changed) pepiteAdvice.signedOut();
      default:
        break;
    }
  }

  SessionStage? _followed;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _session,
    builder: (context, _) => switch (_session.stage) {
      SessionStage.loading => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      SessionStage.setup => SetupScreen(session: _session),
      SessionStage.signedOut => SignInScreen(session: _session),
      SessionStage.needsTwoFactor => TwoFactorScreen(session: _session),
      SessionStage.ready => HomeScreen(session: _session),
      SessionStage.error => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorText(AppLocalizations.of(context), _session.lastError!),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _session.refresh,
                child: Text(AppLocalizations.of(context).retry),
              ),
              if (ServerAddress.needed)
                TextButton(
                  onPressed: changeServer,
                  child: Text(AppLocalizations.of(context).serverAddressChange),
                ),
            ],
          ),
        ),
      ),
    },
  );
}

/// The places of the sessions come from DB-IP Lite City, shipped with the
/// server image (decision 0027); its licence asks to credit it.
Stream<LicenseEntry> _dbIpLicense() async* {
  yield const LicenseEntryWithLineBreaks(
    ['DB-IP Lite City'],
    'IP Geolocation by DB-IP (https://db-ip.com).\n\n'
    'The server of OwnCoffer finds the approximate city and country of a '
    'session in this database, without any outside service.\n\n'
    'Licensed under the Creative Commons Attribution 4.0 International '
    'License: https://creativecommons.org/licenses/by/4.0/',
  );
}
