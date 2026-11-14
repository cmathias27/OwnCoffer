import 'package:serverpod/serverpod.dart';

import '../finance/plan_inputs.dart';
import '../finance/wealth_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Net worth and assets, regulated savings, financial health and the
/// yearly review (decision 0050).
class WealthEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<WealthOverview> overview(Session session, int groupId) =>
      WealthService.overview(session, groupId);

  Future<List<RegulatedSavingsInfo>> savings(Session session, int groupId) =>
      WealthService.savings(session, groupId);

  Future<HealthReport> health(Session session, int groupId) =>
      WealthService.health(session, groupId);

  Future<YearReview> year(Session session, int groupId, int year) {
    if (year < 1970 || year > 2200) {
      throw InvalidInputException(code: 'invalid_date', field: 'year');
    }
    return WealthService.year(session, groupId, year);
  }

  /// Creates ([asset] without id) or changes an asset.
  Future<Asset> saveAsset(Session session, int groupId, Asset asset) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final current = asset.id == null
        ? null
        : await _find(session, asset.id!, groupId);
    final clean = Asset(
      groupId: groupId,
      name: PlanInputs.text(asset.name),
      kind: asset.kind,
      valueCents: PlanInputs.cents(asset.valueCents, allowZero: true),
      valuedAt: PlanInputs.day(asset.valuedAt),
    );
    final saved = current == null
        ? await Asset.db.insertRow(session, clean)
        : await Asset.db.updateRow(
            session,
            clean.copyWith(id: current.id, createdAt: current.createdAt),
          );
    await Audit.log(
      session,
      groupId: groupId,
      action: current == null ? 'create' : 'update',
      entity: 'asset',
      rowId: saved.id,
      before: current,
      after: saved,
    );
    return saved;
  }

  Future<void> removeAsset(Session session, int assetId) async {
    final current = await _find(session, assetId, null);
    await Access.requireMember(
      session,
      current.groupId,
      min: MemberRole.user,
    );
    await Asset.db.deleteRow(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'delete',
      entity: 'asset',
      rowId: assetId,
      before: current,
    );
  }

  static Future<Asset> _find(Session session, int id, int? groupId) async {
    final a = await Asset.db.findById(session, id);
    if (a == null || (groupId != null && a.groupId != groupId)) {
      throw AccessDeniedException(code: 'asset_access_denied');
    }
    return a;
  }
}
