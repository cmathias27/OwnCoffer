import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'client.dart';
import 'l10n/app_localizations.dart';
import 'l10n/error_messages.dart';
import 'screens/home_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/two_factor_screen.dart';
import 'state/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  // Titles and figures in Manrope, text in Inter (docs/MAQUETTES.md).
  return base.copyWith(
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

class OwnCofferApp extends StatelessWidget {
  const OwnCofferApp({super.key});

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
      home: const _Root(),
    );
  }
}

/// Placeholder until the operations screens (phase 3).

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
            ],
          ),
        ),
      ),
    },
  );
}
