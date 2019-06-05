import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:flutter/material.dart';

/// This class is responsible to holds data to draw Bar Chart
/// [barGroups] holds list of bar groups to show together,
/// [alignment] is the alignment of showing groups,
/// [titlesData] holds data about drawing left and bottom titles.
class BarChartData extends AxisChartData {
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
    double minX,
    double maxX,
    double minY,
    double maxY,
  }) : super(
          gridData: gridData,
          borderData: borderData,
        ) {
    initSuperMinMaxValues(minX, maxX, minY, maxY);
  }

  /// we have to tell [AxisChartData] how much is our
  /// minX, maxX, minY, maxY, values.
  /// here we get them in our constructor, but if each of them was null,
  /// we calculate it with the barGroups, and barRods data.
  void initSuperMinMaxValues(
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) {
    barGroups.forEach((barData) {
      if (barData.barRods == null || barData.barRods.isEmpty) {
        throw Exception('barRods could not be null or empty');
      }
    });

    if (barGroups.isNotEmpty) {
      var canModifyMinX = false;
      if (minX == null) {
        minX = barGroups[0].x.toDouble();
        canModifyMinX = true;
      }

      var canModifyMaxX = false;
      if (maxX == null) {
        maxX = barGroups[0].x.toDouble();
        canModifyMaxX = true;
      }

      var canModifyMinY = false;
      if (minY == null) {
        minY = barGroups[0].barRods[0].y;
        canModifyMinY = true;
      }

      var canModifyMaxY = false;
      if (maxY == null) {
        maxY = barGroups[0].barRods[0].y;
        canModifyMaxY = true;
      }

      barGroups.forEach((barGroup) {
        if (canModifyMaxX && barGroup.x.toDouble() > maxX) {
          maxX = barGroup.x.toDouble();
        }

        if (canModifyMinX && barGroup.x.toDouble() < minX) {
          minX = barGroup.x.toDouble();
        }

        barGroup.barRods.forEach((rod) {
          if (canModifyMaxY && rod.y > maxY) {
            maxY = rod.y;
          }

          if (canModifyMinY && rod.y < minY) {
            minY = rod.y;
          }

          if (canModifyMaxY && rod.backDrawRodData.y != null && rod.backDrawRodData.y > maxY) {
            maxY = rod.backDrawRodData.y;
          }

          if (canModifyMinY && rod.backDrawRodData.y != null && rod.backDrawRodData.y < minY) {
            minY = rod.backDrawRodData.y;
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

    super.minX = minX;
    super.maxX = maxX;
    super.minY = minY;
    super.maxY = maxY;
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
    if (barRods.isEmpty) {
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
