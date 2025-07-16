import 'package:flutter/material.dart';

/// A [CustomPainter] that fills the area with a polka dot pattern.
///
/// The pattern consists of evenly spaced circles (dots) arranged in rows and columns.
/// You can configure the color, number of dots per row, gap, and maximum dot radius.
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   painter: CirclePoisPatternPainter(
///     color: Colors.red,
///     dotsPerRow: 4,
///     minSpacing: 2.0,
///     maxDotRadius: 5.0,
///   ),
/// )
/// ```
class CirclePoisPatternPainter extends CustomPainter {
  CirclePoisPatternPainter({
    this.color = Colors.black,
    this.dotsPerRow = 2,
    this.gap = 1.0,
    this.maxDotRadius = 3.0,
  });

  /// The color of the dots.
  final Color color;

  /// Number of dots per row.
  final int dotsPerRow;

  /// The gap between dots, in logical pixels.
  final double gap;

  /// Maximum radius for each dot, in logical pixels.
  final double maxDotRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (dotsPerRow <= 0) return;

    const horizontalPadding = 2.0; // horizontal padding
    const interDotPadding = 5.0; // padding between dots
    const verticalPadding = 1.0; // vertical padding

    final totalWidth = size.width;
    final totalHeight = size.height;

    // Calculate the maximum radius to respect horizontal and vertical padding
    double maxRadiusByWidth;
    if (dotsPerRow == 1) {
      maxRadiusByWidth = (totalWidth - 2 * horizontalPadding) / 2;
    } else {
      maxRadiusByWidth = (totalWidth -
              2 * horizontalPadding -
              interDotPadding * (dotsPerRow - 1)) /
          (2 * dotsPerRow);
    }

    var dotRadius = maxRadiusByWidth;
    dotRadius = dotRadius < maxDotRadius ? dotRadius : maxDotRadius;
    if (dotRadius <= 0) return;

    // Calculate the maximum number of vertical dots that fit
    final availableHeight = totalHeight - 2 * verticalPadding;
    final n = ((availableHeight + interDotPadding) /
            (2 * dotRadius + interDotPadding))
        .floor();
    if (n <= 0) return;

    // Calculate the offset to center the dots vertically
    final occupied = n * 2 * dotRadius + (n - 1) * interDotPadding;
    final offsetY =
        verticalPadding + (availableHeight - occupied) / 2 + dotRadius;

    final spacing =
        (totalWidth - 2 * horizontalPadding - 2 * dotRadius) / (dotsPerRow - 1);

    for (var i = 0; i < n; i++) {
      final dy = offsetY + i * (2 * dotRadius + interDotPadding);
      for (var j = 0; j < dotsPerRow; j++) {
        final dx = dotsPerRow == 1
            ? totalWidth / 2
            : horizontalPadding + dotRadius + j * spacing;
        canvas.drawCircle(
          Offset(dx, dy),
          dotRadius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
