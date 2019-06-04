import '../base/fl_axis_chart/fl_axis_chart.dart';
import '../base/fl_chart/fl_chart_painter.dart';
import 'line_chart_data.dart';
import 'line_chart_painter.dart';

class LineChart extends FlAxisChart {
  final LineChartData lineChartData;

  LineChart(
    this.lineChartData,
  );

  @override
  FlChartPainter painter() => LineChartPainter(lineChartData);
}
