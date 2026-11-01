import 'package:serverpod/serverpod.dart';

import '../export/export_service.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';
import 'admin_endpoint.dart';

/// Export of the member's data in a group: complete JSON, or the
/// operations as CSV. Only what the member may see; every export is logged.
class ExportEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// Everything visible in [groupId], as one JSON document (amounts in
  /// cents, see docs/UTILISATION.md for the layout).
  Future<String> groupJson(Session session, int groupId) async {
    final member = await Access.requireMember(session, groupId);
    final json = await ExportService.json(
      session,
      member,
      serverVersion: AdminEndpoint.serverVersion(),
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'export_json',
      entity: 'group',
      rowId: groupId,
    );
    return json;
  }

  /// The operations of the visible accounts, for a spreadsheet.
  /// [language]: `fr` (default: `;`, decimal comma) or `en`.
  Future<String> transactionsCsv(
    Session session,
    int groupId,
    String? language,
  ) async {
    final member = await Access.requireMember(session, groupId);
    final csv = await ExportService.csv(
      session,
      member,
      language: language == 'en' ? 'en' : 'fr',
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'export_csv',
      entity: 'group',
      rowId: groupId,
    );
    return csv;
  }
}
