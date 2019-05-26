import 'dart:ui';

import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

/// This class holds data to draw the line chart
/// [LineChartBarData] the data to draw the bar line,
/// [BelowBarData] to fill space below the bar line,
/// [FlDotData] to show dot spots upon the line chart
/// [FlTitlesData] to show the bottom and left titles
class LineChartData extends FlAxisChartData {
  final LineChartBarData barData;
  final BelowBarData belowBarData;
  final FlDotData dotData;
  final FlTitlesData titlesData;

  LineChartData({
    @required List<FlSpot> spots,
    this.barData = const LineChartBarData(),
    this.belowBarData = const BelowBarData(),
    this.dotData = const FlDotData(),
    this.titlesData = const FlTitlesData(),
    FlGridData gridData = const FlGridData(),
    FlBorderData borderData = const FlBorderData(),
  }) : super(
          spots: spots,
          gridData: gridData,
          borderData: borderData,
        );
}

/***** LineChartBarData *****/
/// This class holds visualisation data about the bar line
/// use [isCurved] to set the bar line curve or sharp on connections spot.
class LineChartBarData {
  final bool show;

  final Color barColor;
  final double barWidth;
  final bool isCurved;

  /// if isCurved is true, this is important to us,
  /// this determines that how much we should curve the line
  /// on the spot connections.
  /// if it is 0.0, the lines draw with sharp corners.
  final double curveSmoothness;

  const LineChartBarData({
    this.show = true,
    this.barColor = Colors.redAccent,
    this.barWidth = 2.0,
    this.isCurved = false,
    this.curveSmoothness = 0.35,
  });
}

/***** BelowBarData *****/
/// This class holds data about draw on below space of the bar line,
class BelowBarData {
  final bool show;

  /// if you pass just one color, the solid color will be used,
  /// or if you pass more than one color, we use gradient mode to draw.
  /// then the [gradientFrom], [gradientTo] and [gradientColorStops] is important,
  final List<Color> colors;

  /// if the gradient mode is enabled (if you have more than one color)
  /// [gradientFrom] and [gradientTo] is important otherwise they will be skipped.
  /// you can determine where the gradient should start and end,
  /// values are available between 0 to 1,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right
  final Offset gradientFrom;
  final Offset gradientTo;

  /// if you have more than one color, fill it with
  /// equal or customized stops, for example if you have 3 colors,
  /// fill it like this : gradientColorStops = [0.33, 0.66, 1.0]
  final List<double> gradientColorStops;

  const BelowBarData({
    this.show = true,
    this.colors = const [Colors.blueGrey],
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.gradientColorStops = const [1.0],
  });
}


/***** DotData *****/
typedef CheckToShowDot = bool Function(FlSpot spot);

bool showAllDots(FlSpot spot) {
  return true;
}

/// This class holds data about drawing spot dots on the drawing bar line.
class FlDotData {
  final bool show;
  final Color dotColor;
  final double dotSize;

  /// with this field you can determine which dot should show,
  /// for example you can draw just the last spot dot.
  final CheckToShowDot checkToShowDot;

  const FlDotData({
    this.show = true,
    this.dotColor = Colors.blue,
    this.dotSize = 4.0,
    this.checkToShowDot = showAllDots,
  });
}