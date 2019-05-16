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

  double minX, maxX;
  double minY, maxY;

  LineChartData({
    @required this.spots,
    this.barColor = Colors.redAccent,
    this.barWidth = 2.0,
    this.dotColor = Colors.blue,
    this.dotSize = 4.0,
    this.showDots = true,
    this.isCurved = true,
    this.curveSmoothness = 0.35
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