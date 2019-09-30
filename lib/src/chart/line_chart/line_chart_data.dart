import 'dart:async';
import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

/// This class holds data to draw the line chart
/// List [LineChartBarData] the data to draw the bar lines independently,
/// [FlTitlesData] to show the bottom and left titles
/// [ExtraLinesData] to draw extra horizontal and vertical lines on the chart
/// [LineTouchData] holds data to handling touch and interactions
class LineChartData extends AxisChartData {
  final List<LineChartBarData> lineBarsData;
  final FlTitlesData titlesData;
  final ExtraLinesData extraLinesData;
  final LineTouchData lineTouchData;

  LineChartData({
    this.lineBarsData = const [],
    this.titlesData = const FlTitlesData(),
    this.extraLinesData = const ExtraLinesData(),
    this.lineTouchData = const LineTouchData(),
    FlGridData gridData = const FlGridData(),
    FlBorderData borderData,
    double minX,
    double maxX,
    double minY,
    double maxY,
    bool clipToBorder = false,
    Color backgroundColor,
  }) : super(
          gridData: gridData,
          touchData: lineTouchData,
          borderData: borderData,
          clipToBorder: clipToBorder,
          backgroundColor: backgroundColor,
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

  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {

    if (a is LineChartData && b is LineChartData && t != null) {
      return LineChartData(
        minX: lerpDouble(a.minX, b.minX, t),
        maxX: lerpDouble(a.maxX, b.maxX, t),
        minY: lerpDouble(a.minY, b.minY, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        clipToBorder: b.clipToBorder,
        extraLinesData: ExtraLinesData.lerp(a.extraLinesData, b.extraLinesData, t),
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        lineBarsData: lerpLineChartBarDataList(a.lineBarsData, b.lineBarsData, t),
        lineTouchData: b.lineTouchData,
      );
    } else {
      throw Exception('Illegal State');
    }
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

  /// prevent overshooting when draw curve line on linear sequence spots
  /// check this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/25)
  final bool preventCurveOverShooting;

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
    this.preventCurveOverShooting = false,
    this.isStrokeCapRound = false,
    this.belowBarData = const BelowBarData(),
    this.dotData = const FlDotData(),
  });

  static LineChartBarData lerp(LineChartBarData a, LineChartBarData b, double t) {

    return LineChartBarData(
      show: b.show,
      barWidth: lerpDouble(a.barWidth, b.barWidth, t),
      belowBarData: BelowBarData.lerp(a.belowBarData, b.belowBarData, t),
      curveSmoothness: b.curveSmoothness,
      isCurved: b.isCurved,
      isStrokeCapRound: b.isStrokeCapRound,
      preventCurveOverShooting: b.preventCurveOverShooting,
      dotData: FlDotData.lerp(a.dotData, b.dotData, t),
      colors: lerpColorList(a.colors, b.colors, t),
      colorStops: lerpDoubleList(a.colorStops, b.colorStops, t),
      spots: lerpFlSpotList(a.spots, b.spots, t),
    );
  }
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

  static BelowBarData lerp(BelowBarData a, BelowBarData b, double t) {
    return BelowBarData(
      show: b.show,
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      belowSpotsLine: BelowSpotsLine.lerp(a.belowSpotsLine, b.belowSpotsLine, t),
      colors: lerpColorList(a.colors, b.colors, t),
      gradientColorStops: lerpDoubleList(a.gradientColorStops, b.gradientColorStops, t),
    );
  }
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

  static BelowSpotsLine lerp(BelowSpotsLine a, BelowSpotsLine b, double t) {
    return BelowSpotsLine(
      show: b.show,
      checkToShowSpotBelowLine: b.checkToShowSpotBelowLine,
      flLineStyle: FlLine.lerp(a.flLineStyle, b.flLineStyle, t),
    );
  }
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

  static FlDotData lerp(FlDotData a, FlDotData b, double t) {
    return FlDotData(
      show: b.show,
      checkToShowDot: b.checkToShowDot,
      dotColor: Color.lerp(a.dotColor, b.dotColor, t),
      dotSize: lerpDouble(a.dotSize, b.dotSize, t),
    );
  }
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

  static HorizontalLine lerp(HorizontalLine a, HorizontalLine b, double t) {
    return HorizontalLine(
      x: lerpDouble(a.x, b.x, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
    );
  }
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

  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) {
    return VerticalLine(
      y: lerpDouble(a.y, b.y, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
    );
  }
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

  static ExtraLinesData lerp(ExtraLinesData a, ExtraLinesData b, double t) {
    return ExtraLinesData(
      showHorizontalLines: b.showHorizontalLines,
      showVerticalLines: b.showVerticalLines,
      horizontalLines: lerpHorizontalLineList(a.horizontalLines, b.horizontalLines, t),
      verticalLines: lerpVerticalLineList(a.verticalLines, b.verticalLines, t),
    );
  }

}

/// if user touched the chart, we indicate the touched spots with a below line,
/// and make a bigger dot on that spot,
/// here we get the [TouchedSpotIndicatorData] from the given [LineTouchedSpot].
typedef GetTouchedSpotIndicator = List<TouchedSpotIndicatorData> Function(
    List<LineTouchedSpot> touchedSpots);

List<TouchedSpotIndicatorData> defaultTouchedIndicators(
    List<LineTouchedSpot> touchedSpots) {
  return touchedSpots.map((LineTouchedSpot lineTouchedSpot) {
    /// Indicator Line
    Color lineColor = lineTouchedSpot.barData.colors[0];
    if (lineTouchedSpot.barData.dotData.show) {
      lineColor = lineTouchedSpot.barData.dotData.dotColor;
    }
    const double lineStrokeWidth = 4;
    final FlLine flLine =
        FlLine(color: lineColor, strokeWidth: lineStrokeWidth);

    /// Indicator dot
    double dotSize = 10;
    Color dotColor = lineTouchedSpot.barData.colors[0];
    if (lineTouchedSpot.barData.dotData.show) {
      dotSize = lineTouchedSpot.barData.dotData.dotSize * 1.8;
      dotColor = lineTouchedSpot.barData.dotData.dotColor;
    }
    FlDotData dotData = FlDotData(
      dotSize: dotSize,
      dotColor: dotColor,
    );

    return TouchedSpotIndicatorData(flLine, dotData);
  }).toList();
}

/// holds data for handling touch events on the [LineChart]
class LineTouchData extends FlTouchData {
  /// show a tooltip on touched spots
  final TouchTooltipData touchTooltipData;

  /// show the indicator line and dot at the touched spot
  /// return null if you don't want to show any indicator on each spot
  final GetTouchedSpotIndicator getTouchedSpotIndicator;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  const LineTouchData({
    bool enabled = true,
    bool enableNormalTouch = true,
    this.touchTooltipData = const TouchTooltipData(),
    this.getTouchedSpotIndicator = defaultTouchedIndicators,
    this.touchSpotThreshold = 10,
    StreamSink<LineTouchResponse> touchResponseSink,
  }) : super(enabled, touchResponseSink, enableNormalTouch);
}

/// details of showing indicator when touch happened on [LineChart]
/// [indicatorBelowLine] we draw a vertical line below of the touched spot
/// [touchedSpotDotData] we draw a larger dot on the touched spot to bold it
class TouchedSpotIndicatorData {
  final FlLine indicatorBelowLine;
  final FlDotData touchedSpotDotData;

  TouchedSpotIndicatorData(this.indicatorBelowLine, this.touchedSpotDotData);
}

/// holds the data of the touched spot
class LineTouchedSpot extends TouchedSpot {
  LineChartBarData barData;
  int barDataPosition;

  LineTouchedSpot(
    this.barData,
    this.barDataPosition,
    FlSpot spot,
    Offset offset,
  ) : super(spot, offset);

  @override
  Color getColor() {
    return barData.colors[0];
  }
}

/// holds the data of touch response on the [LineChart]
/// used in the [LineTouchData] in a [StreamSink]
class LineTouchResponse extends BaseTouchResponse {
  /// touch happened on these spots
  /// (if a single line provided on the chart, [spots]'s length will be 1 always)
  final List<LineTouchedSpot> spots;

  LineTouchResponse(
    this.spots,
    FlTouchInput touchInput,
  ) : super(touchInput);
}
