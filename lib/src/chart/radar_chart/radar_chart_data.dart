import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/src/extensions/list_extension.dart';

typedef GetTitleByIndexFunction = String Function(int index);

//ToDo(payam) : document data classes
class RadarChartData extends BaseChartData {
  final List<RadarDataSet> dataSets;

  final Color radarBackgroundColor;
  final BorderSide radarBorderData;

  final GetTitleByIndexFunction getTitle;
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
  final BorderSide tickBorderData;

  final BorderSide gridBorderData;

  final RadarTouchData radarTouchData;

  RadarChartData({
    @required List<RadarDataSet> dataSets,
    Color radarBackgroundColor,
    BorderSide radarBorderData,
    GetTitleByIndexFunction getTitle,
    TextStyle titleTextStyle,
    double titlePositionPercentageOffset,
    int tickCount,
    TextStyle ticksTextStyle,
    BorderSide tickBorderData,
    BorderSide gridBorderData,
    RadarTouchData radarTouchData,
    FlBorderData borderData,
  })  : assert(dataSets != null && dataSets.hasEqualDataEntriesLength),
        assert(tickCount == null || tickCount >= 1, "RadarChart need's at least 1 tick"),
        assert(
          titlePositionPercentageOffset==null || titlePositionPercentageOffset >= 0 && titlePositionPercentageOffset <= 1,
          'titlePositionPercentageOffset must be something between 0 and 1 ',
        ),
        dataSets = dataSets ?? const [],
        radarBackgroundColor = radarBackgroundColor ?? Colors.transparent,
        radarBorderData = radarBorderData ?? const BorderSide(color: Colors.black, width: 2),
        radarTouchData = radarTouchData ?? RadarTouchData(),
        getTitle = getTitle,
        titleTextStyle = titleTextStyle ?? const TextStyle(color: Colors.black, fontSize: 12),
        titlePositionPercentageOffset = titlePositionPercentageOffset ?? 0.2,
        tickCount = tickCount ?? 1,
        ticksTextStyle = ticksTextStyle ?? const TextStyle(fontSize: 10, color: Colors.black),
        tickBorderData = tickBorderData ?? const BorderSide(color: Colors.black, width: 2),
        gridBorderData = gridBorderData ?? const BorderSide(color: Colors.black, width: 2),
        super(borderData: borderData, touchData: radarTouchData);

  RadarEntry get maxEntry {
    var maximum = dataSets.first.dataEntries.first;

    for (final dataSet in dataSets) {
      for (final entry in dataSet.dataEntries) {
        if (entry.value > maximum.value) maximum = entry;
      }
    }
    return maximum;
  }

  RadarEntry get minEntry {
    var minimum = dataSets.first.dataEntries.first;

    for (final dataSet in dataSets) {
      for (final entry in dataSet.dataEntries) {
        if (entry.value < minimum.value) minimum = entry;
      }
    }

    return minimum;
  }

  int get titleCount => dataSets[0].dataEntries.length;

  RadarChartData copyWith({
    List<RadarDataSet> dataSets,
    Color radarBackgroundColor,
    BorderSide radarBorderData,
    GetTitleByIndexFunction getTitle,
    TextStyle titleTextStyle,
    double titlePositionPercentageOffset,
    int tickCount,
    TextStyle ticksTextStyle,
    BorderSide tickBorderData,
    BorderSide gridBorderData,
    RadarTouchData radarTouchData,
    FlBorderData borderData,
  }) =>
      RadarChartData(
        dataSets: dataSets ?? this.dataSets,
        radarBackgroundColor: radarBackgroundColor ?? this.radarBackgroundColor,
        radarBorderData: radarBorderData ?? this.radarBorderData,
        getTitle: getTitle ?? this.getTitle,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        titlePositionPercentageOffset:
            titlePositionPercentageOffset ?? this.titlePositionPercentageOffset,
        tickCount: tickCount ?? this.tickCount,
        ticksTextStyle: ticksTextStyle ?? this.ticksTextStyle,
        tickBorderData: tickBorderData ?? this.tickBorderData,
        gridBorderData: gridBorderData ?? this.gridBorderData,
        radarTouchData: radarTouchData ?? this.radarTouchData,
        borderData: borderData ?? this.borderData,
      );

  @override
  RadarChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is RadarChartData && b is RadarChartData && t != null) {
      return RadarChartData(
        dataSets: lerpRadarDataSetList(a.dataSets, b.dataSets, t),
        radarBackgroundColor: Color.lerp(a.radarBackgroundColor, b.radarBackgroundColor, t),
        getTitle: b.getTitle,
        titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
        titlePositionPercentageOffset: lerpDouble(
          a.titlePositionPercentageOffset,
          b.titlePositionPercentageOffset,
          t,
        ),
        tickCount: lerpInt(a.tickCount, b.tickCount, t),
        ticksTextStyle: TextStyle.lerp(a.ticksTextStyle, b.ticksTextStyle, t),
        gridBorderData: BorderSide.lerp(a.gridBorderData, b.gridBorderData, t),
        radarBorderData: BorderSide.lerp(a.radarBorderData, b.radarBorderData, t),
        tickBorderData: BorderSide.lerp(a.tickBorderData, b.tickBorderData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        radarTouchData: b.radarTouchData,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        borderData,
        touchData,
        dataSets,
        radarBackgroundColor,
        radarBorderData,
        getTitle,
        titleTextStyle,
        titlePositionPercentageOffset,
        tickCount,
        ticksTextStyle,
        tickBorderData,
        gridBorderData,
        radarTouchData,
      ];
}

class RadarDataSet extends Equatable {
  final List<RadarEntry> dataEntries;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double entryRadius;

  const RadarDataSet({
    List<RadarEntry> dataEntries,
    Color fillColor,
    Color borderColor,
    double borderWidth,
    double entryRadius,
  })  : dataEntries = dataEntries ?? const [],
        fillColor = fillColor,
        borderColor = borderColor,
        borderWidth = borderWidth ?? 2,
        entryRadius = entryRadius ?? 5.0;

  RadarDataSet copyWith({
    List<RadarEntry> dataEntries,
    Color fillColor,
    Color borderColor,
    double borderWidth,
    double entryRadius,
  }) =>
      RadarDataSet(
        dataEntries: dataEntries ?? this.dataEntries,
        fillColor: fillColor ?? this.fillColor,
        borderColor: borderColor ?? this.borderColor,
        borderWidth: borderWidth ?? this.borderWidth,
        entryRadius: entryRadius ?? this.entryRadius,
      );

  static RadarDataSet lerp(RadarDataSet a, RadarDataSet b, double t) {
    return RadarDataSet(
      dataEntries: lerpRadarEntryList(a.dataEntries, b.dataEntries, t),
      fillColor: Color.lerp(a.fillColor, b.fillColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      entryRadius: lerpDouble(a.entryRadius, b.entryRadius, t),
    );
  }

  @override
  List<Object> get props => [
        dataEntries,
        fillColor,
        borderColor,
        borderWidth,
        entryRadius,
      ];
}

class RadarEntry extends Equatable {
  final double value;

  const RadarEntry({double value}) : value = value ?? 0;

  RadarEntry copyWith({double value}) => RadarEntry(value: value ?? this.value);

  static RadarEntry lerp(RadarEntry a, RadarEntry b, double t) {
    return RadarEntry(value: lerpDouble(a.value, b.value, t));
  }

  @override
  List<Object> get props => [value];
}

class RadarTouchData extends FlTouchData {
  /// you can implement it to receive touches callback
  final Function(RadarTouchResponse) touchCallback;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  RadarTouchData({
    bool enabled,
    Function(RadarTouchResponse) touchCallback,
    double touchSpotThreshold,
  })  : touchCallback = touchCallback,
        touchSpotThreshold = touchSpotThreshold ?? 10,
        super(enabled ?? true);

  @override
  List<Object> get props => [
        enabled,
        touchSpotThreshold,
        touchCallback,
      ];
}

class RadarTouchResponse extends BaseTouchResponse {
  final RadarTouchedSpot touchedSpot;

  RadarTouchResponse(
    RadarTouchedSpot touchedSpot,
    FlTouchInput touchInput,
  )   : touchedSpot = touchedSpot,
        super(touchInput);

  @override
  List<Object> get props => [
        touchedSpot,
        touchInput,
      ];
}

class RadarTouchedSpot extends TouchedSpot {
  final RadarDataSet touchedDataSet;
  final int touchedDataSetIndex;

  final RadarEntry touchedRadarEntry;
  final int touchedRadarEntryIndex;

  RadarTouchedSpot(
    RadarDataSet touchedDataSet,
    int touchedDataSetIndex,
    RadarEntry touchedRadarEntry,
    int touchedRadarEntryIndex,
    FlSpot spot,
    Offset offset,
  )   : touchedDataSet = touchedDataSet,
        touchedDataSetIndex = touchedDataSetIndex,
        touchedRadarEntry = touchedRadarEntry,
        touchedRadarEntryIndex = touchedRadarEntryIndex,
        super(spot, offset);

  Color getColor() {
    return Colors.black;
  }

  @override
  List<Object> get props => [
        spot,
        offset,
        touchedDataSet,
        touchedDataSetIndex,
        touchedRadarEntry,
        touchedRadarEntryIndex,
      ];
}

class RadarChartDataTween extends Tween<RadarChartData> {
  RadarChartDataTween({
    RadarChartData begin,
    RadarChartData end,
  }) : super(begin: begin, end: end);

  @override
  RadarChartData lerp(double t) => begin.lerp(begin, end, t);
}
