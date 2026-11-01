import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import 'soft.dart';

/// What the user asks the assistant to keep in mind: written by them only,
/// sent with each question, seen by nobody else.
class AiMemoriesSection extends StatefulWidget {
  final GroupMembership membership;
  const AiMemoriesSection({super.key, required this.membership});

  @override
  State<AiMemoriesSection> createState() => _AiMemoriesSectionState();
}

class _AiMemoriesSectionState extends State<AiMemoriesSection> {
  List<AiMemory>? _items;
  final _text = TextEditingController();
  String? _error;

  int get _groupId => widget.membership.group.id!;

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
      final items = await client.ai.memories(_groupId);
      if (mounted) setState(() => _items = items);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _add() async {
    final l = AppLocalizations.of(context);
    final text = _text.text.trim();
    if (text.isEmpty) return;
    try {
      await client.ai.addMemory(_groupId, text);
      _text.clear();
      setState(() => _error = null);
    } on Object catch (e) {
      setState(() => _error = errorText(l, e));
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = _items ?? const <AiMemory>[];
    return SoftSection(
      icon: Icons.psychology_outlined,
      title: l.aiMemoriesTitle,
      children: [
        Text(l.aiMemoriesHelp, style: Theme.of(context).textTheme.bodySmall),
        for (final m in items)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(Icons.push_pin_outlined, size: 18),
            title: Text(m.text),
            trailing: IconButton(
              tooltip: l.aiMemoriesDelete,
              icon: const Icon(Icons.close),
              onPressed: () async {
                await client.ai.deleteMemory(m.id!);
                await _load();
              },
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _text,
                maxLength: 300,
                decoration: InputDecoration(hintText: l.aiMemoriesHint),
                onSubmitted: (_) => _add(),
              ),
            ),
            IconButton(
              tooltip: l.aiMemoriesAdd,
              icon: const Icon(Icons.add),
              onPressed: _add,
            ),
          ],
        ),
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
