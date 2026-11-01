import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../screens/invoice_scan_screen.dart';
import '../util/file_pick.dart';
import '../util/file_save.dart';
import '../util/format.dart';
import 'admin_backups.dart';

/// Files accepted as invoices (checked again by the server).
const invoiceExtensions = ['.pdf', '.png', '.jpg', '.jpeg', '.webp'];

/// Asks for a file (or a photo with [camera]) and attaches it to the
/// operation. Returns the invoice, or null if cancelled or refused (the
/// reason is shown).
Future<InvoiceInfo?> attachInvoice(
  BuildContext context,
  int transactionId, {
  bool camera = false,
}) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final f = await _pick(context, camera);
    if (f == null) return null;
    final info = await client.invoice.upload(
      transactionId,
      f.name,
      ByteData.sublistView(f.bytes),
    );
    messenger.showSnackBar(SnackBar(content: Text(l.invoiceAdded(info.name))));
    return info;
  } on Object catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return null;
  }
}

/// An invoice whose operation is not there yet: file or photo, then what
/// is known of it (all optional), then the operations it could be.
/// Returns the saved invoice, or null if cancelled.
Future<InvoiceInfo?> addUnattachedInvoice(
  BuildContext context,
  int groupId, {
  bool camera = false,
}) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final f = await _pick(context, camera);
    if (f == null || !context.mounted) return null;
    final hints = await showDialog<InvoiceHints>(
      context: context,
      builder: (_) => const _HintsDialog(),
    );
    if (hints == null) return null;
    var info = await client.invoice.uploadUnattached(
      groupId,
      f.name,
      ByteData.sublistView(f.bytes),
      amountCents: hints.amountCents,
      date: hints.date,
      merchant: hints.merchant,
    );
    messenger.showSnackBar(SnackBar(content: Text(l.invoiceAdded(info.name))));
    if (context.mounted) {
      info = await chooseOperationFor(context, info, afterAdding: true) ?? info;
    }
    return info;
  } on Object catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return null;
  }
}

/// What is known of a waiting invoice: total paid, date, merchant.
typedef InvoiceHints = ({int? amountCents, DateTime? date, String? merchant});

/// Changes the hints of a waiting invoice; returns it, or null if
/// cancelled.
Future<InvoiceInfo?> editInvoiceHints(
  BuildContext context,
  InvoiceInfo info,
) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final i = info.invoice;
  final hints = await showDialog<InvoiceHints>(
    context: context,
    builder: (_) => _HintsDialog(
      initial: (
        amountCents: i.hintAmountCents,
        date: i.hintDate,
        merchant: i.hintMerchant,
      ),
    ),
  );
  if (hints == null) return null;
  try {
    return await client.invoice.setHints(
      i.id!,
      hints.amountCents,
      hints.date,
      hints.merchant,
    );
  } on Object catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return null;
  }
}

/// The operations a waiting invoice could be, to attach it to one (the
/// user chooses; nothing is attached alone). Returns the attached
/// invoice, or null if left waiting.
Future<InvoiceInfo?> chooseOperationFor(
  BuildContext context,
  InvoiceInfo info, {
  bool afterAdding = false,
}) => showDialog<InvoiceInfo>(
  context: context,
  builder: (_) => _ProposalsDialog(info: info, afterAdding: afterAdding),
);

/// Attaches a waiting invoice to an operation; returns it, or null.
Future<InvoiceInfo?> attachWaitingInvoice(
  BuildContext context,
  int invoiceId,
  int transactionId,
) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final info = await client.invoice.attach(invoiceId, transactionId);
    messenger.showSnackBar(
      SnackBar(content: Text(l.invoiceAttached(info.name))),
    );
    return info;
  } on Object catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return null;
  }
}

/// A file or a photo; a photo is then cropped to the invoice alone.
Future<PickedFile?> _pick(BuildContext context, bool camera) async {
  final f = await pickFile(extensions: invoiceExtensions, camera: camera);
  if (f == null || !isScannable(f.name) || !context.mounted) return f;
  return scanInvoicePhoto(context, f);
}

Future<void> openInvoice(BuildContext context, InvoiceInfo info) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final data = await client.invoice.download(info.invoice.id!);
    openOrSaveFile(
      info.name,
      info.invoice.mimeType,
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  } on Object catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
  }
}

/// What the invoice is for and the end of its warranty. Returns the saved
/// invoice, or null if cancelled.
Future<InvoiceInfo?> editInvoice(BuildContext context, InvoiceInfo info) =>
    showDialog<InvoiceInfo>(
      context: context,
      builder: (_) => _EditInvoiceDialog(info: info),
    );

/// Emails the invoice; returns true once sent.
Future<bool> sendInvoice(BuildContext context, InvoiceInfo info) async {
  final sent = await showDialog<bool>(
    context: context,
    builder: (_) => _SendInvoiceDialog(info: info),
  );
  if (sent == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).invoiceSent)),
    );
  }
  return sent == true;
}

/// Deletes the invoice after confirmation; returns true once deleted.
Future<bool> deleteInvoice(BuildContext context, InvoiceInfo info) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(l.invoiceDeleteConfirm(info.name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.invoiceDelete),
        ),
      ],
    ),
  );
  if (ok != true) return false;
  try {
    await client.invoice.delete(info.invoice.id!);
    return true;
  } on Object catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return false;
  }
}

/// Whether the warranty ends within a month (or is over).
bool warrantyEndingSoon(DateTime until, DateTime today) =>
    !until.isAfter(today.add(const Duration(days: 30)));

/// One invoice: its name, warranty and actions (open, edit, send, delete).
class InvoiceTile extends StatelessWidget {
  final InvoiceInfo info;
  final bool canWrite;

  /// After a change: the new invoice, or null once deleted.
  final void Function(InvoiceInfo? info) onChanged;

  /// Shows the operation (Invoices page); not inside the operation itself.
  final bool showOperation;

  const InvoiceTile({
    super.key,
    required this.info,
    required this.canWrite,
    required this.onChanged,
    this.showOperation = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final i = info.invoice;
    final until = i.warrantyUntil;
    final waiting = i.transactionId == null;
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final details = [
      if (showOperation && info.transactionDate != null)
        [
          context.day(info.transactionDate!),
          ?info.accountName,
          if (info.amountCents != null)
            context.money(
              info.amountCents!,
              currency: info.currency ?? 'EUR',
            ),
        ].join(' · '),
      if (showOperation && waiting) l.invoiceUnattached,
      AdminBackupsView.bytes(context, i.sizeBytes),
    ];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        i.mimeType == 'application/pdf'
            ? Icons.picture_as_pdf_outlined
            : Icons.image_outlined,
      ),
      title: Text(info.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(details.join('\n')),
          if (until != null)
            Text(
              until.isBefore(today)
                  ? l.invoiceWarrantyOver(context.day(until))
                  : l.invoiceWarrantyUntil(context.day(until)),
              style: TextStyle(
                color: until.isBefore(today)
                    ? theme.disabledColor
                    : warrantyEndingSoon(until, today)
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
            ),
        ],
      ),
      onTap: () => openInvoice(context, info),
      trailing: PopupMenuButton<String>(
        tooltip: l.invoiceActions,
        onSelected: (action) async {
          switch (action) {
            case 'open':
              await openInvoice(context, info);
            case 'attach':
              final attached = await chooseOperationFor(context, info);
              if (attached != null) onChanged(attached);
            case 'hints':
              final saved = await editInvoiceHints(context, info);
              if (saved != null) onChanged(saved);
            case 'edit':
              final saved = await editInvoice(context, info);
              if (saved != null) onChanged(saved);
            case 'send':
              await sendInvoice(context, info);
            case 'delete':
              if (await deleteInvoice(context, info)) onChanged(null);
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(value: 'open', child: Text(l.invoiceOpen)),
          if (canWrite && waiting)
            PopupMenuItem(value: 'attach', child: Text(l.invoiceAttachTo)),
          if (canWrite && waiting)
            PopupMenuItem(value: 'hints', child: Text(l.invoiceHints)),
          if (canWrite)
            PopupMenuItem(value: 'edit', child: Text(l.invoiceEdit)),
          PopupMenuItem(value: 'send', child: Text(l.invoiceSend)),
          if (canWrite)
            PopupMenuItem(value: 'delete', child: Text(l.invoiceDelete)),
        ],
      ),
    );
  }
}

/// Invoices of an operation, inside its details: list and "attach".
class InvoiceSection extends StatefulWidget {
  final int transactionId;
  final bool canWrite;

  /// Whether the operation has invoices, after a change (list mark).
  final ValueChanged<bool> onHasInvoices;

  const InvoiceSection({
    super.key,
    required this.transactionId,
    required this.canWrite,
    required this.onHasInvoices,
  });

  @override
  State<InvoiceSection> createState() => _InvoiceSectionState();
}

class _InvoiceSectionState extends State<InvoiceSection> {
  List<InvoiceInfo>? _items;

  /// Waiting invoices that could be this operation's.
  List<InvoiceMatch> _waiting = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await client.invoice.forTransaction(widget.transactionId);
      if (mounted) setState(() => _items = items);
    } on Object {
      if (mounted) setState(() => _items = const []);
    }
    if (!widget.canWrite) return;
    try {
      final waiting = await client.invoice.candidatesFor(widget.transactionId);
      if (mounted) setState(() => _waiting = waiting);
    } on Object {
      // Proposals are a help; the section works without them.
    }
  }

  Future<void> _attach({required bool camera}) async {
    final info = await attachInvoice(
      context,
      widget.transactionId,
      camera: camera,
    );
    if (info == null) return;
    // Names are numbered within the operation: reload them all.
    await _load();
    widget.onHasInvoices(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final items = _items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titled by the operation sheet's section.
        if (items == null)
          const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          )
        else if (items.isEmpty)
          Text(l.invoicesNone, style: theme.textTheme.bodySmall)
        else
          for (final i in items)
            InvoiceTile(
              key: ValueKey(i.invoice.id),
              info: i,
              canWrite: widget.canWrite,
              onChanged: (_) async {
                await _load();
                widget.onHasInvoices(_items?.isNotEmpty ?? false);
              },
            ),
        if (_waiting.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l.invoicesWaitingForThis,
              style: theme.textTheme.labelLarge,
            ),
          ),
          for (final m in _waiting)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(Icons.pending_actions_outlined),
              title: Text(m.label),
              subtitle: Text(l.invoiceMatchScore(m.score)),
              trailing: TextButton(
                onPressed: () async {
                  final info = await attachWaitingInvoice(
                    context,
                    m.invoiceId,
                    widget.transactionId,
                  );
                  if (info == null) return;
                  await _load();
                  widget.onHasInvoices(true);
                },
                child: Text(l.invoiceAttachHere),
              ),
            ),
        ],
        if (widget.canWrite)
          Wrap(
            spacing: 8,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.attach_file),
                label: Text(l.invoiceAttach),
                onPressed: () => _attach(camera: false),
              ),
              TextButton.icon(
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(l.invoiceTakePhoto),
                onPressed: () => _attach(camera: true),
              ),
            ],
          ),
      ],
    );
  }
}

class _EditInvoiceDialog extends StatefulWidget {
  final InvoiceInfo info;
  const _EditInvoiceDialog({required this.info});

  @override
  State<_EditInvoiceDialog> createState() => _EditInvoiceDialogState();
}

class _EditInvoiceDialogState extends State<_EditInvoiceDialog> {
  late final _label = TextEditingController(text: widget.info.invoice.label);
  late DateTime? _until = widget.info.invoice.warrantyUntil;
  var _busy = false;
  String? _error;

  /// Warranties start on the purchase: the operation's date, else today.
  DateTime get _start {
    final d = widget.info.transactionDate;
    if (d != null) return d;
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day);
  }

  DateTime _years(int n) {
    final s = _start;
    // 29 February plus a year: 28 February.
    final day = DateTime.utc(s.year + n, s.month + 1, 0).day;
    return DateTime.utc(s.year + n, s.month, s.day > day ? day : s.day);
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final s = _start;
    final initial = _until ?? _years(2);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(s.year - 5),
      lastDate: DateTime(s.year + 30),
    );
    if (picked != null) {
      setState(
        () => _until = DateTime.utc(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _save() async {
    setState(() => (_busy = true, _error = null));
    try {
      final saved = await client.invoice.update(
        widget.info.invoice.id!,
        _label.text,
        _until,
      );
      if (mounted) Navigator.pop(context, saved);
    } on Object catch (e) {
      if (mounted) {
        setState(
          () => (
            _busy = false,
            _error = errorText(AppLocalizations.of(context), e),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final until = _until;
    return AlertDialog(
      title: Text(l.invoiceEdit),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _label,
              autofocus: true,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: l.invoiceLabel,
                hintText: l.invoiceLabelHint,
                helperText: l.invoiceLabelHelp,
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(l.invoiceWarranty, style: theme.textTheme.titleSmall),
            Text(
              until == null
                  ? l.invoiceWarrantyNone
                  : l.invoiceWarrantyUntil(context.day(until)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final n in [1, 2, 3, 5])
                  ChoiceChip(
                    label: Text(l.invoiceWarrantyYears(n)),
                    selected: until == _years(n),
                    onSelected: (_) => setState(() => _until = _years(n)),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.event, size: 18),
                  label: Text(l.invoiceWarrantyPick),
                  onPressed: _pick,
                ),
                if (until != null)
                  ActionChip(
                    avatar: const Icon(Icons.clear, size: 18),
                    label: Text(l.invoiceWarrantyClear),
                    onPressed: () => setState(() => _until = null),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l.invoiceWarrantyHelp,
                style: theme.textTheme.bodySmall,
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
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

class _SendInvoiceDialog extends StatefulWidget {
  final InvoiceInfo info;
  const _SendInvoiceDialog({required this.info});

  @override
  State<_SendInvoiceDialog> createState() => _SendInvoiceDialogState();
}

class _SendInvoiceDialogState extends State<_SendInvoiceDialog> {
  final _to = TextEditingController();
  final _message = TextEditingController();
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _to.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => (_busy = true, _error = null));
    try {
      await client.invoice.send(
        widget.info.invoice.id!,
        _to.text,
        _message.text,
      );
      if (mounted) Navigator.pop(context, true);
    } on Object catch (e) {
      if (mounted) {
        setState(
          () => (
            _busy = false,
            _error = errorText(AppLocalizations.of(context), e),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(l.invoiceSend),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.info.name, style: theme.textTheme.bodySmall),
            TextField(
              controller: _to,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l.invoiceSendTo),
            ),
            TextField(
              controller: _message,
              maxLines: 4,
              minLines: 2,
              maxLength: 1000,
              decoration: InputDecoration(labelText: l.invoiceSendMessage),
            ),
            Text(l.invoiceSendHelp, style: theme.textTheme.bodySmall),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.send),
          onPressed: _busy ? null : _send,
          label: Text(l.invoiceSendAction),
        ),
      ],
    );
  }
}

class _HintsDialog extends StatefulWidget {
  final InvoiceHints? initial;
  const _HintsDialog({this.initial});

  @override
  State<_HintsDialog> createState() => _HintsDialogState();
}

class _HintsDialogState extends State<_HintsDialog> {
  late final _amount = TextEditingController();
  late final _merchant = TextEditingController(
    text: widget.initial?.merchant,
  );
  late DateTime? _date = widget.initial?.date;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    final a = widget.initial?.amountCents;
    if (a != null) {
      // Shown as typed: 499,00 / 499.00.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final fr = Localizations.localeOf(context).languageCode == 'fr';
        final t = (a / 100).toStringAsFixed(2);
        _amount.text = fr ? t.replaceAll('.', ',') : t;
      });
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final today = todayUtcMidnight();
    final initial = _date ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(today.year - 10),
      lastDate: DateTime(today.year, today.month, today.day + 30),
    );
    if (picked != null) {
      setState(
        () => _date = DateTime.utc(picked.year, picked.month, picked.day),
      );
    }
  }

  void _done() {
    final l = AppLocalizations.of(context);
    final text = _amount.text.trim();
    int? cents;
    if (text.isNotEmpty) {
      cents = parseUserAmount(text)?.abs();
      if (cents == null || cents == 0) {
        setState(() => _amountError = l.invoiceHintAmountInvalid);
        return;
      }
    }
    final m = _merchant.text.trim();
    Navigator.pop<InvoiceHints>(context, (
      amountCents: cents,
      date: _date,
      merchant: m.isEmpty ? null : m,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final date = _date;
    return AlertDialog(
      title: Text(l.invoiceHints),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.invoiceHintsHelp, style: theme.textTheme.bodySmall),
            TextField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l.invoiceHintAmount,
                errorText: _amountError,
              ),
            ),
            TextField(
              controller: _merchant,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: l.invoiceHintMerchant,
                hintText: l.invoiceHintMerchantHint,
              ),
            ),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  date == null
                      ? l.invoiceHintNoDate
                      : l.invoiceHintDate(context.day(date)),
                ),
                ActionChip(
                  avatar: const Icon(Icons.event, size: 18),
                  label: Text(l.invoiceWarrantyPick),
                  onPressed: _pick,
                ),
                if (date != null)
                  IconButton(
                    tooltip: l.invoiceWarrantyClear,
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _date = null),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _done, child: Text(l.continueLabel)),
      ],
    );
  }
}

class _ProposalsDialog extends StatefulWidget {
  final InvoiceInfo info;
  final bool afterAdding;
  const _ProposalsDialog({required this.info, required this.afterAdding});

  @override
  State<_ProposalsDialog> createState() => _ProposalsDialogState();
}

class _ProposalsDialogState extends State<_ProposalsDialog> {
  final _search = TextEditingController();
  List<InvoiceMatch>? _items;
  String? _error;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => (_items = null, _error = null));
    try {
      final items = await client.invoice.proposals(
        widget.info.invoice.id!,
        search: _search.text,
      );
      if (mounted) setState(() => _items = items);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _attach(InvoiceMatch m) async {
    setState(() => _busy = true);
    final info = await attachWaitingInvoice(
      context,
      widget.info.invoice.id!,
      m.transactionId,
    );
    if (!mounted) return;
    if (info != null) {
      Navigator.pop(context, info);
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final items = _items;
    return AlertDialog(
      title: Text(l.invoiceAttachTo),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.info.name, style: theme.textTheme.bodySmall),
            TextField(
              controller: _search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: l.invoiceProposalsSearch,
              ),
              onSubmitted: (_) => _load(),
            ),
            const SizedBox(height: 8),
            if (_error != null)
              Text(_error!, style: TextStyle(color: theme.colorScheme.error))
            else if (items == null)
              const LinearProgressIndicator()
            else if (items.isEmpty)
              Text(
                _search.text.trim().isEmpty
                    ? l.invoiceProposalsNone
                    : l.invoiceProposalsNoneSearch,
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final m in items)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        enabled: !_busy,
                        title: Text(m.label),
                        subtitle: Text(
                          '${context.day(m.date)} · ${m.accountName}'
                          '${_search.text.trim().isEmpty ? ' · ${l.invoiceMatchScore(m.score)}' : ''}',
                        ),
                        trailing: Text(
                          context.money(m.amountCents, currency: m.currency),
                        ),
                        onTap: () => _attach(m),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: Text(
            widget.afterAdding ? l.invoiceAttachLater : l.cancel,
          ),
        ),
      ],
    );
  }
}
