import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// {@template circle_pois_pattern_painter}
/// A [CustomPainter] that fills the area with a polka dot pattern.
///
/// The pattern consists of evenly spaced circles (dots) arranged in rows and columns.
/// You can configure the dot color, number of dots per row, horizontal and vertical gaps, and margin.
///
/// The pattern is rendered using a custom [CirclePoisShader], which allows for efficient and flexible drawing.
///
/// ### Constructor parameters:
/// - [poisShader]: The shader responsible for rendering the polka dot pattern.
/// - [color]: The color of the dots (default: black).
/// - [dotsPerRow]: Number of dots per row (default: 2).
/// - [gap]: Horizontal gap between dots (default: 2.0).
/// - [verticalGap]: Vertical gap between dots (default: 2.0).
/// - [margin]: Margin around the pattern (default: 2.0).
///
/// ### Example usage:
/// ```dart
/// CustomPaint(
///   painter: CirclePoisPatternPainter(
///     poisShader: myShader,
///     color: Colors.red,
///     dotsPerRow: 4,
///     gap: 4.0,
///     verticalGap: 4.0,
///     margin: 2.0,
///   ),
/// )
/// ```
/// {@endtemplate}
class CirclePoisPatternPainter extends FlShaderPainter {
  CirclePoisPatternPainter({
    required this.poisShader,
    this.color = Colors.black,
    this.dotsPerRow = 2,
    this.gap = 2.0,
    this.verticalGap = 2.0,
    this.margin = 2.0,
  }) : super(flShader: poisShader);

  /// The color of the dots.
  final Color color;

  /// Number of dots per row.
  final int dotsPerRow;

  /// The gap between dots on X axis.
  final double gap;

  /// The gap between dots on Y axis.
  final double verticalGap;

  /// The margin around the pattern from the borders.
  final double margin;

  /// The shader used to render the polka dot pattern.
  final CirclePoisShader poisShader;

  @override
  void paint(Canvas canvas, Size size) {
    poisShader.shader.setFloat(0, size.width);
    poisShader.shader.setFloat(1, size.height);
    poisShader.shader.setFloat(2, color.r);
    poisShader.shader.setFloat(3, color.g);
    poisShader.shader.setFloat(4, color.b);
    poisShader.shader.setFloat(5, dotsPerRow.toDouble());
    poisShader.shader.setFloat(6, gap);
    poisShader.shader.setFloat(7, verticalGap);
    poisShader.shader.setFloat(8, margin);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = poisShader.shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
