import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/contract_simulation.dart';
import 'package:owncoffer_app/widgets/form_card.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

void main() {
  group('ContractSimulation.perDebit with interval', () {
    ScheduledTransaction makeSub({
      required ScheduleFrequency frequency,
      int interval = 1,
    }) => ScheduledTransaction(
      accountId: 1,
      amountCents: -1000,
      label: 'Test',
      frequency: frequency,
      interval: interval,
      startDate: DateTime.utc(2026, 1, 1),
    );

    test('monthly subscription respects interval', () {
      // Monthly 10 €/month -> 10 € per debit
      expect(
        ContractSimulation.perDebit(
          makeSub(frequency: ScheduleFrequency.monthly),
          1000,
        ),
        1000,
      );
      // Bimonthly 10 €/month -> 20 € per debit
      expect(
        ContractSimulation.perDebit(
          makeSub(frequency: ScheduleFrequency.monthly, interval: 2),
          1000,
        ),
        2000,
      );
      // Quarterly 10 €/month -> 30 € per debit
      expect(
        ContractSimulation.perDebit(
          makeSub(frequency: ScheduleFrequency.monthly, interval: 3),
          1000,
        ),
        3000,
      );
    });

    test('yearly subscription respects interval', () {
      // Yearly 10 €/month -> 120 € per debit
      expect(
        ContractSimulation.perDebit(
          makeSub(frequency: ScheduleFrequency.yearly),
          1000,
        ),
        12000,
      );
      // Every 2 years 10 €/month -> 240 € per debit
      expect(
        ContractSimulation.perDebit(
          makeSub(frequency: ScheduleFrequency.yearly, interval: 2),
          1000,
        ),
        24000,
      );
    });
  });

  group('AsyncAction resilience when unmounted', () {
    testWidgets('does not throw when context is unmounted during call', (
      tester,
    ) async {
      final action = AsyncAction();
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: StatefulBuilder(
            builder: (context, setState) {
              return ElevatedButton(
                onPressed: () {
                  action.run(context, setState, () => completer.future);
                },
                child: const Text('Go'),
              );
            },
          ),
        ),
      );

      // Start the async action
      await tester.tap(find.text('Go'));
      await tester.pump();
      expect(action.busy, isTrue);

      // Unmount the widget tree before completer finishes
      await tester.pumpWidget(const SizedBox());

      // Complete with an error while unmounted
      completer.completeError(Exception('Server error'));
      await tester.pumpAndSettle();

      // No exception was thrown by setState, action completed cleanly
      expect(action.busy, isTrue); // setState wasn't called to flip it back
    });
  });
}
