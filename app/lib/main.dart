import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'client.dart';
import 'l10n/app_localizations.dart';
import 'l10n/error_messages.dart';
import 'screens/home_screen.dart';
import 'screens/server_address_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/two_factor_screen.dart';
import 'state/session.dart';
import 'assistant/chat_bubble.dart';
import 'util/server_address.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  askServerAddress = () async =>
      runApp(OwnCofferApp(home: ServerAddressScreen(onSaved: _start)));
  // Windows and Android: the user's server is asked once (decision 0020).
  if (ServerAddress.needed && await ServerAddress.load() == null) {
    await askServerAddress();
    return;
  }
  await _start();
}

Future<void> _start() async {
  await initializeClient();
  runApp(const OwnCofferApp());
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
      // The assistant's bubble stays above every page.
      builder: home != null
          ? null
          : (context, child) => ChatLayer(
              navigator: _navigator,
              child: child ?? const SizedBox(),
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
    _session.refresh();
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

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
