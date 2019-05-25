library fl_chart;

import 'package:fl_chart/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

/// A widget that holds a [FlChart] class
/// that contains [FlChartPainter] extends from [CustomPainter]
/// to paint the relative content on our [CustomPaint] class
/// [FlChart] is an abstract class and we should use a concrete class
/// such as [LineChart], [BarChart], [PieChart].
class FlChartWidget extends StatefulWidget {
  final FlChart flChart;

  FlChartWidget({
    Key key,
    @required this.flChart,
  }) : super(key: key) {
    if (flChart == null) {
      throw Exception("flChart might not be null");
    }
  }

  @override
  State<StatefulWidget> createState() => _FlChartState();
}

class _FlChartState extends State<FlChartWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: widget.flChart.painter(),
    );
  }
}