import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/screens/loans_screen.dart';
import 'package:owncoffer_app/widgets/budget_charts.dart';

void main() {
  test('rates are read in thousandths of a percent, without double', () {
    expect(parseRateMilli('3,45'), 3450);
    expect(parseRateMilli('3.125'), 3125);
    expect(parseRateMilli(' 0 '), 0);
    expect(parseRateMilli('12 %'), 12000);
    expect(parseRateMilli('1,2345'), isNull);
    expect(parseRateMilli('-1'), isNull);
    expect(parseRateMilli('abc'), isNull);
  });

  testWidgets('income / expense chart: legend, tooltip on tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: IncomeExpenseChart(
              points: [
                for (var i = 0; i < 6; i++)
                  IncomeExpensePoint(
                    label: 'M$i',
                    tooltipTitle: 'Mois $i',
                    incomeCents: 200000 + i * 1000,
                    expenseCents: 150000 + i * 5000,
                  ),
              ],
              incomeLabel: 'Revenus',
              expenseLabel: 'Dépenses',
              netLabel: 'Reste',
              semanticLabel: 'chart',
              money: (c) => '${c ~/ 100} €',
              axisMoney: (c) => '${c ~/ 100}',
            ),
          ),
        ),
      ),
    );
    expect(find.text('Revenus'), findsOneWidget);
    expect(find.text('Dépenses'), findsOneWidget);
    expect(find.text('Mois 5'), findsNothing);
    // Last slot: right edge of the plot.
    final box = tester.getRect(find.byType(CustomPaint).last);
    await tester.tapAt(Offset(box.right - 10, box.center.dy));
    await tester.pump();
    expect(find.text('Mois 5'), findsOneWidget);
    expect(find.text('2050 €'), findsOneWidget);
    expect(find.text('1750 €'), findsOneWidget);
    expect(find.text('300 €'), findsOneWidget, reason: 'net');
    expect(tester.takeException(), isNull);
  });
}
