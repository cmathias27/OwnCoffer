import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/update_progress_screen.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

UpdateOverview _o({
  String running = '0.3.19',
  String? target,
  String? step,
  bool pending = false,
}) => UpdateOverview(
  available: true,
  runningVersion: running,
  auto: true,
  requestPending: pending,
  progressTarget: target,
  progressStep: step,
  history: const [],
  releases: const [],
);

void main() {
  const v = 'v0.3.20';
  ({UpdateStep step, UpdateOutcome outcome}) at(
    UpdateOverview? o, {
    bool unreachable = false,
  }) => updateProgress(o, v, unreachable: unreachable);

  test('steps as the host writes them, the restart included', () {
    expect(at(_o(pending: true)).step, UpdateStep.requested);
    expect(
      at(_o(target: 'v0.3.19', step: 'done')).step,
      UpdateStep.requested,
      reason: 'an earlier installation',
    );
    expect(at(_o(target: v, step: 'pull')).step, UpdateStep.pull);
    expect(at(_o(target: v, step: 'backup')).step, UpdateStep.backup);
    expect(at(_o(target: v, step: 'start')).step, UpdateStep.start);
    expect(
      at(_o(target: v, step: 'backup'), unreachable: true).step,
      UpdateStep.start,
      reason: 'no answer: the server restarts',
    );
    expect(at(_o(target: v, step: 'check')).outcome, UpdateOutcome.running);
    expect(
      at(_o(running: '0.3.20', target: v, step: 'check')),
      (step: UpdateStep.done, outcome: UpdateOutcome.done),
      reason: 'done once the new server answers',
    );
    expect(at(_o(target: v, step: 'failed')).outcome, UpdateOutcome.failed);
    expect(at(_o(target: v, step: 'waiting')).outcome, UpdateOutcome.waiting);
  });

  testWidgets('held page: steps listed, no way back while it runs', (
    tester,
  ) async {
    client = Client('http://localhost:9/');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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
        home: const UpdateProgressScreen(
          target: v,
          every: Duration(milliseconds: 200),
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(tester.takeException(), isNull);
    expect(find.text('Mise à jour vers v0.3.20'), findsOneWidget);
    expect(find.text('Sauvegarde de vos données'), findsOneWidget);
    expect(
      find.textContaining('le serveur ne répond pas'),
      findsOneWidget,
      reason: 'no server in tests: shown as the restart',
    );
    final scope = tester.widget<PopScope>(find.byType(PopScope));
    expect(scope.canPop, isFalse);
    expect(find.text('Fermer'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
