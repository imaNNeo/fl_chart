import 'dart:ui';

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

/// Holds data for showing a title in each side (left, top, right, bottom) of the chart.
class FlAxisTitleData {
  final bool show;

  final AxisTitle leftTitle, topTitle, rightTitle, bottomTitle;

  /// [show] determines showing or hiding all titles,
  /// [leftTitle], [topTitle], [rightTitle], [bottomTitle] determines
  /// title for left, top, right, bottom axis sides respectively.
  const FlAxisTitleData({
    this.show = true,
    this.leftTitle = const AxisTitle(reservedSize: 16),
    this.topTitle = const AxisTitle(reservedSize: 16),
    this.rightTitle = const AxisTitle(reservedSize: 16),
    this.bottomTitle = const AxisTitle(reservedSize: 16),
  });

  static FlAxisTitleData lerp(FlAxisTitleData a, FlAxisTitleData b, double t) {
    return FlAxisTitleData(
      show: b.show,
      leftTitle: AxisTitle.lerp(a.leftTitle, b.leftTitle, t),
      rightTitle: AxisTitle.lerp(a.rightTitle, b.rightTitle, t),
      bottomTitle: AxisTitle.lerp(a.bottomTitle, b.bottomTitle, t),
      topTitle: AxisTitle.lerp(a.topTitle, b.topTitle, t),
    );
  }
}

/// Holds data for showing title of each side of charts.
class AxisTitle {

  /// You can show or hide it using [showTitle],
  final bool showTitle;

  /// Defines how much space it needed to draw.
  final double reservedSize;

  /// Determines the style of this.
  final TextStyle textStyle;

  /// Determines alignment of this title.
  final TextAlign textAlign;

  /// Determines margin of this title.
  final double margin;

  /// Determines the showing text.
  final String titleText;

  /// You can show or hide it using [showTitle],
  /// [titleText] determines the text, and
  /// [textStyle] determines the style of this.
  /// [textAlign] determines alignment of this title,
  /// [BaseChartPainter] uses [reservedSize] for assigning
  /// a space for drawing this side title, it used for
  /// some calculations.
  /// [margin] determines margin of this title.
  const AxisTitle({
    this.showTitle = false,
    this.titleText = '',
    this.reservedSize = 14,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.textAlign = TextAlign.center,
    this.margin = 4,
  });

  static AxisTitle lerp(AxisTitle a, AxisTitle b, double t) {
    return AxisTitle(
      showTitle: b.showTitle,
      titleText: b.titleText,
      reservedSize: lerpDouble(a.reservedSize, b.reservedSize, t),
      textStyle: TextStyle.lerp(a.textStyle.copyWith(fontSize: a.textStyle.fontSize),
        b.textStyle.copyWith(fontSize: b.textStyle.fontSize), t),
      textAlign: b.textAlign,
      margin: lerpDouble(a.margin, b.margin, t),
    );
  }
}

/// Holds data for showing titles on each side of charts (a title per each axis value).
class FlTitlesData {
  final bool show;

  final SideTitles leftTitles, topTitles, rightTitles, bottomTitles;

  /// [show] determines showing or hiding all titles,
  /// [leftTitles], [topTitles], [rightTitles], [bottomTitles] defines
  /// side titles of left, top, right, bottom sides respectively.
  const FlTitlesData({
    this.show = true,
    this.leftTitles = const SideTitles(reservedSize: 40, showTitles: true),
    this.topTitles = const SideTitles(reservedSize: 6),
    this.rightTitles = const SideTitles(
      reservedSize: 40,
    ),
    this.bottomTitles = const SideTitles(reservedSize: 22, showTitles: true),
  });

  static FlTitlesData lerp(FlTitlesData a, FlTitlesData b, double t) {
    return FlTitlesData(
      show: b.show,
      leftTitles: SideTitles.lerp(a.leftTitles, b.leftTitles, t),
      rightTitles: SideTitles.lerp(a.rightTitles, b.rightTitles, t),
      bottomTitles: SideTitles.lerp(a.bottomTitles, b.bottomTitles, t),
      topTitles: SideTitles.lerp(a.topTitles, b.topTitles, t),
    );
  }
}

/// Holds data for showing each side titles (a title per each axis value).
class SideTitles {
  final bool showTitles;
  final GetTitleFunction getTitles;
  final double reservedSize;
  final TextStyle textStyle;
  final double margin;
  final double interval;
  final double rotateAngle;

  /// It draws some title on all axis, per each axis value,
  /// [showTitles] determines showing or hiding this side,
  /// texts are depend on the axis value, you can override [getTitles],
  /// it gives you an axis value (double value), and you should return a string.
  ///
  /// [reservedSize] determines how much space they needed,
  /// [textStyle] determines the text style of them,
  /// [margin] determines margin of texts from the border line,
  ///
  /// by default, texts are showing with 1.0 interval,
  /// you can change this value using [interval],
  ///
  /// you can change rotation of drawing titles using [rotateAngle].
  const SideTitles({
    this.showTitles = false,
    this.getTitles = defaultGetTitle,
    this.reservedSize = 22,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.margin = 6,
    this.interval = 1.0,
    this.rotateAngle = 0.0,
  });

  static SideTitles lerp(SideTitles a, SideTitles b, double t) {
    return SideTitles(
      showTitles: b.showTitles,
      getTitles: b.getTitles,
      reservedSize: lerpDouble(a.reservedSize, b.reservedSize, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      margin: lerpDouble(a.margin, b.margin, t),
      interval: lerpDouble(a.interval, b.interval, t),
      rotateAngle: lerpDouble(a.rotateAngle, b.rotateAngle, t),
    );
  }
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
