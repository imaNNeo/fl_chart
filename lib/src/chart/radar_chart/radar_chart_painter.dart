import 'dart:developer';
import 'dart:math' show pi, cos, sin, min;
import 'dart:ui';

import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const defaultGraphColors = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.orange,
];

class RadarChartPainter extends BaseChartPainter<RadarChartData>
    with TouchHandler<RadarTouchResponse> {
  final Paint _outlinePaint, _backgroundPaint, _tickPaint;
  final TextPainter _ticksTextPaint;

  //ToDo(payam) : add touchHandle function here
  RadarChartPainter(
    RadarChartData data,
    RadarChartData targetData, {
    double textScale,
  })  : _backgroundPaint = Paint()
          ..color = data.fillColor
          ..style = PaintingStyle.fill
          ..isAntiAlias = true,
        _outlinePaint = Paint()
          ..color = data.borderData.border.top.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = data.borderData.border.top.width
          ..isAntiAlias = true,
        _ticksTextPaint = TextPainter(),
        _tickPaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..isAntiAlias = true,
        super(data, targetData, textScale: textScale);

  @override
  void paint(Canvas canvas, Size size) {
    drawTicks(size, canvas);
    drawGrids(size, canvas);
    drawTitles(size, canvas);
    drawDataSets(size, canvas);
  }

  void drawTicks(Size size, Canvas canvas) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = min(centerX, centerY) * 0.7;

    //draw radar background
    canvas.drawCircle(centerOffset, radius, _backgroundPaint);
    //draw radar border
    canvas.drawCircle(centerOffset, radius, _outlinePaint);

    final dataSetMaxValue = data.maxEntry.value;
    final dataSetMinValue = data.minEntry.value;
    final tickSpace = (dataSetMaxValue - dataSetMinValue) / data.tickCount;

    final ticks = <double>[];

    for (var tick = dataSetMinValue; tick <= dataSetMaxValue; tick = tick + tickSpace)
      ticks.add(tick);

    final tickDistance = radius / (ticks.length);

    log('ticks: ${ticks.toString()}');

    ticks.sublist(0, ticks.length - 1).asMap().forEach((index, tick) {
      final tickRadius = tickDistance * (index + 1);
      canvas.drawCircle(centerOffset, tickRadius, _tickPaint);
      _ticksTextPaint
        ..text = TextSpan(
          text: tick.toString(),
          style: const TextStyle(fontSize: 10, color: Colors.black),
        )
        ..textDirection = TextDirection.ltr
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(canvas, Offset(centerX + 5, centerY - tickRadius - 12));
    });
  }

  void drawGrids(Size size, Canvas canvas) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = min(centerX, centerY) * 0.7;

    final angle = (2 * pi) / data.titleCount;

    //drawing grids
    for (int index = 0; index < data.titleCount; index++) {
      final endX = centerX + radius * cos(angle * index - pi / 2);
      final endY = centerY + radius * sin(angle * index - pi / 2);

      final gridOffset = Offset(endX, endY);

      canvas.drawLine(centerOffset, gridOffset, _tickPaint);
    }
  }

  void drawTitles(Size size, Canvas canvas) {
    if (data?.getTitle == null) return;

    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;

    /// controls Radar chart size
    final radius = min(centerX, centerY) * 0.7;

    final angle = (2 * pi) / data.titleCount;

    for (int index = 0; index < data.titleCount; index++) {
      final title = data?.getTitle(index);
      const style = TextStyle(fontSize: 14, color: Colors.red);
      final xAngle = cos(angle * index - pi / 2);
      final yAngle = sin(angle * index - pi / 2);

      final span = TextSpan(text: title, style: style);
      final TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        textScaleFactor: textScale,
      );

      tp.layout();
      canvas.save();
      const threshold = 1.15;
      final featureOffset = Offset(
        centerX + threshold * radius * xAngle,
        centerY + threshold * radius * yAngle,
      );
      canvas.translate(featureOffset.dx, featureOffset.dy);
      canvas.rotate(angle * index);

      tp.paint(canvas, Offset.zero - Offset(tp.width / 2, tp.height / 2));
      canvas.restore();
    }
  }

  void drawDataSets(Size size, Canvas canvas) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;

    /// controls Radar chart size
    final radius = min(centerX, centerY) * 0.7;

    data.dataSets.asMap().forEach((index, graph) {
      final graphPaint = Paint()
        ..color = graph.color.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      final graphOutlinePaint = Paint()
        ..color = graph.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;

      final scale = radius / data.maxEntry.value;
      final scaledPoint = scale * graph.dataEntries.first.value;
      final angle = (2 * pi) / data.titleCount;
      final path = Path();

      path.moveTo(centerX, centerY - scaledPoint);

      graph.dataEntries.asMap().forEach((index, point) {
        if (index == 0) return;
        final xAngle = cos(angle * index - pi / 2);
        final yAngle = sin(angle * index - pi / 2);
        final scaledPoint = scale * point.value;

        path.lineTo(centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
      });

      path.close();
      canvas.drawPath(path, graphPaint);
      canvas.drawPath(path, graphOutlinePaint);
    });
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    //ToDo(payam) : override this method
    return true;
  }
}
