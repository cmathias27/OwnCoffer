import 'dart:io';

import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

/// Fictional exports reproducing the structure of real Caisse d'Épargne
/// files (see test/fixtures/README.md): CRLF, newest first, QIF `P`/`M` and
/// OFX `MEMO`/`NAME` holding the same two texts the other way round, a
/// reference appended to direct debits in OFX, NAME truncated to 32 chars.
void main() {
  final qif = parseQif(File('test/fixtures/ce_export.qif').readAsBytesSync());
  final ofx = parseOfx(File('test/fixtures/ce_export.ofx').readAsBytesSync());

  test('both formats read without any issue', () {
    expect(qif.issues, isEmpty);
    expect(ofx.issues, isEmpty);
    expect(qif.transactions, hasLength(20));
    expect(ofx.transactions, hasLength(20));
  });

  test('same amounts and dates, to the cent', () {
    for (var i = 0; i < 20; i++) {
      expect(ofx.transactions[i].date, qif.transactions[i].date);
      expect(ofx.transactions[i].amountCents, qif.transactions[i].amountCents);
    }
    final total = sumCents(qif.transactions.map((t) => t.amountCents));
    expect(total, 63917);
    expect(ofx.statedBalanceCents, 120000 + total);
  });

  test('OFX operation label comes from MEMO, like QIF P', () {
    expect(ofx.transactions[2].label, 'CB CARREFOUR MARKET FACT 281026');
    expect(ofx.transactions[2].memo, 'CARREFOUR MARKET');
    expect(qif.transactions[2].label, 'CB CARREFOUR MARKET FACT 281026');
    expect(qif.transactions[2].memo, 'CARREFOUR MARKET');
    expect(ofx.transactions[5].label, 'PRLV FREE MOBILE 1234567G00000001');
  });

  test('importing the other format afterwards adds no duplicate', () {
    for (final pair in [(qif, ofx), (ofx, qif)]) {
      final existing = [
        for (final c in checkDuplicates(pair.$1.transactions, const []))
          ExistingTransaction(
            date: c.transaction.date,
            amountCents: c.transaction.amountCents,
            fingerprint: c.fingerprint,
            bankId: c.transaction.bankId,
            label: c.transaction.label,
          ),
      ];
      final r = checkDuplicates(pair.$2.transactions, existing);
      expect(
        r.map((c) => c.status).toSet(),
        {DuplicateStatus.duplicate},
        reason: '${pair.$2.format.name} after ${pair.$1.format.name}',
      );
    }
  });

  test('a truncated label in the other format is still a duplicate', () {
    final short = ParsedTransaction(
      date: LocalDate(2026, 10, 26),
      amountCents: -3500,
      label: 'VIR PERSONNE',
    );
    final long = ExistingTransaction(
      date: LocalDate(2026, 10, 26),
      amountCents: -3500,
      fingerprint: 'x',
      label: 'VIR PERSONNE FICTIVE LOYER GARAGE OCTOBRE 1234567G0000',
    );
    expect(
      checkDuplicates([short], [long]).single.status,
      DuplicateStatus.duplicate,
    );
    // Not a word prefix: still only a possible duplicate.
    final other = ParsedTransaction(
      date: LocalDate(2026, 10, 26),
      amountCents: -3500,
      label: 'VIR PERS',
    );
    expect(
      checkDuplicates([other], [long]).single.status,
      DuplicateStatus.possibleDuplicate,
    );
  });

  test('the two identical bakery purchases stay two operations', () {
    final prints = fingerprints(qif.transactions);
    expect(prints.toSet(), hasLength(20));
  });

  test('operation kinds and short labels', () {
    final expected = <String, (String, OperationKind)>{
      'VIR SEPA CPAM EXEMPLE': ('CPAM EXEMPLE', OperationKind.transfer),
      'CB CARREFOUR MARKET FACT 281026': (
        'CARREFOUR MARKET',
        OperationKind.card,
      ),
      'PRLV FREE MOBILE': ('FREE MOBILE', OperationKind.directDebit),
      'PRLV EDF clients particuliers': (
        'EDF CLIENTS PARTICULIERS',
        OperationKind.directDebit,
      ),
      'RETRAIT DAB 26 10 12345 678901': (
        'RETRAIT DAB',
        OperationKind.withdrawal,
      ),
      'ECH PRET 123456E DU 27 10 26': ('ECH PRET', OperationKind.loan),
      'FORMULE FAMILLE CONFORT': ('FAMILLE CONFORT', OperationKind.fee),
      'REM OFFRE CONFORT': ('CONFORT', OperationKind.fee),
      'MIN FORFAIT INTERET DEBITEUR': (
        'INTERET DEBITEUR',
        OperationKind.fee,
      ),
      'COM CB INT CA': ('CB INT CA', OperationKind.fee),
    };
    for (final format in [qif, ofx]) {
      for (final t in format.transactions) {
        final want =
            expected[t.label] ??
            expected[t.label.replaceAll(RegExp(r' \d+G\d+$'), '')];
        if (want == null) continue;
        final c = cleanCaisseEpargneLabel(t.label);
        expect((c.display, c.kind), want, reason: t.label);
      }
    }
    final other = [
      for (final t in ofx.transactions)
        if (cleanCaisseEpargneLabel(t.label).kind == OperationKind.other)
          t.label,
    ];
    expect(other, isEmpty);
  });
}
