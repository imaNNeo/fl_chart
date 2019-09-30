import 'dart:async';
import 'dart:ui';

import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

/// This class is responsible to holds data to draw Bar Chart
/// [barGroups] holds list of bar groups to show together,
/// [alignment] is the alignment of showing groups,
/// [titlesData] holds data about drawing left and bottom titles.
class BarChartData extends AxisChartData {
  final List<BarChartGroupData> barGroups;
  final BarChartAlignment alignment;
  final FlTitlesData titlesData;
  final BarTouchData barTouchData;

  BarChartData({
    this.barGroups = const [],
    this.alignment = BarChartAlignment.spaceBetween,
    this.titlesData = const FlTitlesData(),
    this.barTouchData = const BarTouchData(),
    FlGridData gridData = const FlGridData(
      show: false,
    ),
    FlBorderData borderData,
    double maxY,
    Color backgroundColor,
  }) : super(
          gridData: gridData,
          borderData: borderData,
          backgroundColor: backgroundColor,
          touchData: barTouchData,
        ) {
    initSuperMinMaxValues(maxY);
  }

  /// we have to tell [AxisChartData] how much is our
  /// minX, maxX, minY, maxY, values.
  /// here we get them in our constructor, but if each of them was null,
  /// we calculate it with the barGroups, and barRods data.
  void initSuperMinMaxValues(
    double maxY,
  ) {
    barGroups.forEach((barData) {
      if (barData.barRods == null || barData.barRods.isEmpty) {
        throw Exception('barRods could not be null or empty');
      }
    });

    if (barGroups.isNotEmpty) {
      var canModifyMaxY = false;
      if (maxY == null) {
        maxY = barGroups[0].barRods[0].y;
        canModifyMaxY = true;
      }

      barGroups.forEach((barGroup) {
        barGroup.barRods.forEach((rod) {
          if (canModifyMaxY && rod.y > maxY) {
            maxY = rod.y;
          }

          if (canModifyMaxY &&
              rod.backDrawRodData.show &&
              rod.backDrawRodData.y != null &&
              rod.backDrawRodData.y > maxY) {
            maxY = rod.backDrawRodData.y;
          }
        });
      });
    } else {
      /// when list is empty
      minX = 0;
      maxX = 0;
      minY = 0;
      minX = 0;
    }

    super.minX = 0;
    super.maxX = 0;
    super.minY = 0;
    super.maxY = maxY;
  }

  BarChartData copyWith({
    List<BarChartGroupData> barGroups,
    BarChartAlignment alignment,
    FlTitlesData titlesData,
    FlGridData gridData,
    FlBorderData borderData,
    double maxY,
  }) {
    return BarChartData(
      barGroups: barGroups ?? this.barGroups,
      alignment: alignment ?? this.alignment,
      titlesData: titlesData ?? this.titlesData,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      maxY: maxY ?? this.maxY,
    );
  }

  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is BarChartData && b is BarChartData && t != null) {
      return BarChartData(
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        alignment: b.alignment,
        barGroups: lerpBarChartGroupDataList(a.barGroups, b.barGroups, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        barTouchData: b.barTouchData,
      );
    } else {
      throw Exception('Illegal State');
    }
  }
}

/// this is mimic of [MainAxisAlignment] to aligning the groups horizontally
enum BarChartAlignment {
  start,
  end,
  center,
  spaceEvenly,
  spaceAround,
  spaceBetween,
}

/***** BarChartGroupData *****/

/// holds list of vertical bars together as a group,
/// we call the vertical bars Rod, see [BarChartRodData],
/// if your chart doesn't have some bar lines grouped together,
/// you should use it with single child list.
class BarChartGroupData {
  @required
  final int x;
  final List<BarChartRodData> barRods;
  final double barsSpace;

  /// the [x] is the whole group x,
  /// [barRods] are our vertical bar lines, that each of them contains a y value,
  /// to draw them independently by y value together.
  /// [barsSpace] is the space between the bar lines inside group
  const BarChartGroupData({
    @required this.x,
    this.barRods = const [],
    this.barsSpace = 2,
  }) : assert(x != null);

  /// calculates the whole width of our group,
  /// by adding all rod's width and group space * rods count.
  double get width {
    if (barRods.isEmpty) {
      return 0;
    }

    double sumWidth = barRods
        .map((rodData) => rodData.width)
        .reduce((first, second) => first + second);
    double spaces = (barRods.length - 1) * barsSpace;

    return sumWidth + spaces;
  }

  BarChartGroupData copyWith({
    int x,
    List<BarChartRodData> barRods,
    double barsSpace,
  }) {
    return BarChartGroupData(
      x: x ?? this.x,
      barRods: barRods ?? this.barRods,
      barsSpace: barsSpace ?? this.barsSpace,
    );
  }

  static BarChartGroupData lerp(BarChartGroupData a, BarChartGroupData b, double t) {
    return BarChartGroupData(
      x: (a.x + (b.x - a.x) * t).round(),
      barRods: lerpBarChartRodDataList(a.barRods, b.barRods, t),
      barsSpace: lerpDouble(a.barsSpace, b.barsSpace, t),
    );
  }
}

/***** BarChartRodData *****/

/// This class holds data to show a single rod,
/// rod is a vertical bar line,
class BarChartRodData {
  final double y;
  final Color color;
  final double width;
  final bool isRound;
  final BackgroundBarChartRodData backDrawRodData;

  const BarChartRodData({
    this.y,
    this.color = Colors.blueAccent,
    this.width = 8,
    this.isRound = true,
    this.backDrawRodData = const BackgroundBarChartRodData(),
  });

  BarChartRodData copyWith({
    double y,
    Color color,
    double width,
    bool isRound,
    BackgroundBarChartRodData backDrawRodData,
  }) {
    return BarChartRodData(
      y: y ?? this.y,
      color: color ?? this.color,
      width: width ?? this.width,
      isRound: isRound ?? this.isRound,
      backDrawRodData: backDrawRodData ?? this.backDrawRodData,
    );
  }

  static BarChartRodData lerp(BarChartRodData a, BarChartRodData b, double t) {
    return BarChartRodData(
      color: Color.lerp(a.color, b.color, t),
      width: lerpDouble(a.width, b.width, t),
      isRound: b.isRound,
      y: lerpDouble(a.y, b.y, t),
      backDrawRodData: BackgroundBarChartRodData.lerp(a.backDrawRodData, b.backDrawRodData, t),
    );
  }
}

/// maybe in your design you should draw a behind bar
/// to represent the max value of the bar height [y]
/// by default it is not showing.
/// if you want to use it set [BackgroundBarChartRodData.show] true.
class BackgroundBarChartRodData {
  final bool show;
  final double y;
  final Color color;

  const BackgroundBarChartRodData({
    this.y = 8,
    this.show = false,
    this.color = Colors.blueGrey,
  });

  static BackgroundBarChartRodData lerp(BackgroundBarChartRodData a, BackgroundBarChartRodData b, double t) {
    return BackgroundBarChartRodData(
      y: lerpDouble(a.y, b.y, t),
      color: Color.lerp(a.color, b.color, t),
      show: b.show,
    );
  }
}

/// holds data for handling touch events on the [BarChart]
class BarTouchData extends FlTouchData {
  /// show a tooltip on touched spots
  final TouchTooltipData touchTooltipData;

  /// we find the nearest bar on touched position based on this threshold
  final EdgeInsets touchExtraThreshold;

  /// allow to touch the bar back draw
  final bool allowTouchBarBackDraw;

  const BarTouchData({
    bool enabled = true,
    bool enableNormalTouch = true,
    this.touchTooltipData = const TouchTooltipData(),
    this.touchExtraThreshold = const EdgeInsets.all(4),
    this.allowTouchBarBackDraw = false,
    StreamSink<BarTouchResponse> touchResponseSink,
  }) : super(enabled, touchResponseSink, enableNormalTouch);
}

/// holds the data of touch response on the [BarChart]
/// used in the [BarTouchData] in a [StreamSink]
class BarTouchResponse extends BaseTouchResponse {
  /// touch happened on this [BarTouchedSpot]
  final BarTouchedSpot spot;

  BarTouchResponse(
    this.spot,
    FlTouchInput touchInput,
  ) : super(touchInput);
}

/// holds the [BarChartGroupData] and the [BarChartRodData]
/// of the touched spot
class BarTouchedSpot extends TouchedSpot {
  final BarChartGroupData touchedBarGroup;
  final int touchedBarGroupPosition;

  final BarChartRodData touchedRodData;
  final int touchedRodDataPosition;

  BarTouchedSpot(
    this.touchedBarGroup,
    this.touchedBarGroupPosition,
    this.touchedRodData,
    this.touchedRodDataPosition,
    FlSpot spot,
    Offset offset,
  ) : super(spot, offset);

  @override
  Color getColor() {
    return Colors.black;
  }
}
