import 'dart:ui';

import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

class BarChartData extends FlAxisChartData {
  final List<BarChartRodData> barSpots;

  BarChartData({
    this.barSpots = const [],
    FlGridData gridData = const FlGridData(show: false,),
    FlTitlesData titlesData = const FlTitlesData(show: true, showVerticalTitles: false),
    FlBorderData borderData = const FlBorderData(show: true, borderColor: Colors.black12),
    AxisDotData dotData = const AxisDotData(show: false),
  }) : super(
    spots: barSpots,
    gridData: gridData,
    dotData: dotData,
    titlesData: titlesData,
    borderData: borderData,
  );

}

// Bar Data
class BarChartRodData extends AxisSpot{
  final Color color;
  final double width;

  const BarChartRodData({
    this.color,
    this.width,
    double x,
    double y,
  }) : super(x, y);
}