import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'access.dart';

/// Writes the audit log of sensitive changes. Snapshots are JSON of the
/// model; never pass objects holding secrets.
abstract final class Audit {
  static Future<void> log(
    Session session, {
    required int? groupId,
    required String action,
    required String entity,
    Object? rowId,
    SerializableModel? before,
    SerializableModel? after,
    Transaction? transaction,
  }) async {
    await AuditEntry.db.insertRow(
      session,
      AuditEntry(
        groupId: groupId,
        authUserId: session.authenticated == null
            ? null
            : Access.userId(session),
        action: action,
        entity: entity,
        rowId: rowId?.toString(),
        before: before == null ? null : jsonEncode(before.toJson()),
        after: after == null ? null : jsonEncode(after.toJson()),
      ),
      transaction: transaction,
    );
  }
}
