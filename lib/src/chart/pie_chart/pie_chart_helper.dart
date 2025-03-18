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
  const PieChartArcMeta(
    this.from,
    this.to,
    this.startRadians,
    this.sweepRadians,
    this.endRadians,
    this.radius,
  );

  factory PieChartArcMeta.compute(
    Rect radiusRect,
    double startRadians,
    double sweepRadians,
    double indent,
  ) {
    // `radiusRect` is based on `Rect.fromCircle` (i.e. is a square).
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
        ? (indent / effectiveRadius)
        : -(indent / effectiveRadius);

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
      Radius.circular(indent),
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
