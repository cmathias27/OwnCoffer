import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const OwnCofferApp());
}

/// Indigo main colour (docs/MAQUETTES.md).
const _brand = Color(0xFF3346C8);

ThemeData _buildTheme(Brightness brightness) => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _brand, brightness: brightness),
);

class OwnCofferApp extends StatelessWidget {
  const OwnCofferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OwnCoffer',
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
        title: const Text('OwnCoffer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => client.auth.signOutDevice(),
          ),
        ],
      ),
    );
  }
}
