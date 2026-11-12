import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/loan_check.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

BankTransaction _debit(int id, DateTime date, int cents) => BankTransaction(
  id: id,
  accountId: 7,
  date: date,
  amountCents: -cents,
  rawLabel: 'PRLV PRET',
  cleanLabel: 'PRET',
  operationKind: 'directDebit',
  categorySource: CategorySource.groupRule,
);

LoanCheckReport _report(List<LoanCheckLine> lines) => LoanCheckReport(
  available: true,
  historyFrom: DateTime.utc(2026, 1, 1),
  historyTo: DateTime.utc(2026, 6, 30),
  paidCount: 4,
  lines: lines,
);

void main() {
  Future<void> show(WidgetTester tester, LoanCheckReport r) =>
      tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Scaffold(body: LoanCheckView(report: r)),
        ),
      );

  testWidgets('all instalments debited', (tester) async {
    await show(tester, _report(const []));
    expect(find.textContaining('Les 4 échéances'), findsOneWidget);
    expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
    expect(find.textContaining('Le tableau de la banque fait foi'), findsOne);
  });

  testWidgets('each problem shown with its figures', (tester) async {
    await show(
      tester,
      _report([
        LoanCheckLine(
          status: LoanCheckStatus.missing,
          number: 3,
          dueDate: DateTime.utc(2026, 3, 5),
          expectedCents: 92000,
          gapCents: 0,
          debits: const [],
        ),
        LoanCheckLine(
          status: LoanCheckStatus.differentAmount,
          number: 5,
          dueDate: DateTime.utc(2026, 5, 5),
          expectedCents: 92000,
          gapCents: 1500,
          debits: [_debit(1, DateTime.utc(2026, 5, 5), 93500)],
        ),
      ]),
    );
    expect(find.textContaining('2 points à vérifier'), findsOneWidget);
    expect(find.textContaining('Échéance 3'), findsOneWidget);
    expect(find.textContaining('aucun prélèvement trouvé'), findsOneWidget);
    expect(find.textContaining('Échéance 5'), findsOneWidget);
    expect(find.textContaining('au lieu de'), findsOneWidget);
    expect(find.byIcon(Icons.report_problem_outlined), findsOneWidget);
  });

  test('hidden without account or history', () {
    expect(LoanCheckView.shows(null), isFalse);
    expect(
      LoanCheckView.shows(
        LoanCheckReport(available: false, paidCount: 0, lines: const []),
      ),
      isFalse,
    );
    expect(LoanCheckView.shows(_report(const [])), isTrue);
  });
}
