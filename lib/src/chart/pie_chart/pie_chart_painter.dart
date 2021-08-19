import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/line.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pie_chart_data.dart';

/// Paints [PieChartData] in the canvas, it can be used in a [CustomPainter]
class PieChartPainter extends BaseChartPainter<PieChartData> {
  late Paint _sectionPaint, _sectionStrokePaint, _sectionsSpaceClearPaint, _centerSpacePaint;

  /// Paints [data] into canvas, it is the animating [PieChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [data] is changing constantly.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  PieChartPainter() : super() {
    _sectionPaint = Paint()..style = PaintingStyle.stroke;

    _sectionStrokePaint = Paint()..style = PaintingStyle.stroke;

    _sectionsSpaceClearPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.srcOut;

    _centerSpacePaint = Paint()..style = PaintingStyle.fill;
  }

  /// Paints [PieChartData] into the provided canvas.
  @override
  void paint(BuildContext context, CanvasWrapper canvasWrapper, PaintHolder<PieChartData> holder) {
    super.paint(context, canvasWrapper, holder);
    final data = holder.data;
    if (data.sections.isEmpty) {
      return;
    }

    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);
    final centerRadius = _calculateCenterRadius(canvasWrapper.size, holder);

    _drawCenterSpace(canvasWrapper, centerRadius, holder);
    _drawSections(canvasWrapper, sectionsAngle, centerRadius, holder);
    _drawTexts(context, canvasWrapper, holder, centerRadius);
  }

  List<double> _calculateSectionsAngle(List<PieChartSectionData> sections, double sumValue) {
    return sections.map((section) {
      return 360 * (section.value / sumValue);
    }).toList();
  }

  void _drawCenterSpace(
      CanvasWrapper canvasWrapper, double centerRadius, PaintHolder<PieChartData> holder) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final centerX = viewSize.width / 2;
    final centerY = viewSize.height / 2;

    _centerSpacePaint.color = data.centerSpaceColor;
    canvasWrapper.drawCircle(Offset(centerX, centerY), centerRadius, _centerSpacePaint);
  }

  void _drawSections(
    CanvasWrapper canvasWrapper,
    List<double> sectionsAngle,
    double centerRadius,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final shouldDrawSeparators = data.sectionsSpace != 0 && data.sections.length > 1;

    final viewSize = canvasWrapper.size;

    if (shouldDrawSeparators) {
      canvasWrapper.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    }

    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = data.startDegreeOffset;

    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      if (section.value == 0) {
        continue;
      }
      final sectionDegree = sectionsAngle[i];

      final sectionRadiusRect = Rect.fromCircle(
        center: center,
        radius: centerRadius + section.radius,
      );

      final centerRadiusRect = Rect.fromCircle(
        center: center,
        radius: centerRadius,
      );

      if (sectionDegree == 360) {
        _sectionPaint.color = section.color;
        _sectionPaint.strokeWidth = section.radius;
        _sectionPaint.style = PaintingStyle.stroke;
        canvasWrapper.drawCircle(center, centerRadius + section.radius / 2, _sectionPaint);
        return;
      }

      final startRadians = radians(tempAngle);
      final sweepRadians = radians(sectionDegree);
      final endRadians = startRadians + sweepRadians;

      final startLineDirection = Offset(math.cos(startRadians), math.sin(startRadians));
      final startLineFrom = center + startLineDirection * centerRadius;
      final startLineTo = startLineFrom + startLineDirection * section.radius;
      final startLine = Line(startLineFrom, startLineTo);

      final endLineDirection = Offset(math.cos(endRadians), math.sin(endRadians));
      final endLineFrom = center + endLineDirection * centerRadius;
      final endLineTo = endLineFrom + endLineDirection * section.radius;
      final endLine = Line(endLineFrom, endLineTo);

      final sectionPath = _generateSectionPath(
          startLine, endLine, startRadians, endRadians, sectionRadiusRect, centerRadiusRect);

      _sectionPaint.color = section.color;
      _sectionPaint.style = PaintingStyle.fill;
      canvasWrapper.drawPath(sectionPath, _sectionPaint);

      if (section.borderSide.width != 0.0 && section.borderSide.color.opacity != 0.0) {
        canvasWrapper.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
        canvasWrapper.clipPath(sectionPath);

        _sectionStrokePaint.strokeWidth = section.borderSide.width * 2;
        _sectionStrokePaint.color = section.borderSide.color;
        canvasWrapper.drawPath(
          sectionPath,
          _sectionStrokePaint,
        );
        canvasWrapper.restore();
      }
      tempAngle += sectionDegree;
    }

    if (shouldDrawSeparators) {
      _removeSectionsSpace(canvasWrapper, holder, centerRadius);
    }
  }

  /// Generates a path around a section
  Path _generateSectionPath(
    Line startLine,
    Line endLine,
    double startRadians,
    double endRadians,
    Rect sectionRadiusRect,
    Rect centerRadiusRect,
  ) {
    final sweepRadians = endRadians - startRadians;
    return Path()
      ..moveTo(startLine.from.dx, startLine.from.dy)
      ..lineTo(startLine.to.dx, startLine.to.dy)
      ..arcTo(sectionRadiusRect, startRadians, sweepRadians, false)
      ..lineTo(endLine.from.dx, endLine.from.dy)
      ..arcTo(centerRadiusRect, endRadians, -sweepRadians, false)
      ..moveTo(startLine.from.dx, startLine.from.dy)
      ..close();
  }

  /// firstly the sections draw close to eachOther without any space,
  /// then here we clear a line with given [PieChartData.width]
  void _removeSectionsSpace(
    CanvasWrapper canvasWrapper,
    PaintHolder<PieChartData> holder,
    double centerRadius,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    const extraLineSize = 1;
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = data.startDegreeOffset;
    data.sections.asMap().forEach((index, section) {
      final previousIndex = index == 0 ? data.sections.length - 1 : index - 1;
      final previousSection = data.sections[previousIndex];

      final maxSectionRadius = math.max(section.radius, previousSection.radius);

      final startAngle = tempAngle;
      final sweepAngle = 360 * (section.value / data.sumValue);

      final sectionsStartFrom = center +
          Offset(
            math.cos(radians(startAngle)) * (centerRadius - extraLineSize),
            math.sin(radians(startAngle)) * (centerRadius - extraLineSize),
          );

      final sectionsStartTo = center +
          Offset(
            math.cos(radians(startAngle)) * (centerRadius + maxSectionRadius + extraLineSize),
            math.sin(radians(startAngle)) * (centerRadius + maxSectionRadius + extraLineSize),
          );

      _sectionsSpaceClearPaint.strokeWidth = data.sectionsSpace;
      canvasWrapper.drawLine(sectionsStartFrom, sectionsStartTo, _sectionsSpaceClearPaint);
      tempAngle += sweepAngle;
    });
    canvasWrapper.restore();
  }

  /// Calculates layout of overlaying elements, includes:
  /// - title text
  /// - badge widget positions
  void _drawTexts(
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

      Offset sectionCenter(double percentageOffset) =>
          center +
          Offset(
            math.cos(radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
            math.sin(radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
          );

      final sectionCenterOffsetTitle = sectionCenter(section.titlePositionPercentageOffset);

      if (section.showTitle) {
        final span = TextSpan(
          style: getThemeAwareTextStyle(context, section.titleStyle),
          text: section.title,
        );
        final tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            textScaleFactor: holder.textScale);

        tp.layout();
        canvasWrapper.drawText(tp, sectionCenterOffsetTitle - Offset(tp.width / 2, tp.height / 2));
      }

      tempAngle += sweepAngle;
    }
  }

  double _calculateCenterRadius(Size viewSize, PaintHolder<PieChartData> holder) {
    final data = holder.data;
    if (data.centerSpaceRadius.isFinite) {
      return data.centerSpaceRadius;
    }
    final maxRadius = data.sections.reduce((a, b) => a.radius > b.radius ? a : b).radius;
    return (viewSize.shortestSide - (maxRadius * 2)) / 2;
  }

  /// Makes a [PieTouchedSection] based on the provided [localPosition]
  ///
  /// Processes [localPosition] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [PieTouchedSection] from the elements that has been touched.
  PieTouchedSection? handleTouch(
    Offset localPosition,
    Size size,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);
    return _getTouchedSection(size, localPosition, sectionsAngle, holder);
  }

  /// find touched section by the value of [touchInputNotifier]
  PieTouchedSection? _getTouchedSection(
    Size viewSize,
    Offset localPosition,
    List<double> sectionsAngle,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    final touchedPoint2 = localPosition - center;

    final touchX = touchedPoint2.dx;
    final touchY = touchedPoint2.dy;

    final touchR = math.sqrt(math.pow(touchX, 2) + math.pow(touchY, 2));
    var touchAngle = degrees(math.atan2(touchY, touchX));
    touchAngle = touchAngle < 0 ? (180 - touchAngle.abs()) + 180 : touchAngle;

    PieChartSectionData? foundSectionData;
    var foundSectionDataPosition = -1;

    /// Find the nearest section base on the touch spot
    final relativeTouchAngle = (touchAngle - data.startDegreeOffset) % 360;
    var tempAngle = 0.0;
    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      var sectionAngle = sectionsAngle[i];

      tempAngle %= 360;
      if (data.sections.length == 1) {
        sectionAngle = 360;
      } else {
        sectionAngle %= 360;
      }

      /// degree criteria
      final space = data.sectionsSpace / 2;
      final fromDegree = tempAngle + space;
      final toDegree = sectionAngle + tempAngle - space;
      final isInDegree = relativeTouchAngle >= fromDegree && relativeTouchAngle <= toDegree;

      /// radius criteria
      final centerRadius = _calculateCenterRadius(viewSize, holder);
      final sectionRadius = centerRadius + section.radius;
      final isInRadius = touchR > centerRadius && touchR <= sectionRadius;

      if (isInDegree && isInRadius) {
        foundSectionData = section;
        foundSectionDataPosition = i;
        break;
      }

      tempAngle += sectionAngle;
    }

    return PieTouchedSection(foundSectionData, foundSectionDataPosition, touchAngle, touchR);
  }

  /// Exposes offset for laying out the badge widgets upon the chart.
  Map<int, Offset> getBadgeOffsets(Size viewSize, PaintHolder<PieChartData> holder) {
    final data = holder.data;
    final center = viewSize.center(Offset.zero);
    final badgeWidgetsOffsets = <int, Offset>{};

    if (data.sections.isEmpty) {
      return badgeWidgetsOffsets;
    }

    var tempAngle = data.startDegreeOffset;

    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);
    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final startAngle = tempAngle;
      final sweepAngle = sectionsAngle[i];
      final sectionCenterAngle = startAngle + (sweepAngle / 2);
      final centerRadius = _calculateCenterRadius(viewSize, holder);

      Offset sectionCenter(double percentageOffset) =>
          center +
          Offset(
            math.cos(radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
            math.sin(radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
          );

      final sectionCenterOffsetBadgeWidget = sectionCenter(section.badgePositionPercentageOffset);

      badgeWidgetsOffsets[i] = sectionCenterOffsetBadgeWidget;

      tempAngle += sweepAngle;
    }

    return badgeWidgetsOffsets;
  }
}
