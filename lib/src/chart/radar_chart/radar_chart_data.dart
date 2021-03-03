import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_extension.dart';

typedef GetTitleByIndexFunction = String Function(int index);

/// [RadarChart] needs this class to render itself.
///
/// It holds data needed to draw a radar chart,
/// including radar dataSets, colors, ...
class RadarChartData extends BaseChartData with EquatableMixin {
  /// [RadarChart] draw [dataSets] that each of them showing a list of [RadarEntry]
  final List<RadarDataSet> dataSets;

  /// [radarBackgroundColor] draw the background color of the [RadarChart]
  final Color radarBackgroundColor;

  /// [radarBorderData] is used to draw [RadarChart] border
  final BorderSide radarBorderData;

  /// [getTitle] is used to draw titles near the [RadarChart]
  /// [getTitle] is type of [GetTitleByIndexFunction] so you should return a valid [String]
  /// for each [index]
  ///
  /// ```dart
  /// getTitle: (index) {
  ///   switch (index) {
  ///     case 0:
  ///       return 'Mobile or Tablet';
  ///     case 2:
  ///       return 'Desktop';
  ///     case 1:
  ///       return 'TV';
  ///     default:
  ///       return '';
  ///   }
  /// }
  /// ```
  final GetTitleByIndexFunction? getTitle;

  /// Defines style of showing [RadarChart] titles.
  final TextStyle titleTextStyle;

  /// the [titlePositionPercentageOffset] is the place of showing title on the [RadarChart]
  /// the degree is statically on the end of Radar Line,
  /// this field should be between 0 and 1,
  /// if it is 0 the title will be drawn near the inside section,
  /// if it is 1 the title will be drawn near the outside of section,
  /// the default value is 0.2.
  final double titlePositionPercentageOffset;

  /// Defines the number of ticks that should be paint in [RadarChart]
  /// the default & minimum value of this field is 1.
  final int tickCount;

  /// Defines style of showing [RadarChart] tick titles.
  final TextStyle ticksTextStyle;

  /// Defines style of showing [RadarChart] tick borders.
  final BorderSide tickBorderData;

  /// Defines style of showing [RadarChart] grid borders.
  final BorderSide gridBorderData;

  /// Handles touch behaviors and responses.
  final RadarTouchData radarTouchData;

  /// [titleCount] we use this value to determine number of [RadarChart] grid or lines.
  int get titleCount => dataSets[0].dataEntries.length;

  /// defines the maximum [RadarEntry] value in all [dataSets]
  /// we use this value to calculate the maximum value of ticks.
  RadarEntry get maxEntry {
    var maximum = dataSets.first.dataEntries.first;

    for (final dataSet in dataSets) {
      for (final entry in dataSet.dataEntries) {
        if (entry.value > maximum.value) maximum = entry;
      }
    }
    return maximum;
  }

  /// defines the minimum [RadarEntry] value in all [dataSets]
  /// we use this value to calculate the minimum value of ticks.
  RadarEntry get minEntry {
    var minimum = dataSets.first.dataEntries.first;

    for (final dataSet in dataSets) {
      for (final entry in dataSet.dataEntries) {
        if (entry.value < minimum.value) minimum = entry;
      }
    }

    return minimum;
  }

  /// [RadarChart] draws some [dataSets] in a radar-shaped chart.
  /// it fills the radar area with [radarBackgroundColor]
  /// and draws radar border with [radarBorderData]
  /// then draws a grid over it, you can customize it using [gridBorderData].
  ///
  /// it draws some titles based on the number of [dataSets] values.
  /// the titles are shown near each radar grid or line.
  /// for changing the titles you can modify the [getTitle] field.
  /// and for styling the titles you can use [titleTextStyle].
  ///
  /// it draws some ticks. and you can customize the number of ticks by modifying the [titleCount]
  /// and style the ticks titles with [ticksTextStyle].
  /// for changing the ticks color and border width you can use [tickBorderData].
  ///
  /// You can modify [radarTouchData] to customize touch behaviors and responses.
  RadarChartData({
    @required List<RadarDataSet>? dataSets,
    Color? radarBackgroundColor,
    BorderSide? radarBorderData,
    GetTitleByIndexFunction? getTitle,
    TextStyle? titleTextStyle,
    double? titlePositionPercentageOffset,
    int? tickCount,
    TextStyle? ticksTextStyle,
    BorderSide? tickBorderData,
    BorderSide? gridBorderData,
    RadarTouchData? radarTouchData,
    FlBorderData? borderData,
  })  : assert(dataSets != null && dataSets.hasEqualDataEntriesLength),
        assert(tickCount == null || tickCount >= 1, "RadarChart need's at least 1 tick"),
        assert(
          titlePositionPercentageOffset == null ||
              titlePositionPercentageOffset >= 0 && titlePositionPercentageOffset <= 1,
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
        super(borderData: borderData, touchData: radarTouchData ?? RadarTouchData());

  /// Copies current [RadarChartData] to a new [RadarChartData],
  /// and replaces provided values.
  RadarChartData copyWith({
    List<RadarDataSet>? dataSets,
    Color? radarBackgroundColor,
    BorderSide? radarBorderData,
    GetTitleByIndexFunction? getTitle,
    TextStyle? titleTextStyle,
    double? titlePositionPercentageOffset,
    int? tickCount,
    TextStyle? ticksTextStyle,
    BorderSide? tickBorderData,
    BorderSide? gridBorderData,
    RadarTouchData? radarTouchData,
    FlBorderData? borderData,
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

  /// Lerps a [BaseChartData] based on [t] value, check [Tween.lerp].
  @override
  RadarChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is RadarChartData && b is RadarChartData) {
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
  List<Object?> get props => [
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

/// the data values for drawing [RadarChart] sections
class RadarDataSet with EquatableMixin {
  /// each section or dataSets consists of a set of [dataEntries].
  final List<RadarEntry> dataEntries;

  /// defines the color that fills the [RadarDataSet].
  final Color fillColor;

  /// defines the border color of the [RadarDataSet].
  /// if [borderColor] is not defined it will replaced with [fillColor].
  final Color borderColor;

  /// defines the width of [RadarDataSet] border.
  /// the default value of this field is 2.0
  final double borderWidth;

  /// defines the radius of each entry
  /// the default value of this field is 5.0
  final double entryRadius;

  /// [RadarChart] can contain multiple [RadarDataSet] And it shows them on top of each other.
  /// each [RadarDataSet] has a set of [dataEntries]
  /// and the [RadarChart] uses this [dataEntries] to draw the chart.
  ///
  /// it fill dataSets with [fillColor].
  ///
  /// the [RadarDataSet] can have custom border. for changing border of [RadarDataSet]
  /// you can modify the [borderColor] and [borderWidth].
  const RadarDataSet({
    List<RadarEntry>? dataEntries,
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    double? entryRadius,
  })  : dataEntries = dataEntries ?? const [],
        fillColor = fillColor ?? Colors.black12,
        borderColor = borderColor ?? Colors.blueAccent,
        borderWidth = borderWidth ?? 2.0,
        entryRadius = entryRadius ?? 5.0;

  /// Copies current [RadarDataSet] to a new [RadarDataSet],
  /// and replaces provided values.
  RadarDataSet copyWith({
    List<RadarEntry>? dataEntries,
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    double? entryRadius,
  }) =>
      RadarDataSet(
        dataEntries: dataEntries ?? this.dataEntries,
        fillColor: fillColor ?? this.fillColor,
        borderColor: borderColor ?? this.borderColor,
        borderWidth: borderWidth ?? this.borderWidth,
        entryRadius: entryRadius ?? this.entryRadius,
      );

  /// Lerps a [RadarDataSet] based on [t] value, check [Tween.lerp].
  static RadarDataSet lerp(RadarDataSet a, RadarDataSet b, double t) {
    return RadarDataSet(
      dataEntries: lerpRadarEntryList(a.dataEntries, b.dataEntries, t),
      fillColor: Color.lerp(a.fillColor, b.fillColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      entryRadius: lerpDouble(a.entryRadius, b.entryRadius, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        dataEntries,
        fillColor,
        borderColor,
        borderWidth,
        entryRadius,
      ];
}

/// holds the data about each entry or point in [RadarChart]
class RadarEntry with EquatableMixin {
  /// [RadarChart] uses this field to render every point in chart.
  final double value;

  /// [RadarChart] draws every point or entry with [RadarEntry]
  const RadarEntry({required double value}) : value = value;

  /// Lerps a [RadarEntry] based on [t] value, check [Tween.lerp].
  RadarEntry copyWith({double? value}) => RadarEntry(value: value ?? this.value);

  /// Lerps a [RadarDataSet] based on [t] value, check [Tween.lerp].
  static RadarEntry lerp(RadarEntry a, RadarEntry b, double t) {
    return RadarEntry(value: lerpDouble(a.value, b.value, t)!);
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [value];
}

/// Holds data to handle touch events, and touch responses in the [RadarChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [RadarTouchData].
class RadarTouchData extends FlTouchData with EquatableMixin {
  /// you can implement it to receive touches callback
  final Function(RadarTouchResponse)? touchCallback;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  /// You can disable or enable the touch system using [enabled] flag,
  ///
  /// You can listen to touch events using [touchCallback],
  /// It gives you a [RadarTouchResponse] that contains some
  /// useful information about happened touch.
  RadarTouchData({
    bool? enabled,
    Function(RadarTouchResponse)? touchCallback,
    double? touchSpotThreshold,
  })  : touchCallback = touchCallback,
        touchSpotThreshold = touchSpotThreshold ?? 10,
        super(enabled ?? true);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchSpotThreshold,
        touchCallback,
      ];
}

/// Holds information about touch response in the [RadarTouchResponse].
///
/// You can override [RadarTouchData.touchCallback] to handle touch events,
/// it gives you a [RadarTouchResponse] and you can do whatever you want.
class RadarTouchResponse extends BaseTouchResponse with EquatableMixin {
  /// touch happened on this spot. this spot has useful information about spot or entry
  final RadarTouchedSpot? touchedSpot;

  /// If touch happens, [RadarChart] processes it internally and passes out a [RadarTouchResponse]
  /// that contains a [touchedSpot], it gives you information about the touched spot.
  /// [touchInput] is the type of happened touch.
  RadarTouchResponse(
    RadarTouchedSpot? touchedSpot,
    FlTouchInput touchInput,
  )   : touchedSpot = touchedSpot,
        super(touchInput);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        touchedSpot,
        touchInput,
      ];
}

/// It gives you information about the touched spot.
class RadarTouchedSpot extends TouchedSpot with EquatableMixin {
  final RadarDataSet touchedDataSet;
  final int touchedDataSetIndex;

  final RadarEntry touchedRadarEntry;
  final int touchedRadarEntryIndex;

  /// When touch happens, a [RadarTouchedSpot] returns as a output,
  /// it tells you where the touch happened.
  /// [touchedDataSet], and [touchedDataSetIndex] tell you in which dataSet touch happened,
  /// [touchedRadarEntry], and [touchedRadarEntryIndex] tell you in which entry touch happened,
  /// You can also have the touched x and y in the chart as a [FlSpot] using [spot] value,
  /// and you can have the local touch coordinates on the screen as a [Offset] using [offset] value.
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

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        spot,
        offset,
        touchedDataSet,
        touchedDataSetIndex,
        touchedRadarEntry,
        touchedRadarEntryIndex,
      ];
}

/// It lerps a [RadarChartData] to another [RadarChartData] (handles animation for updating values)
class RadarChartDataTween extends Tween<RadarChartData> {
  RadarChartDataTween({
    required RadarChartData begin,
    required RadarChartData end,
  }) : super(begin: begin, end: end);

  /// Lerps a [RadarChartData] based on [t] value, check [Tween.lerp].
  @override
  RadarChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
