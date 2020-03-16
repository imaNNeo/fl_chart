import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

/// This is the base class for axis base charts data
/// that contains a [FlGridData] that holds data for showing grid lines,
/// also we have [minX], [maxX], [minY], [maxY] values
/// we use them to determine how much is the scale of chart,
/// and calculate x and y according to the scale.
/// each child have to set it in their constructor.
abstract class AxisChartData extends BaseChartData {
  final FlGridData gridData;
  final FlAxisTitleData axisTitleData;
  final RangeAnnotations rangeAnnotations;

  double minX, maxX;
  double minY, maxY;

  /// clip the chart to the border (prevent draw outside the border)
  bool clipToBorder;

  /// A background color which is drawn behind th chart.
  Color backgroundColor;

  AxisChartData({
    this.gridData = const FlGridData(),
    FlBorderData borderData,
    FlTouchData touchData,
    this.axisTitleData,
    this.rangeAnnotations = const RangeAnnotations(),
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
    this.clipToBorder = false,
    this.backgroundColor,
  }) : super(borderData: borderData, touchData: touchData);
}

/// Holds data for showing a title in each side (left, top, right, bottom) of the chart.
class FlAxisTitleData {
  final bool show;

  final AxisTitle leftTitle, topTitle, rightTitle, bottomTitle;

  /// [show] determines showing or hiding all titles,
  /// [leftTitle], [topTitle], [rightTitle], [bottomTitle] determines
  /// title for left, top, right, bottom axis sides respectively.
  const FlAxisTitleData({
    this.show = true,
    this.leftTitle = const AxisTitle(reservedSize: 16),
    this.topTitle = const AxisTitle(reservedSize: 16),
    this.rightTitle = const AxisTitle(reservedSize: 16),
    this.bottomTitle = const AxisTitle(reservedSize: 16),
  });

  /// Lerps a [FlAxisTitleData] based on [t] value, check [Tween.lerp].
  static FlAxisTitleData lerp(FlAxisTitleData a, FlAxisTitleData b, double t) {
    return FlAxisTitleData(
      show: b.show,
      leftTitle: AxisTitle.lerp(a.leftTitle, b.leftTitle, t),
      rightTitle: AxisTitle.lerp(a.rightTitle, b.rightTitle, t),
      bottomTitle: AxisTitle.lerp(a.bottomTitle, b.bottomTitle, t),
      topTitle: AxisTitle.lerp(a.topTitle, b.topTitle, t),
    );
  }
}

/// Holds data for showing title of each side of charts.
class AxisTitle {

  /// You can show or hide it using [showTitle],
  final bool showTitle;

  /// Defines how much space it needed to draw.
  final double reservedSize;

  /// Determines the style of this.
  final TextStyle textStyle;

  /// Determines alignment of this title.
  final TextAlign textAlign;

  /// Determines margin of this title.
  final double margin;

  /// Determines the showing text.
  final String titleText;

  /// You can show or hide it using [showTitle],
  /// [titleText] determines the text, and
  /// [textStyle] determines the style of this.
  /// [textAlign] determines alignment of this title,
  /// [BaseChartPainter] uses [reservedSize] for assigning
  /// a space for drawing this side title, it used for
  /// some calculations.
  /// [margin] determines margin of this title.
  const AxisTitle({
    this.showTitle = false,
    this.titleText = '',
    this.reservedSize = 14,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.textAlign = TextAlign.center,
    this.margin = 4,
  });

  static AxisTitle lerp(AxisTitle a, AxisTitle b, double t) {
    return AxisTitle(
      showTitle: b.showTitle,
      titleText: b.titleText,
      reservedSize: lerpDouble(a.reservedSize, b.reservedSize, t),
      textStyle: TextStyle.lerp(a.textStyle.copyWith(fontSize: a.textStyle.fontSize),
        b.textStyle.copyWith(fontSize: b.textStyle.fontSize), t),
      textAlign: b.textAlign,
      margin: lerpDouble(a.margin, b.margin, t),
    );
  }
}

/// Holds data for showing titles on each side of charts (a title per each axis value).
class FlTitlesData {
  final bool show;

  final SideTitles leftTitles, topTitles, rightTitles, bottomTitles;

  /// [show] determines showing or hiding all titles,
  /// [leftTitles], [topTitles], [rightTitles], [bottomTitles] defines
  /// side titles of left, top, right, bottom sides respectively.
  const FlTitlesData({
    this.show = true,
    this.leftTitles = const SideTitles(reservedSize: 40, showTitles: true),
    this.topTitles = const SideTitles(reservedSize: 6),
    this.rightTitles = const SideTitles(
      reservedSize: 40,
    ),
    this.bottomTitles = const SideTitles(reservedSize: 22, showTitles: true),
  });

  static FlTitlesData lerp(FlTitlesData a, FlTitlesData b, double t) {
    return FlTitlesData(
      show: b.show,
      leftTitles: SideTitles.lerp(a.leftTitles, b.leftTitles, t),
      rightTitles: SideTitles.lerp(a.rightTitles, b.rightTitles, t),
      bottomTitles: SideTitles.lerp(a.bottomTitles, b.bottomTitles, t),
      topTitles: SideTitles.lerp(a.topTitles, b.topTitles, t),
    );
  }
}

/// Holds data for showing each side titles (a title per each axis value).
class SideTitles {
  final bool showTitles;
  final GetTitleFunction getTitles;
  final double reservedSize;
  final TextStyle textStyle;
  final double margin;
  final double interval;
  final double rotateAngle;

  /// It draws some title on all axis, per each axis value,
  /// [showTitles] determines showing or hiding this side,
  /// texts are depend on the axis value, you can override [getTitles],
  /// it gives you an axis value (double value), and you should return a string.
  ///
  /// [reservedSize] determines how much space they needed,
  /// [textStyle] determines the text style of them,
  /// [margin] determines margin of texts from the border line,
  ///
  /// by default, texts are showing with 1.0 interval,
  /// you can change this value using [interval],
  ///
  /// you can change rotation of drawing titles using [rotateAngle].
  const SideTitles({
    this.showTitles = false,
    this.getTitles = defaultGetTitle,
    this.reservedSize = 22,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.margin = 6,
    this.interval = 1.0,
    this.rotateAngle = 0.0,
  });

  static SideTitles lerp(SideTitles a, SideTitles b, double t) {
    return SideTitles(
      showTitles: b.showTitles,
      getTitles: b.getTitles,
      reservedSize: lerpDouble(a.reservedSize, b.reservedSize, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      margin: lerpDouble(a.margin, b.margin, t),
      interval: lerpDouble(a.interval, b.interval, t),
      rotateAngle: lerpDouble(a.rotateAngle, b.rotateAngle, t),
    );
  }
}

/// Represents a conceptual position in cartesian (axis based) space.
class FlSpot {
  final double x;
  final double y;

  /// [x] determines cartesian (axis based) horizontally position
  /// 0 means most left point of the chart
  ///
  /// [y] determines cartesian (axis based) vertically position
  /// 0 means most bottom point of the chart
  const FlSpot(this.x, this.y);

  FlSpot copyWith({
    double x,
    double y,
  }) {
    return FlSpot(
      x ?? this.x,
      y ?? this.y,
    );
  }

  static FlSpot lerp(FlSpot a, FlSpot b, double t) {
    return FlSpot(
      lerpDouble(a.x, b.x, t),
      lerpDouble(a.y, b.y, t),
    );
  }
}

/// Responsible to hold grid data,
class FlGridData {

  /// Determines showing or hiding all horizontal and vertical lines.
  final bool show;

  /// Determines showing or hiding all horizontal lines.
  final bool drawHorizontalLine;

  /// Determines interval between horizontal lines.
  final double horizontalInterval;

  /// Gives you a y value, and gets a [FlLine] that represents specified line.
  final GetDrawingGridLine getDrawingHorizontalLine;

  /// Gives you a y value, and gets a boolean that determines showing or hiding specified line.
  final CheckToShowGrid checkToShowHorizontalLine;

  /// Determines showing or hiding all vertical lines.
  final bool drawVerticalLine;

  /// Determines interval between vertical lines.
  final double verticalInterval;

  /// Gives you a x value, and gets a [FlLine] that represents specified line.
  final GetDrawingGridLine getDrawingVerticalLine;

  /// Gives you a x value, and gets a boolean that determines showing or hiding specified line.
  final CheckToShowGrid checkToShowVerticalLine;

  /// Responsible for rendering grid lines behind the content of charts,
  /// [show] determines showing or hiding all grids,
  ///
  /// [AxisChartPainter] draws horizontal lines from left to right of the chart,
  /// with increasing y value, it increases by [horizontalInterval].
  /// Representation of each line determines by [getDrawingHorizontalLine] callback,
  /// it gives you a double value (in the y axis), and you should return a [FlLine] that represents
  /// a horizontal line.
  /// You are allowed to show or hide any horizontal line, using [checkToShowHorizontalLine] callback,
  /// it gives you a double value (in the y axis), and you should return a boolean that determines
  /// showing or hiding specified line.
  /// or you can hide all horizontal lines by setting [drawHorizontalLine] false.
  ///
  /// [AxisChartPainter] draws vertical lines from bottom to top of the chart,
  /// with increasing x value, it increases by [verticalInterval].
  /// Representation of each line determines by [getDrawingVerticalLine] callback,
  /// it gives you a double value (in the x axis), and you should return a [FlLine] that represents
  /// a horizontal line.
  /// You are allowed to show or hide any vertical line, using [checkToShowVerticalLine] callback,
  /// it gives you a double value (in the x axis), and you should return a boolean that determines
  /// showing or hiding specified line.
  /// or you can hide all vertical lines by setting [drawVerticalLine] false.
  const FlGridData({
    this.show = true,
    this.drawHorizontalLine = true,
    this.horizontalInterval = 1.0,
    this.getDrawingHorizontalLine = defaultGridLine,
    this.checkToShowHorizontalLine = showAllGrids,
    this.drawVerticalLine = false,
    this.verticalInterval = 1.0,
    this.getDrawingVerticalLine = defaultGridLine,
    this.checkToShowVerticalLine = showAllGrids,
  });

  static FlGridData lerp(FlGridData a, FlGridData b, double t) {
    return FlGridData(
      show: b.show,
      drawHorizontalLine: b.drawHorizontalLine,
      horizontalInterval: lerpDouble(a.horizontalInterval, b.horizontalInterval, t),
      getDrawingHorizontalLine: b.getDrawingHorizontalLine,
      checkToShowHorizontalLine: b.checkToShowHorizontalLine,
      drawVerticalLine: b.drawVerticalLine,
      verticalInterval: lerpDouble(a.verticalInterval, b.verticalInterval, t),
      getDrawingVerticalLine: b.getDrawingVerticalLine,
      checkToShowVerticalLine: b.checkToShowVerticalLine,
    );
  }
}

/// Determines showing or hiding specified line.
typedef CheckToShowGrid = bool Function(double value);

/// Shows all lines.
bool showAllGrids(double value) {
  return true;
}

/// Determines the appearance of specified line.
///
/// It gives you an axis value (horizontal or vertical),
/// you should pass a [FlLine] that represents style of specified line.
typedef GetDrawingGridLine = FlLine Function(double value);

/// Returns a grey line for all values.
FlLine defaultGridLine(double value) {
  return const FlLine(
    color: Colors.grey,
    strokeWidth: 0.5,
  );
}

/// Defines style of a line.
class FlLine {

  /// Defines color of the line.
  final Color color;

  /// Defines thickness of the line.
  final double strokeWidth;

  /// Defines dash effect of the line.
  ///
  /// it is a circular array of dash offsets and lengths.
  /// For example, the array `[5, 10]` would result in dashes 5 pixels long
  /// followed by blank spaces 10 pixels long.
  final List<int> dashArray;

  /// Renders a line, color it by [color],
  /// thickness is defined by [strokeWidth],
  /// and if you want to have dashed line, you should fill [dashArray],
  /// it is a circular array of dash offsets and lengths.
  /// For example, the array `[5, 10]` would result in dashes 5 pixels long
  /// followed by blank spaces 10 pixels long.
  const FlLine({this.color = Colors.black, this.strokeWidth = 2, this.dashArray});

  static FlLine lerp(FlLine a, FlLine b, double t) {
    return FlLine(
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
    );
  }
}

/// holds information about touched spot on the axis based charts.
abstract class TouchedSpot {

  /// Represents the spot inside our axis based chart,
  /// 0, 0 is bottom left, and 1, 1 is top right.
  final FlSpot spot;

  /// Represents the touch position in device pixels,
  /// 0, 0 is top, left, and 1, 1 is bottom right.
  final Offset offset;

  /// [spot]  represents the spot inside our axis based chart,
  /// 0, 0 is bottom left, and 1, 1 is top right.
  ///
  /// [offset] is the touch position in device pixels,
  /// 0, 0 is top, left, and 1, 1 is bottom right.
  TouchedSpot(
    this.spot,
    this.offset,
  );
}

/// Holds data for rendering horizontal and vertical range annotations.
class RangeAnnotations {
  final List<HorizontalRangeAnnotation> horizontalRangeAnnotations;
  final List<VerticalRangeAnnotation> verticalRangeAnnotations;

  /// Axis based charts can annotate some horizontal and vertical regions,
  /// using [horizontalRangeAnnotations], and [verticalRangeAnnotations] respectively.
  const RangeAnnotations({
    this.horizontalRangeAnnotations = const [],
    this.verticalRangeAnnotations = const [],
  });

  static RangeAnnotations lerp(RangeAnnotations a, RangeAnnotations b, double t) {
    return RangeAnnotations(
      horizontalRangeAnnotations: lerpHorizontalRangeAnnotationList(
        a.horizontalRangeAnnotations, b.horizontalRangeAnnotations, t),
      verticalRangeAnnotations: lerpVerticalRangeAnnotationList(
        a.verticalRangeAnnotations, b.verticalRangeAnnotations, t),
    );
  }
}

/// Defines an annotation region in y (vertical) axis.
class HorizontalRangeAnnotation {

  /// Determines starting point in vertical (y) axis.
  final double y1;

  /// Determines ending point in vertical (y) axis.
  final double y2;

  /// Fills the area with this color.
  final Color color;

  /// Annotates a horizontal region from most left to most right point of the chart, and
  /// from [y1] to [y2], and fills the area with [color].
  HorizontalRangeAnnotation({
    this.y1,
    this.y2,
    this.color = Colors.white,
  });

  static HorizontalRangeAnnotation lerp(
    HorizontalRangeAnnotation a, HorizontalRangeAnnotation b, double t) {
    return HorizontalRangeAnnotation(
      y1: lerpDouble(a.y1, b.y1, t),
      y2: lerpDouble(a.y2, b.y2, t),
      color: Color.lerp(a.color, b.color, t),
    );
  }
}

/// Defines an annotation region in x (horizontal) axis.
class VerticalRangeAnnotation {

  /// Determines starting point in horizontal (x) axis.
  final double x1;

  /// Determines ending point in horizontal (x) axis.
  final double x2;

  /// Fills the area with this color.
  final Color color;


  /// Annotates a vertical region from most bottom to most top point of the chart, and
  /// from [x1] to [x2], and fills the area with [color].
  VerticalRangeAnnotation({
    this.x1,
    this.x2,
    this.color = Colors.white,
  });

  static VerticalRangeAnnotation lerp(
    VerticalRangeAnnotation a, VerticalRangeAnnotation b, double t) {
    return VerticalRangeAnnotation(
      x1: lerpDouble(a.x1, b.x1, t),
      x2: lerpDouble(a.x2, b.x2, t),
      color: Color.lerp(a.color, b.color, t),
    );
  }
}
