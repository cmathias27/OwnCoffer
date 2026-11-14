import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/forecast_service.dart';
import '../finance/plan_inputs.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Savings projects and the expenses spread over the year (decision 0050).
class ProjectEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// The projects (archived ones last) and the planned expenses of the
  /// visible accounts that come less often than monthly, as monthly
  /// provisions.
  Future<ProjectOverview> overview(Session session, int groupId) async {
    final visible = await Access.visibleAccounts(session, groupId);
    final today = PlanInputs.today();
    final projects = await SavingsProject.db.find(
      session,
      where: (p) => p.groupId.equals(groupId),
      orderBy: (p) => p.createdAt,
    );
    final infos = [
      for (final p in projects)
        if (p.archivedAt == null) info(p, today),
      for (final p in projects)
        if (p.archivedAt != null) info(p, today),
    ];
    final smoothed = await _smoothed(session, {
      for (final a in visible) a.id!,
    }, today);
    return ProjectOverview(
      projects: infos,
      smoothed: smoothed,
      smoothedMonthlyCents: smoothed.fold(0, (a, s) => a + s.monthlyCents),
      smoothedSetAsideCents: smoothed.fold(0, (a, s) => a + s.setAsideCents),
      projectsMonthlyCents: infos
          .where((i) => i.project.archivedAt == null)
          .fold(0, (a, i) => a + (i.monthlyCents ?? 0)),
    );
  }

  /// Creates ([project] without id) or changes a project.
  Future<SavingsProjectInfo> save(
    Session session,
    int groupId,
    SavingsProject project,
  ) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final current = project.id == null
        ? null
        : await _find(session, project.id!, groupId);
    if (project.accountId != null) {
      final a = await Access.requireAccount(session, project.accountId!);
      if (a.groupId != groupId) {
        throw AccessDeniedException(code: 'account_access_denied');
      }
    }
    final clean = SavingsProject(
      groupId: groupId,
      name: PlanInputs.text(project.name),
      targetCents: PlanInputs.cents(project.targetCents),
      savedCents: PlanInputs.cents(project.savedCents, allowZero: true),
      targetDate: project.targetDate == null
          ? null
          : PlanInputs.day(project.targetDate!),
      accountId: project.accountId,
      archivedAt: current?.archivedAt,
    );
    final saved = current == null
        ? await SavingsProject.db.insertRow(session, clean)
        : await SavingsProject.db.updateRow(
            session,
            clean.copyWith(id: current.id, createdAt: current.createdAt),
          );
    await Audit.log(
      session,
      groupId: groupId,
      action: current == null ? 'create' : 'update',
      entity: 'savings_project',
      rowId: saved.id,
      before: current,
      after: saved,
    );
    return info(saved, PlanInputs.today());
  }

  /// Puts aside [amountCents] more (negative to take some back).
  Future<SavingsProjectInfo> addSaved(
    Session session,
    int projectId,
    int amountCents,
  ) async {
    final current = await _find(session, projectId, null);
    await Access.requireMember(
      session,
      current.groupId,
      min: MemberRole.user,
    );
    final total = current.savedCents + amountCents;
    if (amountCents == 0 || total < 0 || total > PlanInputs.maxCents) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    final saved = await SavingsProject.db.updateRow(
      session,
      current.copyWith(savedCents: total),
    );
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'update',
      entity: 'savings_project',
      rowId: projectId,
      before: current,
      after: saved,
    );
    return info(saved, PlanInputs.today());
  }

  /// Archives (done or given up) or brings back a project.
  Future<SavingsProjectInfo> setArchived(
    Session session,
    int projectId,
    bool archived,
  ) async {
    final current = await _find(session, projectId, null);
    await Access.requireMember(
      session,
      current.groupId,
      min: MemberRole.user,
    );
    final saved = await SavingsProject.db.updateRow(
      session,
      current.copyWith(archivedAt: archived ? DateTime.now().toUtc() : null),
    );
    await Audit.log(
      session,
      groupId: current.groupId,
      action: archived ? 'archive' : 'restore',
      entity: 'savings_project',
      rowId: projectId,
      before: current,
      after: saved,
    );
    return info(saved, PlanInputs.today());
  }

  Future<void> remove(Session session, int projectId) async {
    final current = await _find(session, projectId, null);
    await Access.requireMember(
      session,
      current.groupId,
      min: MemberRole.user,
    );
    await SavingsProject.db.deleteRow(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'delete',
      entity: 'savings_project',
      rowId: projectId,
      before: current,
    );
  }

  static SavingsProjectInfo info(SavingsProject p, core.LocalDate today) {
    final plan = core.projectPlan(
      targetCents: p.targetCents,
      savedCents: p.savedCents,
      today: today,
      targetDate: p.targetDate?.toLocalDate(),
    );
    return SavingsProjectInfo(
      project: p,
      remainingCents: plan.remainingCents,
      monthsLeft: plan.monthsLeft,
      monthlyCents: plan.monthlyCents,
      progressPerMille: plan.progressPerMille,
      reached: plan.reached,
      overdue: plan.overdue,
    );
  }

  /// Planned debits of [accountIds] less often than monthly, the next one
  /// first.
  static Future<List<SmoothedExpenseInfo>> _smoothed(
    Session session,
    Set<int> accountIds,
    core.LocalDate today,
  ) async {
    if (accountIds.isEmpty) return [];
    final rows = await ScheduledTransaction.db.find(
      session,
      where: (s) =>
          s.accountId.inSet(accountIds) &
          s.deletedAt.equals(null) &
          (s.amountCents < 0),
    );
    final result = <SmoothedExpenseInfo>[];
    for (final s in rows) {
      final next = ForecastService.recurrenceOf(s).nextAfter(today.addDays(-1));
      if (next == null) continue;
      final smooth = core.smoothExpense(
        amountCents: -s.amountCents,
        frequency: core.Frequency.values.byName(s.frequency.name),
        interval: s.interval,
        nextDue: next,
        today: today,
      );
      if (smooth == null) continue;
      result.add(
        SmoothedExpenseInfo(
          scheduledId: s.id!,
          accountId: s.accountId,
          label: s.label,
          amountCents: -s.amountCents,
          nextDue: next.toDb(),
          periodMonths: smooth.periodMonths,
          monthlyCents: smooth.monthlyCents,
          setAsideCents: smooth.setAsideCents,
          monthsUntil: smooth.monthsUntil,
        ),
      );
    }
    result.sort((a, b) => a.nextDue.compareTo(b.nextDue));
    return result;
  }

  /// A project of [groupId] (any group when null; the caller checks the
  /// membership); missing and foreign projects are refused alike.
  static Future<SavingsProject> _find(
    Session session,
    int id,
    int? groupId,
  ) async {
    final p = await SavingsProject.db.findById(session, id);
    if (p == null || (groupId != null && p.groupId != groupId)) {
      throw AccessDeniedException(code: 'project_access_denied');
    }
    return p;
  }
}
