// coverage:ignore-file
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart' hide Image;

/// This is the base class for axis base charts data
/// that contains a [FlGridData] that holds data for showing grid lines,
/// also we have [minX], [maxX], [minY], [maxY] values
/// we use them to determine how much is the scale of chart,
/// and calculate x and y according to the scale.
/// each child have to set it in their constructor.
abstract class AxisChartData extends BaseChartData with EquatableMixin {
  AxisChartData({
    FlGridData? gridData,
    required this.titlesData,
    RangeAnnotations? rangeAnnotations,
    required this.minX,
    required this.maxX,
    double? baselineX,
    required this.minY,
    required this.maxY,
    double? baselineY,
    FlClipData? clipData,
    Color? backgroundColor,
    super.borderData,
    ExtraLinesData? extraLinesData,
    this.rotationQuarterTurns = 0,
  })  : gridData = gridData ?? const FlGridData(),
        rangeAnnotations = rangeAnnotations ?? const RangeAnnotations(),
        baselineX = baselineX ?? 0,
        baselineY = baselineY ?? 0,
        clipData = clipData ?? const FlClipData.none(),
        backgroundColor = backgroundColor ?? Colors.transparent,
        extraLinesData = extraLinesData ?? const ExtraLinesData();
  final FlGridData gridData;
  final FlTitlesData titlesData;
  final RangeAnnotations rangeAnnotations;

  final double minX;
  final double maxX;
  final double baselineX;
  final double minY;
  final double maxY;
  final double baselineY;

  /// clip the chart to the border (prevent draw outside the border)
  final FlClipData clipData;

  /// A background color which is drawn behind the chart.
  final Color backgroundColor;

  /// Difference of [maxY] and [minY]
  double get verticalDiff => maxY - minY;

  /// Difference of [maxX] and [minX]
  double get horizontalDiff => maxX - minX;

  /// Extra horizontal or vertical lines to draw on the chart.
  final ExtraLinesData extraLinesData;

  /// Rotates the chart by 90 degrees clockwise in each turn
  final int rotationQuarterTurns;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        gridData,
        titlesData,
        rangeAnnotations,
        minX,
        maxX,
        baselineX,
        minY,
        maxY,
        baselineY,
        clipData,
        backgroundColor,
        borderData,
        extraLinesData,
        rotationQuarterTurns,
      ];
}

/// This class holds the touch response details of the axis-based charts
abstract class AxisBaseTouchResponse extends BaseTouchResponse {
  AxisBaseTouchResponse({
    required super.touchLocation,
    required this.touchChartCoordinate,
  });

  /// The axis coordinate of the touch in chart's coordinate system.
  final Offset touchChartCoordinate;
}

/// Represents a side of the chart
enum AxisSide {
  left,
  top,
  right,
  bottom;

  AxisSide rotateByQuarterTurns(int quarterTurns) {
    const values = AxisSide.values;
    return values[(values.indexOf(this) + quarterTurns) % values.length];
  }
}

/// Represents where the [SideTitles] are drawn in relation to the chart.
enum SideTitleAlignment { outside, border, inside }

/// Contains meta information about the drawing title.
class TitleMeta {
  TitleMeta({
    required this.min,
    required this.max,
    required this.parentAxisSize,
    required this.axisPosition,
    required this.appliedInterval,
    required this.sideTitles,
    required this.formattedValue,
    required this.axisSide,
    required this.rotationQuarterTurns,
  }) : assert(
          rotationQuarterTurns >= 0,
          "TitleMeta.rotationQuarterTurns couldn't be negative",
        );

  /// min axis value
  final double min;

  /// max axis value
  final double max;

  /// parent axis max width/height
  final double parentAxisSize;

  /// The position (in pixel) that applied to
  /// this drawing title along its axis.
  final double axisPosition;

  /// The interval that applied to this drawing title
  final double appliedInterval;

  /// Reference of [SideTitles] object.
  final SideTitles sideTitles;

  /// Formatted value that is suitable to show, for example 100, 2k, 5m, ...
  final String formattedValue;

  /// Determines the axis side of titles (left, top, right, bottom)
  final AxisSide axisSide;

  /// Chart is rotated by 90 degrees clockwise in each turn
  ///
  /// default is zero, which means chart is normal and upward
  final int rotationQuarterTurns;
}

/// It gives you the axis value and gets a String value based on it.
typedef GetTitleWidgetFunction = Widget Function(double value, TitleMeta meta);

/// The default [SideTitles.getTitlesWidget] function.
///
/// formats the axis number to a shorter string using [formatNumber].
Widget defaultGetTitle(double value, TitleMeta meta) {
  return SideTitleWidget(
    meta: meta,
    child: Text(
      meta.formattedValue,
    ),
  );
}

/// Holds data for showing label values on axis numbers
class SideTitles with EquatableMixin {
  /// It draws some title on an axis, per axis values,
  /// [showTitles] determines showing or hiding this side,
  ///
  /// Texts are depend on the axis value, you can override [getTitles],
  /// it gives you an axis value (double value) and a [TitleMeta] which contains
  /// additional information about the axis.
  /// Then you should return a [Widget] to show.
  /// It allows you to do anything you want, For example you can show icons
  /// instead of texts, because it accepts a [Widget]
  ///
  /// [reservedSize] determines the maximum space that your titles need,
  /// (All titles will stretch using this value)
  ///
  /// Texts are showing with provided [interval]. If you don't provide anything,
  /// we try to find a suitable value to set as [interval] under the hood.
  const SideTitles({
    this.showTitles = false,
    this.getTitlesWidget = defaultGetTitle,
    this.reservedSize = 22,
    this.interval,
    this.minIncluded = true,
    this.maxIncluded = true,
  }) : assert(interval != 0, "SideTitles.interval couldn't be zero");

  /// Determines showing or hiding this side titles
  final bool showTitles;

  /// You can override it to pass your custom widget to show in each axis value
  /// We recommend you to use [SideTitleWidget].
  ///
  /// If you decide to implement your custom widget
  /// (instead of [SideTitleWidget]), you have to take care of the alignment,
  /// space to the chart and also the rotation (if you are rotating the chart,
  /// for example for Horizontal Bar Chart)
  final GetTitleWidgetFunction getTitlesWidget;

  /// It determines the maximum space that your titles need,
  /// (All titles will stretch using this value)
  final double reservedSize;

  /// Texts are showing with provided [interval]. If you don't provide anything,
  /// we try to find a suitable value to set as [interval] under the hood.
  final double? interval;

  /// If true (default), a title for the minimum data value is included
  /// independent of the sampling interval
  final bool minIncluded;

  /// If true (default), a title for the maximum data value is included
  /// independent of the sampling interval
  final bool maxIncluded;

  /// Lerps a [SideTitles] based on [t] value, check [Tween.lerp].
  static SideTitles lerp(SideTitles a, SideTitles b, double t) => SideTitles(
        showTitles: b.showTitles,
        getTitlesWidget: b.getTitlesWidget,
        reservedSize: lerpDouble(a.reservedSize, b.reservedSize, t)!,
        interval: lerpDouble(a.interval, b.interval, t),
        minIncluded: b.minIncluded,
        maxIncluded: b.maxIncluded,
      );

  /// Copies current [SideTitles] to a new [SideTitles],
  /// and replaces provided values.
  SideTitles copyWith({
    bool? showTitles,
    GetTitleWidgetFunction? getTitlesWidget,
    double? reservedSize,
    double? interval,
    bool? minIncluded,
    bool? maxIncluded,
  }) =>
      SideTitles(
        showTitles: showTitles ?? this.showTitles,
        getTitlesWidget: getTitlesWidget ?? this.getTitlesWidget,
        reservedSize: reservedSize ?? this.reservedSize,
        interval: interval ?? this.interval,
        minIncluded: minIncluded ?? this.minIncluded,
        maxIncluded: maxIncluded ?? this.maxIncluded,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        showTitles,
        getTitlesWidget,
        reservedSize,
        interval,
        minIncluded,
        maxIncluded,
      ];
}

/// Force child widget to be positioned inside its
/// corresponding axis bounding box
///
/// To makes things simpler, it's recommended to use
/// [SideTitleFitInsideData.fromTitleMeta] and pass the
/// TitleMeta provided from [SideTitles.getTitlesWidget]
class SideTitleFitInsideData with EquatableMixin {
  /// Force child widget to be positioned inside its
  /// corresponding axis bounding box
  ///
  /// To makes things simpler, it's recommended to use
  /// [SideTitleFitInsideData.fromTitleMeta] and pass the
  /// TitleMeta provided from [SideTitles.getTitlesWidget]
  ///
  /// Some translations will be applied to force
  /// children to be positioned inside the parent axis bounding box.
  ///
  /// Will override the [SideTitleWidget.space] and caused
  /// spacing between [SideTitles] children might be not equal.
  const SideTitleFitInsideData({
    required this.enabled,
    required this.axisPosition,
    required this.parentAxisSize,
    required this.distanceFromEdge,
  });

  /// Create a disabled [SideTitleFitInsideData].
  /// If used, the child widget wouldn't be fitted
  /// inside its corresponding axis bounding box
  factory SideTitleFitInsideData.disable() => const SideTitleFitInsideData(
        enabled: false,
        distanceFromEdge: 0,
        parentAxisSize: 0,
        axisPosition: 0,
      );

  /// Help to Create [SideTitleFitInsideData] from [TitleMeta].
  /// [TitleMeta] is provided by [SideTitles.getTitlesWidget] function.
  factory SideTitleFitInsideData.fromTitleMeta(
    TitleMeta meta, {
    bool enabled = true,
    double distanceFromEdge = 6,
  }) =>
      SideTitleFitInsideData(
        enabled: enabled,
        distanceFromEdge: distanceFromEdge,
        parentAxisSize: meta.parentAxisSize,
        axisPosition: meta.axisPosition,
      );

  /// Whether to enable fit inside to SideTitleWidget
  final bool enabled;

  /// Distance between child widget and its closest corresponding axis edge
  final double distanceFromEdge;

  /// Parent axis max width/height
  final double parentAxisSize;

  /// The position (in pixel) that applied to
  /// the child widget along its corresponding axis.
  final double axisPosition;

  @override
  List<Object?> get props => [
        enabled,
        distanceFromEdge,
        parentAxisSize,
        axisPosition,
      ];
}

/// Holds data for showing each side titles (left, top, right, bottom)
class AxisTitles with EquatableMixin {
  /// you can provide [axisName] if you want to show a general
  /// label on this axis,
  ///
  /// [axisNameSize] determines the maximum size that [axisName] can use
  ///
  /// [sideTitles] property is responsible to show your axis side labels
  const AxisTitles({
    this.axisNameWidget,
    this.axisNameSize = 16,
    this.sideTitles = const SideTitles(),
    this.drawBelowEverything = true,
    this.sideTitleAlignment = SideTitleAlignment.outside,
  });

  /// Determines the size of [axisName]
  final double axisNameSize;

  /// It shows the name of axis, for example your x-axis shows year,
  /// then you might want to show it using [axisNameWidget] property as a widget
  final Widget? axisNameWidget;

  /// It is responsible to show your axis side labels.
  final SideTitles sideTitles;

  /// If titles are showing on top of your tooltip, you can draw them below everything.
  ///
  /// In the future, we will convert tooltips to a widget, that would solve this problem.
  final bool drawBelowEverything;

  /// Where the [SideTitles] are drawn in relation to the chart.
  final SideTitleAlignment sideTitleAlignment;

  /// If there is something to show as axisTitles, it returns true
  bool get showAxisTitles => axisNameWidget != null && axisNameSize != 0;

  /// If there is something to show as sideTitles, it returns true
  bool get showSideTitles =>
      sideTitles.showTitles && sideTitles.reservedSize != 0;

  /// Lerps a [AxisTitles] based on [t] value, check [Tween.lerp].
  static AxisTitles lerp(AxisTitles a, AxisTitles b, double t) => AxisTitles(
        axisNameWidget: b.axisNameWidget,
        axisNameSize: lerpDouble(a.axisNameSize, b.axisNameSize, t)!,
        sideTitles: SideTitles.lerp(a.sideTitles, b.sideTitles, t),
        drawBelowEverything: b.drawBelowEverything,
        sideTitleAlignment: b.sideTitleAlignment,
      );

  /// Copies current [SideTitles] to a new [SideTitles],
  /// and replaces provided values.
  AxisTitles copyWith({
    Widget? axisNameWidget,
    double? axisNameSize,
    SideTitles? sideTitles,
    bool? drawBelowEverything,
    SideTitleAlignment? sideTitleAlignment,
  }) =>
      AxisTitles(
        axisNameWidget: axisNameWidget ?? this.axisNameWidget,
        axisNameSize: axisNameSize ?? this.axisNameSize,
        sideTitles: sideTitles ?? this.sideTitles,
        drawBelowEverything: drawBelowEverything ?? this.drawBelowEverything,
        sideTitleAlignment: sideTitleAlignment ?? this.sideTitleAlignment,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        axisNameWidget,
        axisNameSize,
        sideTitles,
        drawBelowEverything,
        sideTitleAlignment,
      ];
}

/// Holds data for showing titles on each side of charts.
class FlTitlesData with EquatableMixin {
  /// [show] determines showing or hiding all titles,
  /// [leftTitles], [topTitles], [rightTitles], [bottomTitles] defines
  /// side titles of left, top, right, bottom sides respectively.
  const FlTitlesData({
    this.show = true,
    this.leftTitles = const AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 44,
        showTitles: true,
      ),
    ),
    this.topTitles = const AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 30,
        showTitles: true,
      ),
    ),
    this.rightTitles = const AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 44,
        showTitles: true,
      ),
    ),
    this.bottomTitles = const AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 30,
        showTitles: true,
      ),
    ),
  });

  final bool show;
  final AxisTitles leftTitles;
  final AxisTitles topTitles;
  final AxisTitles rightTitles;
  final AxisTitles bottomTitles;

  /// Lerps a [FlTitlesData] based on [t] value, check [Tween.lerp].
  static FlTitlesData lerp(FlTitlesData a, FlTitlesData b, double t) =>
      FlTitlesData(
        show: b.show,
        leftTitles: AxisTitles.lerp(a.leftTitles, b.leftTitles, t),
        rightTitles: AxisTitles.lerp(a.rightTitles, b.rightTitles, t),
        bottomTitles: AxisTitles.lerp(a.bottomTitles, b.bottomTitles, t),
        topTitles: AxisTitles.lerp(a.topTitles, b.topTitles, t),
      );

  /// Copies current [FlTitlesData] to a new [FlTitlesData],
  /// and replaces provided values.
  FlTitlesData copyWith({
    bool? show,
    AxisTitles? leftTitles,
    AxisTitles? topTitles,
    AxisTitles? rightTitles,
    AxisTitles? bottomTitles,
  }) =>
      FlTitlesData(
        show: show ?? this.show,
        leftTitles: leftTitles ?? this.leftTitles,
        topTitles: topTitles ?? this.topTitles,
        rightTitles: rightTitles ?? this.rightTitles,
        bottomTitles: bottomTitles ?? this.bottomTitles,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        leftTitles,
        topTitles,
        rightTitles,
        bottomTitles,
      ];
}

/// Represents a conceptual position in cartesian (axis based) space.
@immutable
class FlSpot {
  /// [x] determines cartesian (axis based) horizontally position
  /// 0 means most left point of the chart
  ///
  /// [y] determines cartesian (axis based) vertically position
  /// 0 means most bottom point of the chart
  const FlSpot(
    this.x,
    this.y, {
    this.xError,
    this.yError,
  });

  final double x;
  final double y;
  final FlErrorRange? xError;
  final FlErrorRange? yError;

  /// Copies current [FlSpot] to a new [FlSpot],
  /// and replaces provided values.
  // Prevent polymorphism
  FlSpot copyWith({
    double? x,
    double? y,
    FlErrorRange? xError,
    FlErrorRange? yError,
  }) =>
      FlSpot(
        x ?? this.x,
        y ?? this.y,
        xError: xError ?? this.xError,
        yError: yError ?? this.yError,
      );

  ///Prints x and y coordinates of FlSpot list
  @override
  String toString() => '($x, $y, $xError, $yError)';

  /// Used for splitting lines, or maybe other concepts.
  static const FlSpot nullSpot = FlSpot(double.nan, double.nan);

  /// Sets zero for x and y
  static const FlSpot zero = FlSpot(0, 0);

  /// Determines if [x] or [y] is null.
  bool isNull() => this == nullSpot;

  /// Determines if [x] and [y] is not null.
  bool isNotNull() => !isNull();

  /// Lerps a [FlSpot] based on [t] value, check [Tween.lerp].
  static FlSpot lerp(FlSpot a, FlSpot b, double t) {
    if (a == FlSpot.nullSpot) {
      return b;
    }

    if (b == FlSpot.nullSpot) {
      return a;
    }

    return FlSpot(
      lerpDouble(a.x, b.x, t)!,
      lerpDouble(a.y, b.y, t)!,
      xError: FlErrorRange.lerp(a.xError, b.xError, t),
      yError: FlErrorRange.lerp(a.yError, b.yError, t),
    );
  }

  /// Two [FlSpot] are equal if their [x] and [y] are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FlSpot) {
      return false;
    }

    if (x.isNaN && y.isNaN && other.x.isNaN && other.y.isNaN) {
      return true;
    }

    return other.x == x &&
        other.y == y &&
        other.xError == xError &&
        other.yError == yError;
  }

  /// Override hashCode
  @override
  int get hashCode =>
      x.hashCode ^ y.hashCode ^ xError.hashCode ^ yError.hashCode;
}

/// Represents a range of values that can be used to show error bars/threshold
///
/// [lowerBy] and [upperBy] are the values that will be added and subtracted
/// from the main value. It means that they should be non-negative.
/// Also it means that they are relative to the main value.
class FlErrorRange with EquatableMixin {
  const FlErrorRange({
    required this.lowerBy,
    required this.upperBy,
  })  : assert(lowerBy >= 0, 'lowerBy must be non-negative'),
        assert(upperBy >= 0, 'upperBy must be non-negative');

  /// Creates a symmetric error range.
  /// It sets [lowerBy] and [upperBy] to the same [value].
  const FlErrorRange.symmetric(double value)
      : lowerBy = value,
        upperBy = value,
        assert(value >= 0, 'value must be non-negative');

  /// determines the lower bound of the error range, it will be subtracted from
  /// the main value. So it is non-negative and it is relative to the main value
  final double lowerBy;

  /// determines the lower bound of the error range, it will be added to
  /// the main value. So it is non-negative and it is relative to the main value
  final double upperBy;

  /// Lerps a [FlErrorRange] based on [t] value
  static FlErrorRange? lerp(FlErrorRange? a, FlErrorRange? b, double t) {
    if (a != null && b != null) {
      return FlErrorRange(
        lowerBy: lerpDouble(a.lowerBy, b.lowerBy, t)!,
        upperBy: lerpDouble(a.upperBy, b.upperBy, t)!,
      );
    }

    return b;
  }

  @override
  List<Object?> get props => [lowerBy, upperBy];
}

/// Responsible to hold grid data,
class FlGridData with EquatableMixin {
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
    this.horizontalInterval,
    this.getDrawingHorizontalLine = defaultGridLine,
    this.checkToShowHorizontalLine = showAllGrids,
    this.drawVerticalLine = true,
    this.verticalInterval,
    this.getDrawingVerticalLine = defaultGridLine,
    this.checkToShowVerticalLine = showAllGrids,
  })  : assert(
          horizontalInterval != 0,
          "FlGridData.horizontalInterval couldn't be zero",
        ),
        assert(
          verticalInterval != 0,
          "FlGridData.verticalInterval couldn't be zero",
        );

  /// Determines showing or hiding all horizontal and vertical lines.
  final bool show;

  /// Determines showing or hiding all horizontal lines.
  final bool drawHorizontalLine;

  /// Determines interval between horizontal lines, left it null to be auto calculated.
  final double? horizontalInterval;

  /// Gives you a y value, and gets a [FlLine] that represents specified line.
  final GetDrawingGridLine getDrawingHorizontalLine;

  /// Gives you a y value, and gets a boolean that determines showing or hiding specified line.
  final CheckToShowGrid checkToShowHorizontalLine;

  /// Determines showing or hiding all vertical lines.
  final bool drawVerticalLine;

  /// Determines interval between vertical lines, left it null to be auto calculated.
  final double? verticalInterval;

  /// Gives you a x value, and gets a [FlLine] that represents specified line.
  final GetDrawingGridLine getDrawingVerticalLine;

  /// Gives you a x value, and gets a boolean that determines showing or hiding specified line.
  final CheckToShowGrid checkToShowVerticalLine;

  /// Lerps a [FlGridData] based on [t] value, check [Tween.lerp].
  static FlGridData lerp(FlGridData a, FlGridData b, double t) => FlGridData(
        show: b.show,
        drawHorizontalLine: b.drawHorizontalLine,
        horizontalInterval:
            lerpDouble(a.horizontalInterval, b.horizontalInterval, t),
        getDrawingHorizontalLine: b.getDrawingHorizontalLine,
        checkToShowHorizontalLine: b.checkToShowHorizontalLine,
        drawVerticalLine: b.drawVerticalLine,
        verticalInterval: lerpDouble(a.verticalInterval, b.verticalInterval, t),
        getDrawingVerticalLine: b.getDrawingVerticalLine,
        checkToShowVerticalLine: b.checkToShowVerticalLine,
      );

  /// Copies current [FlGridData] to a new [FlGridData],
  /// and replaces provided values.
  FlGridData copyWith({
    bool? show,
    bool? drawHorizontalLine,
    double? horizontalInterval,
    GetDrawingGridLine? getDrawingHorizontalLine,
    CheckToShowGrid? checkToShowHorizontalLine,
    bool? drawVerticalLine,
    double? verticalInterval,
    GetDrawingGridLine? getDrawingVerticalLine,
    CheckToShowGrid? checkToShowVerticalLine,
  }) =>
      FlGridData(
        show: show ?? this.show,
        drawHorizontalLine: drawHorizontalLine ?? this.drawHorizontalLine,
        horizontalInterval: horizontalInterval ?? this.horizontalInterval,
        getDrawingHorizontalLine:
            getDrawingHorizontalLine ?? this.getDrawingHorizontalLine,
        checkToShowHorizontalLine:
            checkToShowHorizontalLine ?? this.checkToShowHorizontalLine,
        drawVerticalLine: drawVerticalLine ?? this.drawVerticalLine,
        verticalInterval: verticalInterval ?? this.verticalInterval,
        getDrawingVerticalLine:
            getDrawingVerticalLine ?? this.getDrawingVerticalLine,
        checkToShowVerticalLine:
            checkToShowVerticalLine ?? this.checkToShowVerticalLine,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        drawHorizontalLine,
        horizontalInterval,
        getDrawingHorizontalLine,
        checkToShowHorizontalLine,
        drawVerticalLine,
        verticalInterval,
        getDrawingVerticalLine,
        checkToShowVerticalLine,
      ];
}

/// Determines showing or hiding specified line.
typedef CheckToShowGrid = bool Function(double value);

/// Shows all lines.
bool showAllGrids(double value) => true;

/// Determines the appearance of specified line.
///
/// It gives you an axis [value] (horizontal or vertical),
/// you should pass a [FlLine] that represents style of specified line.
typedef GetDrawingGridLine = FlLine Function(double value);

/// Returns a grey line for all values.
FlLine defaultGridLine(double value) => const FlLine(
      color: Colors.blueGrey,
      strokeWidth: 0.4,
      dashArray: [8, 4],
    );

/// Defines style of a line.
class FlLine with EquatableMixin {
  /// Renders a line, color it by [color],
  /// thickness is defined by [strokeWidth],
  /// and if you want to have dashed line, you should fill [dashArray],
  /// it is a circular array of dash offsets and lengths.
  /// For example, the array `[5, 10]` would result in dashes 5 pixels long
  /// followed by blank spaces 10 pixels long.
  const FlLine({
    Color? color,
    this.gradient,
    this.strokeWidth = 2,
    this.dashArray,
  }) : color = color ??
            ((color == null && gradient == null) ? Colors.black : null);

  /// Defines color of the line.
  final Color? color;

  /// Defines the gradient of the line.
  final Gradient? gradient;

  /// Defines thickness of the line.
  final double strokeWidth;

  /// Defines dash effect of the line.
  ///
  /// it is a circular array of dash offsets and lengths.
  /// For example, the array `[5, 10]` would result in dashes 5 pixels long
  /// followed by blank spaces 10 pixels long.
  final List<int>? dashArray;

  /// Lerps a [FlLine] based on [t] value, check [Tween.lerp].
  static FlLine lerp(FlLine a, FlLine b, double t) => FlLine(
        color: Color.lerp(a.color, b.color, t),
        gradient: Gradient.lerp(a.gradient, b.gradient, t),
        strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t)!,
        dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      );

  /// Copies current [FlLine] to a new [FlLine],
  /// and replaces provided values.
  FlLine copyWith({
    Color? color,
    Gradient? gradient,
    double? strokeWidth,
    List<int>? dashArray,
  }) =>
      FlLine(
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        dashArray: dashArray ?? this.dashArray,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        color,
        gradient,
        strokeWidth,
        dashArray,
      ];
}

/// holds information about touched spot on the axis based charts.
abstract class TouchedSpot with EquatableMixin {
  /// [spot]  represents the spot inside our axis based chart,
  /// 0, 0 is bottom left, and 1, 1 is top right.
  ///
  /// [offset] is the touch position in device pixels,
  /// 0, 0 is top, left, and 1, 1 is bottom right.
  TouchedSpot(
    this.spot,
    this.offset,
  );

  /// Represents the spot inside our axis based chart,
  /// 0, 0 is bottom left, and 1, 1 is top right.
  final FlSpot spot;

  /// Represents the touch position in device pixels,
  /// 0, 0 is top, left, and 1, 1 is bottom right.
  final Offset offset;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        spot,
        offset,
      ];
}

/// Holds data for rendering horizontal and vertical range annotations.
class RangeAnnotations with EquatableMixin {
  /// Axis based charts can annotate some horizontal and vertical regions,
  /// using [horizontalRangeAnnotations], and [verticalRangeAnnotations] respectively.
  const RangeAnnotations({
    this.horizontalRangeAnnotations = const [],
    this.verticalRangeAnnotations = const [],
  });

  final List<HorizontalRangeAnnotation> horizontalRangeAnnotations;
  final List<VerticalRangeAnnotation> verticalRangeAnnotations;

  /// Lerps a [RangeAnnotations] based on [t] value, check [Tween.lerp].
  static RangeAnnotations lerp(
    RangeAnnotations a,
    RangeAnnotations b,
    double t,
  ) =>
      RangeAnnotations(
        horizontalRangeAnnotations: lerpHorizontalRangeAnnotationList(
          a.horizontalRangeAnnotations,
          b.horizontalRangeAnnotations,
          t,
        )!,
        verticalRangeAnnotations: lerpVerticalRangeAnnotationList(
          a.verticalRangeAnnotations,
          b.verticalRangeAnnotations,
          t,
        )!,
      );

  /// Copies current [RangeAnnotations] to a new [RangeAnnotations],
  /// and replaces provided values.
  RangeAnnotations copyWith({
    List<HorizontalRangeAnnotation>? horizontalRangeAnnotations,
    List<VerticalRangeAnnotation>? verticalRangeAnnotations,
  }) =>
      RangeAnnotations(
        horizontalRangeAnnotations:
            horizontalRangeAnnotations ?? this.horizontalRangeAnnotations,
        verticalRangeAnnotations:
            verticalRangeAnnotations ?? this.verticalRangeAnnotations,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        horizontalRangeAnnotations,
        verticalRangeAnnotations,
      ];
}

/// Defines an annotation region in y (vertical) axis.
class HorizontalRangeAnnotation with EquatableMixin {
  /// Annotates a horizontal region from most left to most right point of the chart, and
  /// from [y1] to [y2], and fills the area with [color] or [gradient].
  HorizontalRangeAnnotation({
    required this.y1,
    required this.y2,
    Color? color,
    this.gradient,
  }) : color = color ??
            ((color == null && gradient == null) ? Colors.white : null);

  /// Determines starting point in vertical (y) axis.
  final double y1;

  /// Determines ending point in vertical (y) axis.
  final double y2;

  /// If provided, this [HorizontalRangeAnnotation] draws with this [color]
  /// Otherwise we use [gradient] to draw the background.
  /// It draws with [gradient] if you provide both [color] and [gradient].
  /// If none is provided, it draws with a white color.
  final Color? color;

  /// If provided, this [HorizontalRangeAnnotation] draws with this [gradient]
  /// Otherwise we use [color] to draw the background.
  /// It draws with [gradient] if you provide both [color] and [gradient].
  /// If none is provided, it draws with a white color.
  final Gradient? gradient;

  /// Lerps a [HorizontalRangeAnnotation] based on [t] value, check [Tween.lerp].
  static HorizontalRangeAnnotation lerp(
    HorizontalRangeAnnotation a,
    HorizontalRangeAnnotation b,
    double t,
  ) =>
      HorizontalRangeAnnotation(
        y1: lerpDouble(a.y1, b.y1, t)!,
        y2: lerpDouble(a.y2, b.y2, t)!,
        color: Color.lerp(a.color, b.color, t),
        gradient: Gradient.lerp(a.gradient, b.gradient, t),
      );

  /// Copies current [HorizontalRangeAnnotation] to a new [HorizontalRangeAnnotation],
  /// and replaces provided values.
  HorizontalRangeAnnotation copyWith({
    double? y1,
    double? y2,
    Color? color,
    Gradient? gradient,
  }) =>
      HorizontalRangeAnnotation(
        y1: y1 ?? this.y1,
        y2: y2 ?? this.y2,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        y1,
        y2,
        color,
        gradient,
      ];
}

/// Defines an annotation region in x (horizontal) axis.
class VerticalRangeAnnotation with EquatableMixin {
  /// Annotates a vertical region from most bottom to most top point of the chart, and
  /// from [x1] to [x2], and fills the area with [color] or [gradient].
  VerticalRangeAnnotation({
    required this.x1,
    required this.x2,
    Color? color,
    this.gradient,
  }) : color = color ??
            ((color == null && gradient == null) ? Colors.white : null);

  /// Determines starting point in horizontal (x) axis.
  final double x1;

  /// Determines ending point in horizontal (x) axis.
  final double x2;

  /// If provided, this [VerticalRangeAnnotation] draws with this [color]
  /// Otherwise we use [gradient] to draw the background.
  /// It draws with [gradient] if you provide both [color] and [gradient].
  /// If none is provided, it draws with a white color.
  final Color? color;

  /// If provided, this [VerticalRangeAnnotation] draws with this [gradient]
  /// Otherwise we use [color] to draw the background.
  /// It draws with [gradient] if you provide both [color] and [gradient].
  /// If none is provided, it draws with a white color.
  final Gradient? gradient;

  /// Lerps a [VerticalRangeAnnotation] based on [t] value, check [Tween.lerp].
  static VerticalRangeAnnotation lerp(
    VerticalRangeAnnotation a,
    VerticalRangeAnnotation b,
    double t,
  ) =>
      VerticalRangeAnnotation(
        x1: lerpDouble(a.x1, b.x1, t)!,
        x2: lerpDouble(a.x2, b.x2, t)!,
        color: Color.lerp(a.color, b.color, t),
        gradient: Gradient.lerp(a.gradient, b.gradient, t),
      );

  /// Copies current [VerticalRangeAnnotation] to a new [VerticalRangeAnnotation],
  /// and replaces provided values.
  VerticalRangeAnnotation copyWith({
    double? x1,
    double? x2,
    Color? color,
    Gradient? gradient,
  }) =>
      VerticalRangeAnnotation(
        x1: x1 ?? this.x1,
        x2: x2 ?? this.x2,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        x1,
        x2,
        color,
        gradient,
      ];
}

/// Holds data for drawing extra horizontal lines.
///
/// [LineChart] draws some [HorizontalLine] (set by [LineChartData.extraLinesData]),
/// in below or above of everything, it draws from left to right side of the chart.
class HorizontalLine extends FlLine with EquatableMixin {
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
    super.color,
    super.gradient,
    super.strokeWidth,
    super.dashArray,
    this.image,
    this.sizedPicture,
    this.strokeCap = StrokeCap.butt,
  }) : label = label ?? HorizontalLineLabel();

  /// Draws from left to right of the chart using the [y] value.
  final double y;

  /// Use it for any kind of image, to draw it in left side of the chart.
  final Image? image;

  /// Use it for vector images, to draw it in left side of the chart.
  final SizedPicture? sizedPicture;

  /// Draws a text label over the line.
  final HorizontalLineLabel label;

  /// if not drawing dash line, then this is the StrokeCap for the line.
  /// i.e. if the two ends of the line is round or butt or square.
  final StrokeCap strokeCap;

  /// Lerps a [HorizontalLine] based on [t] value, check [Tween.lerp].
  static HorizontalLine lerp(HorizontalLine a, HorizontalLine b, double t) =>
      HorizontalLine(
        y: lerpDouble(a.y, b.y, t)!,
        label: HorizontalLineLabel.lerp(a.label, b.label, t),
        color: Color.lerp(a.color, b.color, t),
        gradient: Gradient.lerp(a.gradient, b.gradient, t),
        strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t)!,
        dashArray: lerpIntList(a.dashArray, b.dashArray, t),
        image: b.image,
        sizedPicture: b.sizedPicture,
        strokeCap: b.strokeCap,
      );

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
        strokeCap,
      ];
}

/// Holds data for drawing extra vertical lines.
///
/// [LineChart] draws some [VerticalLine] (set by [LineChartData.extraLinesData]),
/// in below or above of everything, it draws from bottom to top side of the chart.
class VerticalLine extends FlLine with EquatableMixin {
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
    super.color,
    super.gradient,
    super.strokeWidth,
    super.dashArray,
    this.image,
    this.sizedPicture,
    this.strokeCap = StrokeCap.butt,
  }) : label = label ?? VerticalLineLabel();

  /// Draws from bottom to top of the chart using the [x] value.
  final double x;

  /// Use it for any kind of image, to draw it in bottom side of the chart.
  final Image? image;

  /// Use it for vector images, to draw it in bottom side of the chart.
  final SizedPicture? sizedPicture;

  /// Draws a text label over the line.
  final VerticalLineLabel label;

  /// if not drawing dash line, then this is the StrokeCap for the line.
  /// i.e. if the two ends of the line is round or butt or square.
  final StrokeCap strokeCap;

  /// Lerps a [VerticalLine] based on [t] value, check [Tween.lerp].
  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) =>
      VerticalLine(
        x: lerpDouble(a.x, b.x, t)!,
        label: VerticalLineLabel.lerp(a.label, b.label, t),
        color: Color.lerp(a.color, b.color, t),
        gradient: Gradient.lerp(a.gradient, b.gradient, t),
        strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t)!,
        dashArray: lerpIntList(a.dashArray, b.dashArray, t),
        image: b.image,
        sizedPicture: b.sizedPicture,
        strokeCap: b.strokeCap,
      );

  /// Copies current [VerticalLine] to a new [VerticalLine]
  /// and replaces provided values.
  VerticalLine copyVerticalLineWith({
    double? x,
    VerticalLineLabel? label,
    Color? color,
    double? strokeWidth,
    List<int>? dashArray,
    Image? image,
    SizedPicture? sizedPicture,
    StrokeCap? strokeCap,
  }) =>
      VerticalLine(
        x: x ?? this.x,
        label: label ?? this.label,
        color: color ?? this.color,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        dashArray: dashArray ?? this.dashArray,
        image: image ?? this.image,
        sizedPicture: sizedPicture ?? this.sizedPicture,
        strokeCap: strokeCap ?? this.strokeCap,
      );

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
        strokeCap,
      ];
}

/// Draws a title on the [HorizontalLine]
class HorizontalLineLabel extends FlLineLabel with EquatableMixin {
  /// Draws a title on the [HorizontalLine], align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style for changing color,
  /// size, ... of the text.
  /// Drawing text will retrieve through [labelResolver],
  /// you can override it with your custom data.
  /// [show] determines showing label or not.
  /// [direction] determines if the direction of the text should be horizontal or vertical.
  HorizontalLineLabel({
    super.padding = const EdgeInsets.all(6),
    super.style,
    super.alignment = Alignment.topLeft,
    super.show = false,
    super.direction = LabelDirection.horizontal,
    this.labelResolver = HorizontalLineLabel.defaultLineLabelResolver,
  });

  /// Resolves a label for showing.
  final String Function(HorizontalLine) labelResolver;

  /// Returns the [HorizontalLine.y] as the drawing label.
  static String defaultLineLabelResolver(HorizontalLine line) =>
      line.y.toStringAsFixed(1);

  /// Lerps a [HorizontalLineLabel] based on [t] value, check [Tween.lerp].
  static HorizontalLineLabel lerp(
    HorizontalLineLabel a,
    HorizontalLineLabel b,
    double t,
  ) =>
      HorizontalLineLabel(
        padding: EdgeInsets.lerp(
          a.padding as EdgeInsets,
          b.padding as EdgeInsets,
          t,
        )!,
        style: TextStyle.lerp(a.style, b.style, t),
        alignment: Alignment.lerp(a.alignment, b.alignment, t)!,
        labelResolver: b.labelResolver,
        show: b.show,
        direction: b.direction,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        labelResolver,
        show,
        padding,
        style,
        alignment,
        direction,
      ];
}

/// Draws a title on the [VerticalLine]
class VerticalLineLabel extends FlLineLabel with EquatableMixin {
  /// Draws a title on the [VerticalLine], align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style for changing color,
  /// size, ... of the text.
  /// Drawing text will retrieve through [labelResolver],
  /// you can override it with your custom data.
  /// [show] determines showing label or not.
  /// [direction] determines if the direction of the text should be horizontal or vertical.
  VerticalLineLabel({
    super.padding = const EdgeInsets.all(6),
    super.style = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    super.alignment = Alignment.bottomRight,
    super.show = false,
    super.direction = LabelDirection.horizontal,
    this.labelResolver = VerticalLineLabel.defaultLineLabelResolver,
  });

  /// Resolves a label for showing.
  final String Function(VerticalLine) labelResolver;

  /// Returns the [VerticalLine.x] as the drawing label.
  static String defaultLineLabelResolver(VerticalLine line) =>
      line.x.toStringAsFixed(1);

  /// Lerps a [VerticalLineLabel] based on [t] value, check [Tween.lerp].
  static VerticalLineLabel lerp(
    VerticalLineLabel a,
    VerticalLineLabel b,
    double t,
  ) =>
      VerticalLineLabel(
        padding: EdgeInsets.lerp(
          a.padding as EdgeInsets,
          b.padding as EdgeInsets,
          t,
        )!,
        style: TextStyle.lerp(a.style, b.style, t),
        alignment: Alignment.lerp(a.alignment, b.alignment, t)!,
        labelResolver: b.labelResolver,
        show: b.show,
        direction: b.direction,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        labelResolver,
        show,
        padding,
        style,
        alignment,
        direction,
      ];
}

/// Holds data for showing a vector image inside the chart.
///
/// for example:
/// ```dart
/// Future<SizedPicture> loadSvg() async {
///    const String rawSvg = 'your svg string';
///    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
///    final sizedPicture = SizedPicture(svgRoot.toPicture(), 14, 14);
///    return sizedPicture;
///  }
/// ```
class SizedPicture with EquatableMixin {
  /// [picture] is the showing image,
  /// it can retrieve from a svg icon,
  /// for example:
  /// ```dart
  ///    const String rawSvg = 'your svg string';
  ///    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
  ///    final picture = svgRoot.toPicture()
  /// ```
  /// [width] and [height] determines the size of our picture.
  SizedPicture(this.picture, this.width, this.height);

  /// Is the showing image.
  final Picture picture;

  /// width of our [picture].
  final int width;

  /// height of our [picture].
  final int height;

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
  /// [LineChart] draws some straight horizontal or vertical lines,
  /// you should set [LineChartData.extraLinesData].
  /// Draws horizontal lines using [horizontalLines],
  /// and vertical lines using [verticalLines].
  ///
  /// If [extraLinesOnTop] sets true, it draws the line above the main bar lines, otherwise
  /// it draws them below the main bar lines.
  const ExtraLinesData({
    this.horizontalLines = const [],
    this.verticalLines = const [],
    this.extraLinesOnTop = true,
  });

  final List<HorizontalLine> horizontalLines;
  final List<VerticalLine> verticalLines;
  final bool extraLinesOnTop;

  /// Lerps a [ExtraLinesData] based on [t] value, check [Tween.lerp].
  static ExtraLinesData lerp(ExtraLinesData a, ExtraLinesData b, double t) =>
      ExtraLinesData(
        extraLinesOnTop: b.extraLinesOnTop,
        horizontalLines: lerpHorizontalLineList(
          a.horizontalLines,
          b.horizontalLines,
          t,
        )!,
        verticalLines: lerpVerticalLineList(
          a.verticalLines,
          b.verticalLines,
          t,
        )!,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        horizontalLines,
        verticalLines,
        extraLinesOnTop,
      ];
}

/// This class contains the interface that all DotPainters should conform to.
abstract class FlDotPainter with EquatableMixin {
  const FlDotPainter();

  /// This method should be overridden to draw the dot shape.
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas);

  /// This method should be overridden to return the size of the shape.
  Size getSize(FlSpot spot);

  /// Used to show default UIs, for example [defaultScatterTooltipItem]
  Color get mainColor;

  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t);

  /// Used to implement touch behaviour of this dot, for example,
  /// it behaves like a square of [getSize]
  /// Check [FlDotCirclePainter.hitTest] for an example of an implementation
  bool hitTest(
    FlSpot spot,
    Offset touched,
    Offset center,
    double extraThreshold,
  ) {
    final size = getSize(spot);
    final spotRect = Rect.fromCenter(
      center: center,
      width: size.width,
      height: size.height,
    );
    final thresholdRect = spotRect.inflate(extraThreshold);
    return thresholdRect.contains(touched);
  }
}

/// This class is an implementation of a [FlDotPainter] that draws
/// a circled shape
class FlDotCirclePainter extends FlDotPainter {
  /// The color of the circle is determined determined by [color],
  /// [radius] determines the radius of the circle.
  /// You can have a stroke line around the circle,
  /// by setting the thickness with [strokeWidth],
  /// and you can change the color of of the stroke with [strokeColor].
  FlDotCirclePainter({
    this.color = Colors.green,
    double? radius,
    this.strokeColor = const Color.fromRGBO(76, 175, 80, 1),
    this.strokeWidth = 0.0,
  }) : radius = radius ?? 4.0;

  /// The fill color to use for the circle
  final Color color;

  /// Customizes the radius of the circle
  final double radius;

  /// The stroke color to use for the circle
  final Color strokeColor;

  /// The stroke width to use for the circle
  final double strokeWidth;

  /// Implementation of the parent class to draw the circle
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    if (strokeWidth != 0.0 && strokeColor.a != 0.0) {
      canvas.drawCircle(
        offsetInCanvas,
        radius + (strokeWidth / 2),
        Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke,
      );
    }
    canvas.drawCircle(
      offsetInCanvas,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  /// Implementation of the parent class to get the size of the circle
  @override
  Size getSize(FlSpot spot) => Size.fromRadius(radius + strokeWidth);

  @override
  Color get mainColor => color;

  FlDotCirclePainter _lerp(
    FlDotCirclePainter a,
    FlDotCirclePainter b,
    double t,
  ) =>
      FlDotCirclePainter(
        color: Color.lerp(a.color, b.color, t)!,
        radius: lerpDouble(a.radius, b.radius, t),
        strokeColor: Color.lerp(a.strokeColor, b.strokeColor, t)!,
        strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t)!,
      );

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is! FlDotCirclePainter || b is! FlDotCirclePainter) {
      return b;
    }
    return _lerp(a, b, t);
  }

  @override
  bool hitTest(
    FlSpot spot,
    Offset touched,
    Offset center,
    double extraThreshold,
  ) {
    final distance = (touched - center).distance.abs();
    return distance < radius + extraThreshold;
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
  /// The color of the square is determined determined by [color],
  /// [size] determines the size of the square.
  /// You can have a stroke line around the square,
  /// by setting the thickness with [strokeWidth],
  /// and you can change the color of of the stroke with [strokeColor].
  FlDotSquarePainter({
    this.color = Colors.green,
    this.size = 4.0,
    this.strokeColor = const Color.fromRGBO(76, 175, 80, 1),
    this.strokeWidth = 1.0,
  });

  /// The fill color to use for the square
  final Color color;

  /// Customizes the size of the square
  final double size;

  /// The stroke color to use for the square
  final Color strokeColor;

  /// The stroke width to use for the square
  final double strokeWidth;

  /// Implementation of the parent class to draw the square
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    if (strokeWidth != 0.0 && strokeColor.a != 0.0) {
      canvas.drawRect(
        Rect.fromCircle(
          center: offsetInCanvas,
          radius: (size / 2) + (strokeWidth / 2),
        ),
        Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke,
      );
    }
    canvas.drawRect(
      Rect.fromCircle(
        center: offsetInCanvas,
        radius: size / 2,
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  /// Implementation of the parent class to get the size of the square
  @override
  Size getSize(FlSpot spot) => Size.square(size + strokeWidth);

  @override
  Color get mainColor => color;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        color,
        size,
        strokeColor,
        strokeWidth,
      ];

  FlDotSquarePainter _lerp(
    FlDotSquarePainter a,
    FlDotSquarePainter b,
    double t,
  ) =>
      FlDotSquarePainter(
        color: Color.lerp(a.color, b.color, t)!,
        size: lerpDouble(a.size, b.size, t)!,
        strokeColor: Color.lerp(a.strokeColor, b.strokeColor, t)!,
        strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t)!,
      );

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is! FlDotSquarePainter || b is! FlDotSquarePainter) {
      return b;
    }
    return _lerp(a, b, t);
  }
}

/// This class is an implementation of a [FlDotPainter] that draws
/// a cross (X mark) shape
class FlDotCrossPainter extends FlDotPainter {
  /// The [color] and [width] properties determines the color and thickness of the cross shape,
  /// [size] determines the width and height of the shape.
  FlDotCrossPainter({
    this.color = Colors.green,
    this.size = 8.0,
    this.width = 2.0,
  });

  /// The fill color to use for the X mark
  final Color color;

  /// Determines size (width and height) of shape.
  final double size;

  /// Determines thickness of X mark.
  final double width;

  /// Implementation of the parent class to draw the cross
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    final path = Path()
      ..moveTo(offsetInCanvas.dx, offsetInCanvas.dy)
      ..relativeMoveTo(-size / 2, -size / 2)
      ..relativeLineTo(size, size)
      ..moveTo(offsetInCanvas.dx, offsetInCanvas.dy)
      ..relativeMoveTo(size / 2, -size / 2)
      ..relativeLineTo(-size, size);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = color;

    canvas.drawPath(path, paint);
  }

  /// Implementation of the parent class to get the size of the circle
  @override
  Size getSize(FlSpot spot) => Size(size, size);

  @override
  Color get mainColor => color;

  FlDotCrossPainter _lerp(
    FlDotCrossPainter a,
    FlDotCrossPainter b,
    double t,
  ) =>
      FlDotCrossPainter(
        color: Color.lerp(a.color, b.color, t)!,
        size: lerpDouble(a.size, b.size, t)!,
        width: lerpDouble(a.width, b.width, t)!,
      );

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is! FlDotCrossPainter || b is! FlDotCrossPainter) {
      return b;
    }
    return _lerp(a, b, t);
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        color,
        size,
        width,
      ];
}

/// Holds the information about the error range of a spot
///
/// We support horizontal and vertical error range/indicator for our axis based
/// charts such as [LineChart], [BarChart] and [PieChart]
///
/// For example, in [LineChart] you can add [FlSpot.xError] and [FlSpot.yError]
/// in your data points, so we can draw error indicators for them.
/// And it works relative to the point that you are setting the error range
///
/// For [BarChart], you can set the [BarChartRodData.toYErrorRange] to have
/// vertical error range for each bar. (relative to [BarChartRodData.toY] value)
///
/// [show] is tru by default, it means that we show
/// the error indicator lines (if you provide them in [FlSpot]s)
///
/// [painter] is a callback that allows you to return a
/// [FlSpotErrorRangePainter] per each data point which is responsible for
/// drawing the error indicator. You can use the default [FlSimpleErrorPainter]
/// or create your own by extending our abstract [FlSpotErrorRangePainter]
class FlErrorIndicatorData<T extends FlSpotErrorRangeCallbackInput>
    with EquatableMixin {
  const FlErrorIndicatorData({
    this.show = true,
    this.painter = _defaultGetSpotRangeErrorPainter,
  });

  /// Determines showing the error indicator or not
  final bool show;

  /// A callback that allows you to return a [FlSpotErrorRangePainter]
  /// per each data point (for example [FlSpot] in line chart)
  final GetSpotRangeErrorPainter<T> painter;

  /// Lerps a [FlErrorIndicatorData] based on [t] value.
  static FlErrorIndicatorData<T> lerp<T extends FlSpotErrorRangeCallbackInput>(
    FlErrorIndicatorData<T> a,
    FlErrorIndicatorData<T> b,
    double t,
  ) =>
      FlErrorIndicatorData<T>(
        show: b.show,
        painter: b.painter,
      );

  @override
  List<Object?> get props => [
        show,
        painter,
      ];
}

/// A callback that allows you to return a [FlSpotErrorRangePainter] based on
/// the provided specific data point (for example [FlSpot] in [LineChart])
///
/// So [input] is different based on the chart type,
/// for example in [LineChart] it will be [LineChartSpotErrorRangeCallbackInput]
typedef GetSpotRangeErrorPainter<T extends FlSpotErrorRangeCallbackInput>
    = FlSpotErrorRangePainter Function(
  T input,
);

/// The default [GetSpotRangeErrorPainter] for [FlErrorIndicatorData],
/// it draws a simple and typical error indicator using [FlSimpleErrorPainter]
FlSpotErrorRangePainter _defaultGetSpotRangeErrorPainter(
  FlSpotErrorRangeCallbackInput input,
) =>
    FlSimpleErrorPainter();

/// The abstract painter that is responsible for drawing the error range of
/// a point in our axis based charts such as [LineChart] and [BarChart]
///
/// It has a [draw] method that you should override to draw the error range
/// as you like
///
/// The default implementation is [FlSpotErrorRangePainter]. It is a simple and
/// common error indicator painter.
///
/// You can see how does it look in the [example app](https://app.flchart.dev/)
abstract class FlSpotErrorRangePainter with EquatableMixin {
  const FlSpotErrorRangePainter();

  /// Draws the error range of a point in our axis based charts
  ///
  /// [canvas] is the canvas that you should draw on it
  /// [offsetInCanvas] is the absolute position/offset of the point in
  /// the canvas that you can use it as your center point
  /// [origin] is the relative point point that you should draw
  /// the error range on it (it is based on the chart values)
  /// [errorRelativeRect] is the relative rect that you should draw the error,
  /// it is absolute and you can shift it with [offsetInCanvas] to draw your
  /// shape inside it.
  /// [axisChartData] is the axis chart data that you can use it to get more
  /// information about the chart
  ///
  /// You can take a look at our default implementation [FlSimpleErrorPainter]
  void draw(
    Canvas canvas,
    Offset offsetInCanvas,
    FlSpot origin,
    Rect errorRelativeRect,
    AxisChartData axisChartData,
  );
}

/// The default implementation of [FlSpotErrorRangePainter]
///
/// It draws a simple and common error indicator for the error range of a point
/// in our axis based charts such as [LineChart] and [BarChart]
///
/// You can see how does it look in the [example app](https://app.flchart.dev/)
///
/// You can customize the lines using [lineColor], [lineWidth], [capLength],
///
/// You can customize the text using [showErrorTexts], [errorTextStyle]
/// and [errorTextDirection]
///
/// You can customize the alignment of the error lines using [crossAlignment]
class FlSimpleErrorPainter extends FlSpotErrorRangePainter with EquatableMixin {
  FlSimpleErrorPainter({
    this.lineColor = Colors.white,
    this.lineWidth = 1.0,
    this.capLength = 8.0,
    this.crossAlignment = 0,
    this.showErrorTexts = false,
    this.errorTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    this.errorTextDirection = TextDirection.ltr,
  }) {
    _linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;
    assert(
      crossAlignment >= -1 && crossAlignment <= 1,
      'crossAlignment must be between -1 (start) and 1 (end)',
    );
  }

  /// The color of the error lines
  final Color lineColor;

  /// The thickness of the error lines
  final double lineWidth;

  /// The length of the cap of the error lines
  final double capLength;

  /// The alignment of the error lines,
  /// it should be between -1 (start) and 1 (end)
  final double crossAlignment;

  /// Determines showing the error texts or not
  final bool showErrorTexts;

  /// The style of the error texts
  final TextStyle errorTextStyle;

  /// The direction of the error texts
  final TextDirection errorTextDirection;

  late final Paint _linePaint;

  @override
  void draw(
    Canvas canvas,
    Offset offsetInCanvas,
    FlSpot origin,
    Rect errorRelativeRect,
    AxisChartData axisChartData,
  ) {
    final rect = errorRelativeRect.shift(offsetInCanvas);
    final hasVerticalError = errorRelativeRect.height != 0;
    if (hasVerticalError) {
      _drawDirectErrorLine(
        canvas,
        Offset(offsetInCanvas.dx, rect.top),
        Offset(offsetInCanvas.dx, rect.bottom),
      );

      if (showErrorTexts) {
        // lower
        _drawErrorText(
          canvas: canvas,
          rect: rect,
          isHorizontal: false,
          isLower: true,
          text: Utils().formatNumber(
            axisChartData.minY,
            axisChartData.maxY,
            origin.y - origin.yError!.lowerBy,
          ),
          textStyle: errorTextStyle,
        );

        // upper
        _drawErrorText(
          canvas: canvas,
          rect: rect,
          isHorizontal: false,
          isLower: false,
          text: Utils().formatNumber(
            axisChartData.minY,
            axisChartData.maxY,
            origin.y + origin.yError!.upperBy,
          ),
          textStyle: errorTextStyle,
        );
      }
    }

    final hasHorizontalError = errorRelativeRect.width != 0;
    if (hasHorizontalError) {
      _drawDirectErrorLine(
        canvas,
        Offset(rect.left, offsetInCanvas.dy),
        Offset(rect.right, offsetInCanvas.dy),
      );

      if (showErrorTexts) {
        // lower
        _drawErrorText(
          canvas: canvas,
          rect: rect,
          isHorizontal: true,
          isLower: true,
          text: Utils().formatNumber(
            axisChartData.minX,
            axisChartData.maxX,
            origin.x - origin.xError!.lowerBy,
          ),
          textStyle: errorTextStyle,
        );

        // upper
        _drawErrorText(
          canvas: canvas,
          rect: rect,
          isHorizontal: true,
          isLower: false,
          text: Utils().formatNumber(
            axisChartData.minX,
            axisChartData.maxX,
            origin.x + origin.xError!.upperBy,
          ),
          textStyle: errorTextStyle,
        );
      }
    }
  }

  void _drawDirectErrorLine(Canvas canvas, Offset from, Offset to) {
    final isLineVertical = from.dx == to.dx;
    final mainLineOffset = crossAlignment * capLength;

    if (isLineVertical) {
      from = Offset(from.dx + mainLineOffset, from.dy);
      to = Offset(to.dx + mainLineOffset, to.dy);
    } else {
      from = Offset(from.dx, from.dy + mainLineOffset);
      to = Offset(to.dx, to.dy + mainLineOffset);
    }

    canvas.drawLine(
      from,
      to,
      _linePaint,
    );

    final t = (crossAlignment + 1) / 2;
    final end = capLength - lerpDouble(0, capLength, t)!;
    final start = capLength - end;
    // Draw edge lines
    if (isLineVertical) {
      canvas
        // draw top cap
        ..drawLine(
          Offset(from.dx - start, from.dy),
          Offset(from.dx + end, from.dy),
          _linePaint,
        )
        // draw bottom cap
        ..drawLine(
          Offset(to.dx - start, to.dy),
          Offset(to.dx + end, to.dy),
          _linePaint,
        );
    } else {
      canvas
        // draw left cap
        ..drawLine(
          Offset(from.dx, from.dy - start),
          Offset(from.dx, from.dy + end),
          _linePaint,
        )
        // draw right cap
        ..drawLine(
          Offset(to.dx, to.dy - start),
          Offset(to.dx, to.dy + end),
          _linePaint,
        );
    }
  }

  void _drawErrorText({
    required Canvas canvas,
    required Rect rect,
    required bool isHorizontal,
    required bool isLower,
    required String text,
    required TextStyle textStyle,
  }) {
    final lowerText = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const spacing = 4.0;
    final textX = isHorizontal
        ? isLower
            ? rect.left - lowerText.width - spacing
            : rect.right + spacing
        : rect.center.dx - lowerText.width / 2;

    final textY = isHorizontal
        ? rect.center.dy - lowerText.height / 2
        : isLower
            ? rect.bottom + spacing
            : rect.top - lowerText.width - spacing;

    lowerText.paint(
      canvas,
      Offset(
        textX,
        textY,
      ),
    );
  }

  @override
  List<Object?> get props => [
        lineColor,
        lineWidth,
        capLength,
        crossAlignment,
        showErrorTexts,
        errorTextStyle,
        errorTextDirection,
      ];
}

/// The abstract class that is used as the input of
/// the [GetSpotRangeErrorPainter] callback.
///
/// So as you know, we have this feature in our axis-based charts and each chart
/// has its own input type, for example in [LineChart]
/// it is [LineChartSpotErrorRangeCallbackInput] (which contains the [FlSpot])
abstract class FlSpotErrorRangeCallbackInput with EquatableMixin {}

typedef ValueInCanvasProvider = double Function(double axisValue);

/// The class to hold the information about showing a specific point
/// in the axis-based charts
///
/// You can use the [x] and [y] properties to set the point, Otherwise it
/// uses the touch point (if `handleBuiltinTouches` is true)
///
/// There's a [painter] property that manages the drawing of the point.
/// We have a default implementation of the painter which is
/// [AxisLinesIndicatorPainter], it draws a horizontal and a vertical line
/// that goes through the point.
///
/// You can override the [painter] by implementing your own
/// [AxisSpotIndicatorPainter] implementation.
///
/// For more information, look at our default implementation:
/// [AxisLinesIndicatorPainter].
class AxisSpotIndicator with EquatableMixin {
  const AxisSpotIndicator({
    this.x,
    this.y,
    required this.painter,
  });

  final double? x;
  final double? y;
  final AxisSpotIndicatorPainter painter;

  /// Lerps a [AxisSpotIndicator] based on [t] value, check [Tween.lerp].
  static AxisSpotIndicator lerp(
    AxisSpotIndicator a,
    AxisSpotIndicator b,
    double t,
  ) =>
      AxisSpotIndicator(
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t),
        painter: a.painter.lerp(b.painter, t),
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        x,
        y,
        painter,
      ];
}

/// The abstract class that is used to draw the point indicator
///
/// You can create your own custom painter by extending this class
/// and implementing the [paint] method.
///
/// You can also use the default implementation which is
/// [AxisLinesIndicatorPainter], it draws a horizontal and a vertical line
/// that goes through the point.
abstract class AxisSpotIndicatorPainter {
  const AxisSpotIndicatorPainter();

  /// Draws the point indicator
  void paint(
    BuildContext context,
    Canvas canvas,
    Size viewSize,
    AxisSpotIndicator axisPointIndicator,
    ValueInCanvasProvider xInCanvasProvider,
    ValueInCanvasProvider yInCanvasProvider,
    AxisChartData axisChartData,
  );

  /// Lerps a [AxisSpotIndicatorPainter] based on [t] value, check [Tween.lerp].
  AxisSpotIndicatorPainter lerp(
    AxisSpotIndicatorPainter b,
    double t,
  );
}

/// The default implementation of the [AxisSpotIndicatorPainter]
///
/// It draws a horizontal and a vertical line that goes through the point
class AxisLinesIndicatorPainter extends AxisSpotIndicatorPainter {
  AxisLinesIndicatorPainter({
    required this.verticalLineProvider,
    required this.horizontalLineProvider,
  });

  final VerticalLine? Function(double x)? verticalLineProvider;

  final HorizontalLine? Function(double y)? horizontalLineProvider;

  /// The paint object that is used to draw the lines
  final _linePaint = Paint();

  /// The paint object that is used to draw the images
  final _imagePaint = Paint();

  void _drawHorizontalLine(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    HorizontalLine line,
    Offset from,
    Offset to,
  ) {
    _linePaint
      ..setColorOrGradientForLine(
        line.color,
        line.gradient,
        from: from,
        to: to,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = line.strokeWidth
      ..transparentIfWidthIsZero()
      ..strokeCap = line.strokeCap;

    canvasWrapper.drawDashedLine(
      from,
      to,
      _linePaint,
      line.dashArray,
    );

    if (line.sizedPicture != null) {
      final centerX = line.sizedPicture!.width / 2;
      final centerY = line.sizedPicture!.height / 2;
      final xPosition = centerX;
      final yPosition = to.dy - centerY;

      canvasWrapper
        ..save()
        ..translate(xPosition, yPosition)
        ..drawPicture(line.sizedPicture!.picture)
        ..restore();
    }

    if (line.image != null) {
      final centerX = line.image!.width / 2;
      final centerY = line.image!.height / 2;
      final centeredImageOffset = Offset(centerX, to.dy - centerY);
      canvasWrapper.drawImage(
        line.image!,
        centeredImageOffset,
        _imagePaint,
      );
    }

    if (line.label.show) {
      final label = line.label;
      final style =
          TextStyle(fontSize: 11, color: line.color).merge(label.style);
      final padding = label.padding as EdgeInsets;

      final span = TextSpan(
        text: label.labelResolver(line),
        style: Utils().getThemeAwareTextStyle(context, style),
      );

      final tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      )..layout();

      switch (label.direction) {
        case LabelDirection.horizontal:
          canvasWrapper.drawText(
            tp,
            label.alignment.withinRect(
              Rect.fromLTRB(
                from.dx + padding.left,
                from.dy - padding.bottom - tp.height,
                to.dx - padding.right - tp.width,
                to.dy + padding.top,
              ),
            ),
          );
        case LabelDirection.vertical:
          canvasWrapper.drawVerticalText(
            tp,
            label.alignment.withinRect(
              Rect.fromLTRB(
                from.dx + padding.left + tp.height,
                from.dy - padding.bottom - tp.width,
                to.dx - padding.right,
                to.dy + padding.top,
              ),
            ),
          );
      }
    }
  }

  void _drawVerticalLine(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    VerticalLine line,
    Offset from,
    Offset to,
  ) {
    final viewSize = canvasWrapper.size;

    _linePaint
      ..setColorOrGradientForLine(
        line.color,
        line.gradient,
        from: from,
        to: to,
      )
      ..strokeWidth = line.strokeWidth
      ..style = PaintingStyle.stroke
      ..transparentIfWidthIsZero()
      ..strokeCap = line.strokeCap;

    canvasWrapper.drawDashedLine(
      from,
      to,
      _linePaint,
      line.dashArray,
    );

    if (line.sizedPicture != null) {
      final centerX = line.sizedPicture!.width / 2;
      final centerY = line.sizedPicture!.height / 2;
      final xPosition = to.dx - centerX;
      final yPosition = viewSize.height - centerY;

      canvasWrapper
        ..save()
        ..translate(xPosition, yPosition)
        ..drawPicture(line.sizedPicture!.picture)
        ..restore();
    }

    if (line.image != null) {
      final centerX = line.image!.width / 2;
      final centerY = line.image!.height + 2;
      final centeredImageOffset =
          Offset(to.dx - centerX, viewSize.height - centerY);
      canvasWrapper.drawImage(
        line.image!,
        centeredImageOffset,
        _imagePaint,
      );
    }

    if (line.label.show) {
      final label = line.label;
      final style =
          TextStyle(fontSize: 11, color: line.color).merge(label.style);
      final padding = label.padding as EdgeInsets;

      final span = TextSpan(
        text: label.labelResolver(line),
        style: Utils().getThemeAwareTextStyle(context, style),
      );

      final tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      )..layout();

      switch (label.direction) {
        case LabelDirection.horizontal:
          canvasWrapper.drawText(
            tp,
            label.alignment.withinRect(
              Rect.fromLTRB(
                from.dx - padding.right - tp.width,
                from.dy + padding.top,
                to.dx + padding.left,
                to.dy - padding.bottom - tp.height,
              ),
            ),
          );
        case LabelDirection.vertical:
          canvasWrapper.drawVerticalText(
            tp,
            label.alignment.withinRect(
              Rect.fromLTRB(
                from.dx - padding.right,
                from.dy + padding.top,
                to.dx + padding.left + tp.height,
                to.dy - padding.bottom - tp.width,
              ),
            ),
          );
      }
    }
  }

  @override
  void paint(
    BuildContext context,
    Canvas canvas,
    Size viewSize,
    AxisSpotIndicator axisPointIndicator,
    ValueInCanvasProvider xInCanvasProvider,
    ValueInCanvasProvider yInCanvasProvider,
    AxisChartData axisChartData,
  ) {
    final canvasWrapper = CanvasWrapper(canvas, viewSize);
    final horizontalLine =
        axisPointIndicator.y == null || horizontalLineProvider == null
            ? null
            : horizontalLineProvider!(axisPointIndicator.y!);
    if (horizontalLine != null) {
      final left = Offset(
        xInCanvasProvider(axisChartData.minX),
        yInCanvasProvider(horizontalLine.y),
      );
      final right = Offset(
        xInCanvasProvider(axisChartData.maxX),
        yInCanvasProvider(horizontalLine.y),
      );
      _drawHorizontalLine(
        context,
        canvasWrapper,
        horizontalLine,
        left,
        right,
      );
    }

    final verticalLine =
        axisPointIndicator.x == null || verticalLineProvider == null
            ? null
            : verticalLineProvider!(axisPointIndicator.x!);
    if (verticalLine != null) {
      final top = Offset(
        xInCanvasProvider(verticalLine.x),
        yInCanvasProvider(axisChartData.maxY),
      );
      final bottom = Offset(
        xInCanvasProvider(verticalLine.x),
        yInCanvasProvider(axisChartData.minY),
      );

      _drawVerticalLine(
        context,
        canvasWrapper,
        verticalLine,
        top,
        bottom,
      );
    }
  }

  /// Lerps a [AxisLinesIndicatorPainter] based on [t] value, check [Tween.lerp].
  AxisLinesIndicatorPainter _lerp(
    AxisLinesIndicatorPainter b,
    double t,
  ) =>
      AxisLinesIndicatorPainter(
        horizontalLineProvider: b.horizontalLineProvider,
        verticalLineProvider: b.verticalLineProvider,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  AxisSpotIndicatorPainter lerp(
    AxisSpotIndicatorPainter b,
    double t,
  ) {
    if (b is! AxisLinesIndicatorPainter) {
      return b;
    }
    return _lerp(b, t);
  }
}
