import 'dart:math';

import '../local_date.dart';

/// One fictitious operation of the demo.
typedef DemoOperation = ({
  /// Index of the account in [DemoHousehold.accounts].
  int account,
  LocalDate date,
  int amountCents,
  String label,

  /// Standard category code, or null to leave it to classify.
  String? category,
});

/// A planned operation of the demo (subscription, loan instalment…).
typedef DemoPlanned = ({
  int account,
  String label,
  int amountCents,
  int dayOfMonth,
  String category,
  bool subscription,
});

/// A fictitious household for the demonstration: no real person, no real
/// bank data. The same every time (seeded random), dated relative to
/// [today] so that it always looks current.
class DemoHousehold {
  final List<({String name, int initialCents})> accounts;
  final List<DemoOperation> operations;
  final List<DemoPlanned> planned;

  /// Monthly goals: standard category code → amount.
  final Map<String, int> goals;

  const DemoHousehold._(
    this.accounts,
    this.operations,
    this.planned,
    this.goals,
  );

  factory DemoHousehold.generate(LocalDate today, {int months = 12}) {
    final r = Random(20261102);
    final ops = <DemoOperation>[];
    int vary(int cents, int percent) =>
        cents + (cents * (r.nextInt(2 * percent + 1) - percent) ~/ 100);
    LocalDate day(LocalDate monthStart, int d) {
      final last = LocalDate(
        monthStart.year,
        monthStart.month,
        1,
      ).addMonths(1).addDays(-1).day;
      return LocalDate(monthStart.year, monthStart.month, d.clamp(1, last));
    }

    final first = LocalDate(today.year, today.month, 1).addMonths(1 - months);
    for (var m = 0; m < months; m++) {
      final start = first.addMonths(m);
      void add(int account, int d, int cents, String label, String? code) {
        final date = day(start, d);
        if (date.isAfter(today)) return;
        ops.add((
          account: account,
          date: date,
          amountCents: cents,
          label: label,
          category: code,
        ));
      }

      // Income.
      add(
        0,
        27,
        248000 + (m >= 6 ? 6000 : 0),
        'VIR SALAIRE ENTREPRISE EXEMPLE',
        'income.salary',
      );
      add(1, 28, 195000, 'VIR SALAIRE ASSOCIATION DEMO', 'income.salary');
      if (start.month == 6 || start.month == 12) {
        add(0, 15, 90000, 'VIR PRIME SEMESTRIELLE', 'income.salary');
      }
      // Household account fed by both, then fixed costs.
      add(
        0,
        28,
        -90000,
        'VIR VERS COMPTE COMMUN',
        'transfers.between_accounts',
      );
      add(1, 28, 90000, 'VIR DE COMPTE COURANT', 'transfers.between_accounts');
      add(1, 1, -98000, 'PRLV LOYER AGENCE EXEMPLE', 'housing.rent');
      add(1, 6, -vary(7800, 25), 'PRLV ENERGIE DU QUARTIER', 'housing.energy');
      add(1, 9, -2999, 'PRLV BOX INTERNET', 'subscriptions.phone_internet');
      add(0, 12, -1399, 'PRLV PLATEFORME VIDEO', 'subscriptions.streaming');
      add(0, 14, -1099, 'PRLV MUSIQUE EN LIGNE', 'subscriptions.streaming');
      add(1, 10, -3450, 'PRLV ASSURANCE HABITATION', 'housing.insurance');
      add(
        0,
        5,
        -33500,
        'PRLV CREDIT AUTO BANQUE EXEMPLE',
        'transport.vehicle_loan',
      );
      add(0, 3, -2490, 'PRLV FORFAIT MOBILE', 'subscriptions.phone_internet');
      add(0, 30, -15000, 'VIR LIVRET EPARGNE', 'savings.savings_deposit');
      add(2, 30, 15000, 'VIR DEPUIS COMPTE COURANT', 'savings.savings_deposit');
      // Variable spending.
      for (final d in [3, 10, 17, 24]) {
        add(
          1,
          d,
          -vary(9500, 30),
          'CB SUPERMARCHE DU CENTRE',
          'food.groceries',
        );
      }
      for (var i = 0; i < 3 + r.nextInt(3); i++) {
        add(
          0,
          2 + r.nextInt(26),
          -vary(2800, 40),
          'CB BOULANGERIE DU COIN',
          'food.groceries',
        );
      }
      for (var i = 0; i < 2 + r.nextInt(3); i++) {
        add(
          0,
          1 + r.nextInt(27),
          -vary(3900, 50),
          'CB RESTAURANT LA TABLE',
          'food.restaurants',
        );
      }
      for (var i = 0; i < 2; i++) {
        add(
          0,
          4 + i * 13,
          -vary(6200, 20),
          'CB STATION CARBURANT',
          'transport.fuel',
        );
      }
      add(0, 18, -vary(4500, 60), 'CB CINEMA DES ARTS', 'leisure');
      if (r.nextBool()) {
        add(1, 20, -vary(6900, 40), 'CB PHARMACIE CENTRALE', 'health');
      }
      if (m % 3 == 1) {
        add(
          0,
          22,
          -vary(12000, 30),
          'CB MAGASIN DE VETEMENTS',
          'shopping.clothing',
        );
      }
      // A few left to classify, as after a real import.
      if (m >= months - 2) {
        add(0, 8, -vary(2350, 20), 'CB MARCHE DU SAMEDI', null);
        add(0, 19, -vary(5400, 20), 'PAIEMENT CB 1810 LIBRAIRIE', null);
      }
    }
    // A payment in four instalments, still running.
    final shoe = LocalDate(today.year, today.month, 1).addMonths(-3);
    for (var i = 0; i < 3; i++) {
      final d = day(shoe.addMonths(i), 7);
      if (d.isAfter(today)) continue;
      ops.add((
        account: 0,
        date: d,
        amountCents: -4500,
        label: 'ONEY 4X ${i + 1}/4',
        category: 'banking.installments',
      ));
    }
    ops.sort((a, b) => a.date.compareTo(b.date));
    return DemoHousehold._(
      const [
        (name: 'Compte courant', initialCents: 125000),
        (name: 'Compte commun', initialCents: 60000),
        (name: 'Livret', initialCents: 420000),
      ],
      ops,
      const [
        (
          account: 1,
          label: 'LOYER AGENCE EXEMPLE',
          amountCents: -98000,
          dayOfMonth: 1,
          category: 'housing.rent',
          subscription: false,
        ),
        (
          account: 1,
          label: 'BOX INTERNET',
          amountCents: -2999,
          dayOfMonth: 9,
          category: 'subscriptions.phone_internet',
          subscription: true,
        ),
        (
          account: 0,
          label: 'PLATEFORME VIDEO',
          amountCents: -1399,
          dayOfMonth: 12,
          category: 'subscriptions.streaming',
          subscription: true,
        ),
        (
          account: 0,
          label: 'MUSIQUE EN LIGNE',
          amountCents: -1099,
          dayOfMonth: 14,
          category: 'subscriptions.streaming',
          subscription: true,
        ),
        (
          account: 0,
          label: 'FORFAIT MOBILE',
          amountCents: -2490,
          dayOfMonth: 3,
          category: 'subscriptions.phone_internet',
          subscription: true,
        ),
        (
          account: 1,
          label: 'ASSURANCE HABITATION',
          amountCents: -3450,
          dayOfMonth: 10,
          category: 'housing.insurance',
          subscription: true,
        ),
        (
          account: 0,
          label: 'SALAIRE ENTREPRISE EXEMPLE',
          amountCents: 254000,
          dayOfMonth: 27,
          category: 'income.salary',
          subscription: false,
        ),
      ],
      const {
        'food.groceries': 45000,
        'food.restaurants': 12000,
        'leisure': 6000,
      },
    );
  }
}
