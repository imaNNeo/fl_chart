import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'base_chart_painter.dart';
import 'touch_input.dart';

/// This class holds all data needed for [BaseChartPainter].
///
/// In this phase we draw the border,
/// and handle touches in an abstract way.
abstract class BaseChartData with EquatableMixin {
  /// Holds data to drawing border around the chart.
  FlBorderData borderData;

  /// Holds data needed to touch behavior and responses.
  FlTouchData touchData;

  /// It draws 4 borders around your chart, you can customize it using [borderData],
  /// [touchData] defines the touch behavior and responses.
  BaseChartData({
    FlBorderData borderData,
    FlTouchData touchData,
  })  : borderData = borderData ?? FlBorderData(),
        touchData = touchData;

  BaseChartData lerp(BaseChartData a, BaseChartData b, double t);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        borderData,
        touchData,
      ];
}

/// Holds data to drawing border around the chart.
class FlBorderData with EquatableMixin {
  final bool show;
  Border border;

  /// [show] Determines showing or hiding border around the chart.
  /// [border] Determines the visual look of 4 borders, see [Border].
  FlBorderData({
    bool show,
    Border border,
  })  : show = show ?? true,
        border = border ??
            Border.all(
              color: Colors.black,
              width: 1.0,
              style: BorderStyle.solid,
            );

  /// Lerps a [FlBorderData] based on [t] value, check [Tween.lerp].
  static FlBorderData lerp(FlBorderData a, FlBorderData b, double t) {
    assert(a != null && b != null && t != null);
    return FlBorderData(
      show: b.show,
      border: Border.lerp(a.border, b.border, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        show,
        border,
      ];
}

/// Holds data to handle touch events, and touch responses in abstract way.
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [BaseTouchResponse].
class FlTouchData with EquatableMixin {
  /// You can disable or enable the touch system using [enabled] flag,
  final bool enabled;

  /// You can disable or enable the touch system using [enabled] flag,
  FlTouchData(bool enabled) : enabled = enabled;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        enabled,
      ];
}

/// It gives you the axis value and gets a String value based on it.
typedef GetTitleFunction = String Function(double value);

/// The default [SideTitles.getTitles] function.
///
/// It maps the axis number to a string and returns it.
String defaultGetTitle(double value) {
  return '$value';
}

/// This class holds the touch response details.
///
/// Specific touch details should be hold on the concrete child classes.
class BaseTouchResponse with EquatableMixin {
  final FlTouchInput touchInput;

  BaseTouchResponse(FlTouchInput touchInput) : touchInput = touchInput;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        touchInput,
      ];
}
