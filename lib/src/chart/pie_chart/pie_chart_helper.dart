import 'dart:math' as math;

import 'package:fl_chart/src/chart/pie_chart/pie_chart_data.dart';
import 'package:flutter/widgets.dart';

extension PieChartSectionDataListExtension on List<PieChartSectionData> {
  List<Widget> toWidgets() {
    final widgets = List<Widget>.filled(length, Container());
    var allWidgetsAreNull = true;
    asMap().entries.forEach((e) {
      final index = e.key;
      final section = e.value;
      if (section.badgeWidget != null) {
        widgets[index] = section.badgeWidget!;
        allWidgetsAreNull = false;
      }
    });
    if (allWidgetsAreNull) {
      return List.empty();
    }
    return widgets;
  }
}

/// Information that describes the arc of pie chart section.
/// Used for drawing rounded corners of sections.
class PieChartArcMeta {
  /// Creates a new instance of [PieChartArcMeta].
  const PieChartArcMeta(
    this.from,
    this.to,
    this.startRadians,
    this.sweepRadians,
    this.endRadians,
    this.radius,
  );

  /// Computes the arc metadata.
  ///
  /// - [radiusRect] is based on `Rect.fromCircle` (i.e. must be a square).
  /// - [startRadians] is the starting angle of the section.
  /// - [sweepRadians] is the sweep angle of the section.
  /// - [borderRadius] is the space reserved for an arc.
  /// - [space] is the space between sections.
  factory PieChartArcMeta.compute({
    required Rect radiusRect,
    required double startRadians,
    required double sweepRadians,
    required double borderRadius,
  }) {
    assert(
      // It must be rounded since the precision of `double` may result in
      // false positives (e.g. width = 240.0 && height = 240.00000000000003).
      radiusRect.width.round() == radiusRect.height.round(),
      '`radiusRect` should be a square.',
    );

    final diameter = radiusRect.width;
    final center = radiusRect.center;
    final r = diameter / 2;

    final endRadians = startRadians + sweepRadians;

    // Calculate effective radius at start and end angles.
    final effectiveRadius = (r * r) /
        math.sqrt(
          math.pow(r * math.sin(startRadians), 2) +
              math.pow(r * math.cos(startRadians), 2),
        );

    // Calculate angle adjustments.
    final angleAdjustment = sweepRadians > 0
        ? (borderRadius / effectiveRadius)
        : -(borderRadius / effectiveRadius);

    // Calculate effective angles with padding.
    final effectiveStartRadians = startRadians + angleAdjustment;
    final effectiveEndRadians = endRadians - angleAdjustment;
    final effectiveSweepRadians = effectiveEndRadians - effectiveStartRadians;

    // Coordinates of the start point.
    final start = Offset(
      center.dx + r * math.cos(effectiveStartRadians),
      center.dy + r * math.sin(effectiveStartRadians),
    );

    // Coordinates of the end point.
    final end = Offset(
      center.dx + r * math.cos(effectiveEndRadians),
      center.dy + r * math.sin(effectiveEndRadians),
    );

    // If `effectiveSweepRadians` has a different sign than `sweepRadians` we
    // have to draw a circle instead of an arc (there is no enough space to draw
    // an arc as it exceeds the bounds).
    final hasArcCorners =
        sweepRadians.isNegative == effectiveSweepRadians.isNegative;

    return PieChartArcMeta(
      start,
      end,
      effectiveStartRadians,
      hasArcCorners ? effectiveSweepRadians : 0.0,
      effectiveEndRadians,
      Radius.circular(borderRadius),
    );
  }

  final Offset from;
  final Offset to;
  final double startRadians;
  final double sweepRadians;
  final double endRadians;
  final Radius radius;

  /// Whether the section is big enough to draw corners with an arc.
  bool get hasArcCorners => sweepRadians != 0;
}
