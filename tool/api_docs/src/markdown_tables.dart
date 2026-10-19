import 'api_model.dart';
import 'doc_renderer.dart';

/// `<!-- api:LineChartBarData -->` ... `<!-- /api -->`, with an optional
/// mode (`<!-- api:LineTouchResponse fields -->`).
final markerPattern =
    RegExp(r'<!-- api:(\w+)(?: (\w+))? -->\n[\s\S]*?<!-- /api -->');

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
      final table = type == null
          ? ''
          : _TableWriter(DocRenderer(type, fileName, anchors)).write();
      final mode = match[2] == null ? '' : ' ${match[2]}';
      return '<!-- api:${match[1]}$mode -->\n$table<!-- /api -->';
    });

class _TableWriter {
  _TableWriter(this.renderer);

  final DocRenderer renderer;

  ApiType get type => renderer.type;

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
          final link = renderer.docsLink(parent) ?? '';
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
    return prefix + renderer.cell(member.doc);
  }

  String _code(String code) => '`${code.replaceAll('|', r'\|')}`';
}
