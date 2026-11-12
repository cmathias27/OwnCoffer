import 'package:flutter/material.dart';

import '../help/help.dart';
import '../l10n/app_localizations.dart';

/// The pages of the signed-in shell, in the order of its stack.
enum AppPage {
  home,
  accounts,
  operations,
  forecast,
  budget,
  loans,
  invoices,
  imports,
  advisor,
}

/// The five sections (decision 0041, point 1), the same on every screen.
enum AppSection { home, money, plan, papers, advisor }

extension AppSectionInfo on AppSection {
  /// Its pages, shown as tabs when there are several.
  List<AppPage> get pages => switch (this) {
    AppSection.home => const [AppPage.home],
    AppSection.money => const [AppPage.accounts, AppPage.operations],
    AppSection.plan => const [AppPage.forecast, AppPage.budget, AppPage.loans],
    AppSection.papers => const [AppPage.invoices, AppPage.imports],
    AppSection.advisor => const [AppPage.advisor],
  };

  IconData get icon => switch (this) {
    AppSection.home => Icons.home_outlined,
    AppSection.money => Icons.account_balance_wallet_outlined,
    AppSection.plan => Icons.show_chart,
    AppSection.papers => Icons.folder_outlined,
    AppSection.advisor => Icons.lightbulb_outline,
  };

  IconData get selectedIcon => switch (this) {
    AppSection.home => Icons.home,
    AppSection.money => Icons.account_balance_wallet,
    AppSection.plan => Icons.insights,
    AppSection.papers => Icons.folder,
    AppSection.advisor => Icons.lightbulb,
  };

  String label(AppLocalizations l) => switch (this) {
    AppSection.home => l.navHome,
    AppSection.money => l.navMoney,
    AppSection.plan => l.navPlan,
    AppSection.papers => l.navPapers,
    AppSection.advisor => l.navAdvisor,
  };
}

extension AppPageInfo on AppPage {
  AppSection get section =>
      AppSection.values.firstWhere((s) => s.pages.contains(this));

  String label(AppLocalizations l) => switch (this) {
    AppPage.home => l.navHome,
    AppPage.accounts => l.navAccounts,
    AppPage.operations => l.navOperations,
    AppPage.forecast => l.navForecast,
    AppPage.budget => l.navBudget,
    AppPage.loans => l.navLoans,
    AppPage.invoices => l.navInvoices,
    AppPage.imports => l.navImport,
    AppPage.advisor => l.advisorTitle,
  };

  IconData get icon => switch (this) {
    AppPage.home => Icons.home_outlined,
    AppPage.accounts => Icons.account_balance_wallet_outlined,
    AppPage.operations => Icons.receipt_long_outlined,
    AppPage.forecast => Icons.show_chart,
    AppPage.budget => Icons.pie_chart_outline,
    AppPage.loans => Icons.account_balance_outlined,
    AppPage.invoices => Icons.description_outlined,
    AppPage.imports => Icons.upload_file_outlined,
    AppPage.advisor => Icons.lightbulb_outline,
  };

  HelpTopic get help => switch (this) {
    AppPage.home => HelpTopic.home,
    AppPage.accounts => HelpTopic.accounts,
    AppPage.operations => HelpTopic.operations,
    AppPage.forecast => HelpTopic.forecast,
    AppPage.budget => HelpTopic.budget,
    AppPage.loans => HelpTopic.loans,
    AppPage.invoices => HelpTopic.invoices,
    AppPage.imports => HelpTopic.import,
    AppPage.advisor => HelpTopic.advisor,
  };
}

/// « Prévoir › Crédits › Maison » (decision 0041, point 3): where the user
/// is, read in one line. The last part is the current page.
class Breadcrumb extends StatelessWidget {
  final List<String> parts;
  const Breadcrumb(this.parts, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: AppLocalizations.of(context).breadcrumbLabel(parts.join(' › ')),
      excludeSemantics: true,
      child: Text(
        parts.join(' › '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// The page title with its trail above it, for the pages opened on top of
/// a section (a loan, a setting).
class TrailTitle extends StatelessWidget {
  final List<String> trail;
  final String title;
  const TrailTitle({super.key, required this.trail, required this.title});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Breadcrumb(trail),
      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
    ],
  );
}

/// Under the top bar of a section with several pages: the trail and the
/// pages as tabs, with the help of the page shown.
class SectionBar extends StatelessWidget {
  final AppPage page;
  final ValueChanged<AppPage> onPage;
  const SectionBar({super.key, required this.page, required this.onPage});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final section = page.section;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Breadcrumb([section.label(l)]),
                    const SizedBox(width: 8),
                    for (final p in section.pages)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          key: Key('page-${p.name}'),
                          avatar: Icon(p.icon, size: 18),
                          label: Text(p.label(l)),
                          selected: p == page,
                          showCheckmark: false,
                          onSelected: (_) => onPage(p),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            HelpButton(page.help),
          ],
        ),
      ),
    );
  }
}
