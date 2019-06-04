import '../base/fl_chart/fl_chart.dart';
import '../base/fl_chart/fl_chart_data.dart';
import '../base/fl_chart/fl_chart_painter.dart';
import 'pie_chart_data.dart';
import 'pie_chart_painter.dart';

class PieChart extends FlChart {
  final PieChartData pieChartData;

  PieChart(this.pieChartData);

  @override
  FlChartPainter<FlChartData> painter() => PieChartPainter(pieChartData);
}
