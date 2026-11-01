import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/soft.dart';
import 'loans_screen.dart' show parseRateMilli, rateText;

/// Renegotiate or change the rate of a loan: what the bank offers, its
/// fees, and the loan before and after, computed by the loan engine. The
/// change is recorded only when chosen.
class LoanChangeScreen extends StatefulWidget {
  final LoanInfo info;
  const LoanChangeScreen({super.key, required this.info});

  @override
  State<LoanChangeScreen> createState() => _LoanChangeScreenState();
}

class _LoanChangeScreenState extends State<LoanChangeScreen> {
  final _rate = TextEditingController();
  final _payment = TextEditingController();
  final _months = TextEditingController();
  final _fees = TextEditingController();
  late var _date = () {
    final n = DateTime.now().toUtc();
    return DateTime.utc(n.year, n.month + 1, 1);
  }();
  LoanChangeSimulation? _sim;
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    for (final c in [_rate, _payment, _months, _fees]) {
      c.dispose();
    }
    super.dispose();
  }

  LoanEvent? _event() {
    String? t(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final rate = t(_rate) == null ? null : parseRateMilli(_rate.text);
    final payment = t(_payment) == null ? null : parseUserAmount(_payment.text);
    final months = t(_months) == null ? null : int.tryParse(_months.text);
    if ((t(_rate) != null && rate == null) ||
        (t(_payment) != null && (payment ?? 0) <= 0) ||
        (t(_months) != null && (months ?? 0) < 1) ||
        (rate == null && payment == null && months == null)) {
      return null;
    }
    return LoanEvent(
      date: _date,
      annualRateMilli: rate,
      // The instalment entered includes no insurance (as in the loan form).
      paymentCents: payment,
      remainingMonths: payment == null ? months : null,
    );
  }

  int get _feesCents =>
      _fees.text.trim().isEmpty ? 0 : (parseUserAmount(_fees.text) ?? -1);

  Future<void> _simulate() async {
    final l = AppLocalizations.of(context);
    final e = _event();
    if (e == null || _feesCents < 0) {
      setState(() => (_error = l.loanEventInvalid, _sim = null));
      return;
    }
    setState(() => (_busy = true, _error = null));
    try {
      final sim = await client.loan.simulateChange(
        widget.info.loan.id!,
        e,
        feesCents: _feesCents,
      );
      if (mounted) setState(() => _sim = sim);
    } on Object catch (err) {
      if (mounted) setState(() => (_error = errorText(l, err), _sim = null));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _record() async {
    final l = AppLocalizations.of(context);
    final e = _event();
    if (e == null) return;
    setState(() => _busy = true);
    try {
      final saved = await client.loan.addEvent(
        widget.info.loan.id!,
        e.copyWith(note: l.loanChangeNote),
      );
      if (mounted) Navigator.of(context).pop(saved);
    } on Object catch (err) {
      if (mounted) setState(() => (_error = errorText(l, err), _busy = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final loan = widget.info.loan;
    final sim = _sim;
    Widget field(
      TextEditingController c,
      String label,
      String suffix, {
      String? help,
    }) => Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => setState(() => _sim = null),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          helperText: help,
          helperMaxLines: 2,
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.loanChangeTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.loanChangeIntro(
                      loan.lender,
                      rateText(context, loan.annualRateMilli),
                      context.money(widget.info.paymentCents),
                      context.money(widget.info.remainingCents),
                    ),
                  ),
                  SoftSection(
                    icon: Icons.handshake_outlined,
                    title: l.loanChangeOffer,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.event),
                        title: Text(l.loanEventDate),
                        subtitle: Text(context.day(_date)),
                        onTap: () async {
                          final p = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                              _date.year,
                              _date.month,
                              _date.day,
                            ),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(2100),
                          );
                          if (p != null) {
                            setState(() {
                              _date = DateTime.utc(p.year, p.month, p.day);
                              _sim = null;
                            });
                          }
                        },
                      ),
                      field(_rate, l.loanEventNewRate, '%'),
                      field(_payment, l.loanEventNewPayment, '€'),
                      field(
                        _months,
                        l.loanEventNewMonths,
                        l.loanChangeMonthsSuffix,
                        help: l.loanEventNewMonthsHelp,
                      ),
                      field(
                        _fees,
                        l.loanChangeFees,
                        '€',
                        help: l.loanChangeFeesHelp,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.tonalIcon(
                          icon: const Icon(Icons.calculate_outlined),
                          label: Text(l.loanChangeSimulate),
                          onPressed: _busy ? null : _simulate,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  if (sim != null) _results(context, l, sim),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _results(
    BuildContext context,
    AppLocalizations l,
    LoanChangeSimulation s,
  ) {
    final theme = Theme.of(context);
    final good = s.savingCents > 0;
    TableRow row(String label, String before, String after) => TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(before, textAlign: TextAlign.end),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            after,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
    return SoftSection(
      icon: good ? Icons.trending_down : Icons.trending_up,
      title: good
          ? l.loanChangeSaves(context.money(s.savingCents))
          : l.loanChangeCosts(context.money(-s.savingCents)),
      children: [
        Table(
          columnWidths: const {0: FlexColumnWidth(2)},
          children: [
            TableRow(
              children: [
                const SizedBox(),
                Text(
                  l.loanChangeNow,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelMedium,
                ),
                Text(
                  l.loanChangeAfter,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            row(
              l.loanPaymentComputed,
              context.money(s.paymentBeforeCents),
              context.money(s.paymentAfterCents),
            ),
            row(
              l.loanInterestLeft,
              context.money(s.interestBeforeCents),
              context.money(s.interestAfterCents),
            ),
            row(
              l.loanChangeInstalmentsLeft,
              '${s.instalmentsBefore}',
              '${s.instalmentsAfter}',
            ),
            row(
              l.loanChangeEnd,
              context.day(s.endBefore),
              context.day(s.endAfter),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          [
            if (s.feesCents > 0)
              l.loanChangeFeesCounted(context.money(s.feesCents)),
            s.breakEvenMonth == null
                ? l.loanChangeNeverPaysOff
                : l.loanChangePaysOff(s.breakEvenMonth!),
          ].join(' '),
        ),
        const SizedBox(height: 4),
        Text(l.loanChangeHow, style: theme.textTheme.bodySmall),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            icon: const Icon(Icons.check),
            label: Text(l.loanChangeRecord),
            onPressed: _busy ? null : _record,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
