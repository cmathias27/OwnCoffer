import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/export_screen.dart';
import 'package:owncoffer_app/screens/server_address_screen.dart';
import 'package:owncoffer_app/widgets/admin_backups.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

/// Roadbook phase 5, accessibility: every button has a name read by screen
/// readers, tap targets are large enough, text contrast is sufficient, and
/// the screens still work with text enlarged to 200 %, in French and
/// English, light and dark.
void main() {
  final membership = GroupMembership(
    group: FinanceGroup(
      id: 1,
      name: 'Foyer',
      createdBy: UuidValue.fromString('00000000-0000-4000-8000-000000000000'),
    ),
    role: MemberRole.user,
  );
  final screens = <String, Widget Function()>{
    'server address': () => ServerAddressScreen(onSaved: () async {}),
    'export': () => ExportScreen(membership: membership),
    'backups': () => Scaffold(
      body: AdminBackupsView(
        now: DateTime.utc(2026, 11, 2, 12),
        onBackup: () {},
        onRestoreTest: () {},
        overview: BackupOverview(
          available: true,
          backups: [
            BackupInfo(
              name: 'owncoffer-20261102-033000-daily.dump.gpg',
              label: 'daily',
              bytes: 4096,
              createdAt: DateTime.utc(2026, 11, 2, 3, 30),
              encrypted: true,
            ),
          ],
          lastAt: DateTime.utc(2026, 11, 2, 3, 30),
          lastOk: true,
          lastDailyAt: DateTime.utc(2026, 11, 2, 3, 30),
          requestPending: false,
          lastEncrypted: true,
          restoreTest: RestoreTestInfo(
            at: DateTime.utc(2026, 11, 2, 3, 31),
            ok: true,
            file: 'owncoffer-20261102-033000-daily.dump.gpg',
            tables: 67,
            operations: 1234,
          ),
        ),
      ),
    ),
  };

  Widget app(Widget home, Locale locale, Brightness brightness, double scale) =>
      MaterialApp(
        locale: locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3346C8),
            brightness: brightness,
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: home,
      );

  for (final MapEntry(key: name, value: build) in screens.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('$name, ${brightness.name}: names, targets, contrast', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          app(build(), const Locale('fr'), brightness, 1),
        );
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }
    for (final locale in const [Locale('fr'), Locale('en')]) {
      testWidgets('$name, ${locale.languageCode}: text at 200 % on a phone', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 780);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(app(build(), locale, Brightness.light, 2));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
