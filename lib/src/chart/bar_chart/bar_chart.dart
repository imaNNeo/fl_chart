import 'package:fl_chart/src/chart/base/axis_chart/axis_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';

import 'bar_chart_data.dart';
import 'bar_chart_painter.dart';

class BarChart extends AxisChart {
  final BarChartData barChartData;

  BarChart(
    this.barChartData,
  );

  @override
  BaseChartPainter<BaseChartData> painter() => BarChartPainter(barChartData);
}
