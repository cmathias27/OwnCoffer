import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../assistant/chat_controller.dart';
import '../client.dart';
import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../widgets/ai_memories.dart';
import '../widgets/mcp_tokens.dart';
import '../widgets/soft.dart';

/// The assistant's settings (optional AI, décisions 0006 and 0008): the
/// user's choice of provider and model, on or off, and the tokens for
/// another assistant (MCP). The conversation itself is in the chat bubble,
/// at the bottom right of every page.
class AssistantScreen extends StatefulWidget {
  final GroupMembership membership;
  const AssistantScreen({super.key, required this.membership});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  AiStatus? _status;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
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
      await chat.refreshStatus();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = _status;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.assistantSettingsTitle),
        actions: const [HelpButton(HelpTopic.assistant)],
      ),
      body: _error != null
          ? Center(child: Text(_error!))
          : s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _settings(context, l, s),
                        ListenableBuilder(
                          listenable: chat,
                          builder: (context, _) => chat.available
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FilledButton.icon(
                                      icon: const Icon(
                                        Icons.chat_bubble_outline,
                                      ),
                                      label: Text(l.chatOpen),
                                      onPressed: () {
                                        chat.setOpen(true);
                                        Navigator.of(context).maybePop();
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        AiMemoriesSection(membership: widget.membership),
                        McpTokensSection(membership: widget.membership),
                      ],
                    ),
                  ),
                ),
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
}
