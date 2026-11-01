import 'package:owncoffer_client/owncoffer_client.dart';

/// Moves a group from one OwnCoffer server to another (decision 0022): the
/// standalone app's own server to a Docker server, or back. The source is
/// read through its export, the target recreates it in a new group, then
/// receives the files one by one. Nothing is deleted at the source.
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
