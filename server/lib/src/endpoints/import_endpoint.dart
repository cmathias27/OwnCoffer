import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../finance/alert_service.dart';
import '../finance/import_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Bank statement import: preview, import, history, cancel.
class ImportEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  static const maxFileBytes = 4 * 1024 * 1024;

  void _checkSize(ByteData file) {
    if (file.lengthInBytes == 0) {
      throw InvalidInputException(code: 'import_empty_file', field: 'file');
    }
    if (file.lengthInBytes > maxFileBytes) {
      throw InvalidInputException(code: 'import_file_too_large', field: 'file');
    }
  }

  /// What the import would do. Writes nothing.
  Future<ImportPreview> preview(
    Session session,
    int accountId,
    ByteData file, {
    CsvColumns? columns,
  }) async {
    _checkSize(file);
    final account = await Access.requireAccount(
      session,
      accountId,
      write: true,
    );
    return ImportService.preview(session, account, file, columns);
  }

  Future<StatementImport> commit(
    Session session,
    int accountId,
    String fileName,
    ByteData file, {
    CsvColumns? columns,
    List<int>? acceptedPossibleDuplicates,
  }) async {
    _checkSize(file);
    final account = await Access.requireAccount(
      session,
      accountId,
      write: true,
    );
    final record = await ImportService.commit(
      session,
      account,
      fileName,
      file,
      columns,
      acceptedPossibleDuplicates ?? const [],
      Access.userId(session),
    );
    // Fresh operations: check the forecast now rather than at the next hour.
    try {
      await AlertService.checkAccount(
        session,
        account,
        core.LocalDate.fromDateTime(DateTime.now().toUtc()),
      );
    } on Object catch (e) {
      session.log(
        '[alert] after import: ${e.runtimeType}',
        level: LogLevel.error,
      );
    }
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'import',
      entity: 'import',
      rowId: record.id,
      after: record,
    );
    return record;
  }

  Future<List<StatementImport>> history(Session session, int accountId) async {
    await Access.requireAccount(session, accountId);
    return StatementImport.db.find(
      session,
      where: (i) => i.accountId.equals(accountId),
      orderByList: (i) => [i.createdAt.desc()],
    );
  }

  Future<StatementImport> cancel(Session session, int importId) async {
    final record = await StatementImport.db.findById(session, importId);
    if (record == null) {
      throw AccessDeniedException(code: 'import_access_denied');
    }
    final Account account;
    try {
      account = await Access.requireAccount(
        session,
        record.accountId,
        write: true,
      );
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'import_access_denied');
    }
    if (record.cancelledAt != null) return record;
    final cancelled = await ImportService.cancel(session, record);
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'cancel_import',
      entity: 'import',
      rowId: importId,
      before: record,
      after: cancelled,
    );
    return cancelled;
  }
}
