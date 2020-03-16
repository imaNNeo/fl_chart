import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

/// [ScatterChart] needs this class to render itself.
///
/// It holds data needed to draw a scatter chart,
/// including background color, scatter spots, ...
class ScatterChartData extends AxisChartData {
  final List<ScatterSpot> scatterSpots;
  final FlTitlesData titlesData;
  final ScatterTouchData scatterTouchData;
  final List<int> showingTooltipIndicators;

  /// [ScatterChart] draws some points in a square space,
  /// points are defined by [scatterSpots],
  ///
  /// It draws some titles on left, top, right, bottom sides per each axis number,
  /// you can modify [titlesData] to have your custom titles,
  /// also you can define the axis title (one text per axis) for each side
  /// using [axisTitleData], you can restrict the y axis using [minY] and [maxY] value,
  /// and restrict x axis using [minX] and [maxX].
  ///
  /// It draws a color as a background behind everything you can set it using [backgroundColor],
  /// then a grid over it, you can customize it using [gridData],
  /// and it draws 4 borders around your chart, you can customize it using [borderData].
  ///
  /// You can modify [scatterTouchData] to customize touch behaviors and responses.
  ///
  /// You can show some tooltipIndicators (a popup with an information)
  /// on top of each [ScatterChartData.scatterSpots] using [showingTooltipIndicators],
  /// just put spot indices you want to show it on top of them.
  ///
  /// [clipToBorder] forces the [LineChart] to draw lines inside the chart bounding box.
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

  /// Lerps a [ScatterChartData] based on [t] value, check [Tween.lerp].
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

/// Defines information about a spot in the [ScatterChart]
class ScatterSpot extends FlSpot {

  /// Determines show or hide the spot.
  final bool show;

  /// Determines size of the spot.
  final double radius;

  /// Determines color of the spot.
  Color color;

  /// You can change [show] value to show or hide the spot,
  /// [x], and [y] defines the location of spot in the [ScatterChart],
  /// [radius] defines the size of spot, and [color] defines the color of it.
  ScatterSpot(
    double x,
    double y, {
    this.show = true,
    this.radius = 6,
    this.color,
  }) : super(x, y) {
    color ??= Colors.primaries[((x * y) % Colors.primaries.length).toInt()];
  }

  /// Lerps a [ScatterSpot] based on [t] value, check [Tween.lerp].
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

/// Holds data to handle touch events, and touch responses in the [ScatterChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [ScatterTouchResponse].
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

  /// You can disable or enable the touch system using [enabled] flag,
  /// if [handleBuiltInTouches] is true, [ScatterChart] shows a tooltip popup on top of the spots if
  /// touch occurs (or you can show it manually using, [ScatterChartData.showingTooltipIndicators])
  /// You can customize this tooltip using [touchTooltipData],
  ///
  /// If you need to have a distance threshold for handling touches, use [touchSpotThreshold].
  ///
  /// You can listen to touch events using [touchCallback],
  /// It gives you a [ScatterTouchResponse] that contains some
  /// useful information about happened touch.
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

/// Holds information about touch response in the [ScatterChart].
///
/// You can override [ScatterTouchData.touchCallback] to handle touch events,
/// it gives you a [ScatterTouchResponse] and you can do whatever you want.
class ScatterTouchResponse extends BaseTouchResponse {
  final ScatterSpot touchedSpot;
  final int touchedSpotIndex;

  /// If touch happens, [ScatterChart] processes it internally and
  /// passes out a [ScatterTouchResponse], it gives you information about the touched spot.
  ///
  /// [touchedSpot], and [touchedSpotIndex] tells you
  /// in which spot (of [ScatterChartData.scatterSpots]) touch happened.
  ///
  /// [touchInput] is the type of happened touch.
  ScatterTouchResponse(
    FlTouchInput touchInput,
    this.touchedSpot,
    this.touchedSpotIndex,
  ) : super(touchInput);
}

/// Holds representation data for showing tooltip popup on top of spots.
class ScatterTouchTooltipData {

  /// The tooltip background color.
  final Color tooltipBgColor;

  /// Sets a rounded radius for the tooltip.
  final double tooltipRoundedRadius;

  /// Applies a padding for showing contents inside the tooltip.
  final EdgeInsets tooltipPadding;

  /// Restricts the tooltip's width.
  final double maxContentWidth;

  /// Retrieves data for showing content inside the tooltip.
  final GetScatterTooltipItems getTooltipItems;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// if [ScatterTouchData.handleBuiltInTouches] is true,
  /// [ScatterChart] shows a tooltip popup on top of spots automatically when touch happens,
  /// otherwise you can show it manually using [ScatterChartData.showingTooltipIndicators].
  /// Tooltip shows on top of spots, with [tooltipBgColor] as a background color,
  /// and you can set corner radius using [tooltipRoundedRadius].
  /// If you want to have a padding inside the tooltip, fill [tooltipPadding].
  /// Content of the tooltip will provide using [getTooltipItems] callback, you can override it
  /// and pass your custom data to show in the tooltip.
  /// You can restrict the tooltip's width using [maxContentWidth].
  /// Sometimes, [ScatterChart] shows the tooltip outside of the chart,
  /// you can set [fitInsideHorizontally] true to force it to shift inside the chart horizontally,
  /// also you can set [fitInsideVertically] true to force it to shift inside the chart vertically.
  const ScatterTouchTooltipData({
    this.tooltipBgColor = Colors.white,
    this.tooltipRoundedRadius = 4,
    this.tooltipPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.maxContentWidth = 120,
    this.getTooltipItems = defaultScatterTooltipItem,
    this.fitInsideHorizontally = false,
    this.fitInsideVertically = false,
  }) : super();
}

/// Provides a [ScatterTooltipItem] for showing content inside the [ScatterTouchTooltipData].
///
/// You can override [ScatterTouchTooltipData.getTooltipItems], it gives you
/// [touchedSpot] that touch happened on,
/// then you should and pass your custom [ScatterTooltipItem]
/// to show it inside the tooltip popup.
typedef GetScatterTooltipItems = ScatterTooltipItem Function(ScatterSpot touchedSpot);

/// Default implementation for [ScatterTouchTooltipData.getTooltipItems].
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

/// Holds data of showing each item in the tooltip popup.
class ScatterTooltipItem {

  /// Showing text.
  final String text;

  /// Style of showing text.
  final TextStyle textStyle;

  /// Defines bottom space from spot.
  final double bottomMargin;

  /// Shows a [text] with [textStyle] in the tooltip popup,
  /// [bottomMargin] is the bottom space from spot.
  ScatterTooltipItem(
    this.text,
    this.textStyle,
    this.bottomMargin,
  );
}

/// It lerps a [ScatterChartData] to another [ScatterChartData] (handles animation for updating values)
class ScatterChartDataTween extends Tween<ScatterChartData> {
  ScatterChartDataTween({ScatterChartData begin, ScatterChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [ScatterChartData] based on [t] value, check [Tween.lerp].
  @override
  ScatterChartData lerp(double t) {
    return begin.lerp(begin, end, t);
  }
}
