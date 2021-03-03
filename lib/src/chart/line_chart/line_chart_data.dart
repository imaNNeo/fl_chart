import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart' hide Image;

/// [LineChart] needs this class to render itself.
///
/// It holds data needed to draw a line chart,
/// including bar lines, spots, colors, touches, ...
class LineChartData extends AxisChartData with EquatableMixin {
  /// [LineChart] draws some lines in various shapes and overlaps them.
  final List<LineChartBarData> lineBarsData;

  /// Fills area between two [LineChartBarData] with a color or gradient.
  final List<BetweenBarsData> betweenBarsData;

  /// Titles on left, top, right, bottom axis for each number.
  final FlTitlesData titlesData;

  /// [LineChart] draws some horizontal or vertical lines on above or below of everything
  final ExtraLinesData extraLinesData;

  /// Handles touch behaviors and responses.
  final LineTouchData lineTouchData;

  /// You can show some tooltipIndicators (a popup with an information)
  /// on top of each [LineChartBarData.spots] using [showingTooltipIndicators],
  /// just put line indicator number and spots indices you want to show it on top of them.
  final List<ShowingTooltipIndicators> showingTooltipIndicators;

  /// [LineChart] draws some lines in various shapes and overlaps them.
  /// lines are defined in [lineBarsData], sometimes you need to fill space between two bars
  /// with a color or gradient, you can use [betweenBarsData] to achieve that.
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
  /// You can annotate some regions with a highlight color using [rangeAnnotations].
  ///
  /// You can modify [lineTouchData] to customize touch behaviors and responses.
  ///
  /// you can show some tooltipIndicators (a popup with an information)
  /// on top of each [LineChartBarData.spots] using [showingTooltipIndicators],
  /// just put line indicator number and spots indices you want to show it on top of them.
  ///
  /// [LineChart] draws some horizontal or vertical lines on above or below of everything,
  /// they are useful in some scenarios, for example you can show average line, you can fill
  /// [extraLinesData] property to have your extra lines.
  ///
  /// [clipData] forces the [LineChart] to draw lines inside the chart bounding box.
  LineChartData({
    List<LineChartBarData>? lineBarsData,
    List<BetweenBarsData>? betweenBarsData,
    FlTitlesData? titlesData,
    ExtraLinesData? extraLinesData,
    LineTouchData? lineTouchData,
    List<ShowingTooltipIndicators>? showingTooltipIndicators,
    FlGridData? gridData,
    FlBorderData? borderData,
    FlAxisTitleData? axisTitleData,
    RangeAnnotations? rangeAnnotations,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    FlClipData? clipData,
    Color? backgroundColor,
  })  : lineBarsData = lineBarsData ?? const [],
        betweenBarsData = betweenBarsData ?? const [],
        titlesData = titlesData ?? FlTitlesData(),
        extraLinesData = extraLinesData ?? ExtraLinesData(),
        lineTouchData = lineTouchData ?? LineTouchData(),
        showingTooltipIndicators = showingTooltipIndicators ?? const [],
        super(
          gridData: gridData ?? FlGridData(),
          touchData: lineTouchData ?? LineTouchData(),
          borderData: borderData,
          axisTitleData: axisTitleData ?? FlAxisTitleData(),
          rangeAnnotations: rangeAnnotations ?? RangeAnnotations(),
          clipData: clipData ?? FlClipData.none(),
          backgroundColor: backgroundColor,
          minX: minX ?? LineChartHelper.calculateMaxAxisValues(lineBarsData ?? const []).minX,
          maxX: maxX ?? LineChartHelper.calculateMaxAxisValues(lineBarsData ?? const []).maxX,
          minY: minY ?? LineChartHelper.calculateMaxAxisValues(lineBarsData ?? const []).minY,
          maxY: maxY ?? LineChartHelper.calculateMaxAxisValues(lineBarsData ?? const []).maxY,
        );

  /// Lerps a [BaseChartData] based on [t] value, check [Tween.lerp].
  @override
  LineChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is LineChartData && b is LineChartData) {
      return LineChartData(
        minX: lerpDouble(a.minX, b.minX, t),
        maxX: lerpDouble(a.maxX, b.maxX, t),
        minY: lerpDouble(a.minY, b.minY, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        clipData: b.clipData,
        extraLinesData: ExtraLinesData.lerp(a.extraLinesData, b.extraLinesData, t),
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        axisTitleData: FlAxisTitleData.lerp(a.axisTitleData, b.axisTitleData, t),
        rangeAnnotations: RangeAnnotations.lerp(a.rangeAnnotations, b.rangeAnnotations, t),
        lineBarsData: lerpLineChartBarDataList(a.lineBarsData, b.lineBarsData, t),
        betweenBarsData: lerpBetweenBarsDataList(a.betweenBarsData, b.betweenBarsData, t),
        lineTouchData: b.lineTouchData,
        showingTooltipIndicators: b.showingTooltipIndicators,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Copies current [LineChartData] to a new [LineChartData],
  /// and replaces provided values.
  LineChartData copyWith({
    List<LineChartBarData>? lineBarsData,
    List<BetweenBarsData>? betweenBarsData,
    FlTitlesData? titlesData,
    FlAxisTitleData? axisTitleData,
    RangeAnnotations? rangeAnnotations,
    ExtraLinesData? extraLinesData,
    LineTouchData? lineTouchData,
    List<ShowingTooltipIndicators>? showingTooltipIndicators,
    FlGridData? gridData,
    FlBorderData? borderData,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    FlClipData? clipData,
    Color? backgroundColor,
  }) {
    return LineChartData(
      lineBarsData: lineBarsData ?? this.lineBarsData,
      betweenBarsData: betweenBarsData ?? this.betweenBarsData,
      titlesData: titlesData ?? this.titlesData,
      axisTitleData: axisTitleData ?? this.axisTitleData,
      rangeAnnotations: rangeAnnotations ?? this.rangeAnnotations,
      extraLinesData: extraLinesData ?? this.extraLinesData,
      lineTouchData: lineTouchData ?? this.lineTouchData,
      showingTooltipIndicators: showingTooltipIndicators ?? this.showingTooltipIndicators,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      minY: minY ?? this.minY,
      maxY: maxY ?? this.maxY,
      clipData: clipData ?? this.clipData,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        lineBarsData,
        betweenBarsData,
        titlesData,
        extraLinesData,
        lineTouchData,
        showingTooltipIndicators,
        gridData,
        borderData,
        axisTitleData,
        rangeAnnotations,
        minX,
        maxX,
        minY,
        maxY,
        clipData,
        backgroundColor,
      ];
}

/// Holds data for drawing each individual line in the [LineChart]
class LineChartBarData with EquatableMixin {
  /// This line goes through this spots.
  ///
  /// You can have multiple lines by splitting them,
  /// put a [FlSpot.nullSpot] between each section.
  final List<FlSpot> spots;

  /// Determines to show or hide the line.
  final bool show;

  /// determines the color of drawing line, if one color provided it applies a solid color,
  /// otherwise it gradients between provided colors for drawing the line.
  final List<Color> colors;

  /// Determines the gradient color stops, if multiple [colors] provided.
  final List<double>? colorStops;

  /// Determines the start point of gradient,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right.
  final Offset gradientFrom;

  /// Determines the end point of gradient,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right.
  final Offset gradientTo;

  /// Determines thickness of drawing line.
  final double barWidth;

  /// If it's true, [LineChart] draws the line with curved edges,
  /// otherwise it draws line with hard edges.
  final bool isCurved;

  /// If [isCurved] is true, it determines smoothness of the curved edges.
  final double curveSmoothness;

  /// Prevent overshooting when draw curve line with high value changes.
  /// check this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/25)
  final bool preventCurveOverShooting;

  /// Applies threshold for [preventCurveOverShooting] algorithm.
  final double preventCurveOvershootingThreshold;

  /// Determines the style of line's cap.
  final bool isStrokeCapRound;

  /// Fills the space blow the line, using a color or gradient.
  final BarAreaData belowBarData;

  /// Fills the space above the line, using a color or gradient.
  final BarAreaData aboveBarData;

  /// Responsible to showing [spots] on the line as a circular point.
  final FlDotData dotData;

  /// Show indicators based on provided indexes
  final List<int> showingIndicators;

  /// Determines the dash length and space respectively, fill it if you want to have dashed line.
  final List<int>? dashArray;

  /// Drops a shadow behind the bar line.
  final Shadow shadow;

  /// If sets true, it draws the chart in Step Line Chart style, using [LineChartBarData.lineChartStepData].
  final bool isStepLineChart;

  /// Holds data for representing a Step Line Chart, and works only if [isStepChart] is true.
  final LineChartStepData lineChartStepData;

  /// [BarChart] draws some lines and overlaps them in the chart's view,
  /// You can have multiple lines by splitting them,
  /// put a [FlSpot.nullSpot] between each section.
  /// each line passes through [spots], with hard edges by default,
  /// [isCurved] makes it curve for drawing, and [curveSmoothness] determines the curve smoothness.
  ///
  /// [show] determines the drawing, if set to false, it draws nothing.
  ///
  /// [colors] determines the color of drawing line, if one color provided it applies a solid color,
  /// otherwise it gradients between provided colors for drawing the line.
  /// Gradient happens using provided [colorStops], [gradientFrom], [gradientTo].
  /// if you want it draw normally, don't touch them,
  /// check [LinearGradient] for understanding [colorStops]
  ///
  /// [barWidth] determines the thickness of drawing line,
  ///
  /// if [isCurved] is true, in some situations if the spots changes are in high values,
  /// an overshooting will happen, we don't have any idea to solve this at the moment,
  /// but you can set [preventCurveOverShooting] true, and update the threshold
  /// using [preventCurveOvershootingThreshold] to achieve an acceptable curve,
  /// check this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/25)
  /// to overshooting understand the problem.
  ///
  /// [isStrokeCapRound] determines the shape of line's cap.
  ///
  /// [belowBarData], and  [aboveBarData] used to fill the space below or above the drawn line,
  /// you can fill with a solid color or a linear gradient.
  ///
  /// [LineChart] draws points that the line is going through [spots],
  /// you can customize it's appearance using [dotData].
  ///
  /// there are some indicators with a line and bold point on each spot,
  /// you can show them by filling [showingIndicators] with indices
  /// you want to show indicator on them.
  ///
  /// [LineChart] draws the lines with dashed effect if you fill [dashArray].
  ///
  /// If you want to have a Step Line Chart style, just set [isStepLineChart] true,
  /// also you can tweak the [LineChartBarData.lineChartStepData].
  LineChartBarData({
    List<FlSpot>? spots,
    bool? show,
    List<Color>? colors,
    List<double>? colorStops,
    Offset? gradientFrom,
    Offset? gradientTo,
    double? barWidth,
    bool? isCurved,
    double? curveSmoothness,
    bool? preventCurveOverShooting,
    double? preventCurveOvershootingThreshold,
    bool? isStrokeCapRound,
    BarAreaData? belowBarData,
    BarAreaData? aboveBarData,
    FlDotData? dotData,
    List<int>? showingIndicators,
    List<int>? dashArray,
    Shadow? shadow,
    bool? isStepLineChart,
    LineChartStepData? lineChartStepData,
  })  : spots = spots ?? const [],
        show = show ?? true,
        colors = colors ?? const [Colors.redAccent],
        colorStops = colorStops,
        gradientFrom = gradientFrom ?? const Offset(0, 0),
        gradientTo = gradientTo ?? const Offset(1, 0),
        barWidth = barWidth ?? 2.0,
        isCurved = isCurved ?? false,
        curveSmoothness = curveSmoothness ?? 0.35,
        preventCurveOverShooting = preventCurveOverShooting ?? false,
        preventCurveOvershootingThreshold = preventCurveOvershootingThreshold ?? 10.0,
        isStrokeCapRound = isStrokeCapRound ?? false,
        belowBarData = belowBarData ?? BarAreaData(),
        aboveBarData = aboveBarData ?? BarAreaData(),
        dotData = dotData ?? FlDotData(),
        showingIndicators = showingIndicators ?? const [],
        dashArray = dashArray,
        shadow = shadow ?? const Shadow(color: Colors.transparent),
        isStepLineChart = isStepLineChart ?? false,
        lineChartStepData = lineChartStepData ?? LineChartStepData();

  /// Lerps a [LineChartBarData] based on [t] value, check [Tween.lerp].
  static LineChartBarData lerp(LineChartBarData a, LineChartBarData b, double t) {
    return LineChartBarData(
      show: b.show,
      barWidth: lerpDouble(a.barWidth, b.barWidth, t),
      belowBarData: BarAreaData.lerp(a.belowBarData, b.belowBarData, t),
      aboveBarData: BarAreaData.lerp(a.aboveBarData, b.aboveBarData, t),
      curveSmoothness: b.curveSmoothness,
      isCurved: b.isCurved,
      isStrokeCapRound: b.isStrokeCapRound,
      preventCurveOverShooting: b.preventCurveOverShooting,
      preventCurveOvershootingThreshold:
          lerpDouble(a.preventCurveOvershootingThreshold, b.preventCurveOvershootingThreshold, t),
      dotData: FlDotData.lerp(a.dotData, b.dotData, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      colors: lerpColorList(a.colors, b.colors, t),
      colorStops: lerpDoubleList(a.colorStops, b.colorStops, t),
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      spots: lerpFlSpotList(a.spots, b.spots, t),
      showingIndicators: b.showingIndicators,
      shadow: Shadow.lerp(a.shadow, b.shadow, t),
      isStepLineChart: b.isStepLineChart,
      lineChartStepData: LineChartStepData.lerp(a.lineChartStepData, b.lineChartStepData, t),
    );
  }

  /// Copies current [LineChartBarData] to a new [LineChartBarData],
  /// and replaces provided values.
  LineChartBarData copyWith({
    List<FlSpot>? spots,
    bool? show,
    List<Color>? colors,
    List<double>? colorStops,
    Offset? gradientFrom,
    Offset? gradientTo,
    double? barWidth,
    bool? isCurved,
    double? curveSmoothness,
    bool? preventCurveOverShooting,
    double? preventCurveOvershootingThreshold,
    bool? isStrokeCapRound,
    BarAreaData? belowBarData,
    BarAreaData? aboveBarData,
    FlDotData? dotData,
    List<int>? dashArray,
    List<int>? showingIndicators,
    Shadow? shadow,
    bool? isStepLineChart,
    LineChartStepData? lineChartStepData,
  }) {
    return LineChartBarData(
      spots: spots ?? this.spots,
      show: show ?? this.show,
      colors: colors ?? this.colors,
      colorStops: colorStops ?? this.colorStops,
      gradientFrom: gradientFrom ?? this.gradientFrom,
      gradientTo: gradientTo ?? this.gradientTo,
      barWidth: barWidth ?? this.barWidth,
      isCurved: isCurved ?? this.isCurved,
      curveSmoothness: curveSmoothness ?? this.curveSmoothness,
      preventCurveOverShooting: preventCurveOverShooting ?? this.preventCurveOverShooting,
      preventCurveOvershootingThreshold:
          preventCurveOvershootingThreshold ?? this.preventCurveOvershootingThreshold,
      isStrokeCapRound: isStrokeCapRound ?? this.isStrokeCapRound,
      belowBarData: belowBarData ?? this.belowBarData,
      aboveBarData: aboveBarData ?? this.aboveBarData,
      dashArray: dashArray ?? this.dashArray,
      dotData: dotData ?? this.dotData,
      showingIndicators: showingIndicators ?? this.showingIndicators,
      shadow: shadow ?? this.shadow,
      isStepLineChart: isStepLineChart ?? this.isStepLineChart,
      lineChartStepData: lineChartStepData ?? this.lineChartStepData,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        spots,
        show,
        colors,
        colorStops,
        gradientFrom,
        gradientTo,
        barWidth,
        isCurved,
        curveSmoothness,
        preventCurveOverShooting,
        preventCurveOvershootingThreshold,
        isStrokeCapRound,
        belowBarData,
        aboveBarData,
        dotData,
        showingIndicators,
        dashArray,
        shadow,
        isStepLineChart,
        lineChartStepData,
      ];
}

/// Holds data for representing a Step Line Chart, and works only if [LineChartBarData.isStepChart] is true.
class LineChartStepData with EquatableMixin {
  /// Go to the next spot directly, with the current point's y value.
  static const stepDirectionForward = 0.0;

  /// Go to the half with the current spot y, and with the next spot y for the rest.
  static const stepDirectionMiddle = 0.5;

  /// Go to the next spot y and direct line to the next spot.
  static const stepDirectionBackward = 1.0;

  /// Determines the direction of each step;
  final double stepDirection;

  /// Determines the [stepDirection] of each step;
  LineChartStepData({this.stepDirection = stepDirectionMiddle});

  /// Lerps a [LineChartStepData] based on [t] value, check [Tween.lerp].
  static LineChartStepData lerp(LineChartStepData a, LineChartStepData b, double t) {
    return LineChartStepData(
      stepDirection: lerpDouble(a.stepDirection, b.stepDirection, t)!,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [stepDirection];
}

/// Holds data for filling an area (above or below) of the line with a color or gradient.
class BarAreaData with EquatableMixin {
  final bool show;

  /// if you pass just one color, the solid color will be used,
  /// or if you pass more than one color, we use gradient mode to draw.
  /// then the [gradientFrom], [gradientTo] and [gradientColorStops] is important,
  final List<Color> colors;

  /// if the gradient mode is enabled (if you have more than one color)
  /// [gradientFrom] and [gradientTo] is important otherwise they will be skipped.
  /// you can determine where the gradient should start and end,
  /// values are available between 0 to 1,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right
  final Offset gradientFrom;
  final Offset gradientTo;

  /// if more than one color provided gradientColorStops will hold
  /// stop points of the gradient.
  final List<double>? gradientColorStops;

  /// holds data for drawing a line from each spot the the bottom, or top of the chart
  final BarAreaSpotsLine spotsLine;

  /// cut the drawing below or above area to this y value
  final double cutOffY;

  /// determines should or shouldn't apply cutOffY
  final bool applyCutOffY;

  /// if [show] is true, [LineChart] fills above and below area of each line
  /// with a color or gradient.
  ///
  /// [colors] determines the color of above or below space area,
  /// if one color provided it applies a solid color,
  /// otherwise it gradients between provided colors for drawing the line.
  /// Gradient happens using provided [gradientColorStops], [gradientFrom], [gradientTo].
  /// if you want it draw normally, don't touch them,
  /// check [LinearGradient] for understanding [gradientColorStops]
  ///
  /// If [spotsLine] is provided, it draws some lines from each spot
  /// to the bottom or top of the chart.
  ///
  /// If [applyCutOffY] is true, it cuts the drawing by the [cutOffY] line.
  BarAreaData({
    bool? show,
    List<Color>? colors,
    Offset? gradientFrom,
    Offset? gradientTo,
    List<double>? gradientColorStops,
    BarAreaSpotsLine? spotsLine,
    double? cutOffY,
    bool? applyCutOffY,
  })  : show = show ?? false,
        colors = colors ?? [Colors.blueGrey],
        gradientFrom = gradientFrom ?? const Offset(0, 0),
        gradientTo = gradientTo ?? const Offset(1, 0),
        gradientColorStops = gradientColorStops,
        spotsLine = spotsLine ?? BarAreaSpotsLine(),
        cutOffY = cutOffY ?? 0,
        applyCutOffY = applyCutOffY ?? false,
        assert(applyCutOffY == true ? cutOffY != null : true);

  /// Lerps a [BarAreaData] based on [t] value, check [Tween.lerp].
  static BarAreaData lerp(BarAreaData a, BarAreaData b, double t) {
    return BarAreaData(
      show: b.show,
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      spotsLine: BarAreaSpotsLine.lerp(a.spotsLine, b.spotsLine, t),
      colors: lerpColorList(a.colors, b.colors, t),
      gradientColorStops: lerpDoubleList(a.gradientColorStops, b.gradientColorStops, t),
      cutOffY: lerpDouble(a.cutOffY, b.cutOffY, t),
      applyCutOffY: b.applyCutOffY,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        colors,
        gradientFrom,
        gradientTo,
        gradientColorStops,
        spotsLine,
        cutOffY,
        applyCutOffY,
      ];
}

/// Holds data about filling below or above space of the bar line,
class BetweenBarsData with EquatableMixin {
  /// The index of the lineBarsData from where the area has to be rendered
  final int fromIndex;

  /// The index of the lineBarsData until where the area has to be rendered
  final int toIndex;

  /// if you pass just one color, the solid color will be used,
  /// or if you pass more than one color, we use gradient mode to draw.
  /// then the [gradientFrom], [gradientTo] and [gradientColorStops] is important,
  final List<Color> colors;

  /// if the gradient mode is enabled (if you have more than one color)
  /// [gradientFrom] and [gradientTo] is important otherwise they will be skipped.
  /// you can determine where the gradient should start and end,
  /// values are available between 0 to 1,
  /// Offset(0, 0) represent the top / left
  /// Offset(1, 1) represent the bottom / right
  final Offset gradientFrom;
  final Offset gradientTo;

  /// if more than one color provided gradientColorStops will hold
  /// stop points of the gradient.
  final List<double>? gradientColorStops;

  BetweenBarsData({
    required int fromIndex,
    required int toIndex,
    List<Color>? colors,
    Offset? gradientFrom,
    Offset? gradientTo,
    List<double>? gradientColorStops,
  })  : fromIndex = fromIndex,
        toIndex = toIndex,
        colors = colors ?? const [Colors.blueGrey],
        gradientFrom = gradientFrom ?? const Offset(0, 0),
        gradientTo = gradientTo ?? const Offset(1, 0),
        gradientColorStops = gradientColorStops;

  /// Lerps a [BetweenBarsData] based on [t] value, check [Tween.lerp].
  static BetweenBarsData lerp(BetweenBarsData a, BetweenBarsData b, double t) {
    return BetweenBarsData(
      fromIndex: b.fromIndex,
      toIndex: b.toIndex,
      gradientFrom: Offset.lerp(a.gradientFrom, b.gradientFrom, t),
      gradientTo: Offset.lerp(a.gradientTo, b.gradientTo, t),
      colors: lerpColorList(a.colors, b.colors, t),
      gradientColorStops: lerpDoubleList(a.gradientColorStops, b.gradientColorStops, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        fromIndex,
        toIndex,
        colors,
        gradientFrom,
        gradientTo,
        gradientColorStops,
      ];
}

/// Holds data for drawing line on the spots under the [BarAreaData].
class BarAreaSpotsLine with EquatableMixin {
  /// Determines to show or hide all the lines.
  final bool show;

  /// Holds appearance of drawing line on the spots.
  final FlLine flLineStyle;

  /// Checks to show or hide lines on the spots.
  final CheckToShowSpotLine checkToShowSpotLine;

  /// Determines to inherit the cutOff properties from its parent [BarAreaData]
  final bool applyCutOffY;

  /// If [show] is true, [LineChart] draws some lines on above or below the spots,
  /// you can customize the appearance of the lines using [flLineStyle]
  /// and you can decide to show or hide the lines on each spot using [checkToShowSpotLine].
  BarAreaSpotsLine({
    bool? show,
    FlLine? flLineStyle,
    CheckToShowSpotLine? checkToShowSpotLine,
    bool? applyCutOffY,
  })  : show = show ?? false,
        flLineStyle = flLineStyle ?? FlLine(),
        checkToShowSpotLine = checkToShowSpotLine ?? showAllSpotsBelowLine,
        applyCutOffY = applyCutOffY ?? true;

  /// Lerps a [BarAreaSpotsLine] based on [t] value, check [Tween.lerp].
  static BarAreaSpotsLine lerp(BarAreaSpotsLine a, BarAreaSpotsLine b, double t) {
    return BarAreaSpotsLine(
      show: b.show,
      checkToShowSpotLine: b.checkToShowSpotLine,
      flLineStyle: FlLine.lerp(a.flLineStyle, b.flLineStyle, t),
      applyCutOffY: b.applyCutOffY,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        flLineStyle,
        checkToShowSpotLine,
        applyCutOffY,
      ];
}

/// It used for determine showing or hiding [BarAreaSpotsLine]s
///
/// Gives you the checking spot, and you have to decide to
/// show or not show the line on the provided spot.
typedef CheckToShowSpotLine = bool Function(FlSpot spot);

/// Shows all spot lines.
bool showAllSpotsBelowLine(FlSpot spot) {
  return true;
}

/// The callback passed to get the color of a [FlSpot]
///
/// The callback receives [FlSpot], which is the target spot,
/// [double] is the percentage of spot along the bar line,
/// [LineChartBarData] is the chart's bar.
/// It should return a [Color] that needs to be used for drawing target.
typedef GetDotColorCallback = Color Function(FlSpot, double, LineChartBarData);

/// If there is one color in [LineChartBarData.colors], it returns that color,
/// otherwise it returns the color along the gradient colors based on the [xPercentage].
Color _defaultGetDotColor(FlSpot _, double xPercentage, LineChartBarData bar) {
  if (bar.colors.isEmpty || bar.colors.isEmpty) {
    return Colors.green;
  } else if (bar.colors.length == 1) {
    return bar.colors[0];
  } else {
    return lerpGradient(bar.colors, bar.getSafeColorStops(), xPercentage / 100);
  }
}

/// If there is one color in [LineChartBarData.colors], it returns that color in a darker mode,
/// otherwise it returns the color along the gradient colors based on the [xPercentage] in a darker mode.
Color _defaultGetDotStrokeColor(FlSpot spot, double xPercentage, LineChartBarData bar) {
  Color color;
  if (bar.colors.isEmpty || bar.colors.isEmpty) {
    color = Colors.green;
  } else if (bar.colors.length == 1) {
    color = bar.colors[0];
  } else {
    color = lerpGradient(bar.colors, bar.getSafeColorStops(), xPercentage / 100);
  }
  return color.darken();
}

/// The callback passed to get the painter of a [FlSpot]
///
/// The callback receives [FlSpot], which is the target spot,
/// [LineChartBarData] is the chart's bar.
/// [int] is the index position of the spot.
/// It should return a [FlDotPainter] that needs to be used for drawing target.
typedef GetDotPainterCallback = FlDotPainter Function(FlSpot, double, LineChartBarData, int);

FlDotPainter _defaultGetDotPainter(FlSpot spot, double xPercentage, LineChartBarData bar, int index,
    {double? size}) {
  return FlDotCirclePainter(
    radius: size,
    color: _defaultGetDotColor(spot, xPercentage, bar),
    strokeColor: _defaultGetDotStrokeColor(spot, xPercentage, bar),
  );
}

/// This class holds data about drawing spot dots on the drawing bar line.
class FlDotData with EquatableMixin {
  /// Determines show or hide all dots.
  final bool show;

  /// Checks to show or hide an individual dot.
  final CheckToShowDot checkToShowDot;

  /// Callback which is called to set the painter of the given [FlSpot].
  /// The [FlSpot] is provided as parameter to this callback
  final GetDotPainterCallback getDotPainter;

  /// set [show] false to prevent dots from drawing,
  /// if you want to show or hide dots in some spots,
  /// override [checkToShowDot] to handle it in your way.
  FlDotData({
    bool? show,
    CheckToShowDot? checkToShowDot,
    GetDotPainterCallback? getDotPainter,
  })  : show = show ?? true,
        checkToShowDot = checkToShowDot ?? showAllDots,
        getDotPainter = getDotPainter ?? _defaultGetDotPainter;

  /// Lerps a [FlDotData] based on [t] value, check [Tween.lerp].
  static FlDotData lerp(FlDotData a, FlDotData b, double t) {
    return FlDotData(
      show: b.show,
      checkToShowDot: b.checkToShowDot,
      getDotPainter: b.getDotPainter,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        checkToShowDot,
        getDotPainter,
      ];
}

/// This class contains the interface that all DotPainters should conform to.
abstract class FlDotPainter with EquatableMixin {
  /// This method should be overriden to draw the dot shape.
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas);

  /// This method should be overriden to return the size of the shape.
  Size getSize(FlSpot spot);
}

/// This class is an implementation of a [FlDotPainter] that draws
/// a circled shape
class FlDotCirclePainter extends FlDotPainter {
  /// The fill color to use for the circle
  Color color;

  /// Customizes the radius of the circle
  double radius;

  /// The stroke color to use for the circle
  Color strokeColor;

  /// The stroke width to use for the circle
  double strokeWidth;

  /// The color of the circle is determined determined by [color],
  /// [radius] determines the radius of the circle.
  /// You can have a stroke line around the circle,
  /// by setting the thickness with [strokeWidth],
  /// and you can change the color of of the stroke with [strokeColor].
  FlDotCirclePainter({
    Color? color,
    double? radius,
    Color? strokeColor,
    double? strokeWidth,
  })  : color = color ?? Colors.green,
        radius = radius ?? 4.0,
        strokeColor = strokeColor ?? Colors.green.darken(),
        strokeWidth = strokeWidth ?? 1.0;

  /// Implementation of the parent class to draw the circle
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    if (strokeWidth != 0.0 && strokeColor.opacity != 0.0) {
      canvas.drawCircle(
          offsetInCanvas,
          radius + (strokeWidth / 2),
          Paint()
            ..color = strokeColor
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke);
    }
    canvas.drawCircle(
        offsetInCanvas,
        radius,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  /// Implementation of the parent class to get the size of the circle
  @override
  Size getSize(FlSpot spot) {
    return Size(radius, radius);
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        color,
        radius,
        strokeColor,
        strokeWidth,
      ];
}

/// This class is an implementation of a [FlDotPainter] that draws
/// a squared shape
class FlDotSquarePainter extends FlDotPainter {
  /// The fill color to use for the square
  Color color;

  /// Customizes the size of the square
  double size;

  /// The stroke color to use for the square
  Color strokeColor;

  /// The stroke width to use for the square
  double strokeWidth;

  /// The color of the square is determined determined by [color],
  /// [size] determines the size of the square.
  /// You can have a stroke line around the square,
  /// by setting the thickness with [strokeWidth],
  /// and you can change the color of of the stroke with [strokeColor].
  FlDotSquarePainter({
    Color? color,
    double? size,
    Color? strokeColor,
    double? strokeWidth,
  })  : color = color ?? Colors.green,
        size = size ?? 4.0,
        strokeColor = strokeColor ?? Colors.green.darken(),
        strokeWidth = strokeWidth ?? 1.0;

  /// Implementation of the parent class to draw the square
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    if (strokeWidth != 0.0 && strokeColor.opacity != 0.0) {
      canvas.drawRect(
          Rect.fromCircle(
            center: offsetInCanvas,
            radius: (size / 2) + (strokeWidth / 2),
          ),
          Paint()
            ..color = strokeColor
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke);
    }
    canvas.drawRect(
        Rect.fromCircle(
          center: offsetInCanvas,
          radius: size / 2,
        ),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  /// Implementation of the parent class to get the size of the square
  @override
  Size getSize(FlSpot spot) {
    return Size(size, size);
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        color,
        size,
        strokeColor,
        strokeWidth,
      ];
}

/// It determines showing or hiding [FlDotData] on the spots.
///
/// It gives you the checking [FlSpot] and you should decide to
/// show or hide the dot on this spot by returning true or false.
typedef CheckToShowDot = bool Function(FlSpot spot, LineChartBarData barData);

/// Shows all dots on spots.
bool showAllDots(FlSpot spot, LineChartBarData barData) {
  return true;
}

/// Holds data for drawing extra horizontal lines.
///
/// [LineChart] draws some [HorizontalLine] (set by [LineChartData.extraLinesData]),
/// in below or above of everything, it draws from left to right side of the chart.
class HorizontalLine extends FlLine with EquatableMixin {
  /// Draws from left to right of the chart using the [y] value.
  final double y;

  /// Use it for any kind of image, to draw it in left side of the chart.
  Image? image;

  /// Use it for vector images, to draw it in left side of the chart.
  SizedPicture? sizedPicture;

  /// Draws a text label over the line.
  final HorizontalLineLabel label;

  /// [LineChart] draws horizontal lines from left to right side of the chart
  /// in the provided [y] value, and color it using [color].
  /// You can define the thickness using [strokeWidth]
  ///
  /// It draws a [label] over it.
  ///
  /// You can have a dashed line by filling [dashArray] with dash size and space respectively.
  ///
  /// It draws an image in left side of the chart, use [sizedPicture] for vectors,
  /// or [image] for any kind of image.
  HorizontalLine({
    required this.y,
    HorizontalLineLabel? label,
    Color? color,
    double? strokeWidth,
    List<int>? dashArray,
    this.image,
    this.sizedPicture,
  })  : label = label ?? HorizontalLineLabel(),
        super(color: color ?? Colors.black, strokeWidth: strokeWidth ?? 2, dashArray: dashArray);

  /// Lerps a [HorizontalLine] based on [t] value, check [Tween.lerp].
  static HorizontalLine lerp(HorizontalLine a, HorizontalLine b, double t) {
    return HorizontalLine(
      y: lerpDouble(a.y, b.y, t)!,
      label: HorizontalLineLabel.lerp(a.label, b.label, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      image: b.image,
      sizedPicture: b.sizedPicture,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        y,
        label,
        color,
        strokeWidth,
        dashArray,
        image,
        sizedPicture,
      ];
}

/// Holds data for drawing extra vertical lines.
///
/// [LineChart] draws some [VerticalLine] (set by [LineChartData.extraLinesData]),
/// in below or above of everything, it draws from bottom to top side of the chart.
class VerticalLine extends FlLine with EquatableMixin {
  /// Draws from bottom to top of the chart using the [x] value.
  final double x;

  /// Use it for any kind of image, to draw it in bottom side of the chart.
  Image? image;

  /// Use it for vector images, to draw it in bottom side of the chart.
  SizedPicture? sizedPicture;

  /// Draws a text label over the line.
  final VerticalLineLabel label;

  /// [LineChart] draws vertical lines from bottom to top side of the chart
  /// in the provided [x] value, and color it using [color].
  /// You can define the thickness using [strokeWidth]
  ///
  /// It draws a [label] over it.
  ///
  /// You can have a dashed line by filling [dashArray] with dash size and space respectively.
  ///
  /// It draws an image in bottom side of the chart, use [sizedPicture] for vectors,
  /// or [image] for any kind of image.
  VerticalLine({
    required this.x,
    VerticalLineLabel? label,
    Color? color,
    double? strokeWidth,
    List<int>? dashArray,
    this.image,
    this.sizedPicture,
  })  : label = label ?? VerticalLineLabel(),
        super(color: color ?? Colors.black, strokeWidth: strokeWidth ?? 2, dashArray: dashArray);

  /// Lerps a [VerticalLine] based on [t] value, check [Tween.lerp].
  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) {
    return VerticalLine(
      x: lerpDouble(a.x, b.x, t)!,
      label: VerticalLineLabel.lerp(a.label, b.label, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      image: b.image,
      sizedPicture: b.sizedPicture,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        x,
        label,
        color,
        strokeWidth,
        dashArray,
        image,
        sizedPicture,
      ];
}

/// Shows a text label
abstract class FlLineLabel with EquatableMixin {
  /// Determines showing label or not.
  final bool show;

  /// Inner spaces around the drawing text.
  final EdgeInsetsGeometry padding;

  /// Sets style of the drawing text.
  final TextStyle style;

  /// Aligns the text on the line.
  final Alignment alignment;

  /// Draws a title on the line, align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style] for changing color,
  /// size, ... of the text.
  /// [show] determines showing label or not.
  FlLineLabel(
      {required this.show, required this.padding, required this.style, required this.alignment});

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        padding,
        style,
        alignment,
      ];
}

/// Draws a title on the [HorizontalLine]
class HorizontalLineLabel extends FlLineLabel with EquatableMixin {
  /// Resolves a label for showing.
  final String Function(HorizontalLine) labelResolver;

  /// Returns the [HorizontalLine.y] as the drawing label.
  static String defaultLineLabelResolver(HorizontalLine line) => line.y.toStringAsFixed(1);

  /// Draws a title on the [HorizontalLine], align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style for changing color,
  /// size, ... of the text.
  /// Drawing text will retrieve through [labelResolver],
  /// you can override it with your custom data.
  /// /// [show] determines showing label or not.
  HorizontalLineLabel({
    EdgeInsets? padding,
    TextStyle? style,
    Alignment? alignment,
    bool show = false,
    String Function(HorizontalLine)? labelResolver,
  })  : labelResolver = labelResolver ?? HorizontalLineLabel.defaultLineLabelResolver,
        super(
          show: show,
          padding: padding ?? const EdgeInsets.all(6),
          style: style ??
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
          alignment: alignment ?? Alignment.topLeft,
        );

  /// Lerps a [HorizontalLineLabel] based on [t] value, check [Tween.lerp].
  static HorizontalLineLabel lerp(HorizontalLineLabel a, HorizontalLineLabel b, double t) {
    return HorizontalLineLabel(
      padding: EdgeInsets.lerp(a.padding as EdgeInsets, b.padding as EdgeInsets, t),
      style: TextStyle.lerp(a.style, b.style, t),
      alignment: Alignment.lerp(a.alignment, b.alignment, t),
      labelResolver: b.labelResolver,
      show: b.show,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        labelResolver,
        show,
        padding,
        style,
        alignment,
      ];
}

/// Draws a title on the [VerticalLine]
class VerticalLineLabel extends FlLineLabel with EquatableMixin {
  /// Resolves a label for showing.
  final String Function(VerticalLine) labelResolver;

  /// Returns the [VerticalLine.x] as the drawing label.
  static String defaultLineLabelResolver(VerticalLine line) => line.x.toStringAsFixed(1);

  /// Draws a title on the [VerticalLine], align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style for changing color,
  /// size, ... of the text.
  /// Drawing text will retrieve through [labelResolver],
  /// you can override it with your custom data.
  /// [show] determines showing label or not.
  VerticalLineLabel({
    EdgeInsets? padding,
    TextStyle? style,
    Alignment? alignment,
    bool? show,
    String Function(VerticalLine)? labelResolver,
  })  : labelResolver = labelResolver ?? VerticalLineLabel.defaultLineLabelResolver,
        super(
          show: show ?? false,
          padding: padding ?? const EdgeInsets.all(6),
          style: style ??
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
          alignment: alignment ?? Alignment.bottomRight,
        );

  /// Lerps a [VerticalLineLabel] based on [t] value, check [Tween.lerp].
  static VerticalLineLabel lerp(VerticalLineLabel a, VerticalLineLabel b, double t) {
    return VerticalLineLabel(
      padding: EdgeInsets.lerp(a.padding as EdgeInsets, b.padding as EdgeInsets, t),
      style: TextStyle.lerp(a.style, b.style, t),
      alignment: Alignment.lerp(a.alignment, b.alignment, t),
      labelResolver: b.labelResolver,
      show: b.show,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        labelResolver,
        show,
        padding,
        style,
        alignment,
      ];
}

/// Holds data for showing a vector image inside the chart.
///
/// for example:
/// ```
/// Future<SizedPicture> loadSvg() async {
///    const String rawSvg = 'your svg string';
///    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
///    final sizedPicture = SizedPicture(svgRoot.toPicture(), 14, 14);
///    return sizedPicture;
///  }
/// ```
class SizedPicture with EquatableMixin {
  /// Is the showing image.
  Picture picture;

  /// width of our [picture].
  int width;

  /// height of our [picture].
  int height;

  /// [picture] is the showing image,
  /// it can retrieve from a svg icon,
  /// for example:
  /// ```
  ///    const String rawSvg = 'your svg string';
  ///    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
  ///    final picture = svgRoot.toPicture()
  /// ```
  /// [width] and [height] determines the size of our picture.
  SizedPicture(this.picture, this.width, this.height);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        picture,
        width,
        height,
      ];
}

/// Draws some straight horizontal or vertical lines in the [LineChart]
class ExtraLinesData with EquatableMixin {
  final List<HorizontalLine> horizontalLines;
  final List<VerticalLine> verticalLines;

  final bool extraLinesOnTop;

  /// [LineChart] draws some straight horizontal or vertical lines,
  /// you should set [LineChartData.extraLinesData].
  /// Draws horizontal lines using [horizontalLines],
  /// and vertical lines using [verticalLines].
  ///
  /// If [extraLinesOnTop] sets true, it draws the line above the main bar lines, otherwise
  /// it draws them below the main bar lines.
  ExtraLinesData({
    List<HorizontalLine>? horizontalLines,
    List<VerticalLine>? verticalLines,
    bool? extraLinesOnTop,
  })  : horizontalLines = horizontalLines ?? const [],
        verticalLines = verticalLines ?? const [],
        extraLinesOnTop = extraLinesOnTop ?? true;

  /// Lerps a [ExtraLinesData] based on [t] value, check [Tween.lerp].
  static ExtraLinesData lerp(ExtraLinesData a, ExtraLinesData b, double t) {
    return ExtraLinesData(
      extraLinesOnTop: b.extraLinesOnTop,
      horizontalLines: lerpHorizontalLineList(a.horizontalLines, b.horizontalLines, t),
      verticalLines: lerpVerticalLineList(a.verticalLines, b.verticalLines, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        horizontalLines,
        verticalLines,
        extraLinesOnTop,
      ];
}

/// Holds data to handle touch events, and touch responses in the [LineChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [LineTouchResponse].
class LineTouchData extends FlTouchData with EquatableMixin {
  /// Configs of how touch tooltip popup.
  final LineTouchTooltipData touchTooltipData;

  /// Configs of how touch indicator looks like.
  final GetTouchedSpotIndicator getTouchedSpotIndicator;

  /// Distance threshold to handle the touch event.
  final double touchSpotThreshold;

  /// Determines to handle default built-in touch responses,
  /// [LineTouchResponse] shows a tooltip popup above the touched spot.
  final bool handleBuiltInTouches;

  /// Sets the indicator line full height, from bottom to top of the chart,
  /// and goes through the targeted spot.
  final bool fullHeightTouchLine;

  /// Informs the touchResponses
  final Function(LineTouchResponse)? touchCallback;

  /// You can disable or enable the touch system using [enabled] flag,
  /// if [handleBuiltInTouches] is true, [LineChart] shows a tooltip popup on top of the spots if
  /// touch occurs (or you can show it manually using, [LineChartData.showingTooltipIndicators])
  /// and also it shows an indicator (contains a thicker line and larger dot on the targeted spot),
  /// You can define how this indicator looks like through [getTouchedSpotIndicator] callback,
  /// You can customize this tooltip using [touchTooltipData], indicator lines starts from  bottom
  /// of the chart to the targeted spot, you can change this behavior by [fullHeightTouchLine],
  /// if [fullHeightTouchLine] sets true, the line goes from bottom to top of the chart,
  /// and goes through the targeted spot.
  /// If you need to have a distance threshold for handling touches, use [touchSpotThreshold].
  ///
  /// You can listen to touch events using [touchCallback],
  /// It gives you a [LineTouchResponse] that contains some
  /// useful information about happened touch.
  LineTouchData({
    bool? enabled,
    LineTouchTooltipData? touchTooltipData,
    GetTouchedSpotIndicator? getTouchedSpotIndicator,
    double? touchSpotThreshold,
    bool? fullHeightTouchLine,
    bool? handleBuiltInTouches,
    Function(LineTouchResponse)? touchCallback,
  })  : touchTooltipData = touchTooltipData ?? LineTouchTooltipData(),
        getTouchedSpotIndicator = getTouchedSpotIndicator ?? defaultTouchedIndicators,
        touchSpotThreshold = touchSpotThreshold ?? 10,
        fullHeightTouchLine = fullHeightTouchLine ?? false,
        handleBuiltInTouches = handleBuiltInTouches ?? true,
        touchCallback = touchCallback,
        super(enabled ?? true);

  /// Copies current [LineTouchData] to a new [LineTouchData],
  /// and replaces provided values.
  LineTouchData copyWith({
    bool? enabled,
    LineTouchTooltipData? touchTooltipData,
    GetTouchedSpotIndicator? getTouchedSpotIndicator,
    double? touchSpotThreshold,
    bool? fullHeightTouchLine,
    bool? handleBuiltInTouches,
    Function(LineTouchResponse)? touchCallback,
  }) {
    return LineTouchData(
      enabled: enabled ?? this.enabled,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      getTouchedSpotIndicator: getTouchedSpotIndicator ?? this.getTouchedSpotIndicator,
      touchSpotThreshold: touchSpotThreshold ?? this.touchSpotThreshold,
      fullHeightTouchLine: fullHeightTouchLine ?? this.fullHeightTouchLine,
      handleBuiltInTouches: handleBuiltInTouches ?? this.handleBuiltInTouches,
      touchCallback: touchCallback ?? this.touchCallback,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        touchTooltipData,
        getTouchedSpotIndicator,
        touchSpotThreshold,
        handleBuiltInTouches,
        fullHeightTouchLine,
        touchCallback,
        enabled,
      ];
}

/// Used for showing touch indicators (a thicker line and larger dot on the targeted spot).
///
/// It gives you the [spotIndexes] that touch happened, or manually targeted,
/// in the given [barData], you should return a list of [TouchedSpotIndicatorData],
/// length of this list should be equal to the [spotIndexes.length],
/// each [TouchedSpotIndicatorData] determines the look of showing indicator.
typedef GetTouchedSpotIndicator = List<TouchedSpotIndicatorData?> Function(
    LineChartBarData barData, List<int> spotIndexes);

/// Default presentation of touched indicators.
List<TouchedSpotIndicatorData> defaultTouchedIndicators(
    LineChartBarData barData, List<int> indicators) {
  return indicators.map((int index) {
    /// Indicator Line
    var lineColor = barData.colors[0];
    if (barData.dotData.show) {
      lineColor = _defaultGetDotColor(barData.spots[index], 0, barData);
    }
    const lineStrokeWidth = 4.0;
    final flLine = FlLine(color: lineColor, strokeWidth: lineStrokeWidth);

    var dotSize = 10.0;
    if (barData.dotData.show) {
      dotSize = 4.0 * 1.8;
    }

    final dotData = FlDotData(
        getDotPainter: (spot, percent, bar, index) =>
            _defaultGetDotPainter(spot, percent, bar, index, size: dotSize));

    return TouchedSpotIndicatorData(flLine, dotData);
  }).toList();
}

/// Holds representation data for showing tooltip popup on top of spots.
class LineTouchTooltipData with EquatableMixin {
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
  final GetLineTooltipItems getTooltipItems;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// Forces the tooltip container to top of the line, default 'false'
  final bool showOnTopOfTheChartBoxArea;

  /// if [LineTouchData.handleBuiltInTouches] is true,
  /// [LineChart] shows a tooltip popup on top of spots automatically when touch happens,
  /// otherwise you can show it manually using [LineChartData.showingTooltipIndicators].
  /// Tooltip shows on top of spots, with [tooltipBgColor] as a background color,
  /// and you can set corner radius using [tooltipRoundedRadius].
  /// If you want to have a padding inside the tooltip, fill [tooltipPadding],
  /// or If you want to have a bottom margin, set [tooltipBottomMargin].
  /// Content of the tooltip will provide using [getTooltipItems] callback, you can override it
  /// and pass your custom data to show in the tooltip.
  /// You can restrict the tooltip's width using [maxContentWidth].
  /// Sometimes, [LineChart] shows the tooltip outside of the chart,
  /// you can set [fitInsideHorizontally] true to force it to shift inside the chart horizontally,
  /// also you can set [fitInsideVertically] true to force it to shift inside the chart vertically.
  LineTouchTooltipData({
    Color? tooltipBgColor,
    double? tooltipRoundedRadius,
    EdgeInsets? tooltipPadding,
    double? tooltipBottomMargin,
    double? maxContentWidth,
    GetLineTooltipItems? getTooltipItems,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    bool? showOnTopOfTheChartBoxArea,
  })  : tooltipBgColor = tooltipBgColor ?? Colors.white,
        tooltipRoundedRadius = tooltipRoundedRadius ?? 4,
        tooltipPadding = tooltipPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tooltipBottomMargin = tooltipBottomMargin ?? 16,
        maxContentWidth = maxContentWidth ?? 120,
        getTooltipItems = getTooltipItems ?? defaultLineTooltipItem,
        fitInsideHorizontally = fitInsideHorizontally ?? false,
        fitInsideVertically = fitInsideVertically ?? false,
        showOnTopOfTheChartBoxArea = showOnTopOfTheChartBoxArea ?? false,
        super();

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        tooltipBgColor,
        tooltipRoundedRadius,
        tooltipPadding,
        tooltipBottomMargin,
        maxContentWidth,
        getTooltipItems,
        fitInsideHorizontally,
        fitInsideVertically,
        showOnTopOfTheChartBoxArea,
      ];
}

/// Provides a [LineTooltipItem] for showing content inside the [LineTouchTooltipData].
///
/// You can override [LineTouchTooltipData.getTooltipItems], it gives you
/// [touchedSpots] list that touch happened on,
/// then you should and pass your custom [LineTooltipItem] list
/// (length should be equal to the [touchedSpots.length]),
/// to show inside the tooltip popup.
typedef GetLineTooltipItems = List<LineTooltipItem?> Function(List<LineBarSpot> touchedSpots);

/// Default implementation for [LineTouchTooltipData.getTooltipItems].
List<LineTooltipItem> defaultLineTooltipItem(List<LineBarSpot> touchedSpots) {
  return touchedSpots.map((LineBarSpot touchedSpot) {
    final textStyle = TextStyle(
      color: touchedSpot.bar.colors[0],
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return LineTooltipItem(touchedSpot.y.toString(), textStyle);
  }).toList();
}

/// Represent a targeted spot inside a line bar.
class LineBarSpot extends FlSpot with EquatableMixin {
  /// Is the [LineChartBarData] that this spot is inside of.
  final LineChartBarData bar;

  /// Is the index of our [bar], in the [LineChartData.lineBarsData] list,
  final int barIndex;

  /// Is the index of our [super.spot], in the [LineChartBarData.spots] list.
  final int spotIndex;

  /// [bar] is the [LineChartBarData] that this spot is inside of,
  /// [barIndex] is the index of our [bar], in the [LineChartData.lineBarsData] list,
  /// [spot] is the targeted spot.
  /// [spotIndex] is the index this [FlSpot], in the [LineChartBarData.spots] list.
  LineBarSpot(
    this.bar,
    this.barIndex,
    FlSpot spot,
  )   : spotIndex = bar.spots.indexOf(spot),
        super(spot.x, spot.y);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        bar,
        barIndex,
        spotIndex,
        x,
        y,
      ];
}

/// Holds data of showing each row item in the tooltip popup.
class LineTooltipItem with EquatableMixin {
  /// Showing text.
  final String text;

  /// Style of showing text.
  final TextStyle textStyle;

  /// Shows a [text] with [textStyle] as a row in the tooltip popup.
  LineTooltipItem(this.text, this.textStyle);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        text,
        textStyle,
      ];
}

/// details of showing indicator when touch happened on [LineChart]
/// [indicatorBelowLine] we draw a vertical line below of the touched spot
/// [touchedSpotDotData] we draw a larger dot on the touched spot to bold it
class TouchedSpotIndicatorData with EquatableMixin {
  /// Determines line's style.
  final FlLine indicatorBelowLine;

  /// Determines dot's style.
  final FlDotData touchedSpotDotData;

  /// if [LineTouchData.handleBuiltInTouches] is true,
  /// [LineChart] shows a thicker line and larger spot as indicator automatically when touch happens,
  /// otherwise you can show it manually using [LineChartBarData.showingIndicators].
  /// [indicatorBelowLine] determines line's style, and
  /// [touchedSpotDotData] determines dot's style.
  TouchedSpotIndicatorData(this.indicatorBelowLine, this.touchedSpotDotData);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        indicatorBelowLine,
        touchedSpotDotData,
      ];
}

/// Holds data for showing tooltips over a line
class ShowingTooltipIndicators with EquatableMixin {
  /// Determines in which line these tooltips should be shown.
  final int lineIndex;

  /// Determines the spots that each tooltip should be shown.
  final List<LineBarSpot> showingSpots;

  /// [LineChart] shows some tooltips over each [LineChartBarData],
  /// [lineIndex] determines the index of [LineChartBarData],
  /// and [showingSpots] determines in which spots this tooltip should be shown.
  ShowingTooltipIndicators(int lineIndex, List<LineBarSpot> showingSpots)
      : lineIndex = lineIndex,
        showingSpots = showingSpots;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [lineIndex, showingSpots];
}

/// Holds information about touch response in the [LineChart].
///
/// You can override [LineTouchData.touchCallback] to handle touch events,
/// it gives you a [LineTouchResponse] and you can do whatever you want.
class LineTouchResponse extends BaseTouchResponse with EquatableMixin {
  /// touch happened on these spots
  /// (if a single line provided on the chart, [lineBarSpots]'s length will be 1 always)
  final List<LineBarSpot> lineBarSpots;

  /// If touch happens, [LineChart] processes it internally and
  /// passes out a list of [lineBarSpots] it gives you information about the touched spot.
  /// [touchInput] is the type of happened touch.
  LineTouchResponse(
    this.lineBarSpots,
    FlTouchInput touchInput,
  ) : super(touchInput);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        lineBarSpots,
        touchInput,
      ];
}

/// It lerps a [LineChartData] to another [LineChartData] (handles animation for updating values)
class LineChartDataTween extends Tween<LineChartData> {
  LineChartDataTween({required LineChartData begin, required LineChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [LineChartData] based on [t] value, check [Tween.lerp].
  @override
  LineChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
