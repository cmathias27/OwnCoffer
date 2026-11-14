import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// A field of [showEntryDialog].
sealed class EntryField {
  final String key;
  final String label;
  final bool optional;
  const EntryField(this.key, this.label, {this.optional = false});
}

class TextEntry extends EntryField {
  final String? initial;
  final int maxLength;
  const TextEntry(
    super.key,
    super.label, {
    this.initial,
    super.optional,
    this.maxLength = 80,
  });
}

/// An amount typed in euros, returned in cents.
class AmountEntry extends EntryField {
  final int? initial;
  final bool allowNegative;

  /// Shown after the figure: `€`, or `%` for a rate in hundredths.
  final String suffix;
  const AmountEntry(
    super.key,
    super.label, {
    this.initial,
    super.optional,
    this.allowNegative = false,
    this.suffix = '€',
  });
}

/// A calendar date, returned at UTC midnight.
class DateEntry extends EntryField {
  final DateTime? initial;
  const DateEntry(super.key, super.label, {this.initial, super.optional});
}

class IntEntry extends EntryField {
  final int? initial;
  final int min;
  final int max;
  const IntEntry(
    super.key,
    super.label, {
    this.initial,
    super.optional,
    this.min = 0,
    this.max = 1 << 30,
  });
}

class ChoiceEntry<T> extends EntryField {
  final T? initial;
  final List<(T, String)> options;
  const ChoiceEntry(
    super.key,
    super.label, {
    required this.options,
    this.initial,
    super.optional,
  });
}

class CheckEntry extends EntryField {
  final bool initial;
  const CheckEntry(super.key, super.label, {this.initial = false});
}

/// Several boxes to tick among [options]; at least one unless optional.
class MultiEntry<T> extends EntryField {
  final List<(T, String)> options;
  final Set<T> initial;
  const MultiEntry(
    super.key,
    super.label, {
    required this.options,
    this.initial = const {},
    super.optional,
  });
}

/// A form in a dialog: returns the values by key (cents for amounts, UTC
/// midnight for dates), or null when cancelled. [onSave] runs the server
/// call: its error stays in the dialog.
Future<Map<String, Object?>?> showEntryDialog(
  BuildContext context, {
  required String title,
  required List<EntryField> fields,
  String? intro,
  Future<void> Function(Map<String, Object?> values)? onSave,
}) => showDialog<Map<String, Object?>>(
  context: context,
  builder: (_) =>
      _EntryDialog(title: title, intro: intro, fields: fields, onSave: onSave),
);

class _EntryDialog extends StatefulWidget {
  final String title;
  final String? intro;
  final List<EntryField> fields;
  final Future<void> Function(Map<String, Object?> values)? onSave;
  const _EntryDialog({
    required this.title,
    required this.intro,
    required this.fields,
    required this.onSave,
  });

  @override
  State<_EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<_EntryDialog> {
  final _text = <String, TextEditingController>{};
  final _values = <String, Object?>{};
  String? _error;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      switch (f) {
        case TextEntry(:final initial):
          _text[f.key] = TextEditingController(text: initial ?? '');
        case AmountEntry(:final initial):
          _text[f.key] = TextEditingController(
            text: initial == null ? '' : _plain(initial),
          );
        case IntEntry(:final initial):
          _text[f.key] = TextEditingController(text: initial?.toString());
        case DateEntry(:final initial):
          _values[f.key] = initial;
        case ChoiceEntry(:final initial):
          _values[f.key] = initial;
        case CheckEntry(:final initial):
          _values[f.key] = initial;
        case MultiEntry(:final initial):
          _values[f.key] = {...initial};
      }
    }
  }

  /// Cents as typed back: `1234,56`, no thousands separator.
  static String _plain(int cents) {
    final sign = cents < 0 ? '-' : '';
    final a = cents.abs();
    return '$sign${a ~/ 100},${(a % 100).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// The values, or null with [_error] set.
  Map<String, Object?>? _read(AppLocalizations l) {
    final out = <String, Object?>{};
    for (final f in widget.fields) {
      final raw = _text[f.key]?.text.trim() ?? '';
      switch (f) {
        case TextEntry():
          if (raw.isEmpty && !f.optional) return _fail(l, f);
          out[f.key] = raw.isEmpty ? null : raw;
        case AmountEntry(:final allowNegative):
          if (raw.isEmpty) {
            if (!f.optional) return _fail(l, f);
            out[f.key] = null;
            continue;
          }
          final cents = parseUserAmount(raw);
          if (cents == null || (!allowNegative && cents < 0)) {
            return _fail(l, f);
          }
          out[f.key] = cents;
        case IntEntry(:final min, :final max):
          if (raw.isEmpty) {
            if (!f.optional) return _fail(l, f);
            out[f.key] = null;
            continue;
          }
          final n = int.tryParse(raw);
          if (n == null || n < min || n > max) return _fail(l, f);
          out[f.key] = n;
        case DateEntry():
        case ChoiceEntry():
          if (_values[f.key] == null && !f.optional) return _fail(l, f);
          out[f.key] = _values[f.key];
        case CheckEntry():
          out[f.key] = _values[f.key];
        case MultiEntry():
          final set = _values[f.key]! as Set;
          if (set.isEmpty && !f.optional) return _fail(l, f);
          out[f.key] = set;
      }
    }
    return out;
  }

  Map<String, Object?>? _fail(AppLocalizations l, EntryField f) {
    setState(() => _error = l.entryInvalid(f.label));
    return null;
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final values = _read(l);
    if (values == null) return;
    final save = widget.onSave;
    if (save != null) {
      setState(() {
        _busy = true;
        _error = null;
      });
      try {
        await save(values);
      } on Object catch (e) {
        if (mounted) {
          setState(() {
            _busy = false;
            _error = errorText(l, e);
          });
        }
        return;
      }
    }
    if (mounted) Navigator.of(context).pop(values);
  }

  Widget _field(BuildContext context, EntryField f) {
    final l = AppLocalizations.of(context);
    final label = f.optional ? l.entryOptional(f.label) : f.label;
    switch (f) {
      case TextEntry(:final maxLength):
        return TextField(
          controller: _text[f.key],
          maxLength: maxLength,
          decoration: InputDecoration(labelText: label),
        );
      case AmountEntry(:final allowNegative, :final suffix):
        return TextField(
          controller: _text[f.key],
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
            signed: allowNegative,
          ),
          decoration: InputDecoration(labelText: label, suffixText: suffix),
        );
      case IntEntry():
        return TextField(
          controller: _text[f.key],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label),
        );
      case DateEntry():
        final value = _values[f.key] as DateTime?;
        return InputDecorator(
          decoration: InputDecoration(labelText: label),
          child: Row(
            children: [
              Expanded(
                child: Text(value == null ? '—' : context.day(value)),
              ),
              IconButton(
                tooltip: l.entryPickDate,
                icon: const Icon(Icons.event_outlined),
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: value ?? now,
                    firstDate: DateTime(1990),
                    lastDate: DateTime(now.year + 50),
                  );
                  if (picked != null) {
                    setState(
                      () => _values[f.key] = DateTime.utc(
                        picked.year,
                        picked.month,
                        picked.day,
                      ),
                    );
                  }
                },
              ),
              if (f.optional && value != null)
                IconButton(
                  tooltip: l.entryClear,
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _values[f.key] = null),
                ),
            ],
          ),
        );
      case ChoiceEntry():
        return _choice(f, label);
      case CheckEntry():
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _values[f.key]! as bool,
          title: Text(f.label),
          onChanged: (v) => setState(() => _values[f.key] = v ?? false),
        );
      case MultiEntry():
        return _multi(f, label);
    }
  }

  Widget _choice<T>(ChoiceEntry<T> f, String label) =>
      DropdownButtonFormField<T?>(
        initialValue: _values[f.key] as T?,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          if (f.optional) const DropdownMenuItem(value: null, child: Text('—')),
          for (final (value, text) in f.options)
            DropdownMenuItem(
              value: value,
              child: Text(text, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: (v) => setState(() => _values[f.key] = v),
      );

  Widget _multi<T>(MultiEntry<T> f, String label) {
    final set = _values[f.key]! as Set;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
        for (final (value, text) in f.options)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: set.contains(value),
            title: Text(text),
            onChanged: (v) => setState(() {
              if (v ?? false) {
                set.add(value);
              } else {
                set.remove(value);
              }
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.intro != null) ...[
                Text(widget.intro!),
                const SizedBox(height: 8),
              ],
              for (final f in widget.fields) ...[
                _field(context, f),
                const SizedBox(height: 8),
              ],
              if (_error != null)
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: Text(l.save),
        ),
      ],
    );
  }
}

/// Runs [action] and shows its error, if any, in a snack bar. True when
/// it went through.
Future<bool> runShowingError(
  BuildContext context,
  Future<void> Function() action,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final l = AppLocalizations.of(context);
  try {
    await action();
    return true;
  } on Object catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return false;
  }
}

/// Asks before removing [name].
Future<bool> confirmRemove(BuildContext context, String name) async {
  final l = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.entryRemoveTitle),
      content: Text(l.entryRemoveText(name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l.entryRemove),
        ),
      ],
    ),
  );
  return ok ?? false;
}
