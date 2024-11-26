// coverage:ignore-file
import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// [BarChart] needs this class to render itself.
///
/// It holds data needed to draw a bar chart,
/// including bar lines, colors, spaces, touches, ...
class BarChartData extends AxisChartData with EquatableMixin {
  /// [BarChart] draws some [barGroups] and aligns them using [alignment],
  /// if [alignment] is [BarChartAlignment.center], you can define [groupsSpace]
  /// to apply space between them.
  ///
  /// It draws some titles on left, top, right, bottom sides per each axis number,
  /// you can modify [titlesData] to have your custom titles,
  /// also you can define the axis title (one text per axis) for each side
  /// using [axisTitleData], you can restrict the y axis using [minY], and [maxY] values.
  ///
  /// It draws a color as a background behind everything you can set it using [backgroundColor],
  /// then a grid over it, you can customize it using [gridData],
  /// and it draws 4 borders around your chart, you can customize it using [borderData].
  ///
  /// You can annotate some regions with a highlight color using [rangeAnnotations].
  ///
  /// You can modify [barTouchData] to customize touch behaviors and responses.
  ///
  /// Horizontal lines are drawn with [extraLinesData]. Vertical lines will not be painted if received.
  /// Please see issue #1149 (https://github.com/imaNNeo/fl_chart/issues/1149) for vertical lines.
  BarChartData({
    List<BarChartGroupData>? barGroups,
    double? groupsSpace,
    BarChartAlignment? alignment,
    FlTitlesData? titlesData,
    BarTouchData? barTouchData,
    double? maxY,
    double? minY,
    super.baselineY,
    FlGridData? gridData,
    super.borderData,
    RangeAnnotations? rangeAnnotations,
    super.backgroundColor,
    ExtraLinesData? extraLinesData,
  })  : barGroups = barGroups ?? const [],
        groupsSpace = groupsSpace ?? 16,
        alignment = alignment ?? BarChartAlignment.spaceEvenly,
        barTouchData = barTouchData ?? BarTouchData(),
        super(
          titlesData: titlesData ??
              const FlTitlesData(
                topTitles: AxisTitles(),
              ),
          gridData: gridData ?? const FlGridData(),
          rangeAnnotations: rangeAnnotations ?? const RangeAnnotations(),
          touchData: barTouchData ?? BarTouchData(),
          extraLinesData: extraLinesData ?? const ExtraLinesData(),
          minX: 0,
          maxX: 1,
          maxY: maxY ?? double.nan,
          minY: minY ?? double.nan,
        );

  /// [BarChart] draws [barGroups] that each of them contains a list of [BarChartRodData].
  final List<BarChartGroupData> barGroups;

  /// Apply space between the [barGroups].
  final double groupsSpace;

  /// Arrange the [barGroups], see [BarChartAlignment].
  final BarChartAlignment alignment;

  /// Handles touch behaviors and responses.
  final BarTouchData barTouchData;

  /// Copies current [BarChartData] to a new [BarChartData],
  /// and replaces provided values.
  BarChartData copyWith({
    List<BarChartGroupData>? barGroups,
    double? groupsSpace,
    BarChartAlignment? alignment,
    FlTitlesData? titlesData,
    RangeAnnotations? rangeAnnotations,
    BarTouchData? barTouchData,
    FlGridData? gridData,
    FlBorderData? borderData,
    double? maxY,
    double? minY,
    double? baselineY,
    Color? backgroundColor,
    ExtraLinesData? extraLinesData,
  }) =>
      BarChartData(
        barGroups: barGroups ?? this.barGroups,
        groupsSpace: groupsSpace ?? this.groupsSpace,
        alignment: alignment ?? this.alignment,
        titlesData: titlesData ?? this.titlesData,
        rangeAnnotations: rangeAnnotations ?? this.rangeAnnotations,
        barTouchData: barTouchData ?? this.barTouchData,
        gridData: gridData ?? this.gridData,
        borderData: borderData ?? this.borderData,
        maxY: maxY ?? this.maxY,
        minY: minY ?? this.minY,
        baselineY: baselineY ?? this.baselineY,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        extraLinesData: extraLinesData ?? this.extraLinesData,
      );

  /// Lerps a [BaseChartData] based on [t] value, check [Tween.lerp].
  @override
  BarChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is BarChartData && b is BarChartData) {
      return BarChartData(
        barGroups: lerpBarChartGroupDataList(a.barGroups, b.barGroups, t),
        groupsSpace: lerpDouble(a.groupsSpace, b.groupsSpace, t),
        alignment: b.alignment,
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        rangeAnnotations:
            RangeAnnotations.lerp(a.rangeAnnotations, b.rangeAnnotations, t),
        barTouchData: b.barTouchData,
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        minY: lerpDouble(a.minY, b.minY, t),
        baselineY: lerpDouble(a.baselineY, b.baselineY, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        extraLinesData:
            ExtraLinesData.lerp(a.extraLinesData, b.extraLinesData, t),
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        barGroups,
        groupsSpace,
        alignment,
        titlesData,
        barTouchData,
        maxY,
        minY,
        baselineY,
        gridData,
        borderData,
        rangeAnnotations,
        backgroundColor,
        extraLinesData,
      ];
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
class BarChartGroupData with EquatableMixin {
  /// [BarChart] renders groups, and arrange them using [alignment],
  /// [x] value defines the group's value in the x axis (set them incrementally).
  /// it renders a list of [BarChartRodData] that represents a rod (or a bar) in the bar chart,
  /// and applies [barsSpace] between them.
  ///
  /// you can show some tooltipIndicators (a popup with an information)
  /// on top of each [BarChartRodData] using [showingTooltipIndicators],
  /// just put indices you want to show it on top of them.
  BarChartGroupData({
    required this.x,
    bool? groupVertically,
    List<BarChartRodData>? barRods,
    double? barsSpace,
    List<int>? showingTooltipIndicators,
  })  : groupVertically = groupVertically ?? false,
        barRods = barRods ?? const [],
        barsSpace = barsSpace ?? 2,
        showingTooltipIndicators = showingTooltipIndicators ?? const [];

  /// Order along the x axis in which titles, and titles only, will be shown.
  ///
  /// Note [x] does not reorder bars from [barRods]; instead, it gets the title
  /// in [x] position through [SideTitles.getTitlesWidget] function.
  @required
  final int x;

  /// If set true, it will show bars below/above each other.
  /// Otherwise, it will show bars beside each other.
  final bool groupVertically;

  /// [BarChart] renders [barRods] that represents a rod (or a bar) in the bar chart.
  final List<BarChartRodData> barRods;

  /// [BarChart] applies [barsSpace] between [barRods] if [groupVertically] is false.
  final double barsSpace;

  /// you can show some tooltipIndicators (a popup with an information)
  /// on top of each [BarChartRodData] using [showingTooltipIndicators],
  /// just put indices you want to show it on top of them.
  ///
  /// An important point is that you have to disable the default touch behaviour
  /// to show the tooltip manually, see [BarTouchData.handleBuiltInTouches].
  final List<int> showingTooltipIndicators;

  /// width of the group (sum of all [BarChartRodData]'s width and spaces)
  double get width {
    if (barRods.isEmpty) {
      return 0;
    }

    if (groupVertically) {
      return barRods.map((rodData) => rodData.width).reduce(max);
    } else {
      final sumWidth = barRods
          .map((rodData) => rodData.width)
          .reduce((first, second) => first + second);
      final spaces = (barRods.length - 1) * barsSpace;

      return sumWidth + spaces;
    }
  }

  /// Copies current [BarChartGroupData] to a new [BarChartGroupData],
  /// and replaces provided values.
  BarChartGroupData copyWith({
    int? x,
    bool? groupVertically,
    List<BarChartRodData>? barRods,
    double? barsSpace,
    List<int>? showingTooltipIndicators,
  }) =>
      BarChartGroupData(
        x: x ?? this.x,
        groupVertically: groupVertically ?? this.groupVertically,
        barRods: barRods ?? this.barRods,
        barsSpace: barsSpace ?? this.barsSpace,
        showingTooltipIndicators:
            showingTooltipIndicators ?? this.showingTooltipIndicators,
      );

  /// Lerps a [BarChartGroupData] based on [t] value, check [Tween.lerp].
  static BarChartGroupData lerp(
    BarChartGroupData a,
    BarChartGroupData b,
    double t,
  ) =>
      BarChartGroupData(
        x: (a.x + (b.x - a.x) * t).round(),
        groupVertically: b.groupVertically,
        barRods: lerpBarChartRodDataList(a.barRods, b.barRods, t),
        barsSpace: lerpDouble(a.barsSpace, b.barsSpace, t),
        showingTooltipIndicators: lerpIntList(
          a.showingTooltipIndicators,
          b.showingTooltipIndicators,
          t,
        ),
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        x,
        groupVertically,
        barRods,
        barsSpace,
        showingTooltipIndicators,
      ];
}

/// Holds data about rendering each rod (or bar) in the [BarChart].
class BarChartRodData with EquatableMixin {
  /// [BarChart] renders rods vertically from zero to [toY],
  /// and the x is equivalent to the [BarChartGroupData.x] value.
  ///
  /// It renders each rod using [color], [width], and [borderRadius] for rounding corners and also [borderSide] for stroke border.
  /// Optionally you can use [borderDashArray] if you want your borders to have dashed lines.
  ///
  /// This bar draws with provided [color] or [gradient].
  /// You must provide one of them.
  ///
  /// If you want to have a bar drawn in rear of this rod, use [backDrawRodData],
  /// it uses to have a bar with a passive color in rear of the rod,
  /// for example you can use it as the maximum value place holder.
  ///
  /// If you are a fan of stacked charts (If you don't know what is it, google it),
  /// you can fill up the [rodStackItems] to have a Stacked Chart.
  /// for example if you want to have a Stacked Chart with three colors:
  /// ```dart
  /// BarChartRodData(
  ///   y: 9,
  ///   color: Colors.grey,
  ///   rodStackItems: [
  ///     BarChartRodStackItem(0, 3, Colors.red),
  ///     BarChartRodStackItem(3, 6, Colors.green),
  ///     BarChartRodStackItem(6, 9, Colors.blue),
  ///   ]
  /// )
  /// ```
  BarChartRodData({
    double? fromY,
    required this.toY,
    Color? color,
    this.gradient,
    double? width,
    BorderRadius? borderRadius,
    this.borderDashArray,
    BorderSide? borderSide,
    BackgroundBarChartRodData? backDrawRodData,
    List<BarChartRodStackItem>? rodStackItems,
  })  : fromY = fromY ?? 0,
        color =
            color ?? ((color == null && gradient == null) ? Colors.cyan : null),
        width = width ?? 8,
        borderRadius = Utils().normalizeBorderRadius(borderRadius, width ?? 8),
        borderSide = Utils().normalizeBorderSide(borderSide, width ?? 8),
        backDrawRodData = backDrawRodData ?? BackgroundBarChartRodData(),
        rodStackItems = rodStackItems ?? const [];

  /// [BarChart] renders rods vertically from [fromY].
  final double fromY;

  /// [BarChart] renders rods vertically from [fromY] to [toY].
  final double toY;

  /// If provided, this [BarChartRodData] draws with this [color]
  /// Otherwise we use  [gradient] to draw the background.
  /// It throws an exception if you provide both [color] and [gradient]
  final Color? color;

  /// If provided, this [BarChartRodData] draws with this [gradient].
  /// Otherwise we use [color] to draw the background.
  /// It throws an exception if you provide both [color] and [gradient]
  final Gradient? gradient;

  /// [BarChart] renders each rods with this value.
  final double width;

  /// If you want to have a rounded rod, set this value.
  final BorderRadius? borderRadius;

  /// If you want to have dashed border, set this value.
  final List<int>? borderDashArray;

  /// If you want to have a border for rod, set this value.
  final BorderSide borderSide;

  /// If you want to have a bar drawn in rear of this rod, use [backDrawRodData],
  /// it uses to have a bar with a passive color in rear of the rod,
  /// for example you can use it as the maximum value place holder.
  final BackgroundBarChartRodData backDrawRodData;

  /// If you are a fan of stacked charts (If you don't know what is it, google it),
  /// you can fill up the [rodStackItems] to have a Stacked Chart.
  final List<BarChartRodStackItem> rodStackItems;

  /// Determines the upward or downward direction
  bool isUpward() => toY >= fromY;

  /// Copies current [BarChartRodData] to a new [BarChartRodData],
  /// and replaces provided values.
  BarChartRodData copyWith({
    double? fromY,
    double? toY,
    Color? color,
    Gradient? gradient,
    double? width,
    BorderRadius? borderRadius,
    List<int>? dashArray,
    BorderSide? borderSide,
    BackgroundBarChartRodData? backDrawRodData,
    List<BarChartRodStackItem>? rodStackItems,
  }) =>
      BarChartRodData(
        fromY: fromY ?? this.fromY,
        toY: toY ?? this.toY,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
        width: width ?? this.width,
        borderRadius: borderRadius ?? this.borderRadius,
        borderDashArray: borderDashArray,
        borderSide: borderSide ?? this.borderSide,
        backDrawRodData: backDrawRodData ?? this.backDrawRodData,
        rodStackItems: rodStackItems ?? this.rodStackItems,
      );

  /// Lerps a [BarChartRodData] based on [t] value, check [Tween.lerp].
  static BarChartRodData lerp(BarChartRodData a, BarChartRodData b, double t) =>
      BarChartRodData(
        // ignore: invalid_use_of_protected_member
        gradient: a.gradient?.lerpTo(b.gradient, t),
        color: Color.lerp(a.color, b.color, t),
        width: lerpDouble(a.width, b.width, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
        borderDashArray: lerpIntList(a.borderDashArray, b.borderDashArray, t),
        borderSide: BorderSide.lerp(a.borderSide, b.borderSide, t),
        fromY: lerpDouble(a.fromY, b.fromY, t),
        toY: lerpDouble(a.toY, b.toY, t)!,
        backDrawRodData: BackgroundBarChartRodData.lerp(
          a.backDrawRodData,
          b.backDrawRodData,
          t,
        ),
        rodStackItems:
            lerpBarChartRodStackList(a.rodStackItems, b.rodStackItems, t),
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        fromY,
        toY,
        width,
        borderRadius,
        borderDashArray,
        borderSide,
        backDrawRodData,
        rodStackItems,
        color,
        gradient,
      ];
}

/// A colored section of Stacked Chart rod item
///
/// Each [BarChartRodData] can have a list of [BarChartRodStackItem] (with different colors
/// and position) to represent a Stacked Chart rod,
class BarChartRodStackItem with EquatableMixin {
  /// Renders a section of Stacked Chart from [fromY] to [toY] with [color]
  /// for example if you want to have a Stacked Chart with three colors:
  /// ```dart
  /// BarChartRodData(
  ///   y: 9,
  ///   color: Colors.grey,
  ///   rodStackItems: [
  ///     BarChartRodStackItem(0, 3, Colors.red),
  ///     BarChartRodStackItem(3, 6, Colors.green),
  ///     BarChartRodStackItem(6, 9, Colors.blue),
  ///   ]
  /// )
  /// ```
  BarChartRodStackItem(
    this.fromY,
    this.toY,
    this.color, [
    this.borderSide = Utils.defaultBorderSide,
  ]);

  /// Renders a Stacked Chart section from [fromY]
  final double fromY;

  /// Renders a Stacked Chart section to [toY]
  final double toY;

  /// Renders a Stacked Chart section with [color]
  final Color color;

  /// Renders border stroke for a Stacked Chart section
  final BorderSide borderSide;

  /// Copies current [BarChartRodStackItem] to a new [BarChartRodStackItem],
  /// and replaces provided values.
  BarChartRodStackItem copyWith({
    double? fromY,
    double? toY,
    Color? color,
    BorderSide? borderSide,
  }) =>
      BarChartRodStackItem(
        fromY ?? this.fromY,
        toY ?? this.toY,
        color ?? this.color,
        borderSide ?? this.borderSide,
      );

  /// Lerps a [BarChartRodStackItem] based on [t] value, check [Tween.lerp].
  static BarChartRodStackItem lerp(
    BarChartRodStackItem a,
    BarChartRodStackItem b,
    double t,
  ) =>
      BarChartRodStackItem(
        lerpDouble(a.fromY, b.fromY, t)!,
        lerpDouble(a.toY, b.toY, t)!,
        Color.lerp(a.color, b.color, t)!,
        BorderSide.lerp(a.borderSide, b.borderSide, t),
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [fromY, toY, color, borderSide];
}

/// Holds values to draw a rod in rear of the main rod.
///
/// If you want to have a bar drawn in rear of the main rod, use [BarChartRodData.backDrawRodData],
/// it uses to have a bar with a passive color in rear of the rod,
/// for example you can use it as the maximum value place holder in rear of your rod.
class BackgroundBarChartRodData with EquatableMixin {
  /// It will be rendered in rear of the main rod,
  /// background starts to show from [fromY] to [toY],
  /// It draws with [color] or [gradient]. You must provide one of them,
  /// you prevent to show it, using [show] property.
  BackgroundBarChartRodData({
    double? fromY,
    double? toY,
    bool? show,
    Color? color,
    this.gradient,
  })  : fromY = fromY ?? 0,
        toY = toY ?? 0,
        show = show ?? false,
        color = color ??
            ((color == null && gradient == null) ? Colors.blueGrey : null);

  /// Determines to show or hide this
  final bool show;

  /// [fromY] is where background starts to show
  final double fromY;

  /// background starts to show from [fromY] to [toY]
  final double toY;

  /// If provided, Background draws with this [color]
  /// Otherwise we use  [gradient] to draw the background.
  /// It throws an exception if you provide both [color] and [gradient]
  final Color? color;

  /// If provided, background draws with this [gradient].
  /// Otherwise we use [color] to draw the background.
  /// It throws an exception if you provide both [color] and [gradient]
  final Gradient? gradient;

  /// Lerps a [BackgroundBarChartRodData] based on [t] value, check [Tween.lerp].
  static BackgroundBarChartRodData lerp(
    BackgroundBarChartRodData a,
    BackgroundBarChartRodData b,
    double t,
  ) =>
      BackgroundBarChartRodData(
        fromY: lerpDouble(a.fromY, b.fromY, t),
        toY: lerpDouble(a.toY, b.toY, t),
        color: Color.lerp(a.color, b.color, t),
        // ignore: invalid_use_of_protected_member
        gradient: a.gradient?.lerpTo(b.gradient, t),
        show: b.show,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        fromY,
        toY,
        color,
        gradient,
      ];
}

/// Holds data to handle touch events, and touch responses in the [BarChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart's renderer captures the touch events, and passes the pointerEvent
/// to the painter, and gets touched spot, and wraps it into a concrete [BarTouchResponse].
class BarTouchData extends FlTouchData<BarTouchResponse> with EquatableMixin {
  /// You can disable or enable the touch system using [enabled] flag,
  ///
  /// [touchCallback] notifies you about the happened touch/pointer events.
  /// It gives you a [FlTouchEvent] which is the happened event such as [FlPointerHoverEvent], [FlTapUpEvent], ...
  /// It also gives you a [BarTouchResponse] which contains information
  /// about the elements that has touched.
  ///
  /// Using [mouseCursorResolver] you can change the mouse cursor
  /// based on the provided [FlTouchEvent] and [BarTouchResponse]
  ///
  /// if [handleBuiltInTouches] is true, [BarChart] shows a tooltip popup on top of the bars if
  /// touch occurs (or you can show it manually using, [BarChartGroupData.showingTooltipIndicators]),
  /// You can customize this tooltip using [touchTooltipData].
  /// If you need to have a distance threshold for handling touches, use [touchExtraThreshold].
  /// If [allowTouchBarBackDraw] sets to true, touches will work
  /// on [BarChartRodData.backDrawRodData] too (by default it only works on the main rods).
  BarTouchData({
    bool? enabled,
    BaseTouchCallback<BarTouchResponse>? touchCallback,
    MouseCursorResolver<BarTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
    BarTouchTooltipData? touchTooltipData,
    EdgeInsets? touchExtraThreshold,
    bool? allowTouchBarBackDraw,
    bool? handleBuiltInTouches,
  })  : touchTooltipData = touchTooltipData ?? BarTouchTooltipData(),
        touchExtraThreshold = touchExtraThreshold ?? const EdgeInsets.all(4),
        allowTouchBarBackDraw = allowTouchBarBackDraw ?? false,
        handleBuiltInTouches = handleBuiltInTouches ?? true,
        super(
          enabled ?? true,
          touchCallback,
          mouseCursorResolver,
          longPressDuration,
        );

  /// Configs of how touch tooltip popup.
  final BarTouchTooltipData touchTooltipData;

  /// Distance threshold to handle the touch event.
  final EdgeInsets touchExtraThreshold;

  /// Determines to handle touches on the back draw bar.
  final bool allowTouchBarBackDraw;

  /// Determines to handle default built-in touch responses,
  /// [BarTouchResponse] shows a tooltip popup above the touched spot.
  final bool handleBuiltInTouches;

  /// Copies current [BarTouchData] to a new [BarTouchData],
  /// and replaces provided values.
  BarTouchData copyWith({
    bool? enabled,
    BaseTouchCallback<BarTouchResponse>? touchCallback,
    MouseCursorResolver<BarTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
    BarTouchTooltipData? touchTooltipData,
    EdgeInsets? touchExtraThreshold,
    bool? allowTouchBarBackDraw,
    bool? handleBuiltInTouches,
  }) =>
      BarTouchData(
        enabled: enabled ?? this.enabled,
        touchCallback: touchCallback ?? this.touchCallback,
        mouseCursorResolver: mouseCursorResolver ?? this.mouseCursorResolver,
        longPressDuration: longPressDuration ?? this.longPressDuration,
        touchTooltipData: touchTooltipData ?? this.touchTooltipData,
        touchExtraThreshold: touchExtraThreshold ?? this.touchExtraThreshold,
        allowTouchBarBackDraw:
            allowTouchBarBackDraw ?? this.allowTouchBarBackDraw,
        handleBuiltInTouches: handleBuiltInTouches ?? this.handleBuiltInTouches,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
        longPressDuration,
        touchTooltipData,
        touchExtraThreshold,
        allowTouchBarBackDraw,
        handleBuiltInTouches,
      ];
}

/// Controls showing tooltip on top or bottom.
enum TooltipDirection {
  /// Tooltip shows on top if value is positive, on bottom if value is negative.
  auto,

  /// Tooltip always shows on top.
  top,

  /// Tooltip always shows on bottom.
  bottom,
}

/// Holds representation data for showing tooltip popup on top of rods.
class BarTouchTooltipData with EquatableMixin {
  /// if [BarTouchData.handleBuiltInTouches] is true,
  /// [BarChart] shows a tooltip popup on top of rods automatically when touch happens,
  /// otherwise you can show it manually using [BarChartGroupData.showingTooltipIndicators].
  /// Tooltip shows on top of rods, with [getTooltipColor] as a background color,
  /// and you can set corner radius using [tooltipRoundedRadius].
  /// If you want to have a padding inside the tooltip, fill [tooltipPadding],
  /// or If you want to have a bottom margin, set [tooltipMargin].
  /// Content of the tooltip will provide using [getTooltipItem] callback, you can override it
  /// and pass your custom data to show in the tooltip.
  /// You can restrict the tooltip's width using [maxContentWidth].
  /// Sometimes, [BarChart] shows the tooltip outside of the chart,
  /// you can set [fitInsideHorizontally] true to force it to shift inside the chart horizontally,
  /// also you can set [fitInsideVertically] true to force it to shift inside the chart vertically.
  BarTouchTooltipData({
    double? tooltipRoundedRadius,
    EdgeInsets? tooltipPadding,
    double? tooltipMargin,
    FLHorizontalAlignment? tooltipHorizontalAlignment,
    double? tooltipHorizontalOffset,
    double? maxContentWidth,
    GetBarTooltipItem? getTooltipItem,
    GetBarTooltipColor? getTooltipColor,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    TooltipDirection? direction,
    double? rotateAngle,
    BorderSide? tooltipBorder,
  })  : tooltipRoundedRadius = tooltipRoundedRadius ?? 4,
        tooltipPadding = tooltipPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tooltipMargin = tooltipMargin ?? 16,
        tooltipHorizontalAlignment =
            tooltipHorizontalAlignment ?? FLHorizontalAlignment.center,
        tooltipHorizontalOffset = tooltipHorizontalOffset ?? 0,
        maxContentWidth = maxContentWidth ?? 120,
        getTooltipItem = getTooltipItem ?? defaultBarTooltipItem,
        getTooltipColor = getTooltipColor ?? defaultBarTooltipColor,
        fitInsideHorizontally = fitInsideHorizontally ?? false,
        fitInsideVertically = fitInsideVertically ?? false,
        direction = direction ?? TooltipDirection.auto,
        rotateAngle = rotateAngle ?? 0.0,
        tooltipBorder = tooltipBorder ?? BorderSide.none,
        super();

  /// Sets a rounded radius for the tooltip.
  final double tooltipRoundedRadius;

  /// Applies a padding for showing contents inside the tooltip.
  final EdgeInsets tooltipPadding;

  /// Applies a bottom margin for showing tooltip on top of rods.
  final double tooltipMargin;

  /// Controls showing tooltip on left side, right side or center aligned with rod, default is center
  final FLHorizontalAlignment tooltipHorizontalAlignment;

  /// Applies horizontal offset for showing tooltip, default is zero.
  final double tooltipHorizontalOffset;

  /// Restricts the tooltip's width.
  final double maxContentWidth;

  /// Retrieves data for showing content inside the tooltip.
  final GetBarTooltipItem getTooltipItem;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// Controls showing tooltip on top or bottom, default is auto.
  final TooltipDirection direction;

  /// Controls the rotation of the tooltip.
  final double rotateAngle;

  /// The tooltip border color.
  final BorderSide tooltipBorder;

  /// Retrieves data for setting background color of the tooltip.
  final GetBarTooltipColor getTooltipColor;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        tooltipRoundedRadius,
        tooltipPadding,
        tooltipMargin,
        tooltipHorizontalAlignment,
        tooltipHorizontalOffset,
        maxContentWidth,
        getTooltipItem,
        fitInsideHorizontally,
        fitInsideVertically,
        rotateAngle,
        tooltipBorder,
        getTooltipColor,
      ];
}

/// Provides a [BarTooltipItem] for showing content inside the [BarTouchTooltipData].
///
/// You can override [BarTouchTooltipData.getTooltipItem], it gives you
/// [group], [groupIndex], [rod], and [rodIndex] that touch happened on,
/// then you should and pass your custom [BarTooltipItem] to show inside the tooltip popup.
typedef GetBarTooltipItem = BarTooltipItem? Function(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
);

/// Default implementation for [BarTouchTooltipData.getTooltipItem].
BarTooltipItem? defaultBarTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
) {
  final color = rod.gradient?.colors.first ?? rod.color;
  final textStyle = TextStyle(
    color: color,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return BarTooltipItem(rod.toY.toString(), textStyle);
}

/// Holds data needed for showing custom tooltip content.
class BarTooltipItem with EquatableMixin {
  /// content of the tooltip, is a [text] String with a [textStyle],
  /// [textDirection] and optional [children].
  BarTooltipItem(
    this.text,
    this.textStyle, {
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.ltr,
    this.children,
  });

  /// Text of the content.
  final String text;

  /// TextStyle of the showing content.
  final TextStyle textStyle;

  /// TextAlign of the showing content.
  final TextAlign textAlign;

  /// Direction of showing text.
  final TextDirection textDirection;

  /// List<TextSpan> add further style and format to the text of the tooltip
  final List<TextSpan>? children;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        text,
        textStyle,
        textAlign,
        textDirection,
        children,
      ];
}

//// Provides a [Color] to show different background color for each rod
///
/// You can override [BarTouchTooltipData.getTooltipColor], it gives you
/// [group] that touch happened on, then you should and pass your custom [Color] to set background color
/// of tooltip popup.
typedef GetBarTooltipColor = Color Function(
  BarChartGroupData group,
);

/// Default implementation for [BarTouchTooltipData.getTooltipColor].
Color defaultBarTooltipColor(BarChartGroupData group) =>
    Colors.blueGrey.darken(15);

/// Holds information about touch response in the [BarChart].
///
/// You can override [BarTouchData.touchCallback] to handle touch events,
/// it gives you a [BarTouchResponse] and you can do whatever you want.
class BarTouchResponse extends BaseTouchResponse {
  /// If touch happens, [BarChart] processes it internally and passes out a BarTouchedSpot
  /// that contains a [spot], it gives you information about the touched spot.
  BarTouchResponse(this.spot) : super();

  /// Gives information about the touched spot
  final BarTouchedSpot? spot;

  /// Copies current [BarTouchResponse] to a new [BarTouchResponse],
  /// and replaces provided values.
  BarTouchResponse copyWith({
    BarTouchedSpot? spot,
  }) =>
      BarTouchResponse(
        spot ?? this.spot,
      );
}

/// It gives you information about the touched spot.
class BarTouchedSpot extends TouchedSpot with EquatableMixin {
  /// When touch happens, a [BarTouchedSpot] returns as a output,
  /// it tells you where the touch happened.
  /// [touchedBarGroup], and [touchedBarGroupIndex] tell you in which group touch happened,
  /// [touchedRodData], and [touchedRodDataIndex] tell you in which rod touch happened,
  /// [touchedStackItem], and [touchedStackItemIndex] tell you in which rod stack touch happened
  /// ([touchedStackItemIndex] means nothing found).
  /// You can also have the touched x and y in the chart as a [FlSpot] using [spot] value,
  /// and you can have the local touch coordinates on the screen as a [Offset] using [offset] value.
  BarTouchedSpot(
    this.touchedBarGroup,
    this.touchedBarGroupIndex,
    this.touchedRodData,
    this.touchedRodDataIndex,
    this.touchedStackItem,
    this.touchedStackItemIndex,
    FlSpot spot,
    Offset offset,
  ) : super(spot, offset);
  final BarChartGroupData touchedBarGroup;
  final int touchedBarGroupIndex;

  final BarChartRodData touchedRodData;
  final int touchedRodDataIndex;

  /// It can be null, if nothing found
  final BarChartRodStackItem? touchedStackItem;

  /// It can be -1, if nothing found
  final int touchedStackItemIndex;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        touchedBarGroup,
        touchedBarGroupIndex,
        touchedRodData,
        touchedRodDataIndex,
        touchedStackItem,
        touchedStackItemIndex,
        spot,
        offset,
      ];
}

/// It lerps a [BarChartData] to another [BarChartData] (handles animation for updating values)
class BarChartDataTween extends Tween<BarChartData> {
  BarChartDataTween({required BarChartData begin, required BarChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [BarChartData] based on [t] value, check [Tween.lerp].
  @override
  BarChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
