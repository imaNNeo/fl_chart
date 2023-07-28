import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

class GaugeChartPainter extends BaseChartPainter<GaugeChartData> {
  GaugeChartPainter() : super() {
    _backgroundPaint = Paint()..isAntiAlias = true;
    _valuePaint = Paint()..isAntiAlias = true;
    _tickPaint = Paint();
  }

  late Paint _backgroundPaint;
  late Paint _valuePaint;
  late Paint _tickPaint;

  GaugePosition? _gaugePosition;

  @override
  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<GaugeChartData> holder,
  ) {
    super.paint(context, canvasWrapper, holder);

    drawValue(canvasWrapper, holder);
    drawTicks(canvasWrapper, holder);
  }

  @visibleForTesting
  void drawTicks(
    CanvasWrapper canvasWrapper,
    PaintHolder<GaugeChartData> holder,
  ) {
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
    for (var i = 0; i < ticks.count; i++) {
      final angle = Utils().radians(data.startAngle + interTickAngle * i);
      _drawTick(
        canvasWrapper,
        centerOffset,
        angle,
        radius,
        ticks,
        data.strokeWidth,
      );
    }

    final valueColor = data.valueColor;
    if (ticks.showChangingColorTicks && valueColor is ColoredTicksGenerator) {
      for (final tick
          in (valueColor as ColoredTicksGenerator).getColoredTicks()) {
        final angle =
            Utils().radians(data.startAngle + angleRange * tick.position);
        _tickPaint.color = tick.color;
        _drawTick(
          canvasWrapper,
          centerOffset,
          angle,
          radius,
          ticks,
          data.strokeWidth,
        );
      }
    }
  }

  void _drawTick(
    CanvasWrapper canvasWrapper,
    Offset center,
    double angle,
    double radius,
    GaugeTicks ticks,
    double strokeWidth,
  ) {
    final positionRadius = switch (ticks.position) {
      GaugeTickPosition.inner =>
        radius - strokeWidth - ticks.radius - ticks.margin,
      GaugeTickPosition.outer => radius + ticks.radius + ticks.margin,
      GaugeTickPosition.center => radius - strokeWidth / 2,
    };
    final tickX = center.dx + cos(angle) * positionRadius;
    final tickY = center.dy + sin(angle) * positionRadius;

    canvasWrapper.drawCircle(Offset(tickX, tickY), ticks.radius, _tickPaint);
  }

  GaugePosition _calculateValuePosition(
    Size viewSize,
    PaintHolder<GaugeChartData> holder,
  ) {
    final data = holder.data;
    final size = Size.square(
      viewSize.shortestSide - data.strokeWidth,
    );
    final demiStroke = data.strokeWidth / 2;
    final offset = Offset(
      max(viewSize.width - viewSize.height, 0) / 2 + demiStroke,
      max(viewSize.height - viewSize.width, 0) / 2 + demiStroke,
    );
    final angleRange = data.endAngle - data.startAngle;
    return GaugePosition(
      offset & size,
      data.strokeCap,
      data.strokeWidth,
      angleRange,
      data.startAngle,
      angleRange * data.value.clamp(0, 1),
    );
  }

  @visibleForTesting
  void drawValue(
    CanvasWrapper canvasWrapper,
    PaintHolder<GaugeChartData> holder,
  ) {
    final data = holder.data;

    final backgroundColor = data.backgroundColor;
    final position =
        _gaugePosition = _calculateValuePosition(canvasWrapper.size, holder);

    // for(var i = 0; i < 3; i++) {
    /// Draw background if needed
    if (backgroundColor != null) {
      _backgroundPaint
        ..color = backgroundColor
        ..strokeWidth = data.strokeWidth
        ..strokeCap = data.strokeCap
        ..style = PaintingStyle.stroke;
      canvasWrapper.drawArc(
        position.rect,
        Utils().radians(position.startAngle),
        Utils().radians(position.angleRange),
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
      position.rect,
      Utils().radians(position.startAngle),
      Utils().radians(position.angleSize),
      false,
      _valuePaint,
    );

    //   offset = offset + Offset(data.strokeWidth + 3, data.strokeWidth + 3);
    //   size = Size.square(size.width - 2 * (data.strokeWidth + 3));
    // }
  }

  GaugeTouchedSpot? handleTouch(
    Offset touchedPoint,
    Size viewSize,
    PaintHolder<GaugeChartData> holder,
  ) {
    final position =
        _gaugePosition ??= _calculateValuePosition(viewSize, holder);
    if (position.contains(touchedPoint)) {
      final offset = position.getInterestSpot();
      return GaugeTouchedSpot(
        FlSpot(offset.dx, offset.dy),
        offset,
      );
    }
    return null;
  }

  @visibleForTesting
  Offset center(Size size) => Offset(size.width / 2.0, size.height / 2.0);

  @visibleForTesting
  double gaugeRadius(Size size) => size.shortestSide / 2;
}

class GaugePosition {
  GaugePosition(
    this.rect,
    this.strokeCap,
    this.strokeWidth,
    this.angleRange,
    this.startAngle,
    this.angleSize,
  );

  final Rect rect;
  final double strokeWidth;
  final double angleRange;
  final double startAngle;
  final double angleSize;
  final StrokeCap strokeCap;

  Range _calculateValidValueRange() {
    final radius = rect.shortestSide / 2;
    final halfStroke = strokeWidth / 2;
    return Range.fromValues(radius - halfStroke, radius + halfStroke);
  }

  Offset getInterestSpot() {
    final radius = rect.shortestSide / 2;
    final averageAngle = startAngle + angleSize / 2;
    return rect.center +
        Offset.fromDirection(Utils().radians(averageAngle), radius);
  }

  bool contains(Offset point) {
    final vector = point - rect.center;
    var start = startAngle;
    var end = angleSize < 0 ? angleSize + startAngle : angleSize - startAngle;
    if (strokeCap != StrokeCap.butt) {
      final strokeRadius = strokeWidth / 2;
      final radius = rect.shortestSide / 2;
      final bonusAngle = 180 * strokeRadius / (pi * radius);
      start = angleSize < 0 ? start + bonusAngle : start - bonusAngle;
      end = angleSize < 0 ? end - bonusAngle : end + bonusAngle;
    }
    return _calculateValidValueRange().contains(vector.distance) &&
        DegreeAngleRange(start, end)
            .contains(Utils().degrees(vector.direction));
  }
}

class Range {
  const Range._(this.min, this.max);
  factory Range.fromValues(double a, double b) {
    return a > b ? Range._(b, a) : Range._(a, b);
  }

  final double min;
  final double max;

  bool contains(double value) {
    return min <= value && max >= value;
  }
}

class DegreeAngleRange {
  const DegreeAngleRange(this.start, this.end);
  final double start;
  final double end;

  bool contains(double angle) {
    final ref = (end - start) < 0 ? end - start + 360 : end - start;
    final value = (angle - start) < 0 ? angle - start + 360 : angle - start;
    return end < start ? value > ref : value < ref;
  }
}
