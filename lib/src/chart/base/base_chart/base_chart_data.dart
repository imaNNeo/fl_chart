import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/utils/utils.dart';
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

/// Holds data to clipping chart around its borders.
class FlClipData with EquatableMixin {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  /// Creates data that clips specified sides
  FlClipData({
    @required this.top,
    @required this.bottom,
    @required this.left,
    @required this.right,
  });

  /// Creates data that clips all sides
  FlClipData.all() : this(top: true, bottom: true, left: true, right: true);

  /// Creates data that clips only top and bottom side
  FlClipData.vertical() : this(top: true, bottom: true, left: false, right: false);

  /// Creates data that clips only left and right side
  FlClipData.horizontal() : this(top: false, bottom: false, left: true, right: true);

  /// Creates data that doesn't clip any side
  FlClipData.none() : this(top: false, bottom: false, left: false, right: false);

  /// Checks whether any of the sides should be clipped
  bool get any => top || bottom || left || right;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [top, bottom, left, right];
}

/// It gives you the axis value and gets a String value based on it.
typedef GetTitleFunction = String Function(double value);

/// The default [SideTitles.getTitles] function.
///
/// formats the axis number to a shorter string using [formatNumber].
String defaultGetTitle(double value) {
  return formatNumber(value);
}

/// It gives you the axis value and gets a TextStyle based on given value
/// (you can customize a specific title using this).
typedef GetTitleTextStyleFunction = TextStyle Function(double value);

/// The default [SideTitles.getTextStyles] function.
///
/// returns a black TextStyle with 11 fontSize for all values.
TextStyle defaultGetTitleTextStyle(double value) {
  return const TextStyle(
    color: Colors.black,
    fontSize: 11,
  );
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
