import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/category_field.dart';

/// Categories of the group (rename, add, archive) and its classification
/// rules, with a tester that shows how a bank label would be classified.
class CategoriesScreen extends StatefulWidget {
  final GroupMembership membership;

  const CategoriesScreen({super.key, required this.membership});

  @override
  State<CategoriesScreen> createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  Map<int, Category> _categories = {};
  List<Rule> _rules = [];
  String? _error;

  int get _groupId => widget.membership.group.id!;
  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(CategoriesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membership.group.id != widget.membership.group.id) reload();
  }

  Future<void> reload() async {
    try {
      final categories = await client.category.list(_groupId);
      final rules = await client.rule.list(_groupId);
      if (!mounted) return;
      setState(() {
        _categories = {for (final c in categories) c.id!: c};
        _rules = rules;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) _fail(e);
    }
  }

  void _fail(Object e) =>
      setState(() => _error = errorText(AppLocalizations.of(context), e));

  /// "Parent › Child", for lists and menus.
  String _path(BuildContext context, Category c) {
    final parent = c.parentId == null ? null : _categories[c.parentId];
    return parent == null
        ? context.categoryName(c)
        : '${context.categoryName(parent)} › ${context.categoryName(c)}';
  }

  List<Category> _sorted(BuildContext context) =>
      _categories.values.toList()
        ..sort((a, b) => _path(context, a).compareTo(_path(context, b)));

  Future<void> _editCategory([Category? c]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _CategoryDialog(
        groupId: _groupId,
        category: c,
        parents: [
          for (final p in _sorted(context))
            if (p.parentId == null && p.id != c?.id) p,
        ],
      ),
    );
    if (saved == true) await reload();
  }

  Future<void> _editRule([Rule? r]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _RuleDialog(
        groupId: _groupId,
        rule: r,
        categories: _sorted(context),
        label: (c) => _path(context, c),
      ),
    );
    if (saved == true) await reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final tabs = DefaultTabController.of(context);
          return Scaffold(
            appBar: TabBar(
              tabs: [
                Tab(text: l.categoriesTab),
                Tab(text: l.rulesTab),
              ],
            ),
            floatingActionButton: _canWrite
                ? ListenableBuilder(
                    listenable: tabs,
                    builder: (context, _) => FloatingActionButton.extended(
                      onPressed: () =>
                          tabs.index == 0 ? _editCategory() : _editRule(),
                      icon: const Icon(Icons.add),
                      label: Text(
                        tabs.index == 0 ? l.categoryAdd : l.ruleAdd,
                      ),
                    ),
                  )
                : null,
            body: _error != null
                ? Center(child: Text(_error!))
                : TabBarView(
                    children: [_categoriesTab(context), _rulesTab(context)],
                  ),
          );
        },
      ),
    );
  }

  Widget _categoriesTab(BuildContext context) {
    final theme = Theme.of(context);
    final mains = [
      for (final c in _sorted(context))
        if (c.parentId == null || !_categories.containsKey(c.parentId)) c,
    ];
    final children = <int, List<Category>>{};
    for (final c in _sorted(context)) {
      final p = c.parentId;
      if (p != null && _categories.containsKey(p)) {
        (children[p] ??= []).add(c);
      }
    }
    // Top-level categories stand out on a tinted band, in bold; their
    // sub-categories are indented along a guide line, in a lighter style.
    Widget tile(Category c, {required bool child}) => ListTile(
      contentPadding: EdgeInsets.only(left: child ? 40 : 16, right: 16),
      tileColor: child ? null : theme.colorScheme.surfaceContainerHigh,
      leading: child
          ? Container(
              width: 2,
              height: 36,
              color: theme.colorScheme.outlineVariant,
            )
          : Icon(_kindIcon(c.kind)),
      minLeadingWidth: child ? 8 : null,
      title: Text(
        context.categoryName(c),
        style: child
            ? theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              )
            : theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
      ),
      subtitle: c.name != null && c.standardCode != null
          ? Text(
              AppLocalizations.of(context).categoryStandardName(
                context.standardName(c) ?? '',
              ),
              style: theme.textTheme.bodySmall,
            )
          : null,
      onTap: _canWrite ? () => _editCategory(c) : null,
    );
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        for (final c in mains) ...[
          const SizedBox(height: 8),
          tile(c, child: false),
          for (final k in children[c.id] ?? const <Category>[])
            tile(k, child: true),
        ],
      ],
    );
  }

  Widget _rulesTab(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _Tester(
          groupId: _groupId,
          category: (id) {
            final c = _categories[id];
            return c == null ? '?' : _path(context, c);
          },
          onOpenRule: (id) {
            final r = _rules.where((x) => '${x.id}' == id).firstOrNull;
            if (r != null && _canWrite) _editRule(r);
          },
        ),
        const SizedBox(height: 16),
        if (_rules.isEmpty) Text(l.rulesEmpty),
        for (final r in _rules)
          Card(
            child: ListTile(
              title: Text(
                l.ruleSummary(
                  _matchText(l, r.matchType),
                  r.pattern,
                  _categories[r.categoryId] == null
                      ? '?'
                      : _path(context, _categories[r.categoryId]!),
                ),
                style: r.enabled ? null : TextStyle(color: theme.disabledColor),
              ),
              subtitle: Text(
                [
                  _directionText(l, r.direction),
                  ?_amountText(context, r),
                  '${l.rulePriority} ${r.priority}',
                ].join(' · '),
              ),
              trailing: Switch(
                value: r.enabled,
                onChanged: _canWrite
                    ? (v) async {
                        try {
                          await client.rule.update(r.id!, enabled: v);
                          await reload();
                        } on Object catch (e) {
                          if (mounted) _fail(e);
                        }
                      }
                    : null,
              ),
              onTap: _canWrite ? () => _editRule(r) : null,
            ),
          ),
      ],
    );
  }

  static IconData _kindIcon(CategoryKind k) => switch (k) {
    CategoryKind.income => Icons.south_west,
    CategoryKind.expense => Icons.north_east,
    CategoryKind.savings => Icons.savings_outlined,
    CategoryKind.transfer => Icons.swap_horiz,
  };

  String? _amountText(BuildContext context, Rule r) {
    final l = AppLocalizations.of(context);
    final min = r.minAbsCents;
    final max = r.maxAbsCents;
    if (min != null && max != null) {
      return l.ruleAmounts(context.money(min), context.money(max));
    }
    if (min != null) return l.ruleAmountFrom(context.money(min));
    if (max != null) return l.ruleAmountUpTo(context.money(max));
    return null;
  }
}

String _matchText(AppLocalizations l, RuleMatchType t) => switch (t) {
  RuleMatchType.contains => l.matchContains,
  RuleMatchType.startsWith => l.matchStartsWith,
  RuleMatchType.equals => l.matchEquals,
};

String _directionText(AppLocalizations l, RuleDirection d) => switch (d) {
  RuleDirection.any => l.directionAny,
  RuleDirection.debit => l.directionDebit,
  RuleDirection.credit => l.directionCredit,
};

/// Rule tester: the server cleans and classifies a label, writing nothing.
class _Tester extends StatefulWidget {
  final int groupId;
  final String Function(int categoryId) category;
  final void Function(String ruleId) onOpenRule;

  const _Tester({
    required this.groupId,
    required this.category,
    required this.onOpenRule,
  });

  @override
  State<_Tester> createState() => _TesterState();
}

class _TesterState extends State<_Tester> {
  final _label = TextEditingController();
  final _amount = TextEditingController(text: '-10,00');
  RuleTestResult? _result;
  String? _error;

  @override
  void dispose() {
    _label.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final l = AppLocalizations.of(context);
    final amount = parseUserAmount(_amount.text);
    if (amount == null || amount == 0) {
      setState(() => (_error = l.amountInvalid, _result = null));
      return;
    }
    try {
      final r = await client.rule.tryLabel(
        widget.groupId,
        _label.text,
        amount,
      );
      if (mounted) setState(() => (_result = r, _error = null));
    } on Object catch (e) {
      if (mounted) setState(() => (_error = errorText(l, e), _result = null));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = _result;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.testerTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(l.testerHelp, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                SizedBox(
                  width: 360,
                  child: TextField(
                    controller: _label,
                    decoration: InputDecoration(labelText: l.bankLabel),
                    onSubmitted: (_) => _run(),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _amount,
                    decoration: InputDecoration(labelText: l.amountLabel),
                    onSubmitted: (_) => _run(),
                  ),
                ),
                FilledButton.tonal(onPressed: _run, child: Text(l.testerRun)),
              ],
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            if (r != null) ...[
              const SizedBox(height: 12),
              Text(l.testerCleaned(r.cleanLabel)),
              if (r.categoryId == null)
                Text(
                  l.testerNone,
                  style: TextStyle(color: theme.colorScheme.tertiary),
                )
              else
                Text(
                  l.testerResult(
                    widget.category(r.categoryId!),
                    context.categorySourceName(r.source),
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              if (r.source == CategorySource.groupRule && r.ruleRef != null)
                TextButton(
                  onPressed: () => widget.onOpenRule(r.ruleRef!),
                  child: Text(l.testerRuleOpen),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryDialog extends StatefulWidget {
  final int groupId;
  final Category? category;
  final List<Category> parents;

  const _CategoryDialog({
    required this.groupId,
    required this.category,
    required this.parents,
  });

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late final Category? _c = widget.category;
  late final _name = TextEditingController(text: _c?.name);
  late var _kind = _c?.kind ?? CategoryKind.expense;
  int? _parent;
  final _form = GlobalKey<FormState>();
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _do(Future<void> Function() call) async {
    try {
      await call();
      if (mounted) Navigator.pop(context, true);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _archive() async {
    final l = AppLocalizations.of(context);
    final c = _c!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.categoryArchiveConfirm(context.categoryName(c))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.categoryArchive),
          ),
        ],
      ),
    );
    if (ok == true) await _do(() => client.category.archive(c.id!));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final c = _c;
    final standard = c?.standardCode != null;
    final standardName = c == null ? null : context.standardName(c) ?? '';
    return AlertDialog(
      title: Text(c == null ? l.categoryAdd : l.categoryEdit),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                maxLength: 60,
                decoration: InputDecoration(
                  labelText: l.categoryName,
                  hintText: standard ? standardName : null,
                ),
                validator: (v) => !standard && (v == null || v.trim().isEmpty)
                    ? l.error_invalid_name
                    : null,
              ),
              if (standard) ...[
                Text(l.categoryStandardHelp, style: theme.textTheme.bodySmall),
                if (c!.name != null)
                  TextButton(
                    onPressed: () => _do(
                      () => client.category.update(c.id!, resetName: true),
                    ),
                    child: Text(l.categoryResetName),
                  ),
              ],
              if (c == null) ...[
                DropdownButtonFormField<CategoryKind>(
                  isExpanded: true,
                  initialValue: _kind,
                  decoration: InputDecoration(labelText: l.categoryKindLabel),
                  items: [
                    for (final k in CategoryKind.values)
                      DropdownMenuItem(
                        value: k,
                        child: Text(categoryKindText(l, k)),
                      ),
                  ],
                  onChanged: (v) => _kind = v!,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  initialValue: _parent,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l.categoryParent),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l.categoryNoParent),
                    ),
                    for (final p in widget.parents)
                      DropdownMenuItem(
                        value: p.id,
                        child: Text(context.categoryName(p)),
                      ),
                  ],
                  onChanged: (v) => _parent = v,
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        if (c != null)
          TextButton(onPressed: _archive, child: Text(l.categoryArchive)),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_form.currentState!.validate()) return;
            final name = _name.text.trim();
            _do(() async {
              if (c == null) {
                await client.category.create(
                  widget.groupId,
                  name,
                  _kind,
                  parentId: _parent,
                );
              } else if (name.isEmpty) {
                await client.category.update(c.id!, resetName: true);
              } else {
                await client.category.update(c.id!, name: name);
              }
            });
          },
          child: Text(l.save),
        ),
      ],
    );
  }
}

class _RuleDialog extends StatefulWidget {
  final int groupId;
  final Rule? rule;
  final List<Category> categories;
  final String Function(Category) label;

  const _RuleDialog({
    required this.groupId,
    required this.rule,
    required this.categories,
    required this.label,
  });

  @override
  State<_RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<_RuleDialog> {
  late final Rule? _r = widget.rule;
  late final _pattern = TextEditingController(text: _r?.pattern);
  late final _min = TextEditingController(
    text: _r?.minAbsCents == null ? '' : _cents(_r!.minAbsCents!),
  );
  late final _max = TextEditingController(
    text: _r?.maxAbsCents == null ? '' : _cents(_r!.maxAbsCents!),
  );
  late final _priority = TextEditingController(
    text: '${_r?.priority ?? 100}',
  );
  late int? _category = _r?.categoryId;
  late var _match = _r?.matchType ?? RuleMatchType.contains;
  late var _direction = _r?.direction ?? RuleDirection.any;
  final _form = GlobalKey<FormState>();
  String? _error;

  /// Cents to editable text without going through double.
  static String _cents(int c) =>
      '${c ~/ 100},${(c % 100).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    for (final c in [_pattern, _min, _max, _priority]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Optional positive amount: null when empty, -1 when unreadable.
  static int? _bound(String text) {
    if (text.trim().isEmpty) return null;
    final c = parseUserAmount(text);
    return c == null || c < 0 ? -1 : c;
  }

  Future<void> _do(Future<void> Function() call) async {
    try {
      await call();
      if (mounted) Navigator.pop(context, true);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final min = _bound(_min.text);
    final max = _bound(_max.text);
    final priority = int.parse(_priority.text.trim());
    final r = _r;
    _do(() async {
      if (r == null) {
        await client.rule.create(
          widget.groupId,
          _category!,
          _pattern.text,
          _match,
          direction: _direction,
          minAbsCents: min,
          maxAbsCents: max,
          priority: priority,
        );
      } else {
        await client.rule.update(
          r.id!,
          categoryId: _category,
          pattern: _pattern.text,
          matchType: _match,
          direction: _direction,
          clearAmounts: min == null && max == null,
          minAbsCents: min,
          maxAbsCents: max,
          priority: priority,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const gap = SizedBox(height: 12);
    String? amount(String? v) => _bound(v ?? '') == -1 ? l.amountInvalid : null;
    return AlertDialog(
      title: Text(_r == null ? l.ruleAdd : l.ruleEdit),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<RuleMatchType>(
                  isExpanded: true,
                  initialValue: _match,
                  decoration: InputDecoration(labelText: l.ruleMatchType),
                  items: [
                    for (final t in RuleMatchType.values)
                      DropdownMenuItem(value: t, child: Text(_matchText(l, t))),
                  ],
                  onChanged: (v) => _match = v!,
                ),
                gap,
                TextFormField(
                  controller: _pattern,
                  autofocus: _r == null,
                  maxLength: 100,
                  decoration: InputDecoration(labelText: l.rulePattern),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l.error_invalid_pattern
                      : null,
                ),
                CategoryFormField(
                  categories: widget.categories,
                  initialValue: _category,
                  label: l.categoryLabel,
                  validator: (v) => v == null ? l.categoryLabel : null,
                  onChanged: (v) => _category = v,
                ),
                gap,
                DropdownButtonFormField<RuleDirection>(
                  isExpanded: true,
                  initialValue: _direction,
                  decoration: InputDecoration(labelText: l.ruleDirection),
                  items: [
                    for (final d in RuleDirection.values)
                      DropdownMenuItem(
                        value: d,
                        child: Text(_directionText(l, d)),
                      ),
                  ],
                  onChanged: (v) => _direction = v!,
                ),
                gap,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _min,
                        decoration: InputDecoration(
                          labelText: l.ruleMinAmount,
                        ),
                        validator: amount,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _max,
                        decoration: InputDecoration(
                          labelText: l.ruleMaxAmount,
                        ),
                        validator: amount,
                      ),
                    ),
                  ],
                ),
                gap,
                TextFormField(
                  controller: _priority,
                  decoration: InputDecoration(
                    labelText: l.rulePriority,
                    helperText: l.rulePriorityHelp,
                  ),
                  validator: (v) => int.tryParse(v?.trim() ?? '') == null
                      ? l.toleranceInvalid
                      : null,
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (_r != null)
          TextButton(
            onPressed: () => _do(() => client.rule.delete(_r.id!)),
            child: Text(l.ruleDelete),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(l.save)),
      ],
    );
  }
}
