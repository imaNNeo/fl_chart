import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

class ColoredTick {
  final double position;
  final Color color;

  const ColoredTick(this.position, this.color);
}

abstract class ColoredTicksGenerator {
  Iterable<ColoredTick> getColoredTicks();
}

@immutable
abstract class GaugeColor {
  Color getColor(double value);

  static GaugeColor lerp(GaugeColor a, GaugeColor b, double t) {
    return _LerpGaugeColor(a, b, t);
  }
}

class _LerpGaugeColor implements GaugeColor, ColoredTicksGenerator {
  final GaugeColor a, b;
  final double t;
  _LerpGaugeColor(this.a, this.b, this.t);

  @override
  Color getColor(double value) {
    return Color.lerp(a.getColor(value), b.getColor(value), t)!;
  }

  @override
  Iterable<ColoredTick> getColoredTicks() sync* {
    if (a is ColoredTicksGenerator) {
      for (final tick in (a as ColoredTicksGenerator).getColoredTicks()) {
        yield ColoredTick(tick.position, tick.color.withOpacity(1 - t));
      }
    }
    if (b is ColoredTicksGenerator) {
      for (final tick in (b as ColoredTicksGenerator).getColoredTicks()) {
        yield ColoredTick(tick.position, tick.color.withOpacity(t));
      }
    }
  }
}

@immutable
class SimpleGaugeColor implements GaugeColor {
  final Color color;
  const SimpleGaugeColor({required this.color});

  @override
  Color getColor(double value) => color;
}

class VariableGaugeColor implements GaugeColor, ColoredTicksGenerator {
  final List<double> limits;
  final List<Color> colors;

  VariableGaugeColor({
    required this.limits,
    required this.colors,
  }) : assert(
    colors.length - 1 == limits.length,
    'length of limits should be equals to colors length minus one'
  ) {
    assert(
      limits.reduce((a, b) => a < b ? 0 : 2) == 0,
      'the limits list should be sorted in ascending order',
    );
    assert(
      limits.first > 0 || limits.last < 1.0,
      'limits values should be in range 0, 1 (exclusive)',
    );
  }

  @override
  Color getColor(double value) {
    for (var i = 0; i < limits.length; i++) {
      if (value < limits[i]) return colors[i];
    }
    return colors.last;
  }

  @override
  Iterable<ColoredTick> getColoredTicks() sync* {
    for(var i = 0; i < limits.length; i++) {
      yield ColoredTick(limits[i], colors[i + 1]);
    }
  }
}

enum GaugeTickPosition {
  inner,
  outer,
  center,
}

@immutable
class GaugeTicks {
  final int count;
  final double radius;
  final Color color;
  final GaugeTickPosition position;
  final double margin;
  final bool showChangingColorTicks;

  const GaugeTicks({
    this.count = 3,
    this.radius = 3.0,
    required this.color,
    this.position = GaugeTickPosition.outer,
    this.margin = 3,
    this.showChangingColorTicks = true,
  }) : assert(count > 2, 'count should be >= 2'),
        assert(radius > 0, 'radius should be > 0');

  static GaugeTicks? lerp(GaugeTicks? a, GaugeTicks? b, double t) {
    if (a == null || b == null) return b;
    return GaugeTicks(
      color: Color.lerp(a.color, b.color, t)!,
      count: lerpInt(a.count, b.count, t),
      margin: lerpDouble(a.margin, b.margin, t)!,
      position: b.position,
      radius: lerpDouble(a.radius, b.radius, t)!,
      showChangingColorTicks: b.showChangingColorTicks,
    );
  }
}

class GaugeChartData extends BaseChartData with EquatableMixin {
  final StrokeCap strokeCap;
  final double value;
  final double strokeWidth;
  final GaugeColor valueColor;
  final Color? backgroundColor;
  final double startAngle;
  final double endAngle;
  final GaugeTouchData gaugeTouchData;
  final GaugeTicks? ticks;

  GaugeChartData({
    this.strokeCap = StrokeCap.butt,
    this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.strokeWidth,
    required this.startAngle,
    required this.endAngle,
    this.ticks,
    FlBorderData? borderData,
    GaugeTouchData? touchData,
  }) : gaugeTouchData = touchData ?? GaugeTouchData(),
        super(
          borderData: borderData,
          touchData: touchData ?? GaugeTouchData());

  GaugeChartData copyWith({
    StrokeCap? strokeCap,
    Color? backgroundColor,
    GaugeColor? valueColor,
    double? value,
    double? strokeWidth,
    double? startAngle,
    double? endAngle,
    GaugeTicks? ticks,
    FlBorderData? borderData,
    GaugeTouchData? gaugeTouchData,
  }) =>
      GaugeChartData(
        strokeCap: strokeCap ?? this.strokeCap,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        valueColor: valueColor ?? this.valueColor,
        value: value ?? this.value,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        startAngle: startAngle ?? this.startAngle,
        endAngle: endAngle ?? this.endAngle,
        ticks: ticks ?? this.ticks,
        borderData: borderData ?? this.borderData,
        touchData: gaugeTouchData ?? this.gaugeTouchData,
      );


  @override
  GaugeChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is GaugeChartData && b is GaugeChartData) {
      return GaugeChartData(
        ticks: GaugeTicks.lerp(a.ticks, b.ticks, t),
        strokeCap: b.strokeCap,
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        valueColor: GaugeColor.lerp(a.valueColor, b.valueColor, t),
        value: lerpDouble(a.value, b.value, t)!,
        strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t)!,
        startAngle: lerpDouble(a.startAngle, b.startAngle, t)!,
        endAngle: lerpDouble(a.endAngle, b.endAngle, t)!,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  @override
  List<Object?> get props => [
    ticks,
    strokeCap,
    backgroundColor,
    valueColor,
    value,
    strokeWidth,
    startAngle,
    endAngle,
  ];
}

class GaugeTouchData extends FlTouchData<GaugeTouchResponse> {
  GaugeTouchData({
    bool? enabled,
    BaseTouchCallback<GaugeTouchResponse>? touchCallback,
    MouseCursorResolver<GaugeTouchResponse>? mouseCursorResolver
  }) : super(enabled ?? true, touchCallback, mouseCursorResolver);
}

class GaugeTouchResponse extends BaseTouchResponse {
  GaugeTouchResponse(GaugeTouchedSpot? touchedSpot);
}

class GaugeTouchedSpot extends TouchedSpot with EquatableMixin {
  GaugeTouchedSpot(FlSpot spot, Offset offset) : super(spot, offset);
}

/// It lerps a [GaugeChartData] to another [GaugeChartData] (handles animation for updating values)
class GaugeChartDataTween extends Tween<GaugeChartData> {
  GaugeChartDataTween({
    required GaugeChartData begin,
    required GaugeChartData end,
  }) : super(begin: begin, end: end);

  /// Lerps a [GaugeChartData] based on [t] value, check [Tween.lerp].
  @override
  GaugeChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}