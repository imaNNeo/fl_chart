import 'package:fl_chart_app/util/app_helper.dart';
import 'package:flutter/material.dart';

import 'bar/bar_sample_1.dart';
import 'line/line_sample_1.dart';
import 'pie/pie_sample_1.dart';
import 'radar/radar_sample_1.dart';
import 'scatter/scatter_sample_1.dart';

class ChartSamplesHolder {
  static final Map<ChartType, List<WidgetBuilder>> samples = {
    ChartType.line: [
      (context) => const LineSample1(),
      (context) => const LineSample1(),
      (context) => const LineSample1(),
      (context) => const LineSample1(),
    ],
    ChartType.bar: [
      (context) => const BarSample1(),
      (context) => const BarSample1(),
      (context) => const BarSample1(),
      (context) => const BarSample1(),
    ],
    ChartType.pie: [
      (context) => const PieSample1(),
      (context) => const PieSample1(),
      (context) => const PieSample1(),
      (context) => const PieSample1(),
    ],
    ChartType.scatter: [
      (context) => const ScatterSample1(),
      (context) => const ScatterSample1(),
      (context) => const ScatterSample1(),
      (context) => const ScatterSample1(),
    ],
    ChartType.radar: [
      (context) => const RadarSample1(),
      (context) => const RadarSample1(),
      (context) => const RadarSample1(),
      (context) => const RadarSample1(),
      (context) => const RadarSample1(),
    ],
  };
}
