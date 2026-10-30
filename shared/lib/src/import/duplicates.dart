import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../local_date.dart';
import '../text.dart';
import 'statement.dart';

/// Version prefix: change it only with a data migration.
const _fingerprintVersion = 'v1';

final RegExp _referenceToken = RegExp(r'\S*\d{5}\S*');

/// Label part of the fingerprint: the operation label only (not the memo),
/// normalised, without tokens holding 5 digits or more. Banks write the same
/// operation differently depending on the format (QIF vs OFX): the memo moves
/// and references are appended, but the operation label stays.
String fingerprintLabel(ParsedTransaction t) => normalizeForMatch(
  t.label.replaceAll(_referenceToken, ' '),
);

/// Computes the duplicate fingerprint of each transaction of one file.
///
/// The fingerprint covers the date, the amount, the operation label (see
/// [fingerprintLabel]) and the rank of the transaction among identical ones
/// in the same file, so that two identical coffees on the same day stay two
/// operations, while re-importing an overlapping file — even in another
/// format — adds nothing. It is scoped to one account by the database
/// (unique on account + fingerprint).
List<String> fingerprints(List<ParsedTransaction> transactions) {
  final seen = <String, int>{};
  return [
    for (final t in transactions)
      () {
        final base =
            '$_fingerprintVersion|${t.date}|${t.amountCents}|'
            '${fingerprintLabel(t)}';
        final rank = seen.update(base, (n) => n + 1, ifAbsent: () => 0);
        final digest = sha256.convert(utf8.encode('$base|$rank'));
        return digest.toString().substring(0, 32);
      }(),
  ];
}

/// An operation already stored for the target account.
class ExistingTransaction {
  final LocalDate date;
  final int amountCents;
  final String? fingerprint;
  final String? bankId;

  /// Operation label as stored, to recognise the same operation exported
  /// with a longer or shorter label in another format.
  final String? label;

  const ExistingTransaction({
    required this.date,
    required this.amountCents,
    this.fingerprint,
    this.bankId,
    this.label,
  });
}

enum DuplicateStatus {
  /// Not in the account yet: will be added.
  isNew,

  /// Already imported (same fingerprint or same bank id): skipped.
  duplicate,

  /// Same date and amount as an existing operation, but a different label
  /// (often the same operation exported in another format): the user decides.
  possibleDuplicate,
}

class DuplicateCheck {
  final ParsedTransaction transaction;
  final String fingerprint;
  final DuplicateStatus status;

  const DuplicateCheck(this.transaction, this.fingerprint, this.status);
}

/// Compares a parsed file with the operations already in the account.
List<DuplicateCheck> checkDuplicates(
  List<ParsedTransaction> incoming,
  Iterable<ExistingTransaction> existing,
) {
  final prints = fingerprints(incoming);
  final existingPrints = <String>{};
  final existingBankIds = <String>{};
  // Remaining existing operations per date + amount, for possible duplicates.
  final pool = <String, int>{};
  final existingList = existing.toList();
  for (final e in existingList) {
    if (e.fingerprint != null) existingPrints.add(e.fingerprint!);
    if (e.bankId != null && e.bankId!.isNotEmpty) {
      existingBankIds.add(e.bankId!);
    }
    pool.update('${e.date}|${e.amountCents}', (n) => n + 1, ifAbsent: () => 1);
  }

  final statuses = List<DuplicateStatus?>.filled(incoming.length, null);
  final matchedPrints = <String>{};
  // First pass: exact duplicates consume their date + amount slot.
  for (var i = 0; i < incoming.length; i++) {
    final t = incoming[i];
    final exact =
        existingPrints.contains(prints[i]) ||
        (t.bankId != null && existingBankIds.contains(t.bankId));
    if (exact) {
      statuses[i] = DuplicateStatus.duplicate;
      matchedPrints.add(prints[i]);
      final key = '${t.date}|${t.amountCents}';
      final left = pool[key];
      if (left != null) pool[key] = left - 1;
    }
  }
  // Second pass: same date and amount, and one label is the other one
  // truncated (whole words) — e.g. QIF labels are shorter than OFX ones.
  final unmatched = <String, List<String>>{};
  for (final e in existingList) {
    if (e.label == null) continue;
    if (e.fingerprint != null && matchedPrints.contains(e.fingerprint)) {
      continue;
    }
    unmatched
        .putIfAbsent('${e.date}|${e.amountCents}', () => [])
        .add(normalizeForMatch(e.label!.replaceAll(_referenceToken, ' ')));
  }
  for (var i = 0; i < incoming.length; i++) {
    if (statuses[i] != null) continue;
    final key = '${incoming[i].date}|${incoming[i].amountCents}';
    final candidates = unmatched[key];
    if (candidates == null) continue;
    final mine = fingerprintLabel(incoming[i]);
    final j = candidates.indexWhere(
      (other) =>
          mine.isNotEmpty &&
          other.isNotEmpty &&
          (startsWithWords(other, mine) || startsWithWords(mine, other)),
    );
    if (j < 0) continue;
    candidates.removeAt(j);
    statuses[i] = DuplicateStatus.duplicate;
    pool[key] = (pool[key] ?? 1) - 1;
  }
  // Third pass: what remains with the same date + amount is suspicious.
  for (var i = 0; i < incoming.length; i++) {
    if (statuses[i] != null) continue;
    final key = '${incoming[i].date}|${incoming[i].amountCents}';
    final left = pool[key] ?? 0;
    if (left > 0) {
      pool[key] = left - 1;
      statuses[i] = DuplicateStatus.possibleDuplicate;
    } else {
      statuses[i] = DuplicateStatus.isNew;
    }
  }
  return [
    for (var i = 0; i < incoming.length; i++)
      DuplicateCheck(incoming[i], prints[i], statuses[i]!),
  ];
}
