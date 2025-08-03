import 'package:fl_chart/src/shaders/fl_shader_painter.dart';
import 'package:fl_chart/src/shaders/stripes_shader.dart';
import 'package:flutter/material.dart';

/// {@template stripes_pattern_painter}
/// A [CustomPainter] that fills the area with diagonal stripes at a configurable angle.
///
/// The stripes are rendered as parallel lines with customizable color, width, gap, and angle.
/// The angle is specified in degrees and measured clockwise from the x-axis.
///
/// The pattern is rendered using a custom [StripesShader], which enables efficient and flexible drawing of the stripes.
///
/// ### Constructor parameters:
/// - [stripesShader]: The shader responsible for rendering the stripe pattern.
/// - [color]: The color of the stripes (default: black).
/// - [width]: The width of each stripe (default: 20).
/// - [gap]: The gap between each stripe, in logical pixels (default: 10).
/// - [angle]: The angle of the stripes in degrees, clockwise from the x-axis (default: 45).
///
/// ### Example usage:
/// ```dart
/// CustomPaint(
///   painter: StripesPatternPainter(
///     stripesShader: myShader,
///     color: Colors.blue,
///     width: 3,
///     gap: 8,
///     angle: 30,
///   ),
/// )
/// ```
/// {@endtemplate}
class StripesPatternPainter extends FlShaderPainter {
  StripesPatternPainter({
    required this.stripesShader,
    this.color = Colors.black,
    this.width = 2,
    this.gap = 4,
    this.angle = 45,
  }) : super(flShader: stripesShader);

  /// The color of the stripes.
  final Color color;

  /// The width of each stripe line.
  final double width;

  /// The gap between each stripe, in logical pixels.
  final double gap;

  /// Angle in degrees, positive values rotate clockwise from the x-axis.
  final double angle;

  /// The shader used to render the stripes pattern.
  final StripesShader stripesShader;

  @override
  void paint(Canvas canvas, Size size) {
    stripesShader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, width)
      ..setFloat(3, gap)
      ..setFloat(4, angle)
      ..setFloat(5, color.r)
      ..setFloat(6, color.g)
      ..setFloat(7, color.b);

    final paint = Paint()..shader = stripesShader.shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
