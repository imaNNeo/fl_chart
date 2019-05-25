import 'dart:ui';

import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

class LineChartData extends FlAxisChartData {
  final LineChartBarData barData;
  final BelowBarData belowBarData;
  final FlDotData dotData;

  LineChartData({
    @required List<FlSpot> spots,
    this.barData = const LineChartBarData(),
    this.belowBarData = const BelowBarData(),
    this.dotData = const FlDotData(),
    FlGridData gridData = const FlGridData(),
    FlTitlesData titlesData = const FlTitlesData(),
    FlBorderData borderData = const FlBorderData(),
  }) : super(
          spots: spots,
          gridData: gridData,
          titlesData: titlesData,
          borderData: borderData,
        );
}

// Bar Data
class LineChartBarData {
  final bool show;

  final Color barColor;
  final double barWidth;
  final bool isCurved;
  final double curveSmoothness;

  const LineChartBarData({
    this.show = true,
    this.barColor = Colors.redAccent,
    this.barWidth = 2.0,
    this.isCurved = false,
    this.curveSmoothness = 0.35,
  });
}

// Below Bar Data
class BelowBarData {
  final bool show;

  final List<Color> colors;
  final Offset gradientFrom;
  final Offset gradientTo;
  final List<double> gradientColorStops;

  const BelowBarData({
    this.show = true,
    this.colors = const [Colors.blueGrey],
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.gradientColorStops = const [1.0],
  });
}


// Dot Data
typedef CheckToShowDot = bool Function(FlSpot spot);

bool showAllDots(FlSpot spot) {
  return true;
}

class FlDotData {
  final bool show;
  final Color dotColor;
  final double dotSize;
  final CheckToShowDot checkToShowDot;

  const FlDotData({
    this.show = true,
    this.dotColor = Colors.blue,
    this.dotSize = 4.0,
    this.checkToShowDot = showAllDots,
  });
}