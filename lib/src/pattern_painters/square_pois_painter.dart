import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// {@template square_pois_pattern_painter}
/// A [CustomPainter] that fills the area with a square polka dot pattern.
///
/// The pattern consists of evenly spaced squares arranged in rows and columns.
/// You can configure the color of the squares, the number of squares per row, the horizontal and vertical gaps between squares, and the margin around the pattern.
///
/// The pattern is rendered using a custom [SquarePoisShader], which allows for efficient and flexible drawing.
///
/// ### Constructor parameters:
/// - [poisShader]: The shader responsible for rendering the square polka dot pattern.
/// - [color]: The color of the squares (default: black).
/// - [squaresPerRow]: Number of squares per row (default: 3).
/// - [gap]: Horizontal gap between squares (default: 2.0).
/// - [verticalGap]: Vertical gap between squares (default: 2.0).
/// - [margin]: Margin around the pattern (default: 2.0).
///
/// ### Example usage:
/// ```dart
/// CustomPaint(
///   painter: SquarePoisPatternPainter(
///     poisShader: myShader,
///     color: Colors.green,
///     squaresPerRow: 4,
///     gap: 2.0,
///     verticalGap: 2.0,
///     margin: 2.0,
///   ),
/// )
/// ```
/// {@endtemplate}
class SquarePoisPatternPainter extends FlShaderPainter {
  SquarePoisPatternPainter({
    required this.poisShader,
    this.color = Colors.black,
    this.squaresPerRow = 3,
    this.gap = 2.0,
    this.verticalGap = 2.0,
    this.margin = 2.0,
  }) : super(flShader: poisShader);

  /// The color of the squares.
  final Color color;

  /// Number of squares per row.
  final int squaresPerRow;

  /// The gap between dots on X axis;
  final double gap;

  /// The gap between dots on Y axis;
  final double verticalGap;

  /// The margin around the pattern from the borders.
  final double margin;

  /// The shader used to render the polka dot pattern.
  final SquarePoisShader poisShader;

  @override
  void paint(Canvas canvas, Size size) {
    poisShader.shader.setFloat(0, size.width);
    poisShader.shader.setFloat(1, size.height);
    poisShader.shader.setFloat(2, color.r);
    poisShader.shader.setFloat(3, color.g);
    poisShader.shader.setFloat(4, color.b);
    poisShader.shader.setFloat(5, squaresPerRow.toDouble());
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
