import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

class FlAxisChartData extends FlChartData {
  final List<FlSpot> spots;
  final FlGridData gridData;
  final FlTitlesData titlesData;

  double minX, maxX;
  double minY, maxY;

  FlAxisChartData({
    @required this.spots,
    this.gridData = const FlGridData(),
    this.titlesData = const FlTitlesData(),
    FlBorderData borderData = const FlBorderData(),
  }) : super(borderData: borderData) {
    if (spots == null) {
      throw Exception("spots couldn't be null");
    }

    if (spots.length >= 0) {
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

class FlSpot {
  final double x;
  final double y;

  const FlSpot(this.x, this.y);
}

// Grid data
typedef CheckToShowGrid = bool Function(double value);

bool showAllGrids(double value) {
  return true;
}

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

// Titles data
typedef GetTitleFunction = String Function(double value);

String defaultGetTitle(double value) {
  return "${value.toInt()}";
}

class FlTitlesData {
  final bool show;

  // Horizontal
  final bool showHorizontalTitles;
  final GetTitleFunction getHorizontalTitles;
  final double horizontalTitlesReservedHeight;
  final TextStyle horizontalTitlesTextStyle;
  final double horizontalTitleMargin;

  // Vertical
  final bool showVerticalTitles;
  final GetTitleFunction getVerticalTitles;
  final double verticalTitlesReservedWidth;
  final TextStyle verticalTitlesTextStyle;
  final double verticalTitleMargin;

  const FlTitlesData({
    this.show = true,
    // Horizontal
    this.showHorizontalTitles = true,
    this.getHorizontalTitles = defaultGetTitle,
    this.horizontalTitlesReservedHeight = 22,
    this.horizontalTitlesTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.horizontalTitleMargin = 6,

    // Vertical
    this.showVerticalTitles = true,
    this.getVerticalTitles = defaultGetTitle,
    this.verticalTitlesReservedWidth = 40,
    this.verticalTitlesTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.verticalTitleMargin = 6,
  });
}