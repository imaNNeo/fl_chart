import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A [CustomPainter] that draws diagonal stripes at a configurable angle.
///
/// The stripes are rendered as parallel lines with a given color, width, gap, and angle.
/// The angle is in degrees and is measured clockwise from the x-axis.
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   painter: StripesPatternPainter(
///     color: Colors.blue,
///     stripeWidth: 3,
///     gap: 8,
///     angle: 30,
///   ),
/// )
/// ```
class StripesPatternPainter extends CustomPainter {
  StripesPatternPainter({
    this.color = Colors.black,
    this.width = 2,
    this.gap = 10,
    this.angle = 45,
  });

  /// The color of the stripes.
  final Color color;

  /// The width of each stripe line.
  final double width;

  /// The gap between each stripe, in logical pixels.
  final double gap;

  /// Angle in degrees, positive values rotate clockwise from the x-axis.
  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;

    // Normalize the angle between 0 and 360
    final normalizedAngle = ((angle % 360) + 360) % 360;
    final radians = normalizedAngle * math.pi / 180.0;

    // Vertical stripes (0° or 180°)
    if (normalizedAngle == 0 || normalizedAngle == 180) {
      for (var x = -size.width; x < size.width * 2; x += gap) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
        );
      }
      return;
    }

    // Horizontal stripes (90° or 270°)
    if (normalizedAngle == 90 || normalizedAngle == 270) {
      for (var y = -size.height; y < size.height * 2; y += gap) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          paint,
        );
      }
      return;
    }

    // Generic diagonal stripes
    // To cover the whole area, use the diagonal as the line length
    final lineLength = size.width * 2;
    final dx = lineLength * math.cos(radians);
    final dy = lineLength * math.sin(radians);
    for (var y = -size.height; y < size.height + lineLength; y += gap) {
      final start = Offset(0, y);
      final end = Offset(dx, y + dy);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
