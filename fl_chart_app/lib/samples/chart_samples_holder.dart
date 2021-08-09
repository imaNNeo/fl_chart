import 'package:fl_chart_app/util/app_helper.dart';
import 'package:flutter/material.dart';

import 'bar/bar_sample_1.dart';
import 'line/line_sample_1.dart';
import 'pie/pie_sample_1.dart';
import 'radar/radar_sample_1.dart';
import 'scatter/scatter_sample_1.dart';

class ChartSamplesHolder {
  static final Map<ChartType, List<WidgetBuilder>> samples = {
    ChartType.LINE: [
      (context) => LineSample1(),
      (context) => LineSample1(),
      (context) => LineSample1(),
      (context) => LineSample1(),
    ],
    ChartType.BAR: [
      (context) => BarSample1(),
      (context) => BarSample1(),
      (context) => BarSample1(),
      (context) => BarSample1(),
    ],
    ChartType.PIE: [
      (context) => PieSample1(),
      (context) => PieSample1(),
      (context) => PieSample1(),
      (context) => PieSample1(),
    ],
    ChartType.SCATTER: [
      (context) => ScatterSample1(),
      (context) => ScatterSample1(),
      (context) => ScatterSample1(),
      (context) => ScatterSample1(),
    ],
    ChartType.RADAR: [
      (context) => RadarSample1(),
      (context) => RadarSample1(),
      (context) => RadarSample1(),
      (context) => RadarSample1(),
      (context) => RadarSample1(),
    ],
  };
}
