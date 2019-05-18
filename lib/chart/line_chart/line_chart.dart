import 'package:fl_chart/chart/base/fl_chart/fl_chart.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:fl_chart/chart/line_chart/line_chart_painter.dart';

import 'line_chart_data.dart';

class LineChart extends FlChart {
  final LineChartData lineChartData;

  LineChart(this.lineChartData,);

  @override
  FlChartPainter painter() {
    return LineChartPainter(lineChartData);
  }
}