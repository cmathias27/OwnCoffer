import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/pepite_shop_screen.dart';
import 'package:owncoffer_app/state/app_lock.dart';
import 'package:owncoffer_app/state/pepite.dart';
import 'package:owncoffer_app/state/pepite_messages.dart';
import 'package:owncoffer_app/widgets/pepite.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

class _MemoryStore implements LockStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}

class _NoReminders implements PepiteReminders {
  @override
  bool get supported => false;
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<void> schedule(
    List<DateTime> at, {
    required String title,
    required String body,
    required String channel,
  }) async {}
  @override
  Future<void> cancel() async {}
}

/// A server keeping the rules of the shop, as the real one.
class _Shop {
  var status = PepiteStatus(
    seeds: 40,
    weeks: 3,
    doneThisWeek: true,
    badges: const [],
    earnedSeeds: 0,
    newBadges: const [],
    items: const [],
    equipped: const [],
  );
  final bought = <String>[];

  Future<PepiteStatus> buy(String code, DateTime _) async {
    final item = core.pepiteItemByCode(code)!;
    if (status.seeds - status.spentSeeds < item.price) {
      throw Exception('pepite_not_enough_seeds');
    }
    bought.add(code);
    return status = status.copyWith(
      spentSeeds: status.spentSeeds + item.price,
      items: [...status.items, code],
    );
  }

  Future<PepiteStatus> equip(String code, bool on, DateTime _) async {
    final accessory =
        core.pepiteItemByCode(code)!.category ==
        core.PepiteItemCategory.accessory;
    final worn = [
      for (final c in status.equipped)
        if (c != code &&
            !(on &&
                accessory &&
                core.pepiteItemByCode(c)!.category ==
                    core.PepiteItemCategory.accessory))
          c,
      if (on) code,
    ];
    return status = status.copyWith(equipped: worn);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fr = lookupAppLocalizations(const Locale('fr'));

  late _Shop shop;
  Pepite make({bool browser = false}) => Pepite(
    store: _MemoryStore(),
    reminders: _NoReminders(),
    status: (_) async => shop.status,
    complete: (_) async => shop.status,
    buy: shop.buy,
    equip: shop.equip,
    now: () => DateTime(2026, 11, 4, 10),
    browser: browser,
  );

  setUp(() => shop = _Shop());

  Widget app(Widget child) => MaterialApp(
    locale: const Locale('fr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: child,
  );

  Future<void> big(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Finder buyOf(String name) => find.descendant(
    of: find.ancestor(of: find.text(name), matching: find.byType(Card)),
    matching: find.widgetWithText(FilledButton, fr.pepiteShopBuy),
  );

  test('the controller reads what is owned, worn and left', () async {
    final p = make();
    await p.signedIn();
    expect(p.seedsToSpend, 40);
    await p.buyItem('scarf');
    await p.buyItem('mat');
    expect(p.seedsToSpend, 40 - 15 - 10);
    expect(p.status!.seeds, 40, reason: 'the total earned stays');
    expect(p.owns('scarf'), isTrue);
    expect(p.accessory, isNull);
    await p.equipItem('scarf', true);
    await p.equipItem('mat', true);
    expect(p.wears('scarf'), isTrue);
    expect(p.accessory, 'scarf');
    expect(p.burrow, ['mat']);
  });

  testWidgets('buying asks first, then the item is owned and worn', (
    tester,
  ) async {
    await big(tester);
    final p = make();
    await tester.runAsync(p.signedIn);
    await tester.pumpWidget(app(PepiteShopScreen(controller: p)));
    await tester.pumpAndSettle();
    expect(find.text(fr.pepiteShopToSpend(40)), findsOneWidget);
    expect(find.text(fr.pepiteShopEarned(40)), findsOneWidget);

    await tester.tap(buyOf(fr.pepiteItemScarf));
    await tester.pumpAndSettle();
    expect(
      find.text(fr.pepiteShopBuyConfirm(fr.pepiteItemScarf, 15, 25)),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, fr.pepiteShopBuy).last);
    await tester.pumpAndSettle();
    expect(shop.bought, ['scarf']);
    expect(find.text(fr.pepiteShopBought(fr.pepiteItemScarf)), findsOneWidget);
    expect(find.text(fr.pepiteShopToSpend(25)), findsOneWidget);

    await tester.tap(find.text(fr.pepiteShopWear));
    await tester.pumpAndSettle();
    expect(p.accessory, 'scarf');
    expect(find.text(fr.pepiteShopTakeOff), findsOneWidget);
  });

  testWidgets('too few seeds: the button waits, with what is missing', (
    tester,
  ) async {
    await big(tester);
    shop.status = shop.status.copyWith(seeds: 12);
    final p = make();
    await tester.runAsync(p.signedIn);
    await tester.pumpWidget(app(PepiteShopScreen(controller: p)));
    await tester.pumpAndSettle();
    // The hut costs 35.
    final button = tester.widget<FilledButton>(buyOf(fr.pepiteItemHut));
    expect(button.onPressed, isNull);
    expect(find.text(fr.pepiteShopMissing(23)), findsOneWidget);
    // The rug (10) is within reach.
    expect(
      tester.widget<FilledButton>(buyOf(fr.pepiteItemMat)).onPressed,
      isNotNull,
    );
  });

  testWidgets('in a browser, an item of the apps is not for sale', (
    tester,
  ) async {
    await big(tester);
    final p = make(browser: true);
    await tester.runAsync(p.signedIn);
    await tester.pumpWidget(app(PepiteShopScreen(controller: p)));
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(buyOf(fr.pepiteItemBackpack)).onPressed,
      isNull,
    );
    expect(find.text(fr.pepiteShopAppsOnly), findsOneWidget);
  });

  testWidgets('an item of the apps, once owned, shows in the browser too', (
    tester,
  ) async {
    await big(tester);
    shop.status = shop.status.copyWith(
      spentSeeds: 20,
      items: ['backpack'],
      equipped: ['backpack'],
    );
    final p = make(browser: true);
    await tester.runAsync(p.signedIn);
    await tester.pumpWidget(
      app(
        Scaffold(
          body: PepiteBurrow(
            PepitePose.happy,
            controller: p,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(p.accessory, 'backpack');
    expect(find.byType(PepiteImage), findsOneWidget);
  });
}
