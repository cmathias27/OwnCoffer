import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/entry_dialog.dart';

/// Expenses shared between members and the common pot split by income
/// (decision 0050). Who owes whom is computed by the server's engine.
class TogetherScreen extends StatefulWidget {
  final GroupMembership membership;
  const TogetherScreen({super.key, required this.membership});

  @override
  State<TogetherScreen> createState() => TogetherScreenState();
}

class TogetherScreenState extends State<TogetherScreen> {
  SharedOverview? _shared;
  PotOverview? _pot;
  List<MemberInfo> _members = const [];
  String? _error;

  int get _groupId => widget.membership.group.id!;
  bool get _canWrite => widget.membership.role != MemberRole.reader;
  String get _me => '${client.auth.authInfo?.authUserId}';

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(TogetherScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membership.group.id != widget.membership.group.id) reload();
  }

  Future<void> reload() async {
    try {
      final results = await Future.wait<Object>([
        client.shared.overview(_groupId),
        client.shared.pot(_groupId),
        client.group.members(_groupId),
      ]);
      if (!mounted) return;
      setState(() {
        _shared = results[0] as SharedOverview;
        _pot = results[1] as PotOverview;
        _members = results[2] as List<MemberInfo>;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  String _name(UuidValue id) {
    final l = AppLocalizations.of(context);
    if (id.uuid == _me) return l.togetherMe;
    for (final m in _members) {
      if (m.userId.uuid == id.uuid) return m.email ?? l.togetherMember;
    }
    return l.togetherFormerMember;
  }

  Future<void> _addExpense({bool repayment = false}) async {
    final l = AppLocalizations.of(context);
    final options = [
      for (final m in _members) (m.userId.uuid, _name(m.userId)),
    ];
    final mine = _members.any((m) => m.userId.uuid == _me) ? _me : null;
    final saved = await showEntryDialog(
      context,
      title: repayment ? l.sharedRepay : l.sharedAdd,
      intro: repayment ? l.sharedRepayIntro : null,
      fields: [
        if (!repayment) TextEntry('label', l.sharedLabel),
        AmountEntry('amount', l.sharedAmount),
        DateEntry('date', l.sharedDate, initial: todayUtcMidnight()),
        ChoiceEntry<String>(
          'paidBy',
          repayment ? l.sharedRepayFrom : l.sharedPaidBy,
          initial: mine,
          options: options,
        ),
        if (repayment)
          ChoiceEntry<String>('to', l.sharedRepayTo, options: options)
        else
          MultiEntry<String>(
            'for',
            l.sharedFor,
            initial: {for (final (id, _) in options) id},
            options: options,
          ),
      ],
      onSave: (v) => client.shared.add(
        _groupId,
        SharedExpense(
          groupId: _groupId,
          label: repayment ? l.sharedRepayLabel : v['label']! as String,
          date: v['date']! as DateTime,
          amountCents: v['amount']! as int,
          paidBy: UuidValue.fromString(v['paidBy']! as String),
          participants: repayment
              ? [UuidValue.fromString(v['to']! as String)]
              : [
                  for (final id in (v['for']! as Set).cast<String>())
                    UuidValue.fromString(id),
                ],
          repayment: repayment,
          createdBy: UuidValue.fromString(_me),
        ),
      ),
    );
    if (saved != null) await reload();
  }

  Future<void> _remove(SharedExpense e) async {
    if (!await confirmRemove(context, e.label) || !mounted) return;
    if (await runShowingError(context, () => client.shared.remove(e.id!))) {
      await reload();
    }
  }

  Future<void> _setPot() async {
    final l = AppLocalizations.of(context);
    final saved = await showEntryDialog(
      context,
      title: l.potSet,
      intro: l.potSetIntro,
      fields: [
        AmountEntry('total', l.potTotal, initial: _pot?.totalCents),
      ],
      onSave: (v) => client.shared.setPot(_groupId, v['total']! as int),
    );
    if (saved != null) await reload();
  }

  Future<void> _setIncome(PotShareInfo s) async {
    final l = AppLocalizations.of(context);
    final saved = await showEntryDialog(
      context,
      title: l.potIncomeOf(_name(s.userId)),
      intro: l.potIncomeIntro,
      fields: [
        AmountEntry('income', l.potIncome, initial: s.incomeCents),
      ],
      onSave: (v) =>
          client.shared.setIncome(_groupId, s.userId, v['income']! as int),
    );
    if (saved != null) await reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final shared = _shared;
    final pot = _pot;
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.togetherTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(l.togetherIntro),
          const SizedBox(height: 12),
          if (_error != null)
            Text(_error!, style: TextStyle(color: theme.colorScheme.error))
          else if (shared == null || pot == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            Text(l.sharedTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_canWrite)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l.sharedAdd),
                    onPressed: _members.length < 2 ? null : _addExpense,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(l.sharedRepay),
                    onPressed: _members.length < 2
                        ? null
                        : () => _addExpense(repayment: true),
                  ),
                ],
              ),
            if (_members.length < 2)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(l.togetherAlone, style: theme.textTheme.bodySmall),
              ),
            const SizedBox(height: 8),
            if (shared.settlements.isEmpty)
              Text(shared.expenses.isEmpty ? l.sharedEmpty : l.sharedSettled)
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.sharedToSettle, style: theme.textTheme.titleSmall),
                      for (final s in shared.settlements)
                        Text(
                          l.sharedOwes(
                            _name(s.fromUserId),
                            _name(s.toUserId),
                            context.money(s.amountCents),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            if (shared.expenses.isNotEmpty)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(l.sharedHistory(shared.expenses.length)),
                children: [
                  for (final e in shared.expenses)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        e.repayment ? Icons.swap_horiz : Icons.groups_outlined,
                      ),
                      title: Text(e.label),
                      subtitle: Text(
                        e.repayment
                            ? l.sharedRepayLine(
                                context.day(e.date),
                                _name(e.paidBy),
                                _name(e.participants.first),
                              )
                            : l.sharedLine(
                                context.day(e.date),
                                _name(e.paidBy),
                                e.participants.map(_name).join(', '),
                              ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(context.money(e.amountCents)),
                          if (_canWrite)
                            IconButton(
                              tooltip: l.entryRemove,
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _remove(e),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(l.potTitle, style: theme.textTheme.titleMedium),
                ),
                if (_canWrite)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l.potSet),
                    onPressed: _setPot,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(l.potIntro, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            if (pot.totalCents == 0)
              Text(l.potNone)
            else ...[
              Text(
                l.potTotalLine(context.money(pot.totalCents)),
                style: theme.textTheme.titleSmall,
              ),
              for (final s in pot.shares)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_name(s.userId)),
                  subtitle: Text(
                    s.incomeCents == 0
                        ? l.potIncomeUnknown
                        : l.potIncomeLine(context.money(s.incomeCents)),
                  ),
                  trailing: Text(
                    l.perMonth(context.money(s.shareCents)),
                    style: theme.textTheme.titleSmall,
                  ),
                  onTap: _canWrite ? () => _setIncome(s) : null,
                ),
            ],
          ],
        ],
      ),
    );
  }
}
