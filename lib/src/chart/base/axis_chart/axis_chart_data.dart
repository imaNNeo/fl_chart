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
    this.minX, this.maxX,
    this.minY, this.maxY,
    this.clipToBorder = false,
    this.backgroundColor,
  }) : super(borderData: borderData);
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
}


/***** GridData *****/
/// we use this typedef to determine which grid lines we should show,
/// we pass the coord value, and receive a boolean to show that line in the grid.
typedef CheckToShowGrid = bool Function(double value);

bool showAllGrids(double value) {
  return true;
}

/// This class is responsible to hold grid data,
/// the field names are descriptive and you can find out what they do.
class FlGridData {
  final bool show;

  // Horizontal
  final bool drawHorizontalGrid;
  final double horizontalInterval;
  final Color horizontalGridColor;
  final double horizontalGridLineWidth;
  final CheckToShowGrid checkToShowHorizontalGrid;

  // Vertical
  final bool drawVerticalGrid;
  final double verticalInterval;
  final Color verticalGridColor;
  final double verticalGridLineWidth;
  final CheckToShowGrid checkToShowVerticalGrid;

  const FlGridData({
    this.show = true,
    // Horizontal
    this.drawHorizontalGrid = false,
    this.horizontalInterval = 1.0,
    this.horizontalGridColor = Colors.grey,
    this.horizontalGridLineWidth = 0.5,
    this.checkToShowHorizontalGrid = showAllGrids,

    //Vertical
    this.drawVerticalGrid = true,
    this.verticalInterval = 1.0,
    this.verticalGridColor = Colors.grey,
    this.verticalGridLineWidth = 0.5,
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