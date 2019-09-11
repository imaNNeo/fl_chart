import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pie_chart.dart';
import 'pie_chart_data.dart';


/// this class will paint the [PieChart] based on the [PieChartData]
class PieChartPainter extends BaseChartPainter {
  final PieChartData data;

  /// [sectionPaint] responsible to paint each section
  /// [sectionsSpaceClearPaint] responsible to clear the space between the sections
  /// [centerSpacePaint] responsible to draw the center space of our chart.
  Paint sectionPaint, sectionsSpaceClearPaint, centerSpacePaint;

  PieChartPainter(
    this.data,
    FlTouchInputNotifier touchInputNotifier,
    StreamSink<PieTouchResponse> touchedResultSink,)
    : super(data, touchInputNotifier: touchInputNotifier, touchedResponseSink: touchedResultSink) {
    sectionPaint = Paint()
      ..style = PaintingStyle.stroke;

    sectionsSpaceClearPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.srcOut;

    centerSpacePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = data.centerSpaceColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (data.sections.isEmpty) {
      return;
    }

    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);

    drawCenterSpace(canvas, size);
    drawSections(canvas, size, sectionsAngle);
    drawTexts(canvas, size);

    final touched = _getTouchedDetails(canvas, size, sectionsAngle);
    if (touchedResponseSink != null && touchInputNotifier != null
      && touchInputNotifier.value != null
      && !(touchInputNotifier.value.runtimeType is NonTouch)) {
      touchedResponseSink.add(touched);
    }
  }

  List<double> _calculateSectionsAngle(List<PieChartSectionData> sections, double sumValue) {
    return sections.map((section) {
      return 360 * (section.value / sumValue);
    }).toList();
  }

  void drawCenterSpace(Canvas canvas, Size viewSize) {
    double centerX = viewSize.width / 2;
    double centerY = viewSize.height / 2;

    canvas.drawCircle(Offset(centerX, centerY), data.centerSpaceRadius, centerSpacePaint);
  }

  void drawSections(Canvas canvas, Size viewSize, List<double> sectionsAngle) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = data.startDegreeOffset;

    for (int i = 0; i < data.sections.length; i++) {
      final section =  data.sections[i];
      final sectionDegree = sectionsAngle[i];

      final rect = Rect.fromCircle(
        center: center,
        radius: data.centerSpaceRadius + (section.radius / 2),
      );

      sectionPaint.color = section.color;
      sectionPaint.strokeWidth = section.radius;

      double startAngle = tempAngle;
      double sweepAngle = sectionDegree;
      canvas.drawArc(
        rect,
        radians(startAngle),
        radians(sweepAngle),
        false,
        sectionPaint,
      );

      tempAngle += sweepAngle;
    }

    removeSectionsSpace(canvas, viewSize);
  }

  /// firstly the sections draw close to eachOther without any space,
  /// then here we clear a line with given [PieChartData.width]
  void removeSectionsSpace(Canvas canvas, Size viewSize) {
    double extraLineSize = 1;
    Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = data.startDegreeOffset;
    data.sections.asMap().forEach((index, section) {
      int previousIndex = index == 0 ? data.sections.length - 1 : index - 1;
      var previousSection = data.sections[previousIndex];

      double maxSectionRadius = math.max(section.radius, previousSection.radius);

      double startAngle = tempAngle;
      double sweepAngle = 360 * (section.value / data.sumValue);

      Offset sectionsStartFrom = center + Offset(
        math.cos(radians(startAngle)) *
          (data.centerSpaceRadius - extraLineSize),
        math.sin(radians(startAngle)) *
          (data.centerSpaceRadius - extraLineSize),
      );

      Offset sectionsStartTo = center + Offset(
        math.cos(radians(startAngle)) *
          (data.centerSpaceRadius + maxSectionRadius + extraLineSize),
        math.sin(radians(startAngle)) *
          (data.centerSpaceRadius + maxSectionRadius + extraLineSize),
      );

      sectionsSpaceClearPaint.strokeWidth = data.sectionsSpace;
      canvas.drawLine(sectionsStartFrom, sectionsStartTo, sectionsSpaceClearPaint);
      tempAngle += sweepAngle;
    });
    canvas.restore();
  }

  void drawTexts(Canvas canvas, Size viewSize) {
    Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = data.startDegreeOffset;
    data.sections.forEach((section) {
      double startAngle = tempAngle;
      double sweepAngle = 360 * (section.value / data.sumValue);
      double sectionCenterAngle = startAngle + (sweepAngle / 2);
      Offset sectionCenterOffset = center + Offset(
        math.cos(radians(sectionCenterAngle)) *
          (data.centerSpaceRadius + (section.radius * section.titlePositionPercentageOffset)),
        math.sin(radians(sectionCenterAngle)) *
          (data.centerSpaceRadius + (section.radius * section.titlePositionPercentageOffset)),
      );

      if (section.showTitle) {
        TextSpan span = TextSpan(style: section.titleStyle, text: section.title);
        TextPainter tp = TextPainter(
          text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, sectionCenterOffset - Offset(tp.width / 2, tp.height / 2));
      }

      tempAngle += sweepAngle;
    });
  }

  /// find touched section by the value of [touchInputNotifier]
  PieTouchResponse _getTouchedDetails(Canvas canvas, Size viewSize, List<double> sectionsAngle) {
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    if (touchInputNotifier == null || touchInputNotifier.value == null) {
      return null;
    }

    final touch = touchInputNotifier.value;

    if (touch.getOffset() == null) {
      return null;
    }

    final touchedPoint = touch.getOffset() - center;

    final touchX = touchedPoint.dx;
    final touchY = touchedPoint.dy;

    final touchR = math.sqrt(math.pow(touchX, 2) + math.pow(touchY, 2));
    double touchAngle = degrees(math.atan2(touchY, touchX));
    touchAngle = touchAngle < 0 ? (180 - touchAngle.abs()) + 180 : touchAngle;

    PieChartSectionData foundSectionData;

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
      final centerRadius = data.centerSpaceRadius;
      final sectionRadius = centerRadius + section.radius;
      final isInRadius = touchR > centerRadius && touchR <= sectionRadius;

      if (isInDegree && isInRadius) {
        foundSectionData = section;
        break;
      }

      tempAngle += sectionAngle;
    }

    return PieTouchResponse(foundSectionData, touchAngle, touchR, touch);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate.data != this.data;
}
