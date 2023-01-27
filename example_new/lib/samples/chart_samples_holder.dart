import 'package:example_new/samples/bar/bar_chart_sample1.dart';
import 'package:example_new/samples/bar/bar_chart_sample4.dart';
import 'package:example_new/samples/bar/bar_chart_sample6.dart';
import 'package:example_new/samples/bar/bar_chart_sample7.dart';
import 'package:example_new/samples/line/line_chart_sample1.dart';
import 'package:example_new/samples/pie/pie_chart_sample1.dart';
import 'package:example_new/samples/pie/pie_chart_sample2.dart';
import 'package:example_new/samples/pie/pie_chart_sample3.dart';
import 'package:example_new/util/app_helper.dart';

import 'bar/bar_chart_sample2.dart';
import 'bar/bar_chart_sample3.dart';
import 'bar/bar_chart_sample5.dart';
import 'chart_sample.dart';
import 'line/line_chart_sample10.dart';
import 'line/line_chart_sample2.dart';
import 'line/line_chart_sample3.dart';
import 'line/line_chart_sample4.dart';
import 'line/line_chart_sample5.dart';
import 'line/line_chart_sample6.dart';
import 'line/line_chart_sample7.dart';
import 'line/line_chart_sample8.dart';
import 'line/line_chart_sample9.dart';
import 'radar/radar_sample_1.dart';
import 'scatter/scatter_sample_1.dart';

class ChartSamplesHolder {
  static final Map<ChartType, List<ChartSample>> samples = {
    ChartType.line: [
      LineChartSample('Line Chart Sample 1', 'link1', (context) => const LineChartSample1()),
      LineChartSample('Line Chart Sample 2', 'link2', (context) => const LineChartSample2()),
      LineChartSample('Line Chart Sample 3', 'link3', (context) => LineChartSample3()),
      LineChartSample('Line Chart Sample 4', 'link4', (context) => LineChartSample4()),
      LineChartSample('Line Chart Sample 5', 'link5', (context) => const LineChartSample5()),
      LineChartSample('Line Chart Sample 6', 'link6', (context) => LineChartSample6()),
      LineChartSample('Line Chart Sample 7', 'link7', (context) => LineChartSample7()),
      LineChartSample('Line Chart Sample 8', 'link8', (context) => const LineChartSample8()),
      LineChartSample('Line Chart Sample 9', 'link9', (context) => LineChartSample9()),
      LineChartSample('Line Chart Sample 10', 'link10', (context) => const LineChartSample10()),
    ],
    ChartType.bar: [
      BarChartSample('Bar Chart Sample 1', 'link 1', (context) => BarChartSample1()),
      BarChartSample('Bar Chart Sample 2', 'link 2', (context) => BarChartSample2()),
      BarChartSample('Bar Chart Sample 3', 'link 3', (context) => const BarChartSample3()),
      BarChartSample('Bar Chart Sample 4', 'link 4', (context) => BarChartSample4()),
      BarChartSample('Bar Chart Sample 5', 'link 5', (context) => const BarChartSample5()),
      BarChartSample('Bar Chart Sample 6', 'link 6', (context) => const BarChartSample6()),
      BarChartSample('Bar Chart Sample 7', 'link 7', (context) => BarChartSample7()),
    ],
    ChartType.pie: [
      PieChartSample('Pie Chart Sample 1', 'link 1', (context) => const PieChartSample1()),
      PieChartSample('Pie Chart Sample 2', 'link 2', (context) => const PieChartSample2()),
      PieChartSample('Pie Chart Sample 3', 'link 3', (context) => const PieChartSample3()),
    ],
    ChartType.scatter: [
      ScatterChartSample('Scatter Chart Sample 1', 'link 1', (context) => const ScatterSample1()),
      ScatterChartSample('Scatter Chart Sample 2', 'link 2', (context) => const ScatterSample1()),
      ScatterChartSample('Scatter Chart Sample 3', 'link 3', (context) => const ScatterSample1()),
      ScatterChartSample('Scatter Chart Sample 4', 'link 4', (context) => const ScatterSample1()),
    ],
    ChartType.radar: [
      RadarChartSample('Radar Chart Sample 1', 'link 1', (context) => const RadarSample1()),
      RadarChartSample('Radar Chart Sample 2', 'link 2', (context) => const RadarSample1()),
      RadarChartSample('Radar Chart Sample 3', 'link 3', (context) => const RadarSample1()),
      RadarChartSample('Radar Chart Sample 4', 'link 4', (context) => const RadarSample1()),
      RadarChartSample('Radar Chart Sample 5', 'link 5', (context) => const RadarSample1()),
    ],
  };
}
