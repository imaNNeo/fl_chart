import 'package:fl_chart/src/shaders/fl_shader.dart';

/// {@template stripes_shader}
/// A shader class for rendering a diagonal stripes pattern.
///
/// This class loads the fragment shader located at
/// `packages/fl_chart/shaders/striped_pattern.frag` and provides it
/// for use in custom painters such as [StripesPatternPainter].
///
/// Typically used to efficiently render repeating diagonal stripe patterns
/// as backgrounds or fills in charts and custom widgets.
/// {@endtemplate}
class StripesShader extends FlShader {
  StripesShader()
      : super(path: 'packages/fl_chart/shaders/striped_pattern.frag');
}
