import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// Category choice with a search box: a group has about 90 categories, too
/// many for a plain drop-down. Opens a dialog listing `Parent › Child`
/// names, filtered as the user types (accents and case ignored).
class CategoryFormField extends FormField<int?> {
  CategoryFormField({
    super.key,
    required List<Category> categories,
    super.initialValue,
    required String label,
    String? helperText,
    String? noneLabel,
    ValueChanged<int?>? onChanged,
    CategoryCreator? onCreate,
    super.validator,
  }) : super(
         enabled: onChanged != null,
         builder: (state) {
           final context = state.context;
           final byId = {for (final c in categories) c.id!: c};
           final selected = byId[state.value];
           return InkWell(
             onTap: onChanged == null
                 ? null
                 : () async {
                     final picked = await showCategoryPicker(
                       context,
                       categories: categories,
                       selected: state.value,
                       noneLabel: noneLabel,
                       onCreate: onCreate,
                     );
                     if (picked == null) return;
                     state.didChange(picked.id);
                     onChanged(picked.id);
                   },
             child: InputDecorator(
               isEmpty: false,
               decoration: InputDecoration(
                 labelText: label,
                 helperText: helperText,
                 errorText: state.errorText,
                 enabled: onChanged != null,
                 suffixIcon: const Icon(Icons.arrow_drop_down),
               ),
               child: Text(
                 selected == null
                     ? (noneLabel ?? '')
                     : categoryPath(context, selected, byId),
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
               ),
             ),
           );
         },
       );
}

/// `Parent › Child`, or the name alone for a top-level category.
String categoryPath(
  BuildContext context,
  Category c,
  Map<int, Category> byId,
) {
  final parent = c.parentId == null ? null : byId[c.parentId];
  return parent == null
      ? context.categoryName(c)
      : '${context.categoryName(parent)} › ${context.categoryName(c)}';
}

/// The user's choice; [id] is null for "no category".
typedef CategoryChoice = ({int? id});

/// Creates a category named after the search text; null if cancelled.
typedef CategoryCreator =
    Future<Category?> Function(BuildContext context, String name);

/// Returns null when the dialog is dismissed without a choice.
Future<CategoryChoice?> showCategoryPicker(
  BuildContext context, {
  required List<Category> categories,
  int? selected,
  String? noneLabel,
  CategoryCreator? onCreate,
}) => showDialog<CategoryChoice>(
  context: context,
  builder: (_) => _PickerDialog(
    categories: categories,
    selected: selected,
    noneLabel: noneLabel,
    onCreate: onCreate,
  ),
);

class _PickerDialog extends StatefulWidget {
  final List<Category> categories;
  final int? selected;
  final String? noneLabel;
  final CategoryCreator? onCreate;

  const _PickerDialog({
    required this.categories,
    required this.selected,
    required this.noneLabel,
    required this.onCreate,
  });

  @override
  State<_PickerDialog> createState() => _PickerDialogState();
}

class _PickerDialogState extends State<_PickerDialog> {
  var _query = '';
  late final List<(Category, String, String)> _entries;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final byId = {for (final c in widget.categories) c.id!: c};
    _entries = [
      for (final c in widget.categories)
        (
          c,
          categoryPath(context, c, byId),
          _fold(categoryPath(context, c, byId)),
        ),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
  }

  static String _fold(String s) => core.normalizeForMatch(s.toUpperCase());

  List<(Category, String, String)> _matches() {
    final words = _fold(_query).split(' ').where((w) => w.isNotEmpty).toList();
    return [
      for (final e in _entries)
        if (words.every(e.$3.contains)) e,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final searching = _query.trim().isNotEmpty;
    final shown = _matches();
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l.categorySearchHint,
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _query = v),
                onSubmitted: (_) {
                  final matches = _matches();
                  if (matches.length == 1) {
                    Navigator.of(context).pop((id: matches.single.$1.id));
                  }
                },
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (widget.noneLabel != null && !searching)
                    ListTile(
                      dense: true,
                      title: Text(widget.noneLabel!),
                      selected: widget.selected == null,
                      onTap: () => Navigator.of(context).pop((id: null)),
                    ),
                  for (final (c, path, _) in shown)
                    ListTile(
                      dense: true,
                      title: Text(path),
                      selected: c.id == widget.selected,
                      onTap: () => Navigator.of(context).pop((id: c.id)),
                    ),
                  if (widget.onCreate != null)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.add),
                      title: Text(
                        searching
                            ? l.categoryCreateNamed(_query.trim())
                            : l.categoryAdd,
                      ),
                      onTap: () async {
                        final created = await widget.onCreate!(
                          context,
                          _query.trim(),
                        );
                        if (created != null && context.mounted) {
                          Navigator.of(context).pop((id: created.id));
                        }
                      },
                    ),
                  if (shown.isEmpty && widget.onCreate == null)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l.categorySearchEmpty,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l.cancel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String categoryKindText(AppLocalizations l, CategoryKind k) => switch (k) {
  CategoryKind.income => l.kindIncome,
  CategoryKind.expense => l.kindExpense,
  CategoryKind.savings => l.kindSavings,
  CategoryKind.transfer => l.kindTransfer,
};

/// Quick creation of a category while classifying an operation: name, type
/// (from the operation's direction) and optional parent. Returns the saved
/// category, or null if cancelled.
Future<Category?> showNewCategoryDialog(
  BuildContext context, {
  required int groupId,
  required String name,
  required CategoryKind kind,
  required List<Category> categories,
}) => showDialog<Category>(
  context: context,
  builder: (_) => _NewCategoryDialog(
    groupId: groupId,
    name: name,
    kind: kind,
    categories: categories,
  ),
);

class _NewCategoryDialog extends StatefulWidget {
  final int groupId;
  final String name;
  final CategoryKind kind;
  final List<Category> categories;

  const _NewCategoryDialog({
    required this.groupId,
    required this.name,
    required this.kind,
    required this.categories,
  });

  @override
  State<_NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<_NewCategoryDialog> {
  late final _name = TextEditingController(text: widget.name);
  late var _kind = widget.kind;
  int? _parent;
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => (_busy = true, _error = null));
    try {
      final c = await client.category.create(
        widget.groupId,
        _name.text,
        _kind,
        parentId: _parent,
      );
      if (mounted) Navigator.of(context).pop(c);
    } on Object catch (e) {
      if (!mounted) return;
      setState(
        () => (
          _busy = false,
          _error = errorText(AppLocalizations.of(context), e),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Two levels; a parent of the same type keeps income and expense
    // totals consistent.
    final parents =
        [
          for (final c in widget.categories)
            if (c.parentId == null && c.kind == _kind) c,
        ]..sort(
          (a, b) => context.categoryName(a).compareTo(context.categoryName(b)),
        );
    return AlertDialog(
      title: Text(l.categoryAdd),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _name,
                autofocus: true,
                maxLength: 80,
                decoration: InputDecoration(labelText: l.categoryName),
                onSubmitted: (_) => _save(),
              ),
              DropdownButtonFormField<CategoryKind>(
                initialValue: _kind,
                decoration: InputDecoration(labelText: l.categoryKindLabel),
                items: [
                  for (final k in CategoryKind.values)
                    DropdownMenuItem(
                      value: k,
                      child: Text(categoryKindText(l, k)),
                    ),
                ],
                onChanged: (v) => setState(() => (_kind = v!, _parent = null)),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                key: ValueKey(_kind),
                initialValue: _parent,
                isExpanded: true,
                decoration: InputDecoration(labelText: l.categoryParent),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l.categoryNoParent),
                  ),
                  for (final p in parents)
                    DropdownMenuItem(
                      value: p.id,
                      child: Text(context.categoryName(p)),
                    ),
                ],
                onChanged: (v) => _parent = v,
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
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
