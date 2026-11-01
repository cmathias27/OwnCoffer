import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// A remark for the server administrator: a bug, an idea, a question. It
/// stays on the server; no bank data is joined.
class FeedbackScreen extends StatefulWidget {
  /// The page the user came from, to help understand the remark.
  final String? page;
  const FeedbackScreen({super.key, this.page});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  var _kind = 'idea';
  final _text = TextEditingController();
  List<UserFeedback>? _mine;
  String? _error;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final mine = await client.feedback.mine();
      if (mounted) setState(() => _mine = mine);
    } on Object {
      if (mounted) setState(() => _mine = const []);
    }
  }

  Future<void> _send() async {
    final l = AppLocalizations.of(context);
    if (_text.text.trim().isEmpty) return;
    setState(() => (_busy = true, _error = null));
    try {
      await client.feedback.send(_kind, _text.text, widget.page, null);
      _text.clear();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.feedbackSent)));
      }
      await _load();
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String kindText(AppLocalizations l, String kind) => switch (kind) {
    'bug' => l.feedbackBug,
    'question' => l.feedbackQuestion,
    _ => l.feedbackIdea,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.feedbackTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.feedbackIntro),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final k in ['bug', 'idea', 'question'])
                        ChoiceChip(
                          label: Text(kindText(l, k)),
                          selected: _kind == k,
                          onSelected: (_) => setState(() => _kind = k),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _text,
                    minLines: 4,
                    maxLines: 10,
                    maxLength: 2000,
                    decoration: InputDecoration(hintText: l.feedbackHint),
                  ),
                  Text(l.feedbackPrivacy, style: theme.textTheme.bodySmall),
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.send),
                      label: Text(l.feedbackSend),
                      onPressed: _busy ? null : _send,
                    ),
                  ),
                  if (_mine?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 16),
                    Text(l.feedbackMine, style: theme.textTheme.titleSmall),
                    for (final f in _mine!)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          f.status == 'done'
                              ? Icons.check_circle_outline
                              : Icons.schedule,
                        ),
                        title: Text(
                          f.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          [
                            kindText(l, f.kind),
                            context.day(f.createdAt.toLocal()),
                            f.status == 'done'
                                ? l.feedbackDone
                                : l.feedbackOpen,
                          ].join(' · '),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Administration: the remarks of the users, to read and close.
class AdminFeedbackView extends StatefulWidget {
  const AdminFeedbackView({super.key});

  @override
  State<AdminFeedbackView> createState() => _AdminFeedbackViewState();
}

class _AdminFeedbackViewState extends State<AdminFeedbackView> {
  List<FeedbackInfo>? _items;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await client.feedback.all();
      if (mounted) setState(() => (_items = items, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = _items;
    if (_error != null) return Center(child: Text(_error!));
    if (items == null) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.adminFeedbackHelp, style: Theme.of(context).textTheme.bodySmall),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l.adminFeedbackNone),
          ),
        for (final i in items)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: i.feedback.status == 'done',
            onChanged: (v) async {
              await client.feedback.setDone(i.feedback.id!, v ?? false);
              await _load();
            },
            title: Text(i.feedback.text),
            subtitle: Text(
              [
                _FeedbackScreenState.kindText(l, i.feedback.kind),
                i.email ?? l.adminSystem,
                context.day(i.feedback.createdAt.toLocal()),
                ?i.feedback.page,
                ?i.feedback.appVersion,
              ].join(' · '),
            ),
          ),
      ],
    );
  }
}
