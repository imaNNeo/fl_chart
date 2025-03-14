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
  );

  factory PieChartArcMeta.compute(
    Rect sectionRadiusRect,
    double startRadians,
    double sweepRadians,
    double indent,
  ) {
    // FIXME: It sometimes looks weird??

    // `sectionRadiusRect` is based on `Rect.fromCircle` (i.e. is a square).
    final size = sectionRadiusRect.width;
    final center = sectionRadiusRect.center;
    final r = size / 2;
    final endRadians = startRadians + sweepRadians;

    // Calculate effective radius at start and end angles.
    final effRadius = (r * r) /
        math.sqrt(
          math.pow(r * math.sin(startRadians), 2) +
              math.pow(r * math.cos(startRadians), 2),
        );

    // Calculate angle adjustments.
    final startAngleAdjustment = indent / effRadius;
    final endAngleAdjustment = indent / effRadius;

    // Calculate effective angles with padding.
    final effectiveStartRadians = startRadians +
        (sweepRadians > 0 ? startAngleAdjustment : -startAngleAdjustment);
    final effectiveEndRadians = endRadians -
        (sweepRadians > 0 ? endAngleAdjustment : -endAngleAdjustment);
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
    );
  }

  final Offset from;
  final Offset to;
  final double startRadians;
  final double sweepRadians;
  final double endRadians;
}
