import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/line.dart';
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

    _sectionStrokePaint = Paint()..style = PaintingStyle.stroke;

    _centerSpacePaint = Paint()..style = PaintingStyle.fill;

    _clipPaint = Paint();
  }
  static const double _kRadiusSafetyMargin = 0.499;

  late Paint _sectionPaint;
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
        final fullCirclePath = generateSegmentPath(
          center,
          centerRadius,
          section.radius,
          0,
          sectionDegree,
        );
        drawSegments(
          canvasWrapper,
          section,
          fullCirclePath,
          sectionDegree,
          centerRadius,
          0,
          center,
        );

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

      if (section.value == 0 || section.radius == 0) continue;

      final sectionPath = generateSectionPath(
        section,
        data.sectionsSpace,
        tempAngle,
        sectionDegree,
        center,
        centerRadius,
      );

      canvasWrapper
        ..save()
        ..clipPath(sectionPath);

      drawSegments(
        canvasWrapper,
        section,
        sectionPath,
        sectionDegree,
        centerRadius,
        tempAngle,
        center,
      );
      canvasWrapper.restore();

      drawSectionStroke(section, sectionPath, canvasWrapper, viewSize);

      tempAngle += sectionDegree;
    }
  }

  /// Draws the main section background first, then renders stacked segments
  /// on top, similar to how [BarChartRodStackItem] works in bar charts.
  ///
  /// [mainPath] is the path for the full section fill, to avoid recalculating
  /// the same geometry. The [PieChartStackSegmentData] overlays must still be
  /// generated here since they use different radii.
  ///
  /// Each segment's [PieChartStackSegmentData.fromRadius] and
  /// [PieChartStackSegmentData.toRadius] are clamped to [0, section.radius]
  /// and rendered as overlays.
  @visibleForTesting
  void drawSegments(
    CanvasWrapper canvasWrapper,
    PieChartSectionData section,
    Path mainPath,
    double sweepAngle,
    double startRadius,
    double startAngle,
    Offset center,
  ) {
    _sectionPaint
      ..setColorOrGradient(
        section.color,
        section.gradient,
        mainPath.getBounds(),
      )
      ..style = PaintingStyle.fill;
    canvasWrapper.drawPath(mainPath, _sectionPaint);

    for (final seg in section.segments) {
      final clampedFrom = seg.fromRadius.clamp(0.0, section.radius);
      final clampedTo = seg.toRadius.clamp(0.0, section.radius);
      final segRadius = clampedTo - clampedFrom;
      if (segRadius <= 0) continue;

      final segPath = generateSegmentPath(
        center,
        startRadius + clampedFrom,
        segRadius,
        startAngle,
        sweepAngle,
      );
      drawSegment(seg, segPath, canvasWrapper);
    }
  }

  @visibleForTesting
  void drawSegment(
    PieChartStackSegmentData segment,
    Path segmentPath,
    CanvasWrapper canvasWrapper,
  ) {
    _sectionPaint
      ..setColorOrGradient(
        segment.color,
        segment.gradient,
        segmentPath.getBounds(),
      )
      ..style = PaintingStyle.fill;
    canvasWrapper.drawPath(segmentPath, _sectionPaint);
  }

  @visibleForTesting
  Path generateSegmentPath(
    Offset center,
    double innerRadius,
    double segmentRadius,
    double startAngle,
    double sweepAngle,
  ) {
    if (sweepAngle == 360) {
      return Path()
        ..addOval(
          Rect.fromCircle(
            center: center,
            radius: innerRadius + segmentRadius,
          ),
        )
        ..addOval(Rect.fromCircle(center: center, radius: innerRadius))
        ..fillType = PathFillType.evenOdd
        ..close();
    }

    final outerRadius = innerRadius + segmentRadius;
    final rectOuter = Rect.fromCircle(center: center, radius: outerRadius);
    final rectInner = Rect.fromCircle(center: center, radius: innerRadius);

    final startRadians = Utils().radians(startAngle);
    final sweepRadians = Utils().radians(sweepAngle);

    return Path()
      ..moveTo(
        center.dx + innerRadius * math.cos(startRadians),
        center.dy + innerRadius * math.sin(startRadians),
      )
      ..arcTo(rectOuter, startRadians, sweepRadians, false)
      ..lineTo(
        center.dx + innerRadius * math.cos(startRadians + sweepRadians),
        center.dy + innerRadius * math.sin(startRadians + sweepRadians),
      )
      ..arcTo(rectInner, startRadians + sweepRadians, -sweepRadians, false)
      ..close();
  }

  /// Generates a path around a section
  @visibleForTesting
  Path generateSectionPath(
    PieChartSectionData section,
    double sectionSpace,
    double tempAngle,
    double sectionDegree,
    Offset center,
    double centerRadius,
  ) {
    final sectionRadiusRect = Rect.fromCircle(
      center: center,
      radius: centerRadius + section.radius,
    );

    final centerRadiusRect = Rect.fromCircle(
      center: center,
      radius: centerRadius,
    );

    final startRadians = Utils().radians(tempAngle);
    final sweepRadians = Utils().radians(sectionDegree);
    final endRadians = startRadians + sweepRadians;

    final startLineDirection =
        Offset(math.cos(startRadians), math.sin(startRadians));

    final startLineFrom = center + startLineDirection * centerRadius;
    final startLineTo = startLineFrom + startLineDirection * section.radius;
    final startLine = Line(startLineFrom, startLineTo);

    final endLineDirection = Offset(math.cos(endRadians), math.sin(endRadians));

    final endLineFrom = center + endLineDirection * centerRadius;
    final endLineTo = endLineFrom + endLineDirection * section.radius;
    final endLine = Line(endLineFrom, endLineTo);

    Path sectionPath;

    if (section.cornerRadius > 0) {
      sectionPath = generateRoundedSectionPath(
        section,
        startRadians,
        sweepRadians,
        center,
        centerRadius,
        sectionRadiusRect,
        centerRadiusRect,
      );
    } else {
      sectionPath = Path()
        ..moveTo(startLine.from.dx, startLine.from.dy)
        ..lineTo(startLine.to.dx, startLine.to.dy)
        ..arcTo(sectionRadiusRect, startRadians, sweepRadians, false)
        ..lineTo(endLine.from.dx, endLine.from.dy)
        ..arcTo(centerRadiusRect, endRadians, -sweepRadians, false)
        ..moveTo(startLine.from.dx, startLine.from.dy)
        ..close();
    }

    /// Apply section-space separators as parallel radial cuts.
    if (sectionSpace != 0) {
      final startLineSeparatorPath = createRectPathAroundLine(
        Line(startLineFrom, startLineTo),
        sectionSpace,
      );
      try {
        sectionPath = Path.combine(
          PathOperation.difference,
          sectionPath,
          startLineSeparatorPath,
        );
      } catch (_) {
        /// It's a flutter engine issue with [Path.combine] in web-html renderer
        /// https://github.com/imaNNeo/fl_chart/issues/955
      }

      final endLineSeparatorPath =
          createRectPathAroundLine(Line(endLineFrom, endLineTo), sectionSpace);
      try {
        sectionPath = Path.combine(
          PathOperation.difference,
          sectionPath,
          endLineSeparatorPath,
        );
      } catch (_) {
        /// It's a flutter engine issue with [Path.combine] in web-html renderer
        /// https://github.com/imaNNeo/fl_chart/issues/955
      }
    }

    return sectionPath;
  }

  /// Generates a Path for a pie-section with rounded corners.
  ///
  /// This method builds a path that rounds both the outer and inner
  /// corners of a pie section (when `centerRadius > 0`). It clamps the
  /// requested `section.cornerRadius` separately for the outer and inner
  /// edges to avoid geometric overlap when the section is narrow or the
  /// radii would be too large for the available arc length.
  ///
  /// Important behaviors / notes:
  /// - If `cornerRadius <= 1` the method returns a standard (non-rounded)
  ///   section path for performance and to avoid tiny visual artifacts.
  /// - Outer and inner corner radii are clamped independently (`clampedOuterRadius`
  ///   and `clampedInnerRadius`) to reasonable maxima based on section size
  ///   and sweep angle.
  /// - The code supports `centerRadius == 0` (fully filled pie) and
  ///   `centerRadius > 0` (donut). When `centerRadius > 0` the inner
  ///   corners are rounded as well.
  /// - `sectionsSpace` trimming is applied later by subtracting separator
  ///   rectangles from the resulting path (see `generateSectionPath`).
  /// - There are known platform/engine caveats when using `Path.combine` on
  ///   web-html renderer; the subtraction steps are guarded with try/catch
  ///   where used.
  @visibleForTesting
  Path generateRoundedSectionPath(
    PieChartSectionData section,
    double startRadians,
    double sweepRadians,
    Offset center,
    double centerRadius,
    Rect sectionRadiusRect,
    Rect centerRadiusRect,
  ) {
    final endRadians = startRadians + sweepRadians;
    final outerRadius = centerRadius + section.radius;
    // User-provided corner radius (applies uniformly to this section).
    final cornerRadius = section.cornerRadius;

    final path = Path();

    if (cornerRadius <= 1) {
      // if corner radius is too small, return standard section path
      final innerStart = center +
          Offset(math.cos(startRadians), math.sin(startRadians)) * centerRadius;
      final outerStart = center +
          Offset(math.cos(startRadians), math.sin(startRadians)) * outerRadius;
      final innerEnd = center +
          Offset(math.cos(endRadians), math.sin(endRadians)) * centerRadius;

      path
        ..moveTo(innerStart.dx, innerStart.dy)
        ..lineTo(outerStart.dx, outerStart.dy)
        ..arcTo(sectionRadiusRect, startRadians, sweepRadians, false)
        ..lineTo(innerEnd.dx, innerEnd.dy)
        ..arcTo(centerRadiusRect, endRadians, -sweepRadians, false)
        ..close();
    } else {
      // Clamp requested radii to avoid overlaps. We compute a separate
      // maximum for the outer arc (based on section radius and sweep angle)
      // and for the inner arc (based on centerRadius). This keeps rounding
      // visually stable across different section sizes.
      final maxRadiusForSection = section.radius * _kRadiusSafetyMargin;
      final maxRadiusForOuterArc =
          sweepRadians * outerRadius * _kRadiusSafetyMargin;
      final maxRadiusForInnerArc = centerRadius > 0
          ? sweepRadians * centerRadius * _kRadiusSafetyMargin
          : 0.0;

      final clampedOuterRadius = math.min(
        cornerRadius,
        math.min(maxRadiusForSection, maxRadiusForOuterArc),
      );
      final clampedInnerRadius = math.min(
        cornerRadius,
        math.min(maxRadiusForSection, maxRadiusForInnerArc),
      );

      // Compute angular offsets that correspond to the linear corner radii.
      // These are used to trim the sweep angles so the rounded joins fit
      // cleanly along the arc.
      final outerAngleOffset =
          outerRadius > 0 ? clampedOuterRadius / outerRadius : 0.0;
      final innerAngleOffset =
          centerRadius > 0 ? clampedInnerRadius / centerRadius : 0.0;

      // Tight angles for outside corners
      final outerStartAngle = startRadians + outerAngleOffset;
      final outerEndAngle = endRadians - outerAngleOffset;
      final outerSweepAngle = sweepRadians - (2 * outerAngleOffset);

      // Tight angles for inside corners
      final innerStartAngle = startRadians + innerAngleOffset;
      final innerEndAngle = endRadians - innerAngleOffset;
      final innerSweepAngle = sweepRadians - (2 * innerAngleOffset);

      // Points of the outer corners
      final outerStartPoint = center +
          Offset(math.cos(startRadians), math.sin(startRadians)) * outerRadius;
      final outerEndPoint = center +
          Offset(math.cos(endRadians), math.sin(endRadians)) * outerRadius;
      final outerStartRounded = center +
          Offset(math.cos(outerStartAngle), math.sin(outerStartAngle)) *
              outerRadius;
      final outerEndRounded = center +
          Offset(math.cos(outerEndAngle), math.sin(outerEndAngle)) *
              outerRadius;

      // Points of the inner corners
      final innerStartPoint = center +
          Offset(math.cos(startRadians), math.sin(startRadians)) * centerRadius;
      final innerEndPoint = center +
          Offset(math.cos(endRadians), math.sin(endRadians)) * centerRadius;
      final innerStartRounded = center +
          Offset(math.cos(innerStartAngle), math.sin(innerStartAngle)) *
              centerRadius;
      final innerEndRounded = center +
          Offset(math.cos(innerEndAngle), math.sin(innerEndAngle)) *
              centerRadius;

      // Control points used to connect the rounded corner bezier segments to
      // the inner/outer arcs. They lie along the original radial directions
      // but offset inward/outward by the clamped radii.
      final startOuterControl = center +
          Offset(math.cos(startRadians), math.sin(startRadians)) *
              (outerRadius - clampedOuterRadius);
      final endOuterControl = center +
          Offset(math.cos(endRadians), math.sin(endRadians)) *
              (outerRadius - clampedOuterRadius);
      final startInnerControl = center +
          Offset(math.cos(startRadians), math.sin(startRadians)) *
              (centerRadius + clampedInnerRadius);
      final endInnerControl = center +
          Offset(math.cos(endRadians), math.sin(endRadians)) *
              (centerRadius + clampedInnerRadius);

      // Build the rounded path step by step
      if (centerRadius > 0) {
        // Start from the inner rounded corner
        path.moveTo(innerStartRounded.dx, innerStartRounded.dy);

        // Inner starting rounded corner (quadratic join). If the inner
        // radius is small we fall back to a straight line to avoid tiny
        // bezier segments.
        if (clampedInnerRadius > 1) {
          path.quadraticBezierTo(
            innerStartPoint.dx,
            innerStartPoint.dy,
            startInnerControl.dx,
            startInnerControl.dy,
          );
        } else {
          path.lineTo(innerStartPoint.dx, innerStartPoint.dy);
        }

        // Straight line to the outer edge
        path.lineTo(startOuterControl.dx, startOuterControl.dy);

        // Outer starting rounded corner (quadratic join).
        if (clampedOuterRadius > 1) {
          path.quadraticBezierTo(
            outerStartPoint.dx,
            outerStartPoint.dy,
            outerStartRounded.dx,
            outerStartRounded.dy,
          );
        } else {
          path.lineTo(outerStartPoint.dx, outerStartPoint.dy);
        }
      } else {
        // If there is no centerRadius, start from the center
        path
          ..moveTo(center.dx, center.dy)
          ..lineTo(startOuterControl.dx, startOuterControl.dy);

        if (clampedOuterRadius > 1) {
          path.quadraticBezierTo(
            outerStartPoint.dx,
            outerStartPoint.dy,
            outerStartRounded.dx,
            outerStartRounded.dy,
          );
        } else {
          path.lineTo(outerStartPoint.dx, outerStartPoint.dy);
        }
      }

      // Draw the outer arc between the two rounded outer corner points.
      if (outerSweepAngle > 0) {
        path.arcTo(sectionRadiusRect, outerStartAngle, outerSweepAngle, false);
      }

      // Outer ending rounded corner (quadratic join).
      if (clampedOuterRadius > 1) {
        path
          ..lineTo(outerEndRounded.dx, outerEndRounded.dy)
          ..quadraticBezierTo(
            outerEndPoint.dx,
            outerEndPoint.dy,
            endOuterControl.dx,
            endOuterControl.dy,
          );
      } else {
        path.lineTo(outerEndPoint.dx, outerEndPoint.dy);
      }

      if (centerRadius > 0) {
        // Straight line to the inner edge
        path.lineTo(endInnerControl.dx, endInnerControl.dy);

        // Inner ending rounded corner (quadratic join).
        if (clampedInnerRadius > 1) {
          path.quadraticBezierTo(
            innerEndPoint.dx,
            innerEndPoint.dy,
            innerEndRounded.dx,
            innerEndRounded.dy,
          );
        } else {
          path.lineTo(innerEndPoint.dx, innerEndPoint.dy);
        }

        // Draw the inner arc between the two rounded inner corner points.
        if (innerSweepAngle > 0) {
          path.arcTo(centerRadiusRect, innerEndAngle, -innerSweepAngle, false);
        }
      } else {
        // If there is no centerRadius, close towards the center
        path.lineTo(center.dx, center.dy);
      }

      path.close();
    }

    return path;
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
    if (data.sections.isEmpty) {
      return 0;
    }
    final maxRadius = data.sections.map((s) => s.radius).reduce(math.max);
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
}
