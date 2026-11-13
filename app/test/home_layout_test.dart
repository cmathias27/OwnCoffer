import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/state/app_lock.dart' show LockStore;
import 'package:owncoffer_app/state/ui_prefs.dart';
import 'package:owncoffer_app/widgets/home_layout_dialog.dart';

// Decision 0044: the home page shows the cards the user chose, in their
// order, kept on this device.

class _MemoryStore implements LockStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}

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
  group('home layout', () {
    test('every card by default; the spending left out in simple mode', () {
      expect(HomeLayout.defaults().visible, HomeCard.values);
      expect(
        HomeLayout.defaults(simple: true).shows(HomeCard.topSpending),
        isFalse,
      );
      expect(HomeLayout.parse(null), HomeLayout.defaults());
      expect(HomeLayout.parse(''), HomeLayout.defaults());
    });

    test('written and read back the same', () {
      final layout = HomeLayout.defaults()
          .toggled(HomeCard.pepite, false)
          .reordered([
            HomeCard.upcoming,
            HomeCard.balance,
            for (final c in HomeCard.values)
              if (c != HomeCard.upcoming && c != HomeCard.balance) c,
          ]);
      final text = layout.toString();
      expect(text, startsWith('upcoming,balance,-pepite,summary'));
      expect(HomeLayout.parse(text), layout);
      expect(HomeLayout.parse(text).visible.first, HomeCard.upcoming);
    });

    test('unknown or repeated names are skipped; a new card comes last, '
        'shown', () {
      final layout = HomeLayout.parse('balance,someday,-balance,-upcoming');
      expect(layout.order.first, HomeCard.balance);
      expect(layout.shows(HomeCard.balance), isTrue);
      expect(layout.shows(HomeCard.upcoming), isFalse);
      expect(layout.order.toSet(), HomeCard.values.toSet());
      expect(layout.order, hasLength(HomeCard.values.length));
      expect(layout.order.last, HomeCard.topSpending);
      expect(layout.shows(HomeCard.topSpending), isTrue);
    });

    test('a card left out of a new order keeps its place', () {
      final layout = HomeLayout.defaults().reordered([
        for (final c in HomeCard.values.reversed)
          if (c != HomeCard.advices) c,
      ]);
      expect(
        layout.order.indexOf(HomeCard.advices),
        HomeCard.values.indexOf(HomeCard.advices),
      );
      expect(layout.order.first, HomeCard.topSpending);
    });

    test(
      'kept on the device; « Premiers pas » follows its own switch',
      () async {
        final store = _MemoryStore();
        final prefs = UiPrefs(store: store);
        await prefs.load();
        expect(prefs.homeLayout, HomeLayout.defaults());
        await prefs.setHomeLayout(
          HomeLayout.defaults()
              .toggled(HomeCard.firstSteps, false)
              .toggled(HomeCard.status, false),
        );
        expect(prefs.firstStepsHidden, isTrue);
        final again = UiPrefs(store: store);
        await again.load();
        expect(again.homeLayout.shows(HomeCard.status), isFalse);
        expect(again.homeLayout.shows(HomeCard.firstSteps), isFalse);
        // Hidden from its own card: the editor shows it unticked.
        await again.setHomeLayout(null);
        expect(again.firstStepsHidden, isFalse);
        await again.setFirstStepsHidden(true);
        expect(again.homeLayout.shows(HomeCard.firstSteps), isFalse);
        expect(store.values['home'], isNull, reason: 'back to the defaults');
      },
    );
  });

  group('editor', () {
    Future<HomeLayoutChoice?> open(
      WidgetTester tester,
      HomeLayout layout, {
      bool advices = true,
      required Future<void> Function() act,
    }) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      HomeLayoutChoice? chosen;
      var closed = false;
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  chosen = await showDialog<HomeLayoutChoice>(
                    context: context,
                    builder: (_) =>
                        HomeLayoutDialog(layout: layout, advices: advices),
                  );
                  closed = true;
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await act();
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      return chosen;
    }

    testWidgets('a card hidden, then saved', (tester) async {
      final chosen = await open(
        tester,
        HomeLayout.defaults(),
        act: () async {
          expect(find.text("Personnaliser l'accueil"), findsOneWidget);
          await tester.tap(find.text('Pépite'));
          await tester.pump();
          await tester.tap(find.byKey(const Key('home-layout-save')));
        },
      );
      expect(chosen!.layout!.shows(HomeCard.pepite), isFalse);
      expect(chosen.layout!.shows(HomeCard.balance), isTrue);
    });

    testWidgets('cancel keeps everything', (tester) async {
      final chosen = await open(
        tester,
        HomeLayout.defaults(),
        act: () async {
          await tester.tap(find.text('Pépite'));
          await tester.tap(find.text('Annuler'));
        },
      );
      expect(chosen, isNull);
    });

    testWidgets('reset gives back the home page as it comes', (tester) async {
      final chosen = await open(
        tester,
        HomeLayout.defaults().toggled(HomeCard.balance, false),
        act: () async {
          await tester.tap(find.byKey(const Key('home-layout-reset')));
          await tester.pump();
          await tester.tap(find.byKey(const Key('home-layout-save')));
        },
      );
      expect(chosen, isNotNull);
      expect(chosen!.layout, isNull);
    });

    testWidgets('without the advisor, its card is not offered', (
      tester,
    ) async {
      await open(
        tester,
        HomeLayout.defaults(),
        advices: false,
        act: () async {
          expect(find.text('Conseils du moment'), findsNothing);
          expect(find.text('Total des comptes'), findsOneWidget);
          await tester.tap(find.text('Annuler'));
        },
      );
    });

    testWidgets('a card dragged to the top', (tester) async {
      final chosen = await open(
        tester,
        HomeLayout.defaults(),
        act: () async {
          final handle = find.descendant(
            of: find.byKey(const ValueKey('home-card-summary')),
            matching: find.byIcon(Icons.drag_handle),
          );
          final gesture = await tester.startGesture(
            tester.getCenter(handle),
          );
          await tester.pump(const Duration(milliseconds: 100));
          await gesture.moveBy(const Offset(0, -200));
          await tester.pump();
          await gesture.up();
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('home-layout-save')));
        },
      );
      expect(chosen!.layout!.order.first, HomeCard.summary);
    });
  });
}
