import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';

/// Administration > AI: the providers the users may choose (décision
/// 0017). Keys are written once and never shown again.
class AdminAiView extends StatefulWidget {
  const AdminAiView({super.key});

  @override
  State<AdminAiView> createState() => _AdminAiViewState();
}

class _AdminAiViewState extends State<AdminAiView> {
  List<AiProvider>? _providers;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final s = await client.ai.status();
      if (mounted) setState(() => (_providers = s.providers, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _edit([AiProvider? p]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ProviderDialog(provider: p),
    );
    if (saved == true) await _load();
  }

  Future<void> _test(AiProvider p) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final models = await client.ai.testProvider(p.id!);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l.adminAiTestOk(
              models.length,
              models.take(8).join(', '),
            ),
          ),
        ),
      );
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
  }

  Future<void> _delete(AiProvider p) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.adminAiDeleteTitle(p.name)),
        content: Text(l.adminAiDeleteHelp),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.adminAiDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await client.ai.deleteProvider(p.id!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final list = _providers;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.adminAiIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l.adminAiAdd),
            onPressed: _edit,
          ),
        ),
        const SizedBox(height: 12),
        if (_error != null)
          Text(_error!)
        else if (list == null)
          const Center(child: CircularProgressIndicator())
        else if (list.isEmpty)
          Text(l.adminAiNone)
        else
          for (final p in list)
            Card(
              child: ListTile(
                leading: Icon(
                  p.kind == 'ollama'
                      ? Icons.dns_outlined
                      : Icons.cloud_outlined,
                ),
                title: Text(p.name),
                subtitle: Text(
                  [
                    p.baseUrl,
                    p.models,
                    if (p.hasKey == true) l.adminAiKeySet,
                    if (!p.enabled) l.adminAiDisabled,
                    if (p.monthlyCap > 0) l.adminAiCapValue(p.monthlyCap),
                  ].join(' · '),
                ),
                onTap: () => _edit(p),
                trailing: Wrap(
                  children: [
                    IconButton(
                      tooltip: l.adminAiTest,
                      icon: const Icon(Icons.network_check),
                      onPressed: () => _test(p),
                    ),
                    IconButton(
                      tooltip: l.adminAiDelete,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(p),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _ProviderDialog extends StatefulWidget {
  final AiProvider? provider;
  const _ProviderDialog({this.provider});

  @override
  State<_ProviderDialog> createState() => _ProviderDialogState();
}

class _ProviderDialogState extends State<_ProviderDialog> {
  late final p = widget.provider;
  late var _kind = p?.kind ?? 'ollama';
  late final _name = TextEditingController(text: p?.name ?? 'Ollama');
  late final _url = TextEditingController(
    text: p?.baseUrl ?? 'http://192.168.1.10:11434/v1',
  );
  final _key = TextEditingController();
  late final _models = TextEditingController(text: p?.models ?? '');
  late final _cap = TextEditingController(text: '${p?.monthlyCap ?? 0}');
  late var _tools = p?.toolCalling ?? true;
  late var _vision = p?.vision ?? false;
  late var _enabled = p?.enabled ?? true;
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _url, _key, _models, _cap]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    setState(() => (_busy = true, _error = null));
    try {
      await client.ai.saveProvider(
        AiProvider(
          id: p?.id,
          name: _name.text,
          kind: _kind,
          baseUrl: _url.text,
          models: _models.text,
          toolCalling: _tools,
          vision: _vision,
          monthlyCap: int.tryParse(_cap.text.trim()) ?? 0,
          enabled: _enabled,
        ),
        // Null keeps the key already set.
        _key.text.isEmpty && p != null ? null : _key.text,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (e) {
      if (mounted) setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const gap = SizedBox(height: 12);
    return AlertDialog(
      title: Text(p == null ? l.adminAiAdd : l.adminAiEdit),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'ollama', label: Text(l.adminAiLocal)),
                  ButtonSegment(
                    value: 'openai',
                    label: Text(l.adminAiExternal),
                  ),
                ],
                selected: {_kind},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _kind = s.single),
              ),
              const SizedBox(height: 6),
              Text(
                _kind == 'ollama' ? l.adminAiLocalHelp : l.adminAiExternalHelp,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              gap,
              TextField(
                controller: _name,
                decoration: InputDecoration(labelText: l.adminAiName),
              ),
              gap,
              TextField(
                controller: _url,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(labelText: l.adminAiUrl),
              ),
              gap,
              TextField(
                controller: _key,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l.adminAiKey,
                  helperText: p?.hasKey == true
                      ? l.adminAiKeyKeep
                      : l.adminAiKeyHelp,
                  helperMaxLines: 2,
                ),
              ),
              gap,
              TextField(
                controller: _models,
                decoration: InputDecoration(
                  labelText: l.adminAiModels,
                  helperText: l.adminAiModelsHelp,
                  helperMaxLines: 2,
                ),
              ),
              gap,
              TextField(
                controller: _cap,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l.adminAiCap,
                  helperText: l.adminAiCapHelp,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.adminAiTools),
                subtitle: Text(l.adminAiToolsHelp),
                value: _tools,
                onChanged: (v) => setState(() => _tools = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.adminAiVision),
                subtitle: Text(l.adminAiVisionHelp),
                value: _vision,
                onChanged: (v) => setState(() => _vision = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.adminAiEnabled),
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _busy ? null : _save, child: Text(l.save)),
      ],
    );
  }
}
