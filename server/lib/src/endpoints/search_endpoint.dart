import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/scopes.dart';
import 'invoice_endpoint.dart';
import 'transaction_endpoint.dart';

/// The search at the top of every screen (decision 0041): operations of
/// all the visible accounts, loans and invoices of the household. Read
/// only; the text searched is neither kept nor logged.
class SearchEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// Results of each kind.
  static const perKind = 8;

  Future<GlobalSearchResult> global(
    Session session,
    int groupId,
    String query,
  ) async {
    final member = await Access.requireMember(session, groupId);
    final text = query.trim();
    if (text.length < 2) {
      return GlobalSearchResult(
        operations: const [],
        loans: const [],
        invoices: const [],
      );
    }
    final visible = await Access.visibleAccountsOf(session, member);
    final Set<int> ids = {for (final a in visible) a.id!};
    final pattern = TransactionEndpoint.likePattern(text)!;
    // "42,50" or "-42.50" also finds the operations of that amount.
    int? cents;
    try {
      cents = core.parseAmountCents(text).abs();
    } on Object {
      cents = null;
    }
    final operations = ids.isEmpty
        ? <BankTransaction>[]
        : await BankTransaction.db.find(
            session,
            where: (t) {
              Expression match =
                  t.rawLabel.ilike(pattern) |
                  t.cleanLabel.ilike(pattern) |
                  t.memo.ilike(pattern) |
                  t.note.ilike(pattern);
              if (cents != null && cents > 0) {
                match =
                    match |
                    t.amountCents.equals(cents) |
                    t.amountCents.equals(-cents);
              }
              return t.accountId.inSet(ids) & t.deletedAt.equals(null) & match;
            },
            orderByList: (t) => [t.date.desc(), t.id.desc()],
            limit: perKind,
          );
    final lower = text.toLowerCase();
    final loans = [
      for (final l in await Loan.db.find(
        session,
        where: (l) => l.groupId.equals(groupId) & l.deletedAt.equals(null),
        orderBy: (l) => l.firstDueDate,
      ))
        if ((l.accountId == null || ids.contains(l.accountId)) &&
            '${l.lender} ${l.label ?? ''}'.toLowerCase().contains(lower))
          l,
    ].take(perKind).toList();
    final invoices = (await InvoiceEndpoint().list(
      session,
      groupId,
      search: text,
    )).take(perKind).toList();
    return GlobalSearchResult(
      operations: operations,
      loans: loans,
      invoices: invoices,
    );
  }
}
