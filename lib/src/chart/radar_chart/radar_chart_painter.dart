import 'dart:math' show pi, cos, sin, min;
import 'dart:ui';

import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';

import '../../../fl_chart.dart';

/// Paints [RadarChartData] in the canvas, it can be used in a [CustomPainter]
class RadarChartPainter extends BaseChartPainter<RadarChartData> {
  late Paint _borderPaint, _backgroundPaint, _gridPaint, _tickPaint;
  late Paint _graphPaint, _graphBorderPaint, _graphPointPaint;
  late TextPainter _ticksTextPaint, _titleTextPaint;

  List<RadarDataSetsPosition>? dataSetsPosition;

  /// Paints [data] into canvas, it is the animating [RadarChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [data] is changing constantly.
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
  void paint(Canvas canvas, Size size, PaintHolder<RadarChartData> holder) {
    super.paint(canvas, size, holder);
    final data = holder.data;

    if (data.dataSets.isEmpty) {
      return;
    }

    final canvasWrapper = CanvasWrapper(canvas, size);

    dataSetsPosition = _calculateDataSetsPosition(canvasWrapper.size, holder);

    _drawGrids(canvasWrapper, holder);
    _drawTicks(canvasWrapper, holder);
    _drawTitles(canvasWrapper, holder);
    _drawDataSets(canvasWrapper, holder);
  }

  void _drawTicks(CanvasWrapper canvasWrapper, PaintHolder<RadarChartData> holder) {
    final data = holder.data;
    final size = canvasWrapper.size;

    final centerX = _radarCenterX(size);
    final centerY = _radarCenterY(size);
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = _radarRadius(size);

    /// draw radar background
    _backgroundPaint.color = data.radarBackgroundColor;
    canvasWrapper.drawCircle(centerOffset, radius, _backgroundPaint);

    /// draw radar border
    canvasWrapper.drawCircle(centerOffset, radius, _borderPaint);

    final dataSetMaxValue = data.maxEntry.value;
    final dataSetMinValue = data.minEntry.value;
    final tickSpace = (dataSetMaxValue - dataSetMinValue) / data.tickCount;

    final ticks = <double>[];

    for (var tick = dataSetMinValue; tick <= dataSetMaxValue; tick = tick + tickSpace) {
      ticks.add(tick);
    }

    final tickDistance = radius / (ticks.length);

    ticks.sublist(0, ticks.length - 1).asMap().forEach(
      (index, tick) {
        final tickRadius = tickDistance * (index + 1);
        _tickPaint.color = data.tickBorderData.color;
        _tickPaint.strokeWidth = data.tickBorderData.width;
        canvasWrapper.drawCircle(centerOffset, tickRadius, _tickPaint);
        _ticksTextPaint
          ..text = TextSpan(
            text: tick.toStringAsFixed(1),
            style: data.ticksTextStyle,
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

  void _drawGrids(CanvasWrapper canvasWrapper, PaintHolder<RadarChartData> holder) {
    final data = holder.data;
    final size = canvasWrapper.size;

    final centerX = _radarCenterX(size);
    final centerY = _radarCenterY(size);
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = _radarRadius(size);

    final angle = (2 * pi) / data.titleCount;

    //drawing grids
    for (var index = 0; index < data.titleCount; index++) {
      final endX = centerX + radius * cos(angle * index - pi / 2);
      final endY = centerY + radius * sin(angle * index - pi / 2);

      final gridOffset = Offset(endX, endY);

      _gridPaint.color = data.gridBorderData.color;
      _gridPaint.strokeWidth = data.gridBorderData.width;
      canvasWrapper.drawLine(centerOffset, gridOffset, _gridPaint);
    }
  }

  void _drawTitles(CanvasWrapper canvasWrapper, PaintHolder<RadarChartData> holder) {
    final data = holder.data;
    if (data.getTitle == null) return;

    final size = canvasWrapper.size;

    final centerX = _radarCenterX(size);
    final centerY = _radarCenterY(size);

    /// controls Radar chart size
    final radius = _radarRadius(size);

    final angle = (2 * pi) / data.titleCount;

    final style = data.titleTextStyle;

    _titleTextPaint
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textScaleFactor = holder.textScale;

    for (var index = 0; index < data.titleCount; index++) {
      final title = data.getTitle!(index);
      final xAngle = cos(angle * index - pi / 2);
      final yAngle = sin(angle * index - pi / 2);

      final span = TextSpan(text: title, style: style);
      _titleTextPaint.text = span;
      _titleTextPaint.layout();
      canvasWrapper.save();
      final titlePositionPercentageOffset = data.titlePositionPercentageOffset;
      final threshold = 1.0 + titlePositionPercentageOffset;
      final featureOffset = Offset(
        centerX + threshold * radius * xAngle,
        centerY + threshold * radius * yAngle,
      );
      canvasWrapper.translate(featureOffset.dx, featureOffset.dy);
      canvasWrapper.rotate(angle * index);

      canvasWrapper.drawText(
        _titleTextPaint,
        Offset.zero - Offset(_titleTextPaint.width / 2, _titleTextPaint.height / 2),
      );
      canvasWrapper.restore();
    }
  }

  void _drawDataSets(CanvasWrapper canvasWrapper, PaintHolder<RadarChartData> holder) {
    final data = holder.data;
    // we will use dataSetsPosition to draw the graphs
    dataSetsPosition!.asMap().forEach((index, dataSetOffset) {
      final graph = data.dataSets[index];
      _graphPaint
        ..color = graph.fillColor.withOpacity(graph.fillColor.opacity - 0.2)
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
      PointerEvent touchInput, Size size, PaintHolder<RadarChartData> holder) {
    return _getNearestTouchSpot(size, touchInput.localPosition, dataSetsPosition, holder);
  }

  double _radarCenterY(Size size) => size.height / 2.0;

  double _radarCenterX(Size size) => size.width / 2.0;

  double _radarRadius(Size size) => min(_radarCenterX(size), _radarCenterY(size)) * 0.8;

  RadarTouchedSpot? _getNearestTouchSpot(
    Size viewSize,
    Offset touchedPoint,
    List<RadarDataSetsPosition>? radarDataSetsPosition,
    PaintHolder<RadarChartData> holder,
  ) {
    final targetData = holder.targetData;
    radarDataSetsPosition ??= _calculateDataSetsPosition(viewSize, holder);

    for (var i = 0; i < radarDataSetsPosition.length; i++) {
      final dataSetPosition = radarDataSetsPosition[i];
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

  List<RadarDataSetsPosition> _calculateDataSetsPosition(
    Size viewSize,
    PaintHolder<RadarChartData> holder,
  ) {
    final data = holder.data;
    final centerX = _radarCenterX(viewSize);
    final centerY = _radarCenterY(viewSize);
    final radius = _radarRadius(viewSize);

    final scale = radius / data.maxEntry.value;
    final angle = (2 * pi) / data.titleCount;

    final dataSetsPosition = List<RadarDataSetsPosition>.filled(
      data.dataSets.length,
      RadarDataSetsPosition([]),
    );
    for (var i = 0; i < data.dataSets.length; i++) {
      final dataSet = data.dataSets[i];
      final entriesOffset = List<Offset>.filled(dataSet.dataEntries.length, Offset.zero);

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
