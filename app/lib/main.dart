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
import 'screens/outbox_screen.dart';
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
import 'state/ui_prefs.dart';
import 'theme/app_theme.dart';
import 'assistant/chat_bubble.dart';
import 'util/offline.dart';
import 'util/outbox.dart';
import 'util/server_address.dart';
import 'util/standalone.dart';
import 'util/standalone_backups.dart';
import 'widgets/offline_banner.dart';
import 'widgets/app_lock_layer.dart';
import 'widgets/app_update_flow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(_dbIpLicense);
  LicenseRegistry.addLicense(_sqlite3mcLicense);
  // Decision 0032: the update just installed is running; forget the
  // download and the previous folder.
  unawaited(appUpdater.cleanup());
  // Before any page: a web page reloaded while locked stays locked.
  await appLock.load();
  await uiPrefs.load();
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
    final keyLost = e is StandaloneStartError && isDatabaseKeyLost(e.cause);
    runApp(
      OwnCofferApp(
        home: StartingScreen(
          error: '$e',
          onRetry: _startStandalone,
          onBack: askServerAddress,
          onSetAside: keyLost
              ? () async {
                  await setAsideLockedDatabase();
                  await _startStandalone();
                }
              : null,
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

/// The pages' navigator, for the chat window above them.
final _navigator = GlobalKey<NavigatorState>();

class OwnCofferApp extends StatelessWidget {
  /// Another first page (the server address of the native apps), shown
  /// before the client exists: no assistant bubble then.
  final Widget? home;

  const OwnCofferApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    // Large text and high contrast change the whole app at once.
    return ListenableBuilder(
      listenable: uiPrefs,
      builder: (context, _) => MaterialApp(
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
        theme: buildAppTheme(
          Brightness.light,
          highContrast: uiPrefs.highContrast,
        ),
        darkTheme: buildAppTheme(
          Brightness.dark,
          highContrast: uiPrefs.highContrast,
        ),
        highContrastTheme: buildAppTheme(Brightness.light, highContrast: true),
        highContrastDarkTheme: buildAppTheme(
          Brightness.dark,
          highContrast: true,
        ),
        themeMode: ThemeMode.system,
        navigatorKey: _navigator,
        // The assistant's bubble stays above every page, the lock above all.
        builder: home != null
            ? (context, child) => _LargeText(child: child ?? const SizedBox())
            : (context, child) => _LargeText(
                child: AppLockLayer(
                  lock: appLock,
                  child: OfflineBanner(
                    onOpenOutbox: () => _navigator.currentState?.push(
                      MaterialPageRoute<void>(
                        builder: (_) => const OutboxScreen(),
                      ),
                    ),
                    child: ChatLayer(
                      navigator: _navigator,
                      child: child ?? const SizedBox(),
                    ),
                  ),
                ),
              ),
        home: home ?? const _Root(),
      ),
    );
  }
}

/// « Grands caractères » (decision 0041, point 18): on top of the size
/// chosen in the system.
class _LargeText extends StatelessWidget {
  final Widget child;
  const _LargeText({required this.child});

  @override
  Widget build(BuildContext context) {
    final scale = uiPrefs.textScale;
    if (scale == 1) return child;
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        textScaler: TextScaler.linear(media.textScaler.scale(14) / 14 * scale),
      ),
      child: child,
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
        final user = client.auth.authInfo?.authUserId;
        if (changed && user != null) unawaited(outbox.signedIn('$user'));
      case SessionStage.signedOut || SessionStage.setup:
        appLock.detach();
        presence.detach();
        // Signed out: nothing read under this account stays on the device.
        if (changed) unawaited(clearOfflineStore());
        // Entries not sent stay for this account's next sign-in, unless
        // the user chose to drop them when signing out.
        if (changed) outbox.signedOut();
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
                  onPressed: () => changeServerAfterOutbox(context),
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

/// The Windows and Android apps carry SQLite3 Multiple Ciphers, which
/// encrypts the standalone database (decision 0033); MIT licence.
Stream<LicenseEntry> _sqlite3mcLicense() async* {
  yield const LicenseEntryWithLineBreaks(
    ['SQLite3 Multiple Ciphers'],
    'MIT License\n\n'
    'Copyright (c) 2019-2026 Ulrich Telle\n\n'
    'Permission is hereby granted, free of charge, to any person obtaining '
    'a copy of this software and associated documentation files (the '
    '"Software"), to deal in the Software without restriction, including '
    'without limitation the rights to use, copy, modify, merge, publish, '
    'distribute, sublicense, and/or sell copies of the Software, and to '
    'permit persons to whom the Software is furnished to do so, subject to '
    'the following conditions:\n\n'
    'The above copyright notice and this permission notice shall be '
    'included in all copies or substantial portions of the Software.\n\n'
    'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, '
    'EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF '
    'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. '
    'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY '
    'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, '
    'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE '
    'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.',
  );
}
