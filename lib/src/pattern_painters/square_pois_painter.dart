import 'package:flutter/material.dart';

/// A [CustomPainter] that fills the area with a square polka dot pattern.
///
/// The pattern consists of evenly spaced squares arranged in rows and columns.
/// You can configure the color, number of squares per row, minimum spacing, and maximum square size.
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   painter: SquarePoisPatternPainter(
///     color: Colors.green,
///     squaresPerRow: 4,
///     gap: 2.0,
///     maxSquareSize: 6.0,
///   ),
/// )
/// ```
class SquarePoisPatternPainter extends CustomPainter {
  SquarePoisPatternPainter({
    this.color = Colors.black,
    this.squaresPerRow = 3,
    this.gap = 2.0,
    this.maxSquareSize = 4.0,
  });

  /// The color of the squares.
  final Color color;

  /// Number of squares per row.
  final int squaresPerRow;

  /// The gap between squares, in logical pixels.
  final double gap;

  /// Maximum size for each square's side, in logical pixels.
  final double maxSquareSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (squaresPerRow <= 0) return;

    const horizontalPadding = 2.0; // horizontal padding
    const verticalPadding = 1.0; // vertical padding

    final totalWidth = size.width;
    final totalHeight = size.height;

    // Calculate the maximum square side to respect horizontal padding and gap
    double maxSizeByWidth;
    if (squaresPerRow == 1) {
      maxSizeByWidth = totalWidth - 2 * horizontalPadding;
    } else {
      maxSizeByWidth =
          (totalWidth - 2 * horizontalPadding - gap * (squaresPerRow - 1)) /
              squaresPerRow;
    }

    var squareSize = maxSizeByWidth;
    squareSize = squareSize < maxSquareSize ? squareSize : maxSquareSize;
    if (squareSize <= 0) return;

    // Calculate the maximum number of vertical rows that fit
    final availableHeight = totalHeight - 2 * verticalPadding;
    final n = ((availableHeight + gap) / (squareSize + gap)).floor();
    if (n <= 0) return;

    // Calculate the offset to center the squares vertically
    final occupied = n * squareSize + (n - 1) * gap;
    final offsetY = verticalPadding + (availableHeight - occupied) / 2;

    final spacing = squaresPerRow > 1
        ? (totalWidth - 2 * horizontalPadding - squareSize) /
            (squaresPerRow - 1)
        : 0;

    for (var i = 0; i < n; i++) {
      final top = offsetY + i * (squareSize + gap);
      for (var j = 0; j < squaresPerRow; j++) {
        final left = squaresPerRow == 1
            ? (totalWidth - squareSize) / 2
            : horizontalPadding + j * spacing;
        canvas.drawRect(
          Rect.fromLTWH(left, top, squareSize, squareSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
