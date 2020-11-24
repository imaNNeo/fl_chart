import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

typedef GetTitleByIndexFunction = String Function(int index);

class RadarChartData extends BaseChartData {
  final List<RadarDataSet> dataSets;
  final GetTitleByIndexFunction getTitle;
  final int count;

  RadarChartData({
    this.dataSets = const [],
    this.getTitle,
    @required this.count,
  }) : assert(count != null);

  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {
    //ToDo(payam) : complete this method
    throw Exception('Illegal State');
  }
}

class RadarDataSet {
  final List<RadarEntry> dataEntries;
  final Color color;

  RadarDataSet({
    this.dataEntries = const [],
    this.color,
  });

//ToDo(payam) : add lerp function
}

class RadarEntry {
  final double value;

  RadarEntry({this.value = 0});
//ToDo(payam) : add lerp function
}
