
import 'package:fl_chart/chart/base/fl_chart/fl_chart.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_data.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_painter.dart';

class PieChart extends FlChart {

  final PieChartData pieChartData;

  PieChart(this.pieChartData);


  @override
  FlChartPainter<FlChartData> painter() => PieChartPainter(pieChartData);

}