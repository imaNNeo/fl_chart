import 'dart:ui';

import 'package:flutter/material.dart';

/// Simple dot pattern configuration for improved accessibility and contrast.
///
/// When enabled, dots are drawn over the segment using a stable, world-aligned
/// grid, clipped to the segment path to avoid flickering on repaints.
class DotPattern {
  const DotPattern({
    required Color color,
    double spacing = 6,
    double dotRadius = 1.5,
    Offset phase = Offset.zero,
  }) : this._(
          enabled: true,
          color: color,
          spacing: spacing,
          dotRadius: dotRadius,
          phase: phase,
        );

  const DotPattern._({
    required this.enabled,
    required this.color,
    required this.spacing,
    required this.dotRadius,
    this.phase = Offset.zero,
  });

  const DotPattern.disabled()
      : this._(
          enabled: false,
          color: Colors.transparent,
          spacing: 0,
          dotRadius: 0,
          phase: Offset.zero,
        );

  final bool enabled;
  final Color color;
  final double spacing;
  final double dotRadius;
  final Offset phase;

  static DotPattern lerp(DotPattern a, DotPattern b, double t) {
    return DotPattern(
      color: Color.lerp(a.color, b.color, t) ?? a.color,
      spacing: lerpDouble(a.spacing, b.spacing, t)!,
      dotRadius: lerpDouble(a.dotRadius, b.dotRadius, t)!,
      phase: Offset(
        lerpDouble(a.phase.dx, b.phase.dx, t)!,
        lerpDouble(a.phase.dy, b.phase.dy, t)!,
      ),
    );
  }

  DotPattern copyWith({
    bool? enabled,
    Color? color,
    double? spacing,
    double? dotRadius,
    Offset? phase,
  }) {
    if (enabled == false) return const DotPattern.disabled();
    return DotPattern(
      color: color ?? this.color,
      spacing: spacing ?? this.spacing,
      dotRadius: dotRadius ?? this.dotRadius,
      phase: phase ?? this.phase,
    );
  }
}
