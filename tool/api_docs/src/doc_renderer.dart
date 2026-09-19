import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as p;

import 'api_extractor.dart';
import 'api_model.dart';

/// Stands for the n-th code span while the prose of a text is processed.
final _placeholder = RegExp('\u0000(\\d+)\u0000');

/// Renders the dartdoc of [type]'s members as markdown for the page
/// [fileName], linking `[references]` to the docs or to the API reference.
class DocRenderer {
  DocRenderer(this.type, this.fileName, this.anchors);

  final ApiType type;

  /// The documentation file the rendered text goes to, e.g. `line_chart.md`.
  final String fileName;

  /// Where each type is documented, see `headingAnchors`.
  final Map<String, String> anchors;

  /// Renders [doc] as regular (multi-line) markdown.
  String markdown(DocText doc) => _render(
        doc,
        codeBlock: (code) => code,
        prose: (text) => text,
      );

  /// Renders [doc] in a single line, to fit in a markdown table cell.
  String cell(DocText doc) => _render(
        doc,
        codeBlock: (code) =>
            '<pre>${code.replaceAll(RegExp(r'^```\w*\n?|\n?```$'), '').split('\n').map(_escapeHtml).join('<br>')}</pre>',
        prose: (text) =>
            text.split(RegExp(r'\n[ \t]*\n')).map(_joinLines).join('<br><br>'),
      ).replaceAll('|', r'\|');

  /// Link to the section documenting [typeName], relative to [fileName].
  String? docsLink(String? typeName) {
    final anchor = anchors[typeName];
    if (anchor == null) return null;
    final [file, fragment] = anchor.split('#');
    return file == fileName ? '#$fragment' : anchor;
  }

  String _render(
    DocText doc, {
    required String Function(String code) codeBlock,
    required String Function(String text) prose,
  }) {
    // Code is swapped for placeholders, so only the prose gets processed.
    final code = <String>[];
    final text = splitCode(doc.markdown).map((segment) {
      if (!segment.isCode) return segment.text;
      code.add(segment.isBlock ? codeBlock(segment.text) : segment.text);
      return '\u0000${code.length - 1}\u0000';
    }).join();
    return prose(_escapeHtml(text))
        .replaceAllMapped(
          referencePattern,
          (m) => _reference(m[1]!, doc.references[m[1]!]),
        )
        .replaceAllMapped(_placeholder, (m) => code[int.parse(m[1]!)])
        .trim();
  }

  /// Joins the wrapped lines of a paragraph, keeping list items apart.
  String _joinLines(String paragraph) => paragraph
          .split('\n')
          .map((line) => line.trim())
          .fold<String>('', (joined, line) {
        if (joined.isEmpty) return line;
        final isListItem = RegExp(r'^([-*]|\d+\.) ').hasMatch(line);
        return '$joined${isListItem ? '<br>' : ' '}$line';
      });

  String _reference(String text, Element? element) {
    final code = '`$text`';
    if (element == null) return code;
    // A sibling property of this type: there's no anchor to link to.
    final isSibling = !text.contains('.') &&
        element is! InterfaceElement &&
        type.members.any((m) => m.name == text);
    if (isSibling) return code;
    final link = docsLink(_typeOf(element)?.name) ?? _apiLink(element);
    return link == null ? code : '[$code]($link)';
  }

  /// Links to the dartdoc page on pub.dev or api.flutter.dev.
  String? _apiLink(Element element) {
    final target = _typeOf(element) ?? element;
    final uri = target.library?.uri;
    final name = target.name;
    if (uri == null || name == null) return null;
    final String base;
    if (uri.isScheme('dart')) {
      base = 'https://api.flutter.dev/flutter/dart-${uri.path}';
    } else if (uri.pathSegments.firstOrNull == 'fl_chart') {
      base = 'https://pub.dev/documentation/fl_chart/latest/fl_chart';
    } else if (uri.pathSegments.firstOrNull == 'flutter' &&
        uri.pathSegments.length > 2) {
      base = 'https://api.flutter.dev/flutter/${uri.pathSegments[2]}';
    } else {
      return null;
    }
    final page = target is ClassElement ? '$name-class.html' : '$name.html';
    return p.url.join(base, page);
  }

  /// The type a reference points to, or belongs to for a member.
  InterfaceElement? _typeOf(Element element) => switch (element) {
        InterfaceElement() => element,
        _ => element.enclosingElement is InterfaceElement
            ? element.enclosingElement! as InterfaceElement
            : null,
      };

  String _escapeHtml(String text) => text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');
}
