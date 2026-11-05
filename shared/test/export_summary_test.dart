import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

/// Two exports of the same data, ids renumbered (as on another server).
Map<String, dynamic> export({int shift = 0, int amount = -990}) => {
  'format': 'owncoffer-export',
  'accounts': [
    {
      'id': 1 + shift,
      'name': 'Courant',
      'kind': 'checking',
      'initialBalanceCents': 10000,
    },
    {
      'id': 2 + shift,
      'name': 'Livret',
      'kind': 'savings',
      'initialBalanceCents': 0,
    },
  ],
  'categories': [
    {'id': 10 + shift, 'name': 'Maison'},
    {'id': 11 + shift, 'name': 'Loyer', 'parentId': 10 + shift},
  ],
  'transactions': [
    {
      'id': 100 + shift,
      'accountId': 1 + shift,
      'amountCents': amount,
      'categoryId': 11 + shift,
    },
    {
      'id': 101 + shift,
      'accountId': 1 + shift,
      'amountCents': -5000,
      'transferPairId': 102 + shift,
    },
    {
      'id': 102 + shift,
      'accountId': 2 + shift,
      'amountCents': 5000,
      'transferPairId': 101 + shift,
    },
  ],
  'transactionSplits': [
    {'id': 7 + shift, 'transactionId': 100 + shift, 'amountCents': -990},
  ],
  'loans': [
    {'id': 3 + shift, 'principalCents': 1200000},
  ],
  'invoices': [
    {'id': 4 + shift, 'transactionId': 100 + shift, 'sizeBytes': 2048},
  ],
};

void main() {
  test('same data, other ids: same summary', () {
    final a = ExportSummary.of(export());
    final b = ExportSummary.of(export(shift: 1000));
    expect(a.differences(b), isEmpty);
    expect(a.facts['transactions.count'], '3');
    expect(a.facts['transactions.amount'], '${-990 - 5000 + 5000}');
    expect(a.facts['transactions.transfers'], '2');
    expect(a.facts['categories.children'], '1');
    expect(a.facts['account Courant (checking)'], '10000 + 2 op. = -5990');
  });

  test('a changed amount or a missing row is named', () {
    final a = ExportSummary.of(export());
    final changed = ExportSummary.of(export(amount: -991));
    expect(a.differences(changed), [
      'transactions.amount: -990 ≠ -991',
      'account Courant (checking): 10000 + 2 op. = -5990 ≠ 10000 + 2 op. = -5991',
    ]);
    final fewer = export()..['invoices'] = <Object>[];
    expect(
      a.differences(ExportSummary.of(fewer)),
      containsAll([
        'invoices.count: 1 ≠ 0',
        'invoices.bytes: 2048 ≠ 0',
        'invoices.linked: 1 ≠ 0',
      ]),
    );
  });

  test('two accounts of the same name are both checked', () {
    final doc = export();
    (doc['accounts'] as List).add({
      'id': 9,
      'name': 'Courant',
      'kind': 'checking',
      'initialBalanceCents': 1,
    });
    final s = ExportSummary.of(doc);
    expect(
      s.facts.keys.where((k) => k.startsWith('account Courant')),
      hasLength(2),
    );
  });

  test('an empty export has a summary of zeros', () {
    final s = ExportSummary.of(const {});
    expect(s.facts['transactions.count'], '0');
    expect(s.differences(ExportSummary.of(const {})), isEmpty);
  });
}
