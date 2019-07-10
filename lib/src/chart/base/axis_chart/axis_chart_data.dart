import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:flutter/material.dart';


/// This is the base class for axis base charts data
/// that contains a [FlGridData] that holds data for showing grid lines,
/// also we have [minX], [maxX], [minY], [maxY] values
/// we use them to determine how much is the scale of chart,
/// and calculate x and y according to the scale.
/// each child have to set it in their constructor.
class AxisChartData extends BaseChartData {
  final FlGridData gridData;

  double minX, maxX;
  double minY, maxY;

  /// clip the chart to the border (prevent draw outside the border)
  bool clipToBorder;

  /// A background color which is drawn behind th chart.
  Color backgroundColor;

  AxisChartData({
    this.gridData = const FlGridData(),
    FlBorderData borderData,
    FlTouchData touchData,
    this.minX, this.maxX,
    this.minY, this.maxY,
    this.clipToBorder = false,
    this.backgroundColor,
  }) : super(borderData: borderData, touchData: touchData);
}

/***** Spot *****/
/// this class represent a conceptual position of a spot in our chart
/// they are based on bottom/left just like real life axises.
/// we convert them to view x and y according to maxX and maxY
/// based on the view's size
class FlSpot {
  final double x;
  final double y;

  const FlSpot(this.x, this.y);

  FlSpot copyWith({
    double x,
    double y,
  }) {
    return FlSpot(
      x ?? this.x,
      y ?? this.y,
    );
  }
}


/***** GridData *****/
/// we use this typedef to determine which grid lines we should show,
/// we pass the coord value, and receive a boolean to show that line in the grid.
typedef CheckToShowGrid = bool Function(double value);

bool showAllGrids(double value) {
  return true;
}


/// we use this typedef to determine how draw the grid line at specific position
typedef GetDrawingGridLine = FlLine Function(double value);

FlLine defaultGridLine(double value) {
  return const FlLine(
    color: Colors.grey,
    strokeWidth: 0.5,
  );
}

/// This class is responsible to hold grid data,
/// the field names are descriptive and you can find out what they do.
class FlGridData {
  final bool show;

  // Horizontal
  final bool drawHorizontalGrid;
  final double horizontalInterval;
  final GetDrawingGridLine getDrawingHorizontalGridLine;
  final CheckToShowGrid checkToShowHorizontalGrid;

  // Vertical
  final bool drawVerticalGrid;
  final double verticalInterval;
  final GetDrawingGridLine getDrawingVerticalGridLine;
  final CheckToShowGrid checkToShowVerticalGrid;

  const FlGridData({
    this.show = true,
    // Horizontal
    this.drawHorizontalGrid = false,
    this.horizontalInterval = 1.0,
    this.getDrawingHorizontalGridLine = defaultGridLine,
    this.checkToShowHorizontalGrid = showAllGrids,

    //Vertical
    this.drawVerticalGrid = true,
    this.verticalInterval = 1.0,
    this.getDrawingVerticalGridLine = defaultGridLine,
    this.checkToShowVerticalGrid = showAllGrids,
  });
}


/// This class can be used wherever we want draw a straight line,
/// and contains visual properties
class FlLine {
  final Color color;
  final double strokeWidth;

  const FlLine({
    this.color = Colors.black,
    this.strokeWidth = 2,
  });
}


/// show each TooltipItem as a row on the tooltip window,
/// return null if you don't want to show each item
/// if user touched the chart, we show a tooltip window on the most top [TouchSpot],
/// here we get the [TooltipItem] from the given [TouchedSpot].
typedef GetTooltipItems<T extends TouchedSpot> = List<TooltipItem> Function(List<T> touchedSpots);
List<TooltipItem> defaultTitlesStyle<T extends TouchedSpot>(List<T> touchedSpots) {

  if (touchedSpots == null) {
    return null;
  }

  return touchedSpots.map((T touchedSpot) {
    if (touchedSpots == null || touchedSpot.spot == null) {
      return null;
    }

    final String text = touchedSpot.spot.y.toString();

    final TextStyle textStyle = TextStyle(
      color: touchedSpot.getColor(),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return TooltipItem(text, textStyle);
  }).toList();
}

/// Holds information for showing tooltip on axis based charts
/// when a touch event happened
class TouchTooltipData {
  final Color tooltipBgColor;
  final double tooltipRoundedRadius;
  final EdgeInsets tooltipPadding;
  final double tooltipBottomMargin;
  final double maxContentWidth;
  final GetTooltipItems getTooltipItems;

  const TouchTooltipData({
    this.tooltipBgColor = Colors.white,
    this.tooltipRoundedRadius = 4,
    this.tooltipPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.tooltipBottomMargin = 16,
    this.maxContentWidth = 120,
    this.getTooltipItems = defaultTitlesStyle,
  }) : super();
}

/// holds information about touched spot on the axis base charts
abstract class TouchedSpot {
  final FlSpot spot;
  final Offset offset;

  TouchedSpot(
    this.spot,
    this.offset,
    );

  Color getColor();
}

/// holds data of showing each item in the tooltip window
class TooltipItem {
  final String text;
  final TextStyle textStyle;

  TooltipItem(this.text, this.textStyle);
}