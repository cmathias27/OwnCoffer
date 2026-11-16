import 'package:owncoffer_server/src/finance/forecast_service.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Deferred card and multi-account budget (decision 0052)', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue alice, mallory;
    late int groupA, groupB;
    late Account checkingA, cardA, checkingB;

    final denied = throwsA(isA<AccessDeniedException>());
    final invalid = throwsA(isA<InvalidInputException>());

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );

    Future<UuidValue> makeUser([Set<String> scopes = const {}]) async =>
        (await AuthUser.db.insertRow(
          db,
          AuthUser(
            createdAt: DateTime.now(),
            scopeNames: scopes,
            blocked: false,
          ),
        )).id!;

    setUp(() async {
      db = sessionBuilder.build();
      alice = await makeUser({'owncoffer.serverAdmin'});
      mallory = await makeUser({'owncoffer.serverAdmin'});

      groupA = (await endpoints.group.create(as(alice), 'Famille A')).group.id!;
      groupB = (await endpoints.group.create(
        as(mallory),
        'Famille B',
      )).group.id!;

      checkingA = await endpoints.account.create(
        as(alice),
        groupA,
        'Compte Courant A',
        AccountKind.checking,
        initialBalanceCents: 100000,
      );

      checkingB = await endpoints.account.create(
        as(mallory),
        groupB,
        'Compte Courant B',
        AccountKind.checking,
      );
    });

    test(
      'account creation and update validates deferred card parameters',
      () async {
        // 1) Validation of cutoff and debit days
        await expectLater(
          endpoints.account.create(
            as(alice),
            groupA,
            'Carte invalide',
            AccountKind.deferredCard,
            statementCutoffDay: 35,
          ),
          invalid,
        );
        await expectLater(
          endpoints.account.create(
            as(alice),
            groupA,
            'Carte invalide',
            AccountKind.deferredCard,
            statementDebitDay: 0,
          ),
          invalid,
        );

        // 2) Isolation: linking an account from another group is refused
        await expectLater(
          endpoints.account.create(
            as(alice),
            groupA,
            'Carte espionne',
            AccountKind.deferredCard,
            statementCutoffDay: 28,
            statementDebitDay: 4,
            linkedAccountId: checkingB.id!,
          ),
          denied,
        );

        // 3) Valid creation
        cardA = await endpoints.account.create(
          as(alice),
          groupA,
          'Carte Débit Différé',
          AccountKind.deferredCard,
          statementCutoffDay: 28,
          statementDebitDay: 4,
          linkedAccountId: checkingA.id!,
        );
        expect(cardA.statementCutoffDay, equals(28));
        expect(cardA.statementDebitDay, equals(4));
        expect(cardA.linkedAccountId, equals(checkingA.id!));

        // 4) Update parameters
        final updated = await endpoints.account.update(
          as(alice),
          cardA.id!,
          statementCutoffDay: 25,
          statementDebitDay: 5,
        );
        expect(updated.statementCutoffDay, equals(25));
        expect(updated.statementDebitDay, equals(5));

        // 5) Clear linked account
        final cleared = await endpoints.account.update(
          as(alice),
          cardA.id!,
          clearLinkedAccountId: true,
        );
        expect(cleared.linkedAccountId, isNull);
      },
    );

    test(
      'balance of deferred card is restricted to the active billing cycle',
      () async {
        cardA = await endpoints.account.create(
          as(alice),
          groupA,
          'Carte Débit Différé',
          AccountKind.deferredCard,
          statementCutoffDay: 28,
          statementDebitDay: 4,
        );

        final today = core.LocalDate(2026, 11, 16);
        // Active cycle: 2026-10-29 .. 2026-11-28
        // 1) Operation in previous cycle (2026-10-15): -100,00 €
        await BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: cardA.id!,
            date: DateTime.utc(2026, 10, 15),
            rawLabel: 'Achat mois dernier',
            cleanLabel: 'Achat mois dernier',
            operationKind: 'card',
            amountCents: -10000,
          ),
        );

        // 2) Operations in active cycle (2026-11-05 and 2026-11-12): -50,00 € and -30,00 €
        await BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: cardA.id!,
            date: DateTime.utc(2026, 11, 5),
            rawLabel: 'Courses',
            cleanLabel: 'Courses',
            operationKind: 'card',
            amountCents: -5000,
          ),
        );
        await BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: cardA.id!,
            date: DateTime.utc(2026, 11, 12),
            rawLabel: 'Carburant',
            cleanLabel: 'Carburant',
            operationKind: 'card',
            amountCents: -3000,
          ),
        );

        // BalancesOf only sums active cycle (-80,00 €)
        final balances = await ForecastService.balancesOf(db, cardA, today);
        expect(balances.currentCents, equals(-8000));

        // ForecastResult exposes cycle dates
        final forecast = await ForecastService.compute(
          db,
          cardA,
          today,
        );
        expect(forecast.currentBalanceCents, equals(-8000));
        expect(forecast.deferredCutoffDate, equals(DateTime.utc(2026, 11, 28)));
        expect(forecast.deferredDebitDate, equals(DateTime.utc(2026, 12, 4)));
        expect(forecast.deferredPendingDebitCents, isNull);

        // On 2026-11-29 (between cutoff and debit day): previous cycle pending debit is exposed
        final forecastAfterCutoff = await ForecastService.compute(
          db,
          cardA,
          core.LocalDate(2026, 11, 29),
        );
        // Active cycle is now 2026-11-29..2026-12-28 (0 € spent so far)
        expect(forecastAfterCutoff.currentBalanceCents, equals(0));
        expect(
          forecastAfterCutoff.deferredCutoffDate,
          equals(DateTime.utc(2026, 12, 28)),
        );
        expect(
          forecastAfterCutoff.deferredDebitDate,
          equals(DateTime.utc(2027, 1, 4)),
        );
        // Previous cycle (ended 28 Nov) has -80,00 € pending debit
        expect(forecastAfterCutoff.deferredPendingDebitCents, equals(-8000));
        expect(
          forecastAfterCutoff.deferredPendingDebitDate,
          equals(DateTime.utc(2026, 12, 4)),
        );

        // Endpoint verification with current date
        final endpointForecast = await endpoints.scheduled.forecast(
          as(alice),
          cardA.id!,
          DateTime.now().toUtc(),
        );
        expect(endpointForecast.deferredCutoffDate, isNotNull);
        expect(endpointForecast.deferredDebitDate, isNotNull);
      },
    );

    test('multi-account budget analysis and isolation', () async {
      cardA = await endpoints.account.create(
        as(alice),
        groupA,
        'Carte Débit Différé',
        AccountKind.deferredCard,
        statementCutoffDay: 28,
        statementDebitDay: 4,
      );

      // Operations on checking account
      await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: checkingA.id!,
          date: DateTime.utc(2026, 11, 10),
          rawLabel: 'Loyer',
          cleanLabel: 'Loyer',
          operationKind: 'directDebit',
          amountCents: -70000,
        ),
      );

      // Operation on card
      await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: cardA.id!,
          date: DateTime.utc(2026, 11, 11),
          rawLabel: 'Restaurant',
          cleanLabel: 'Restaurant',
          operationKind: 'card',
          amountCents: -5000,
        ),
      );

      final date = DateTime.utc(2026, 11, 16);

      // 1) Multi-account selection combines operations from both accounts
      final rep = await endpoints.analysis.report(
        as(alice),
        groupA,
        BudgetPeriod.month,
        date,
        accountIds: [checkingA.id!, cardA.id!],
      );
      expect(rep.expenseCents, equals(75000));

      final ops = await endpoints.analysis.operations(
        as(alice),
        groupA,
        BudgetPeriod.month,
        date,
        accountIds: [checkingA.id!, cardA.id!],
      );
      expect(ops.length, equals(2));

      final ltl = await endpoints.analysis.leftToLive(
        as(alice),
        groupA,
        accountIds: [checkingA.id!, cardA.id!],
      );
      expect(ltl.accountIds, containsAll([checkingA.id!, cardA.id!]));

      final rev = await endpoints.analysis.review(
        as(alice),
        groupA,
        date,
        accountIds: [checkingA.id!, cardA.id!],
      );
      expect(rev.expenseCents, equals(75000));

      // 2) Isolation check: including an account from groupB is rejected
      await expectLater(
        endpoints.analysis.report(
          as(alice),
          groupA,
          BudgetPeriod.month,
          date,
          accountIds: [checkingA.id!, checkingB.id!],
        ),
        denied,
      );
      await expectLater(
        endpoints.analysis.operations(
          as(alice),
          groupA,
          BudgetPeriod.month,
          date,
          accountIds: [checkingA.id!, checkingB.id!],
        ),
        denied,
      );
      await expectLater(
        endpoints.analysis.leftToLive(
          as(alice),
          groupA,
          accountIds: [checkingA.id!, checkingB.id!],
        ),
        denied,
      );
      await expectLater(
        endpoints.analysis.review(
          as(alice),
          groupA,
          date,
          accountIds: [checkingA.id!, checkingB.id!],
        ),
        denied,
      );
    });
  });
}
