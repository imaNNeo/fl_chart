import 'hints/bar.dart';
import 'hints/base.dart';
import 'hints/candlestick.dart';
import 'hints/gauge.dart';
import 'hints/line.dart';
import 'hints/pie.dart';
import 'hints/radar.dart';
import 'hints/scatter.dart';

/// What the type of a property doesn't tell about its demo.
class PropertyHint {
  const PropertyHint({
    this.min,
    this.max,
    this.presets,
    this.requires = const {},
    this.note,
    this.nullable = true,
    this.sample,
  });

  /// The range of the slider of a number.
  final double? min;
  final double? max;

  /// Values to pick from, for types that have no control of their own.
  final List<Preset>? presets;

  /// Other properties of the same class, set to show the effect of this one
  /// (like `isCurved: true` for `curveSmoothness`).
  final Map<String, Object?> requires;

  /// Shown under the chart.
  final String? note;

  /// False when `null` is not a valid value, even if the type is nullable
  /// (like the color of a stack item that has no gradient).
  final bool nullable;

  /// The code of the value the demo starts from, when the demo doesn't use
  /// the default of the constructor (the sample data of the chart, for
  /// example).
  ///
  /// A value that has no obvious code (a list of spots, a callback, a
  /// `TextStyle`, ...) is otherwise shown as the default, which would be a
  /// lie: the chart of the demo draws the sample, not the default.
  final String? sample;
}

/// A value, with the Dart code that creates it.
class Preset {
  const Preset(this.code, this.value);

  final String code;
  final Object? value;
}

/// The hints of the properties, keyed by `ClassName.property`.
final hints = <String, PropertyHint>{
  ...lineHints,
  ...baseHints,
  ...barHints,
  ...pieHints,
  ...scatterHints,
  ...radarHints,
  ...candlestickHints,
  ...gaugeHints,
};
