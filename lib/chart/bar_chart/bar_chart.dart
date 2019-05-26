import 'package:fl_chart/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';

import 'bar_chart_data.dart';

class BarChart extends FlAxisChart {
  final BarChartData barChartData;

  BarChart(
    this.barChartData,
  );

  @override
  FlChartPainter<FlChartData> painter() => BarChartPainter(barChartData);
}
