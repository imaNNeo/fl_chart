import 'dart:math' as math;

import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';


class PieChartPainter extends FlChartPainter {
  final PieChartData data;

  Paint sectionPaint, centerSpacePaint;
  Rect sectionsDrawRectTmp = Rect.fromLTRB(0, 0, 0, 0);

  PieChartPainter(
    this.data,
  ) : super(data) {
    sectionPaint = Paint()
      ..style = PaintingStyle.stroke;

    centerSpacePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = data.centerSpaceColor;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    if (data.sections.length == 0) {
      return;
    }
    super.paint(canvas, viewSize);

    drawCenterSpace(canvas, viewSize);
    drawSections(canvas, viewSize);
    drawTexts(canvas, viewSize);
  }

  void drawCenterSpace(Canvas canvas, Size viewSize) {
    double centerX = viewSize.width / 2;
    double centerY = viewSize.height / 2;

    canvas.drawCircle(Offset(centerX, centerY), data.centerSpaceRadius, centerSpacePaint);
  }

  void drawSections(Canvas canvas, Size viewSize) {
    Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    sectionPaint.color = Color(0xff000000);

    double tempAngle = 0;
    data.sections.forEach((section) {
      Rect rect = Rect.fromCircle(
        center: center,
        radius: data.centerSpaceRadius + (section.widthRadius / 2),
      );

      sectionPaint.color = section.color;
      sectionPaint.strokeWidth = section.widthRadius;

      double startAngle = tempAngle;
      double sweepAngle = 360 * (section.value / data.sumValue);
      canvas.drawArc(
        rect,
        radians(startAngle),
        radians(sweepAngle),
        false,
        sectionPaint,
      );

      tempAngle += sweepAngle;
    });
  }

  void drawTexts(Canvas canvas, Size viewSize) {
    Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = 0;
    data.sections.forEach((section) {

      double startAngle = tempAngle;
      double sweepAngle = 360 * (section.value / data.sumValue);
      double sectionCenterAngle = startAngle + (sweepAngle / 2);
      Offset sectionCenterOffset = center + Offset(
        math.cos(radians(sectionCenterAngle)) *
          (data.centerSpaceRadius + (section.widthRadius / 2)),
        math.sin(radians(sectionCenterAngle)) *
          (data.centerSpaceRadius + (section.widthRadius / 2)),
      );

      if (section.showTitle) {
        TextSpan span = new TextSpan(style: section.textStyle, text: section.title);
        TextPainter tp = new TextPainter(
          text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout();
        sectionCenterOffset -= Offset(tp.width / 2, tp.height / 2);
        tp.paint(canvas, sectionCenterOffset);
      }
      tempAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}
