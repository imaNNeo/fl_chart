import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/src/utils/lerp.dart';

/// This is the base class for axis base charts data
/// that contains a [FlGridData] that holds data for showing grid lines,
/// also we have [minX], [maxX], [minY], [maxY] values
/// we use them to determine how much is the scale of chart,
/// and calculate x and y according to the scale.
/// each child have to set it in their constructor.
abstract class AxisChartData extends BaseChartData {
  final FlGridData gridData;
  final FlAxisTitleData axisTitleData;

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
    this.axisTitleData,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
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

  static FlSpot lerp(FlSpot a, FlSpot b, double t) {
    return FlSpot(
      lerpDouble(a.x, b.x, t),
      lerpDouble(a.y, b.y, t),
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
  final bool drawHorizontalLine;
  final double horizontalInterval;
  final GetDrawingGridLine getDrawingHorizontalLine;
  final CheckToShowGrid checkToShowHorizontalLine;

  // Vertical
  final bool drawVerticalLine;
  final double verticalInterval;
  final GetDrawingGridLine getDrawingVerticalLine;
  final CheckToShowGrid checkToShowVerticalLine;

  const FlGridData({
    this.show = true,
    // Horizontal
    this.drawHorizontalLine = true,
    this.horizontalInterval = 1.0,
    this.getDrawingHorizontalLine = defaultGridLine,
    this.checkToShowHorizontalLine = showAllGrids,

    //Vertical
    this.drawVerticalLine = false,
    this.verticalInterval = 1.0,
    this.getDrawingVerticalLine = defaultGridLine,
    this.checkToShowVerticalLine = showAllGrids,
  });

  static FlGridData lerp(FlGridData a, FlGridData b, double t) {
    return FlGridData(
      show: b.show,
      drawHorizontalLine: b.drawHorizontalLine,
      horizontalInterval: lerpDouble(a.horizontalInterval, b.horizontalInterval, t),
      getDrawingHorizontalLine: b.getDrawingHorizontalLine,
      checkToShowHorizontalLine: b.checkToShowHorizontalLine,
      drawVerticalLine: b.drawVerticalLine,
      verticalInterval: lerpDouble(a.verticalInterval, b.verticalInterval, t),
      getDrawingVerticalLine: b.getDrawingVerticalLine,
      checkToShowVerticalLine: b.checkToShowVerticalLine,
    );
  }
}

/// This class can be used wherever we want draw a straight line,
/// and contains visual properties
/// [dashArray]  A circular array of dash offsets and lengths.
/// For example, the array `[5, 10]` would result in dashes 5 pixels long
/// followed by blank spaces 10 pixels long.  The array `[5, 10, 5]` would
/// result in a 5 pixel dash, a 10 pixel gap, a 5 pixel dash, a 5 pixel gap,
/// a 10 pixel dash, etc.
class FlLine {
  final Color color;
  final double strokeWidth;
  final List<int> dashArray;

  const FlLine({this.color = Colors.black, this.strokeWidth = 2, this.dashArray});

  static FlLine lerp(FlLine a, FlLine b, double t) {
    return FlLine(
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
    );
  }
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
