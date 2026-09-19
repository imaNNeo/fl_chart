/// Output-agnostic model of the documented API, filled by the extractor and
/// rendered by the writers (markdown tables today, json/playground later).
library;

import 'package:analyzer/dart/element/element.dart';

/// How a documented type is turned into table rows.
enum TableMode {
  /// One row per parameter of the unnamed constructor (config classes).
  constructor,

  /// One row per public instance field (read-only/response classes).
  fields,

  /// One row per enum value.
  enumValues,
}

class ApiType {
  ApiType({
    required this.name,
    required this.mode,
    required this.members,
    this.inheritsFrom,
  });

  final String name;
  final TableMode mode;
  final List<ApiMember> members;

  /// A documented superclass whose fields are not repeated (fields mode).
  final String? inheritsFrom;
}

class ApiMember {
  ApiMember({
    required this.name,
    required this.doc,
    this.type,
    this.defaultValue,
    this.isRequired = false,
    this.deprecationMessage,
  });

  final String name;

  /// Display string of the type, null for enum values.
  final String? type;

  /// Source code of the default value, null if there's none (or unknown).
  final String? defaultValue;

  final bool isRequired;

  /// Non-null if deprecated (empty when there's no message).
  final String? deprecationMessage;

  final DocText doc;
}

/// A dartdoc comment, cleaned up to plain markdown, whose `[references]` are
/// already resolved so each writer can link them in its own way.
class DocText {
  DocText(this.markdown, this.references);

  final String markdown;

  /// Keyed by the text between the brackets, e.g. `FlSpot.nullSpot`.
  final Map<String, Element> references;
}
