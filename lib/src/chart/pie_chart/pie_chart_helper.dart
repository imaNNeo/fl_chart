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
    final effRadius = (r * r) /
        math.sqrt(
          math.pow(r * math.sin(startRadians), 2) +
              math.pow(r * math.cos(startRadians), 2),
        );

    // Calculate effective padding value.
    final effIndent = math.min(indent, r / 2);

    // Calculate angle adjustments.
    final angleAdjustment = effIndent / effRadius;

    // Calculate effective angles with padding.
    final effectiveStartRadians =
        startRadians + (sweepRadians > 0 ? angleAdjustment : -angleAdjustment);
    final effectiveEndRadians =
        endRadians - (sweepRadians > 0 ? angleAdjustment : -angleAdjustment);
    final effectiveSweepRadians = effectiveEndRadians - effectiveStartRadians;

    // Coordinates of the start point.
    final startX = center.dx + r * math.cos(effectiveStartRadians);
    final startY = center.dy + r * math.sin(effectiveStartRadians);

    // Coordinates of the end point.
    final endX = center.dx + r * math.cos(effectiveEndRadians);
    final endY = center.dy + r * math.sin(effectiveEndRadians);

    return PieChartArcMeta(
      Offset(startX, startY),
      Offset(endX, endY),
      effectiveStartRadians,
      effectiveSweepRadians,
      effectiveEndRadians,
      Radius.circular(effIndent),
    );
  }

  final Offset from;
  final Offset to;
  final double startRadians;
  final double sweepRadians;
  final double endRadians;
  final Radius radius;
}
