import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/admin_backups.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  final now = DateTime.utc(2026, 11, 2, 12);

  testWidgets('backups: nightly late, last failed, list, backup now', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(380, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var asked = 0;
    await tester.pumpWidget(
      _app(
        AdminBackupsView(
          now: now,
          onBackup: () => asked++,
          overview: BackupOverview(
            available: true,
            backups: [
              BackupInfo(
                name: 'owncoffer-20261031-120000-before-0.3.8.dump',
                label: 'before-0.3.8',
                bytes: 3 * 1024 * 1024,
                createdAt: DateTime.utc(2026, 10, 31, 12),
              ),
              BackupInfo(
                name: 'owncoffer-20261030-033000-daily.dump',
                label: 'daily',
                bytes: 2048,
                createdAt: DateTime.utc(2026, 10, 30, 3, 30),
              ),
            ],
            lastAt: DateTime.utc(2026, 11, 1, 3, 30),
            lastLabel: 'daily',
            lastOk: false,
            lastMessage: 'empty dump',
            lastDailyAt: DateTime.utc(2026, 10, 30, 3, 30),
            requestPending: false,
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      find.textContaining('Pas de sauvegarde de nuit depuis'),
      findsOneWidget,
    );
    expect(find.textContaining('empty dump'), findsOneWidget);
    expect(find.text('Avant la mise à jour 0.3.8'), findsOneWidget);
    expect(find.textContaining('3,0 Mo'), findsOneWidget);
    await tester.tap(find.text('Sauvegarder maintenant'));
    expect(asked, 1);
  });

  testWidgets('backups: pending request disables the button', (tester) async {
    await tester.pumpWidget(
      _app(
        AdminBackupsView(
          now: now,
          onBackup: () {},
          overview: BackupOverview(
            available: true,
            backups: const [],
            lastDailyAt: now.subtract(const Duration(hours: 8)),
            requestPending: true,
          ),
        ),
      ),
    );
    expect(find.textContaining('Dernière sauvegarde de nuit'), findsOneWidget);
    expect(find.textContaining('en cours sur le serveur'), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('backups: shared folder missing, the command is given', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        AdminBackupsView(
          onBackup: () {},
          overview: BackupOverview(
            available: false,
            backups: const [],
            requestPending: false,
          ),
        ),
      ),
    );
    expect(find.text('sudo docker/install-auto-update.sh'), findsOneWidget);
  });
}
