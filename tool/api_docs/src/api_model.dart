/// Output-agnostic model of the documented API, filled by the extractor and
/// rendered by the writers (markdown tables, website data and playground).
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

/// Which control the playground can show for a property, from its type.
///
/// Mirrors `PropertyKind` in playground/lib/src/api.dart.
enum PropertyKind {
  boolean,
  integer,
  decimal,
  text,
  color,
  enumeration,

  /// Another documented class, which has its own properties.
  nested,
  other,
}

class ApiType {
  ApiType({
    required this.name,
    required this.mode,
    required this.members,
    this.inheritsFrom,
    this.copyIssue,
  });

  final String name;
  final TableMode mode;
  final List<ApiMember> members;

  /// A documented superclass whose fields are not repeated (fields mode).
  final String? inheritsFrom;

  /// Why an instance can't be copied with a changed property (constructor
  /// mode), null if it can: every parameter must have a matching getter.
  final String? copyIssue;
}

class ApiMember {
  ApiMember({
    required this.name,
    required this.doc,
    String? fieldName,
    this.type,
    this.defaultValue,
    this.isRequired = false,
    this.isPositional = false,
    this.deprecationMessage,
    this.kind = PropertyKind.other,
    this.isNullable = false,
    this.kindType,
    this.typeCode,
  }) : fieldName = fieldName ?? name;

  final String name;

  /// The field the parameter is assigned to, when the constructor renames
  /// it (`gaugeTouchData = touchData ?? ...`), else its own name.
  final String fieldName;

  /// Display string of the type, null for enum values.
  final String? type;

  /// The type as Dart code for the playground registry, where `dart:ui` is
  /// imported as `ui` (`ui.Image` is not the `Image` widget).
  final String? typeCode;

  /// Source code of the default value, null if there's none (or unknown).
  final String? defaultValue;

  final bool isRequired;

  /// Whether it's a positional (not named) constructor parameter.
  final bool isPositional;

  /// Non-null if deprecated (empty when there's no message).
  final String? deprecationMessage;

  final PropertyKind kind;

  final bool isNullable;

  /// The enum ([PropertyKind.enumeration]) or the documented class
  /// ([PropertyKind.nested]) of the type.
  final String? kindType;

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
