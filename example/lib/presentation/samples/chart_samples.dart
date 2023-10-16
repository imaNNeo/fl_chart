import 'package:fl_chart_app/util/app_helper.dart';

import 'bar/bar_chart_sample1.dart';
import 'bar/bar_chart_sample2.dart';
import 'bar/bar_chart_sample3.dart';
import 'bar/bar_chart_sample4.dart';
import 'bar/bar_chart_sample5.dart';
import 'bar/bar_chart_sample6.dart';
import 'bar/bar_chart_sample7.dart';
import 'bar/bar_chart_sample8.dart';
import 'chart_sample.dart';
import 'line/line_chart_sample1.dart';
import 'line/line_chart_sample10.dart';
import 'line/line_chart_sample11.dart';
import 'line/line_chart_sample2.dart';
import 'line/line_chart_sample3.dart';
import 'line/line_chart_sample4.dart';
import 'line/line_chart_sample5.dart';
import 'line/line_chart_sample6.dart';
import 'line/line_chart_sample7.dart';
import 'line/line_chart_sample8.dart';
import 'line/line_chart_sample9.dart';
import 'pie/pie_chart_sample1.dart';
import 'pie/pie_chart_sample2.dart';
import 'pie/pie_chart_sample3.dart';
import 'radar/radar_chart_sample1.dart';
import 'scatter/scatter_chart_sample1.dart';
import 'scatter/scatter_chart_sample2.dart';

class ChartSamples {
  static final Map<ChartType, List<ChartSample>> samples = {
    ChartType.line: [
      LineChartSample(1, (context) => const LineChartSample1()),
      LineChartSample(2, (context) => const LineChartSample2()),
      LineChartSample(3, (context) => LineChartSample3()),
      LineChartSample(4, (context) => LineChartSample4()),
      LineChartSample(5, (context) => const LineChartSample5()),
      LineChartSample(6, (context) => LineChartSample6()),
      LineChartSample(7, (context) => LineChartSample7()),
      LineChartSample(8, (context) => const LineChartSample8()),
      LineChartSample(9, (context) => LineChartSample9()),
      LineChartSample(10, (context) => const LineChartSample10()),
      LineChartSample(11, (context) => const LineChartSample11()),
    ],
    ChartType.bar: [
      BarChartSample(1, (context) => BarChartSample1()),
      BarChartSample(2, (context) => BarChartSample2()),
      BarChartSample(3, (context) => const BarChartSample3()),
      BarChartSample(4, (context) => BarChartSample4()),
      BarChartSample(5, (context) => const BarChartSample5()),
      BarChartSample(6, (context) => const BarChartSample6()),
      BarChartSample(7, (context) => BarChartSample7()),
      BarChartSample(8, (context) => BarChartSample8()),
    ],
    ChartType.pie: [
      PieChartSample(1, (context) => const PieChartSample1()),
      PieChartSample(2, (context) => const PieChartSample2()),
      PieChartSample(3, (context) => const PieChartSample3()),
    ],
    ChartType.scatter: [
      ScatterChartSample(1, (context) => ScatterChartSample1()),
      ScatterChartSample(2, (context) => const ScatterChartSample2()),
    ],
    ChartType.radar: [
      RadarChartSample(1, (context) => RadarChartSample1()),
    ],
  };
}
