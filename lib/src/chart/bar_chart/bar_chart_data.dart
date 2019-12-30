import 'dart:async';
import 'dart:ui';

import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

/// This class is responsible to holds data to draw Bar Chart
/// [barGroups] holds list of bar groups to show together,
/// [groupsSpace] space between groups, it applies only when the [alignment] is [Alignment.center],
/// [axisTitleData] to show a description of each axis
/// [alignment] is the alignment of showing groups,
/// [titlesData] holds data about drawing left and bottom titles.
class BarChartData extends AxisChartData {
  final List<BarChartGroupData> barGroups;
  final double groupsSpace;
  final BarChartAlignment alignment;
  final FlTitlesData titlesData;
  final BarTouchData barTouchData;

  BarChartData({
    this.barGroups = const [],
    this.groupsSpace = 16,
    this.alignment = BarChartAlignment.spaceBetween,
    this.titlesData = const FlTitlesData(),
    this.barTouchData = const BarTouchData(),
    FlGridData gridData = const FlGridData(
      show: false,
    ),
    FlBorderData borderData,
    FlAxisTitleData axisTitleData = const FlAxisTitleData(),
    double maxY,
    Color backgroundColor,
  }) : super(
          gridData: gridData,
          borderData: borderData,
          axisTitleData: axisTitleData,
          backgroundColor: backgroundColor,
          touchData: barTouchData,
        ) {
    initSuperMinMaxValues(maxY);
  }

  /// we have to tell [AxisChartData] how much is our
  /// minX, maxX, minY, maxY, values.
  /// here we get them in our constructor, but if each of them was null,
  /// we calculate it with the barGroups, and barRods data.
  void initSuperMinMaxValues(
    double maxY,
  ) {
    for (int i = 0; i < barGroups.length; i++) {
      final BarChartGroupData barData = barGroups[i];
      if (barData.barRods == null || barData.barRods.isEmpty) {
        throw Exception('barRods could not be null or empty');
      }
    }

    if (barGroups.isNotEmpty) {
      var canModifyMaxY = false;
      if (maxY == null) {
        maxY = barGroups[0].barRods[0].y;
        canModifyMaxY = true;
      }

      for (int i = 0; i < barGroups.length; i++) {
        final BarChartGroupData barGroup = barGroups[i];
        for (int j = 0; j < barGroup.barRods.length; j++) {
          final BarChartRodData rod = barGroup.barRods[j];
          if (canModifyMaxY && rod.y > maxY) {
            maxY = rod.y;
          }

          if (canModifyMaxY &&
              rod.backDrawRodData.show &&
              rod.backDrawRodData.y != null &&
              rod.backDrawRodData.y > maxY) {
            maxY = rod.backDrawRodData.y;
          }
        }
      }
    }

    super.minX = 0;
    super.maxX = 1;
    super.minY = 0;
    super.maxY = maxY ?? 1;
  }

  BarChartData copyWith({
    List<BarChartGroupData> barGroups,
    double groupsSpace,
    BarChartAlignment alignment,
    FlTitlesData titlesData,
    FlAxisTitleData axisTitleData,
    BarTouchData barTouchData,
    FlGridData gridData,
    FlBorderData borderData,
    double maxY,
    Color backgroundColor,
  }) {
    return BarChartData(
      barGroups: barGroups ?? this.barGroups,
      groupsSpace: groupsSpace ?? this.groupsSpace,
      alignment: alignment ?? this.alignment,
      titlesData: titlesData ?? this.titlesData,
      axisTitleData: axisTitleData ?? this.axisTitleData,
      barTouchData: barTouchData ?? this.barTouchData,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      maxY: maxY ?? this.maxY,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is BarChartData && b is BarChartData && t != null) {
      return BarChartData(
        barGroups: lerpBarChartGroupDataList(a.barGroups, b.barGroups, t),
        groupsSpace: lerpDouble(a.groupsSpace, b.groupsSpace, t),
        alignment: b.alignment,
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        axisTitleData: FlAxisTitleData.lerp(a.axisTitleData, b.axisTitleData, t),
        barTouchData: b.barTouchData,
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );
    } else {
      throw Exception('Illegal State');
    }
  }
}

/// this is mimic of [MainAxisAlignment] to aligning the groups horizontally
enum BarChartAlignment {
  start,
  end,
  center,
  spaceEvenly,
  spaceAround,
  spaceBetween,
}

/***** BarChartGroupData *****/

/// holds list of vertical bars together as a group,
/// we call the vertical bars Rod, see [BarChartRodData],
/// if your chart doesn't have some bar lines grouped together,
/// you should use it with single child list.
class BarChartGroupData {
  @required
  final int x;
  final List<BarChartRodData> barRods;
  final double barsSpace;
  final List<int> showingTooltipIndicators;

  /// the [x] is the whole group x,
  /// [barRods] are our vertical bar lines, that each of them contains a y value,
  /// to draw them independently by y value together.
  /// [barsSpace] is the space between the bar lines inside group
  /// [showingTooltipIndicators] indexes of barRods to show the tooltip on top of them
  const BarChartGroupData({
    @required this.x,
    this.barRods = const [],
    this.barsSpace = 2,
    this.showingTooltipIndicators = const [],
  }) : assert(x != null);

  /// calculates the whole width of our group,
  /// by adding all rod's width and group space * rods count.
  double get width {
    if (barRods.isEmpty) {
      return 0;
    }

    final double sumWidth =
        barRods.map((rodData) => rodData.width).reduce((first, second) => first + second);
    final double spaces = (barRods.length - 1) * barsSpace;

    return sumWidth + spaces;
  }

  BarChartGroupData copyWith({
    int x,
    List<BarChartRodData> barRods,
    double barsSpace,
    List<int> showingTooltipIndicators,
  }) {
    return BarChartGroupData(
      x: x ?? this.x,
      barRods: barRods ?? this.barRods,
      barsSpace: barsSpace ?? this.barsSpace,
      showingTooltipIndicators: showingTooltipIndicators ?? this.showingTooltipIndicators,
    );
  }

  static BarChartGroupData lerp(BarChartGroupData a, BarChartGroupData b, double t) {
    return BarChartGroupData(
      x: (a.x + (b.x - a.x) * t).round(),
      barRods: lerpBarChartRodDataList(a.barRods, b.barRods, t),
      barsSpace: lerpDouble(a.barsSpace, b.barsSpace, t),
      showingTooltipIndicators: lerpIntList(a.showingTooltipIndicators, b.showingTooltipIndicators, t),
    );
  }
}

/***** BarChartRodData *****/

/// This class holds data to show a single rod,
/// rod is a vertical bar line,
class BarChartRodData {
  final double y;
  final Color color;
  final double width;
  final bool isRound;
  final BackgroundBarChartRodData backDrawRodData;
  final List<BarChartRodStackItem> rodStackItem;

  const BarChartRodData({
    this.y,
    this.color = Colors.blueAccent,
    this.width = 8,
    this.isRound = true,
    this.backDrawRodData = const BackgroundBarChartRodData(),
    this.rodStackItem = const [],
  });

  BarChartRodData copyWith({
    double y,
    Color color,
    double width,
    bool isRound,
    BackgroundBarChartRodData backDrawRodData,
    List<BarChartRodStackItem> rodStackItem,
  }) {
    return BarChartRodData(
      y: y ?? this.y,
      color: color ?? this.color,
      width: width ?? this.width,
      isRound: isRound ?? this.isRound,
      backDrawRodData: backDrawRodData ?? this.backDrawRodData,
      rodStackItem: rodStackItem ?? this.rodStackItem,
    );
  }

  static BarChartRodData lerp(BarChartRodData a, BarChartRodData b, double t) {
    return BarChartRodData(
      color: Color.lerp(a.color, b.color, t),
      width: lerpDouble(a.width, b.width, t),
      isRound: b.isRound,
      y: lerpDouble(a.y, b.y, t),
      backDrawRodData: BackgroundBarChartRodData.lerp(a.backDrawRodData, b.backDrawRodData, t),
      rodStackItem: lerpBarChartRodStackList(a.rodStackItem, b.rodStackItem, t),
    );
  }
}

/// each section of rod stack, it will draw the section from [fromY] to [toY] using [color].
class BarChartRodStackItem {
  final double fromY;
  final double toY;
  final Color color;

  const BarChartRodStackItem(this.fromY, this.toY, this.color);

  BarChartRodStackItem copyWith({
    double fromY,
    double toY,
    Color color,
  }) {
    return BarChartRodStackItem(
      fromY ?? this.fromY,
      toY ?? this.toY,
      color ?? this.color,
    );
  }

  static BarChartRodStackItem lerp(BarChartRodStackItem a, BarChartRodStackItem b, double t) {
    return BarChartRodStackItem(
      lerpDouble(a.fromY, b.fromY, t),
      lerpDouble(a.toY, b.toY, t),
      Color.lerp(a.color, b.color, t),
    );
  }
}

/// maybe in your design you should draw a behind bar
/// to represent the max value of the bar height [y]
/// by default it is not showing.
/// if you want to use it set [BackgroundBarChartRodData.show] true.
class BackgroundBarChartRodData {
  final bool show;
  final double y;
  final Color color;

  const BackgroundBarChartRodData({
    this.y = 8,
    this.show = false,
    this.color = Colors.blueGrey,
  });

  static BackgroundBarChartRodData lerp(
      BackgroundBarChartRodData a, BackgroundBarChartRodData b, double t) {
    return BackgroundBarChartRodData(
      y: lerpDouble(a.y, b.y, t),
      color: Color.lerp(a.color, b.color, t),
      show: b.show,
    );
  }
}

/// holds data for handling touch events on the [BarChart]
class BarTouchData extends FlTouchData {
  /// show a tooltip on touched spots
  final BarTouchTooltipData touchTooltipData;

  /// we find the nearest bar on touched position based on this threshold
  final EdgeInsets touchExtraThreshold;

  /// allow to touch the bar back draw
  final bool allowTouchBarBackDraw;

  /// set this true if you want the built in touch handling
  /// (show a tooltip bubble and an indicator on touched spots)
  final bool handleBuiltInTouches;

  final Function(BarTouchResponse) touchCallback;

  const BarTouchData({
    bool enabled = true,
    bool enableNormalTouch = true,
    this.touchTooltipData = const BarTouchTooltipData(),
    this.touchExtraThreshold = const EdgeInsets.all(4),
    this.allowTouchBarBackDraw = false,
    this.handleBuiltInTouches = true,
    this.touchCallback,
  }) : super(enabled, enableNormalTouch);

  BarTouchData copyWith({
    bool enabled,
    bool enableNormalTouch,
    BarTouchTooltipData touchTooltipData,
    EdgeInsets touchExtraThreshold,
    bool allowTouchBarBackDraw,
    bool handleBuiltInTouches,
    Function(BarTouchResponse) touchCallback,
  }) {
    return BarTouchData(
      enabled: enabled ?? this.enabled,
      enableNormalTouch: enableNormalTouch ?? this.enableNormalTouch,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      touchExtraThreshold: touchExtraThreshold ?? this.touchExtraThreshold,
      allowTouchBarBackDraw: allowTouchBarBackDraw ?? this.allowTouchBarBackDraw,
      handleBuiltInTouches: handleBuiltInTouches ?? this.handleBuiltInTouches,
      touchCallback: touchCallback ?? this.touchCallback,
    );
  }

}


/// Holds information for showing tooltip on axis based charts
/// when a touch event happened
class BarTouchTooltipData {
  final Color tooltipBgColor;
  final double tooltipRoundedRadius;
  final EdgeInsets tooltipPadding;
  final double tooltipBottomMargin;
  final double maxContentWidth;
  final GetBarTooltipItem getTooltipItem;

  const BarTouchTooltipData({
    this.tooltipBgColor = Colors.white,
    this.tooltipRoundedRadius = 4,
    this.tooltipPadding =
    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.tooltipBottomMargin = 16,
    this.maxContentWidth = 120,
    this.getTooltipItem = defaultBarTooltipItem,
  }) : super();
}

/// show each TooltipItem as a row on the tooltip window,
/// return null if you don't want to show each item
/// if user touched the chart, we show a tooltip window on the most top [TouchSpot],
/// here we get the [BarTooltipItem] from the given [TouchedSpot].
typedef GetBarTooltipItem = BarTooltipItem Function(
  BarChartGroupData group, int groupIndex,
  BarChartRodData rod, int rodIndex,
  );

BarTooltipItem defaultBarTooltipItem(
  BarChartGroupData group, int groupIndex,
  BarChartRodData rod, int rodIndex,
  ) {
  final TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return BarTooltipItem(rod.y.toString(), textStyle);
}

/// holds data of showing each item in the tooltip window
class BarTooltipItem {
  final String text;
  final TextStyle textStyle;

  BarTooltipItem(this.text, this.textStyle);
}

/// holds the data of touch response on the [BarChart]
/// used in the [BarTouchData] in a [StreamSink]
class BarTouchResponse extends BaseTouchResponse {
  /// touch happened on this [BarTouchedSpot]
  final BarTouchedSpot spot;

  BarTouchResponse(
    this.spot,
    FlTouchInput touchInput,
  ) : super(touchInput);
}

/// holds the [BarChartGroupData] and the [BarChartRodData]
/// of the touched spot
class BarTouchedSpot extends TouchedSpot {
  final BarChartGroupData touchedBarGroup;
  final int touchedBarGroupIndex;

  final BarChartRodData touchedRodData;
  final int touchedRodDataIndex;

  BarTouchedSpot(
    this.touchedBarGroup,
    this.touchedBarGroupIndex,
    this.touchedRodData,
    this.touchedRodDataIndex,
    FlSpot spot,
    Offset offset,
  ) : super(spot, offset);

  @override
  Color getColor() {
    return Colors.black;
  }
}

class BarChartDataTween extends Tween<BarChartData> {

  BarChartDataTween({BarChartData begin, BarChartData end}) : super(begin: begin, end: end);

  @override
  BarChartData lerp(double t) => begin.lerp(begin, end, t);

}