import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef GetTitleByIndexFunction = String Function(int index);

class RadarChartData extends BaseChartData {
  //ToDo(payam) : document data classes
  RadarChartData({
    this.dataSets = const [],
    this.getTitle,
    @required this.titleCount,
    @required this.tickCount,
    this.fillColor = Colors.transparent,
    this.gridData = const BorderSide(color: Colors.black, width: 2),
    this.ticksTextStyle = const TextStyle(color: Colors.black, fontSize: 9),
    this.titleTextStyle = const TextStyle(color: Colors.black, fontSize: 12),
    this.titlePositionPercentageOffset = 0.2,
    this.radarTouchData,
    FlBorderData borderData,
  })  : assert(dataSets != null, "the dataSets field can't be null"),
        assert(titleCount != null && titleCount >= 2, "RadarChart need's more then 2 titles"),
        assert(tickCount != null && tickCount >= 2, "RadarChart need's more then 2 ticks"),
        assert(
          titlePositionPercentageOffset >= 0 && titlePositionPercentageOffset <= 1,
          'titlePositionPercentageOffset must be something between 0 and 1 ',
        ),
        assert(
          dataSets.firstWhere(
                (element) => element.dataEntries.length != titleCount,
                orElse: () => null,
              ) ==
              null,
          'dataSets value count must be equal to titleCount value',
        ),
        super(borderData: borderData, touchData: radarTouchData);

  final List<RadarDataSet> dataSets;

  final Color fillColor;

  final GetTitleByIndexFunction getTitle;
  final int titleCount;
  final TextStyle titleTextStyle;

  /// the [titlePositionPercentageOffset] is the place of showing title on the section
  /// the degree is statically on the center of each section,
  /// but the radius of drawing is depend of this field,
  /// this field should be between 0 and 1,
  /// if it is 0 the title will be drawn near the inside section,
  /// if it is 1 the title will be drawn near the outside of section,
  /// the default value is 0.5, means it draw on the center of section.
  final double titlePositionPercentageOffset;

  final int tickCount;
  final TextStyle ticksTextStyle;

  final BorderSide gridData;

  final RadarTouchData radarTouchData;

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
        dataSets: lerpRadarDataSetList(a.dataSets, b.dataSets, t),
        fillColor: Color.lerp(a.fillColor, b.fillColor, t),
        getTitle: b.getTitle,
        titleCount: lerpInt(a.titleCount, b.titleCount, t),
        titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
        titlePositionPercentageOffset: lerpDouble(
          a.titlePositionPercentageOffset,
          b.titlePositionPercentageOffset,
          t,
        ),
        tickCount: lerpInt(a.tickCount, b.tickCount, t),
        ticksTextStyle: TextStyle.lerp(a.ticksTextStyle, b.ticksTextStyle, t),
        gridData: BorderSide.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        radarTouchData: b.radarTouchData,
      );
    } else {
      throw Exception('Illegal State');
    }
  }
}

class RadarDataSet {
  final List<RadarEntry> dataEntries;
  final Color color;
  final double borderWidth;
  final double entryRadius;

  const RadarDataSet({
    this.dataEntries = const [],
    @required this.color,
    this.borderWidth = 2,
    this.entryRadius = 5.0,
  });

  static RadarDataSet lerp(RadarDataSet a, RadarDataSet b, double t) {
    return RadarDataSet(
      dataEntries: lerpRadarEntryList(a.dataEntries, b.dataEntries, t),
      color: Color.lerp(a.color, b.color, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      entryRadius: lerpDouble(a.entryRadius, b.entryRadius, t),
    );
  }
}

class RadarEntry {
  final double value;

  const RadarEntry({this.value = 0});

  static RadarEntry lerp(RadarEntry a, RadarEntry b, double t) {
    return RadarEntry(value: lerpDouble(a.value, b.value, t));
  }
}

class RadarTouchData extends FlTouchData {
  /// you can implement it to receive touches callback
  final Function(RadarTouchResponse) touchCallback;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  const RadarTouchData({
    bool enabled = true,
    bool enableNormalTouch = true,
    this.touchCallback,
    this.touchSpotThreshold = 10,
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
