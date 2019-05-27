import 'dart:ui';

import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

/// This class is responsible to holds data to draw Bar Chart
/// [barGroups] holds list of bar groups to show together,
/// [alignment] is the alignment of showing groups,
/// [titlesData] holds data about drawing left and bottom titles.
class BarChartData extends FlAxisChartData {
  final List<BarChartGroupData> barGroups;
  final BarChartAlignment alignment;
  final FlTitlesData titlesData;

  BarChartData({
    this.barGroups = const [],
    this.alignment = BarChartAlignment.spaceBetween,
    this.titlesData = const FlTitlesData(),
    FlGridData gridData = const FlGridData(
      show: false,
    ),
    FlBorderData borderData,
  }) : super(
          spots: groupsToFlSpots(barGroups),
          gridData: gridData,
          borderData: borderData,
        );

  /// we should pass a list of [FlSpot] to our parent [FlAxisChartData],
  /// the parent need it to know how much is our min and max values
  /// to calculate the scale of the chart,
  /// here we map the [barGroups] to the list of [FlSpot]
  static List<FlSpot> groupsToFlSpots(List<BarChartGroupData> barGroups) {
    List<FlSpot> spots = barGroups.expand((group) {
      return group.barRods.map((rodData) {
        double y = rodData.y;
        if (rodData.backDrawRodData.y > y) {
          y = rodData.backDrawRodData.y;
        }
        return FlSpot(group.x.toDouble(), y);
      }).toList();
    }).toList();

    return spots;
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
    this.x,
    this.barRods = const [],
    this.barsSpace = 2,
  });

  /// calculates the whole width of our group,
  /// by adding all rod's width and group space * rods count.
  double get width {
    if (barRods.length == 0) {
      return 0;
    }

    double sumWidth =
        barRods.map((rodData) => rodData.width).reduce((first, second) => first + second);
    double spaces = (barRods.length - 1) * barsSpace;

    return sumWidth + spaces;
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
}
