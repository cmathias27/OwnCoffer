import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import 'soft.dart';

/// "Use OwnCoffer from another assistant" (MCP, décision 0018): the user's
/// personal tokens, the address to give the assistant, and revocation.
class McpTokensSection extends StatefulWidget {
  final GroupMembership membership;
  const McpTokensSection({super.key, required this.membership});

  @override
  State<McpTokensSection> createState() => _McpTokensSectionState();
}

class _McpTokensSectionState extends State<McpTokensSection> {
  List<McpToken>? _tokens;

  static String get _url => Uri.base.resolve('/mcp').toString();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final t = await client.mcp.tokens();
      if (mounted) setState(() => _tokens = t);
    } on Object {
      if (mounted) setState(() => _tokens = const []);
    }
  }

  Future<void> _create() async {
    final l = AppLocalizations.of(context);
    final name = TextEditingController(text: 'Claude Desktop');
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.mcpCreate),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.mcpCreateHelp),
              const SizedBox(height: 12),
              TextField(
                controller: name,
                decoration: InputDecoration(labelText: l.mcpName),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.mcpCreate),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      final created = await client.mcp.create(
        widget.membership.group.id!,
        name.text,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.mcpCreated),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.mcpCreatedHelp),
                const SizedBox(height: 12),
                Text(
                  l.mcpAddress,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SelectableText(_url),
                const SizedBox(height: 8),
                Text(
                  l.mcpSecret,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SelectableText(created.secret),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: Text(l.mcpCopy),
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: created.secret)),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.mcpDone),
            ),
          ],
        ),
      );
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
      }
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = [
      for (final t in _tokens ?? const <McpToken>[])
        if (t.revokedAt == null) t,
    ];
    return SoftSection(
      icon: Icons.hub_outlined,
      title: l.mcpTitle,
      children: [
        Text(l.mcpIntro, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final t in tokens)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.key_outlined),
            title: Text(t.name),
            subtitle: Text(
              t.lastUsedAt == null
                  ? l.mcpNeverUsed('${t.prefix}…')
                  : l.mcpLastUsed('${t.prefix}…', context.day(t.lastUsedAt!)),
            ),
            trailing: TextButton(
              onPressed: () async {
                await client.mcp.revoke(t.id!);
                await _load();
              },
              child: Text(l.mcpRevoke),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l.mcpCreate),
            onPressed: _create,
          ),
        ),
      ],
    );
  }
}
