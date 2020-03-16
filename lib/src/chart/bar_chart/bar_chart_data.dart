import 'dart:ui';

import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// [BarChart] needs this class to render itself.
///
/// It holds data needed to draw a bar chart,
/// including bar lines, colors, spaces, touches, ...
class BarChartData extends AxisChartData {

  /// [BarChart] draws [barGroups] that each of them contains a list of [BarChartRodData].
  final List<BarChartGroupData> barGroups;

  /// Apply space between the [barGroups].
  final double groupsSpace;

  /// Arrange the [barGroups], see [BarChartAlignment].
  final BarChartAlignment alignment;

  /// Titles on left, top, right, bottom axis for each number.
  final FlTitlesData titlesData;

  /// Handles touch behaviors and responses.
  final BarTouchData barTouchData;

  /// [BarChart] draws some [barGroups] and aligns them using [alignment],
  /// if [alignment] is [BarChartAlignment.center], you can define [groupsSpace]
  /// to apply space between them.
  ///
  /// It draws some titles on left, top, right, bottom sides per each axis number,
  /// you can modify [titlesData] to have your custom titles,
  /// also you can define the axis title (one text per axis) for each side
  /// using [axisTitleData], you can restrict the y axis using [maxY] value.
  ///
  /// It draws a color as a background behind everything you can set it using [backgroundColor],
  /// then a grid over it, you can customize it using [gridData],
  /// and it draws 4 borders around your chart, you can customize it using [borderData].
  ///
  /// You can annotate some regions with a highlight color using [rangeAnnotations].
  ///
  /// You can modify [barTouchData] to customize touch behaviors and responses.
  BarChartData({
    this.barGroups = const [],
    this.groupsSpace = 16,
    this.alignment = BarChartAlignment.spaceBetween,
    this.titlesData = const FlTitlesData(),
    this.barTouchData = const BarTouchData(),
    FlAxisTitleData axisTitleData = const FlAxisTitleData(),
    double maxY,
    FlGridData gridData = const FlGridData(
      show: false,
    ),
    FlBorderData borderData,
    RangeAnnotations rangeAnnotations = const RangeAnnotations(),
    Color backgroundColor,
  }) : super(
    axisTitleData: axisTitleData,
          gridData: gridData,
          borderData: borderData,
          rangeAnnotations: rangeAnnotations,
          backgroundColor: backgroundColor,
          touchData: barTouchData,
        ) {
    initSuperMinMaxValues(maxY);
  }

  /// fills [minX], [maxX], [minY], [maxY] if they are null,
  /// based on the provided [barGroups].
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
    RangeAnnotations rangeAnnotations,
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
      rangeAnnotations: rangeAnnotations ?? this.rangeAnnotations,
      barTouchData: barTouchData ?? this.barTouchData,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      maxY: maxY ?? this.maxY,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Lerps a [BaseChartData] based on [t] value, check [Tween.lerp].
  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is BarChartData && b is BarChartData && t != null) {
      return BarChartData(
        barGroups: lerpBarChartGroupDataList(a.barGroups, b.barGroups, t),
        groupsSpace: lerpDouble(a.groupsSpace, b.groupsSpace, t),
        alignment: b.alignment,
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        axisTitleData: FlAxisTitleData.lerp(a.axisTitleData, b.axisTitleData, t),
        rangeAnnotations: RangeAnnotations.lerp(a.rangeAnnotations, b.rangeAnnotations, t),
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

/// defines arrangement of [barGroups], check [MainAxisAlignment] for more details.
enum BarChartAlignment {
  start,
  end,
  center,
  spaceEvenly,
  spaceAround,
  spaceBetween,
}

/// Represents a group of rods (or bars) inside the [BarChart].
///
/// in the [BarChart] we have some rods, they can be grouped or not,
/// if you want to have grouped bars, simply put them in each group,
/// otherwise just pass one of them in each group.
class BarChartGroupData {

  /// defines the group's value among the x axis (simply set it incrementally).
  @required
  final int x;

  /// [BarChart] renders [barRods] that represents a rod (or a bar) in the bar chart.
  final List<BarChartRodData> barRods;

  /// [BarChart] applies [barsSpace] between [barRods].
  final double barsSpace;

  /// you can show some tooltipIndicators (a popup with an information)
  /// on top of each [BarChartRodData] using [showingTooltipIndicators],
  /// just put indices you want to show it on top of them.
  final List<int> showingTooltipIndicators;

  /// [BarChart] renders groups, and arrange them using [alignment],
  /// [x] value defines the group's value in the x axis (set them incrementally).
  /// it renders a list of [BarChartRodData] that represents a rod (or a bar) in the bar chart,
  /// and applies [barsSpace] between them.
  ///
  /// you can show some tooltipIndicators (a popup with an information)
  /// on top of each [BarChartRodData] using [showingTooltipIndicators],
  /// just put indices you want to show it on top of them.
  const BarChartGroupData({
    @required this.x,
    this.barRods = const [],
    this.barsSpace = 2,
    this.showingTooltipIndicators = const [],
  }) : assert(x != null);

  /// width of the group (sum of all [BarChartRodData]'s width and spaces)
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

  /// Lerps a [BarChartGroupData] based on [t] value, check [Tween.lerp].
  static BarChartGroupData lerp(BarChartGroupData a, BarChartGroupData b, double t) {
    return BarChartGroupData(
      x: (a.x + (b.x - a.x) * t).round(),
      barRods: lerpBarChartRodDataList(a.barRods, b.barRods, t),
      barsSpace: lerpDouble(a.barsSpace, b.barsSpace, t),
      showingTooltipIndicators:
          lerpIntList(a.showingTooltipIndicators, b.showingTooltipIndicators, t),
    );
  }
}

/// Holds data about rendering each rod (or bar) in the [BarChart].
class BarChartRodData {

  /// [BarChart] renders rods vertically from zero to [y].
  final double y;

  /// [BarChart] renders each rods using this [color].
  final Color color;

  /// [BarChart] renders each rods with this value.
  final double width;

  /// If you want to have a rounded rod, set this value.
  final BorderRadius borderRadius;

  /// If you want to have a bar drawn in rear of this rod, use [backDrawRodData],
  /// it uses to have a bar with a passive color in rear of the rod,
  /// for example you can use it as the maximum value place holder.
  final BackgroundBarChartRodData backDrawRodData;

  /// If you are a fan of stacked charts (If you don't know what is it, google it),
  /// you can fill up the [rodStackItem] to have a Stacked Chart.
  final List<BarChartRodStackItem> rodStackItem;

  /// [BarChart] renders rods vertically from zero to [y],
  /// and the x is equivalent to the [BarChartGroupData.x] value.
  ///
  /// It renders each rod using [color], [width], and [borderRadius] for rounding corners.
  ///
  /// If you want to have a bar drawn in rear of this rod, use [backDrawRodData],
  /// it uses to have a bar with a passive color in rear of the rod,
  /// for example you can use it as the maximum value place holder.
  ///
  /// If you are a fan of stacked charts (If you don't know what is it, google it),
  /// you can fill up the [rodStackItem] to have a Stacked Chart.
  /// for example if you want to have a Stacked Chart with three colors:
  /// ```
  /// BarChartRodData(
  ///   y: 9,
  ///   color: Colors.grey,
  ///   rodStackItem: [
  ///     BarChartRodStackItem(0, 3, Colors.red),
  ///     BarChartRodStackItem(3, 6, Colors.green),
  ///     BarChartRodStackItem(6, 9, Colors.blue),
  ///   ]
  /// )
  /// ```
  BarChartRodData({
    this.y,
    this.color = Colors.blueAccent,
    this.width = 8,
    BorderRadius borderRadius,
    this.backDrawRodData = const BackgroundBarChartRodData(),
    this.rodStackItem = const [],
  }) :borderRadius = normalizeBorderRadius(borderRadius, width);

  BarChartRodData copyWith({
    double y,
    Color color,
    double width,
    Radius borderRadius,
    BackgroundBarChartRodData backDrawRodData,
    List<BarChartRodStackItem> rodStackItem,
  }) {
    return BarChartRodData(
      y: y ?? this.y,
      color: color ?? this.color,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      backDrawRodData: backDrawRodData ?? this.backDrawRodData,
      rodStackItem: rodStackItem ?? this.rodStackItem,
    );
  }

  /// Lerps a [BarChartRodData] based on [t] value, check [Tween.lerp].
  static BarChartRodData lerp(BarChartRodData a, BarChartRodData b, double t) {
    return BarChartRodData(
      color: Color.lerp(a.color, b.color, t),
      width: lerpDouble(a.width, b.width, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      y: lerpDouble(a.y, b.y, t),
      backDrawRodData: BackgroundBarChartRodData.lerp(a.backDrawRodData, b.backDrawRodData, t),
      rodStackItem: lerpBarChartRodStackList(a.rodStackItem, b.rodStackItem, t),
    );
  }
}

/// A colored section of Stacked Chart rod item
///
/// Each [BarChartRodData] can have a list of [BarChartRodStackItem] (with different colors
/// and position) to represent a Stacked Chart rod,
class BarChartRodStackItem {

  /// Renders a Stacked Chart section from [fromY]
  final double fromY;

  /// Renders a Stacked Chart section to [toY]
  final double toY;

  /// Renders a Stacked Chart section with [color]
  final Color color;

  /// Renders a section of Stacked Chart from [fromY] to [toY] with [color]
  /// for example if you want to have a Stacked Chart with three colors:
  /// ```
  /// BarChartRodData(
  ///   y: 9,
  ///   color: Colors.grey,
  ///   rodStackItem: [
  ///     BarChartRodStackItem(0, 3, Colors.red),
  ///     BarChartRodStackItem(3, 6, Colors.green),
  ///     BarChartRodStackItem(6, 9, Colors.blue),
  ///   ]
  /// )
  /// ```
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

  /// Lerps a [BarChartRodStackItem] based on [t] value, check [Tween.lerp].
  static BarChartRodStackItem lerp(BarChartRodStackItem a, BarChartRodStackItem b, double t) {
    return BarChartRodStackItem(
      lerpDouble(a.fromY, b.fromY, t),
      lerpDouble(a.toY, b.toY, t),
      Color.lerp(a.color, b.color, t),
    );
  }
}

/// Holds values to draw a rod in rear of the main rod.
///
/// If you want to have a bar drawn in rear of the main rod, use [BarChartRodData.backDrawRodData],
/// it uses to have a bar with a passive color in rear of the rod,
/// for example you can use it as the maximum value place holder in rear of your rod.
class BackgroundBarChartRodData {

  /// Determines to show or hide this
  final bool show;

  /// [y] is the height of this rod
  final double y;

  /// it will be rendered with filled [color]
  final Color color;

  /// It will be rendered in rear of the main rod,
  /// with [y] as the height, and [color] as the fill color,
  /// you prevent to show it, using [show] property.
  const BackgroundBarChartRodData({
    this.y = 8,
    this.show = false,
    this.color = Colors.blueGrey,
  });

  /// Lerps a [BackgroundBarChartRodData] based on [t] value, check [Tween.lerp].
  static BackgroundBarChartRodData lerp(
      BackgroundBarChartRodData a, BackgroundBarChartRodData b, double t) {
    return BackgroundBarChartRodData(
      y: lerpDouble(a.y, b.y, t),
      color: Color.lerp(a.color, b.color, t),
      show: b.show,
    );
  }
}

/// Holds data to handle touch events, and touch responses in the [BarChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [BarTouchResponse].
class BarTouchData extends FlTouchData {

  /// Configs of how touch tooltip popup.
  final BarTouchTooltipData touchTooltipData;

  /// Distance threshold to handle the touch event.
  final EdgeInsets touchExtraThreshold;

  /// Determines to handle touches on the back draw bar.
  final bool allowTouchBarBackDraw;

  /// Determines to handle default built-in touch responses,
  /// [BarTouchResponse] shows a tooltip popup above the touched spot.
  final bool handleBuiltInTouches;

  /// Informs the touchResponses
  final Function(BarTouchResponse) touchCallback;

  /// You can disable or enable the touch system using [enabled] flag,
  /// if [handleBuiltInTouches] is true, [BarChart] shows a tooltip popup on top of the bars if
  /// touch occurs (or you can show it manually using, [BarChartGroupData.showingTooltipIndicators]),
  /// You can customize this tooltip using [touchTooltipData].
  /// If you need to have a distance threshold for handling touches, use [touchExtraThreshold].
  /// If [allowTouchBarBackDraw] sets to true, touches will work
  /// on [BarChartRodData.backDrawRodData] too (by default it only works on the main rods).
  ///
  /// You can listen to touch events using [touchCallback],
  /// It gives you a [BarTouchResponse] that contains some
  /// useful information about happened touch.
  const BarTouchData({
    bool enabled = true,
    this.touchTooltipData = const BarTouchTooltipData(),
    this.touchExtraThreshold = const EdgeInsets.all(4),
    this.allowTouchBarBackDraw = false,
    this.handleBuiltInTouches = true,
    this.touchCallback,
  }) : super(enabled);

  BarTouchData copyWith({
    bool enabled,
    BarTouchTooltipData touchTooltipData,
    EdgeInsets touchExtraThreshold,
    bool allowTouchBarBackDraw,
    bool handleBuiltInTouches,
    Function(BarTouchResponse) touchCallback,
  }) {
    return BarTouchData(
      enabled: enabled ?? this.enabled,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      touchExtraThreshold: touchExtraThreshold ?? this.touchExtraThreshold,
      allowTouchBarBackDraw: allowTouchBarBackDraw ?? this.allowTouchBarBackDraw,
      handleBuiltInTouches: handleBuiltInTouches ?? this.handleBuiltInTouches,
      touchCallback: touchCallback ?? this.touchCallback,
    );
  }
}

/// Holds representation data for showing tooltip popup on top of rods.
class BarTouchTooltipData {

  /// The tooltip background color.
  final Color tooltipBgColor;

  /// Sets a rounded radius for the tooltip.
  final double tooltipRoundedRadius;

  /// Applies a padding for showing contents inside the tooltip.
  final EdgeInsets tooltipPadding;

  /// Applies a bottom margin for showing tooltip on top of rods.
  final double tooltipBottomMargin;

  /// Restricts the tooltip's width.
  final double maxContentWidth;

  /// Retrieves data for showing content inside the tooltip.
  final GetBarTooltipItem getTooltipItem;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// if [BarTouchData.handleBuiltInTouches] is true,
  /// [BarChart] shows a tooltip popup on top of rods automatically when touch happens,
  /// otherwise you can show it manually using [BarChartGroupData.showingTooltipIndicators].
  /// Tooltip shows on top of rods, with [tooltipBgColor] as a background color,
  /// and you can set corner radius using [tooltipRoundedRadius].
  /// If you want to have a padding inside the tooltip, fill [tooltipPadding],
  /// or If you want to have a bottom margin, set [tooltipBottomMargin].
  /// Content of the tooltip will provide using [getTooltipItem] callback, you can override it
  /// and pass your custom data to show in the tooltip.
  /// You can restrict the tooltip's width using [maxContentWidth].
  /// Sometimes, [BarChart] shows the tooltip outside of the chart,
  /// you can set [fitInsideHorizontally] true to force it to shift inside the chart horizontally,
  /// also you can set [fitInsideVertically] true to force it to shift inside the chart vertically.
  const BarTouchTooltipData({
    this.tooltipBgColor = Colors.white,
    this.tooltipRoundedRadius = 4,
    this.tooltipPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.tooltipBottomMargin = 16,
    this.maxContentWidth = 120,
    this.getTooltipItem = defaultBarTooltipItem,
    this.fitInsideHorizontally = false,
    this.fitInsideVertically = false,
  }) : super();
}

/// Provides a [BarTooltipItem] for showing content inside the [BarTouchTooltipData].
///
/// You can override [BarTouchTooltipData.getTooltipItem], it gives you
/// [group], [groupIndex], [rod], and [rodIndex] that touch happened on,
/// then you should and pass your custom [BarTooltipItem] to show inside the tooltip popup.
typedef GetBarTooltipItem = BarTooltipItem Function(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
);

/// Default implementation for [BarTouchTooltipData.getTooltipItem].
BarTooltipItem defaultBarTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
) {
  final TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return BarTooltipItem(rod.y.toString(), textStyle);
}

/// Holds data needed for showing custom tooltip content.
class BarTooltipItem {

  /// Text of the content.
  final String text;

  /// TextStyle of the showing content.
  final TextStyle textStyle;

  /// content of the tooltip, is a [text] String with a [textStyle].
  BarTooltipItem(this.text, this.textStyle);
}

/// Holds information about touch response in the [BarChart].
///
/// You can override [BarTouchData.touchCallback] to handle touch events,
/// it gives you a [BarTouchResponse] and you can do whatever you want.
class BarTouchResponse extends BaseTouchResponse {

  /// Gives information about the touched spot
  final BarTouchedSpot spot;

  /// If touch happens, [BarChart] processes it internally and passes out a BarTouchedSpot
  /// that contains a [spot], it gives you information about the touched spot.
  /// [touchInput] is the type of happened touch.
  BarTouchResponse(
    this.spot,
    FlTouchInput touchInput,
  ) : super(touchInput);
}

/// It gives you information about the touched spot.
class BarTouchedSpot extends TouchedSpot {
  final BarChartGroupData touchedBarGroup;
  final int touchedBarGroupIndex;

  final BarChartRodData touchedRodData;
  final int touchedRodDataIndex;

  /// When touch happens, a [BarTouchedSpot] returns as a output,
  /// it tells you where the touch happened.
  /// [touchedBarGroup], and [touchedBarGroupIndex] tells you in which group touch happened,
  /// [touchedRodData], and [touchedRodDataIndex] telss you in which rod touch happened.
  /// You can also have the touched x and y in the chart as a [FlSpot] using [spot] value,
  /// and you can have the local touch coordinates on the screen as a [Offset] using [offset] value.
  BarTouchedSpot(
    this.touchedBarGroup,
    this.touchedBarGroupIndex,
    this.touchedRodData,
    this.touchedRodDataIndex,
    FlSpot spot,
    Offset offset,
  ) : super(spot, offset);

}

/// It lerps a [BarChartData] to another [BarChartData] (handles animation for updating values)
class BarChartDataTween extends Tween<BarChartData> {
  BarChartDataTween({BarChartData begin, BarChartData end}) : super(begin: begin, end: end);

  /// Lerps a [BarChartData] based on [t] value, check [Tween.lerp].
  @override
  BarChartData lerp(double t) => begin.lerp(begin, end, t);

}
