import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  final added = LocalDate(2026, 10, 31);
  MatchCandidate op(int id, LocalDate d, int cents, String label) =>
      MatchCandidate(id: id, date: d, amountCents: cents, label: label);
  final ops = [
    op(1, LocalDate(2026, 10, 28), -49900, 'DARTY PARIS'),
    op(2, LocalDate(2026, 10, 2), -49900, 'BOULANGER'),
    op(3, LocalDate(2026, 10, 29), -4500, 'CARREFOUR'),
    op(4, LocalDate(2026, 10, 30), 49900, 'REMBOURSEMENT DARTY'),
    op(5, LocalDate(2026, 10, 29), -50200, 'DARTY'),
    op(6, LocalDate(2025, 1, 1), -49900, 'DARTY'),
  ];
  List<int> ids(InvoiceHint h, {int max = 5}) => [
    for (final m in rankInvoiceMatches(h, ops, max: max)) m.candidate.id,
  ];

  test('same amount first, the nearest date breaking ties', () {
    final h = InvoiceHint(addedOn: added, amountCents: 49900);
    expect(ids(h), [1, 2, 5], reason: 'credit and old debit excluded');
    expect(invoiceMatchScore(h, ops[0]), 65);
    expect(invoiceMatchScore(h, ops[4]), 35, reason: 'within 1 %');
    expect(invoiceMatchScore(h, ops[2]), isNull);
  });

  test('date and merchant raise the right one', () {
    final h = InvoiceHint(
      addedOn: added,
      amountCents: 49900,
      date: LocalDate(2026, 10, 2),
      merchant: 'Boulanger',
    );
    expect(ids(h).first, 2);
    expect(invoiceMatchScore(h, ops[1]), 100);
  });

  test('a merchant alone keeps only operations naming it', () {
    final h = InvoiceHint(addedOn: added, merchant: 'Darty');
    expect(ids(h), [5, 1]);
  });

  test('no hint: recent debits before it was saved', () {
    final h = InvoiceHint(addedOn: added);
    expect(h.isEmpty, isTrue);
    expect(ids(h, max: 3), [5, 3, 1], reason: 'same day: newest entry first');
    expect(h.window.from, LocalDate(2026, 8, 2));
  });
}
