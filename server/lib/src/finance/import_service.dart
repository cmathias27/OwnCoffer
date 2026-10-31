import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/bank_account_key.dart';
import 'classification_service.dart';

/// One parsed line with everything computed for it.
class _Line {
  final int index;
  final core.ParsedTransaction parsed;
  final String fingerprint;
  final core.DuplicateStatus status;
  final core.CleanedLabel cleaned;
  final core.Classification<int> classification;

  _Line(
    this.index,
    this.parsed,
    this.fingerprint,
    this.status,
    this.cleaned,
    this.classification,
  );
}

class _Analysis {
  final core.ParsedStatement statement;
  final List<_Line> lines;
  final String fileHash;
  final bool sameFileAlreadyImported;

  _Analysis(
    this.statement,
    this.lines,
    this.fileHash,
    this.sameFileAlreadyImported,
  );
}

/// Bank file import (roadbook phase 3, issue #49). The file is always read
/// again on the server: nothing computed by the app is trusted.
abstract final class ImportService {
  static core.CsvMapping? _mapping(CsvColumns? c) => c == null
      ? null
      : core.CsvMapping(
          delimiter: c.delimiter,
          headerRow: c.headerRow,
          dateColumn: c.dateColumn,
          labelColumn: c.labelColumn,
          memoColumn: c.memoColumn,
          amountColumn: c.amountColumn,
          debitColumn: c.debitColumn,
          creditColumn: c.creditColumn,
          dateOrder: c.monthFirst
              ? core.DateOrder.monthDayYear
              : core.DateOrder.dayMonthYear,
        );

  static core.ParsedStatement read(List<int> bytes, CsvColumns? columns) {
    try {
      return core.readStatement(bytes, csvMapping: _mapping(columns));
    } on core.StatementFormatException catch (e) {
      throw InvalidInputException(code: 'import_${e.code}', field: 'file');
    }
  }

  static Future<_Analysis> _analyse(
    Session session,
    Account account,
    List<int> bytes,
    CsvColumns? columns, {
    Transaction? transaction,
  }) async {
    final statement = read(bytes, columns);
    final txs = statement.transactions;
    final fileHash = sha256.convert(bytes).toString();
    final sameFile =
        await StatementImport.db.count(
          session,
          where: (i) =>
              i.accountId.equals(account.id!) &
              i.fileHash.equals(fileHash) &
              i.cancelledAt.equals(null),
          transaction: transaction,
        ) >
        0;

    var existing = <BankTransaction>[];
    if (txs.isNotEmpty) {
      final from = statement.firstDate!.addDays(-1).toDb();
      final to = statement.lastDate!.addDays(1).toDb();
      existing = await BankTransaction.db.find(
        session,
        where: (t) =>
            t.accountId.equals(account.id!) &
            t.deletedAt.equals(null) &
            (t.date >= from) &
            (t.date <= to),
        transaction: transaction,
      );
    }
    final checks = core.checkDuplicates(txs, [
      for (final e in existing)
        core.ExistingTransaction(
          date: e.date.toLocalDate(),
          amountCents: e.amountCents,
          fingerprint: e.fingerprint,
          bankId: e.bankId,
          label: e.rawLabel,
        ),
    ]);
    final classifier = await ClassificationService.forGroup(
      session,
      account.groupId,
      transaction: transaction,
    );
    final lines = <_Line>[];
    for (var i = 0; i < txs.length; i++) {
      final cleaned = core.cleanCaisseEpargneLabel(
        txs[i].label,
        memo: txs[i].memo,
      );
      lines.add(
        _Line(
          i,
          txs[i],
          checks[i].fingerprint,
          checks[i].status,
          cleaned,
          classifier.classify(cleaned, txs[i].amountCents),
        ),
      );
    }
    return _Analysis(statement, lines, fileHash, sameFile);
  }

  static String _status(core.DuplicateStatus s) => switch (s) {
    core.DuplicateStatus.isNew => 'new',
    core.DuplicateStatus.duplicate => 'duplicate',
    core.DuplicateStatus.possibleDuplicate => 'possibleDuplicate',
  };

  /// The visible account of the group whose number matches the file. Only
  /// accounts the user can see are considered: a restricted account is never
  /// revealed.
  static Future<int?> _recognise(
    Session session,
    Account account,
    core.ParsedStatement s,
  ) async {
    final key = bankAccountKey(s.accountNumber);
    if (key == null) return null;
    if (account.bankAccountKey == key) return account.id;
    final visible = await Access.visibleAccounts(session, account.groupId);
    return visible.where((a) => a.bankAccountKey == key).firstOrNull?.id;
  }

  /// First OFX import into an account: it remembers the number's key, unless
  /// another account of the group already has it.
  static Future<void> _learnBankAccount(
    Session session,
    Account account,
    core.ParsedStatement s,
    Transaction tx,
  ) async {
    final key = bankAccountKey(s.accountNumber);
    if (key == null || account.bankAccountKey != null) return;
    final taken = await Account.db.count(
      session,
      where: (a) =>
          a.groupId.equals(account.groupId) & a.bankAccountKey.equals(key),
      transaction: tx,
    );
    if (taken > 0) return;
    await Account.db.updateRow(
      session,
      account.copyWith(bankAccountKey: key),
      transaction: tx,
    );
  }

  static bool _otherBankAccount(Account account, core.ParsedStatement s) {
    final key = bankAccountKey(s.accountNumber);
    return key != null &&
        account.bankAccountKey != null &&
        account.bankAccountKey != key;
  }

  /// Balance on [day] if the new lines were imported: initial balance,
  /// operations already in the account and new lines dated [day] or earlier.
  static Future<int> _balanceAfterImport(
    Session session,
    Account account,
    _Analysis a,
    core.LocalDate day,
  ) async {
    final until = day.toDb();
    final existing = await BankTransaction.db.find(
      session,
      where: (t) =>
          t.accountId.equals(account.id!) &
          t.deletedAt.equals(null) &
          (t.date <= until),
    );
    return core
        .computeBalances(
          initialBalanceCents: account.initialBalanceCents,
          operations: [
            for (final t in existing)
              core.BalanceInput(t.date.toLocalDate(), t.amountCents),
            for (final l in a.lines)
              if (l.status == core.DuplicateStatus.isNew)
                core.BalanceInput(l.parsed.date, l.parsed.amountCents),
          ],
          today: day,
        )
        .currentCents;
  }

  static Future<ImportPreview> preview(
    Session session,
    Account account,
    ByteData file,
    CsvColumns? columns,
  ) async {
    final a = await _analyse(session, account, _bytes(file), columns);
    final s = a.statement;
    int count(core.DuplicateStatus st) =>
        a.lines.where((l) => l.status == st).length;
    return ImportPreview(
      format: s.format.name,
      encoding: s.encoding,
      readCount: a.lines.length,
      newCount: count(core.DuplicateStatus.isNew),
      duplicateCount: count(core.DuplicateStatus.duplicate),
      possibleDuplicateCount: count(core.DuplicateStatus.possibleDuplicate),
      classifiedCount: a.lines
          .where(
            (l) =>
                l.status != core.DuplicateStatus.duplicate &&
                l.classification.isClassified,
          )
          .length,
      errorCount: s.issues
          .where((i) => i.severity == core.IssueSeverity.error)
          .length,
      issues: [
        for (final i in s.issues)
          ImportIssueInfo(
            severity: i.severity.name,
            code: i.code,
            line: i.line,
          ),
      ],
      lines: [
        for (final l in a.lines)
          ImportPreviewLine(
            index: l.index,
            date: l.parsed.date.toDb(),
            amountCents: l.parsed.amountCents,
            label: l.parsed.label,
            cleanLabel: l.cleaned.display,
            status: _status(l.status),
            categoryId: l.classification.categoryId,
            categorySource: ClassificationService.toDb(
              l.classification.source,
            ),
          ),
      ],
      sameFileAlreadyImported: a.sameFileAlreadyImported,
      statedBalanceCents: s.statedBalanceCents,
      statedBalanceDate: s.statedBalanceDate?.toDb(),
      recognisedAccountId: await _recognise(session, account, s),
      otherBankAccount: _otherBankAccount(account, s),
      balanceAfterImportCents: s.statedBalanceDate == null
          ? null
          : await _balanceAfterImport(
              session,
              account,
              a,
              s.statedBalanceDate!,
            ),
    );
  }

  /// Imports new operations, plus the possible duplicates the user chose
  /// ([acceptedPossibleDuplicates]: line indexes). The account row is locked
  /// so two imports of the same file cannot run side by side.
  static Future<StatementImport> commit(
    Session session,
    Account account,
    String fileName,
    ByteData file,
    CsvColumns? columns,
    List<int> acceptedPossibleDuplicates,
    UuidValue author,
  ) async {
    final bytes = _bytes(file);
    return session.db.transaction((tx) async {
      final locked = await Account.db.findFirstRow(
        session,
        where: (a) => a.id.equals(account.id!),
        lockMode: LockMode.forUpdate,
        transaction: tx,
      );
      final a = await _analyse(
        session,
        account,
        bytes,
        columns,
        transaction: tx,
      );
      if (a.statement.hasErrors && a.lines.isEmpty) {
        throw InvalidInputException(code: 'import_nothing_readable');
      }
      final accepted = acceptedPossibleDuplicates.toSet();
      final toInsert = [
        for (final l in a.lines)
          if (l.status == core.DuplicateStatus.isNew ||
              (l.status == core.DuplicateStatus.possibleDuplicate &&
                  accepted.contains(l.index)))
            l,
      ];
      int count(core.DuplicateStatus st) =>
          a.lines.where((l) => l.status == st).length;
      final record = await StatementImport.db.insertRow(
        session,
        StatementImport(
          accountId: account.id!,
          format: a.statement.format.name,
          fileName: _safeName(fileName),
          fileHash: a.fileHash,
          encoding: a.statement.encoding,
          readCount: a.lines.length,
          addedCount: toInsert.length,
          duplicateCount: count(core.DuplicateStatus.duplicate),
          possibleDuplicateCount: count(core.DuplicateStatus.possibleDuplicate),
          errorCount: a.statement.issues
              .where((i) => i.severity == core.IssueSeverity.error)
              .length,
          classifiedCount: toInsert
              .where((l) => l.classification.isClassified)
              .length,
          authorId: author,
        ),
        transaction: tx,
      );
      // An accepted possible duplicate may share its fingerprint with an
      // existing operation: it then gets a distinct, derived one.
      final used = <String>{};
      await BankTransaction.db.insert(session, [
        for (final l in toInsert)
          BankTransaction(
            accountId: account.id!,
            date: l.parsed.date.toDb(),
            amountCents: l.parsed.amountCents,
            rawLabel: l.parsed.label,
            memo: l.parsed.memo,
            cleanLabel: l.cleaned.display,
            operationKind: l.cleaned.kind.name,
            reference: l.parsed.reference,
            bankId: l.parsed.bankId,
            fingerprint: l.status == core.DuplicateStatus.isNew
                ? l.fingerprint
                : _derived(l.fingerprint, record.id!, used),
            importId: record.id,
            categoryId: l.classification.categoryId,
            categorySource: ClassificationService.toDb(
              l.classification.source,
            ),
            categoryRuleRef: l.classification.ruleId?.toString(),
            createdBy: author,
          ),
      ], transaction: tx);
      await _learnBankAccount(session, locked ?? account, a.statement, tx);
      return record;
    });
  }

  /// Cancels an import: its operations go to the trash (fingerprints set
  /// aside, so the file can be imported again).
  static Future<StatementImport> cancel(
    Session session,
    StatementImport record,
  ) async {
    return session.db.transaction((tx) async {
      final now = DateTime.now().toUtc();
      final ops = await BankTransaction.db.find(
        session,
        where: (t) => t.importId.equals(record.id!) & t.deletedAt.equals(null),
        transaction: tx,
      );
      await BankTransaction.db.update(session, [
        for (final t in ops)
          t.copyWith(
            deletedAt: now,
            fingerprint: null,
            trashedFingerprint: t.fingerprint,
            updatedAt: now,
          ),
      ], transaction: tx);
      return StatementImport.db.updateRow(
        session,
        record.copyWith(cancelledAt: now),
        transaction: tx,
      );
    });
  }

  static String _derived(String fp, int importId, Set<String> used) {
    var n = 0;
    String candidate;
    do {
      candidate = sha256
          .convert(utf8.encode('$fp|accepted|$importId|${n++}'))
          .toString()
          .substring(0, 32);
    } while (!used.add(candidate));
    return candidate;
  }

  static String _safeName(String name) {
    final base = name.split(RegExp(r'[/\\]')).last.trim();
    return base.length > 120 ? base.substring(0, 120) : base;
  }

  static List<int> _bytes(ByteData data) =>
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
