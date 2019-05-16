import 'package:flutter/src/rendering/custom_paint.dart';
import 'package:fl_chart/chart/line_chart/line_chart_painter.dart';

import '../fl_chart.dart';
import 'line_chart_data.dart';

class LineChart extends FlChart {
  final LineChartData lineChartData;

  LineChart(this.lineChartData,);

  @override
  CustomPainter painter() {
    return LineChartPainter(lineChartData);
  }

}