import '../local_date.dart';

/// A debit that may be an instalment of a payment in several times (or of
/// a small consumer loan): its label as cleaned by the import.
typedef InstalmentDebit = ({
  int id,
  int accountId,
  LocalDate date,
  int amountCents,
  String label,
});

/// Debits of one account sharing a label, read as one payment in
/// instalments, oldest first.
class InstalmentPlan {
  final int accountId;

  /// The label without its instalment number ("ONEY 4X").
  final String label;
  final List<InstalmentDebit> debits;

  /// The number of instalments written in the labels ("4X", "2/4",
  /// "EN 3 FOIS"), when there is one.
  final int? statedCount;

  const InstalmentPlan({
    required this.accountId,
    required this.label,
    required this.debits,
    required this.statedCount,
  });

  /// The last instalment debited (positive).
  int get amountCents => -debits.last.amountCents;
  int get paidCount => debits.length;
  LocalDate get first => debits.first.date;
  LocalDate get last => debits.last.date;

  /// The count to propose; the user sets the right one. Without a stated
  /// count, 4 (the most usual) or what was already paid if more.
  int get suggestedCount => statedCount ?? (paidCount > 4 ? paidCount : 4);
}

final _numbered = RegExp(r'\b(\d{1,2})\s*/\s*(\d{1,2})\b');
final _times = RegExp(r'\b(\d{1,2})\s*(?:X|FOIS)\b', caseSensitive: false);

/// The number of instalments written in [label], from 2 to 60: "2/4" gives
/// 4, "4X" or "EN 4 FOIS" gives 4.
int? statedInstalmentCount(String label) {
  for (final m in _numbered.allMatches(label)) {
    final paid = int.parse(m[1]!), total = int.parse(m[2]!);
    if (paid >= 1 && paid <= total && total >= 2 && total <= 60) return total;
  }
  for (final m in _times.allMatches(label)) {
    final n = int.parse(m[1]!);
    if (n >= 2 && n <= 60) return n;
  }
  return null;
}

/// [label] without its instalment number ("ONEY 4X 2/4" → "ONEY 4X"), so
/// that every instalment of a plan has the same one.
String instalmentPlanLabel(String label) => label
    .replaceAll(_numbered, ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim()
    .toUpperCase();

/// The payments in instalments still running among [debits]: grouped by
/// account and label, the last one debited within [activeDays] of [today],
/// and not yet paid off when their count is known. Largest instalment
/// first.
List<InstalmentPlan> detectInstalmentPlans(
  Iterable<InstalmentDebit> debits, {
  required LocalDate today,
  int activeDays = 70,
}) {
  final groups = <(int, String), List<InstalmentDebit>>{};
  for (final d in debits) {
    if (d.amountCents >= 0) continue;
    final key = (d.accountId, instalmentPlanLabel(d.label));
    if (key.$2.isEmpty) continue;
    (groups[key] ??= []).add(d);
  }
  final plans = <InstalmentPlan>[];
  for (final MapEntry(key: (account, label), value: list) in groups.entries) {
    list.sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
    int? stated;
    for (final d in list) {
      stated ??= statedInstalmentCount(d.label);
    }
    final plan = InstalmentPlan(
      accountId: account,
      label: label,
      debits: list,
      statedCount: stated,
    );
    if (plan.last.daysUntil(today) > activeDays) continue;
    if (stated != null && plan.paidCount >= stated) continue;
    plans.add(plan);
  }
  plans.sort((a, b) {
    final c = b.amountCents.compareTo(a.amountCents);
    if (c != 0) return c;
    final n = a.label.compareTo(b.label);
    return n != 0 ? n : a.accountId.compareTo(b.accountId);
  });
  return plans;
}
