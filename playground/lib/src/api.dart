/// What the playground knows about the documented classes of fl_chart,
/// generated from their dartdoc in `../generated/api_registry.g.dart`.
library;

/// Which control a property gets, from its type.
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

class PropertySpec {
  const PropertySpec({
    required this.name,
    required this.type,
    required this.kind,
    this.isNullable = false,
    this.isRequired = false,
    this.isPositional = false,
    this.values,
    this.nestedType,
    this.defaultCode,
  });

  final String name;

  /// The type, as written in Dart (`double?`, `List<FlSpot>`, ...).
  final String type;

  final PropertyKind kind;
  final bool isNullable;
  final bool isRequired;

  /// Whether it's a positional (not named) parameter of the constructor.
  final bool isPositional;

  /// The values of an enum ([PropertyKind.enumeration]).
  final List<Enum>? values;

  /// The documented class of a [PropertyKind.nested] property.
  final String? nestedType;

  /// The default value, as written in the constructor.
  final String? defaultCode;
}

class ClassSpec {
  const ClassSpec({
    required this.name,
    required this.properties,
    this.read,
    this.copy,
  });

  final String name;
  final List<PropertySpec> properties;

  /// Reads a property of an instance of this class.
  final Object? Function(Object instance, String property)? read;

  /// Copies an instance of this class, with the given properties changed.
  final Object Function(Object instance, Map<String, Object?> values)? copy;

  PropertySpec? property(String name) {
    for (final property in properties) {
      if (property.name == name) return property;
    }
    return null;
  }
}
