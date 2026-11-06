import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/state/app_lock.dart';
import 'package:owncoffer_app/util/device_auth.dart';
import 'package:owncoffer_app/widgets/app_lock_layer.dart';

class _MemoryStore implements LockStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}

class _FakeDevice implements DeviceAuth {
  var available = DeviceAuthKind.none;
  var accept = true;

  @override
  Future<DeviceAuthKind> kind() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    return accept;
  }
}

void main() {
  late _MemoryStore store;
  late _FakeDevice device;
  late DateTime now;
  late bool standalone;
  late int signOuts;
  const password = 'right password';

  AppLock newLock() => AppLock(
    store: store,
    deviceAuth: device,
    verifyPassword: (p) async => p == password,
    standalone: () => standalone,
    now: () => now,
  );

  Future<AppLock> attached() async {
    final lock = newLock();
    await lock.attach(() async => signOuts++);
    return lock;
  }

  setUp(() {
    store = _MemoryStore();
    device = _FakeDevice();
    now = DateTime(2026, 11, 6, 10);
    standalone = false;
    signOuts = 0;
  });

  test('off by default: never locks', () async {
    final lock = await attached();
    expect(lock.enabled, isFalse);
    now = now.add(const Duration(hours: 3));
    await lock.check();
    expect(lock.locked, isFalse);
  });

  test('locks after the delay without activity, not before', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    expect(lock.minutes, AppLock.defaultMinutes);
    now = now.add(const Duration(minutes: 14));
    await lock.check();
    expect(lock.locked, isFalse);
    lock.activity();
    now = now.add(const Duration(minutes: 14));
    await lock.check();
    expect(lock.locked, isFalse, reason: 'activity started the delay again');
    now = now.add(const Duration(minutes: 1));
    await lock.check();
    expect(lock.locked, isTrue);
  });

  test('only the offered delays are kept', () async {
    final lock = await attached();
    await lock.setMinutes(7);
    expect(lock.minutes, 15);
    await lock.setMinutes(5);
    expect(newLock().minutes, 15);
    final reloaded = newLock();
    await reloaded.load();
    expect(reloaded.minutes, 5);
  });

  test('the right password unlocks, a wrong one counts', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    await lock.lockNow();
    expect(lock.locked, isTrue);
    expect(await lock.unlockWithPassword('wrong'), UnlockResult.wrongPassword);
    expect(lock.attemptsLeft, 4);
    expect(lock.locked, isTrue);
    expect(await lock.unlockWithPassword(password), UnlockResult.unlocked);
    expect(lock.locked, isFalse);
    expect(lock.attemptsLeft, 5);
  });

  test('five wrong passwords sign the device out', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    await lock.lockNow();
    for (var i = 0; i < 4; i++) {
      expect(
        await lock.unlockWithPassword('wrong'),
        UnlockResult.wrongPassword,
      );
    }
    expect(signOuts, 0);
    expect(await lock.unlockWithPassword('wrong'), UnlockResult.signedOut);
    expect(signOuts, 1);
    expect(lock.active, isFalse);
    expect(lock.locked, isFalse);
    expect(lock.takeSignedOutByLock(), isTrue);
    expect(lock.takeSignedOutByLock(), isFalse, reason: 'said only once');
  });

  test('failures survive a restart of the app', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    await lock.lockNow();
    for (var i = 0; i < 4; i++) {
      await lock.unlockWithPassword('wrong');
    }
    final again = await attached();
    expect(again.locked, isTrue);
    expect(again.attemptsLeft, 1);
    expect(await again.unlockWithPassword('wrong'), UnlockResult.signedOut);
    expect(signOuts, 1);
  });

  test('eight hours behind the lock sign the device out', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    await lock.lockNow();
    now = now.add(const Duration(hours: 7, minutes: 59));
    await lock.check();
    expect(signOuts, 0);
    now = now.add(const Duration(minutes: 1));
    await lock.check();
    expect(signOuts, 1);
  });

  test('also when the app comes back after the night', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    lock.activity();
    await lock.persistActivity();
    // The app was closed; it opens again the next morning.
    now = now.add(const Duration(hours: 12));
    await attached();
    expect(signOuts, 1);
  });

  test('a reloaded page stays locked', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    await lock.lockNow();
    final reloaded = newLock();
    await reloaded.load();
    expect(reloaded.locked, isTrue);
  });

  test('time away counts: idle since the last activity, saved', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    await lock.persistActivity();
    now = now.add(const Duration(minutes: 20));
    final again = await attached();
    expect(again.locked, isTrue);
    expect(again.lockedAt, DateTime(2026, 11, 6, 10, 15));
  });

  test('a sign-out lifts the lock and forgets the failures', () async {
    final lock = await attached();
    await lock.setEnabled(true);
    await lock.lockNow();
    await lock.unlockWithPassword('wrong');
    lock.detach();
    expect(lock.locked, isFalse);
    final again = await attached();
    expect(again.locked, isFalse);
    expect(again.attemptsLeft, 5);
  });

  test('device unlock: only when chosen, offered once', () async {
    device.available = DeviceAuthKind.android;
    final lock = await attached();
    await lock.setEnabled(true);
    expect(await lock.canUseDevice(), isFalse);
    expect(await lock.shouldOfferDevice(), isTrue);
    await lock.setDeviceUnlock(false);
    expect(await lock.shouldOfferDevice(), isFalse);
    await lock.setDeviceUnlock(true);
    expect(await lock.canUseDevice(), isTrue);
    await lock.lockNow();
    device.accept = false;
    expect(await lock.unlockWithDevice('why'), isFalse);
    expect(lock.locked, isTrue);
    device.accept = true;
    expect(await lock.unlockWithDevice('why'), isTrue);
    expect(lock.locked, isFalse);
  });

  test('no device unlock offered when the device has none', () async {
    final lock = await attached();
    expect(await lock.shouldOfferDevice(), isFalse);
    expect(await lock.canUseDevice(), isFalse);
  });

  group('standalone', () {
    setUp(() => standalone = true);

    test('always unlocked by the device, never signed out', () async {
      device.available = DeviceAuthKind.windowsHello;
      final lock = await attached();
      await lock.setEnabled(true);
      expect(lock.deviceUnlock, isTrue);
      expect(await lock.canUseDevice(), isTrue);
      expect(await lock.shouldOfferDevice(), isFalse);
      await lock.lockNow();
      for (var i = 0; i < 6; i++) {
        await lock.recordFailure();
      }
      now = now.add(const Duration(hours: 9));
      await lock.check();
      expect(signOuts, 0);
      expect(lock.locked, isTrue);
    });

    test('turned off when the device lost its screen lock', () async {
      device.available = DeviceAuthKind.android;
      final lock = await attached();
      await lock.setEnabled(true);
      await lock.lockNow();
      device.available = DeviceAuthKind.none;
      final again = await attached();
      expect(again.enabled, isFalse);
      expect(again.locked, isFalse);
    });
  });

  group('lock screen', () {
    Widget app(AppLock lock) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      builder: (context, child) =>
          AppLockLayer(lock: lock, child: child ?? const SizedBox()),
      home: const Scaffold(body: Text('Comptes')),
    );

    testWidgets('hides the pages until the password is given', (
      tester,
    ) async {
      final lock = await tester.runAsync(attached);
      await tester.runAsync(() => lock!.setEnabled(true));
      await tester.pumpWidget(app(lock!));
      expect(find.text('Comptes'), findsOneWidget);
      await tester.runAsync(lock.lockNow);
      await tester.pump();
      expect(find.text('Comptes'), findsNothing);
      expect(find.text('OwnCoffer est verrouillé'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'wrong');
      await tester.tap(find.widgetWithText(FilledButton, 'Déverrouiller'));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
      expect(find.textContaining('Encore 4 essais'), findsOneWidget);
      await tester.enterText(find.byType(TextField), password);
      await tester.tap(find.widgetWithText(FilledButton, 'Déverrouiller'));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
      expect(find.text('Comptes'), findsOneWidget);
      expect(find.text('OwnCoffer est verrouillé'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('a touch starts the delay again', (tester) async {
      final lock = await tester.runAsync(attached);
      await tester.runAsync(() => lock!.setEnabled(true));
      await tester.pumpWidget(app(lock!));
      now = now.add(const Duration(minutes: 10));
      await tester.tap(find.text('Comptes'));
      now = now.add(const Duration(minutes: 10));
      await tester.runAsync(lock.check);
      expect(lock.locked, isFalse);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
