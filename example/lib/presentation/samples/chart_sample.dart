import 'package:fl_chart_app/util/app_helper.dart';
import 'package:flutter/cupertino.dart';

abstract class ChartSample {
  final String name;
  final String url;
  final WidgetBuilder builder;
  ChartType get type;
  ChartSample(this.name, this.url, this.builder);
}

class LineChartSample extends ChartSample {
  LineChartSample(super.name, super.url, super.builder);
  @override
  ChartType get type => ChartType.line;
}

class BarChartSample extends ChartSample {
  BarChartSample(super.name, super.url, super.builder);
  @override
  ChartType get type => ChartType.bar;
}

class PieChartSample extends ChartSample {
  PieChartSample(super.name, super.url, super.builder);
  @override
  ChartType get type => ChartType.pie;
}

class ScatterChartSample extends ChartSample {
  ScatterChartSample(super.name, super.url, super.builder);
  @override
  ChartType get type => ChartType.scatter;
}

class RadarChartSample extends ChartSample {
  RadarChartSample(super.name, super.url, super.builder);
  @override
  ChartType get type => ChartType.radar;
}
