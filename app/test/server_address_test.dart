import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/server_address_screen.dart';
import 'package:owncoffer_app/util/server_address.dart';

void main() {
  group('server address of the native apps', () {
    String? api(String s) => ServerAddress.parse(s)?.toString();

    test('normalised to the API under /api/', () {
      expect(api('comptes.example.org'), 'https://comptes.example.org/api/');
      expect(
        api(' https://comptes.example.org/ '),
        'https://comptes.example.org/api/',
      );
      expect(
        api('https://comptes.example.org/api'),
        'https://comptes.example.org/api/',
      );
      expect(
        api('https://example.org:8443/owncoffer'),
        'https://example.org:8443/owncoffer/api/',
      );
    });

    test('plain http only on the device or the local network', () {
      expect(api('http://192.168.1.20:8095'), 'http://192.168.1.20:8095/api/');
      expect(api('http://localhost:8080'), 'http://localhost:8080/api/');
      expect(api('http://nas.local'), 'http://nas.local/api/');
      expect(api('http://172.20.0.4'), 'http://172.20.0.4/api/');
      expect(api('http://comptes.example.org'), isNull);
      expect(api('http://172.40.0.4'), isNull);
      expect(api('http://8.8.8.8'), isNull);
    });

    test('anything else refused', () {
      for (final bad in [
        '',
        'pas une adresse',
        'ftp://example.org',
        'https://',
        'https://x.org/?a=1',
      ]) {
        expect(api(bad), isNull, reason: bad);
      }
    });
  });

  testWidgets('first launch: refused, then no server answers', (tester) async {
    final checked = <Uri>[];
    var saved = 0;
    var answers = false;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ServerAddressScreen(
          onSaved: () async => saved++,
          check: (api) async {
            checked.add(api);
            return answers;
          },
        ),
      ),
    );
    await tester.enterText(
      find.byType(TextField),
      'http://comptes.example.org',
    );
    await tester.tap(find.text('Se connecter'));
    await tester.pump();
    expect(find.textContaining('https://'), findsWidgets);
    expect(checked, isEmpty);

    await tester.enterText(find.byType(TextField), 'comptes.example.org');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(checked.single.toString(), 'https://comptes.example.org/api/');
    expect(find.textContaining('Aucun serveur OwnCoffer'), findsOneWidget);
    expect(saved, 0);
  });
}
