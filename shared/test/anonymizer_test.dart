import 'dart:io';

import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:owncoffer_shared/src/tools/anonymizer.dart';
import 'package:test/test.dart';

List<int> fixture(String name) => File('test/fixtures/$name').readAsBytesSync();

void main() {
  StatementAnonymizer make() => StatementAnonymizer(
    amountFactor: 1.1,
    salt: 'test',
    replacements: {'BOULANGERIE DU COIN': 'COMMERCE LOCAL'},
  );

  void checkSameShape(String name, ParsedStatement Function(List<int>) read) {
    final a = make();
    final original = read(fixture(name));
    final anonymised = read(a.anonymize(fixture(name)));
    expect(anonymised.encoding, original.encoding);
    expect(
      anonymised.issues.map((i) => i.code),
      original.issues.map((i) => i.code),
    );
    expect(anonymised.transactions, hasLength(original.transactions.length));
    for (var i = 0; i < original.transactions.length; i++) {
      final o = original.transactions[i];
      final n = anonymised.transactions[i];
      expect(n.date, o.date, reason: 'dates are kept');
      expect(n.amountCents, a.scaleCents(o.amountCents));
    }
  }

  test('QIF keeps its shape; amounts scaled, transfers and words replaced', () {
    checkSameShape('sample_bank.qif', parseQif);
    final s = parseQif(make().anonymize(fixture('sample_bank.qif')));
    final labels = s.transactions.map((t) => t.label).toList();
    expect(labels, contains('VIR SEPA RECU TIERS A'));
    expect(
      labels,
      contains('CB COMMERCE LOCAL FACT 021026'),
      reason: 'compact dates are kept',
    );
    expect(labels, contains('CB CARREFOUR MARKET FACT 021026'));
    expect(s.transactions.first.memo, isNot(contains('2026100001')));
    // Identical coffees stay identical.
    expect(s.transactions[3].amountCents, s.transactions[4].amountCents);
  });

  test('OFX keeps its shape; ids and balance changed', () {
    checkSameShape('sample_sgml.ofx', parseOfx);
    final a = make();
    final s = parseOfx(a.anonymize(fixture('sample_sgml.ofx')));
    expect(s.accountNumber, isNot('00000000000'));
    expect(s.accountNumber, hasLength(11));
    expect(s.statedBalanceCents, a.scaleCents(138581));
    expect(s.transactions[1].label, 'VIR SEPA RECU TIERS A');
    expect(s.transactions[1].memo, 'MOTIF');
    checkSameShape('sample_xml.ofx', parseOfx);
  });

  test('CSV (UTF-8 and Windows-1252) keeps its shape', () {
    checkSameShape('sample_bank.csv', parseCsv);
    checkSameShape('sample_legacy_cp1252.csv', parseCsv);
    final bytes = make().anonymize(fixture('sample_legacy_cp1252.csv'));
    expect(decodeBankFile(bytes).text, contains('CAFÉ DE LA GARE'));
    expect(decodeBankFile(bytes).text, isNot(contains('00000000000')));
  });

  test('random factor is never 1 and stays in range', () {
    for (var i = 0; i < 200; i++) {
      final f = StatementAnonymizer().amountFactor;
      expect(f, inInclusiveRange(0.7, 1.3));
      expect(f, isNot(1.0));
    }
  });
}
