import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pie_chart_data.dart';

/// Paints [PieChartData] in the canvas, it can be used in a [CustomPainter]
class PieChartPainter extends BaseChartPainter<PieChartData> with TouchHandler<PieTouchResponse> {

  Paint _sectionPaint, _sectionsSpaceClearPaint, _centerSpacePaint;

  /// Paints [data] into canvas, it is the animating [PieChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [data] is changing constantly.
  ///
  /// [touchHandler] passes a [TouchHandler] to the parent,
  /// parent will use it for touch handling flow.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  PieChartPainter(PieChartData data, PieChartData targetData, Function(TouchHandler) touchHandler,
      {double textScale})
      : super(data, targetData, textScale: textScale) {
    touchHandler(this);

    _sectionPaint = Paint()..style = PaintingStyle.stroke;

    _sectionsSpaceClearPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.srcOut;

    _centerSpacePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = data.centerSpaceColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (data.sections.isEmpty) {
      return;
    }

    final List<double> sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);

    _drawCenterSpace(canvas, size);
    _drawSections(canvas, size, sectionsAngle);
    _drawTexts(canvas, size);
  }

  List<double> _calculateSectionsAngle(List<PieChartSectionData> sections, double sumValue) {
    return sections.map((section) {
      return 360 * (section.value / sumValue);
    }).toList();
  }

  void _drawCenterSpace(Canvas canvas, Size viewSize) {
    final double centerX = viewSize.width / 2;
    final double centerY = viewSize.height / 2;

    canvas.drawCircle(Offset(centerX, centerY), data.centerSpaceRadius, _centerSpacePaint);
  }

  void _drawSections(Canvas canvas, Size viewSize, List<double> sectionsAngle) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    final Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = data.startDegreeOffset;

    for (int i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final sectionDegree = sectionsAngle[i];

      final rect = Rect.fromCircle(
        center: center,
        radius: _calculateCenterRadius(viewSize, data.centerSpaceRadius) + (section.radius / 2),
      );

      _sectionPaint.color = section.color;
      _sectionPaint.strokeWidth = section.radius;

      final double startAngle = tempAngle;
      final double sweepAngle = sectionDegree;
      canvas.drawArc(
        rect,
        radians(startAngle),
        radians(sweepAngle),
        false,
        _sectionPaint,
      );

      tempAngle += sweepAngle;
    }

    _removeSectionsSpace(canvas, viewSize);
  }

  /// firstly the sections draw close to eachOther without any space,
  /// then here we clear a line with given [PieChartData.width]
  void _removeSectionsSpace(Canvas canvas, Size viewSize) {
    const double extraLineSize = 1;
    final Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = data.startDegreeOffset;
    data.sections.asMap().forEach((index, section) {
      final int previousIndex = index == 0 ? data.sections.length - 1 : index - 1;
      final previousSection = data.sections[previousIndex];

      final double maxSectionRadius = math.max(section.radius, previousSection.radius);

      final double startAngle = tempAngle;
      final double sweepAngle = 360 * (section.value / data.sumValue);

      final Offset sectionsStartFrom = center +
          Offset(
            math.cos(radians(startAngle)) * (_calculateCenterRadius(viewSize, data.centerSpaceRadius) - extraLineSize),
            math.sin(radians(startAngle)) * (_calculateCenterRadius(viewSize, data.centerSpaceRadius) - extraLineSize),
          );

      final Offset sectionsStartTo = center +
          Offset(
            math.cos(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) + maxSectionRadius + extraLineSize),
            math.sin(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) + maxSectionRadius + extraLineSize),
          );

      _sectionsSpaceClearPaint.strokeWidth = data.sectionsSpace;
      canvas.drawLine(sectionsStartFrom, sectionsStartTo, _sectionsSpaceClearPaint);
      tempAngle += sweepAngle;
    });
    canvas.restore();
  }

  void _drawTexts(Canvas canvas, Size viewSize) {
    final Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = data.startDegreeOffset;
    for (int i = 0; i < data.sections.length; i++) {
      final PieChartSectionData section = data.sections[i];
      final double startAngle = tempAngle;
      final double sweepAngle = 360 * (section.value / data.sumValue);
      final double sectionCenterAngle = startAngle + (sweepAngle / 2);
      final Offset sectionCenterOffset = center +
          Offset(
            math.cos(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) + (section.radius * section.titlePositionPercentageOffset)),
            math.sin(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) + (section.radius * section.titlePositionPercentageOffset)),
          );

      if (section.showTitle) {
        final TextSpan span = TextSpan(style: section.titleStyle, text: section.title);
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            textScaleFactor: textScale);
        tp.layout();
        tp.paint(canvas, sectionCenterOffset - Offset(tp.width / 2, tp.height / 2));
      }

      tempAngle += sweepAngle;
    }
  }

  double _calculateCenterRadius(Size viewSize, double givenCenterRadius) {
    if (!givenCenterRadius.isNaN) {
      return givenCenterRadius;
    }

    double maxRadius = 0;
    for (int i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      if (section.radius > maxRadius) {
        maxRadius = section.radius;
      }
    }

    final minWidthHeight = math.min(viewSize.width, viewSize.height);
    final centerRadius = (minWidthHeight - (maxRadius * 2)) / 2;
    return centerRadius;
  }

  @override
  PieTouchResponse handleTouch(FlTouchInput touchInput, Size size) {
    final List<double> sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);
    return _getTouchedDetails(size, touchInput, sectionsAngle);
  }

  /// find touched section by the value of [touchInputNotifier]
  PieTouchResponse _getTouchedDetails(
      Size viewSize, FlTouchInput touchInput, List<double> sectionsAngle) {
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    if (touchInput.getOffset() == null) {
      return null;
    }

    final touchedPoint2 = touchInput.getOffset() - center;

    final touchX = touchedPoint2.dx;
    final touchY = touchedPoint2.dy;

    final touchR = math.sqrt(math.pow(touchX, 2) + math.pow(touchY, 2));
    double touchAngle = degrees(math.atan2(touchY, touchX));
    touchAngle = touchAngle < 0 ? (180 - touchAngle.abs()) + 180 : touchAngle;

    PieChartSectionData foundSectionData;
    int foundSectionDataPosition;

    /// Find the nearest section base on the touch spot
    double tempAngle = data.startDegreeOffset;
    for (int i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      double sectionAngle = sectionsAngle[i];

      tempAngle %= 360;
      sectionAngle %= 360;

      /// degree criteria
      final space = data.sectionsSpace / 2;
      final fromDegree = tempAngle + space;
      final toDegree = sectionAngle + tempAngle - space;
      final isInDegree = touchAngle >= fromDegree && touchAngle <= toDegree;

      /// radius criteria
      final centerRadius = _calculateCenterRadius(viewSize, data.centerSpaceRadius);
      final sectionRadius = centerRadius + section.radius;
      final isInRadius = touchR > centerRadius && touchR <= sectionRadius;

      if (isInDegree && isInRadius) {
        foundSectionData = section;
        foundSectionDataPosition = i;
        break;
      }

      tempAngle += sectionAngle;
    }

    return PieTouchResponse(
        foundSectionData, foundSectionDataPosition, touchAngle, touchR, touchInput);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => oldDelegate.data != data;
}
