import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/entry_dialog.dart';

/// Net worth, regulated savings, financial health and the yearly review
/// (decision 0050). Every figure comes from the server's engine.
class WealthScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;
  const WealthScreen({
    super.key,
    required this.membership,
    required this.accounts,
  });

  @override
  State<WealthScreen> createState() => WealthScreenState();
}

class WealthScreenState extends State<WealthScreen> {
  WealthOverview? _wealth;
  List<RegulatedSavingsInfo> _savings = const [];
  HealthReport? _health;
  YearReview? _year;
  Map<int, Category> _categories = const {};
  int _yearShown = DateTime.now().year;
  String? _error;

  int get _groupId => widget.membership.group.id!;
  bool get _canWrite => widget.membership.role != MemberRole.reader;
  bool get _isAdmin => widget.membership.role == MemberRole.admin;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(WealthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membership.group.id != widget.membership.group.id) reload();
  }

  Future<void> reload() async {
    try {
      final results = await Future.wait<Object>([
        client.wealth.overview(_groupId),
        client.wealth.savings(_groupId),
        client.wealth.health(_groupId),
        client.wealth.year(_groupId, _yearShown),
        client.category.list(_groupId),
      ]);
      if (!mounted) return;
      setState(() {
        _wealth = results[0] as WealthOverview;
        _savings = results[1] as List<RegulatedSavingsInfo>;
        _health = results[2] as HealthReport;
        _year = results[3] as YearReview;
        _categories = {
          for (final c in results[4] as List<Category>) c.id!: c,
        };
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _showYear(int year) async {
    setState(() => _yearShown = year);
    try {
      final review = await client.wealth.year(_groupId, year);
      if (mounted) setState(() => _year = review);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  String _assetKind(AppLocalizations l, AssetKind k) => switch (k) {
    AssetKind.property => l.assetProperty,
    AssetKind.vehicle => l.assetVehicle,
    AssetKind.investment => l.assetInvestment,
    AssetKind.valuables => l.assetValuables,
    AssetKind.other => l.assetOther,
  };

  static String regulatedName(AppLocalizations l, RegulatedKind k) =>
      switch (k) {
        RegulatedKind.livretA => l.regulatedLivretA,
        RegulatedKind.ldds => l.regulatedLdds,
        RegulatedKind.lep => l.regulatedLep,
        RegulatedKind.livretJeune => l.regulatedLivretJeune,
      };

  Future<void> _editAsset([Asset? a]) async {
    final l = AppLocalizations.of(context);
    final saved = await showEntryDialog(
      context,
      title: a == null ? l.assetAdd : l.assetEdit,
      intro: l.assetIntro,
      fields: [
        TextEntry('name', l.assetName, initial: a?.name),
        ChoiceEntry<AssetKind>(
          'kind',
          l.assetKind,
          initial: a?.kind ?? AssetKind.property,
          options: [for (final k in AssetKind.values) (k, _assetKind(l, k))],
        ),
        AmountEntry('value', l.assetValue, initial: a?.valueCents),
        DateEntry(
          'date',
          l.assetValuedAt,
          initial: a?.valuedAt ?? todayUtcMidnight(),
        ),
      ],
      onSave: (v) => client.wealth.saveAsset(
        _groupId,
        Asset(
          id: a?.id,
          groupId: _groupId,
          name: v['name']! as String,
          kind: v['kind']! as AssetKind,
          valueCents: v['value']! as int,
          valuedAt: v['date']! as DateTime,
        ),
      ),
    );
    if (saved != null) await reload();
  }

  Future<void> _removeAsset(Asset a) async {
    if (!await confirmRemove(context, a.name) || !mounted) return;
    if (await runShowingError(
      context,
      () => client.wealth.removeAsset(a.id!),
    )) {
      await reload();
    }
  }

  /// Which savings account is a regulated one, and at what rate.
  Future<void> _savingsTerms() async {
    final l = AppLocalizations.of(context);
    final candidates = [
      for (final a in widget.accounts)
        if (a.kind == AccountKind.savings) a,
    ];
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.regulatedNoSavings)));
      return;
    }
    final saved = await showEntryDialog(
      context,
      title: l.regulatedSet,
      intro: l.regulatedSetIntro,
      fields: [
        ChoiceEntry<int>(
          'account',
          l.regulatedAccount,
          initial: candidates.first.id,
          options: [for (final a in candidates) (a.id!, a.name)],
        ),
        ChoiceEntry<RegulatedKind>(
          'kind',
          l.regulatedKind,
          optional: true,
          initial: candidates.first.regulatedKind,
          options: [
            for (final k in RegulatedKind.values) (k, regulatedName(l, k)),
          ],
        ),
        AmountEntry('rate', l.regulatedRate, optional: true, suffix: '%'),
      ],
      onSave: (v) => client.account.setSavingsTerms(
        v['account']! as int,
        v['kind'] as RegulatedKind?,
        v['rate'] as int?,
      ),
    );
    if (saved != null) await reload();
  }

  /// Ticks the categories whose operations the tax return needs.
  Future<void> _taxCategories() async {
    final l = AppLocalizations.of(context);
    final all =
        [
          for (final c in _categories.values)
            if (c.deletedAt == null) c,
        ]..sort(
          (a, b) => context.categoryName(a).compareTo(context.categoryName(b)),
        );
    final before = {
      for (final c in all)
        if (c.taxRelevant) c.id!,
    };
    await showEntryDialog(
      context,
      title: l.taxCategoriesTitle,
      intro: l.taxCategoriesIntro,
      fields: [
        MultiEntry<int>(
          'ids',
          l.taxCategoriesField,
          optional: true,
          initial: before,
          options: [for (final c in all) (c.id!, context.categoryName(c))],
        ),
      ],
      onSave: (v) async {
        final after = (v['ids']! as Set).cast<int>();
        for (final id in {...before, ...after}) {
          final want = after.contains(id);
          if (want != before.contains(id)) {
            await client.category.setTaxRelevant(id, want);
          }
        }
      },
    );
    await reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final wealth = _wealth;
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.wealthTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(l.wealthIntro),
          const SizedBox(height: 12),
          if (_error != null)
            Text(_error!, style: TextStyle(color: theme.colorScheme.error))
          else if (wealth == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            _netWorth(context, wealth),
            const SizedBox(height: 16),
            _assets(context, wealth),
            const SizedBox(height: 24),
            _regulated(context),
            const SizedBox(height: 24),
            if (_health != null) _healthCard(context, _health!),
            const SizedBox(height: 24),
            if (_year != null) _review(context, _year!),
          ],
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    int cents, {
    bool bold = false,
  }) {
    final style = bold ? Theme.of(context).textTheme.titleMedium : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(context.money(cents), style: style),
        ],
      ),
    );
  }

  Widget _netWorth(BuildContext context, WealthOverview w) {
    final l = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _row(context, l.netWorthAccounts, w.accountsCents),
            _row(context, l.netWorthAssets, w.assetsCents),
            _row(context, l.netWorthLoans, -w.loansCents),
            const Divider(),
            _row(context, l.netWorthTotal, w.netWorthCents, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _assets(BuildContext context, WealthOverview w) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l.assetsTitle, style: theme.textTheme.titleMedium),
            ),
            if (_canWrite)
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l.assetAdd),
                onPressed: _editAsset,
              ),
          ],
        ),
        if (w.assets.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.assetsEmpty),
          ),
        for (final a in w.assets)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(a.name),
            subtitle: Text(
              '${_assetKind(l, a.kind)} · ${l.assetValuedOn(context.day(a.valuedAt))}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.money(a.valueCents)),
                if (_canWrite)
                  PopupMenuButton<String>(
                    onSelected: (v) =>
                        v == 'edit' ? _editAsset(a) : _removeAsset(a),
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'edit', child: Text(l.assetEdit)),
                      PopupMenuItem(
                        value: 'remove',
                        child: Text(l.entryRemove),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _regulated(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l.regulatedTitle, style: theme.textTheme.titleMedium),
            ),
            if (_isAdmin)
              OutlinedButton.icon(
                icon: const Icon(Icons.tune),
                label: Text(l.regulatedSet),
                onPressed: _savingsTerms,
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(l.regulatedIntro, style: theme.textTheme.bodySmall),
        if (_savings.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.regulatedEmpty),
          ),
        for (final s in _savings)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${s.name} · ${regulatedName(l, s.kind)}',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: s.ceilingCents <= 0
                        ? 0
                        : (s.balanceCents / s.ceilingCents).clamp(0, 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.regulatedRoom(
                      context.money(s.balanceCents),
                      context.money(s.ceilingCents),
                      context.money(s.roomCents),
                    ),
                  ),
                  if (s.rateBp == null)
                    Text(l.regulatedNoRate, style: theme.textTheme.bodySmall)
                  else
                    Text(
                      l.regulatedInterest(
                        _rate(s.rateBp!),
                        context.money(s.interestSoFarCents ?? 0),
                        context.money(s.interestYearCents ?? 0),
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// `3,00` for 300 hundredths of a percent (no double).
  String _rate(int bp) {
    final sep = Localizations.localeOf(context).languageCode == 'fr'
        ? ','
        : '.';
    return '${bp ~/ 100}$sep${(bp % 100).toString().padLeft(2, '0')}';
  }

  Widget _healthCard(BuildContext context, HealthReport h) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.healthTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              h.score == null ? l.healthNoScore : l.healthScore(h.score!),
              style: theme.textTheme.headlineSmall,
            ),
            Text(
              l.healthBasis(
                context.money(h.monthlyIncomeCents),
                context.money(h.monthlyExpenseCents),
                context.money(h.savingsCents),
              ),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            for (final i in h.indicators)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: Icon(
                  Icons.circle,
                  size: 14,
                  color: healthGradeColor(theme, i.grade),
                ),
                title: Text(healthIndicatorText(context, i, h.months)),
                trailing: Text(
                  healthGradeName(l, i.grade),
                  style: TextStyle(color: healthGradeColor(theme, i.grade)),
                ),
              ),
            Text(l.healthHow, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  String _categoryName(int id) {
    final c = _categories[id];
    return c == null ? '?' : context.categoryName(c);
  }

  Widget _review(BuildContext context, YearReview y) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final thisYear = DateTime.now().year;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l.yearReviewTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
            DropdownButton<int>(
              value: _yearShown,
              items: [
                for (var v = thisYear; v >= thisYear - 10; v--)
                  DropdownMenuItem(value: v, child: Text('$v')),
              ],
              onChanged: (v) {
                if (v != null) _showYear(v);
              },
            ),
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _row(context, l.yearIncome, y.incomeCents),
                _row(context, l.yearExpense, -y.expenseCents),
                _row(context, l.yearSavings, y.savingsCents),
                if (y.interestCents > 0)
                  _row(context, l.yearInterest, y.interestCents),
              ],
            ),
          ),
        ),
        if (y.topExpenses.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l.yearTopExpenses, style: theme.textTheme.titleSmall),
          for (final c in y.topExpenses)
            _row(
              context,
              l.yearCategoryLine(_categoryName(c.categoryId), c.count),
              c.amountCents,
            ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(l.yearTaxTitle, style: theme.textTheme.titleSmall),
            ),
            if (_canWrite)
              TextButton.icon(
                icon: const Icon(Icons.checklist),
                label: Text(l.taxCategoriesTitle),
                onPressed: _taxCategories,
              ),
          ],
        ),
        Text(l.yearTaxIntro, style: theme.textTheme.bodySmall),
        if (y.taxCategories.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.yearTaxNone),
          ),
        for (final c in y.taxCategories)
          _row(
            context,
            l.yearCategoryLine(_categoryName(c.categoryId), c.count),
            c.amountCents.abs(),
          ),
        if (y.taxOperations.isNotEmpty)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(l.yearTaxOperations(y.taxOperations.length)),
            children: [
              for (final t in y.taxOperations)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(t.cleanLabel),
                  subtitle: Text(
                    '${context.day(t.date)} · ${_categoryName(t.categoryId ?? 0)}',
                  ),
                  trailing: Text(context.money(t.amountCents)),
                ),
            ],
          ),
      ],
    );
  }
}

/// A health grade in words (decision 0050).
String healthGradeName(AppLocalizations l, HealthGrade g) => switch (g) {
  HealthGrade.good => l.healthGood,
  HealthGrade.fair => l.healthFair,
  HealthGrade.weak => l.healthWeak,
  HealthGrade.unknown => l.healthUnknown,
};

Color healthGradeColor(ThemeData theme, HealthGrade g) => switch (g) {
  HealthGrade.good => Colors.green.shade700,
  HealthGrade.fair => Colors.orange.shade800,
  HealthGrade.weak => theme.colorScheme.error,
  HealthGrade.unknown => theme.colorScheme.onSurfaceVariant,
};

/// A health indicator's figure in words: months, percent or count.
String healthIndicatorText(
  BuildContext context,
  HealthIndicatorInfo i,
  int months,
) {
  final l = AppLocalizations.of(context);
  final sep = Localizations.localeOf(context).languageCode == 'fr' ? ',' : '.';
  final v = i.value;
  return switch (i.key) {
    'emergency' =>
      v == null
          ? l.healthEmergencyUnknown
          : l.healthEmergency('${v ~/ 10}$sep${v % 10}'),
    'savingsRate' =>
      v == null
          ? l.healthSavingsRateUnknown
          : l.healthSavingsRate('${v ~/ 10}'),
    'debt' => v == null ? l.healthDebtUnknown : l.healthDebt('${v ~/ 10}'),
    'regularity' =>
      v == null ? l.healthRegularityUnknown : l.healthRegularity(v, months),
    _ => i.key,
  };
}
