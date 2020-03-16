import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart' hide Image;

/// [LineChart] needs this class to render itself.
///
/// It holds data needed to draw a line chart,
/// including bar lines, spots, colors, touches, ...
class LineChartData extends AxisChartData {

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
  final List<MapEntry<int, List<LineBarSpot>>> showingTooltipIndicators;

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
  /// [clipToBorder] forces the [LineChart] to draw lines inside the chart bounding box.
  LineChartData({
    this.lineBarsData = const [],
    this.betweenBarsData = const [],
    this.titlesData = const FlTitlesData(),
    this.extraLinesData = const ExtraLinesData(),
    this.lineTouchData = const LineTouchData(),
    this.showingTooltipIndicators = const [],
    FlGridData gridData = const FlGridData(),
    FlBorderData borderData,
    FlAxisTitleData axisTitleData = const FlAxisTitleData(),
    RangeAnnotations rangeAnnotations = const RangeAnnotations(),
    double minX,
    double maxX,
    double minY,
    double maxY,
    bool clipToBorder = false,
    Color backgroundColor,
  }) : super(
          gridData: gridData,
          touchData: lineTouchData,
          borderData: borderData,
          axisTitleData: axisTitleData,
          rangeAnnotations: rangeAnnotations,
          clipToBorder: clipToBorder,
          backgroundColor: backgroundColor,
        ) {
    initSuperMinMaxValues(minX, maxX, minY, maxY);
  }

  /// fills [minX], [maxX], [minY], [maxY] if they are null,
  /// based on the provided [lineBarsData].
  void initSuperMinMaxValues(
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) {
    for (int i = 0; i < lineBarsData.length; i++) {
      final LineChartBarData lineBarChart = lineBarsData[i];
      if (lineBarChart.spots == null || lineBarChart.spots.isEmpty) {
        throw Exception('spots could not be null or empty');
      }
    }
    if (lineBarsData.isNotEmpty) {
      var canModifyMinX = false;
      if (minX == null) {
        minX = lineBarsData[0].spots[0].x;
        canModifyMinX = true;
      }

      var canModifyMaxX = false;
      if (maxX == null) {
        maxX = lineBarsData[0].spots[0].x;
        canModifyMaxX = true;
      }

      var canModifyMinY = false;
      if (minY == null) {
        minY = lineBarsData[0].spots[0].y;
        canModifyMinY = true;
      }

      var canModifyMaxY = false;
      if (maxY == null) {
        maxY = lineBarsData[0].spots[0].y;
        canModifyMaxY = true;
      }

      for (int i = 0; i < lineBarsData.length; i++) {
        final LineChartBarData barData = lineBarsData[i];
        for (int j = 0; j < barData.spots.length; j++) {
          final FlSpot spot = barData.spots[j];
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
    }

    super.minX = minX ?? 0;
    super.maxX = maxX ?? 1;
    super.minY = minY ?? 0;
    super.maxY = maxY ?? 1;
  }

  /// Lerps a [BaseChartData] based on [t] value, check [Tween.lerp].
  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is LineChartData && b is LineChartData && t != null) {
      return LineChartData(
        minX: lerpDouble(a.minX, b.minX, t),
        maxX: lerpDouble(a.maxX, b.maxX, t),
        minY: lerpDouble(a.minY, b.minY, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        clipToBorder: b.clipToBorder,
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

  LineChartData copyWith({
    List<LineChartBarData> lineBarsData,
    List<BetweenBarsData> betweenBarsData,
    FlTitlesData titlesData,
    FlAxisTitleData axisTitleData,
    RangeAnnotations rangeAnnotations,
    ExtraLinesData extraLinesData,
    LineTouchData lineTouchData,
    List<MapEntry<int, List<LineBarSpot>>> showingTooltipIndicators,
    FlGridData gridData,
    FlBorderData borderData,
    double minX,
    double maxX,
    double minY,
    double maxY,
    bool clipToBorder,
    Color backgroundColor,
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
      clipToBorder: clipToBorder ?? this.clipToBorder,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

/// Holds data for drawing each individual line in the [LineChart]
class LineChartBarData {

  /// This line goes through this spots.
  final List<FlSpot> spots;

  /// Determines to show or hide the line.
  final bool show;

  /// determines the color of drawing line, if one color provided it applies a solid color,
  /// otherwise it gradients between provided colors for drawing the line.
  final List<Color> colors;

  /// Determines the gradient color stops, if multiple [colors] provided.
  final List<double> colorStops;

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
  final List<int> dashArray;

  /// [BarChart] draws some lines and overlaps them in the chart's view,
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
  const LineChartBarData({
    this.spots = const [],
    this.show = true,
    this.colors = const [Colors.redAccent],
    this.colorStops,
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.barWidth = 2.0,
    this.isCurved = false,
    this.curveSmoothness = 0.35,
    this.preventCurveOverShooting = false,
    this.preventCurveOvershootingThreshold = 10.0,
    this.isStrokeCapRound = false,
    this.belowBarData = const BarAreaData(),
    this.aboveBarData = const BarAreaData(),
    this.dotData = const FlDotData(),
    this.showingIndicators = const [],
    this.dashArray,
  });

  /// Lerps a [LineChartBarData] based on [t] value, check [Tween.lerp].
  static LineChartBarData lerp(LineChartBarData a, LineChartBarData b, double t) {
    return LineChartBarData(
      show: b.show,
      barWidth: lerpDouble(a.barWidth, b.barWidth, t),
      belowBarData: BarAreaData.lerp(a.belowBarData, b.belowBarData, t),
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
    );
  }

  LineChartBarData copyWith({
    List<FlSpot> spots,
    bool show,
    List<Color> colors,
    List<double> colorStops,
    Offset gradientFrom,
    Offset gradientTo,
    double barWidth,
    bool isCurved,
    double curveSmoothness,
    bool preventCurveOverShooting,
    bool isStrokeCapRound,
    BarAreaData belowBarData,
    BarAreaData aboveBarData,
    FlDotData dotData,
    List<int> dashArray,
    List<int> showingIndicators,
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
      isStrokeCapRound: isStrokeCapRound ?? this.isStrokeCapRound,
      belowBarData: belowBarData ?? this.belowBarData,
      aboveBarData: aboveBarData ?? this.aboveBarData,
      dashArray: dashArray ?? this.dashArray,
      dotData: dotData ?? this.dotData,
      showingIndicators: showingIndicators ?? this.showingIndicators,
    );
  }
}

/// Holds data for filling an area (above or below) of the line with a color or gradient.
class BarAreaData {
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
  final List<double> gradientColorStops;

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
  const BarAreaData({
    this.show = false,
    this.colors = const [Colors.blueGrey],
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.gradientColorStops,
    this.spotsLine = const BarAreaSpotsLine(),
    this.cutOffY,
    this.applyCutOffY = false,
  }) : assert(applyCutOffY == true ? cutOffY != null : true);

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
}

/// Holds data about filling below or above space of the bar line,
class BetweenBarsData {
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
  final List<double> gradientColorStops;

  const BetweenBarsData({
    @required this.fromIndex,
    @required this.toIndex,
    this.colors = const [Colors.blueGrey],
    this.gradientFrom = const Offset(0, 0),
    this.gradientTo = const Offset(1, 0),
    this.gradientColorStops,
  });

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
}

/// Holds data for drawing line on the spots under the [BarAreaData].
class BarAreaSpotsLine {

  /// Determines to show or hide all the lines.
  final bool show;

  /// Holds appearance of drawing line on the spots.
  final FlLine flLineStyle;

  /// Checks to show or hide lines on the spots.
  final CheckToShowSpotLine checkToShowSpotLine;

  /// If [show] is true, [LineChart] draws some lines on above or below the spots,
  /// you can customize the appearance of the lines using [flLineStyle]
  /// and you can decide to show or hide the lines on each spot using [checkToShowSpotLine].
  const BarAreaSpotsLine({
    this.show = false,
    this.flLineStyle = const FlLine(),
    this.checkToShowSpotLine = showAllSpotsBelowLine,
  });

  /// Lerps a [BarAreaSpotsLine] based on [t] value, check [Tween.lerp].
  static BarAreaSpotsLine lerp(BarAreaSpotsLine a, BarAreaSpotsLine b, double t) {
    return BarAreaSpotsLine(
      show: b.show,
      checkToShowSpotLine: b.checkToShowSpotLine,
      flLineStyle: FlLine.lerp(a.flLineStyle, b.flLineStyle, t),
    );
  }
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

/// Holds data for showing dots on the bar line.
class FlDotData {

  /// Determines show or hide all dots.
  final bool show;

  /// Determines color of showing dots.
  final Color dotColor;

  /// Determines size of showing dots.
  final double dotSize;

  /// Checks to show or hide an individual dot.
  final CheckToShowDot checkToShowDot;

  /// set [show] false to prevent dots from drawing,
  /// [dotColor] determines the color of circular dots on spots, and
  /// [dotSize] determines the size of dots.
  /// if you want to show or hide dots in some spots,
  /// override [checkToShowDot] to handle it in your way.
  const FlDotData({
    this.show = true,
    this.dotColor = Colors.blue,
    this.dotSize = 4.0,
    this.checkToShowDot = showAllDots,
  });

  /// Lerps a [FlDotData] based on [t] value, check [Tween.lerp].
  static FlDotData lerp(FlDotData a, FlDotData b, double t) {
    return FlDotData(
      show: b.show,
      checkToShowDot: b.checkToShowDot,
      dotColor: Color.lerp(a.dotColor, b.dotColor, t),
      dotSize: lerpDouble(a.dotSize, b.dotSize, t),
    );
  }
}

/// It determines showing or hiding [FlDotData] on the spots.
///
/// It gives you the checking [FlSpot] and you should decide to
/// show or hide the dot on this spot by returning true or false.
typedef CheckToShowDot = bool Function(FlSpot spot);

/// Shows all dots on spots.
bool showAllDots(FlSpot spot) {
  return true;
}

/// Holds data for drawing extra horizontal lines.
///
/// [LineChart] draws some [HorizontalLine] (set by [LineChartData.extraLinesData]),
/// in below or above of everything, it draws from left to right side of the chart.
class HorizontalLine extends FlLine {

  /// Draws from left to right of the chart using the [y] value.
  final double y;

  /// Use it for any kind of image, to draw it in left side of the chart.
  Image image;

  /// Use it for vector images, to draw it in left side of the chart.
  SizedPicture sizedPicture;

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
    this.y,
    this.label,
    Color color = Colors.black,
    double strokeWidth = 2,
    List<int> dashArray,
    this.image,
    this.sizedPicture,
  }) : super(color: color, strokeWidth: strokeWidth, dashArray: dashArray);

  /// Lerps a [HorizontalLine] based on [t] value, check [Tween.lerp].
  static HorizontalLine lerp(HorizontalLine a, HorizontalLine b, double t) {
    return HorizontalLine(
      y: lerpDouble(a.y, b.y, t),
      label: HorizontalLineLabel.lerp(a.label, b.label, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      image: b.image,
      sizedPicture: b.sizedPicture,
    );
  }
}

/// Holds data for drawing extra vertical lines.
///
/// [LineChart] draws some [VerticalLine] (set by [LineChartData.extraLinesData]),
/// in below or above of everything, it draws from bottom to top side of the chart.
class VerticalLine extends FlLine {

  /// Draws from bottom to top of the chart using the [x] value.
  final double x;

  /// Use it for any kind of image, to draw it in bottom side of the chart.
  Image image;

  /// Use it for vector images, to draw it in bottom side of the chart.
  SizedPicture sizedPicture;

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
    this.x,
    this.label,
    Color color = Colors.black,
    double strokeWidth = 2,
    List<int> dashArray,
    this.image,
    this.sizedPicture,
  }) : super(color: color, strokeWidth: strokeWidth, dashArray: dashArray);

  /// Lerps a [VerticalLine] based on [t] value, check [Tween.lerp].
  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) {
    return VerticalLine(
      x: lerpDouble(a.x, b.x, t),
      label: VerticalLineLabel.lerp(a.label, b.label, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      image: b.image,
      sizedPicture: b.sizedPicture,
    );
  }
}

// Shows a text label
abstract class FlLineLabel {

  /// Inner spaces around the drawing text.
  final EdgeInsetsGeometry padding;

  /// Sets style of the drawing text.
  final TextStyle style;

  /// Aligns the text on the line.
  final Alignment alignment;

  /// Draws a title on the line, align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style] for changing color,
  /// size, ... of the text.
  FlLineLabel({this.padding, this.style, this.alignment});
}

/// Draws a title on the [HorizontalLine]
class HorizontalLineLabel extends FlLineLabel {

  /// Resolves a label for showing.
  final String Function(HorizontalLine) labelResolver;

  /// Returns the [HorizontalLine.y] as the drawing label.
  static String defaultLineLabelResolver(HorizontalLine line) => line.y.toString();

  /// Draws a title on the [HorizontalLine], align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style for changing color,
  /// size, ... of the text.
  /// Drawing text will retrieve through [labelResolver],
  /// you can override it with your custom data.
  HorizontalLineLabel({
    EdgeInsets padding,
    TextStyle style,
    Alignment alignment = Alignment.topLeft,
    this.labelResolver = HorizontalLineLabel.defaultLineLabelResolver,
  }) : super(padding: padding, style: style, alignment: alignment);

  /// Lerps a [HorizontalLineLabel] based on [t] value, check [Tween.lerp].
  static HorizontalLineLabel lerp(HorizontalLineLabel a, HorizontalLineLabel b, double t) {
    return HorizontalLineLabel(
      padding: EdgeInsets.lerp(a.padding, b.padding, t),
      style: TextStyle.lerp(a.style, b.style, t),
      alignment: Alignment.lerp(a.alignment, b.alignment, t),
      labelResolver: b.labelResolver,
    );
  }
}

/// Draws a title on the [VerticalLine]
class VerticalLineLabel extends FlLineLabel {

  /// Resolves a label for showing.
  final String Function(VerticalLine) labelResolver;

  /// Returns the [VerticalLine.x] as the drawing label.
  static String defaultLineLabelResolver(VerticalLine line) => line.x.toString();

  /// Draws a title on the [VerticalLine], align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style for changing color,
  /// size, ... of the text.
  /// Drawing text will retrieve through [labelResolver],
  /// you can override it with your custom data.
  VerticalLineLabel({
    EdgeInsets padding,
    TextStyle style,
    Alignment alignment = Alignment.bottomRight,
    this.labelResolver = VerticalLineLabel.defaultLineLabelResolver,
  }) : super(padding: padding, style: style, alignment: alignment);

  /// Lerps a [VerticalLineLabel] based on [t] value, check [Tween.lerp].
  static VerticalLineLabel lerp(VerticalLineLabel a, VerticalLineLabel b, double t) {
    return VerticalLineLabel(
      padding: EdgeInsets.lerp(a.padding, b.padding, t),
      style: TextStyle.lerp(a.style, b.style, t),
      alignment: Alignment.lerp(a.alignment, b.alignment, t),
      labelResolver: b.labelResolver,
    );
  }

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
class SizedPicture {

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
}

/// Draws some straight horizontal or vertical lines in the [LineChart]
class ExtraLinesData {

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
  const ExtraLinesData(
      {this.horizontalLines = const [],
      this.verticalLines = const [],
      this.extraLinesOnTop = true});

  /// Lerps a [ExtraLinesData] based on [t] value, check [Tween.lerp].
  static ExtraLinesData lerp(ExtraLinesData a, ExtraLinesData b, double t) {
    return ExtraLinesData(
      extraLinesOnTop: b.extraLinesOnTop,
      horizontalLines: lerpHorizontalLineList(a.horizontalLines, b.horizontalLines, t),
      verticalLines: lerpVerticalLineList(a.verticalLines, b.verticalLines, t),
    );
  }
}

/// Holds data to handle touch events, and touch responses in the [LineChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [LineTouchResponse].
class LineTouchData extends FlTouchData {

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
  final Function(LineTouchResponse) touchCallback;

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
  const LineTouchData({
    bool enabled = true,
    this.touchTooltipData = const LineTouchTooltipData(),
    this.getTouchedSpotIndicator = defaultTouchedIndicators,
    this.touchSpotThreshold = 10,
    this.fullHeightTouchLine = false,
    this.handleBuiltInTouches = true,
    this.touchCallback,
  }) : super(enabled);

  LineTouchData copyWith({
    bool enabled,
    bool fullHeightTouchLine,
    LineTouchTooltipData touchTooltipData,
    GetTouchedSpotIndicator getTouchedSpotIndicator,
    double touchSpotThreshold,
    Function(LineTouchResponse) touchCallback,
  }) {
    return LineTouchData(
      enabled: enabled ?? this.enabled,
      fullHeightTouchLine: fullHeightTouchLine ?? this.fullHeightTouchLine,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      getTouchedSpotIndicator: getTouchedSpotIndicator ?? this.getTouchedSpotIndicator,
      touchSpotThreshold: touchSpotThreshold ?? this.touchSpotThreshold,
      touchCallback: touchCallback ?? this.touchCallback,
    );
  }
}

/// Used for showing touch indicators (a thicker line and larger dot on the targeted spot).
///
/// It gives you the [spotIndexes] that touch happened, or manually targeted,
/// in the given [barData], you should return a list of [TouchedSpotIndicatorData],
/// length of this list should be equal to the [spotIndexes.length],
/// each [TouchedSpotIndicatorData] determines the look of showing indicator.
typedef GetTouchedSpotIndicator = List<TouchedSpotIndicatorData> Function(
  LineChartBarData barData, List<int> spotIndexes);

/// Default presentation of touched indicators.
List<TouchedSpotIndicatorData> defaultTouchedIndicators(
  LineChartBarData barData, List<int> indicators) {
  if (indicators == null) {
    return [];
  }
  return indicators.map((int index) {
    /// Indicator Line
    Color lineColor = barData.colors[0];
    if (barData.dotData.show) {
      lineColor = barData.dotData.dotColor;
    }
    const double lineStrokeWidth = 4;
    final FlLine flLine = FlLine(color: lineColor, strokeWidth: lineStrokeWidth);

    /// Indicator dot
    double dotSize = 10;
    Color dotColor = barData.colors[0];
    if (barData.dotData.show) {
      dotSize = barData.dotData.dotSize * 1.8;
      dotColor = barData.dotData.dotColor;
    }
    final dotData = FlDotData(
      dotSize: dotSize,
      dotColor: dotColor,
    );

    return TouchedSpotIndicatorData(flLine, dotData);
  }).toList();
}

/// Holds representation data for showing tooltip popup on top of spots.
class LineTouchTooltipData {

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
  const LineTouchTooltipData({
    this.tooltipBgColor = Colors.white,
    this.tooltipRoundedRadius = 4,
    this.tooltipPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.tooltipBottomMargin = 16,
    this.maxContentWidth = 120,
    this.getTooltipItems = defaultLineTooltipItem,
    this.fitInsideHorizontally = false,
    this.fitInsideVertically = false,
  }) : super();
}

/// Provides a [LineTooltipItem] for showing content inside the [LineTouchTooltipData].
///
/// You can override [LineTouchTooltipData.getTooltipItems], it gives you
/// [touchedSpots] list that touch happened on,
/// then you should and pass your custom [LineTooltipItem] list
/// (length should be equal to the [touchedSpots.length]),
/// to show inside the tooltip popup.
typedef GetLineTooltipItems = List<LineTooltipItem> Function(List<LineBarSpot> touchedSpots);

/// Default implementation for [LineTouchTooltipData.getTooltipItems].
List<LineTooltipItem> defaultLineTooltipItem(List<LineBarSpot> touchedSpots) {
  if (touchedSpots == null) {
    return null;
  }

  return touchedSpots.map((LineBarSpot touchedSpot) {
    if (touchedSpot == null) {
      return null;
    }
    final TextStyle textStyle = TextStyle(
      color: touchedSpot.bar.colors[0],
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return LineTooltipItem(touchedSpot.y.toString(), textStyle);
  }).toList();
}

/// Represent a targeted spot inside a line bar.
class LineBarSpot extends FlSpot {

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
}

/// Holds data of showing each row item in the tooltip popup.
class LineTooltipItem {

  /// Showing text.
  final String text;

  /// Style of showing text.
  final TextStyle textStyle;

  /// Shows a [text] with [textStyle] as a row in the tooltip popup.
  LineTooltipItem(this.text, this.textStyle);
}

/// details of showing indicator when touch happened on [LineChart]
/// [indicatorBelowLine] we draw a vertical line below of the touched spot
/// [touchedSpotDotData] we draw a larger dot on the touched spot to bold it
class TouchedSpotIndicatorData {

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
}

/// Holds information about touch response in the [LineChart].
///
/// You can override [LineTouchData.touchCallback] to handle touch events,
/// it gives you a [LineTouchResponse] and you can do whatever you want.
class LineTouchResponse extends BaseTouchResponse {

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
}



/// It lerps a [LineChartData] to another [LineChartData] (handles animation for updating values)
class LineChartDataTween extends Tween<LineChartData> {
  LineChartDataTween({LineChartData begin, LineChartData end}) : super(begin: begin, end: end);

  /// Lerps a [LineChartData] based on [t] value, check [Tween.lerp].
  @override
  LineChartData lerp(double t) => begin.lerp(begin, end, t);
}