import '../local_date.dart';
import '../money.dart';

/// Characters that Windows, macOS or Linux refuse in a file name.
final _forbidden = RegExp(r'[\\/:*?"<>|\x00-\x1f\x7f]');

/// A label made safe for a file name: forbidden characters replaced, spaces
/// collapsed, at most [max] characters.
String safeFileLabel(String text, {int max = 60}) {
  var s = text.replaceAll(_forbidden, '_').replaceAll(RegExp(r'\s+'), ' ');
  s = s.trim();
  // A name ending with dots or spaces is refused by Windows.
  s = s.replaceFirst(RegExp(r'[. ]+$'), '');
  if (s.length > max) s = s.substring(0, max).trimRight();
  return s;
}

/// Extension of [fileName] in lower case, without the dot (`pdf`), or ''.
String fileExtension(String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot <= 0 || dot == fileName.length - 1) return '';
  return fileName.substring(dot + 1).toLowerCase();
}

/// Name an invoice gets when it is opened, saved or exported, so that a
/// folder of invoices reads like the statement:
/// `2026-10-31 - DARTY - Lave-linge - 499,00 EUR.pdf`.
///
/// Built from its operation ([date], [operationLabel], [amountCents],
/// [currency]) and its own [label]; an invoice without an operation keeps
/// its [label], or else its [originalName]. [index] tells apart several
/// invoices of one operation (` (2)`, ` (3)`…).
String invoiceFileName({
  required String originalName,
  LocalDate? date,
  String? operationLabel,
  int? amountCents,
  String? currency,
  String? label,
  int index = 1,
}) {
  final ext = fileExtension(originalName);
  final own = label == null ? '' : safeFileLabel(label);
  final parts = <String>[];
  if (date != null) {
    parts.add('$date');
    final op = operationLabel == null ? '' : safeFileLabel(operationLabel);
    if (op.isNotEmpty) parts.add(op);
    if (own.isNotEmpty && own.toLowerCase() != op.toLowerCase()) {
      parts.add(own);
    }
    if (amountCents != null) {
      final money = formatCents(amountCents.abs(), thousandsSeparator: '');
      parts.add(currency == null ? money : '$money ${safeFileLabel(currency)}');
    }
  } else {
    final stem = ext.isEmpty
        ? originalName
        : originalName.substring(0, originalName.length - ext.length - 1);
    final fallback = safeFileLabel(stem, max: 100);
    parts.add(own.isNotEmpty ? own : (fallback.isEmpty ? '_' : fallback));
  }
  final suffix = index > 1 ? ' ($index)' : '';
  return '${parts.join(' - ')}$suffix${ext.isEmpty ? '' : '.$ext'}';
}

/// Makes [names] unique by adding ` (2)`, ` (3)`… before the extension of
/// the repeated ones (several invoices with the same name in an export).
List<String> uniqueFileNames(List<String> names) {
  final used = <String>{};
  return [
    for (final n in names)
      () {
        if (used.add(n.toLowerCase())) return n;
        final ext = fileExtension(n);
        final stem = ext.isEmpty
            ? n
            : n.substring(0, n.length - ext.length - 1);
        for (var i = 2; ; i++) {
          final c = '$stem ($i)${ext.isEmpty ? '' : '.$ext'}';
          if (used.add(c.toLowerCase())) return c;
        }
      }(),
  ];
}
