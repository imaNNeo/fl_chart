import '../base/fl_axis_chart/fl_axis_chart.dart';
import '../base/fl_chart/fl_chart_data.dart';
import '../base/fl_chart/fl_chart_painter.dart';
import 'bar_chart_data.dart';
import 'bar_chart_painter.dart';

class BarChart extends FlAxisChart {
  final BarChartData barChartData;

  BarChart(
    this.barChartData,
  );

  @override
  FlChartPainter<FlChartData> painter() => BarChartPainter(barChartData);
}
