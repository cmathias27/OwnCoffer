import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/entry_dialog.dart';

/// Savings projects and yearly expenses spread over the months
/// (decision 0050). Every figure comes from the server's engine.
class ProjectsScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;
  const ProjectsScreen({
    super.key,
    required this.membership,
    required this.accounts,
  });

  @override
  State<ProjectsScreen> createState() => ProjectsScreenState();
}

class ProjectsScreenState extends State<ProjectsScreen> {
  ProjectOverview? _data;
  String? _error;

  int get _groupId => widget.membership.group.id!;
  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(ProjectsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membership.group.id != widget.membership.group.id) reload();
  }

  Future<void> reload() async {
    try {
      final data = await client.project.overview(_groupId);
      if (mounted) {
        setState(() {
          _data = data;
          _error = null;
        });
      }
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _edit([SavingsProject? p]) async {
    final l = AppLocalizations.of(context);
    final saved = await showEntryDialog(
      context,
      title: p == null ? l.projectAdd : l.projectEdit,
      fields: [
        TextEntry('name', l.projectName, initial: p?.name),
        AmountEntry('target', l.projectTarget, initial: p?.targetCents),
        if (p == null) AmountEntry('saved', l.projectSaved, optional: true),
        DateEntry(
          'date',
          l.projectDate,
          initial: p?.targetDate,
          optional: true,
        ),
        ChoiceEntry<int>(
          'account',
          l.projectAccount,
          optional: true,
          initial: p?.accountId,
          options: [for (final a in widget.accounts) (a.id!, a.name)],
        ),
      ],
      onSave: (v) => client.project.save(
        _groupId,
        SavingsProject(
          id: p?.id,
          groupId: _groupId,
          name: v['name']! as String,
          targetCents: v['target']! as int,
          savedCents: p?.savedCents ?? (v['saved'] as int? ?? 0),
          targetDate: v['date'] as DateTime?,
          accountId: v['account'] as int?,
        ),
      ),
    );
    if (saved != null) await reload();
  }

  Future<void> _addSaved(SavingsProject p) async {
    final l = AppLocalizations.of(context);
    final saved = await showEntryDialog(
      context,
      title: l.projectAddSaved,
      intro: l.projectAddSavedIntro,
      fields: [AmountEntry('amount', l.projectAmount, allowNegative: true)],
      onSave: (v) => client.project.addSaved(p.id!, v['amount']! as int),
    );
    if (saved != null) await reload();
  }

  Future<void> _menu(SavingsProjectInfo info, String action) async {
    final p = info.project;
    switch (action) {
      case 'saved':
        await _addSaved(p);
      case 'edit':
        await _edit(p);
      case 'archive':
        if (await runShowingError(
          context,
          () => client.project.setArchived(p.id!, p.archivedAt == null),
        )) {
          await reload();
        }
      case 'remove':
        if (!await confirmRemove(context, p.name)) return;
        if (!mounted) return;
        if (await runShowingError(
          context,
          () => client.project.remove(p.id!),
        )) {
          await reload();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final data = _data;
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.projectsTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(l.projectsIntro),
          const SizedBox(height: 12),
          if (_error != null)
            Text(_error!, style: TextStyle(color: theme.colorScheme.error))
          else if (data == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.projectsMonthly(
                        context.money(
                          data.projectsMonthlyCents + data.smoothedMonthlyCents,
                        ),
                      ),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.projectsMonthlyDetail(
                        context.money(data.projectsMonthlyCents),
                        context.money(data.smoothedMonthlyCents),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.projectsList,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (_canWrite)
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l.projectAdd),
                    onPressed: _edit,
                  ),
              ],
            ),
            if (data.projects.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l.projectsEmpty),
              ),
            for (final p in data.projects) _project(context, p),
            const SizedBox(height: 24),
            Text(l.smoothedTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(l.smoothedIntro, style: theme.textTheme.bodySmall),
            if (data.smoothed.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l.smoothedEmpty),
              )
            else ...[
              const SizedBox(height: 8),
              Text(
                l.smoothedTotals(
                  context.money(data.smoothedMonthlyCents),
                  context.money(data.smoothedSetAsideCents),
                ),
              ),
              for (final s in data.smoothed)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_repeat_outlined),
                  title: Text(s.label),
                  subtitle: Text(
                    l.smoothedLine(
                      context.money(s.amountCents),
                      s.periodMonths,
                      context.day(s.nextDue),
                      context.money(s.setAsideCents),
                    ),
                  ),
                  trailing: Text(
                    l.perMonth(context.money(s.monthlyCents)),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _project(BuildContext context, SavingsProjectInfo info) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = info.project;
    final archived = p.archivedAt != null;
    final String status;
    if (info.reached) {
      status = l.projectReached;
    } else if (info.overdue) {
      status = l.projectOverdue(context.money(info.remainingCents));
    } else if (info.monthlyCents != null && info.monthsLeft != null) {
      status = l.projectPlan(
        context.money(info.monthlyCents!),
        info.monthsLeft!,
      );
    } else {
      status = l.projectRemaining(context.money(info.remainingCents));
    }
    return Opacity(
      opacity: archived ? 0.6 : 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 4, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(p.name, style: theme.textTheme.titleMedium),
                  ),
                  if (archived)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(label: Text(l.projectArchived)),
                    ),
                  if (_canWrite)
                    PopupMenuButton<String>(
                      onSelected: (a) => _menu(info, a),
                      itemBuilder: (_) => [
                        if (!archived)
                          PopupMenuItem(
                            value: 'saved',
                            child: Text(l.projectAddSaved),
                          ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(l.projectEdit),
                        ),
                        PopupMenuItem(
                          value: 'archive',
                          child: Text(
                            archived ? l.projectUnarchive : l.projectArchive,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'remove',
                          child: Text(l.entryRemove),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: info.progressPerMille.clamp(0, 1000) / 1000,
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  l.projectProgress(
                    context.money(p.savedCents),
                    context.money(p.targetCents),
                    info.progressPerMille ~/ 10,
                  ),
                ),
              ),
              Text(
                p.targetDate == null
                    ? status
                    : '$status · ${l.projectBy(context.day(p.targetDate!))}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: info.overdue ? theme.colorScheme.error : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
