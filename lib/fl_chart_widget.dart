library fl_chart;

import 'package:flutter/material.dart';
import 'package:fl_chart/chart/fl_chart.dart';

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
