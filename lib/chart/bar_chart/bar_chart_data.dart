import 'dart:ui';

import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

class BarChartData extends FlAxisChartData {
  final List<BarChartGroupData> barGroups;
  final BarChartAlignment alignment;

  BarChartData({
    this.barGroups = const [],
    this.alignment = BarChartAlignment.spaceBetween,
    FlGridData gridData = const FlGridData(
      show: false,
    ),
    FlTitlesData titlesData = const FlTitlesData(show: true, showVerticalTitles: false),
    FlBorderData borderData = const FlBorderData(show: true, borderColor: Colors.black12),
    FlDotData dotData = const FlDotData(show: false),
  }) : super(
          spots: groupsToFlSpots(barGroups),
          gridData: gridData,
          dotData: dotData,
          titlesData: titlesData,
          borderData: borderData,
        );

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

enum BarChartAlignment {
  start,
  end,
  center,
  spaceEvenly,
  spaceAround,
  spaceBetween,
}

// Bar Chart Group Data
class BarChartGroupData {
  @required
  final int x;
  final List<BarChartRodData> barRods;
  final double barsSpace;

  const BarChartGroupData({
    this.x,
    this.barRods = const [],
    this.barsSpace = 2,
  });

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

// Bar Data
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
