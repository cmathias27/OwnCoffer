import 'package:serverpod/serverpod.dart';

import '../finance/proposal_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/scopes.dart';

/// "Mon conseiller" without AI (décision 0007): proposals computed by the
/// engine for the user, from the accounts they may see, applied only when
/// they accept them (décision 0009).
class AdvisorEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// The user's open proposals, refreshed first, then those decided in the
  /// last 30 days; newest first.
  Future<List<ActionProposal>> proposals(Session session, int groupId) async {
    await ProposalService.refreshAdvice(session, groupId);
    final user = Access.userId(session);
    final since = DateTime.now().toUtc().subtract(const Duration(days: 30));
    final rows = await ActionProposal.db.find(
      session,
      where: (p) =>
          p.authUserId.equals(user) &
          p.groupId.equals(groupId) &
          (p.status.equals('pending') | (p.decidedAt > since)),
      orderByList: (p) => [p.createdAt.desc(), p.id.desc()],
      limit: 100,
    );
    return rows;
  }

  Future<ActionProposal> accept(Session session, int proposalId) =>
      ProposalService.accept(session, proposalId);

  Future<ActionProposal> refuse(Session session, int proposalId) =>
      ProposalService.refuse(session, proposalId);

  Future<ActionProposal> undo(Session session, int proposalId) =>
      ProposalService.undo(session, proposalId);
}
