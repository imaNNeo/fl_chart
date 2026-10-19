import 'package:flutter/material.dart';

import 'api.dart';
import 'hints.dart';

/// The Dart code that creates [className] with the given property [values].
String constructorCode(
  ClassSpec spec,
  Map<String, Object?> values, {
  Map<String, String> fallbackCodes = const {},
}) {
  if (values.isEmpty) return '${spec.name}()';
  // Positional parameters come first, in the order of the constructor.
  final lines = [
    for (final property in spec.properties)
      if (values.containsKey(property.name))
        '  ${property.isPositional ? '' : '${property.name}: '}'
            '${dartCode(values[property.name], fallback: fallbackCodes[property.name], isDouble: property.kind == PropertyKind.decimal)},',
  ];
  return '${spec.name}(\n${lines.join('\n')}\n)';
}

/// The Dart code of [value], or [fallback] (or `...`) when there's no
/// obvious one, like for a callback.
///
/// [isDouble] writes `3.0` for a `double`, which is an `int` on the web.
String dartCode(Object? value, {String? fallback, bool isDouble = false}) =>
    switch (value) {
      null => 'null',
      Preset(:final code) => code,
      num() when isDouble => _doubleCode(value.toDouble()),
      bool() || int() => '$value',
      double() => _doubleCode(value),
      String() => _stringCode(value),
      Enum() => '$value',
      Color() => colorCode(value),
      List() when value.every((item) => item is num) => '$value',
      _ => fallback ?? '...',
    };

/// The colors of the color picker, with their code.
final namedColors = <Color, String>{
  Colors.cyan: 'Colors.cyan',
  Colors.blue: 'Colors.blue',
  Colors.deepPurple: 'Colors.deepPurple',
  Colors.purpleAccent: 'Colors.purpleAccent',
  Colors.pinkAccent: 'Colors.pinkAccent',
  Colors.red: 'Colors.red',
  Colors.orange: 'Colors.orange',
  Colors.amber: 'Colors.amber',
  Colors.green: 'Colors.green',
  Colors.white: 'Colors.white',
  Colors.black: 'Colors.black',
};

String colorCode(Color color) {
  for (final MapEntry(key: named, value: code) in namedColors.entries) {
    if (named.toARGB32() == color.toARGB32()) return code;
  }
  return 'Color(0x${color.toARGB32().toRadixString(16).padLeft(8, '0')})';
}

String _doubleCode(double value) {
  if (value.isNaN) return 'null';
  if (value.isInfinite) {
    return value > 0 ? 'double.infinity' : '-double.infinity';
  }
  final fixed = value.toStringAsFixed(2);
  final trimmed = fixed.replaceFirst(RegExp(r'0+$'), '');
  return trimmed.endsWith('.') ? '${trimmed}0' : trimmed;
}

String _stringCode(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$')
      .replaceAll('\n', r'\n');
  return "'$escaped'";
}
