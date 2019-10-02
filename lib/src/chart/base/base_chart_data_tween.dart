import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/animation.dart';

class BaseChartDataTween<T extends BaseChartData> extends Tween<T> {

  BaseChartDataTween({T begin, T end}) : super(begin: begin, end: end);

  @override
  T lerp(double t) => begin.lerp(begin, end, t);
}