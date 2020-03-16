import 'package:flutter/material.dart';

import 'base_chart_painter.dart';
import 'touch_input.dart';

/// This class holds all data needed for [BaseChartPainter].
///
/// In this phase we draw the border,
/// and handle touches in an abstract way.
abstract class BaseChartData {

  /// Holds data to drawing border around the chart.
  FlBorderData borderData;

  /// Holds data needed to touch behavior and responses.
  FlTouchData touchData;

  /// It draws 4 borders around your chart, you can customize it using [borderData],
  /// [touchData] defines the touch behavior and responses.
  BaseChartData({
    this.borderData,
    this.touchData,
  }) {
    borderData ??= FlBorderData();
  }

  BaseChartData lerp(BaseChartData a, BaseChartData b, double t);
}

/// Holds data to drawing border around the chart.
class FlBorderData {
  final bool show;
  Border border;

  /// [show] Determines showing or hiding border around the chart.
  /// [border] Determines the visual look of 4 borders, see [Border].
  FlBorderData({
    this.show = true,
    this.border,
  }) {
    border ??= Border.all(
      color: Colors.black,
      width: 1.0,
      style: BorderStyle.solid,
    );
  }

  /// Lerps a [FlBorderData] based on [t] value, check [Tween.lerp].
  static FlBorderData lerp(FlBorderData a, FlBorderData b, double t) {
    assert(a != null && b != null && t != null);
    return FlBorderData(
      show: b.show,
      border: Border.lerp(a.border, b.border, t),
    );
  }
}

/// Holds data to handle touch events, and touch responses in abstract way.
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [BaseTouchResponse].
class FlTouchData {

  /// You can disable or enable the touch system using [enabled] flag,
  final bool enabled;

  /// You can disable or enable the touch system using [enabled] flag,
  const FlTouchData(this.enabled);

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
class BaseTouchResponse {
  final FlTouchInput touchInput;

  BaseTouchResponse(this.touchInput);
}
