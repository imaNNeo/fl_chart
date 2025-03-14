import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Describes a line model (contains [from], and end [to])
class Line {
  const Line(this.from, this.to);

  /// Start of the line
  final Offset from;

  /// End of the line
  final Offset to;

  /// Returns the length of line
  double magnitude() {
    final diff = to - from;
    final dx = diff.dx;
    final dy = diff.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Returns angle of the line in radians
  double direction() {
    final diff = to - from;
    return math.atan(diff.dy / diff.dx);
  }

  /// Returns the line in magnitude of 1.0
  Offset normalize() {
    final diffOffset = to - from;
    return diffOffset * (1.0 / magnitude());
  }

  /// Returns a new [Line] that is shortened by [value] from both ends.
  Line subtract(double value) {
    if (value == 0) {
      return Line(from, to);
    }

    final normalized = normalize();
    return Line(
      from + (normalized * value),
      to - (normalized * value),
    );
  }
}
