import 'dart:math';

import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_data.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

class GaugeChartPainter extends BaseChartPainter<GaugeChartData> {
  late Paint _backgroundPaint, _valuePaint, _tickPaint;

  GaugeChartPainter() : super() {
    _backgroundPaint = Paint()
      ..isAntiAlias = true;
    _valuePaint = Paint()
      ..isAntiAlias = true;
    _tickPaint = Paint();
  }

  @override
  void paint(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<GaugeChartData> holder) {
    super.paint(context, canvasWrapper, holder);

    drawValue(canvasWrapper, holder);
    drawTicks(canvasWrapper, holder);
  }
  
  @visibleForTesting
  void drawTicks(CanvasWrapper canvasWrapper, 
      PaintHolder<GaugeChartData> holder) {
    final data = holder.data;
    final ticks = data.ticks;
    if (ticks == null) return;

    final size = canvasWrapper.size;

    final centerOffset = center(size);
    final angleRange = data.endAngle - data.startAngle;
    final interTickAngle = angleRange / (ticks.count - 1);

    _tickPaint.color = ticks.color;

    final radius = gaugeRadius(size);

    /// draw radar ticks
    for(var i = 0; i < ticks.count; i++) {
      final angle = Utils().radians(data.startAngle + interTickAngle * i);
      _drawTick(canvasWrapper, centerOffset, angle, radius, ticks, data.strokeWidth);
    }

    final valueColor = data.valueColor;
    if (ticks.showChangingColorTicks && valueColor is ColoredTicksGenerator) {
      for(final tick in (valueColor as ColoredTicksGenerator).getColoredTicks()) {
        final angle = Utils().radians(data.startAngle + angleRange * tick.position);
        _tickPaint.color = tick.color;
        _drawTick(canvasWrapper, centerOffset, angle, radius, ticks, data.strokeWidth);
      }
    }
  }

  _drawTick(CanvasWrapper canvasWrapper, Offset center, double angle, double radius, GaugeTicks ticks, double strokeWidth) {
    double positionRadius;
    switch (ticks.position) {
      case GaugeTickPosition.inner:
        positionRadius = radius - strokeWidth - ticks.radius - ticks.margin;
        break;
      case GaugeTickPosition.outer:
        positionRadius = radius + ticks.radius + ticks.margin;
        break;
      case GaugeTickPosition.center:
        positionRadius = radius - strokeWidth / 2;
        break;
    }
    final tickX = center.dx + cos(angle) * positionRadius;
    final tickY = center.dy + sin(angle) * positionRadius;

    canvasWrapper.drawCircle(Offset(tickX, tickY), ticks.radius, _tickPaint);
  }

  @visibleForTesting
  void drawValue(CanvasWrapper canvasWrapper,
      PaintHolder<GaugeChartData> holder) {
    final data = holder.data;
    var size = Size.square(
      canvasWrapper.size.shortestSide - data.strokeWidth,
    );
    final demiStroke = data.strokeWidth / 2;
    var offset = Offset(
      max(canvasWrapper.size.width - canvasWrapper.size.height, 0) / 2 + demiStroke,
      max(canvasWrapper.size.height - canvasWrapper.size.width, 0) / 2 + demiStroke,
    );
    final backgroundColor = data.backgroundColor;

    final angleRange = data.endAngle - data.startAngle;

    // for(var i = 0; i < 3; i++) {
      /// Draw background if needed
      if(backgroundColor != null) {
        _backgroundPaint
          ..color = backgroundColor
          ..strokeWidth = data.strokeWidth
          ..strokeCap = data.strokeCap
          ..style = PaintingStyle.stroke;
        canvasWrapper.drawArc(
          offset & size,
          Utils().radians(data.startAngle),
          Utils().radians(angleRange),
          false,
          _backgroundPaint,
        );
      }

      /// Draw value
      _valuePaint
        ..color = data.valueColor.getColor(data.value)
        ..strokeWidth = data.strokeWidth
        ..strokeCap = data.strokeCap
        ..style = PaintingStyle.stroke;
      canvasWrapper.drawArc(
        offset & size,
        Utils().radians(data.startAngle),
        Utils().radians(angleRange * data.value.clamp(0, 1)),
        false,
        _valuePaint,
      );

    //   offset = offset + Offset(data.strokeWidth + 3, data.strokeWidth + 3);
    //   size = Size.square(size.width - 2 * (data.strokeWidth + 3));
    // }
  }

  GaugeTouchedSpot? handleTouch(
      Offset touchedPoint, Size viewSize, PaintHolder<GaugeChartData> holder) {
    return null;
  }

  @visibleForTesting
  Offset center(Size size) => Offset(size.width / 2.0, size.height / 2.0);

  @visibleForTesting
  double gaugeRadius(Size size) => size.shortestSide / 2;
}