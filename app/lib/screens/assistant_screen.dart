import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/file_pick.dart';
import '../widgets/mcp_tokens.dart';
import '../widgets/soft.dart';
import 'advisor_screen.dart';

/// The assistant (optional AI, décisions 0006 and 0008): the user's choice
/// of provider and model, then a conversation in which the AI reads the
/// engine's figures and may only propose changes. What leaves the server
/// is said before anything is sent to an external model.
class AssistantScreen extends StatefulWidget {
  final GroupMembership membership;
  const AssistantScreen({super.key, required this.membership});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  AiStatus? _status;
  String? _error;
  final _input = TextEditingController();
  final List<(AiMessage, AiReply?)> _talk = [];
  PickedFile? _image;
  var _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final s = await client.ai.status();
      if (mounted) setState(() => (_status = s, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  AiProvider? get _provider {
    final s = _status;
    if (s == null) return null;
    return s.providers.where((p) => p.id == s.providerId).firstOrNull;
  }

  Future<void> _choose(int? providerId, String? model, bool enabled) async {
    final l = AppLocalizations.of(context);
    try {
      final s = await client.ai.setPreference(providerId, model, enabled);
      if (mounted) setState(() => _status = s);
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
      }
    }
  }

  Future<void> _send() async {
    final l = AppLocalizations.of(context);
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    final image = _image;
    final message = AiMessage(
      role: 'user',
      content: text,
      imageBase64: image == null ? null : base64Encode(image.bytes),
      imageMimeType: image == null
          ? null
          : image.name.toLowerCase().endsWith('.png')
          ? 'image/png'
          : 'image/jpeg',
    );
    final history = [
      for (final (m, r) in _talk) ...[
        m.copyWith(imageBase64: null),
        if (r != null) AiMessage(role: 'assistant', content: r.text),
      ],
    ];
    setState(() {
      _talk.add((message, null));
      _sending = true;
      _image = null;
      _input.clear();
    });
    try {
      final reply = await client.ai.chat(
        widget.membership.group.id!,
        history,
        message,
      );
      if (mounted) {
        setState(() => _talk[_talk.length - 1] = (message, reply));
      }
    } on Object catch (e) {
      if (mounted) {
        setState(() => _talk.removeLast());
        _input.text = text;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = _status;
    return Scaffold(
      appBar: AppBar(title: Text(l.assistantTitle)),
      body: _error != null
          ? Center(child: Text(_error!))
          : s == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _settings(context, l, s),
                              McpTokensSection(membership: widget.membership),
                              if (s.enabled && _provider != null)
                                for (final (m, r) in _talk)
                                  ..._exchange(context, l, m, r),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (s.enabled && _provider != null) _composer(context, l),
              ],
            ),
    );
  }

  Widget _settings(BuildContext context, AppLocalizations l, AiStatus s) {
    final theme = Theme.of(context);
    final p = _provider;
    if (s.providers.isEmpty) {
      return SoftSection(
        icon: Icons.auto_awesome_outlined,
        title: l.assistantNotSetUp,
        children: [
          Text(s.canConfigure ? l.assistantSetUpAdmin : l.assistantSetUpAsk),
          const SizedBox(height: 8),
        ],
      );
    }
    return SoftSection(
      icon: Icons.tune,
      title: l.assistantChoice,
      children: [
        Text(l.assistantIntro, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        DropdownButtonFormField<int?>(
          isExpanded: true,
          initialValue: p?.id,
          decoration: InputDecoration(labelText: l.assistantProvider),
          items: [
            for (final x in s.providers.where((x) => x.enabled))
              DropdownMenuItem(
                value: x.id,
                child: Text(
                  '${x.name} · ${x.kind == 'ollama' ? l.assistantLocal : l.assistantExternal}',
                ),
              ),
          ],
          onChanged: (id) {
            final x = s.providers.firstWhere((x) => x.id == id);
            final first = x.models.split(',').first.trim();
            _choose(id, first.isEmpty ? null : first, s.enabled);
          },
        ),
        if (p != null) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: p.models.split(',').contains(s.model)
                ? s.model
                : null,
            decoration: InputDecoration(labelText: l.assistantModel),
            items: [
              for (final m in p.models.split(','))
                if (m.trim().isNotEmpty)
                  DropdownMenuItem(value: m.trim(), child: Text(m.trim())),
            ],
            onChanged: (m) => _choose(p.id, m, s.enabled),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.assistantEnabled),
            subtitle: Text(
              p.monthlyCap > 0
                  ? l.assistantUsageCap(s.usedThisMonth, p.monthlyCap)
                  : l.assistantUsage(s.usedThisMonth),
            ),
            value: s.enabled,
            onChanged: s.model == null
                ? null
                : (v) => _choose(p.id, s.model, v),
          ),
          if (p.kind != 'ollama')
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 18,
                    color: theme.colorScheme.tertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.assistantExternalWarning(p.name),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  List<Widget> _exchange(
    BuildContext context,
    AppLocalizations l,
    AiMessage m,
    AiReply? r,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    Widget bubble(Widget child, {required bool mine}) => Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: mine ? scheme.primaryContainer : scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(22),
          ),
          child: child,
        ),
      ),
    );
    return [
      bubble(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (m.imageBase64 != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.image_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(l.assistantImageSent),
                  ],
                ),
              ),
            SelectableText(m.content),
          ],
        ),
        mine: true,
      ),
      bubble(
        r == null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(l.assistantThinking),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    r.text.isEmpty ? l.assistantNoAnswer : r.text,
                  ),
                  if (r.tools.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      l.assistantUsedTools(r.tools.toSet().join(', ')),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  if (r.isExternal)
                    Text(
                      l.assistantSentTo(r.provider, r.model),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.tertiary,
                      ),
                    ),
                  if (r.proposals.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    FilledButton.tonalIcon(
                      icon: const Icon(Icons.lightbulb_outline),
                      label: Text(l.assistantProposals(r.proposals.length)),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              AdvisorScreen(membership: widget.membership),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
        mine: false,
      ),
    ];
  }

  Widget _composer(BuildContext context, AppLocalizations l) {
    final vision = _provider?.vision ?? false;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                if (vision)
                  IconButton(
                    tooltip: _image == null
                        ? l.assistantAttach
                        : l.assistantImageReady(_image!.name),
                    icon: Icon(
                      _image == null
                          ? Icons.add_photo_alternate_outlined
                          : Icons.image,
                    ),
                    onPressed: () async {
                      final f = await pickFile(
                        extensions: const ['png', 'jpg', 'jpeg', 'webp'],
                      );
                      if (f != null && mounted) setState(() => _image = f);
                    },
                  ),
                Expanded(
                  child: TextField(
                    controller: _input,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: l.assistantHint,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                IconButton.filled(
                  tooltip: l.assistantSend,
                  icon: _sending
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  onPressed: _sending ? null : _send,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
