import 'package:fl_chart/src/shaders/fl_shader.dart';

/// {@template circle_pois_shader}
/// A shader class for rendering a polka dot (circle pois) pattern.
///
/// This class loads the fragment shader located at
/// `packages/fl_chart/shaders/circle_pois_pattern.frag` and provides it
/// for use in custom painters such as [CirclePoisPatternPainter].
///
/// Typically used to efficiently render repeating circular dot patterns
/// as backgrounds or fills in charts and custom widgets.
/// {@endtemplate}
class CirclePoisShader extends FlShader {
  CirclePoisShader()
      : super(path: 'packages/fl_chart/shaders/circle_pois_pattern.frag');
}
