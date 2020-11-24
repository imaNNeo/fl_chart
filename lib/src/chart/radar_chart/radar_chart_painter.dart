import 'dart:math' as math;
import 'dart:math' show pi, cos, sin;
import 'dart:ui';

import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';
import 'package:flutter/material.dart';

const defaultGraphColors = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.orange,
];

class RadarChartPainter extends BaseChartPainter<RadarChartData>
    with TouchHandler<RadarTouchResponse> {

  //ToDo(payam) : add touchHandle function here
  RadarChartPainter(
    RadarChartData data,
    RadarChartData targetData, {
    double textScale,
  }) : super(data, targetData, textScale: textScale);

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    //ToDo(payam) : override this method
    return true;
  }
}
