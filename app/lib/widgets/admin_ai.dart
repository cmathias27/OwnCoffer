import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import 'ai_usage.dart';

/// Administration > AI: the providers the users may choose (décision
/// 0017). Keys are written once and never shown again.
class AdminAiView extends StatefulWidget {
  const AdminAiView({super.key});

  @override
  State<AdminAiView> createState() => _AdminAiViewState();
}

class _AdminAiViewState extends State<AdminAiView> {
  List<AiProvider>? _providers;
  int? _autonomyLevel;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final s = await client.ai.status();
      if (mounted) {
        setState(() {
          _providers = s.providers;
          _autonomyLevel = s.autonomyLevel;
          _error = null;
        });
      }
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _setAutonomy(int? level) async {
    if (level == null || level == _autonomyLevel) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final saved = await client.ai.setAutonomyLevel(level);
      if (mounted) {
        setState(() => _autonomyLevel = saved);
        messenger.showSnackBar(
          SnackBar(content: Text(l.adminAiAutonomySaved)),
        );
      }
    } on Object catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
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
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_outlined),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l.adminAiAutonomyTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(l.adminAiAutonomyHelp, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  isExpanded: true,
                  initialValue: _autonomyLevel ?? 3,
                  decoration: InputDecoration(
                    labelText: l.adminAiAutonomyTitle,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text(l.adminAiAutonomyLevel1Title),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(l.adminAiAutonomyLevel2Title),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text(l.adminAiAutonomyLevel3Title),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: Text(l.adminAiAutonomyLevel4Title),
                    ),
                    DropdownMenuItem(
                      value: 5,
                      child: Text(l.adminAiAutonomyLevel5Title),
                    ),
                  ],
                  onChanged: _setAutonomy,
                ),
                const SizedBox(height: 8),
                Text(
                  switch (_autonomyLevel ?? 3) {
                    1 => l.adminAiAutonomyLevel1Desc,
                    2 => l.adminAiAutonomyLevel2Desc,
                    3 => l.adminAiAutonomyLevel3Desc,
                    4 => l.adminAiAutonomyLevel4Desc,
                    5 => l.adminAiAutonomyLevel5Desc,
                    _ => '',
                  },
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
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
                    if (p.inputPricePerMillion != null &&
                        p.outputPricePerMillion != null)
                      l.adminAiPricesValue(
                        core.formatAiPrice(
                          p.inputPricePerMillion!,
                          decimal: l.localeName == 'fr' ? ',' : '.',
                        ),
                        core.formatAiPrice(
                          p.outputPricePerMillion!,
                          decimal: l.localeName == 'fr' ? ',' : '.',
                        ),
                      ),
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
        const SizedBox(height: 16),
        const AiUsageSection(server: true),
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

/// Ready-made set-ups: for the big providers, only the key is left to type
/// (the list of models is asked to the provider when left empty).
enum _Preset {
  ollama('ollama', 'Ollama', 'http://192.168.1.10:11434/v1', '', false),
  gemini(
    'openai',
    'Gemini',
    'https://generativelanguage.googleapis.com/v1beta/openai/',
    '',
    true,
  ),
  chatgpt('openai', 'ChatGPT', 'https://api.openai.com/v1', '', true),
  claude(
    'anthropic',
    'Claude',
    'https://api.anthropic.com/v1',
    'claude-opus-5-5,claude-sonnet-5-5,claude-haiku-5-5',
    true,
  ),
  other('openai', '', 'https://', '', false);

  final String kind;
  final String name;
  final String url;
  final String models;
  final bool vision;
  const _Preset(this.kind, this.name, this.url, this.models, this.vision);

  static _Preset of(AiProvider? p) {
    if (p == null) return _Preset.ollama;
    for (final x in values) {
      if (x != other &&
          x.kind == p.kind &&
          (x == ollama || x.url == p.baseUrl)) {
        return x;
      }
    }
    return p.kind == 'ollama' ? ollama : other;
  }
}

class _ProviderDialogState extends State<_ProviderDialog> {
  late final p = widget.provider;
  late var _preset = _Preset.of(p);
  late var _kind = p?.kind ?? 'ollama';
  late final _name = TextEditingController(text: p?.name ?? 'Ollama');
  late final _url = TextEditingController(
    text: p?.baseUrl ?? 'http://192.168.1.10:11434/v1',
  );
  final _key = TextEditingController();
  late final _models = TextEditingController(text: p?.models ?? '');
  late final _cap = TextEditingController(text: '${p?.monthlyCap ?? 0}');
  late final _inputPrice = TextEditingController(
    text: _price(p?.inputPricePerMillion),
  );
  late final _outputPrice = TextEditingController(
    text: _price(p?.outputPricePerMillion),
  );
  late var _tools = p?.toolCalling ?? true;
  late var _vision = p?.vision ?? false;
  late var _enabled = p?.enabled ?? true;
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    for (final c in [
      _name,
      _url,
      _key,
      _models,
      _cap,
      _inputPrice,
      _outputPrice,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String _price(int? price) => price == null
      ? ''
      : core.formatAiPrice(
          price,
          decimal: Localizations.localeOf(context).languageCode == 'fr'
              ? ','
              : '.',
        );

  /// A price field: empty is no price; otherwise it must be readable.
  (bool, int?) _readPrice(TextEditingController c) {
    final t = c.text.trim();
    if (t.isEmpty) return (true, null);
    final v = core.parseAiPrice(t);
    return (v != null, v);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final (inOk, inputPrice) = _readPrice(_inputPrice);
    final (outOk, outputPrice) = _readPrice(_outputPrice);
    if (!inOk || !outOk) {
      setState(() => _error = l.adminAiPriceInvalid);
      return;
    }
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
          inputPricePerMillion: inputPrice,
          outputPricePerMillion: outputPrice,
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
              DropdownButtonFormField<_Preset>(
                isExpanded: true,
                initialValue: _preset,
                decoration: InputDecoration(labelText: l.adminAiPreset),
                items: [
                  for (final x in _Preset.values)
                    DropdownMenuItem(
                      value: x,
                      child: Text(switch (x) {
                        _Preset.ollama => l.adminAiLocal,
                        _Preset.gemini => 'Google Gemini',
                        _Preset.chatgpt => 'OpenAI ChatGPT',
                        _Preset.claude => 'Anthropic Claude',
                        _Preset.other => l.adminAiExternal,
                      }),
                    ),
                ],
                onChanged: (x) {
                  if (x == null) return;
                  setState(() {
                    _preset = x;
                    _kind = x.kind;
                    if (x != _Preset.other) {
                      _name.text = x.name;
                      _url.text = x.url;
                      _models.text = x.models;
                      _vision = x.vision;
                      _tools = true;
                    }
                  });
                },
              ),
              const SizedBox(height: 6),
              Text(
                switch (_preset) {
                  _Preset.ollama => l.adminAiLocalHelp,
                  _Preset.gemini => l.adminAiGeminiHelp,
                  _Preset.chatgpt => l.adminAiChatGptHelp,
                  _Preset.claude => l.adminAiClaudeHelp,
                  _Preset.other => l.adminAiExternalHelp,
                },
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (_preset != _Preset.ollama) ...[
                const SizedBox(height: 4),
                Text(
                  l.adminAiSentOutside,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
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
              gap,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      key: const ValueKey('inputPrice'),
                      controller: _inputPrice,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l.adminAiInputPrice,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      key: const ValueKey('outputPrice'),
                      controller: _outputPrice,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l.adminAiOutputPrice,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l.adminAiPriceHelp,
                  style: Theme.of(context).textTheme.bodySmall,
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
