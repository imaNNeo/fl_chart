import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

typedef GetTitleByIndexFunction = String Function(int index);

class RadarChartData extends BaseChartData {
  //ToDo(payam) : add description for asserts
  RadarChartData({
    this.dataSets = const [],
    this.getTitle,
    @required this.titleCount,
    @required this.tickCount,
    this.fillColor = Colors.transparent,
    FlTouchData touchData,
    FlBorderData borderData,
  })  : assert(titleCount != null),
        assert(tickCount != null),
        assert(
          dataSets.firstWhere(
                (element) => element.dataEntries.length != titleCount,
                orElse: () => null,
              ) ==
              null,
        ),
        super(borderData: borderData, touchData: touchData);

  final List<RadarDataSet> dataSets;
  final GetTitleByIndexFunction getTitle;
  final Color fillColor;
  final int titleCount;
  final int tickCount;

  RadarEntry get maxEntry {
    var maximum = dataSets.first.dataEntries.first;

    for (final dataSet in dataSets)
      for (final entry in dataSet.dataEntries) if (entry.value > maximum.value) maximum = entry;

    return maximum;
  }

  RadarEntry get minEntry {
    var minimum = dataSets.first.dataEntries.first;

    for (final dataSet in dataSets)
      for (final entry in dataSet.dataEntries) if (entry.value < minimum.value) minimum = entry;

    return minimum;
  }

  @override
  RadarChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is RadarChartData && b is RadarChartData && t != null) {
      return RadarChartData(
        getTitle: b.getTitle,
        titleCount: lerpInt(a.titleCount, b.titleCount, t),
        tickCount: lerpInt(a.tickCount, b.tickCount, t),
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
  final double strokeWidth;

  RadarDataSet({
    this.dataEntries = const [],
    this.color,
    this.strokeWidth,
  });

  static RadarDataSet lerp(RadarDataSet a, RadarDataSet b, double t) {
    return RadarDataSet(
      dataEntries: lerpRadarEntryList(a.dataEntries, b.dataEntries, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
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

class RadarTouchData extends FlTouchData {
  /// you can implement it to receive touches callback
  final Function(RadarTouchResponse) touchCallback;

  const RadarTouchData({
    bool enabled = true,
    bool enableNormalTouch = true,
    this.touchCallback,
  }) : super(enabled, enableNormalTouch);
}

class RadarTouchResponse extends BaseTouchResponse {
  final RadarTouchedSpot touchedSpot;

  RadarTouchResponse(
    this.touchedSpot,
    FlTouchInput touchInput,
  ) : super(touchInput);
}

class RadarTouchedSpot extends TouchedSpot {
  final RadarDataSet touchedDataSet;
  final int touchedDataSetIndex;

  final RadarEntry touchedRadarEntry;
  final int touchedRadarEntryIndex;

  RadarTouchedSpot(
    this.touchedDataSet,
    this.touchedDataSetIndex,
    this.touchedRadarEntry,
    this.touchedRadarEntryIndex,
    FlSpot spot,
    Offset offset,
  ) : super(spot, offset);

  @override
  Color getColor() {
    return Colors.black;
  }
}

class RadarChartDataTween extends Tween<RadarChartData> {
  RadarChartDataTween({
    RadarChartData begin,
    RadarChartData end,
  }) : super(begin: begin, end: end);

  @override
  RadarChartData lerp(double t) => begin.lerp(begin, end, t);
}
