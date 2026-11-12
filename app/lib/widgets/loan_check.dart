import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../util/format.dart';

/// The loan's instalments compared with the real debits (decision 0040):
/// all right, or each instalment to look at, with the data used.
class LoanCheckView extends StatelessWidget {
  final LoanCheckReport report;
  final String currency;

  const LoanCheckView({super.key, required this.report, this.currency = 'EUR'});

  /// Nothing to show: no account, no history, or no instalment due in it.
  static bool shows(LoanCheckReport? r) =>
      r != null && r.available && (r.paidCount > 0 || r.lines.isNotEmpty);

  String _line(BuildContext context, AppLocalizations l, LoanCheckLine x) {
    String money(int cents) => context.money(cents, currency: currency);
    final due = x.dueDate == null ? '' : context.day(x.dueDate!);
    final n = x.number ?? 0;
    return switch (x.status) {
      LoanCheckStatus.missing => l.loanCheckMissing(n, due),
      LoanCheckStatus.duplicate => l.loanCheckDuplicate(
        n,
        due,
        x.debits.length,
      ),
      LoanCheckStatus.differentAmount => l.loanCheckDifferent(
        n,
        due,
        money(x.debits.isEmpty ? 0 : -x.debits.first.amountCents),
        money(x.expectedCents ?? 0),
      ),
      LoanCheckStatus.unexpected => l.loanCheckUnexpected(
        x.debits.isEmpty ? '' : context.day(x.debits.first.date),
        money(x.debits.isEmpty ? 0 : -x.debits.first.amountCents),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ok = report.lines.isEmpty;
    final color = ok ? theme.colorScheme.primary : theme.colorScheme.error;
    final small = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              ok ? Icons.verified_outlined : Icons.report_problem_outlined,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                ok
                    ? l.loanCheckAllPaid(report.paidCount)
                    : l.loanCheckToLook(report.lines.length, report.paidCount),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        for (final x in report.lines)
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 4),
            child: Text(_line(context, l, x)),
          ),
        if (report.historyFrom != null && report.historyTo != null)
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 4),
            child: Text(
              l.loanCheckBasis(
                context.day(report.historyFrom!),
                context.day(report.historyTo!),
              ),
              style: small,
            ),
          ),
      ],
    );
  }
}
