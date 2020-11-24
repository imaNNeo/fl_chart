import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

typedef GetTitleByIndexFunction = String Function(int index);

class RadarChartData extends BaseChartData {
  final List<RadarDataSet> dataSets;
  final GetTitleByIndexFunction getTitle;
  final int count;
  final Color fillColor;

  RadarChartData({
    this.dataSets = const [],
    this.getTitle,
    @required this.count,
    this.fillColor = Colors.transparent,
  }) : assert(count != null);

  @override
  RadarChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is RadarChartData && b is RadarChartData && t != null) {
      return RadarChartData(
        getTitle: b.getTitle,
        count: lerpInt(a.count, b.count, t),
        fillColor: Color.lerp(a.fillColor, b.fillColor, t),
        dataSets: lerpRadarDataSetList(a.dataSets, b.dataSets, t),
      );
    } else {
      throw Exception('Illegal State');
    }
  }
}

class RadarDataSet {
  final List<RadarEntry> dataEntries;
  final Color color;

  RadarDataSet({
    this.dataEntries = const [],
    this.color,
  });

  static RadarDataSet lerp(RadarDataSet a, RadarDataSet b, double t) {
    return RadarDataSet(
      dataEntries: lerpRadarEntryList(a.dataEntries, b.dataEntries, t),
      color: Color.lerp(a.color, b.color, t),
    );
  }
}

class RadarEntry {
  final double value;

  RadarEntry({this.value = 0});

  static RadarEntry lerp(RadarEntry a, RadarEntry b, double t) {
    return RadarEntry(value: lerpDouble(a.value, b.value, t));
  }
}
