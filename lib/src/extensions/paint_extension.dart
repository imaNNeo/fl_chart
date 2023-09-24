import 'package:flutter/material.dart';

extension PaintExtension on Paint {
  /// Hides the paint's color, if strokeWidth is zero
  void transparentIfWidthIsZero() {
    if (strokeWidth == 0) {
      shader = null;
      color = color.withOpacity(0);
    }
  }

  void setColorOrGradient(Color? color, Gradient? gradient, Rect rect) {
    if (gradient != null) {
      this.color = Colors.black;
      shader = gradient.createShader(rect);
    } else {
      this.color = color ?? Colors.transparent;
      shader = null;
    }
  }

  void setColorOrGradientForLine(
    Color? color,
    Gradient? gradient, {
    required Offset from,
    required Offset to,
  }) {
    final rect = Rect.fromPoints(from, to);
    setColorOrGradient(color, gradient, rect);
  }
}
