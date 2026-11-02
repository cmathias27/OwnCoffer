import 'package:flutter/material.dart';

/// Lightweight Markdown renderer for the AI assistant replies.
///
/// Handles headings (`#`, `##`, `###`), bullets (`-`, `*`), numbered lists
/// (`1.`), paragraphs, and inline formatting (`**bold**`, `*italic*`, `` `code` ``).
/// Each block uses [SelectableText.rich] so the user can easily select,
/// copy, or zoom the content.
class ChatMarkdown extends StatelessWidget {
  final String text;
  const ChatMarkdown(this.text, {super.key});

  static List<TextSpan> _inline(
    String text,
    TextStyle? base,
    ColorScheme scheme,
  ) {
    final spans = <TextSpan>[];
    // Tokenize on backticks first for code spans, then on ** for bold, then * for italic.
    final codeParts = text.split('`');
    for (final (ci, cp) in codeParts.indexed) {
      if (cp.isEmpty) continue;
      if (ci.isOdd) {
        // Inline code / monospace
        spans.add(
          TextSpan(
            text: cp,
            style: base?.copyWith(
              fontFamily: 'monospace',
              backgroundColor: scheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
            ),
          ),
        );
        continue;
      }
      final boldParts = cp.split('**');
      for (final (bi, bp) in boldParts.indexed) {
        if (bp.isEmpty) continue;
        final boldStyle = bi.isOdd
            ? base?.copyWith(fontWeight: FontWeight.w700)
            : base;
        // Check for *italic* inside non-bold parts or bold parts
        final italicParts = bp.split('*');
        if (italicParts.length > 1) {
          for (final (ii, ip) in italicParts.indexed) {
            if (ip.isEmpty) continue;
            spans.add(
              TextSpan(
                text: ip,
                style: ii.isOdd
                    ? boldStyle?.copyWith(fontStyle: FontStyle.italic)
                    : boldStyle,
              ),
            );
          }
        } else {
          spans.add(TextSpan(text: bp, style: boldStyle));
        }
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final body = theme.textTheme.bodyMedium;
    final children = <Widget>[];

    final numberedRegex = RegExp(r'^(\s*)(\d+)\.\s+(.*)$');
    final bulletRegex = RegExp(r'^(\s*)[-*]\s+(.*)$');

    final lines = text.split('\n');
    final paragraphLines = <String>[];

    void flushParagraph() {
      if (paragraphLines.isEmpty) return;
      final content = paragraphLines.join(' ');
      paragraphLines.clear();
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: SelectableText.rich(
            TextSpan(children: _inline(content, body, scheme)),
          ),
        ),
      );
    }

    for (final raw in lines) {
      final line = raw.trimRight();
      if (line.trim().isEmpty) {
        flushParagraph();
        continue;
      }

      // Headings
      if (line.startsWith('#')) {
        flushParagraph();
        final headingText = line.replaceFirst(RegExp(r'^#+\s*'), '');
        final isH1 = line.startsWith('# ') && !line.startsWith('## ');
        final style = isH1
            ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
            : theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700);
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: SelectableText.rich(
              TextSpan(children: _inline(headingText, style, scheme)),
            ),
          ),
        );
        continue;
      }

      // Bullets
      if (bulletRegex.firstMatch(line) case final m?) {
        flushParagraph();
        final indent = m[1]!.length ~/ 2;
        final bulletText = m[2]!;
        children.add(
          Padding(
            padding: EdgeInsets.only(left: 12.0 * indent, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6, top: 1),
                  child: Text(indent == 0 ? '•' : '◦', style: body),
                ),
                Expanded(
                  child: SelectableText.rich(
                    TextSpan(children: _inline(bulletText, body, scheme)),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      // Numbered lists
      if (numberedRegex.firstMatch(line) case final m?) {
        flushParagraph();
        final numStr = m[2]!;
        final listText = m[3]!;
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    '$numStr.',
                    style: body?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: SelectableText.rich(
                    TextSpan(children: _inline(listText, body, scheme)),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      // Regular text in a paragraph
      paragraphLines.add(line.trim());
    }
    flushParagraph();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
