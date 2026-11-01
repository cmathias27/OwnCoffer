import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/apps_screen.dart';
import 'package:owncoffer_app/screens/home_screen.dart';
import 'package:owncoffer_app/util/app_versions.dart';

Widget _app(Widget home) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  tearDown(() => AppVersions.appForTests = null);

  test('versions compared, links to the release of the server', () {
    expect(AppVersions.compare('1.0.2', '1.0.10'), -1);
    expect(AppVersions.compare('1.1.0', '1.0.9'), 1);
    expect(AppVersions.compare('v1.0.3', '1.0.3'), 0);
    expect(AppVersions.compare('1.0.3', 'dev'), isNull);
    expect(AppVersions.updateAvailable('1.0.2', '1.0.3'), isTrue);
    expect(AppVersions.updateAvailable('1.0.3', '1.0.3'), isFalse);
    expect(AppVersions.updateAvailable('1.0.4', '1.0.3'), isFalse);
    expect(AppVersions.updateAvailable('1.0.2', 'dev'), isFalse);
    expect(
      AppVersions.download('1.0.3', 'android').toString(),
      'https://github.com/cmathias27/OwnCoffer/releases/download/v1.0.3/'
      'owncoffer-1.0.3-android.apk',
    );
    expect(
      AppVersions.download('1.0.3', 'windows').toString(),
      endsWith('/v1.0.3/owncoffer-1.0.3-windows-x64.zip'),
    );
    expect(AppVersions.download('dev', 'android'), isNull);
    expect(
      AppVersions.releasePage('dev').toString(),
      'https://github.com/cmathias27/OwnCoffer/releases/latest',
    );
  });

  testWidgets('apps page: versions, a newer one, downloads', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    AppVersions.appForTests = '1.0.2';
    final opened = <Uri>[];
    await tester.pumpWidget(
      _app(AppsScreen(serverVersion: '1.0.3', open: opened.add)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cette application : 1.0.2'), findsOneWidget);
    expect(find.text('Serveur : 1.0.3'), findsOneWidget);
    expect(find.textContaining('nouvelle version'), findsOneWidget);
    await tester.tap(find.text('Télécharger').first);
    await tester.tap(find.text('Télécharger').last);
    expect(opened.map((u) => u.pathSegments.last), [
      'owncoffer-1.0.3-android.apk',
      'owncoffer-1.0.3-windows-x64.zip',
    ]);
  });

  testWidgets('banner: shown when the app is older, hidden by "Later"', (
    tester,
  ) async {
    AppVersions.appForTests = '1.0.2';
    await tester.pumpWidget(
      _app(const Scaffold(body: AppUpdateBanner(serverVersion: '1.0.3'))),
    );
    await tester.pumpAndSettle();
    expect(
      find.text("Nouvelle version de l'application : 1.0.3"),
      findsOneWidget,
    );
    await tester.tap(find.text('Plus tard'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nouvelle version'), findsNothing);

    AppVersions.appForTests = '1.0.3';
    await tester.pumpWidget(
      _app(const Scaffold(body: AppUpdateBanner(serverVersion: '1.0.3'))),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Nouvelle version'), findsNothing);
  });
}
