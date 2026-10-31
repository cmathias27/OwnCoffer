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
}
