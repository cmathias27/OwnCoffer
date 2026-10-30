import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'l10n/app_localizations.dart';
import 'screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const OwnCofferApp());
}

/// Indigo main colour (docs/MAQUETTES.md).
const _brand = Color(0xFF3346C8);

ThemeData _buildTheme(Brightness brightness) {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _brand,
      brightness: brightness,
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
      home: SignInScreen(child: const _Home()),
    );
  }
}

/// Placeholder until the operations screens (phase 3).
class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appTitle),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).signOut,
            icon: const Icon(Icons.logout),
            onPressed: () => client.auth.signOutDevice(),
          ),
        ],
      ),
    );
  }
}
