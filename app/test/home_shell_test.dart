import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/navigation/sections.dart';
import 'package:owncoffer_app/screens/home_screen.dart';
import 'package:owncoffer_app/state/session.dart';
import 'package:owncoffer_app/theme/app_theme.dart';
import 'package:owncoffer_app/util/app_versions.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

// Decision 0041: the signed-in shell (sections, tabs, "+", search,
// shortcuts) and its look in dark mode. No server answers: every page
// shows as it does while loading or offline.

class _NoStorage implements ClientAuthSuccessStorage {
  @override
  Future<AuthSuccess?> get() async => null;
  @override
  Future<void> set(AuthSuccess? data) async {}
}

final _membership = GroupMembership(
  group: FinanceGroup(
    id: 1,
    name: 'Foyer',
    createdBy: UuidValue.fromString('00000000-0000-4000-8000-000000000000'),
  ),
  role: MemberRole.user,
);

SessionController _session() => SessionController()
  ..stage = SessionStage.ready
  ..groups = [_membership]
  ..currentGroupId = 1;

Widget _app(
  SessionController session, {
  Brightness brightness = Brightness.light,
  bool highContrast = false,
}) => MaterialApp(
  locale: const Locale('fr'),
  theme: buildAppTheme(brightness, highContrast: highContrast),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: HomeScreen(session: session),
);

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 250));
  }
}

void main() {
  final fr = lookupAppLocalizations(const Locale('fr'));

  setUpAll(() {
    client = Client('http://localhost:9/')
      ..authSessionManager = FlutterAuthSessionManager(storage: _NoStorage());
    AppVersions.appForTests = '1.26.0';
    // Pépite and the lock keep their marks in the secure storage.
    final kept = <String, String>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (call) async {
            final args = (call.arguments as Map?) ?? const {};
            final key = args['key'] as String?;
            return switch (call.method) {
              'read' => kept[key],
              'write' => kept[key!] = args['value'] as String,
              'delete' => kept.remove(key),
              'readAll' => kept,
              'containsKey' => kept.containsKey(key),
              _ => null,
            };
          },
        );
  });

  Future<SessionController> open(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final session = _session();
    await tester.pumpWidget(_app(session));
    await _settle(tester);
    return session;
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('phone: five sections at the bottom, tabs inside', (
    tester,
  ) async {
    await open(tester, const Size(390, 844));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    for (final label in [
      fr.navHome,
      fr.navMoney,
      fr.navPlan,
      fr.navPapers,
      fr.navAdvisor,
    ]) {
      expect(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
        findsOneWidget,
      );
    }
    expect(find.byKey(const Key('advisor-badge')), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(fr.navPlan),
      ),
    );
    await _settle(tester);
    for (final page in AppSection.plan.pages) {
      expect(find.byKey(Key('page-${page.name}')), findsOneWidget);
    }
    // The test font is wider than a real one: the tabs may scroll.
    await tester.ensureVisible(find.byKey(const Key('page-loans')));
    await tester.tap(find.byKey(const Key('page-loans')));
    await _settle(tester);
    final loans = tester.widget<ChoiceChip>(
      find.byKey(const Key('page-loans')),
    );
    expect(loans.selected, isTrue);
    await close(tester);
  });

  testWidgets('large screen: the sections in a rail', (tester) async {
    await open(tester, const Size(1280, 900));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await close(tester);
  });

  testWidgets('"+" offers to scan a receipt and import a statement', (
    tester,
  ) async {
    await open(tester, const Size(1280, 900));
    await tester.tap(find.byKey(const Key('add-menu')));
    await _settle(tester);
    expect(find.byKey(const Key('add-receipt')), findsOneWidget);
    expect(find.byKey(const Key('add-statement')), findsOneWidget);
    await tester.tap(find.byKey(const Key('add-statement')));
    await _settle(tester);
    expect(
      tester.widget<ChoiceChip>(find.byKey(const Key('page-imports'))).selected,
      isTrue,
    );
    await close(tester);
  });

  testWidgets('keys: 1 to 5, / and ?', (tester) async {
    await open(tester, const Size(1280, 900));

    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await _settle(tester);
    expect(find.byKey(const Key('page-accounts')), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
    await _settle(tester);
    expect(find.byKey(const Key('page-invoices')), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.slash);
    await _settle(tester);
    expect(find.byKey(const Key('global-search-field')), findsOneWidget);
    // Typed in the field, a key is text, not a shortcut.
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await _settle(tester);
    expect(find.byKey(const Key('global-search-field')), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await _settle(tester);

    await tester.tap(find.byKey(const Key('open-settings')));
    await _settle(tester);
    expect(find.text(fr.shortcutsTitle), findsOneWidget);
    await tester.ensureVisible(find.text(fr.shortcutsTitle));
    await _settle(tester);
    await tester.tap(find.text(fr.shortcutsTitle));
    await _settle(tester);
    expect(find.text(fr.shortcutSections), findsOneWidget);
    await close(tester);
  });

  // Decision 0041, point 10: dark mode checked screen by screen.
  for (final highContrast in [false, true]) {
    testWidgets('dark${highContrast ? ', high contrast' : ''}: every section '
        'readable', (tester) async {
      final handle = tester.ensureSemantics();
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _app(
          _session(),
          brightness: Brightness.dark,
          highContrast: highContrast,
        ),
      );
      await _settle(tester);
      for (final section in AppSection.values) {
        await tester.tap(
          find.descendant(
            of: find.byType(NavigationRail),
            matching: find.text(section.label(fr)),
          ),
        );
        await _settle(tester);
        for (final page in section.pages) {
          if (section.pages.length > 1) {
            await tester.ensureVisible(find.byKey(Key('page-${page.name}')));
            await tester.tap(find.byKey(Key('page-${page.name}')));
            await _settle(tester);
          }
          await expectLater(
            tester,
            meetsGuideline(textContrastGuideline),
            reason: page.name,
          );
          await expectLater(
            tester,
            meetsGuideline(labeledTapTargetGuideline),
            reason: page.name,
          );
        }
      }
      handle.dispose();
      await close(tester);
    });
  }
}
