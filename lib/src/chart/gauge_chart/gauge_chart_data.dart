import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/widgets.dart';

class ColoredTick with EquatableMixin {
  const ColoredTick(this.position, this.color);
  final double position;
  final Color color;

  @override
  List<Object?> get props => [position, color];
}

mixin ColoredTicksGenerator {
  Iterable<ColoredTick> getColoredTicks();
}

/// [GaugeChart] needs this class to render itself.
///
/// It holds data needed to draw a gauge chart
class GaugeChartData extends BaseChartData with EquatableMixin {
  GaugeChartData({
    this.strokeCap = StrokeCap.butt,
    this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.strokeWidth,
    this.startDegreeOffset = 0.0,
    this.direction = GaugeDirection.clockwise,
    required this.sweepAngle,
    this.ticks,
    GaugeTouchData? touchData,
    super.borderData,
  })  : gaugeTouchData = touchData ?? GaugeTouchData();

  final StrokeCap strokeCap;
  final double value;
  final double strokeWidth;
  final GaugeColor valueColor;
  final Color? backgroundColor;
  final double startDegreeOffset;
  final GaugeDirection direction;
  final double sweepAngle;
  final GaugeTouchData gaugeTouchData;
  final GaugeTicks? ticks;

  @override
  List<Object?> get props => [
        ticks,
        strokeCap,
        backgroundColor,
        valueColor,
        value,
        strokeWidth,
        startDegreeOffset,
        direction,
        sweepAngle,
        gaugeTouchData,
        borderData,
      ];

  GaugeChartData copyWith({
    StrokeCap? strokeCap,
    Color? backgroundColor,
    GaugeColor? valueColor,
    double? value,
    double? strokeWidth,
    double? startDegreeOffset,
    GaugeDirection? direction,
    double? sweepAngle,
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
        startDegreeOffset: startDegreeOffset ?? this.startDegreeOffset,
        direction: direction ?? this.direction,
        sweepAngle: sweepAngle ?? this.sweepAngle,
        ticks: ticks ?? this.ticks,
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
        startDegreeOffset: lerpDouble(a.startDegreeOffset, b.startDegreeOffset, t)!,
        direction: b.direction,
        sweepAngle: lerpDouble(a.sweepAngle, b.sweepAngle, t)!,
        touchData: b.gaugeTouchData,
      );
    } else {
      throw Exception('Illegal State');
    }
  }
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

@immutable
class GaugeColor with EquatableMixin implements ColoredTicksGenerator {
  GaugeColor({
    required this.colors,
    this.limits,
  }) : assert(colors.isNotEmpty, 'colors list must not be empty') {
    if (colors.length > 1 && limits != null) {
      assert(
        limits!.length == colors.length - 1,
        'length of limits should be equals to colors length minus one',
      );
      assert(
        limits!.length <= 1 || limits!.reduce((a, b) => a < b ? 0 : 2) == 0,
        'the limits list should be sorted in ascending order',
      );
      if (limits!.isNotEmpty) {
        assert(
          limits!.first > 0 && limits!.last < 1.0,
          'limits values should be in range 0, 1 (exclusive)',
        );
      }
    }
  }

  /// Factory constructor for single color
  factory GaugeColor.simple({required Color color}) {
    return GaugeColor(colors: [color]);
  }

  final List<double>? limits;
  final List<Color> colors;

  @override
  List<Object?> get props => [_effectiveLimits, colors];

  List<double> get _effectiveLimits {
    if (colors.length == 1) {
      return [];
    }
    if (limits != null) {
      return limits!;
    }
    // Calculate limits automatically by dividing the space evenly
    final step = 1.0 / (colors.length - 1);
    return [for (var i = 1; i < colors.length; i++) i * step];
  }

  Color getColor(double value) {
    if (colors.length == 1) {
      return colors.first;
    }
    final effectiveLimits = _effectiveLimits;
    for (var i = 0; i < effectiveLimits.length; i++) {
      if (value < effectiveLimits[i]) return colors[i];
    }
    return colors.last;
  }

  @override
  Iterable<ColoredTick> getColoredTicks() sync* {
    if (colors.length == 1) {
      return;
    }
    final effectiveLimits = _effectiveLimits;
    for (var i = 0; i < effectiveLimits.length; i++) {
      yield ColoredTick(effectiveLimits[i], colors[i + 1]);
    }
  }

  /// Lerps a [GaugeColor] to another [GaugeColor] (handles animation for updating values)
  static GaugeColor lerp(GaugeColor a, GaugeColor b, double t) {
    return _LerpGaugeColor(a, b, t);
  }
}

enum GaugeDirection {
  clockwise,
  counterClockwise,
}

enum GaugeTickPosition {
  inner,
  outer,
  center,
}

@immutable
class GaugeTicks with EquatableMixin {
  const GaugeTicks({
    this.count = 3,
    this.radius = 3.0,
    required this.color,
    this.position = GaugeTickPosition.outer,
    this.margin = 3,
    this.showChangingColorTicks = true,
  })  : assert(count > 2, 'count should be >= 2'),
        assert(radius > 0, 'radius should be > 0');
  final int count;
  final double radius;
  final Color color;
  final GaugeTickPosition position;
  final double margin;
  final bool showChangingColorTicks;

  @override
  List<Object?> get props =>
      [count, radius, color, position, margin, showChangingColorTicks];

  static GaugeTicks? lerp(GaugeTicks? a, GaugeTicks? b, double t) {
    // TODO(FlorianArnould): if showChangingColorTicks are different
    // or just a or b is null, handle this with a fade like effect by replacing
    // the null value with a default one
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

class GaugeTouchData extends FlTouchData<GaugeTouchResponse>
    with EquatableMixin {
  GaugeTouchData({
    bool? enabled,
    BaseTouchCallback<GaugeTouchResponse>? touchCallback,
    MouseCursorResolver<GaugeTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
  }) : super(
          enabled ?? true,
          touchCallback,
          mouseCursorResolver,
          longPressDuration,
        );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
        longPressDuration,
      ];
}

class GaugeTouchedSpot extends TouchedSpot with EquatableMixin {
  GaugeTouchedSpot(super.spot, super.offset);
}

class GaugeTouchResponse extends BaseTouchResponse {
  GaugeTouchResponse({required super.touchLocation, required this.touchedSpot});

  final GaugeTouchedSpot? touchedSpot;

  /// Copies current [GaugeTouchResponse] to a new [GaugeTouchResponse],
  /// and replaces provided values.
  GaugeTouchResponse copyWith({
    Offset? touchLocation,
    GaugeTouchedSpot? touchedSpot,
  }) =>
      GaugeTouchResponse(
        touchLocation: touchLocation ?? this.touchLocation,
        touchedSpot: touchedSpot ?? this.touchedSpot,
      );
}

class _LerpGaugeColor extends GaugeColor {
  _LerpGaugeColor(this.a, this.b, this.t)
      : super(
          colors: [
            ...a.colors,
            ...b.colors,
          ],
        );
  final GaugeColor a;
  final GaugeColor b;
  final double t;

  @override
  Color getColor(double value) {
    return Color.lerp(a.getColor(value), b.getColor(value), t)!;
  }

  @override
  Iterable<ColoredTick> getColoredTicks() sync* {
    for (final tick in a.getColoredTicks()) {
      yield ColoredTick(tick.position, tick.color.withValues(alpha: 1 - t));
    }
    for (final tick in b.getColoredTicks()) {
      yield ColoredTick(tick.position, tick.color.withValues(alpha: t));
    }
  }
}
