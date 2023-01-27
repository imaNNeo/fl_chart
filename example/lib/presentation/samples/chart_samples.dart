import 'package:fl_chart_app/urls.dart';
import 'package:fl_chart_app/util/app_helper.dart';

import 'bar/bar_chart_sample1.dart';
import 'bar/bar_chart_sample2.dart';
import 'bar/bar_chart_sample3.dart';
import 'bar/bar_chart_sample4.dart';
import 'bar/bar_chart_sample5.dart';
import 'bar/bar_chart_sample6.dart';
import 'bar/bar_chart_sample7.dart';
import 'chart_sample.dart';
import 'line/line_chart_sample1.dart';
import 'line/line_chart_sample10.dart';
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
      LineChartSample(
        'Line Chart Sample 1',
        Urls.getChartSourceCodeUrl(ChartType.line, 1),
        (context) => const LineChartSample1(),
      ),
      LineChartSample(
        'Line Chart Sample 2',
        Urls.getChartSourceCodeUrl(ChartType.line, 2),
        (context) => const LineChartSample2(),
      ),
      LineChartSample(
        'Line Chart Sample 3',
        Urls.getChartSourceCodeUrl(ChartType.line, 3),
        (context) => LineChartSample3(),
      ),
      LineChartSample(
        'Line Chart Sample 4',
        Urls.getChartSourceCodeUrl(ChartType.line, 4),
        (context) => LineChartSample4(),
      ),
      LineChartSample(
        'Line Chart Sample 5',
        Urls.getChartSourceCodeUrl(ChartType.line, 5),
        (context) => const LineChartSample5(),
      ),
      LineChartSample(
        'Line Chart Sample 6',
        Urls.getChartSourceCodeUrl(ChartType.line, 6),
        (context) => LineChartSample6(),
      ),
      LineChartSample(
        'Line Chart Sample 7',
        Urls.getChartSourceCodeUrl(ChartType.line, 7),
        (context) => LineChartSample7(),
      ),
      LineChartSample(
        'Line Chart Sample 8',
        Urls.getChartSourceCodeUrl(ChartType.line, 8),
        (context) => const LineChartSample8(),
      ),
      LineChartSample(
        'Line Chart Sample 9',
        Urls.getChartSourceCodeUrl(ChartType.line, 9),
        (context) => LineChartSample9(),
      ),
      LineChartSample(
        'Line Chart Sample 10',
        Urls.getChartSourceCodeUrl(ChartType.line, 10),
        (context) => const LineChartSample10(),
      ),
    ],
    ChartType.bar: [
      BarChartSample(
        'Bar Chart Sample 1',
        Urls.getChartSourceCodeUrl(ChartType.bar, 1),
        (context) => BarChartSample1(),
      ),
      BarChartSample(
        'Bar Chart Sample 2',
        Urls.getChartSourceCodeUrl(ChartType.bar, 2),
        (context) => BarChartSample2(),
      ),
      BarChartSample(
        'Bar Chart Sample 3',
        Urls.getChartSourceCodeUrl(ChartType.bar, 3),
        (context) => const BarChartSample3(),
      ),
      BarChartSample(
        'Bar Chart Sample 4',
        Urls.getChartSourceCodeUrl(ChartType.bar, 4),
        (context) => BarChartSample4(),
      ),
      BarChartSample(
        'Bar Chart Sample 5',
        Urls.getChartSourceCodeUrl(ChartType.bar, 5),
        (context) => const BarChartSample5(),
      ),
      BarChartSample(
        'Bar Chart Sample 6',
        Urls.getChartSourceCodeUrl(ChartType.bar, 6),
        (context) => const BarChartSample6(),
      ),
      BarChartSample(
        'Bar Chart Sample 7',
        Urls.getChartSourceCodeUrl(ChartType.bar, 7),
        (context) => BarChartSample7(),
      ),
    ],
    ChartType.pie: [
      PieChartSample(
        'Pie Chart Sample 1',
        Urls.getChartSourceCodeUrl(ChartType.pie, 1),
        (context) => const PieChartSample1(),
      ),
      PieChartSample(
        'Pie Chart Sample 2',
        Urls.getChartSourceCodeUrl(ChartType.pie, 2),
        (context) => const PieChartSample2(),
      ),
      PieChartSample(
        'Pie Chart Sample 3',
        Urls.getChartSourceCodeUrl(ChartType.pie, 3),
        (context) => const PieChartSample3(),
      ),
    ],
    ChartType.scatter: [
      ScatterChartSample(
        'Scatter Chart Sample 1',
        Urls.getChartSourceCodeUrl(ChartType.scatter, 1),
        (context) => ScatterChartSample1(),
      ),
      ScatterChartSample(
        'Scatter Chart Sample 2',
        Urls.getChartSourceCodeUrl(ChartType.scatter, 2),
        (context) => const ScatterChartSample2(),
      ),
    ],
    ChartType.radar: [
      RadarChartSample(
        'Radar Chart Sample 1',
        Urls.getChartSourceCodeUrl(ChartType.radar, 1),
        (context) => RadarChartSample1(),
      ),
    ],
  };
}
