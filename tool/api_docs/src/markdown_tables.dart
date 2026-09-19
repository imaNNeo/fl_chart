import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as p;

import 'api_extractor.dart';
import 'api_model.dart';

/// `<!-- api:LineChartBarData -->` ... `<!-- /api -->`, with an optional
/// mode (`<!-- api:LineTouchResponse fields -->`).
final markerPattern =
    RegExp(r'<!-- api:(\w+)(?: (\w+))? -->\n[\s\S]*?<!-- /api -->');

/// Stands for the n-th code span while the prose of a cell is reflowed.
final _placeholder = RegExp('\u0000(\\d+)\u0000');

class Marker {
  Marker(this.typeName, this.mode);

  final String typeName;
  final TableMode? mode;
}

List<Marker> markersIn(String markdown) => [
      for (final match in markerPattern.allMatches(markdown))
        Marker(
          match[1]!,
          match[2] == null ? null : TableMode.values.byName(match[2]!),
        ),
    ];

/// Where each type is documented: `{'FlSpot': 'base_chart.md#flspot'}`,
/// taken from the headings (`### FlSpot`) of the documentation files.
Map<String, String> headingAnchors(Map<String, String> filesByName) {
  final anchors = <String, String>{};
  final heading = RegExp(r'^#{2,6}\s+(.+?)\s*$', multiLine: true);
  for (final MapEntry(key: fileName, value: markdown) in filesByName.entries) {
    for (final match in heading.allMatches(markdown)) {
      final text = match[1]!;
      final typeName = RegExp(r'^\w+').stringMatch(text);
      if (typeName == null) continue;
      anchors.putIfAbsent(typeName, () => '$fileName#${githubSlug(text)}');
    }
  }
  return anchors;
}

/// The anchor GitHub generates for a heading.
String githubSlug(String heading) => heading
    .replaceAllMapped(RegExp(r'\[([^\]]*)\]\([^)]*\)'), (m) => m[1]!)
    .toLowerCase()
    .replaceAll(RegExp(r'[^\w\- ]'), '')
    .replaceAll(' ', '-');

/// Replaces the content of every marker in [markdown] with its table.
String replaceTables(
  String markdown,
  String fileName,
  Map<String, ApiType> types,
  Map<String, String> anchors,
) =>
    markdown.replaceAllMapped(markerPattern, (match) {
      final type = types[match[1]!];
      final table =
          type == null ? '' : _TableWriter(type, fileName, anchors).write();
      final mode = match[2] == null ? '' : ' ${match[2]}';
      return '<!-- api:${match[1]}$mode -->\n$table<!-- /api -->';
    });

class _TableWriter {
  _TableWriter(this.type, this.fileName, this.anchors);

  final ApiType type;
  final String fileName;
  final Map<String, String> anchors;

  String write() {
    final buffer = StringBuffer();
    switch (type.mode) {
      case TableMode.constructor:
        buffer
          ..writeln('|Property|Type|Default|Description|')
          ..writeln('|:-------|:---|:------|:----------|');
        for (final m in type.members) {
          final defaultValue = m.isRequired
              ? 'required'
              : m.defaultValue == null
                  ? ''
                  : _code(m.defaultValue!);
          buffer.writeln(
            '|${m.name}|${_code(m.type!)}|$defaultValue|${_description(m)}|',
          );
        }
      case TableMode.fields:
        final parent = type.inheritsFrom;
        if (parent != null) {
          final link = _docsLink(parent) ?? '';
          buffer
            ..writeln('Also has the properties of [`$parent`]($link).')
            ..writeln();
        }
        buffer
          ..writeln('|Property|Type|Description|')
          ..writeln('|:-------|:---|:----------|');
        for (final m in type.members) {
          buffer.writeln('|${m.name}|${_code(m.type!)}|${_description(m)}|');
        }
      case TableMode.enumValues:
        buffer
          ..writeln('|Value|Description|')
          ..writeln('|:----|:----------|');
        for (final m in type.members) {
          buffer.writeln('|${m.name}|${_description(m)}|');
        }
    }
    return buffer.toString();
  }

  String _description(ApiMember member) {
    final deprecation = member.deprecationMessage;
    final prefix = deprecation == null
        ? ''
        : '**Deprecated**${deprecation.isEmpty ? '' : ': $deprecation'}<br><br>';
    return prefix + _cell(member.doc);
  }

  /// Renders a dartdoc text in a single table cell.
  String _cell(DocText doc) {
    // Code is swapped for placeholders, so only the prose gets reflowed.
    final code = <String>[];
    final text = splitCode(doc.markdown).map((segment) {
      if (!segment.isCode) return segment.text;
      code.add(
        segment.isBlock
            ? '<pre>${segment.text.replaceAll(RegExp(r'^```\w*\n?|\n?```$'), '').split('\n').map(_escapeHtml).join('<br>')}</pre>'
            : segment.text,
      );
      return '\u0000${code.length - 1}\u0000';
    }).join();

    final paragraphs = text.split(RegExp(r'\n[ \t]*\n')).map((paragraph) {
      // Keep list items on their own line, join the other wrapped lines.
      return paragraph.split('\n').map((line) => line.trim()).fold<String>('',
          (joined, line) {
        if (joined.isEmpty) return line;
        final isListItem = RegExp(r'^([-*]|\d+\.) ').hasMatch(line);
        return '$joined${isListItem ? '<br>' : ' '}$line';
      });
    });
    return paragraphs
        .map(_escapeHtml)
        .map(
          (paragraph) => paragraph.replaceAllMapped(
            referencePattern,
            (m) => _reference(m[1]!, doc.references[m[1]!]),
          ),
        )
        .join('<br><br>')
        .replaceAllMapped(_placeholder, (m) => code[int.parse(m[1]!)])
        .replaceAll('|', r'\|')
        .trim();
  }

  String _reference(String text, Element? element) {
    final code = '`$text`';
    if (element == null) return code;
    // A sibling property of this table: there's no row anchor to link to.
    final isRow = !text.contains('.') &&
        element is! InterfaceElement &&
        type.members.any((m) => m.name == text);
    if (isRow) return code;
    final link = _docsLink(_typeOf(element)?.name) ?? _apiLink(element);
    return link == null ? code : '[$code]($link)';
  }

  /// Link to the section documenting [typeName], relative to this file.
  String? _docsLink(String? typeName) {
    final anchor = anchors[typeName];
    if (anchor == null) return null;
    final [file, fragment] = anchor.split('#');
    return file == fileName ? '#$fragment' : anchor;
  }

  /// Links to the dartdoc page on pub.dev or api.flutter.dev.
  String? _apiLink(Element element) {
    final type = _typeOf(element);
    final target = type ?? element;
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

  String _code(String code) => '`${code.replaceAll('|', r'\|')}`';

  String _escapeHtml(String text) => text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');
}
