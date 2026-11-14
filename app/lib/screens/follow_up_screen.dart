import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/entry_dialog.dart';

/// What to keep an eye on (decision 0050): money expected back, contracts
/// to cancel in time, events with their operations, personal reminders.
class FollowUpScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;
  const FollowUpScreen({
    super.key,
    required this.membership,
    required this.accounts,
  });

  @override
  State<FollowUpScreen> createState() => FollowUpScreenState();
}

class FollowUpScreenState extends State<FollowUpScreen> {
  List<ExpectedRefund>? _refunds;
  List<ContractInfo> _contracts = const [];
  List<LifeEventInfo> _events = const [];
  List<Reminder> _reminders = const [];
  String? _error;

  int get _groupId => widget.membership.group.id!;
  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(FollowUpScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membership.group.id != widget.membership.group.id) reload();
  }

  Future<void> reload() async {
    try {
      final results = await Future.wait<Object>([
        client.refund.list(_groupId),
        client.scheduled.contracts(_groupId),
        client.event.list(_groupId),
        client.reminder.list(_groupId),
      ]);
      if (!mounted) return;
      setState(() {
        _refunds = results[0] as List<ExpectedRefund>;
        _contracts = results[1] as List<ContractInfo>;
        _events = results[2] as List<LifeEventInfo>;
        _reminders = results[3] as List<Reminder>;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  List<(int, String)> get _accountOptions => [
    for (final a in widget.accounts) (a.id!, a.name),
  ];

  // Refunds.

  Future<void> _editRefund([ExpectedRefund? r]) async {
    final l = AppLocalizations.of(context);
    final saved = await showEntryDialog(
      context,
      title: r == null ? l.refundAdd : l.refundEdit,
      intro: l.refundIntro,
      fields: [
        TextEntry('label', l.refundLabel, initial: r?.label),
        AmountEntry('amount', l.refundAmount, initial: r?.amountCents),
        DateEntry(
          'since',
          l.refundSince,
          initial: r?.since ?? todayUtcMidnight(),
        ),
        DateEntry('dueBy', l.refundDueBy, initial: r?.dueBy, optional: true),
        ChoiceEntry<int>(
          'account',
          l.refundAccount,
          optional: true,
          initial: r?.accountId,
          options: _accountOptions,
        ),
      ],
      onSave: (v) => client.refund.save(
        _groupId,
        ExpectedRefund(
          id: r?.id,
          groupId: _groupId,
          createdBy:
              r?.createdBy ??
              UuidValue.fromString('${client.auth.authInfo?.authUserId}'),
          label: v['label']! as String,
          amountCents: v['amount']! as int,
          since: v['since']! as DateTime,
          dueBy: v['dueBy'] as DateTime?,
          accountId: v['account'] as int?,
        ),
      ),
    );
    if (saved != null) await reload();
  }

  Future<void> _refundAction(ExpectedRefund r, String action) async {
    switch (action) {
      case 'edit':
        await _editRefund(r);
        return;
      case 'received' || 'open':
        if (await runShowingError(
          context,
          () => client.refund.setReceived(r.id!, action == 'received'),
        )) {
          await reload();
        }
      case 'remove':
        if (!await confirmRemove(context, r.label) || !mounted) return;
        if (await runShowingError(context, () => client.refund.remove(r.id!))) {
          await reload();
        }
    }
  }

  // Contracts.

  Future<void> _editContract({ContractInfo? current}) async {
    final l = AppLocalizations.of(context);
    final planned = <ScheduledTransaction>[];
    if (current == null) {
      final ok = await runShowingError(context, () async {
        for (final a in widget.accounts) {
          planned.addAll(await client.scheduled.list(a.id!));
        }
      });
      if (!ok || !mounted) return;
      if (planned.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.contractNoPlanned)));
        return;
      }
    }
    final saved = await showEntryDialog(
      context,
      title: current == null ? l.contractAdd : l.contractEdit(current.label),
      intro: l.contractIntro,
      fields: [
        if (current == null)
          ChoiceEntry<int>(
            'scheduled',
            l.contractPlanned,
            options: [
              for (final s in planned)
                (s.id!, '${s.label} · ${context.money(s.amountCents)}'),
            ],
          ),
        DateEntry('renewal', l.contractRenewal, initial: current?.renewal),
        IntEntry(
          'notice',
          l.contractNotice,
          initial: current?.noticeDays ?? 30,
          max: 365,
        ),
      ],
      onSave: (v) => client.scheduled.setContract(
        current?.scheduledId ?? v['scheduled']! as int,
        renewalDate: v['renewal']! as DateTime,
        noticeDays: v['notice']! as int,
      ),
    );
    if (saved != null) await reload();
  }

  Future<void> _contractAction(ContractInfo c, String action) async {
    if (action == 'edit') {
      await _editContract(current: c);
      return;
    }
    if (!await confirmRemove(context, c.label) || !mounted) return;
    if (await runShowingError(
      context,
      () => client.scheduled.setContract(c.scheduledId),
    )) {
      await reload();
    }
  }

  // Events.

  Future<void> _editEvent([LifeEvent? e]) async {
    final l = AppLocalizations.of(context);
    final saved = await showEntryDialog(
      context,
      title: e == null ? l.eventAdd : l.eventEdit,
      intro: l.eventIntro,
      fields: [
        TextEntry('name', l.eventName, initial: e?.name),
        DateEntry(
          'start',
          l.eventStart,
          initial: e?.startDate ?? todayUtcMidnight(),
        ),
        DateEntry('end', l.eventEnd, initial: e?.endDate, optional: true),
        AmountEntry(
          'budget',
          l.eventBudget,
          initial: e?.budgetCents,
          optional: true,
        ),
      ],
      onSave: (v) => client.event.save(
        _groupId,
        LifeEvent(
          id: e?.id,
          groupId: _groupId,
          name: v['name']! as String,
          startDate: v['start']! as DateTime,
          endDate: v['end'] as DateTime?,
          budgetCents: v['budget'] as int?,
        ),
      ),
    );
    if (saved != null) await reload();
  }

  Future<void> _openEvent(LifeEventInfo info) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _EventPage(
          info: info,
          accounts: widget.accounts,
          canWrite: _canWrite,
        ),
      ),
    );
    await reload();
  }

  Future<void> _eventAction(LifeEventInfo info, String action) async {
    final e = info.event;
    switch (action) {
      case 'edit':
        await _editEvent(e);
      case 'remove':
        if (!await confirmRemove(context, e.name) || !mounted) return;
        if (await runShowingError(context, () => client.event.remove(e.id!))) {
          await reload();
        }
    }
  }

  // Reminders.

  Future<void> _editReminder([Reminder? r]) async {
    final l = AppLocalizations.of(context);
    final saved = await showEntryDialog(
      context,
      title: r == null ? l.reminderAdd : l.reminderEdit,
      intro: l.reminderIntro,
      fields: [
        TextEntry('text', l.reminderText, initial: r?.text, maxLength: 200),
        DateEntry(
          'date',
          l.reminderDate,
          initial: r?.dueDate ?? todayUtcMidnight(),
        ),
      ],
      onSave: (v) => client.reminder.save(
        _groupId,
        Reminder(
          id: r?.id,
          groupId: _groupId,
          authUserId:
              r?.authUserId ??
              UuidValue.fromString('${client.auth.authInfo?.authUserId}'),
          text: v['text']! as String,
          dueDate: v['date']! as DateTime,
        ),
      ),
    );
    if (saved != null) await reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final refunds = _refunds;
    final today = todayUtcMidnight();
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.followUpTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(l.followUpIntro),
          const SizedBox(height: 12),
          if (_error != null)
            Text(_error!, style: TextStyle(color: theme.colorScheme.error))
          else if (refunds == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            _header(
              context,
              l.remindersTitle,
              l.reminderAdd,
              _editReminder,
              always: true,
            ),
            if (_reminders.isEmpty) _empty(l.remindersEmpty),
            for (final r in _reminders)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: r.doneAt != null,
                title: Text(
                  r.text,
                  style: r.doneAt == null
                      ? null
                      : const TextStyle(decoration: TextDecoration.lineThrough),
                ),
                subtitle: Text(
                  context.day(r.dueDate),
                  style: r.doneAt == null && !r.dueDate.isAfter(today)
                      ? TextStyle(color: theme.colorScheme.error)
                      : null,
                ),
                secondary: PopupMenuButton<String>(
                  onSelected: (a) async {
                    if (a == 'edit') {
                      await _editReminder(r);
                    } else if (await confirmRemove(context, r.text) &&
                        context.mounted &&
                        await runShowingError(
                          context,
                          () => client.reminder.remove(r.id!),
                        )) {
                      await reload();
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'edit', child: Text(l.reminderEdit)),
                    PopupMenuItem(value: 'remove', child: Text(l.entryRemove)),
                  ],
                ),
                onChanged: (v) async {
                  if (await runShowingError(
                    context,
                    () => client.reminder.setDone(r.id!, v ?? false),
                  )) {
                    await reload();
                  }
                },
              ),
            const SizedBox(height: 24),
            _header(context, l.refundsTitle, l.refundAdd, _editRefund),
            if (refunds.isEmpty) _empty(l.refundsEmpty),
            for (final r in refunds) _refund(context, r, today),
            const SizedBox(height: 24),
            _header(context, l.contractsTitle, l.contractAdd, _editContract),
            if (_contracts.isEmpty) _empty(l.contractsEmpty),
            for (final c in _contracts)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.assignment_outlined,
                  color: c.daysToDeadline >= 0 && c.daysToDeadline <= 30
                      ? theme.colorScheme.error
                      : null,
                ),
                title: Text('${c.label} · ${context.money(c.amountCents)}'),
                subtitle: Text(
                  c.daysToDeadline < 0
                      ? l.contractPassed(context.day(c.renewal))
                      : l.contractDeadline(
                          context.day(c.deadline),
                          c.daysToDeadline,
                          context.day(c.renewal),
                        ),
                ),
                trailing: _canWrite
                    ? PopupMenuButton<String>(
                        onSelected: (a) => _contractAction(c, a),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(l.contractEditMenu),
                          ),
                          PopupMenuItem(
                            value: 'remove',
                            child: Text(l.contractForget),
                          ),
                        ],
                      )
                    : null,
              ),
            const SizedBox(height: 24),
            _header(context, l.eventsTitle, l.eventAdd, _editEvent),
            if (_events.isEmpty) _empty(l.eventsEmpty),
            for (final e in _events)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.celebration_outlined),
                title: Text(e.event.name),
                subtitle: Text(
                  e.event.budgetCents == null
                      ? l.eventLine(e.count, context.money(-e.totalCents))
                      : l.eventLineBudget(
                          e.count,
                          context.money(-e.totalCents),
                          context.money(e.event.budgetCents!),
                        ),
                ),
                onTap: () => _openEvent(e),
                trailing: _canWrite
                    ? PopupMenuButton<String>(
                        onSelected: (a) => _eventAction(e, a),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(l.eventEdit),
                          ),
                          PopupMenuItem(
                            value: 'remove',
                            child: Text(l.entryRemove),
                          ),
                        ],
                      )
                    : null,
              ),
          ],
        ],
      ),
    );
  }

  Widget _header(
    BuildContext context,
    String title,
    String add,
    Future<void> Function() onAdd, {
    bool always = false,
  }) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      if (_canWrite || always)
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: Text(add),
          onPressed: onAdd,
        ),
    ],
  );

  Widget _empty(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: Theme.of(context).textTheme.bodySmall),
  );

  Widget _refund(BuildContext context, ExpectedRefund r, DateTime today) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final received = r.receivedAt != null;
    final late = !received && r.dueBy != null && r.dueBy!.isBefore(today);
    final String status;
    if (received) {
      status = r.transactionId == null
          ? l.refundReceivedBy(context.day(r.receivedAt!))
          : l.refundMatched(context.day(r.receivedAt!));
    } else if (late) {
      status = l.refundLate(context.day(r.dueBy!));
    } else if (r.dueBy != null) {
      status = l.refundAwaitedBy(context.day(r.dueBy!));
    } else {
      status = l.refundAwaited(context.day(r.since));
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        received ? Icons.check_circle_outline : Icons.hourglass_empty,
        color: late ? theme.colorScheme.error : null,
      ),
      title: Text('${r.label} · ${context.money(r.amountCents)}'),
      subtitle: Text(
        status,
        style: late ? TextStyle(color: theme.colorScheme.error) : null,
      ),
      trailing: _canWrite
          ? PopupMenuButton<String>(
              onSelected: (a) => _refundAction(r, a),
              itemBuilder: (_) => [
                if (!received) ...[
                  PopupMenuItem(
                    value: 'received',
                    child: Text(l.refundMarkReceived),
                  ),
                  PopupMenuItem(value: 'edit', child: Text(l.refundEdit)),
                ] else
                  PopupMenuItem(value: 'open', child: Text(l.refundReopen)),
                PopupMenuItem(value: 'remove', child: Text(l.entryRemove)),
              ],
            )
          : null,
    );
  }
}

/// An event's operations: added from the period, removed one by one.
class _EventPage extends StatefulWidget {
  final LifeEventInfo info;
  final List<Account> accounts;
  final bool canWrite;
  const _EventPage({
    required this.info,
    required this.accounts,
    required this.canWrite,
  });

  @override
  State<_EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<_EventPage> {
  List<BankTransaction>? _ops;
  String? _error;

  LifeEvent get _event => widget.info.event;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final ops = await client.event.operations(_event.id!);
      if (mounted) setState(() => _ops = ops);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _add() async {
    final l = AppLocalizations.of(context);
    final have = {for (final t in _ops ?? const <BankTransaction>[]) t.id};
    final candidates = <BankTransaction>[];
    final from = _event.startDate;
    final to = _event.endDate ?? from.add(const Duration(days: 31));
    final ok = await runShowingError(context, () async {
      for (final a in widget.accounts) {
        final page = await client.transaction.list(
          a.id!,
          from: from,
          to: to,
          limit: 200,
        );
        candidates.addAll(page.items.where((t) => !have.contains(t.id)));
      }
    });
    if (!ok || !mounted) return;
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.eventNoCandidates)));
      return;
    }
    candidates.sort((a, b) => a.date.compareTo(b.date));
    final saved = await showEntryDialog(
      context,
      title: l.eventAttach,
      intro: l.eventAttachIntro(context.day(from), context.day(to)),
      fields: [
        MultiEntry<int>(
          'ids',
          l.eventOperations,
          options: [
            for (final t in candidates)
              (
                t.id!,
                '${context.shortDay(t.date)} · ${t.cleanLabel} · ${context.money(t.amountCents)}',
              ),
          ],
        ),
      ],
      onSave: (v) => client.event.attach(
        _event.id!,
        (v['ids']! as Set).cast<int>().toList(),
      ),
    );
    if (saved != null) await _load();
  }

  Future<void> _detach(BankTransaction t) async {
    if (await runShowingError(
      context,
      () => client.event.detach(_event.id!, t.id!),
    )) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ops = _ops;
    final total = ops?.fold(0, (a, t) => a + t.amountCents) ?? 0;
    return Scaffold(
      appBar: AppBar(title: Text(_event.name)),
      floatingActionButton: widget.canWrite
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.playlist_add),
              label: Text(l.eventAttach),
              onPressed: _add,
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null)
            Text(_error!, style: TextStyle(color: theme.colorScheme.error))
          else if (ops == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            Text(
              _event.budgetCents == null
                  ? l.eventLine(ops.length, context.money(-total))
                  : l.eventLineBudget(
                      ops.length,
                      context.money(-total),
                      context.money(_event.budgetCents!),
                    ),
              style: theme.textTheme.titleMedium,
            ),
            if (_event.budgetCents != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _event.budgetCents! <= 0
                    ? 0
                    : (-total / _event.budgetCents!).clamp(0, 1),
              ),
            ],
            const SizedBox(height: 8),
            if (ops.isEmpty) Text(l.eventNoOperations),
            for (final t in ops)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(t.cleanLabel),
                subtitle: Text(context.day(t.date)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.money(t.amountCents)),
                    if (widget.canWrite)
                      IconButton(
                        tooltip: l.eventDetach,
                        icon: const Icon(Icons.link_off),
                        onPressed: () => _detach(t),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
