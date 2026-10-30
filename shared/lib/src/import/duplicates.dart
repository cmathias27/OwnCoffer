import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../local_date.dart';
import '../text.dart';
import 'statement.dart';

/// Version prefix: change it only with a data migration.
const _fingerprintVersion = 'v1';

/// Computes the duplicate fingerprint of each transaction of one file.
///
/// The fingerprint covers the date, the amount, the normalised label and the
/// rank of the transaction among identical ones in the same file, so that two
/// identical coffees on the same day stay two operations, while re-importing
/// an overlapping file adds nothing. It is scoped to one account by the
/// database (unique on account + fingerprint).
List<String> fingerprints(List<ParsedTransaction> transactions) {
  final seen = <String, int>{};
  return [
    for (final t in transactions)
      () {
        final base =
            '$_fingerprintVersion|${t.date}|${t.amountCents}|'
            '${normalizeForMatch(t.fullLabel)}';
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

  const ExistingTransaction({
    required this.date,
    required this.amountCents,
    this.fingerprint,
    this.bankId,
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
  // First pass: exact duplicates consume their date + amount slot.
  for (var i = 0; i < incoming.length; i++) {
    final t = incoming[i];
    final exact =
        existingPrints.contains(prints[i]) ||
        (t.bankId != null && existingBankIds.contains(t.bankId));
    if (exact) {
      statuses[i] = DuplicateStatus.duplicate;
      final key = '${t.date}|${t.amountCents}';
      final left = pool[key];
      if (left != null) pool[key] = left - 1;
    }
  }
  // Second pass: what remains with the same date + amount is suspicious.
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
