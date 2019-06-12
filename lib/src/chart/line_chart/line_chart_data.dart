import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:flutter/material.dart';

/// This class holds data to draw the line chart
/// List [LineChartBarData] the data to draw the bar lines independently,
/// [FlTitlesData] to show the bottom and left titles
class LineChartData extends AxisChartData {
  final List<LineChartBarData> lineBarsData;
  final FlTitlesData titlesData;
  final ExtraLinesData extraLinesData;

  LineChartData({
    this.lineBarsData = const [],
    this.titlesData = const FlTitlesData(),
    this.extraLinesData = const ExtraLinesData(),
    FlGridData gridData = const FlGridData(),
    FlBorderData borderData,
    double minX,
    double maxX,
    double minY,
    double maxY,
    bool clipToBorder = false,
  }) : super(
    gridData: gridData,
    borderData: borderData,
    clipToBorder: clipToBorder,
  ) {
    initSuperMinMaxValues(minX, maxX, minY, maxY);
  }

  void initSuperMinMaxValues(
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) {
    lineBarsData.forEach((lineBarChart) {
      if (lineBarChart.spots == null || lineBarChart.spots.isEmpty) {
        throw Exception('spots could not be null or empty');
      }
    });
    if (lineBarsData.isNotEmpty) {
      var canModifyMinX = false;
      if (minX == null) {
        minX = lineBarsData[0].spots[0].x;
        canModifyMinX = true;
      }

      var canModifyMaxX = false;
      if (maxX == null) {
        maxX = lineBarsData[0].spots[0].x;
        canModifyMaxX = true;
      }

      var canModifyMinY = false;
      if (minY == null) {
        minY = lineBarsData[0].spots[0].y;
        canModifyMinY = true;
      }

      var canModifyMaxY = false;
      if (maxY == null) {
        maxY = lineBarsData[0].spots[0].y;
        canModifyMaxY = true;
      }

      lineBarsData.forEach((barData) {
        barData.spots.forEach((spot) {
          if (canModifyMaxX && spot.x > maxX) {
            maxX = spot.x;
          }

          if (canModifyMinX && spot.x < minX) {
            minX = spot.x;
          }

          if (canModifyMaxY && spot.y > maxY) {
            maxY = spot.y;
          }

          if (canModifyMinY && spot.y < minY) {
            minY = spot.y;
          }
        });
      });
    } else {
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

/***** LineChartBarData *****/
/// This class holds visualisation data about the bar line
/// use [isCurved] to set the bar line curve or sharp on connections spot.
class LineChartBarData {
  final List<FlSpot> spots;

  final bool show;

  /// if one color provided, solid color will apply,
  /// but if more than one color provided, gradient will apply.
  final List<Color> colors;

  /// if more than one color provided colorStops will hold
  /// stop points of the gradient.
  final List<double> colorStops;

  final double barWidth;
  final bool isCurved;

  /// if isCurved is true, this is important to us,
  /// this determines that how much we should curve the line
  /// on the spot connections.
  /// if it is 0.0, the lines draw with sharp corners.
  final double curveSmoothness;

  final bool isStrokeCapRound;

  /// to fill space below the bar line,
  final BelowBarData belowBarData;

  /// to show dot spots upon the line chart
  final FlDotData dotData;

  const LineChartBarData({
    this.spots = const [],
    this.show = true,
    this.colors = const [Colors.redAccent],
    this.colorStops,
    this.barWidth = 2.0,
    this.isCurved = false,
    this.curveSmoothness = 0.35,
    this.isStrokeCapRound = false,
    this.belowBarData = const BelowBarData(),
    this.dotData = const FlDotData(),
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

  /// if more than one color provided gradientColorStops will hold
  /// stop points of the gradient.
  final List<double> gradientColorStops;


  /// holds data for drawing a line from each spot the the bottom of the chart
  final BelowSpotsLine belowSpotsLine;

  const BelowBarData({
    this.show = true,
    this.colors = const [Colors.blueGrey],
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.gradientColorStops,
    this.belowSpotsLine = const BelowSpotsLine(),
  });
}


typedef CheckToShowSpotBelowLine = bool Function(FlSpot spot);

bool showAllSpotsBelowLine(FlSpot spot) {
  return true;
}

class BelowSpotsLine {
  final bool show;

  /// determines style of the line
  final FlLine flLineStyle;

  /// a function to determine whether to show or hide the below line on the given spot
  final CheckToShowSpotBelowLine checkToShowSpotBelowLine;

  const BelowSpotsLine({
    this.show = false,
    this.flLineStyle = const FlLine(),
    this.checkToShowSpotBelowLine = showAllSpotsBelowLine,
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


/// horizontal lines draw from bottom to top of the chart,
/// and the x is dynamic
class HorizontalLine extends FlLine {
  final double x;
  HorizontalLine({
    this.x,
    Color color = Colors.black,
    double strokeWidth = 2,
  }) : super(color: color, strokeWidth: strokeWidth);
}

/// vertical lines draw from left to right of the chart
/// and the y is dynamic
class VerticalLine extends FlLine {
  final double y;
  VerticalLine({
    this.y,
    Color color = Colors.black,
    double strokeWidth = 2,
  }) : super(color: color, strokeWidth: strokeWidth);
}

/// we use ExtraLinesData to draw straight horizontal and vertical lines,
/// for example if you want show the average values of the y axis,
/// you can calculate the average and draw a vertical line by setting the y.
class ExtraLinesData {
  final bool showHorizontalLines;
  final List<HorizontalLine> horizontalLines;

  final bool showVerticalLines;
  final List<VerticalLine> verticalLines;

  const ExtraLinesData({
    this.showHorizontalLines = false,
    this.horizontalLines = const [],
    this.showVerticalLines = false,
    this.verticalLines = const [],
  });
}