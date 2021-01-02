import 'dart:math' show pi, cos, sin, min;
import 'dart:ui';

import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';
import 'package:flutter/material.dart';

import '../../../fl_chart.dart';

class RadarChartPainter extends BaseChartPainter<RadarChartData>
    with TouchHandler<RadarTouchResponse> {
  final Paint _borderPaint, _backgroundPaint, _gridPaint;
  final Paint _graphPaint, _graphBorderPaint, _graphPointPaint;
  final TextPainter _ticksTextPaint, _titleTextPaint;

  List<RadarDataSetsPosition> dataSetsPosition;

  RadarChartPainter(
    RadarChartData data,
    RadarChartData targetData,
    Function(TouchHandler) touchHandler, {
    double textScale =1 ,
  })  : _backgroundPaint = Paint()
          ..color = data.fillColor
          ..style = PaintingStyle.fill
          ..isAntiAlias = true,
        _borderPaint = Paint()
          ..color = data?.borderData?.border?.top?.color ?? Colors.black
          ..strokeWidth = data?.borderData?.border?.top?.width ?? 2
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true,
        _gridPaint = Paint()
          ..color = data?.gridData?.color ?? Colors.black
          ..strokeWidth = data?.gridData?.width ?? 2
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true,
        _graphPaint = Paint(),
        _graphBorderPaint = Paint(),
        _graphPointPaint = Paint(),
        _ticksTextPaint = TextPainter(),
        _titleTextPaint = TextPainter(),
        super(data, targetData, textScale: textScale) {
    touchHandler(this);
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    if (data.dataSets.isEmpty) return;

    dataSetsPosition = _calculateDataSetsPosition(size);

    drawTicks(size, canvas);
    drawGrids(size, canvas);
    drawTitles(size, canvas);
    drawDataSets(size, canvas);
  }

  void drawTicks(Size size, Canvas canvas) {
    final centerX = radarCenterX(size);
    final centerY = radarCenterY(size);
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = radarRadius(size);

    //draw radar background
    canvas.drawCircle(centerOffset, radius, _backgroundPaint);
    //draw radar border
    canvas.drawCircle(centerOffset, radius, _borderPaint);

    final dataSetMaxValue = data.maxEntry.value;
    final dataSetMinValue = data.minEntry.value;
    final tickSpace = (dataSetMaxValue - dataSetMinValue) / data.tickCount;

    final ticks = <double>[];

    for (var tick = dataSetMinValue; tick <= dataSetMaxValue; tick = tick + tickSpace)
      ticks.add(tick);

    final tickDistance = radius / (ticks.length);

    final ticksStyle = data.ticksTextStyle ?? const TextStyle(fontSize: 10, color: Colors.black);
    ticks.sublist(0, ticks.length - 1).asMap().forEach((index, tick) {
      final tickRadius = tickDistance * (index + 1);
      canvas.drawCircle(centerOffset, tickRadius, _gridPaint);
      _ticksTextPaint
        ..text = TextSpan(
          text: tick.toStringAsFixed(1),
          style: ticksStyle,
        )
        ..textDirection = TextDirection.ltr;
      _ticksTextPaint.layout(minWidth: 0, maxWidth: size.width);
      _ticksTextPaint.paint(
          canvas, Offset(centerX + 5, centerY - tickRadius - _ticksTextPaint.height));
    });
  }

  double radarCenterY(Size size) => size.height / 2.0;

  double radarCenterX(Size size) => size.width / 2.0;

  double radarRadius(Size size) => min(radarCenterX(size), radarCenterY(size)) * 0.7;

  void drawGrids(Size size, Canvas canvas) {
    final centerX = radarCenterX(size);
    final centerY = radarCenterY(size);
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = radarRadius(size);

    final angle = (2 * pi) / data.titleCount;

    //drawing grids
    for (int index = 0; index < data.titleCount; index++) {
      final endX = centerX + radius * cos(angle * index - pi / 2);
      final endY = centerY + radius * sin(angle * index - pi / 2);

      final gridOffset = Offset(endX, endY);

      canvas.drawLine(centerOffset, gridOffset, _gridPaint);
    }
  }

  void drawTitles(Size size, Canvas canvas) {
    if (data?.getTitle == null) return;

    final centerX = radarCenterX(size);
    final centerY = radarCenterY(size);

    /// controls Radar chart size
    final radius = radarRadius(size);

    final angle = (2 * pi) / data.titleCount;

    final style = data?.titleTextStyle ?? const TextStyle(fontSize: 14, color: Colors.black);

    _titleTextPaint
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textScaleFactor = textScale;

    for (int index = 0; index < data.titleCount; index++) {
      final title = data?.getTitle(index);
      final xAngle = cos(angle * index - pi / 2);
      final yAngle = sin(angle * index - pi / 2);

      final span = TextSpan(text: title, style: style);
      _titleTextPaint.text = span;
      _titleTextPaint.layout();
      canvas.save();
      final titlePositionPercentageOffset = data?.titlePositionPercentageOffset ?? 0.2;
      final threshold = 1.0 + titlePositionPercentageOffset;
      final featureOffset = Offset(
        centerX + threshold * radius * xAngle,
        centerY + threshold * radius * yAngle,
      );
      canvas.translate(featureOffset.dx, featureOffset.dy);
      canvas.rotate(angle * index);

      _titleTextPaint.paint(
        canvas,
        Offset.zero - Offset(_titleTextPaint.width / 2, _titleTextPaint.height / 2),
      );
      canvas.restore();
    }
  }

  void drawDataSets(Size size, Canvas canvas) {
    // we will use dataSetsPosition to draw the graphs
    dataSetsPosition.asMap().forEach((index, dataSetOffset) {
      final graph = data.dataSets[index];
      _graphPaint
        ..color = graph.color.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      _graphBorderPaint
        ..color = graph.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;

      _graphPointPaint
        ..color = graph.color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      final path = Path();

      final firstOffset = Offset(
        dataSetOffset.entriesOffset.first.dx,
        dataSetOffset.entriesOffset.first.dy,
      );

      path.moveTo(firstOffset.dx, firstOffset.dy);

      canvas.drawCircle(
        firstOffset,
        graph.entryRadius,
        _graphPointPaint,
      );
      dataSetOffset.entriesOffset.asMap().forEach((index, pointOffset) {
        if (index == 0) return;

        path.lineTo(pointOffset.dx, pointOffset.dy);

        canvas.drawCircle(
          pointOffset,
          graph.entryRadius,
          _graphPointPaint,
        );
      });

      path.close();
      canvas.drawPath(path, _graphPaint);
      canvas.drawPath(path, _graphBorderPaint);
    });
  }

  @override
  RadarTouchResponse handleTouch(FlTouchInput touchInput, Size size) {
    final touchedSpot = _getNearestTouchSpot(size, touchInput.getOffset(), dataSetsPosition);
    return RadarTouchResponse(touchedSpot, touchInput);
  }

  RadarTouchedSpot _getNearestTouchSpot(
    Size viewSize,
    Offset touchedPoint,
    List<RadarDataSetsPosition> radarDataSetsPosition,
  ) {
    for (int i = 0; i < radarDataSetsPosition.length; i++) {
      final dataSetPosition = radarDataSetsPosition[i];
      for (int j = 0; j < dataSetPosition.entriesOffset.length; j++) {
        final entryOffset = dataSetPosition.entriesOffset[j];
        if ((touchedPoint.dx - entryOffset.dx).abs() <=
                targetData.radarTouchData.touchSpotThreshold &&
            (touchedPoint.dy - entryOffset.dy).abs() <=
                targetData.radarTouchData.touchSpotThreshold) {
          return RadarTouchedSpot(
            targetData.dataSets[i],
            i,
            targetData.dataSets[i].dataEntries[j],
            j,
            FlSpot(entryOffset.dx, entryOffset.dy),
            entryOffset,
          );
        }
      }
    }
    return null;
  }

  List<RadarDataSetsPosition> _calculateDataSetsPosition(Size viewSize) {
    if (viewSize == null || data?.dataSets == null) return null;

    final centerX = radarCenterX(viewSize);
    final centerY = radarCenterY(viewSize);
    final radius = radarRadius(viewSize);

    final scale = radius / data.maxEntry.value;
    final angle = (2 * pi) / data.titleCount;

    final dataSetsPosition = List<RadarDataSetsPosition>(data.dataSets.length);
    for (int i = 0; i < data.dataSets.length; i++) {
      final dataSet = data.dataSets[i];
      final entriesOffset = List<Offset>(dataSet.dataEntries.length);

      for (int j = 0; j < dataSet.dataEntries.length; j++) {
        final point = dataSet.dataEntries[j];

        final xAngle = cos(angle * j - pi / 2);
        final yAngle = sin(angle * j - pi / 2);
        final scaledPoint = scale * point.value;

        final entryOffset = Offset(
          centerX + scaledPoint * xAngle,
          centerY + scaledPoint * yAngle,
        );

        entriesOffset[j] = entryOffset;
      }
      dataSetsPosition[i] = RadarDataSetsPosition(entriesOffset);
    }

    return dataSetsPosition;
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    //ToDo(payam) : override this method
    return true;
  }
}

class RadarDataSetsPosition {
  final List<Offset> entriesOffset;

  const RadarDataSetsPosition(this.entriesOffset);
}
