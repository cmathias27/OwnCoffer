import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/apps_screen.dart';
import 'package:owncoffer_app/screens/home_screen.dart';
import 'package:owncoffer_app/util/app_update.dart';
import 'package:owncoffer_app/util/app_update/app_update_io.dart';
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

/// A release on a fake GitHub: [files] by name, their sums unless [sums].
MockClient _github(
  Map<String, List<int>> files, {
  String? sums,
  List<String>? asked,
}) => MockClient((request) async {
  asked?.add(request.url.toString());
  final name = request.url.pathSegments.last;
  if (name == 'SHA256SUMS') {
    return http.Response(
      sums ??
          [
            for (final e in files.entries)
              '${sha256.convert(e.value)}  ${e.key}',
          ].join('\n'),
      200,
    );
  }
  final body = files[name];
  return body == null ? http.Response('', 404) : http.Response.bytes(body, 200);
});

class _FakeUpdater implements AppUpdater {
  @override
  final String? platform;
  final Object? fails;
  final String? newest;
  final calls = <String>[];

  _FakeUpdater({this.platform = 'android', this.fails, this.newest});

  @override
  bool get supported => platform != null;

  @override
  bool get restarts => platform == 'windows';

  @override
  Future<String?> latest() async {
    calls.add('latest');
    return newest;
  }

  @override
  Future<AppUpdateReady> prepare(
    String version, {
    AppUpdateProgress? progress,
  }) async {
    calls.add('prepare $version');
    progress?.call(0.5);
    if (fails != null) throw fails!;
    return AppUpdateReady(version, '/cache/updates/x.apk');
  }

  @override
  Future<void> install(AppUpdateReady ready) async =>
      calls.add('install ${ready.version}');

  @override
  Future<void> cleanup() async {}
}

void main() {
  tearDown(() => AppVersions.appForTests = null);

  group('pure helpers', () {
    test('sums, file names and the latest version', () {
      final hex = 'A' * 64;
      expect(
        AppUpdates.parseSums(
          '$hex  owncoffer-1.17.0-android.apk\n'
          '${'b' * 64} *owncoffer-1.17.0-windows-x64.zip\r\n'
          'garbage line\n',
        ),
        {
          'owncoffer-1.17.0-android.apk': 'a' * 64,
          'owncoffer-1.17.0-windows-x64.zip': 'b' * 64,
        },
      );
      expect(
        AppUpdates.sums('1.17.0').toString(),
        'https://github.com/cmathias27/OwnCoffer/releases/download/v1.17.0/'
        'SHA256SUMS',
      );
      expect(
        AppUpdates.fileName('1.17.0', 'windows'),
        'owncoffer-1.17.0-windows-x64.zip',
      );
      expect(
        AppUpdates.versionFromLocation(
          'https://github.com/cmathias27/OwnCoffer/releases/tag/v1.17.0',
        ),
        '1.17.0',
      );
      expect(AppUpdates.versionFromLocation('https://example.org/'), isNull);
      expect(AppUpdates.versionFromLocation(null), isNull);
    });

    test('Windows: only a folder of the app is swapped', () {
      expect(
        AppUpdates.foreignEntries(
          ['owncoffer.exe', 'Flutter_Windows.dll', 'data'],
          ['owncoffer.exe', 'flutter_windows.dll', 'data', 'new.dll'],
        ),
        isEmpty,
      );
      expect(
        AppUpdates.foreignEntries(
          ['owncoffer.exe', 'data', 'holidays.jpg'],
          ['owncoffer.exe', 'data'],
        ),
        ['holidays.jpg'],
      );
      expect(AppUpdates.safeWindowsPath(r'C:\Users\Zoé\OwnCoffer'), isTrue);
      expect(AppUpdates.safeWindowsPath(r'C:\100%\OwnCoffer'), isFalse);
      expect(AppUpdates.safeWindowsPath(r'C:\a"b'), isFalse);
    });

    test('Windows: the script waits, swaps, falls back', () {
      final script = AppUpdates.windowsScript(
        pid: 4242,
        current: r'C:\Apps\OwnCoffer',
        fresh: r'C:\Apps\OwnCoffer.update',
        previous: r'C:\Apps\OwnCoffer.previous',
        exe: 'owncoffer.exe',
      );
      final lines = script.split('\r\n');
      expect(lines, contains(r'set "CUR=C:\Apps\OwnCoffer"'));
      expect(lines, contains(r'set "NEW=C:\Apps\OwnCoffer.update"'));
      expect(lines, contains(r'set "OLD=C:\Apps\OwnCoffer.previous"'));
      expect(script, contains('find " 4242 "'));
      // Old folder aside, new one in place, started; else put back.
      final aside = lines.indexOf(
        'move "%CUR%" "%OLD%" >nul 2>&1 || goto fallback',
      );
      final inPlace = lines.indexOf(
        'move "%NEW%" "%CUR%" >nul 2>&1 || goto restore',
      );
      expect(aside, greaterThan(0));
      expect(inPlace, greaterThan(aside));
      expect(lines[inPlace + 1], r'start "" "%CUR%\owncoffer.exe"');
      expect(
        lines.sublist(lines.indexOf(':restore')),
        containsAllInOrder([
          'move "%OLD%" "%CUR%" >nul 2>&1',
          ':fallback',
          r'start "" "%NEW%\owncoffer.exe"',
        ]),
      );
    });
  });

  group('download', () {
    late Directory temp;
    setUp(() => temp = Directory.systemTemp.createTempSync('oc-update-'));
    tearDown(() => temp.deleteSync(recursive: true));

    IoAppUpdater updater(http.Client client, {String platform = 'android'}) =>
        IoAppUpdater(
          client: client,
          cache: () async => temp,
          platform: platform,
        );

    test('the APK of the release, checked, with its progress', () async {
      final apk = List<int>.generate(5000, (i) => i % 251);
      final asked = <String>[];
      final progress = <double?>[];
      final ready = await updater(
        _github({'owncoffer-1.17.0-android.apk': apk}, asked: asked),
      ).prepare('1.17.0', progress: progress.add);
      expect(asked, [
        'https://github.com/cmathias27/OwnCoffer/releases/download/v1.17.0/SHA256SUMS',
        'https://github.com/cmathias27/OwnCoffer/releases/download/v1.17.0/'
            'owncoffer-1.17.0-android.apk',
      ]);
      expect(ready.version, '1.17.0');
      expect(ready.path, endsWith('updates/owncoffer-1.17.0-android.apk'));
      expect(File(ready.path).readAsBytesSync(), apk);
      expect(progress.last, 1.0);
    });

    test('a file that does not match its sum is deleted', () async {
      final u = updater(
        _github(
          {'owncoffer-1.17.0-android.apk': utf8.encode('not the one')},
          sums: '${'0' * 64}  owncoffer-1.17.0-android.apk',
        ),
      );
      await expectLater(
        u.prepare('1.17.0'),
        throwsA(
          isA<AppUpdateException>().having((e) => e.code, 'code', 'checksum'),
        ),
      );
      expect(
        File('${temp.path}/updates/owncoffer-1.17.0-android.apk').existsSync(),
        isFalse,
      );
    });

    test('no sum, no file, too big: refused', () async {
      Future<String> code(http.Client c, {int? max}) async {
        try {
          await IoAppUpdater(
            client: c,
            cache: () async => temp,
            platform: 'android',
            maxBytes: max ?? AppUpdates.maxBytes,
          ).prepare('1.17.0');
          return 'none';
        } on AppUpdateException catch (e) {
          return e.code;
        }
      }

      expect(
        await code(
          _github({
            'owncoffer-1.17.0-android.apk': [1],
          }, sums: ''),
        ),
        'checksum',
      );
      expect(await code(_github({})), 'checksum');
      expect(
        await code(
          _github(
            {},
            sums: '${'0' * 64}  owncoffer-1.17.0-android.apk',
          ),
        ),
        'network',
      );
      expect(
        await code(
          _github({'owncoffer-1.17.0-android.apk': List.filled(2000, 7)}),
          max: 1000,
        ),
        'too_large',
      );
      expect(
        await code(MockClient((_) async => throw const SocketException('x'))),
        'network',
      );
    });

    test('the latest version, from where GitHub sends', () async {
      final asked = <String>[];
      final u = updater(
        MockClient((request) async {
          asked.add(request.url.toString());
          return http.Response(
            '',
            302,
            headers: {
              'location':
                  'https://github.com/cmathias27/OwnCoffer/releases/tag/v1.18.2',
            },
          );
        }),
      );
      expect(await u.latest(), '1.18.2');
      expect(asked, [
        'https://github.com/cmathias27/OwnCoffer/releases/latest',
      ]);
      await expectLater(
        updater(
          MockClient((_) async => throw http.ClientException('down')),
        ).latest(),
        throwsA(isA<AppUpdateException>()),
      );
    });
  });

  group('Windows', () {
    late Directory temp;
    late Directory app;
    late String exe;
    setUp(() {
      temp = Directory.systemTemp.createTempSync('oc-update-');
      app = Directory('${temp.path}/OwnCoffer')..createSync();
      exe = '${app.path}/owncoffer.exe';
      File(exe).writeAsStringSync('old');
      Directory('${app.path}/data').createSync();
    });
    tearDown(() => temp.deleteSync(recursive: true));

    IoAppUpdater updater({void Function(String script)? restarted}) =>
        IoAppUpdater(
          client: _github({
            'owncoffer-1.17.0-windows-x64.zip': utf8.encode('z'),
          }),
          cache: () async => Directory('${temp.path}/cache'),
          platform: 'windows',
          executable: () => exe,
          unzip: (zip, folder) async {
            File('$folder/owncoffer.exe').writeAsStringSync('new');
            Directory('$folder/data').createSync();
            return true;
          },
          restart: (script) async => restarted?.call(script),
        );

    test('unpacked next to the app, then the script', () async {
      String? script;
      final u = updater(restarted: (s) => script = s);
      expect(u.restarts, isTrue);
      final ready = await u.prepare('1.17.0');
      expect(ready.path, '${app.path}.update');
      expect(
        File('${app.path}.update/owncoffer.exe').readAsStringSync(),
        'new',
      );
      await u.install(ready);
      expect(script, contains('set "CUR=${app.path}"'));
      expect(script, contains('set "NEW=${app.path}.update"'));
      expect(script, contains('set "OLD=${app.path}.previous"'));
    });

    test('a folder holding anything else is never swapped', () async {
      File('${app.path}/holidays.jpg').writeAsStringSync('mine');
      await expectLater(
        updater().prepare('1.17.0'),
        throwsA(
          isA<AppUpdateException>().having((e) => e.code, 'code', 'folder'),
        ),
      );
      expect(Directory('${app.path}.update').existsSync(), isFalse);
      expect(File('${app.path}/holidays.jpg').existsSync(), isTrue);
    });

    test('at start: only folders of the app are deleted', () async {
      final previous = Directory('${app.path}.previous')..createSync();
      File('${previous.path}/owncoffer.exe').writeAsStringSync('older');
      final notOurs = Directory('${app.path}.update')..createSync();
      File('${notOurs.path}/report.pdf').writeAsStringSync('mine');
      Directory('${temp.path}/cache/updates').createSync(recursive: true);
      await updater().cleanup();
      expect(previous.existsSync(), isFalse);
      expect(notOurs.existsSync(), isTrue);
      expect(Directory('${temp.path}/cache/updates').existsSync(), isFalse);
    });
  });

  group('screens', () {
    testWidgets('banner: « Installer », downloaded then installed', (
      tester,
    ) async {
      AppVersions.appForTests = '1.16.0';
      final u = _FakeUpdater();
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: AppUpdateBanner(serverVersion: '1.17.0', updater: u),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Télécharger'), findsNothing);
      await tester.tap(find.byKey(const Key('app-update-install')));
      await tester.pumpAndSettle();
      expect(u.calls, ['prepare 1.17.0', 'install 1.17.0']);
      expect(find.byKey(const Key('app-update-progress')), findsNothing);
      expect(find.textContaining('Android vous demande'), findsOneWidget);
    });

    testWidgets('Windows asks before closing; a failure says why', (
      tester,
    ) async {
      AppVersions.appForTests = '1.16.0';
      final win = _FakeUpdater(platform: 'windows');
      await tester.pumpWidget(
        _app(
          AppsScreen(serverVersion: '1.17.0', updater: win, standalone: false),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('apps-install')));
      await tester.pumpAndSettle();
      expect(find.textContaining('va se fermer'), findsOneWidget);
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();
      expect(win.calls, ['prepare 1.17.0']);
      await tester.tap(find.byKey(const Key('apps-install')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('app-update-restart')));
      await tester.pumpAndSettle();
      expect(win.calls.last, 'install 1.17.0');

      final opened = <Uri>[];
      await tester.pumpWidget(
        _app(
          AppsScreen(
            key: const Key('second'),
            serverVersion: '1.17.0',
            updater: _FakeUpdater(fails: const AppUpdateException('checksum')),
            standalone: false,
            open: opened.add,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('apps-install')));
      await tester.pumpAndSettle();
      expect(find.text('Mise à jour impossible'), findsOneWidget);
      expect(find.textContaining('empreinte publiée'), findsOneWidget);
      await tester.tap(find.text('Télécharger à la main'));
      await tester.pumpAndSettle();
      expect(opened.single.pathSegments.last, 'owncoffer-1.17.0-android.apk');
    });

    testWidgets('standalone: looks for the latest version when asked', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      AppVersions.appForTests = '1.16.0';
      final none = _FakeUpdater(newest: '1.16.0');
      await tester.pumpWidget(
        _app(AppsScreen(serverVersion: null, updater: none, standalone: true)),
      );
      await tester.pumpAndSettle();
      expect(none.calls, isEmpty);
      await tester.tap(find.byKey(const Key('apps-check-latest')));
      await tester.pumpAndSettle();
      expect(
        find.text('Vous avez la dernière version publiée.'),
        findsOneWidget,
      );

      final newer = _FakeUpdater(newest: '1.18.0');
      await tester.pumpWidget(
        _app(
          AppsScreen(
            key: const Key('newer'),
            serverVersion: null,
            updater: newer,
            standalone: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('apps-check-latest')));
      await tester.pumpAndSettle();
      expect(find.text('Nouvelle version publiée : 1.18.0'), findsOneWidget);
      await tester.tap(find.byKey(const Key('apps-install')));
      await tester.pumpAndSettle();
      expect(newer.calls, ['latest', 'prepare 1.18.0', 'install 1.18.0']);
    });
  });
}
