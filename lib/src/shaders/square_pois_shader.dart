import 'package:fl_chart/src/shaders/fl_shader.dart';

/// {@template square_pois_shader}
/// A shader class for rendering a repeating square polka dot pattern.
///
/// This class loads the fragment shader located at
/// `packages/fl_chart/shaders/square_pois_pattern.frag` and provides it
/// for use in custom painters such as [SquarePoisPatternPainter].
///
/// Typically used to efficiently render repeating square dot patterns
/// as backgrounds or fills in charts and custom widgets.
/// {@endtemplate}
class SquarePoisShader extends FlShader {
  SquarePoisShader()
      : super(path: 'packages/fl_chart/shaders/square_pois_pattern.frag');
}
