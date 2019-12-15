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
/// [showingTooltipIndicators] show the tooltip based on provided position(x), and list of [LineBarSpot]
class LineChartData extends AxisChartData {
  final List<LineChartBarData> lineBarsData;
  final List<BetweenBarsData> betweenBarsData;
  final FlTitlesData titlesData;
  final ExtraLinesData extraLinesData;
  final LineTouchData lineTouchData;
  final List<MapEntry<int, List<LineBarSpot>>> showingTooltipIndicators;

  LineChartData({
    this.lineBarsData = const [],
    this.betweenBarsData = const [],
    this.titlesData = const FlTitlesData(),
    this.extraLinesData = const ExtraLinesData(),
    this.lineTouchData = const LineTouchData(),
    this.showingTooltipIndicators = const[],
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
    for (int i = 0; i < lineBarsData.length; i++) {
      final LineChartBarData lineBarChart = lineBarsData[i];
      if (lineBarChart.spots == null || lineBarChart.spots.isEmpty) {
        throw Exception('spots could not be null or empty');
      }
    }
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

      for (int i = 0; i < lineBarsData.length; i++) {
        final LineChartBarData barData = lineBarsData[i];
        for (int j = 0; j < barData.spots.length; j++) {
          final FlSpot spot = barData.spots[j];
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
        }
      }
    }

    super.minX = minX ?? 0;
    super.maxX = maxX ?? 1;
    super.minY = minY ?? 0;
    super.maxY = maxY ?? 1;
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
        betweenBarsData: lerpBetweenBarsDataList(a.betweenBarsData, b.betweenBarsData, t),
        lineTouchData: b.lineTouchData,
        showingTooltipIndicators: b.showingTooltipIndicators,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  LineChartData copyWith({
    List<LineChartBarData> lineBarsData,
    List<BetweenBarsData> betweenBarsData,
    FlTitlesData titlesData,
    ExtraLinesData extraLinesData,
    LineTouchData lineTouchData,
    List<MapEntry<int, List<LineBarSpot>>> showingTooltipIndicators,
    FlGridData gridData,
    FlBorderData borderData,
    double minX,
    double maxX,
    double minY,
    double maxY,
    bool clipToBorder,
    Color backgroundColor,
  }) {
    return LineChartData(
      lineBarsData: lineBarsData ?? this.lineBarsData,
      betweenBarsData: betweenBarsData ?? this.betweenBarsData,
      titlesData: titlesData ?? this.titlesData,
      extraLinesData: extraLinesData ?? this.extraLinesData,
      lineTouchData: lineTouchData ?? this.lineTouchData,
      showingTooltipIndicators: showingTooltipIndicators ?? this.showingTooltipIndicators,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      minY: minY ?? this.minY,
      maxY: maxY ?? this.maxY,
      clipToBorder: clipToBorder ?? this.clipToBorder,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
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

  /// if the gradient mode is enabled (if you have more than one color)
  /// [gradientFrom] and [gradientTo] is important otherwise they will be skipped.
  /// you can determine where the gradient should start and end,
  /// values are available between 0 to 1,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right
  final Offset gradientFrom;
  final Offset gradientTo;

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

  /// to fill space below the bar line
  final BarAreaData belowBarData;

  /// to fill space above the bar line
  final BarAreaData aboveBarData;

  /// to show dot spots upon the line chart
  final FlDotData dotData;

  /// show indicators based on provided indexes
  final List<int> showingIndicators;

  const LineChartBarData({
    this.spots = const [],
    this.show = true,
    this.colors = const [Colors.redAccent],
    this.colorStops,
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.barWidth = 2.0,
    this.isCurved = false,
    this.curveSmoothness = 0.35,
    this.preventCurveOverShooting = false,
    this.isStrokeCapRound = false,
    this.belowBarData = const BarAreaData(),
    this.aboveBarData = const BarAreaData(),
    this.dotData = const FlDotData(),
    this.showingIndicators = const [],
  });

  static LineChartBarData lerp(LineChartBarData a, LineChartBarData b, double t) {
    return LineChartBarData(
      show: b.show,
      barWidth: lerpDouble(a.barWidth, b.barWidth, t),
      belowBarData: BarAreaData.lerp(a.belowBarData, b.belowBarData, t),
      curveSmoothness: b.curveSmoothness,
      isCurved: b.isCurved,
      isStrokeCapRound: b.isStrokeCapRound,
      preventCurveOverShooting: b.preventCurveOverShooting,
      dotData: FlDotData.lerp(a.dotData, b.dotData, t),
      colors: lerpColorList(a.colors, b.colors, t),
      colorStops: lerpDoubleList(a.colorStops, b.colorStops, t),
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      spots: lerpFlSpotList(a.spots, b.spots, t),
      showingIndicators: b.showingIndicators,
    );
  }

  LineChartBarData copyWith({
    List<FlSpot> spots,
    bool show,
    List<Color> colors,
    List<double> colorStops,
    Offset gradientFrom,
    Offset gradientTo,
    double barWidth,
    bool isCurved,
    double curveSmoothness,
    bool preventCurveOverShooting,
    bool isStrokeCapRound,
    BarAreaData belowBarData,
    BarAreaData aboveBarData,
    FlDotData dotData,
    List<int> showingIndicators,
  }) {
    return LineChartBarData(
      spots: spots ?? this.spots,
      show: show ?? this.show,
      colors: colors ?? this.colors,
      colorStops: colorStops ?? this.colorStops,
      gradientFrom: gradientFrom ?? this.gradientFrom,
      gradientTo: gradientTo ?? this.gradientTo,
      barWidth: barWidth ?? this.barWidth,
      isCurved: isCurved ?? this.isCurved,
      curveSmoothness: curveSmoothness ?? this.curveSmoothness,
      preventCurveOverShooting: preventCurveOverShooting ?? this.preventCurveOverShooting,
      isStrokeCapRound: isStrokeCapRound ?? this.isStrokeCapRound,
      belowBarData: belowBarData ?? this.belowBarData,
      aboveBarData: aboveBarData ?? this.aboveBarData,
      dotData: dotData ?? this.dotData,
      showingIndicators: showingIndicators ?? this.showingIndicators,
    );
  }

}

/// holds the details of a [FlSpot] inside a [LineChartBarData]
class LineBarSpot extends FlSpot {
  final LineChartBarData bar;
  final int barIndex;
  final int spotIndex;

  LineBarSpot(this.bar, this.barIndex, FlSpot spot,)
    :spotIndex = bar.spots.indexOf(spot),
      super(spot.x, spot.y);
}

/***** BarAreaData *****/
/// This class holds data about draw on below or above space of the bar line,
class BarAreaData {
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

  /// holds data for drawing a line from each spot the the bottom, or top of the chart
  final BarAreaSpotsLine spotsLine;

  /// cut the drawing below or above area to this y value
  final double cutOffY;

  /// determines should or shouldn't apply cutOffY
  final bool applyCutOffY;

  const BarAreaData({
    this.show = false,
    this.colors = const [Colors.blueGrey],
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.gradientColorStops,
    this.spotsLine = const BarAreaSpotsLine(),
    this.cutOffY,
    this.applyCutOffY = false,
  }) : assert(applyCutOffY == true ? cutOffY != null : true);

  static BarAreaData lerp(BarAreaData a, BarAreaData b, double t) {
    return BarAreaData(
      show: b.show,
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      spotsLine: BarAreaSpotsLine.lerp(a.spotsLine, b.spotsLine, t),
      colors: lerpColorList(a.colors, b.colors, t),
      gradientColorStops: lerpDoubleList(a.gradientColorStops, b.gradientColorStops, t),
      cutOffY: lerpDouble(a.cutOffY, b.cutOffY, t),
      applyCutOffY: b.applyCutOffY,
    );
  }
}

/***** BarAreaData *****/
/// This class holds data about draw on below or above space of the bar line,
class BetweenBarsData {

  /// The index of the lineBarsData from where the area has to be rendered
  final int fromIndex;

  /// The index of the lineBarsData until where the area has to be rendered
  final int toIndex;

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


  const BetweenBarsData({
    @required this.fromIndex,
    @required this.toIndex,
    this.colors = const [Colors.blueGrey],
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.gradientColorStops,
  });

  static BetweenBarsData lerp(BetweenBarsData a, BetweenBarsData b, double t) {
    return BetweenBarsData(
      fromIndex: b.fromIndex,
      toIndex: b.toIndex,
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      colors: lerpColorList(a.colors, b.colors, t),
      gradientColorStops: lerpDoubleList(a.gradientColorStops, b.gradientColorStops, t),
    );
  }
}

typedef CheckToShowSpotLine = bool Function(FlSpot spot);

bool showAllSpotsBelowLine(FlSpot spot) {
  return true;
}

class BarAreaSpotsLine {
  final bool show;

  /// determines style of the line
  final FlLine flLineStyle;

  /// a function to determine whether to show or hide the below or above line on the given spot
  final CheckToShowSpotLine checkToShowSpotLine;

  const BarAreaSpotsLine({
    this.show = false,
    this.flLineStyle = const FlLine(),
    this.checkToShowSpotLine = showAllSpotsBelowLine,
  });

  static BarAreaSpotsLine lerp(BarAreaSpotsLine a, BarAreaSpotsLine b, double t) {
    return BarAreaSpotsLine(
      show: b.show,
      checkToShowSpotLine: b.checkToShowSpotLine,
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
    LineChartBarData barData, List<int> spotIndexes);

List<TouchedSpotIndicatorData> defaultTouchedIndicators(
    LineChartBarData barData, List<int> indicators) {
  if (indicators == null) {
    return [];
  }
  return indicators.map((int index) {
    /// Indicator Line
    Color lineColor = barData.colors[0];
    if (barData.dotData.show) {
      lineColor = barData.dotData.dotColor;
    }
    const double lineStrokeWidth = 4;
    final FlLine flLine = FlLine(color: lineColor, strokeWidth: lineStrokeWidth);

    /// Indicator dot
    double dotSize = 10;
    Color dotColor = barData.colors[0];
    if (barData.dotData.show) {
      dotSize = barData.dotData.dotSize * 1.8;
      dotColor = barData.dotData.dotColor;
    }
    final dotData = FlDotData(
      dotSize: dotSize,
      dotColor: dotColor,
    );

    return TouchedSpotIndicatorData(flLine, dotData);
  }).toList();
}

/// holds data for handling touch events on the [LineChart]
class LineTouchData extends FlTouchData {
  /// show a tooltip on touched spots
  final LineTouchTooltipData touchTooltipData;

  /// show the indicator line and dot at the touched spot
  /// return null if you don't want to show any indicator on each spot
  final GetTouchedSpotIndicator getTouchedSpotIndicator;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  /// set this true if you want the built in touch handling
  /// (show a tooltip bubble and an indicator on touched spots)
  final bool handleBuiltInTouches;

  /// you can implement it to receive touches callback
  final Function(LineTouchResponse) touchCallback;

  const LineTouchData({
    bool enabled = true,
    bool enableNormalTouch = true,
    this.touchTooltipData = const LineTouchTooltipData(),
    this.getTouchedSpotIndicator = defaultTouchedIndicators,
    this.touchSpotThreshold = 10,
    this.handleBuiltInTouches = true,
    this.touchCallback,
  }) : super(enabled, enableNormalTouch);

  LineTouchData copyWith({
    bool enabled,
    bool enableNormalTouch,
    LineTouchTooltipData touchTooltipData,
    GetTouchedSpotIndicator getTouchedSpotIndicator,
    double touchSpotThreshold,
    Function(LineTouchResponse) touchCallback,
  }) {
    return LineTouchData(
      enabled: enabled ?? this.enabled,
      enableNormalTouch: enableNormalTouch ?? this.enableNormalTouch,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      getTouchedSpotIndicator: getTouchedSpotIndicator ?? this.getTouchedSpotIndicator,
      touchSpotThreshold: touchSpotThreshold ?? this.touchSpotThreshold,
      touchCallback: touchCallback ?? this.touchCallback,
    );
  }

}

/// Holds information for showing tooltip on axis based charts
/// when a touch event happened
class LineTouchTooltipData {
  final Color tooltipBgColor;
  final double tooltipRoundedRadius;
  final EdgeInsets tooltipPadding;
  final double tooltipBottomMargin;
  final double maxContentWidth;
  final GetLineTooltipItems getTooltipItems;

  const LineTouchTooltipData({
    this.tooltipBgColor = Colors.white,
    this.tooltipRoundedRadius = 4,
    this.tooltipPadding =
    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.tooltipBottomMargin = 16,
    this.maxContentWidth = 120,
    this.getTooltipItems = defaultLineTooltipItem,
  }) : super();
}

/// show each LineTooltipItem as a row on the tooltip window,
/// return null if you don't want to show each item
/// if user touched the chart, we show a tooltip window on the most top [TouchSpot],
/// here we get the [LineTooltipItem] from the given [TouchedSpot].
typedef GetLineTooltipItems = List<LineTooltipItem> Function(
  List<LineBarSpot> touchedSpots);

List<LineTooltipItem> defaultLineTooltipItem (
  List<LineBarSpot> touchedSpots) {
  if (touchedSpots == null) {
    return null;
  }

  return touchedSpots.map((LineBarSpot touchedSpot) {
    if (touchedSpot == null) {
      return null;
    }
    final TextStyle textStyle = TextStyle(
      color: touchedSpot.bar.colors[0],
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return LineTooltipItem(touchedSpot.y.toString(), textStyle);
  }).toList();
}

/// holds data of showing each item in the tooltip window
class LineTooltipItem {
  final String text;
  final TextStyle textStyle;

  LineTooltipItem(this.text, this.textStyle);
}

/// details of showing indicator when touch happened on [LineChart]
/// [indicatorBelowLine] we draw a vertical line below of the touched spot
/// [touchedSpotDotData] we draw a larger dot on the touched spot to bold it
class TouchedSpotIndicatorData {
  final FlLine indicatorBelowLine;
  final FlDotData touchedSpotDotData;

  TouchedSpotIndicatorData(this.indicatorBelowLine, this.touchedSpotDotData);
}

/// holds the data of touch response on the [LineChart]
/// used in the [LineTouchData] in a [StreamSink]
class LineTouchResponse extends BaseTouchResponse {
  /// touch happened on these spots
  /// (if a single line provided on the chart, [lineBarSpots]'s length will be 1 always)
  final List<LineBarSpot> lineBarSpots;

  LineTouchResponse(
    this.lineBarSpots,
    FlTouchInput touchInput,
  ) : super(touchInput);
}


class LineChartDataTween extends Tween<LineChartData> {

  LineChartDataTween({LineChartData begin, LineChartData end}) : super(begin: begin, end: end);

  @override
  LineChartData lerp(double t) => begin.lerp(begin, end, t);

}