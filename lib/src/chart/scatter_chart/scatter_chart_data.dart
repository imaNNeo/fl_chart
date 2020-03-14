import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class ScatterChartData extends AxisChartData {
  final List<ScatterSpot> scatterSpots;
  final FlTitlesData titlesData;
  final ScatterTouchData scatterTouchData;
  final List<int> showingTooltipIndicators;

  ScatterChartData({
    this.scatterSpots = const [],
    this.titlesData = const FlTitlesData(),
    this.scatterTouchData = const ScatterTouchData(),
    this.showingTooltipIndicators = const [],
    FlGridData gridData = const FlGridData(),
    FlBorderData borderData,
    FlAxisTitleData axisTitleData = const FlAxisTitleData(),
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
          axisTitleData: axisTitleData,
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
    }

    super.minX = minX ?? 0;
    super.maxX = maxX ?? 1;
    super.minY = minY ?? 0;
    super.maxY = maxY ?? 1;
  }

  @override
  ScatterChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is ScatterChartData && b is ScatterChartData && t != null) {
      return ScatterChartData(
        scatterSpots: lerpScatterSpotList(a.scatterSpots, b.scatterSpots, t),
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        scatterTouchData: b.scatterTouchData,
        showingTooltipIndicators:
            lerpIntList(a.showingTooltipIndicators, b.showingTooltipIndicators, t),
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        axisTitleData: FlAxisTitleData.lerp(a.axisTitleData, b.axisTitleData, t),
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
    ScatterTouchData scatterTouchData,
    List<int> showingTooltipIndicators,
    FlGridData gridData,
    FlBorderData borderData,
    FlAxisTitleData axisTitleData,
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
      scatterTouchData: scatterTouchData ?? this.scatterTouchData,
      showingTooltipIndicators: showingTooltipIndicators ?? this.showingTooltipIndicators,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      axisTitleData: axisTitleData ?? this.axisTitleData,
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

  ScatterSpot(
    double x,
    double y, {
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
  final int touchedSpotIndex;

  ScatterTouchResponse(
    FlTouchInput touchInput,
    this.touchedSpot,
    this.touchedSpotIndex,
  ) : super(touchInput);
}

class ScatterTouchData extends FlTouchData {
  /// show a tooltip on touched spots
  final ScatterTouchTooltipData touchTooltipData;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  /// set this true if you want the built in touch handling
  /// (show a tooltip bubble and an indicator on touched spots)
  final bool handleBuiltInTouches;

  /// you can implement it to receive touches callback
  final Function(ScatterTouchResponse) touchCallback;

  const ScatterTouchData({
    bool enabled = true,
    this.touchTooltipData = const ScatterTouchTooltipData(),
    this.touchSpotThreshold = 10,
    this.handleBuiltInTouches = true,
    this.touchCallback,
  }) : super(enabled);

  ScatterTouchData copyWith({
    bool enabled,
    LineTouchTooltipData touchTooltipData,
    double touchSpotThreshold,
    Function(ScatterTouchResponse) touchCallback,
  }) {
    return ScatterTouchData(
      enabled: enabled ?? this.enabled,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      touchSpotThreshold: touchSpotThreshold ?? this.touchSpotThreshold,
      touchCallback: touchCallback ?? this.touchCallback,
    );
  }
}

/// Holds information for showing tooltip
/// when a touch event happened
class ScatterTouchTooltipData {
  final Color tooltipBgColor;
  final double tooltipRoundedRadius;
  final EdgeInsets tooltipPadding;
  final double maxContentWidth;
  final GetScatterTooltipItems getTooltipItems;

  const ScatterTouchTooltipData({
    this.tooltipBgColor = Colors.white,
    this.tooltipRoundedRadius = 4,
    this.tooltipPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.maxContentWidth = 120,
    this.getTooltipItems = defaultScatterTooltipItem,
  }) : super();
}

/// show each [ScatterTooltipItem] on the tooltip window,
/// return null if you don't want to show each item
/// here we get the [ScatterTooltipItem] from the given [ScatterSpot].
typedef GetScatterTooltipItems = ScatterTooltipItem Function(ScatterSpot touchedSpots);

ScatterTooltipItem defaultScatterTooltipItem(ScatterSpot touchedSpot) {
  if (touchedSpot == null) {
    return null;
  }
  final TextStyle textStyle = TextStyle(
    color: touchedSpot.color,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return ScatterTooltipItem(
      '${touchedSpot.radius.toInt()}', textStyle, touchedSpot.radius + (touchedSpot.radius * 0.2));
}

/// holds data of showing each item in the tooltip window
class ScatterTooltipItem {
  final String text;
  final TextStyle textStyle;
  final double bottomMargin;

  ScatterTooltipItem(
    this.text,
    this.textStyle,
    this.bottomMargin,
  );
}

class ScatterChartDataTween extends Tween<ScatterChartData> {
  ScatterChartDataTween({ScatterChartData begin, ScatterChartData end})
      : super(begin: begin, end: end);

  @override
  ScatterChartData lerp(double t) {
    return begin.lerp(begin, end, t);
  }
}
