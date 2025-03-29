import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/line.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_data.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_helper.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// Paints [PieChartData] in the canvas, it can be used in a [CustomPainter]
class PieChartPainter extends BaseChartPainter<PieChartData> {
  /// Paints [dataList] into canvas, it is the animating [PieChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [dataList] is changing constantly.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  PieChartPainter() : super() {
    _sectionPaint = Paint()..style = PaintingStyle.stroke;

    _sectionSaveLayerPaint = Paint();

    _sectionStrokePaint = Paint()..style = PaintingStyle.stroke;

    _centerSpacePaint = Paint()..style = PaintingStyle.fill;

    _clipPaint = Paint();
  }

  late Paint _sectionPaint;
  late Paint _sectionSaveLayerPaint;
  late Paint _sectionStrokePaint;
  late Paint _centerSpacePaint;
  late Paint _clipPaint;

  /// Paints [PieChartData] into the provided canvas.
  @override
  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<PieChartData> holder,
  ) {
    super.paint(context, canvasWrapper, holder);
    final data = holder.data;
    if (data.sections.isEmpty) {
      return;
    }

    final sectionsAngle = calculateSectionsAngle(data.sections, data.sumValue);
    final centerRadius = calculateCenterRadius(canvasWrapper.size, holder);

    drawCenterSpace(canvasWrapper, centerRadius, holder);
    drawSections(canvasWrapper, sectionsAngle, centerRadius, holder);
    drawTexts(context, canvasWrapper, holder, centerRadius);
  }

  @visibleForTesting
  List<double> calculateSectionsAngle(
    List<PieChartSectionData> sections,
    double sumValue,
  ) {
    if (sumValue == 0) {
      return List<double>.filled(sections.length, 0);
    }

    return sections.map((section) {
      return 360 * (section.value / sumValue);
    }).toList();
  }

  @visibleForTesting
  void drawCenterSpace(
    CanvasWrapper canvasWrapper,
    double centerRadius,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final centerX = viewSize.width / 2;
    final centerY = viewSize.height / 2;

    _centerSpacePaint.color = data.centerSpaceColor;
    canvasWrapper.drawCircle(
      Offset(centerX, centerY),
      centerRadius,
      _centerSpacePaint,
    );
  }

  @visibleForTesting
  void drawSections(
    CanvasWrapper canvasWrapper,
    List<double> sectionsAngle,
    double centerRadius,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;

    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = data.startDegreeOffset;

    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      if (section.value == 0) {
        continue;
      }
      final sectionDegree = sectionsAngle[i];

      if (sectionDegree == 360) {
        final radius = centerRadius + section.radius / 2;
        final rect = Rect.fromCircle(center: center, radius: radius);
        _sectionPaint
          ..setColorOrGradient(
            section.color,
            section.gradient,
            rect,
          )
          ..strokeWidth = section.radius
          ..style = PaintingStyle.fill;

        final bounds = Rect.fromCircle(
          center: center,
          radius: centerRadius + section.radius,
        );
        canvasWrapper
          ..saveLayer(bounds, _sectionSaveLayerPaint)
          ..drawCircle(
            center,
            centerRadius + section.radius,
            _sectionPaint..blendMode = BlendMode.srcOver,
          )
          ..drawCircle(
            center,
            centerRadius,
            _sectionPaint..blendMode = BlendMode.srcOut,
          )
          ..restore();
        _sectionPaint.blendMode = BlendMode.srcOver;
        if (section.borderSide.width != 0.0 &&
            section.borderSide.color.a != 0.0) {
          _sectionStrokePaint
            ..strokeWidth = section.borderSide.width
            ..color = section.borderSide.color;
          // Outer
          canvasWrapper
            ..drawCircle(
              center,
              centerRadius + section.radius - (section.borderSide.width / 2),
              _sectionStrokePaint,
            )

            // Inner
            ..drawCircle(
              center,
              centerRadius + (section.borderSide.width / 2),
              _sectionStrokePaint,
            );
        }
        return;
      }

      final sectionPath = generateSectionPath(
        section,
        data.sectionsSpace,
        tempAngle,
        sectionDegree,
        center,
        centerRadius,
        canvasWrapper,
      );

      drawSection(section, sectionPath, canvasWrapper);
      drawSectionStroke(section, sectionPath, canvasWrapper, viewSize);
      tempAngle += sectionDegree;
    }
  }

  /// Generates a path around a section
  @visibleForTesting
  Path generateSectionPath(
    PieChartSectionData section,
    double sectionSpace,
    double tempAngle,
    double sectionDegree,
    Offset center,
    double centerRadius, [
    CanvasWrapper? canvasWrapper,
  ]) {
    final utils = Utils();

    // Create proxy variables that can be modified to create space
    // between sections when `sectionSpace != 0`.
    var outerStartAngle = tempAngle;
    var outerSweepAngle = sectionDegree;

    var innerStartAngle = tempAngle;
    var innerSweepAngle = sectionDegree;

    final sectionRadius = centerRadius + section.radius;
    final sectionRadiusRect = Rect.fromCircle(
      center: center,
      radius: sectionRadius,
    );

    final centerRadiusRect = Rect.fromCircle(
      center: center,
      radius: centerRadius,
    );

    if (sectionSpace != 0) {
      // Calculate outer space angle
      final outerSpaceAngleDegrees =
          utils.degrees(sectionSpace / sectionRadius);

      // Adjust angles to create gaps for outer arc
      outerStartAngle += outerSpaceAngleDegrees / 2;
      outerSweepAngle -= outerSpaceAngleDegrees;

      // Calculate inner space angle if centerRadius > 0
      if (centerRadius > 0) {
        final innerSpaceAngleDegrees =
            utils.degrees(sectionSpace / centerRadius);

        // Adjust angles for inner arc
        innerStartAngle += innerSpaceAngleDegrees / 2;
        innerSweepAngle -= innerSpaceAngleDegrees;
      } else {
        // If no inner radius, use the same angles
        innerStartAngle = outerStartAngle;
        innerSweepAngle = outerSweepAngle;
      }
    }

    final outerStartRadians = utils.radians(outerStartAngle);
    final outerSweepRadians = utils.radians(outerSweepAngle);
    final outerEndRadians = outerStartRadians + outerSweepRadians;

    // Calculate inner arc angles
    final innerStartRadians = utils.radians(innerStartAngle);
    final innerSweepRadians = utils.radians(innerSweepAngle);
    final innerEndRadians = innerStartRadians + innerSweepRadians;

    final outerStartLineDirection = Offset(
      math.cos(outerStartRadians),
      math.sin(outerStartRadians),
    );

    final innerStartLineDirection = Offset(
      math.cos(innerStartRadians),
      math.sin(innerStartRadians),
    );

    // Adjust section center to add empty space from center.
    var sectionCenter = center;
    if (centerRadius == 0 && sectionSpace != 0) {
      // Calculate the midpoint angle of the section
      final midAngleRadians = outerStartRadians + (outerSweepRadians / 2);
      // Calculate offset direction from center
      final offsetDirection = Offset(
        math.cos(midAngleRadians),
        math.sin(midAngleRadians),
      );
      // Adjust the center by half the section space
      sectionCenter = center + offsetDirection * (sectionSpace / 2);
    }

    var startLineFrom = sectionCenter + innerStartLineDirection * centerRadius;
    final startLineTo = center + outerStartLineDirection * sectionRadius;

    final outerEndLineDirection =
        Offset(math.cos(outerEndRadians), math.sin(outerEndRadians));
    final innerEndLineDirection =
        Offset(math.cos(innerEndRadians), math.sin(innerEndRadians));

    var endLineFrom = sectionCenter + innerEndLineDirection * centerRadius;
    final endLineTo = center + outerEndLineDirection * sectionRadius;

    Path sectionPath;
    final borderRadius = section.borderRadius;

    // Calculate intersection point of start and end lines
    final intersectionPoint = _findIntersection(
      startLineFrom,
      startLineTo,
      endLineFrom,
      endLineTo,
    );

    // If there's a valid intersection point, adjust the starting points.
    if (intersectionPoint != null && section.title == 'x') {
      startLineFrom = intersectionPoint;
      endLineFrom = intersectionPoint;
    }

    // Avoids excessive calculations when `borderRadius` is set to 0.
    if (borderRadius == 0) {
      final startLine = Line(startLineFrom, startLineTo);
      final endLine = Line(endLineFrom, endLineTo);

      sectionPath = Path()
        ..moveTo(startLine.from.dx, startLine.from.dy)
        ..lineTo(startLine.to.dx, startLine.to.dy)
        ..arcTo(sectionRadiusRect, outerStartRadians, outerSweepRadians, false)
        ..lineTo(endLine.from.dx, endLine.from.dy);

      if (intersectionPoint == null) {
        sectionPath.arcTo(
          centerRadiusRect,
          innerEndRadians,
          -innerSweepRadians,
          false,
        );
      }

      sectionPath.close();
    } else {
      final radius = Radius.circular(borderRadius);
      final startLine = Line(startLineFrom, startLineTo).subtract(borderRadius);
      final endLine = Line(endLineFrom, endLineTo).subtract(borderRadius);

      // Start drawing the section path.
      sectionPath = Path()
        ..moveTo(startLine.from.dx, startLine.from.dy)
        ..lineTo(startLine.to.dx, startLine.to.dy);

      final outerArc = PieChartArcMeta.compute(
        radiusRect: sectionRadiusRect,
        startRadians: outerStartRadians,
        sweepRadians: outerSweepRadians,
        borderRadius: borderRadius,
      );

      // Draw the outer arc.
      if (outerArc.hasArcCorners) {
        sectionPath
          ..arcToPoint(outerArc.from, radius: outerArc.radius)
          ..arcTo(
            sectionRadiusRect,
            outerArc.startRadians,
            outerArc.sweepRadians,
            false,
          )
          ..arcToPoint(endLine.to, radius: outerArc.radius);
      }
      // Custom logic for a case when `borderRadius` is greater than the
      // section's width.
      else {
        final controlStart =
            Line(startLineFrom, startLineTo).subtract(-borderRadius * 0.5);
        final controlEnd =
            Line(endLineFrom, endLineTo).subtract(-borderRadius * 0.5);

        final controlPoint1 = Offset(
          controlStart.to.dx,
          controlStart.to.dy,
        );

        final controlPoint2 = Offset(
          controlStart.to.dx + (controlEnd.to.dx - controlStart.to.dx),
          controlStart.to.dy + (controlEnd.to.dy - controlStart.to.dy),
        );

        sectionPath.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          endLine.to.dx,
          endLine.to.dy,
        );
      }

      // Draw the second line of a section.
      sectionPath.lineTo(endLine.from.dx, endLine.from.dy);

      // Compute inner arc only if `centerRadius` is greater than 0.
      final innerArc = centerRadius > 0
          ? PieChartArcMeta.compute(
              radiusRect: centerRadiusRect,
              startRadians: innerEndRadians,
              sweepRadians: -innerSweepRadians,
              borderRadius: borderRadius,
            )
          : null;

      // Handles a case when `centerRadius == 0` (there is no inner arc).
      if (innerArc == null) {
        sectionPath
          ..arcTo(centerRadiusRect, innerEndRadians, -innerSweepRadians, false)
          ..close();
      }
      // Regular rounded corners for the inner arc.
      else if (innerArc.hasArcCorners) {
        sectionPath
          ..arcToPoint(innerArc.from, radius: radius)
          ..arcTo(
            centerRadiusRect,
            innerArc.startRadians,
            innerArc.sweepRadians,
            false,
          )
          ..arcToPoint(startLine.from, radius: radius)
          ..close();
      }
      // Custom logic for a case when `borderRadius` is greater than the
      // section's width.
      else {
        final controlStart =
            Line(endLineFrom, endLineTo).subtract(-borderRadius * 0.5);
        final controlEnd =
            Line(startLineFrom, startLineTo).subtract(-borderRadius * 0.5);

        final controlPoint1 = Offset(
          controlEnd.from.dx + (controlStart.from.dx - controlEnd.from.dx),
          controlEnd.from.dy + (controlStart.from.dy - controlEnd.from.dy),
        );

        final controlPoint2 = Offset(
          controlEnd.from.dx,
          controlEnd.from.dy,
        );

        sectionPath.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          startLine.from.dx,
          startLine.from.dy,
        );
      }
    }

    return sectionPath;
  }

  /// Creates a rect around a narrow line
  @visibleForTesting
  Path createRectPathAroundLine(Line line, double width) {
    width = width / 2;
    final normalized = line.normalize();

    final verticalAngle = line.direction() + (math.pi / 2);
    final verticalDirection =
        Offset(math.cos(verticalAngle), math.sin(verticalAngle));

    final startPoint1 = Offset(
      line.from.dx -
          (normalized * (width / 2)).dx -
          (verticalDirection * width).dx,
      line.from.dy -
          (normalized * (width / 2)).dy -
          (verticalDirection * width).dy,
    );

    final startPoint2 = Offset(
      line.to.dx +
          (normalized * (width / 2)).dx -
          (verticalDirection * width).dx,
      line.to.dy +
          (normalized * (width / 2)).dy -
          (verticalDirection * width).dy,
    );

    final startPoint3 = Offset(
      startPoint2.dx + (verticalDirection * (width * 2)).dx,
      startPoint2.dy + (verticalDirection * (width * 2)).dy,
    );

    final startPoint4 = Offset(
      startPoint1.dx + (verticalDirection * (width * 2)).dx,
      startPoint1.dy + (verticalDirection * (width * 2)).dy,
    );

    return Path()
      ..moveTo(startPoint1.dx, startPoint1.dy)
      ..lineTo(startPoint2.dx, startPoint2.dy)
      ..lineTo(startPoint3.dx, startPoint3.dy)
      ..lineTo(startPoint4.dx, startPoint4.dy)
      ..lineTo(startPoint1.dx, startPoint1.dy);
  }

  @visibleForTesting
  void drawSection(
    PieChartSectionData section,
    Path sectionPath,
    CanvasWrapper canvasWrapper,
  ) {
    _sectionPaint
      ..setColorOrGradient(
        section.color,
        section.gradient,
        sectionPath.getBounds(),
      )
      ..style = PaintingStyle.fill;
    canvasWrapper.drawPath(sectionPath, _sectionPaint);
  }

  @visibleForTesting
  void drawSectionStroke(
    PieChartSectionData section,
    Path sectionPath,
    CanvasWrapper canvasWrapper,
    Size viewSize,
  ) {
    if (section.borderSide.width != 0.0 && section.borderSide.color.a != 0.0) {
      canvasWrapper
        ..saveLayer(
          Rect.fromLTWH(0, 0, viewSize.width, viewSize.height),
          _clipPaint,
        )
        ..clipPath(sectionPath);

      _sectionStrokePaint
        ..strokeWidth = section.borderSide.width * 2
        ..color = section.borderSide.color;
      canvasWrapper
        ..drawPath(
          sectionPath,
          _sectionStrokePaint,
        )
        ..restore();
    }
  }

  /// Calculates layout of overlaying elements, includes:
  /// - title text
  /// - badge widget positions
  @visibleForTesting
  void drawTexts(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<PieChartData> holder,
    double centerRadius,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = data.startDegreeOffset;

    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      if (section.value == 0) {
        continue;
      }
      final startAngle = tempAngle;
      final sweepAngle = 360 * (section.value / data.sumValue);
      final sectionCenterAngle = startAngle + (sweepAngle / 2);

      double? rotateAngle;
      if (data.titleSunbeamLayout) {
        if (sectionCenterAngle >= 90 && sectionCenterAngle <= 270) {
          rotateAngle = sectionCenterAngle - 180;
        } else {
          rotateAngle = sectionCenterAngle;
        }
      }

      Offset sectionCenter(double percentageOffset) =>
          center +
          Offset(
            math.cos(Utils().radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
            math.sin(Utils().radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
          );

      final sectionCenterOffsetTitle =
          sectionCenter(section.titlePositionPercentageOffset);

      if (section.showTitle) {
        final span = TextSpan(
          style: Utils().getThemeAwareTextStyle(context, section.titleStyle),
          text: section.title,
        );
        final tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          textScaler: holder.textScaler,
        )..layout();

        canvasWrapper.drawText(
          tp,
          sectionCenterOffsetTitle - Offset(tp.width / 2, tp.height / 2),
          rotateAngle,
        );
      }

      tempAngle += sweepAngle;
    }
  }

  /// Calculates center radius based on the provided sections radius
  @visibleForTesting
  double calculateCenterRadius(
    Size viewSize,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    if (data.centerSpaceRadius.isFinite) {
      return data.centerSpaceRadius;
    }
    final maxRadius =
        data.sections.reduce((a, b) => a.radius > b.radius ? a : b).radius;
    return (viewSize.shortestSide - (maxRadius * 2)) / 2;
  }

  /// Makes a [PieTouchedSection] based on the provided [localPosition]
  ///
  /// Processes [localPosition] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [PieTouchedSection] from the elements that has been touched.
  PieTouchedSection handleTouch(
    Offset localPosition,
    Size viewSize,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final sectionsAngle = calculateSectionsAngle(data.sections, data.sumValue);
    final centerRadius = calculateCenterRadius(viewSize, holder);

    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    final touchedPoint2 = localPosition - center;

    final touchX = touchedPoint2.dx;
    final touchY = touchedPoint2.dy;

    final touchR = math.sqrt(math.pow(touchX, 2) + math.pow(touchY, 2));
    var touchAngle = Utils().degrees(math.atan2(touchY, touchX));
    touchAngle = touchAngle < 0 ? (180 - touchAngle.abs()) + 180 : touchAngle;

    PieChartSectionData? foundSectionData;
    var foundSectionDataPosition = -1;

    var tempAngle = data.startDegreeOffset;
    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final sectionAngle = sectionsAngle[i];

      if (sectionAngle == 360) {
        final distance = math.sqrt(
          math.pow(localPosition.dx - center.dx, 2) +
              math.pow(localPosition.dy - center.dy, 2),
        );
        if (distance >= centerRadius &&
            distance <= section.radius + centerRadius) {
          foundSectionData = section;
          foundSectionDataPosition = i;
        }
        break;
      }

      final sectionPath = generateSectionPath(
        section,
        data.sectionsSpace,
        tempAngle,
        sectionAngle,
        center,
        centerRadius,
      );

      if (sectionPath.contains(localPosition)) {
        foundSectionData = section;
        foundSectionDataPosition = i;
        break;
      }

      tempAngle += sectionAngle;
    }

    return PieTouchedSection(
      foundSectionData,
      foundSectionDataPosition,
      touchAngle,
      touchR,
    );
  }

  /// Exposes offset for laying out the badge widgets upon the chart.
  Map<int, Offset> getBadgeOffsets(
    Size viewSize,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final center = viewSize.center(Offset.zero);
    final badgeWidgetsOffsets = <int, Offset>{};

    if (data.sections.isEmpty) {
      return badgeWidgetsOffsets;
    }

    var tempAngle = data.startDegreeOffset;

    final sectionsAngle = calculateSectionsAngle(data.sections, data.sumValue);
    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final startAngle = tempAngle;
      final sweepAngle = sectionsAngle[i];
      final sectionCenterAngle = startAngle + (sweepAngle / 2);
      final centerRadius = calculateCenterRadius(viewSize, holder);

      Offset sectionCenter(double percentageOffset) =>
          center +
          Offset(
            math.cos(Utils().radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
            math.sin(Utils().radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
          );

      final sectionCenterOffsetBadgeWidget =
          sectionCenter(section.badgePositionPercentageOffset);

      badgeWidgetsOffsets[i] = sectionCenterOffsetBadgeWidget;

      tempAngle += sweepAngle;
    }

    return badgeWidgetsOffsets;
  }

  /// Helper function to find intersection of two line segments
  Offset? _findIntersection(Offset a, Offset b, Offset c, Offset d) {
    // Line AB represented as a1x + b1y = c1
    final a1 = b.dy - a.dy;
    final b1 = a.dx - b.dx;
    final c1 = a1 * a.dx + b1 * a.dy;

    // Line CD represented as a2x + b2y = c2
    final a2 = d.dy - c.dy;
    final b2 = c.dx - d.dx;
    final c2 = a2 * c.dx + b2 * c.dy;

    final determinant = a1 * b2 - a2 * b1;

    // If determinant is zero, lines are parallel or coincident
    if (determinant == 0) {
      return null;
    }

    // Calculate intersection point
    final x = (b2 * c1 - b1 * c2) / determinant;
    final y = (a1 * c2 - a2 * c1) / determinant;
    final point = Offset(x, y);

    // Check if intersection point is on both line segments
    if (_isPointOnLineSegment(a, b, point) &&
        _isPointOnLineSegment(c, d, point)) {
      return point;
    }

    return null;
  }

  /// Helper function to check if a point is on a line segment
  bool _isPointOnLineSegment(Offset a, Offset b, Offset p) {
    // Check if point is within the bounding box of the line segment
    if (p.dx < math.min(a.dx, b.dx) ||
        p.dx > math.max(a.dx, b.dx) ||
        p.dy < math.min(a.dy, b.dy) ||
        p.dy > math.max(a.dy, b.dy)) {
      return false;
    }

    // Check if point is on the line
    final crossProduct =
        (p.dy - a.dy) * (b.dx - a.dx) - (p.dx - a.dx) * (b.dy - a.dy);

    // Allow for floating point precision errors
    return crossProduct.abs() < 1e-10;
  }
}
