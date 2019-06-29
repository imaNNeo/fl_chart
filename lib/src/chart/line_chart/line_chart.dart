import 'dart:async';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';

import 'line_chart_data.dart';
import 'line_chart_painter.dart';

class LineChart extends AxisChart {
  final LineChartData lineChartData;

  LineChart(
    this.lineChartData,
  );

  @override
  BaseChartPainter painter({FlTouchInputNotifier touchInputNotifier, StreamSink<BaseTouchResponse> touchResponseSink}) {
    return LineChartPainter(lineChartData, touchInputNotifier);
  }

  @override
  BaseChartData getData() => lineChartData;

}
