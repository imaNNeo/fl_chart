import 'dart:math' show pi, cos, sin, min;

import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../fl_chart.dart';

/// Paints [RadarChartData] in the canvas, it can be used in a [CustomPainter]
class RadarChartPainter extends BaseChartPainter<RadarChartData> {
  late Paint _borderPaint, _backgroundPaint, _gridPaint, _tickPaint;
  late Paint _graphPaint, _graphBorderPaint, _graphPointPaint;
  late TextPainter _ticksTextPaint, _titleTextPaint;

  List<RadarDataSetsPosition>? dataSetsPosition;

  /// Paints [dataList] into canvas, it is the animating [RadarChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [dataList] is changing constantly.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  RadarChartPainter() : super() {
    _backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    _borderPaint = Paint()..style = PaintingStyle.stroke;

    _gridPaint = Paint()..style = PaintingStyle.stroke;

    _tickPaint = Paint()..style = PaintingStyle.stroke;

    _graphPaint = Paint();
    _graphBorderPaint = Paint();
    _graphPointPaint = Paint();
    _ticksTextPaint = TextPainter();
    _titleTextPaint = TextPainter();
  }

  /// Paints [RadarChartData] into the provided canvas.
  @override
  void paint(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<RadarChartData> holder) {
    super.paint(context, canvasWrapper, holder);
    final data = holder.data;

    if (data.dataSets.isEmpty) {
      return;
    }

    dataSetsPosition = calculateDataSetsPosition(canvasWrapper.size, holder);

    drawGrids(canvasWrapper, holder);
    drawTicks(context, canvasWrapper, holder);
    drawTitles(context, canvasWrapper, holder);
    drawDataSets(canvasWrapper, holder);
  }

  @visibleForTesting
  void drawTicks(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<RadarChartData> holder) {
    final data = holder.data;
    final size = canvasWrapper.size;

    final centerX = radarCenterX(size);
    final centerY = radarCenterY(size);
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = radarRadius(size);

    _backgroundPaint.color = data.radarBackgroundColor;

    _borderPaint
      ..color = data.radarBorderData.color
      ..strokeWidth = data.radarBorderData.width;

    if (data.radarShape == RadarShape.circle) {
      /// draw radar background
      canvasWrapper.drawCircle(centerOffset, radius, _backgroundPaint);

      /// draw radar border
      canvasWrapper.drawCircle(centerOffset, radius, _borderPaint);
    } else {
      final path =
          _generatePolygonPath(centerX, centerY, radius, data.titleCount);

      /// draw radar background
      canvasWrapper.drawPath(path, _backgroundPaint);

      /// draw radar border
      canvasWrapper.drawPath(path, _borderPaint);
    }

    final dataSetMaxValue = data.maxEntry.value;
    final dataSetMinValue = data.minEntry.value;
    final tickSpace = (dataSetMaxValue - dataSetMinValue) / data.tickCount;

    final ticks = <double>[];

    for (var tick = dataSetMinValue;
        tick <= dataSetMaxValue;
        tick = tick + tickSpace) {
      ticks.add(tick);
    }

    final tickDistance = radius / (ticks.length);

    _tickPaint
      ..color = data.tickBorderData.color
      ..strokeWidth = data.tickBorderData.width;

    /// draw radar ticks
    ticks.sublist(0, ticks.length - 1).asMap().forEach(
      (index, tick) {
        final tickRadius = tickDistance * (index + 1);
        if (data.radarShape == RadarShape.circle) {
          canvasWrapper.drawCircle(centerOffset, tickRadius, _tickPaint);
        } else {
          canvasWrapper.drawPath(
            _generatePolygonPath(centerX, centerY, tickRadius, data.titleCount),
            _tickPaint,
          );
        }

        _ticksTextPaint
          ..text = TextSpan(
            text: tick.toStringAsFixed(1),
            style: Utils().getThemeAwareTextStyle(context, data.ticksTextStyle),
          )
          ..textDirection = TextDirection.ltr;
        _ticksTextPaint.layout(minWidth: 0, maxWidth: size.width);
        canvasWrapper.drawText(
          _ticksTextPaint,
          Offset(centerX + 5, centerY - tickRadius - _ticksTextPaint.height),
        );
      },
    );
  }

  Path _generatePolygonPath(
      double centerX, double centerY, double radius, int count) {
    final path = Path();
    path.moveTo(centerX, centerY - radius);
    final angle = (2 * pi) / count;
    for (var index = 0; index < count; index++) {
      final xAngle = cos(angle * index - pi / 2);
      final yAngle = sin(angle * index - pi / 2);
      path.lineTo(centerX + radius * xAngle, centerY + radius * yAngle);
    }
    path.lineTo(centerX, centerY - radius);
    return path;
  }

  void drawGrids(
      CanvasWrapper canvasWrapper, PaintHolder<RadarChartData> holder) {
    final data = holder.data;
    final size = canvasWrapper.size;

    final centerX = radarCenterX(size);
    final centerY = radarCenterY(size);
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = radarRadius(size);

    final angle = (2 * pi) / data.titleCount;

    /// drawing grids
    for (var index = 0; index < data.titleCount; index++) {
      final endX = centerX + radius * cos(angle * index - pi / 2);
      final endY = centerY + radius * sin(angle * index - pi / 2);

      final gridOffset = Offset(endX, endY);

      _gridPaint
        ..color = data.gridBorderData.color
        ..strokeWidth = data.gridBorderData.width;
      canvasWrapper.drawLine(centerOffset, gridOffset, _gridPaint);
    }
  }

  @visibleForTesting
  void drawTitles(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<RadarChartData> holder) {
    final data = holder.data;
    if (data.getTitle == null) return;

    final size = canvasWrapper.size;

    final centerX = radarCenterX(size);
    final centerY = radarCenterY(size);

    /// controls Radar chart size
    final radius = radarRadius(size);

    final diffAngle = (2 * pi) / data.titleCount;

    final style = Utils().getThemeAwareTextStyle(context, data.titleTextStyle);

    _titleTextPaint
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textScaleFactor = holder.textScale;

    for (var index = 0; index < data.titleCount; index++) {
      final baseTitleAngle = Utils().degrees(diffAngle * index);
      final title = data.getTitle!(index, baseTitleAngle);
      final span = TextSpan(text: title.text, style: style);
      _titleTextPaint.text = span;
      _titleTextPaint.layout();
      final angle = diffAngle * index - pi / 2;
      final threshold = 1.0 + data.titlePositionPercentageOffset;
      final titleX = centerX +
          cos(angle) * (radius * threshold + (_titleTextPaint.height / 2));
      final titleY = centerY +
          sin(angle) * (radius + threshold + (_titleTextPaint.height / 2));

      Rect rect = Rect.fromLTWH(
        titleX,
        titleY,
        _titleTextPaint.width,
        _titleTextPaint.height,
      );
      final rectDrawOffset = Offset(rect.left, rect.top);

      final drawTitleDegrees = (angle * 180 / pi) + 90;
      canvasWrapper.drawRotated(
        size: rect.size,
        rotationOffset: Offset(
          -rect.width / 2,
          -rect.height / 2,
        ),
        drawOffset: rectDrawOffset,
        angle: drawTitleDegrees,
        drawCallback: () {
          canvasWrapper.drawText(
            _titleTextPaint,
            rect.topLeft,
            title.angle - baseTitleAngle,
          );
        },
      );
    }
  }

  @visibleForTesting
  void drawDataSets(
      CanvasWrapper canvasWrapper, PaintHolder<RadarChartData> holder) {
    final data = holder.data;
    // we will use dataSetsPosition to draw the graphs
    dataSetsPosition ??= calculateDataSetsPosition(canvasWrapper.size, holder);
    dataSetsPosition!.asMap().forEach((index, dataSetOffset) {
      final graph = data.dataSets[index];
      _graphPaint
        ..color = graph.fillColor
        ..style = PaintingStyle.fill;

      _graphBorderPaint
        ..color = graph.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = graph.borderWidth;

      _graphPointPaint
        ..color = _graphBorderPaint.color
        ..style = PaintingStyle.fill;

      final path = Path();

      final firstOffset = Offset(
        dataSetOffset.entriesOffset.first.dx,
        dataSetOffset.entriesOffset.first.dy,
      );

      path.moveTo(firstOffset.dx, firstOffset.dy);

      canvasWrapper.drawCircle(
        firstOffset,
        graph.entryRadius,
        _graphPointPaint,
      );
      dataSetOffset.entriesOffset.asMap().forEach((index, pointOffset) {
        if (index == 0) return;

        path.lineTo(pointOffset.dx, pointOffset.dy);

        canvasWrapper.drawCircle(
          pointOffset,
          graph.entryRadius,
          _graphPointPaint,
        );
      });

      path.close();
      canvasWrapper.drawPath(path, _graphPaint);
      canvasWrapper.drawPath(path, _graphBorderPaint);
    });
  }

  RadarTouchedSpot? handleTouch(
      Offset touchedPoint, Size viewSize, PaintHolder<RadarChartData> holder) {
    final targetData = holder.targetData;
    dataSetsPosition ??= calculateDataSetsPosition(viewSize, holder);

    for (var i = 0; i < dataSetsPosition!.length; i++) {
      final dataSetPosition = dataSetsPosition![i];
      for (var j = 0; j < dataSetPosition.entriesOffset.length; j++) {
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

  @visibleForTesting
  double radarCenterY(Size size) => size.height / 2.0;

  @visibleForTesting
  double radarCenterX(Size size) => size.width / 2.0;

  @visibleForTesting
  double radarRadius(Size size) =>
      min(radarCenterX(size), radarCenterY(size)) * 0.8;

  @visibleForTesting
  List<RadarDataSetsPosition> calculateDataSetsPosition(
    Size viewSize,
    PaintHolder<RadarChartData> holder,
  ) {
    final data = holder.data;
    final centerX = radarCenterX(viewSize);
    final centerY = radarCenterY(viewSize);
    final radius = radarRadius(viewSize);

    final scale = radius / data.maxEntry.value;
    final angle = (2 * pi) / data.titleCount;

    final dataSetsPosition = List<RadarDataSetsPosition>.filled(
      data.dataSets.length,
      const RadarDataSetsPosition([]),
    );
    for (var i = 0; i < data.dataSets.length; i++) {
      final dataSet = data.dataSets[i];
      final entriesOffset =
          List<Offset>.filled(dataSet.dataEntries.length, Offset.zero);

      for (var j = 0; j < dataSet.dataEntries.length; j++) {
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
}

class RadarDataSetsPosition {
  final List<Offset> entriesOffset;

  const RadarDataSetsPosition(this.entriesOffset);
}
