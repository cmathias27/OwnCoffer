import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/admin_screen.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

void main() {
  testWidgets('admin health: state, figures, warnings in red', (tester) async {
    tester.view.physicalSize = const Size(380, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final now = DateTime.now().toUtc();
    var tested = 0;
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
          body: AdminHealthView(
            health: AdminHealth(
              version: '0.3.7',
              startedAt: now.subtract(const Duration(days: 2, hours: 3)),
              serverTime: now,
              databaseOk: true,
              databaseBytes: 12 * 1024 * 1024,
              documentsBytes: 2048,
              smtpConfigured: false,
              publicUrl: 'https://coffre.example.org',
              alertsRunAt: now,
              alertsRunOk: false,
            ),
            stats: AdminStats(
              users: 3,
              blockedUsers: 0,
              twoFactorUsers: 1,
              groups: 1,
              accounts: 2,
              operations: 120,
              operationsLast30Days: 40,
              importsLast30Days: 2,
              rules: 5,
              pendingInvitations: 1,
              classifiedAutomatically: 80,
              classifiedManually: 15,
              unclassified: 5,
            ),
            onTestEmail: () => tested++,
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('0.3.7'), findsOneWidget);
    expect(find.text('2 j 3 h'), findsOneWidget);
    expect(find.text('12,0 Mo'), findsOneWidget);
    expect(find.textContaining('en échec'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('80 %'), findsOneWidget);
    await tester.tap(find.text('Envoyer un courriel de test'));
    expect(tested, 1);
  });

  testWidgets('admin health: uptime under a day in hours and minutes', (
    tester,
  ) async {
    Future<void> show(Duration up) async {
      final now = DateTime.now().toUtc();
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
            body: AdminHealthView(
              health: AdminHealth(
                version: '0.3.12',
                startedAt: now.subtract(up),
                serverTime: now,
                databaseOk: true,
                documentsBytes: 0,
                smtpConfigured: true,
                publicUrl: '',
              ),
              stats: AdminStats(
                users: 1,
                blockedUsers: 0,
                twoFactorUsers: 0,
                groups: 1,
                accounts: 1,
                operations: 0,
                operationsLast30Days: 0,
                importsLast30Days: 0,
                rules: 0,
                pendingInvitations: 0,
                classifiedAutomatically: 0,
                classifiedManually: 0,
                unclassified: 0,
              ),
              onTestEmail: () {},
            ),
          ),
        ),
      );
    }

    await show(const Duration(hours: 5, minutes: 7, seconds: 3));
    expect(find.text('5 h 7 min'), findsOneWidget);
    await show(const Duration(minutes: 12));
    expect(find.text('12 min'), findsOneWidget);
  });
}
