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
class CirclePoisPatternPainter extends FlSurfacePainter<CirclePoisShader> {
  CirclePoisPatternPainter({
    @visibleForTesting CirclePoisShader? mockShader,
    this.color = Colors.black,
    this.dotsPerRow = 2,
    this.gap = 2.0,
    this.verticalGap = 2.0,
    this.margin = 2.0,
  }) : super(flShader: mockShader ?? CirclePoisShader());

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

  @override
  void paint(Canvas canvas, Size size) {
    flShader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, color.r)
      ..setFloat(3, color.g)
      ..setFloat(4, color.b)
      ..setFloat(5, dotsPerRow.toDouble())
      ..setFloat(6, gap)
      ..setFloat(7, verticalGap)
      ..setFloat(8, margin);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = flShader.shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
