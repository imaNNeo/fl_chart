import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class ScatterChartData extends AxisChartData {

  final List<ScatterSpot> scatterSpots;
  final FlTitlesData titlesData;
  final ExtraLinesData extraLinesData;

  final ScatterTouchData scatterTouchData;

  ScatterChartData({
    this.scatterSpots = const [],
    this.titlesData = const FlTitlesData(),
    this.extraLinesData = const ExtraLinesData(),
    this.scatterTouchData = const ScatterTouchData(),
    FlGridData gridData = const FlGridData(),
    FlBorderData borderData,
    double minX,
    double maxX,
    double minY,
    double maxY,
    bool clipToBorder = false,
    Color backgroundColor,
  }) : super(
    gridData: gridData,
    touchData: scatterTouchData,
    borderData: borderData,
    clipToBorder: clipToBorder,
    backgroundColor: backgroundColor,
  ) {
    initSuperMinMaxValues(minX, maxX, minY, maxY);
  }

  void initSuperMinMaxValues(
    double minX,
    double maxX,
    double minY,
    double maxY,
    ) {
    if (scatterSpots.isNotEmpty) {
      var canModifyMinX = false;
      if (minX == null) {
        minX = scatterSpots[0].x;
        canModifyMinX = true;
      }

      var canModifyMaxX = false;
      if (maxX == null) {
        maxX = scatterSpots[0].x;
        canModifyMaxX = true;
      }

      var canModifyMinY = false;
      if (minY == null) {
        minY = scatterSpots[0].y;
        canModifyMinY = true;
      }

      var canModifyMaxY = false;
      if (maxY == null) {
        maxY = scatterSpots[0].y;
        canModifyMaxY = true;
      }

      for (int j = 0; j < scatterSpots.length; j++) {
        final ScatterSpot spot = scatterSpots[j];
        if (canModifyMaxX && spot.x > maxX) {
          maxX = spot.x;
        }

        if (canModifyMinX && spot.x < minX) {
          minX = spot.x;
        }

        if (canModifyMaxY && spot.y > maxY) {
          maxY = spot.y;
        }

        if (canModifyMinY && spot.y < minY) {
          minY = spot.y;
        }
      }
    } else {
      minX = 0;
      maxX = 0;
      minY = 0;
      minX = 0;
    }

    super.minX = minX;
    super.maxX = maxX;
    super.minY = minY;
    super.maxY = maxY;
  }

  @override
  ScatterChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is ScatterChartData && b is ScatterChartData && t != null) {
      return ScatterChartData(
        scatterSpots: lerpScatterSpotList(a.scatterSpots, b.scatterSpots, t),
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        extraLinesData: ExtraLinesData.lerp(a.extraLinesData, b.extraLinesData, t),
        scatterTouchData: b.scatterTouchData,
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        minX: lerpDouble(a.minX, b.minX, t),
        maxX: lerpDouble(a.maxX, b.maxX, t),
        minY: lerpDouble(a.minY, b.minY, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        clipToBorder: b.clipToBorder,
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  ScatterChartData copyWith({
    List<ScatterSpot> scatterSpots,
    FlTitlesData titlesData,
    ExtraLinesData extraLinesData,
    ScatterTouchData scatterTouchData,
    FlGridData gridData,
    FlBorderData borderData,
    double minX,
    double maxX,
    double minY,
    double maxY,
    bool clipToBorder,
    Color backgroundColor,
  }) {
    return ScatterChartData(
      scatterSpots: scatterSpots ?? this.scatterSpots,
      titlesData: titlesData ?? this.titlesData,
      extraLinesData: extraLinesData ?? this.extraLinesData,
      scatterTouchData: scatterTouchData ?? this.scatterTouchData,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      minY: minY ?? this.minY,
      maxY: maxY ?? this.maxY,
      clipToBorder: clipToBorder ?? this.clipToBorder,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

}

class ScatterSpot extends FlSpot {
  final bool show;
  final double radius;
  Color color;

  ScatterSpot(double x, double y, {
    this.show = true,
    this.radius = 6,
    this.color,
  }) : super(x, y) {
    color ??= Colors.primaries[((x * y) % Colors.primaries.length).toInt()];
  }

  static ScatterSpot lerp(ScatterSpot a, ScatterSpot b, double t) {
    return ScatterSpot(
      lerpDouble(a.x, b.x, t),
      lerpDouble(a.y, b.y, t),
      show: b.show,
      radius: lerpDouble(a.radius, b.radius, t),
      color: Color.lerp(a.color, b.color, t),
    );
  }

}

class ScatterTouchResponse extends BaseTouchResponse {

  final ScatterSpot touchedSpot;

  ScatterTouchResponse(FlTouchInput touchInput, this.touchedSpot) : super(touchInput);
}

class ScatterTouchData extends FlTouchData {

  /// show a tooltip on touched spots
  final LineTouchTooltipData touchTooltipData;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  /// set this true if you want the built in touch handling
  /// (show a tooltip bubble and an indicator on touched spots)
  final bool handleBuiltInTouches;

  /// you can implement it to receive touches callback
  final Function(ScatterTouchResponse) touchCallback;

  const ScatterTouchData({
    bool enabled = true,
    bool enableNormalTouch = true,
    this.touchTooltipData = const LineTouchTooltipData(),
    this.touchSpotThreshold = 10,
    this.handleBuiltInTouches = true,
    this.touchCallback,
  }) : super(enabled, enableNormalTouch);

  ScatterTouchData copyWith({
    bool enabled,
    bool enableNormalTouch,
    LineTouchTooltipData touchTooltipData,
    double touchSpotThreshold,
    Function(ScatterTouchResponse) touchCallback,
  }) {
    return ScatterTouchData(
      enabled: enabled ?? this.enabled,
      enableNormalTouch: enableNormalTouch ?? this.enableNormalTouch,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      touchSpotThreshold: touchSpotThreshold ?? this.touchSpotThreshold,
      touchCallback: touchCallback ?? this.touchCallback,
    );
  }

}

class ScatterChartDataTween extends Tween<ScatterChartData> {

  ScatterChartDataTween({ScatterChartData begin, ScatterChartData end}) : super(begin: begin, end: end);

  @override
  ScatterChartData lerp(double t) {
    return begin.lerp(begin, end, t);
  }

}