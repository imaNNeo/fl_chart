import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_data.dart';
import 'package:flutter/material.dart';

/// This class holds all data needed to [FlChartPainter],
/// in this phase just the [FlBorderData] provided
/// to drawing chart border line,
/// see inherited samples:
/// [LineChartData], [BarChartData], [PieChartData]
class FlChartData {
  final FlBorderData borderData;

  FlChartData({
    this.borderData = const FlBorderData(),
  });
}

/// Border Data that contains
/// [show] show or hide the border line on our chart
/// [borderColor] color of chart border line
/// [borderWidth] width of chart border line
class FlBorderData {
  final bool show;
  final Color borderColor;
  final double borderWidth;

  const FlBorderData({
    this.show = true,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });
}
