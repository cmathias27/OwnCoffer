import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../util/format.dart';
import 'sections.dart';

/// The functions of the app the global search finds (decision 0041,
/// point 5), from their translated name and keywords.
enum AppFunction {
  home,
  accounts,
  operations,
  toClassify,
  forecast,
  budget,
  subscriptions,
  loans,
  invoices,
  scanReceipt,
  imports,
  advisor,
  newOperation,
  categories,
  rules,
  notifications,
  summary,
  start,
  export,
  members,
  security,
  assistant,
  apps,
  pepite,
  display,
  help,
  shortcuts,
  feedback,
  admin,
}

extension AppFunctionInfo on AppFunction {
  String label(AppLocalizations l) => switch (this) {
    AppFunction.home => l.navHome,
    AppFunction.accounts => l.navAccounts,
    AppFunction.operations => l.navOperations,
    AppFunction.toClassify => l.toClassify,
    AppFunction.forecast => l.navForecast,
    AppFunction.budget => l.navBudget,
    AppFunction.subscriptions => l.subscriptionsTitle,
    AppFunction.loans => l.navLoans,
    AppFunction.invoices => l.navInvoices,
    AppFunction.scanReceipt => l.addScanReceipt,
    AppFunction.imports => l.navImport,
    AppFunction.advisor => l.advisorTitle,
    AppFunction.newOperation => l.operationAdd,
    AppFunction.categories => l.navCategories,
    AppFunction.rules => l.rulesTab,
    AppFunction.notifications => l.notificationsTitle,
    AppFunction.summary => l.summaryOpen,
    AppFunction.start => l.startTitle,
    AppFunction.export => l.exportTitle,
    AppFunction.members => l.menuMembers,
    AppFunction.security => l.menuSecurity,
    AppFunction.assistant => l.assistantSettingsTitle,
    AppFunction.apps => l.appsTitle,
    AppFunction.pepite => l.pepiteMenu,
    AppFunction.display => l.settingsDisplay,
    AppFunction.help => l.helpTitle,
    AppFunction.shortcuts => l.shortcutsTitle,
    AppFunction.feedback => l.feedbackTitle,
    AppFunction.admin => l.menuAdmin,
  };

  /// Other words the user may type, comma-separated in the translations.
  String keywords(AppLocalizations l) => switch (this) {
    AppFunction.home => l.searchKwHome,
    AppFunction.accounts => l.searchKwAccounts,
    AppFunction.operations => l.searchKwOperations,
    AppFunction.toClassify => l.searchKwToClassify,
    AppFunction.forecast => l.searchKwForecast,
    AppFunction.budget => l.searchKwBudget,
    AppFunction.subscriptions => l.searchKwSubscriptions,
    AppFunction.loans => l.searchKwLoans,
    AppFunction.invoices => l.searchKwInvoices,
    AppFunction.scanReceipt => l.searchKwScan,
    AppFunction.imports => l.searchKwImport,
    AppFunction.advisor => l.searchKwAdvisor,
    AppFunction.newOperation => l.searchKwNewOperation,
    AppFunction.categories => l.searchKwCategories,
    AppFunction.rules => l.searchKwRules,
    AppFunction.notifications => l.searchKwNotifications,
    AppFunction.summary => l.searchKwSummary,
    AppFunction.start => l.searchKwStart,
    AppFunction.export => l.searchKwExport,
    AppFunction.members => l.searchKwMembers,
    AppFunction.security => l.searchKwSecurity,
    AppFunction.assistant => l.searchKwAssistant,
    AppFunction.apps => l.searchKwApps,
    AppFunction.pepite => l.searchKwPepite,
    AppFunction.display => l.searchKwDisplay,
    AppFunction.help => l.searchKwHelp,
    AppFunction.shortcuts => l.searchKwShortcuts,
    AppFunction.feedback => l.searchKwFeedback,
    AppFunction.admin => l.searchKwAdmin,
  };

  IconData get icon => switch (this) {
    AppFunction.home => AppPage.home.icon,
    AppFunction.accounts => AppPage.accounts.icon,
    AppFunction.operations => AppPage.operations.icon,
    AppFunction.toClassify => Icons.label_off_outlined,
    AppFunction.forecast => AppPage.forecast.icon,
    AppFunction.budget => AppPage.budget.icon,
    AppFunction.subscriptions => Icons.autorenew,
    AppFunction.loans => AppPage.loans.icon,
    AppFunction.invoices => AppPage.invoices.icon,
    AppFunction.scanReceipt => Icons.document_scanner_outlined,
    AppFunction.imports => AppPage.imports.icon,
    AppFunction.advisor => AppPage.advisor.icon,
    AppFunction.newOperation => Icons.add,
    AppFunction.categories => Icons.label_outline,
    AppFunction.rules => Icons.rule,
    AppFunction.notifications => Icons.notifications_none,
    AppFunction.summary => Icons.event_note_outlined,
    AppFunction.start => Icons.flag_outlined,
    AppFunction.export => Icons.download_outlined,
    AppFunction.members => Icons.people_outline,
    AppFunction.security => Icons.shield_outlined,
    AppFunction.assistant => Icons.auto_awesome_outlined,
    AppFunction.apps => Icons.devices_outlined,
    AppFunction.pepite => Icons.pets_outlined,
    AppFunction.display => Icons.text_fields,
    AppFunction.help => Icons.help_outline,
    AppFunction.shortcuts => Icons.keyboard_outlined,
    AppFunction.feedback => Icons.feedback_outlined,
    AppFunction.admin => Icons.admin_panel_settings_outlined,
  };
}

/// Lower case without accents, to match « opé » with « Opérations ».
String foldForSearch(String s) {
  const from = 'àâäáãåçéèêëíìîïñóòôöõúùûüýÿœæ';
  const to = 'aaaaaaceeeeiiiinooooouuuuyyoa';
  final b = StringBuffer();
  for (final c in s.toLowerCase().split('')) {
    final i = from.indexOf(c);
    b.write(i < 0 ? c : to[i]);
  }
  return b.toString();
}

/// The functions matching [query] among [available], best first: every
/// word typed must be found in the name or the keywords.
List<AppFunction> searchFunctions(
  AppLocalizations l,
  String query,
  Iterable<AppFunction> available,
) {
  final words = foldForSearch(
    query,
  ).split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return const [];
  final scored = <(AppFunction, int)>[];
  for (final f in available) {
    final name = foldForSearch(f.label(l));
    final all = '$name ${foldForSearch(f.keywords(l))}';
    if (!words.every(all.contains)) continue;
    final score = name.startsWith(words.first)
        ? 0
        : name.contains(words.first)
        ? 1
        : 2;
    scored.add((f, score));
  }
  scored.sort((a, b) => a.$2.compareTo(b.$2));
  return [for (final s in scored) s.$1];
}

/// What the user chose in the search.
sealed class SearchPick {
  const SearchPick();
}

class FunctionPick extends SearchPick {
  final AppFunction function;
  const FunctionPick(this.function);
}

class OperationPick extends SearchPick {
  final BankTransaction operation;
  const OperationPick(this.operation);
}

class LoanPick extends SearchPick {
  final Loan loan;
  const LoanPick(this.loan);
}

class InvoicePick extends SearchPick {
  final InvoiceInfo invoice;
  const InvoicePick(this.invoice);
}

/// Asks the server; replaced in the tests.
typedef GlobalSearcher =
    Future<GlobalSearchResult> Function(int groupId, String query);

/// The search of every screen (key `/`): the app's functions at once, then
/// the operations, loans and invoices of the household from the server.
/// Offline, only the functions.
class GlobalSearchScreen extends StatefulWidget {
  final int? groupId;
  final Iterable<AppFunction> functions;
  final Map<int, Account> accounts;
  final GlobalSearcher? searcher;

  const GlobalSearchScreen({
    super.key,
    required this.groupId,
    required this.functions,
    this.accounts = const {},
    this.searcher,
  });

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _query = TextEditingController();
  Timer? _debounce;
  GlobalSearchResult? _found;
  var _searching = false;
  var _offline = false;

  /// Answers of an older text are dropped.
  var _asked = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _changed(String text) {
    setState(() {});
    _debounce?.cancel();
    final groupId = widget.groupId;
    if (groupId == null || text.trim().length < 2) {
      setState(() => (_found = null, _searching = false));
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _ask(groupId, text.trim()),
    );
  }

  Future<void> _ask(int groupId, String text) async {
    final asked = ++_asked;
    setState(() => _searching = true);
    try {
      final r = await (widget.searcher ?? client.search.global)(groupId, text);
      if (!mounted || asked != _asked) return;
      setState(() => (_found = r, _offline = false, _searching = false));
    } on Object {
      if (!mounted || asked != _asked) return;
      setState(() => (_found = null, _offline = true, _searching = false));
    }
  }

  void _pick(SearchPick p) => Navigator.of(context).pop(p);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final text = _query.text.trim();
    final functions = searchFunctions(l, text, widget.functions);
    final found = _found;
    Widget header(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: theme.textTheme.titleSmall),
    );
    final nothing =
        text.isNotEmpty &&
        !_searching &&
        functions.isEmpty &&
        (found == null ||
            (found.operations.isEmpty &&
                found.loans.isEmpty &&
                found.invoices.isEmpty));
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const Key('global-search-field'),
          controller: _query,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l.globalSearchHint,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: _changed,
          onSubmitted: (_) {
            if (functions.isNotEmpty &&
                (found == null || found.operations.isEmpty)) {
              _pick(FunctionPick(functions.first));
            }
          },
        ),
        actions: [
          if (text.isNotEmpty)
            IconButton(
              tooltip: l.globalSearchClear,
              icon: const Icon(Icons.close),
              onPressed: () {
                _query.clear();
                _changed('');
              },
            ),
        ],
        bottom: _searching
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(minHeight: 2),
              )
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          if (text.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l.globalSearchIntro, textAlign: TextAlign.center),
            ),
          if (_offline || widget.groupId == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                l.globalSearchOffline,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.moneyColors.muted,
                ),
              ),
            ),
          if (nothing)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l.globalSearchNothing(text),
                textAlign: TextAlign.center,
              ),
            ),
          if (functions.isNotEmpty) ...[
            header(l.globalSearchFunctions),
            for (final f in functions.take(8))
              ListTile(
                key: Key('search-fn-${f.name}'),
                leading: Icon(f.icon),
                title: Text(f.label(l)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pick(FunctionPick(f)),
              ),
          ],
          if (found != null && found.operations.isNotEmpty) ...[
            header(l.navOperations),
            for (final t in found.operations)
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(
                  t.cleanLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  [
                    context.day(t.date),
                    ?widget.accounts[t.accountId]?.name,
                  ].join(' · '),
                ),
                trailing: Text(
                  context.money(
                    t.amountCents,
                    currency: widget.accounts[t.accountId]?.currency ?? 'EUR',
                  ),
                  style: TextStyle(
                    color: t.amountCents > 0
                        ? context.moneyColors.positive
                        : null,
                  ),
                ),
                onTap: () => _pick(OperationPick(t)),
              ),
          ],
          if (found != null && found.loans.isNotEmpty) ...[
            header(l.navLoans),
            for (final loan in found.loans)
              ListTile(
                leading: Icon(AppPage.loans.icon),
                title: Text(loan.label ?? loan.lender),
                subtitle: Text(
                  [
                    if (loan.label != null) loan.lender,
                    context.money(loan.principalCents),
                  ].join(' · '),
                ),
                onTap: () => _pick(LoanPick(loan)),
              ),
          ],
          if (found != null && found.invoices.isNotEmpty) ...[
            header(l.navInvoices),
            for (final i in found.invoices)
              ListTile(
                leading: Icon(AppPage.invoices.icon),
                title: Text(i.name),
                subtitle: Text(
                  [
                    if (i.transactionLabel != null) i.transactionLabel!,
                    if (i.amountCents != null)
                      context.money(
                        i.amountCents!,
                        currency: i.currency ?? 'EUR',
                      ),
                  ].join(' · '),
                ),
                onTap: () => _pick(InvoicePick(i)),
              ),
          ],
        ],
      ),
    );
  }
}
