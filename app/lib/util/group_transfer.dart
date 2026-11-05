import 'dart:convert';

import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' show ExportSummary;

/// Moves a group from one OwnCoffer server to another (decision 0022): the
/// standalone app's own server to a Docker server, or back. The source is
/// read through its export, the target recreates it in a new group, then
/// receives the files one by one. Nothing is deleted at the source.
/// At the end the copy is exported and compared with the source's export
/// (counts, amounts, each account's operations): a difference stops with
/// [TransferMismatch] rather than letting the user switch to an incomplete
/// copy.
abstract final class GroupTransfer {
  /// Characters of JSON per request (the target takes up to 2 million).
  static const partSize = 1000000;

  /// [progress]: from 0 to 1.
  static Future<ImportResult> send({
    required Client from,
    required Client to,
    required int groupId,
    void Function(double progress)? progress,
  }) async {
    progress?.call(0);
    final json = await from.export.groupJson(groupId);
    final result = await importJson(
      to,
      json,
      progress: (p) => progress?.call(p * 0.5),
    );
    final docs = result.documents;
    for (var i = 0; i < docs.length; i++) {
      final d = docs[i];
      final content = d.kind == 'invoice'
          ? await from.invoice.download(d.oldId)
          : await from.loan.downloadDocument(d.oldId);
      await to.transfer.document(result.groupId, d.kind, d.newId, content);
      progress?.call(0.5 + 0.5 * (i + 1) / docs.length);
    }
    final copy = await to.export.groupJson(result.groupId);
    final differences = ExportSummary.of(
      jsonDecode(json) as Map<String, dynamic>,
    ).differences(ExportSummary.of(jsonDecode(copy) as Map<String, dynamic>));
    if (differences.isNotEmpty) {
      throw TransferMismatch(result.groupName, differences);
    }
    progress?.call(1);
    return result;
  }

  /// An export file (without its documents' files) into a new group.
  static Future<ImportResult> importJson(
    Client to,
    String json, {
    void Function(double progress)? progress,
  }) async {
    final token = await to.transfer.begin();
    for (var i = 0; i < json.length; i += partSize) {
      await to.transfer.part(
        token,
        json.substring(i, (i + partSize).clamp(0, json.length)),
      );
      progress?.call((i + partSize).clamp(0, json.length) / json.length);
    }
    return to.transfer.finish(token, null);
  }
}

/// The copy on the target differs from the source: what differs, one line
/// per figure (`transactions.count: 120 ≠ 119`). The copy stays on the
/// target, as a group of the same name, to look at or delete.
class TransferMismatch implements Exception {
  final String groupName;
  final List<String> differences;
  const TransferMismatch(this.groupName, this.differences);

  @override
  String toString() => 'TransferMismatch($groupName: $differences)';
}
