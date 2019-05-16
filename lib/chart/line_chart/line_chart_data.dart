import 'dart:ui';

import 'package:flutter/material.dart';

class LineChartData {
  final List<LineChartSpot> spots;
  final Color barColor;
  final double barWidth;
  final Color dotColor;
  final double dotSize;
  final bool showDots;
  final bool isCurved;
  final double curveSmoothness;
  final bool showGridLines;
  final LineChartGridData gridData;

  double minX, maxX;
  double minY, maxY;

  LineChartData({
    @required this.spots,
    this.barColor = Colors.redAccent,
    this.barWidth = 2.0,
    this.dotColor = Colors.blue,
    this.dotSize = 4.0,
    this.showDots = true,
    this.isCurved = false,
    this.curveSmoothness = 0.35,
    this.showGridLines = true,
    this.gridData = const LineChartGridData(),
  }) {
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

        print("minX: $minX, maxX: $maxX, minY: $minY, maxY: $maxY, ");
      });
    }
  }
}

class LineChartSpot {
  final double x;
  final double y;

  LineChartSpot(this.x, this.y);
}

class LineChartGridData {
  final bool drawHorizontalGrid;
  final double horizontalInterval;
  final Color horizontalGridColor;
  final double horizontalGridLineWidth;

  final bool drawVerticalGrid;
  final double verticalInterval;
  final Color verticalGridColor;
  final double verticalGridLineWidth;

  const LineChartGridData({
    this.drawHorizontalGrid = false,
    this.horizontalInterval = 1.0,
    this.horizontalGridColor = Colors.grey,
    this.horizontalGridLineWidth = 0.5,
    this.drawVerticalGrid = true,
    this.verticalInterval = 1.0,
    this.verticalGridColor = Colors.grey,
    this.verticalGridLineWidth = 0.5,
  });
}