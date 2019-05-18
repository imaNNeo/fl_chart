import 'package:fl_chart/chart/base/fl_chart/fl_chart.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';

import 'bar_chart_data.dart';
import 'bar_chart_painter.dart';

class BarChart extends FlChart {
  final BarChartData barChartData;

  BarChart(this.barChartData,);

  @override
  FlChartPainter painter() => BarChartPainter(barChartData);
}