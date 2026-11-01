import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

/// The pages of the in-app help, one per screen. Their text is in
/// `assets/help/<language>/<name>.md` (French and English), readable on
/// GitHub too. Shipped with the app: no network call.
enum HelpTopic {
  start,
  home,
  accounts,
  operations,
  import,
  categories,
  budget,
  forecast,
  loans,
  invoices,
  advisor,
  assistant,
  notifications,
  members,
  security,
  admin,
  privacy;

  String asset(String language) =>
      'assets/help/${language == 'en' ? 'en' : 'fr'}/$name.md';
}

/// A help page as written: its title (first `# ` line) and its blocks.
class HelpDoc {
  final String title;
  final List<HelpBlock> blocks;
  const HelpDoc(this.title, this.blocks);

  /// Reads the small Markdown the help pages use: `#` and `##` titles,
  /// `- ` and `1. ` lists, paragraphs (lines joined until a blank line),
  /// and `**bold**` inside a line.
  factory HelpDoc.parse(String text) {
    var title = '';
    final blocks = <HelpBlock>[];
    final paragraph = <String>[];
    void flush() {
      if (paragraph.isEmpty) return;
      blocks.add(HelpBlock(HelpBlockKind.paragraph, paragraph.join(' ')));
      paragraph.clear();
    }

    final numbered = RegExp(r'^(\d+)\.\s+(.*)$');
    for (final raw in text.split('\n')) {
      final line = raw.trimRight();
      if (line.trim().isEmpty) {
        flush();
      } else if (line.startsWith('# ')) {
        flush();
        title = line.substring(2).trim();
      } else if (line.startsWith('## ')) {
        flush();
        blocks.add(HelpBlock(HelpBlockKind.heading, line.substring(3).trim()));
      } else if (line.startsWith('- ')) {
        flush();
        blocks.add(HelpBlock(HelpBlockKind.bullet, line.substring(2).trim()));
      } else if (numbered.firstMatch(line) case final m?) {
        flush();
        blocks.add(HelpBlock(HelpBlockKind.numbered, m[2]!, number: m[1]));
      } else {
        paragraph.add(line.trim());
      }
    }
    flush();
    return HelpDoc(title, blocks);
  }

  static Future<HelpDoc> load(HelpTopic topic, String language) async =>
      HelpDoc.parse(await rootBundle.loadString(topic.asset(language)));
}

enum HelpBlockKind { heading, paragraph, bullet, numbered }

class HelpBlock {
  final HelpBlockKind kind;
  final String text;
  final String? number;
  const HelpBlock(this.kind, this.text, {this.number});
}

/// `**bold**` as spans; the rest as written.
List<TextSpan> helpSpans(String text) {
  final spans = <TextSpan>[];
  final parts = text.split('**');
  for (var i = 0; i < parts.length; i++) {
    if (parts[i].isEmpty) continue;
    spans.add(
      TextSpan(
        text: parts[i],
        style: i.isOdd ? const TextStyle(fontWeight: FontWeight.w600) : null,
      ),
    );
  }
  return spans;
}

String _language(BuildContext context) =>
    Localizations.localeOf(context).languageCode;

/// The "?" of a page's top bar: opens the help of that page.
class HelpButton extends StatelessWidget {
  final HelpTopic topic;
  const HelpButton(this.topic, {super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: AppLocalizations.of(context).helpButton,
    icon: const Icon(Icons.help_outline),
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => HelpPage(topic: topic)),
    ),
  );
}

/// One help page, with a way to all the others.
class HelpPage extends StatefulWidget {
  final HelpTopic topic;
  const HelpPage({super.key, required this.topic});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  Future<HelpDoc>? _doc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read once per language, not at every rebuild.
    _doc ??= HelpDoc.load(widget.topic, _language(context));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FutureBuilder<HelpDoc>(
      future: _doc,
      builder: (context, snap) {
        final doc = snap.data;
        return Scaffold(
          appBar: AppBar(title: Text(doc?.title ?? l.helpTitle)),
          body: doc == null
              ? Center(
                  child: snap.hasError
                      ? Text(l.error_generic)
                      : const CircularProgressIndicator(),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ..._render(context, doc),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.menu_book_outlined),
                                label: Text(l.helpAll),
                                onPressed: () =>
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const HelpScreen(),
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  static List<Widget> _render(BuildContext context, HelpDoc doc) {
    final theme = Theme.of(context);
    final body = theme.textTheme.bodyLarge;
    Widget rich(String text, {TextStyle? style}) =>
        Text.rich(TextSpan(style: style ?? body, children: helpSpans(text)));
    Widget item(String mark, String text) => Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 24, child: Text(mark, style: body)),
          Expanded(child: rich(text)),
        ],
      ),
    );
    return [
      for (final b in doc.blocks)
        switch (b.kind) {
          HelpBlockKind.heading => Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 6),
            child: Text(
              b.text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          HelpBlockKind.paragraph => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: rich(b.text),
          ),
          HelpBlockKind.bullet => item('•', b.text),
          HelpBlockKind.numbered => item('${b.number}.', b.text),
        },
    ];
  }
}

/// All the help pages, in reading order.
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  static IconData icon(HelpTopic t) => switch (t) {
    HelpTopic.start => Icons.flag_outlined,
    HelpTopic.home => Icons.home_outlined,
    HelpTopic.accounts => Icons.account_balance_wallet_outlined,
    HelpTopic.operations => Icons.receipt_long_outlined,
    HelpTopic.import => Icons.upload_file_outlined,
    HelpTopic.categories => Icons.label_outline,
    HelpTopic.budget => Icons.pie_chart_outline,
    HelpTopic.forecast => Icons.show_chart,
    HelpTopic.loans => Icons.account_balance_outlined,
    HelpTopic.invoices => Icons.description_outlined,
    HelpTopic.advisor => Icons.lightbulb_outline,
    HelpTopic.assistant => Icons.auto_awesome_outlined,
    HelpTopic.notifications => Icons.notifications_none,
    HelpTopic.members => Icons.people_outline,
    HelpTopic.security => Icons.shield_outlined,
    HelpTopic.admin => Icons.admin_panel_settings_outlined,
    HelpTopic.privacy => Icons.lock_outline,
  };

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Future<List<HelpDoc>>? _docs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = _language(context);
    _docs ??= Future.wait([
      for (final t in HelpTopic.values) HelpDoc.load(t, language),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.helpTitle)),
      body: FutureBuilder<List<HelpDoc>>(
        future: _docs,
        builder: (context, snap) {
          final docs = snap.data;
          if (docs == null) {
            return Center(
              child: snap.hasError
                  ? Text(l.error_generic)
                  : const CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                        child: Text(l.helpIntro),
                      ),
                      for (final (i, t) in HelpTopic.values.indexed)
                        ListTile(
                          leading: Icon(HelpScreen.icon(t)),
                          title: Text(docs[i].title),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => HelpPage(topic: t),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
