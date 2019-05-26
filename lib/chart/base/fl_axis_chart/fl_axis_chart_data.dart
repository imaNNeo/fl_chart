import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

/// This is the base class for axis base charts data
/// that contains a list of [FlSpot] and a [FlGridData]
/// we use spots to calculate [minX], [maxX], [minY], [maxY],
/// with knowing them we can determine how much is the scale,
/// and how much we should calculate height of each spot
/// base on the view's height.
class FlAxisChartData extends FlChartData {
  final List<FlSpot> spots;
  final FlGridData gridData;

  double minX, maxX;
  double minY, maxY;

  FlAxisChartData({
    @required this.spots,
    this.gridData = const FlGridData(),
    FlBorderData borderData = const FlBorderData(),
  }) : super(borderData: borderData) {
    if (spots == null) {
      throw Exception("spots couldn't be null");
    }

    if (spots.length > 0) {
      minX = maxX = spots[0].x;
      minY = maxY = spots[0].y;
      spots.forEach((spot) {
        if (spot.x > maxX) {
          maxX = spot.x;
        } else if (spot.x < minX) {
          minX = spot.x;
        }

        if (spot.y > maxY) {
          maxY = spot.y;
        } else if (spot.y < minY) {
          minY = spot.y;
        }
      });
    }
  }
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