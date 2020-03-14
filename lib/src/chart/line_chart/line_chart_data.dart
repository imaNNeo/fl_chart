import 'dart:async';
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
/// It gives you the checking spot, and you have to decide to
/// show or not show the line on the provided spot.
typedef CheckToShowSpotLine = bool Function(FlSpot spot);

/// Shows all spot lines.
bool showAllSpotsBelowLine(FlSpot spot) {
  return true;
}

/// Holds data for showing dots on the bar line.
class FlDotData {
  final bool show;
  final Color dotColor;
  final double dotSize;

  /// with this field you can determine which dot should show,
  /// for example you can draw just the last spot dot.
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

/// horizontal lines draw from left to right of the chart,
/// and the y is dynamic
///
/// Holds data for drawing extra horizontal lines.
///
/// [LineChart] draws some [HorizontalLine] (set by [LineChartData.extraLinesData]),
/// in below or above of everything, it draws from left to right side of the chart.
class HorizontalLine extends FlLine {
  final double y;
  Image image;
  SizedPicture sizedPicture;
  final HorizontalLineLabel label;

  /// [LineChart] draws horizontal lines from left to right side of the chart
  /// in the provided [y] axis.
  HorizontalLine({
    this.y,
    this.label,
    Color color = Colors.black,
    double strokeWidth = 2,
    List<int> dashArray,
    this.image,
    this.sizedPicture,
  }) : super(color: color, strokeWidth: strokeWidth, dashArray: dashArray);

  static HorizontalLine lerp(HorizontalLine a, HorizontalLine b, double t) {
    return HorizontalLine(
      y: lerpDouble(a.y, b.y, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      image: b.image,
      sizedPicture: b.sizedPicture,
    );
  }
}

/// vertical lines draw from bottom to top of the chart
/// and the x is dynamic
class VerticalLine extends FlLine {
  final double x;
  Image image;
  SizedPicture sizedPicture;
  final VerticalLineLabel label;

  VerticalLine({
    this.x,
    this.label,
    Color color = Colors.black,
    double strokeWidth = 2,
    List<int> dashArray,
    this.image,
    this.sizedPicture,
  }) : super(color: color, strokeWidth: strokeWidth, dashArray: dashArray);

  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) {
    return VerticalLine(
      x: lerpDouble(a.x, b.x, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      image: b.image,
      sizedPicture: b.sizedPicture,
    );
  }
}

// Lines labels
class FlLineLabel {
  final EdgeInsetsGeometry padding;
  final TextStyle style;
  final Alignment alignment;

  FlLineLabel({this.padding, this.style, this.alignment});
}

class HorizontalLineLabel extends FlLineLabel {
  final String Function(HorizontalLine) labelResolver;
  static String defaultLineLabelResolver(HorizontalLine line) => line.y.toString();

  HorizontalLineLabel({
    EdgeInsets padding,
    TextStyle style,
    Alignment alignment = Alignment.topLeft,
    this.labelResolver = HorizontalLineLabel.defaultLineLabelResolver,
  }) : super(padding: padding, style: style, alignment: alignment);
}

class VerticalLineLabel extends FlLineLabel {
  final String Function(VerticalLine) labelResolver;
  static String defaultLineLabelResolver(VerticalLine line) => line.x.toString();

  VerticalLineLabel({
    EdgeInsets padding,
    TextStyle style,
    Alignment alignment = Alignment.bottomRight,
    this.labelResolver = VerticalLineLabel.defaultLineLabelResolver,
  }) : super(padding: padding, style: style, alignment: alignment);
}

/// we use ExtraLinesData to draw straight horizontal and vertical lines,
/// for example if you want show the average values of the y axis,
/// you can calculate the average and draw a vertical line by setting the y.
class ExtraLinesData {
  final List<HorizontalLine> horizontalLines;
  final List<VerticalLine> verticalLines;

  final bool extraLinesOnTop;

  const ExtraLinesData(
      {this.horizontalLines = const [],
      this.verticalLines = const [],
      this.extraLinesOnTop = true});

  static ExtraLinesData lerp(ExtraLinesData a, ExtraLinesData b, double t) {
    return ExtraLinesData(
      extraLinesOnTop: b.extraLinesOnTop,
      horizontalLines: lerpHorizontalLineList(a.horizontalLines, b.horizontalLines, t),
      verticalLines: lerpVerticalLineList(a.verticalLines, b.verticalLines, t),
    );
  }
}

/// if user touched the chart, we indicate the touched spots with a below line,
/// and make a bigger dot on that spot,
/// here we get the [TouchedSpotIndicatorData] from the given [LineTouchedSpot].
typedef GetTouchedSpotIndicator = List<TouchedSpotIndicatorData> Function(
    LineChartBarData barData, List<int> spotIndexes);

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

/// holds data for handling touch events on the [LineChart]
class LineTouchData extends FlTouchData {
  /// show a tooltip on touched spots
  final LineTouchTooltipData touchTooltipData;

  /// show the indicator line and dot at the touched spot
  /// return null if you don't want to show any indicator on each spot
  final GetTouchedSpotIndicator getTouchedSpotIndicator;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  /// set this true if you want the built in touch handling
  /// (show a tooltip bubble and an indicator on touched spots)
  final bool handleBuiltInTouches;

  /// if you want the touchline to reach the top of the chart
  final bool fullHeightTouchLine;

  /// you can implement it to receive touches callback
  final Function(LineTouchResponse) touchCallback;

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

/// Holds information for showing tooltip on axis based charts
/// when a touch event happened
class LineTouchTooltipData {
  final Color tooltipBgColor;
  final double tooltipRoundedRadius;
  final EdgeInsets tooltipPadding;
  final double tooltipBottomMargin;
  final double maxContentWidth;
  final GetLineTooltipItems getTooltipItems;
  final bool fitInsideHorizontally;
  final bool fitInsideVertically;

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

/// show each LineTooltipItem as a row on the tooltip window,
/// return null if you don't want to show each item
/// if user touched the chart, we show a tooltip window on the most top [TouchSpot],
/// here we get the [LineTooltipItem] from the given [TouchedSpot].
typedef GetLineTooltipItems = List<LineTooltipItem> Function(List<LineBarSpot> touchedSpots);

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

/// holds the details of a [FlSpot] inside a [LineChartBarData]
///
///
class LineBarSpot extends FlSpot {
  final LineChartBarData bar;
  final int barIndex;
  final int spotIndex;

  LineBarSpot(
    this.bar,
    this.barIndex,
    FlSpot spot,
    )   : spotIndex = bar.spots.indexOf(spot),
      super(spot.x, spot.y);
}

/// holds data of showing each item in the tooltip window
class LineTooltipItem {
  final String text;
  final TextStyle textStyle;

  LineTooltipItem(this.text, this.textStyle);
}

/// details of showing indicator when touch happened on [LineChart]
/// [indicatorBelowLine] we draw a vertical line below of the touched spot
/// [touchedSpotDotData] we draw a larger dot on the touched spot to bold it
class TouchedSpotIndicatorData {
  final FlLine indicatorBelowLine;
  final FlDotData touchedSpotDotData;

  TouchedSpotIndicatorData(this.indicatorBelowLine, this.touchedSpotDotData);
}

/// holds the data of touch response on the [LineChart]
/// used in the [LineTouchData] in a [StreamSink]
class LineTouchResponse extends BaseTouchResponse {
  /// touch happened on these spots
  /// (if a single line provided on the chart, [lineBarSpots]'s length will be 1 always)
  final List<LineBarSpot> lineBarSpots;

  LineTouchResponse(
    this.lineBarSpots,
    FlTouchInput touchInput,
  ) : super(touchInput);
}

class LineChartDataTween extends Tween<LineChartData> {
  LineChartDataTween({LineChartData begin, LineChartData end}) : super(begin: begin, end: end);

  @override
  LineChartData lerp(double t) => begin.lerp(begin, end, t);
}

class SizedPicture {
  Picture picture;
  int width;
  int height;

  SizedPicture(this.picture, this.width, this.height);
}
