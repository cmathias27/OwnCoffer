import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/dashboard_screen.dart';
import 'package:owncoffer_app/state/app_lock.dart' show LockStore;
import 'package:owncoffer_app/state/pepite.dart';
import 'package:owncoffer_app/state/ui_prefs.dart';
import 'package:owncoffer_app/widgets/home_board_view.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

class _MemoryStore implements LockStore {
  final kept = <String, String>{};

  @override
  Future<String?> read(String key) async => kept[key];

  @override
  Future<void> write(String key, String? value) async =>
      value == null ? kept.remove(key) : kept[key] = value;
}

const _p = HomeTileKind.pepite;
const _b = HomeTileKind.balance;
const _l = HomeTileKind.leftToLive;
const _m = HomeTileKind.monthBalance;
const _u = HomeTileKind.upcoming;

HomeBoard _board(String text, [int columns = 2]) =>
    HomeBoard.parse(text, columns)!;

void main() {
  group('board', () {
    test('read and written back, in reading order', () {
      const text = 'pepite:l:0:0,balance:m:0:2,leftToLive:s:1:3';
      expect(_board(text).toString(), text);
      // Written in reading order whatever the order read.
      expect(
        _board('leftToLive:s:1:3,balance:m:0:2,pepite:l:0:0').toString(),
        text,
      );
    });

    test('what cannot be read is skipped or mended', () {
      final b = _board(
        'nothing:s:0:0,pepite:x:0:0,pepite:s:1:0,balance:m:5:2,'
        'summary:l:0:9,loans:s:0:a,accounts:s',
      );
      // Unknown kind, second pepite, bad numbers, missing parts: skipped.
      // A size it cannot take: its usual size. Outside the grid: back in.
      expect(b.toString(), 'pepite:l:0:0,balance:m:0:2,summary:m:0:9');
      expect(HomeBoard.parse(null, 2), isNull);
      expect(HomeBoard.parse(' ', 2)!.tiles, isEmpty);
    });

    test('overlaps read from a saved text are pushed down', () {
      final b = _board('pepite:l:0:0,balance:m:0:1');
      expect(b.toString(), 'pepite:l:0:0,balance:m:0:2');
    });

    test('the cards of decision 0044 become widgets', () {
      final b = HomeBoard.fromCards('balance,-pepite,upcoming,summary', 2)!;
      expect(b.contains(_p), isFalse);
      expect(b.toString(), 'balance:m:0:0,upcoming:l:0:1,summary:m:0:3');
      expect(HomeBoard.fromCards(null, 2), isNull);
      expect(HomeBoard.fromCards('', 4), isNull);
    });

    test('the home page as it comes', () {
      final phone = HomeBoard.defaults(2);
      expect(phone.reading.first.kind, _p);
      expect(phone.contains(HomeTileKind.topSpending), isTrue);
      expect(phone.contains(HomeTileKind.firstSteps), isTrue);
      // Small widgets side by side on a phone.
      expect(phone.tileOf(_l)!.y, phone.tileOf(_m)!.y);
      final simple = HomeBoard.defaults(2, simple: true, firstSteps: false);
      expect(simple.contains(HomeTileKind.topSpending), isFalse);
      expect(simple.contains(HomeTileKind.firstSteps), isFalse);
      // A large screen fills its four columns.
      final large = HomeBoard.defaults(4);
      expect(large.tileOf(_p)!.x, 0);
      expect(large.tileOf(_b)!.x, 2);
      expect(large.tileOf(_b)!.y, 0);
      for (final t in large.tiles) {
        expect(large.tiles.where((o) => o != t && o.overlaps(t)), isEmpty);
      }
    });

    test('another grid reads the widgets in their order', () {
      final large = HomeBoard.defaults(4);
      final phone = HomeBoard.reflowed(large, 2);
      expect(phone.columns, 2);
      expect([for (final t in phone.reading) t.kind].take(2), [_p, _b]);
      expect(HomeBoard.reflowed(large, 4), same(large));
    });

    test('a widget moved over others pushes them down, holes kept', () {
      final b = _board('pepite:l:0:0,balance:m:0:2,leftToLive:s:0:3');
      final moved = b.moved(_l, 1, 0);
      expect(
        moved.toString(),
        'leftToLive:s:1:0,pepite:l:0:1,balance:m:0:3',
      );
      // A hole left where it was: free placement.
      final hole = b.moved(_l, 1, 6);
      expect(hole.toString(), 'pepite:l:0:0,balance:m:0:2,leftToLive:s:1:6');
      // Brought back inside the grid.
      expect(b.moved(_b, 7, -3).tileOf(_b)!.x, 0);
      expect(b.moved(_b, 7, -3).tileOf(_b)!.y, 0);
      expect(b.moved(HomeTileKind.loans, 0, 0), same(b));
    });

    test('resized: kept inside the grid, the others pushed down', () {
      final b = _board('leftToLive:s:1:0,monthBalance:s:0:1');
      final r = b.resized(_l, TileSize.large);
      expect(r.toString(), 'leftToLive:l:0:0,monthBalance:s:0:2');
      // A size it cannot take: nothing changes.
      final s = _board('summary:s:0:0');
      expect(s.resized(HomeTileKind.summary, TileSize.large), same(s));
      expect(_l.after(TileSize.small), TileSize.medium);
      expect(_l.after(TileSize.large), TileSize.small);
      expect(HomeTileKind.summary.after(TileSize.medium), TileSize.small);
    });

    test('added in the first place free, removed', () {
      final b = _board('pepite:l:0:0,leftToLive:s:0:2');
      final added = b.added(_m);
      expect(added.tileOf(_m)!.x, 1);
      expect(added.tileOf(_m)!.y, 2);
      expect(added.added(_m), same(added));
      // A size it cannot take: its usual size.
      expect(
        b
            .added(HomeTileKind.summary, TileSize.large)
            .tileOf(
              HomeTileKind.summary,
            )!
            .size,
        TileSize.medium,
      );
      expect(added.removed(_p).contains(_p), isFalse);
      expect(added.missing, isNot(contains(_m)));
      expect(added.missing, contains(_u));
      expect(added.rows, 3);
      expect(added, _board(added.toString()));
    });

    test('grid width', () {
      expect(HomeBoard.columnsFor(400), 2);
      expect(HomeBoard.columnsFor(599), 2);
      expect(HomeBoard.columnsFor(600), 4);
    });
  });

  group('kept on this device', () {
    test('each grid its own board, the other read in order', () async {
      final store = _MemoryStore();
      final prefs = UiPrefs(store: store);
      await prefs.load();
      expect(prefs.homeBoard(2), HomeBoard.defaults(2));

      final phone = _board('balance:m:0:0,pepite:l:0:2');
      await prefs.setHomeBoard(phone);
      expect(store.kept['home.2'], phone.toString());

      final again = UiPrefs(store: store);
      await again.load();
      expect(again.homeBoard(2), phone);
      // No board for a large screen yet: the phone's, in its order.
      expect(again.homeBoard(4), HomeBoard.reflowed(phone, 4));

      await again.resetHome();
      expect(store.kept.keys.where((k) => k.startsWith('home')), isEmpty);
      expect(again.homeBoard(2), HomeBoard.defaults(2));
    });

    test('the choice of decision 0044 is read', () async {
      final store = _MemoryStore()..kept['home'] = 'upcoming,-pepite,balance';
      final prefs = UiPrefs(store: store);
      await prefs.load();
      expect(prefs.homeBoard(2).toString(), 'upcoming:l:0:0,balance:m:0:2');
    });

    test('« Premiers pas » hidden before stays hidden', () async {
      final store = _MemoryStore()..kept['firstSteps'] = 'true';
      final prefs = UiPrefs(store: store);
      await prefs.load();
      expect(prefs.homeBoard(4).contains(HomeTileKind.firstSteps), isFalse);
    });
  });

  group('arranging', () {
    Widget view(HomeBoard board, void Function(HomeBoard) changed) =>
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: HomeBoardView(
                  board: board,
                  editing: true,
                  rowHeight: 140,
                  nameOf: (k) => k.name,
                  iconOf: (_) => Icons.square_outlined,
                  onChanged: changed,
                  tileBuilder: (_, t) => HomeTileFrame(
                    icon: Icons.square_outlined,
                    title: t.kind.name,
                    child: Text('${t.kind.name}-content'),
                  ),
                ),
              ),
            ),
          ),
        );

    testWidgets('remove, resize, move from the menu, drag', (tester) async {
      var board = _board('balance:m:0:0,leftToLive:s:0:1');
      await tester.pumpWidget(view(board, (b) => board = b));
      expect(find.text('balance-content'), findsOneWidget);

      await tester.tap(find.byKey(const Key('home-tile-size-leftToLive')));
      expect(board.tileOf(_l)!.size, TileSize.medium);

      await tester.pumpWidget(view(board, (b) => board = b));
      await tester.tap(find.byKey(const Key('home-tile-menu-leftToLive')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-tile-up-leftToLive')));
      await tester.pumpAndSettle();
      expect(board.toString(), 'leftToLive:m:0:0,balance:m:0:1');

      await tester.pumpWidget(view(board, (b) => board = b));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-tile-menu-balance')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-tile-size-small-balance')));
      await tester.pumpAndSettle();
      expect(board.tileOf(_b)!.size, TileSize.small);

      // Dragged by its handle one cell to the right.
      await tester.pumpWidget(view(board, (b) => board = b));
      await tester.pumpAndSettle();
      final handle = find.byKey(const Key('home-tile-drag-balance'));
      final gesture = await tester.startGesture(tester.getCenter(handle));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveBy(const Offset(110, 0));
      await tester.pump();
      await gesture.moveBy(const Offset(100, 0));
      await tester.pump();
      expect(find.byKey(const Key('home-board-ghost')), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(board.tileOf(_b)!.x, 1);

      await tester.pumpWidget(view(board, (b) => board = b));
      await tester.tap(find.byKey(const Key('home-tile-remove-balance')));
      expect(board.contains(_b), isFalse);
    });
  });

  group('home page', () {
    final today = DateTime.now().toUtc();
    final day = DateTime.utc(today.year, today.month, today.day);
    final account = Account(
      id: 4,
      groupId: 1,
      name: 'Courant',
      kind: AccountKind.checking,
    );
    final forecast = ForecastResult(
      accountId: 4,
      today: day,
      until: day.add(const Duration(days: 30)),
      currentBalanceCents: 120000,
      clearedBalanceCents: 120000,
      alertThresholdCents: 0,
      days: [
        for (var i = 0; i < 30; i++)
          ForecastDay(
            date: day.add(Duration(days: i)),
            balanceCents: 120000 - i * 1000,
          ),
      ],
      events: const [],
      lowestDate: day.add(const Duration(days: 29)),
      lowestBalanceCents: 91000,
      missed: const [],
      proposals: const [],
      autoReconciledCount: 0,
    );
    final report = SpendingReport(
      period: BudgetPeriod.month,
      start: day,
      last: day,
      incomeCents: 250000,
      expenseCents: 130000,
      savingsCents: 0,
      netCents: 120000,
      unclassifiedCount: 3,
      unclassifiedInCents: 0,
      unclassifiedOutCents: -4000,
      categories: const [],
      history: const [],
    );
    final membership = GroupMembership(
      group: FinanceGroup(
        id: 1,
        name: 'Foyer',
        createdBy: UuidValue.fromString(
          '00000000-0000-4000-8000-000000000000',
        ),
      ),
      role: MemberRole.user,
    );

    setUp(() async {
      pepite.enabled = false;
      client = Client(
        'https://coffre.example/api/',
        httpClientOverride: MockClient((r) async {
          final answer = switch (r.url.path) {
            '/api/account/list' => [account],
            '/api/scheduled/forecast' => forecast,
            '/api/analysis/report' => report,
            _ => null,
          };
          if (answer == null) return http.Response('{}', 500);
          return http.Response(
            SerializationManager.encodeForProtocol(answer),
            200,
          );
        }),
      );
      await uiPrefs.resetHome();
      // Pépite's own card asks the server for more: kept out of these.
      for (final columns in const [2, 4]) {
        await uiPrefs.setHomeBoard(
          HomeBoard.defaults(columns).removed(HomeTileKind.pepite),
        );
      }
    });

    Future<DashboardTarget?> open(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      DashboardTarget? opened;
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
          home: Scaffold(
            body: DashboardScreen(
              membership: membership,
              onOpen: (t) => opened = t,
              onAdvisor: () {},
              adviceTitle: (p) => p.kind,
            ),
          ),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      return opened;
    }

    for (final (name, size) in [
      ('phone', const Size(400, 900)),
      ('large screen', const Size(1200, 900)),
    ]) {
      testWidgets('$name: the widgets, arranged in place', (tester) async {
        await open(tester, size);
        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('home-board')), findsOneWidget);
        expect(find.byKey(const Key('home-card-balance')), findsOneWidget);
        expect(find.textContaining(RegExp(r'1\s200,00')), findsWidgets);

        await tester.tap(find.byKey(const Key('home-customize')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('home-board-done')), findsOneWidget);
        await tester.tap(find.byKey(const Key('home-tile-remove-balance')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('home-card-balance')), findsNothing);

        // The catalogue: a widget of a page, at the size chosen.
        await tester.tap(find.byKey(const Key('home-board-add')));
        await tester.pumpAndSettle();
        final chip = find.byKey(const Key('home-add-toClassify-medium'));
        await tester.scrollUntilVisible(
          chip,
          150,
          scrollable: find
              .descendant(
                of: find.byType(DraggableScrollableSheet),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(chip);
        await tester.pumpAndSettle();
        await tester.tap(chip);
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        await tester.tap(find.byKey(const Key('home-board-done')));
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        final columns = size.width > 700 ? 4 : 2;
        final saved = uiPrefs.homeBoard(columns);
        expect(saved.contains(_b), isFalse);
        expect(
          saved.tileOf(HomeTileKind.toClassify)!.size,
          TileSize.medium,
        );
        expect(find.byKey(const Key('home-board-done')), findsNothing);

        // A tap opens its page.
        final tile = find.byKey(const Key('home-card-toClassify'));
        await tester.ensureVisible(tile);
        await tester.pumpAndSettle();
        await tester.tap(tile);
        expect(tester.takeException(), isNull);
      });
    }

    for (final size in TileSize.values) {
      for (final (name, screen) in [
        ('phone', const Size(400, 900)),
        ('large screen', const Size(1200, 900)),
      ]) {
        testWidgets('every widget, ${size.name}, $name', (tester) async {
          final columns = screen.width > 700 ? 4 : 2;
          await tester.runAsync(
            () => uiPrefs.setHomeBoard(
              HomeBoard.packed(columns, [
                for (final k in HomeTileKind.values)
                  if (k != HomeTileKind.pepite && k.sizes.contains(size))
                    (k, size),
              ]),
            ),
          );
          await open(tester, screen);
          expect(tester.takeException(), isNull);
          for (final k in HomeTileKind.values) {
            if (k == HomeTileKind.pepite || !k.sizes.contains(size)) continue;
            expect(find.byKey(Key('home-card-${k.name}')), findsOneWidget);
          }
        });
      }
    }

    testWidgets('« Rétablir » then cancel keeps the board', (tester) async {
      await tester.runAsync(
        () => uiPrefs.setHomeBoard(_board('balance:m:0:0')),
      );
      await open(tester, const Size(400, 900));
      expect(find.byKey(const Key('home-card-pepite')), findsNothing);
      await tester.tap(find.byKey(const Key('home-customize')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-board-reset')));
      await tester.pump();
      expect(find.byKey(const Key('home-card-upcoming')), findsOneWidget);
      await tester.tap(find.byKey(const Key('home-board-cancel')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('home-card-upcoming')), findsNothing);
      expect(uiPrefs.homeBoard(2).toString(), 'balance:m:0:0');

      // Done after « Rétablir »: the home page as it comes.
      await tester.tap(find.byKey(const Key('home-customize')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-board-reset')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('home-board-done')));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(uiPrefs.homeBoard(2), HomeBoard.defaults(2));
      expect(uiPrefs.homeBoard(4), HomeBoard.defaults(4));
    });

    testWidgets('nothing on the board: said, and how to add', (tester) async {
      await tester.runAsync(
        () => uiPrefs.setHomeBoard(_board('balance:m:0:0')),
      );
      await open(tester, const Size(400, 900));
      await tester.tap(find.byKey(const Key('home-customize')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-tile-remove-balance')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-board-done')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Aucun widget'), findsOneWidget);
      // Kept empty, not back to the home page as it comes.
      expect(uiPrefs.homeBoard(2).tiles, isEmpty);
      expect(HomeBoard.parse('', 2)!.tiles, isEmpty);
    });
  });
}
