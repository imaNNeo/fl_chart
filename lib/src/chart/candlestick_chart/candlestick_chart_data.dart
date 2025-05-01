// coverage:ignore-file
import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_helper.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

/// [CandlestickChart] needs this class to render itself.
///
/// It holds data needed to draw a candlestick chart,
/// including background color, Candlestick spots, ...
class CandlestickChartData extends AxisChartData with EquatableMixin {
  /// [CandlestickChart] draws some candlesticks on the chart based on
  /// the provided [candlestickSpots],
  ///
  /// It draws some titles on left, top, right, bottom sides per each axis number,
  /// you can modify [titlesData] to have your custom titles,
  ///
  /// It draws a color as a background behind everything you can set it using [backgroundColor],
  /// then a grid over it, you can customize it using [gridData],
  /// and it draws 4 borders around your chart, you can customize it using [borderData].
  ///
  /// You can modify [candlestickTouchData] to customize touch behaviors and responses.
  ///
  /// You can show some tooltipIndicators (a popup with an information)
  /// on top of each [CandlestickChartData.candleSpots] using [showingTooltipIndicators],
  /// just put spot indices you want to show it on top of them.
  ///
  /// [clipData] forces the [CandlestickChart] to draw lines inside the chart bounding box.
  CandlestickChartData({
    List<CandlestickSpot>? candlestickSpots,
    FlCandlestickPainter? candlestickPainter,
    FlTitlesData? titlesData,
    CandlestickTouchData? candlestickTouchData,
    List<int>? showingTooltipIndicators,
    FlGridData? gridData,
    super.borderData,
    double? minX,
    double? maxX,
    super.baselineX,
    double? minY,
    double? maxY,
    super.baselineY,
    super.rangeAnnotations,
    FlClipData? clipData,
    super.backgroundColor,
    super.rotationQuarterTurns,
    this.touchedPointIndicator,
  })  : candlestickSpots = candlestickSpots ?? const [],
        candlestickPainter = candlestickPainter ?? DefaultCandlestickPainter(),
        candlestickTouchData = candlestickTouchData ?? CandlestickTouchData(),
        showingTooltipIndicators = showingTooltipIndicators ?? const [],
        super(
          gridData: gridData ?? const FlGridData(),
          titlesData: titlesData ?? const FlTitlesData(),
          clipData: clipData ?? const FlClipData.none(),
          minX: minX ??
              CandlestickChartHelper.calculateMaxAxisValues(
                candlestickSpots ?? const [],
              ).$1,
          maxX: maxX ??
              CandlestickChartHelper.calculateMaxAxisValues(
                candlestickSpots ?? const [],
              ).$2,
          minY: minY ??
              CandlestickChartHelper.calculateMaxAxisValues(
                candlestickSpots ?? const [],
              ).$3,
          maxY: maxY ??
              CandlestickChartHelper.calculateMaxAxisValues(
                candlestickSpots ?? const [],
              ).$4,
        );

  /// Contains the data for the candlestick chart.
  ///
  /// Each [CandlestickSpot] represents a candlestick in the chart
  /// that contains [open, high, low, close] values.
  final List<CandlestickSpot> candlestickSpots;

  /// The painter used to draw the candlestick.
  /// You can use the [DefaultCandlestickPainter] or implement your own.
  final FlCandlestickPainter candlestickPainter;

  /// Handles touch behaviors and responses.
  final CandlestickTouchData candlestickTouchData;

  /// you can show some tooltipIndicators (a popup with an information)
  /// on top of each [CandlestickSpot] using [showingTooltipIndicators],
  /// just put indices you want to show it on top of them.
  ///
  /// An important point is that you have to disable the default touch behaviour
  /// to show the tooltip manually, see [CandlestickTouchData.handleBuiltInTouches].
  final List<int> showingTooltipIndicators;

  /// Shows an indicator on the touched / hovered point
  ///
  /// We manage to set it by default
  /// when [candlestickTouchData.handleBuiltInTouches] is true,
  /// so nothing happens if you change this property as long as
  /// the handleBuiltInTouches property is true.
  ///
  /// But you can set [candlestickTouchData.handleBuiltInTouches] to false
  /// if you want to have customized [touchedPointIndicator]
  final AxisSpotIndicator? touchedPointIndicator;

  /// Lerps a [CandlestickChartData] based on [t] value, check [Tween.lerp].
  @override
  CandlestickChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is CandlestickChartData && b is CandlestickChartData) {
      return CandlestickChartData(
        candlestickSpots:
            lerpCandleSpotList(a.candlestickSpots, b.candlestickSpots, t),
        candlestickPainter: b.candlestickPainter.lerp(
          a.candlestickPainter,
          b.candlestickPainter,
          t,
        ),
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        candlestickTouchData: b.candlestickTouchData,
        showingTooltipIndicators: lerpIntList(
          a.showingTooltipIndicators,
          b.showingTooltipIndicators,
          t,
        ),
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        minX: lerpDouble(a.minX, b.minX, t),
        maxX: lerpDouble(a.maxX, b.maxX, t),
        baselineX: lerpDouble(a.baselineX, b.baselineX, t),
        minY: lerpDouble(a.minY, b.minY, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        baselineY: lerpDouble(a.baselineY, b.baselineY, t),
        rangeAnnotations: RangeAnnotations.lerp(
          a.rangeAnnotations,
          b.rangeAnnotations,
          t,
        ),
        clipData: b.clipData,
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        rotationQuarterTurns: b.rotationQuarterTurns,
        touchedPointIndicator: b.touchedPointIndicator,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Copies current [CandlestickChartData] to a new [CandlestickChartData],
  /// and replaces provided values.
  CandlestickChartData copyWith({
    List<CandlestickSpot>? candlestickSpots,
    FlCandlestickPainter? candlestickPainter,
    FlTitlesData? titlesData,
    CandlestickTouchData? candlestickTouchData,
    List<int>? showingTooltipIndicators,
    FlGridData? gridData,
    FlBorderData? borderData,
    double? minX,
    double? maxX,
    double? baselineX,
    double? minY,
    double? maxY,
    double? baselineY,
    RangeAnnotations? rangeAnnotations,
    FlClipData? clipData,
    Color? backgroundColor,
    int? rotationQuarterTurns,
    AxisSpotIndicator? touchedPointIndicator,
  }) =>
      CandlestickChartData(
        candlestickSpots: candlestickSpots ?? this.candlestickSpots,
        candlestickPainter: candlestickPainter ?? this.candlestickPainter,
        titlesData: titlesData ?? this.titlesData,
        candlestickTouchData: candlestickTouchData ?? this.candlestickTouchData,
        showingTooltipIndicators:
            showingTooltipIndicators ?? this.showingTooltipIndicators,
        gridData: gridData ?? this.gridData,
        borderData: borderData ?? this.borderData,
        minX: minX ?? this.minX,
        maxX: maxX ?? this.maxX,
        baselineX: baselineX ?? this.baselineX,
        minY: minY ?? this.minY,
        maxY: maxY ?? this.maxY,
        baselineY: baselineY ?? this.baselineY,
        rangeAnnotations: rangeAnnotations ?? this.rangeAnnotations,
        clipData: clipData ?? this.clipData,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        rotationQuarterTurns: rotationQuarterTurns ?? this.rotationQuarterTurns,
        touchedPointIndicator:
            touchedPointIndicator ?? this.touchedPointIndicator,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        candlestickSpots,
        candlestickPainter,
        candlestickTouchData,
        showingTooltipIndicators,
        gridData,
        titlesData,
        minX,
        maxX,
        baselineX,
        minY,
        maxY,
        baselineY,
        rangeAnnotations,
        clipData,
        backgroundColor,
        borderData,
        rotationQuarterTurns,
        touchedPointIndicator,
      ];
}

/// Defines information about a spot in the [CandlestickChart]
class CandlestickSpot extends FlSpot with EquatableMixin {
  /// You can change [show] value to show or hide the spot,
  /// [x] determines the location of [CandlestickChart] in the x-axis,
  /// [open], [high], [low], and [close] defines the values of the spot
  /// based on the standard [OHLC chart](https://en.wikipedia.org/wiki/Open-high-low-close_chart).
  ///
  /// You can temporarily hide the spot by setting [show] to false.
  ///
  /// The [candlestickPainter] is used to customize the appearance of each candlestick.
  /// We use the [DefaultCandlestickPainter] by default, but you can implement
  /// your own painter with your shiny UI
  CandlestickSpot({
    required double x,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    bool? show,
  })  : show = show ?? true,
        super(x, high);

  /// The open value of a specific candlestick.
  final double open;

  /// The high value of a specific candlestick.
  final double high;

  /// The low value of a specific candlestick.
  final double low;

  /// The close value of a specific candlestick.
  final double close;

  /// Determines show or hide the spot.
  final bool show;

  /// Checks if the candlestick is up (close > open).
  ///
  /// It is the same as bullish and bearish definitions in the stock market.
  bool get isUp => close > open;

  /// Returns the middle point of the candlestick
  double get midPoint => (open + close) / 2;

  @override
  CandlestickSpot copyWith({
    double? x,
    double? y,
    FlErrorRange? xError,
    FlErrorRange? yError,
    double? open,
    double? high,
    double? low,
    double? close,
    bool? show,
  }) {
    if (y != null) {
      throw Exception(
        'y value is not used in CandlestickSpot and it does not do anything. Please use open, high, low, close values.',
      );
    }

    if (xError != null || yError != null) {
      throw Exception(
        'xError and yError values are not used in CandlestickSpot and it does not do anything.',
      );
    }

    return CandlestickSpot(
      x: x ?? this.x,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      show: show ?? this.show,
    );
  }

  /// Lerps a [CandlestickSpot] based on [t] value, check [Tween.lerp].
  static CandlestickSpot lerp(CandlestickSpot a, CandlestickSpot b, double t) =>
      CandlestickSpot(
        x: lerpDouble(a.x, b.x, t)!,
        open: lerpDouble(a.open, b.open, t)!,
        high: lerpDouble(a.high, b.high, t)!,
        low: lerpDouble(a.low, b.low, t)!,
        close: lerpDouble(a.close, b.close, t)!,
        show: b.show,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        x,
        open,
        high,
        low,
        close,
        show,
      ];
}

/// Holds data to handle touch events, and touch responses in the [CandlestickChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart's renderer captures the touch events, and passes the pointerEvent
/// to the painter, and gets touched spot, and wraps it into a concrete [CandlestickTouchResponse].
class CandlestickTouchData extends FlTouchData<CandlestickTouchResponse>
    with EquatableMixin {
  /// You can disable or enable the touch system using [enabled] flag,
  ///
  /// [touchCallback] notifies you about the happened touch/pointer events.
  /// It gives you a [FlTouchEvent] which is the happened event such as [FlPointerHoverEvent], [FlTapUpEvent], ...
  /// It also gives you a [CandlestickTouchResponse] which contains information
  /// about the elements that has touched.
  ///
  /// Using [mouseCursorResolver] you can change the mouse cursor
  /// based on the provided [FlTouchEvent] and [CandlestickTouchResponse]
  ///
  /// if [handleBuiltInTouches] is true, [CandlestickChart] shows a tooltip popup on top of the spots if
  /// touch occurs (or you can show it manually using, [CandlestickChartData.showingTooltipIndicators])
  /// You can customize this tooltip using [touchTooltipData],
  ///
  /// If you need to have a distance threshold for handling touches, use [touchSpotThreshold].
  CandlestickTouchData({
    bool? enabled,
    BaseTouchCallback<CandlestickTouchResponse>? touchCallback,
    MouseCursorResolver<CandlestickTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
    CandlestickTouchTooltipData? touchTooltipData,
    bool? handleBuiltInTouches,
    double? touchSpotThreshold,
  })  : touchTooltipData = touchTooltipData ?? CandlestickTouchTooltipData(),
        handleBuiltInTouches = handleBuiltInTouches ?? true,
        touchSpotThreshold = touchSpotThreshold ?? 4,
        super(
          enabled ?? true,
          touchCallback,
          mouseCursorResolver,
          longPressDuration,
        );

  /// show a tooltip on touched spots
  final CandlestickTouchTooltipData touchTooltipData;

  /// set this true if you want the built in touch handling
  /// (show a tooltip bubble and an indicator on touched spots)
  final bool handleBuiltInTouches;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  /// Copies current [CandlestickTouchData] to a new [CandlestickTouchData],
  /// and replaces provided values.
  CandlestickTouchData copyWith({
    bool? enabled,
    BaseTouchCallback<CandlestickTouchResponse>? touchCallback,
    MouseCursorResolver<CandlestickTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
    CandlestickTouchTooltipData? touchTooltipData,
    bool? handleBuiltInTouches,
    double? touchSpotThreshold,
  }) =>
      CandlestickTouchData(
        enabled: enabled ?? this.enabled,
        touchCallback: touchCallback ?? this.touchCallback,
        mouseCursorResolver: mouseCursorResolver ?? this.mouseCursorResolver,
        longPressDuration: longPressDuration ?? this.longPressDuration,
        touchTooltipData: touchTooltipData ?? this.touchTooltipData,
        handleBuiltInTouches: handleBuiltInTouches ?? this.handleBuiltInTouches,
        touchSpotThreshold: touchSpotThreshold ?? this.touchSpotThreshold,
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
        longPressDuration,
        touchTooltipData,
        handleBuiltInTouches,
        touchSpotThreshold,
      ];
}

/// [CandlestickChart]'s touch callback.
typedef CandlestickTouchCallback = void Function(CandlestickTouchResponse);

/// Holds information about touch response in the [CandlestickChart].
///
/// You can override [CandlestickTouchData.touchCallback] to handle touch events,
/// it gives you a [CandlestickTouchResponse] and you can do whatever you want.
class CandlestickTouchResponse extends AxisBaseTouchResponse {
  /// If touch happens, [CandlestickChart] processes it internally and
  /// passes out a [CandlestickTouchResponse], it gives you information about the touched spot.
  ///
  /// [touchedSpot] tells you
  /// in which spot (of [CandlestickChartData.candleSpots]) touch happened.
  CandlestickTouchResponse({
    required super.touchLocation,
    required super.touchChartCoordinate,
    required this.touchedSpot,
  });

  final CandlestickTouchedSpot? touchedSpot;

  /// Copies current [CandlestickTouchResponse] to a new [CandlestickTouchResponse],
  /// and replaces provided values.
  CandlestickTouchResponse copyWith({
    Offset? touchLocation,
    Offset? touchChartCoordinate,
    CandlestickTouchedSpot? touchedSpot,
  }) =>
      CandlestickTouchResponse(
        touchLocation: touchLocation ?? this.touchLocation,
        touchChartCoordinate: touchChartCoordinate ?? this.touchChartCoordinate,
        touchedSpot: touchedSpot ?? this.touchedSpot,
      );
}

/// Holds the touched spot data
class CandlestickTouchedSpot with EquatableMixin {
  /// [spot], and [spotIndex] tells you
  /// in which spot (of [CandlestickChartData.candleSpots]) touch happened.
  const CandlestickTouchedSpot(this.spot, this.spotIndex);

  /// Touch happened on this spot
  final CandlestickSpot spot;

  /// Touch happened on this spot index
  final int spotIndex;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        spot,
        spotIndex,
      ];

  /// Copies current [CandlestickTouchedSpot] to a new [CandlestickTouchedSpot],
  /// and replaces provided values.
  CandlestickTouchedSpot copyWith({
    CandlestickSpot? spot,
    int? spotIndex,
  }) =>
      CandlestickTouchedSpot(spot ?? this.spot, spotIndex ?? this.spotIndex);
}

/// Holds representation data for showing tooltip popup on top of spots.
class CandlestickTouchTooltipData with EquatableMixin {
  /// if [CandlestickTouchData.handleBuiltInTouches] is true,
  /// [CandlestickChart] shows a tooltip popup on top of spots automatically when touch happens,
  /// otherwise you can show it manually using [CandlestickChartData.showingTooltipIndicators].
  /// Tooltip shows on top of rods, with [getTooltipColor] as a background color.
  /// You can set the corner radius using [tooltipBorderRadius].
  /// If you want to have a padding inside the tooltip, fill [tooltipPadding].
  /// Content of the tooltip will provide using [getTooltipItems] callback, you can override it
  /// and pass your custom data to show in the tooltip.
  /// You can restrict the tooltip's width using [maxContentWidth].
  /// Sometimes, [CandlestickChart] shows the tooltip outside of the chart,
  /// you can set [fitInsideHorizontally] true to force it to shift inside the chart horizontally,
  /// also you can set [fitInsideVertically] true to force it to shift inside the chart vertically.
  CandlestickTouchTooltipData({
    BorderRadius? tooltipBorderRadius,
    EdgeInsets? tooltipPadding,
    FLHorizontalAlignment? tooltipHorizontalAlignment,
    double? tooltipHorizontalOffset,
    double? maxContentWidth,
    GetCandlestickTooltipItems? getTooltipItems,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    bool? showOnTopOfTheChartBoxArea,
    double? rotateAngle,
    BorderSide? tooltipBorder,
    GetCandlestickTooltipColor? getTooltipColor,
  })  : tooltipBorderRadius = tooltipBorderRadius ?? BorderRadius.circular(4),
        tooltipPadding = tooltipPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tooltipHorizontalAlignment =
            tooltipHorizontalAlignment ?? FLHorizontalAlignment.center,
        tooltipHorizontalOffset = tooltipHorizontalOffset ?? 0,
        maxContentWidth = maxContentWidth ?? 120,
        getTooltipItems = getTooltipItems ?? defaultCandlestickTooltipItem,
        fitInsideHorizontally = fitInsideHorizontally ?? false,
        fitInsideVertically = fitInsideVertically ?? false,
        showOnTopOfTheChartBoxArea = showOnTopOfTheChartBoxArea ?? false,
        rotateAngle = rotateAngle ?? 0.0,
        tooltipBorder = tooltipBorder ?? BorderSide.none,
        getTooltipColor = getTooltipColor ?? defaultCandlestickTooltipColor,
        super();

  /// Sets a border radius for the tooltip.
  final BorderRadius tooltipBorderRadius;

  /// Applies a padding for showing contents inside the tooltip.
  final EdgeInsets tooltipPadding;

  /// Controls showing tooltip on left side, right side or center aligned with spot, default is center
  final FLHorizontalAlignment tooltipHorizontalAlignment;

  /// Applies horizontal offset for showing tooltip, default is zero.
  final double tooltipHorizontalOffset;

  /// Restricts the tooltip's width.
  final double maxContentWidth;

  /// Retrieves data for showing content inside the tooltip.
  final GetCandlestickTooltipItems getTooltipItems;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// Forces the tooltip container to top of the line, default 'false'
  final bool showOnTopOfTheChartBoxArea;

  /// Controls the rotation of the tooltip.
  final double rotateAngle;

  /// The tooltip border color.
  final BorderSide tooltipBorder;

  /// Retrieves data for showing content inside the tooltip.
  final GetCandlestickTooltipColor getTooltipColor;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        tooltipBorderRadius,
        tooltipPadding,
        tooltipHorizontalAlignment,
        tooltipHorizontalOffset,
        maxContentWidth,
        getTooltipItems,
        fitInsideHorizontally,
        fitInsideVertically,
        showOnTopOfTheChartBoxArea,
        rotateAngle,
        tooltipBorder,
        getTooltipColor,
      ];

  /// Copies current [CandlestickTouchTooltipData] to a new [CandlestickTouchTooltipData],
  /// and replaces provided values.
  CandlestickTouchTooltipData copyWith({
    BorderRadius? tooltipBorderRadius,
    EdgeInsets? tooltipPadding,
    FLHorizontalAlignment? tooltipHorizontalAlignment,
    double? tooltipHorizontalOffset,
    double? maxContentWidth,
    GetCandlestickTooltipItems? getTooltipItems,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    double? rotateAngle,
    BorderSide? tooltipBorder,
    GetCandlestickTooltipColor? getTooltipColor,
  }) =>
      CandlestickTouchTooltipData(
        tooltipBorderRadius: tooltipBorderRadius ?? this.tooltipBorderRadius,
        tooltipPadding: tooltipPadding ?? this.tooltipPadding,
        tooltipHorizontalAlignment:
            tooltipHorizontalAlignment ?? this.tooltipHorizontalAlignment,
        tooltipHorizontalOffset:
            tooltipHorizontalOffset ?? this.tooltipHorizontalOffset,
        maxContentWidth: maxContentWidth ?? this.maxContentWidth,
        getTooltipItems: getTooltipItems ?? this.getTooltipItems,
        fitInsideHorizontally:
            fitInsideHorizontally ?? this.fitInsideHorizontally,
        fitInsideVertically: fitInsideVertically ?? this.fitInsideVertically,
        rotateAngle: rotateAngle ?? this.rotateAngle,
        tooltipBorder: tooltipBorder ?? this.tooltipBorder,
        getTooltipColor: getTooltipColor ?? this.getTooltipColor,
      );
}

/// Provides a [CandlestickTooltipItem] for showing content inside the [CandlestickTouchTooltipData].
///
/// You can override [CandlestickTouchTooltipData.getTooltipItems], it gives you
/// [touchedSpot] that touch happened on,
/// then you should and pass your custom [CandlestickTooltipItem]
/// to show it inside the tooltip popup.
typedef GetCandlestickTooltipItems = CandlestickTooltipItem? Function(
  FlCandlestickPainter painter,
  CandlestickSpot touchedSpot,
  int spotIndex,
);

/// Default implementation for [CandlestickTouchTooltipData.getTooltipItems].
CandlestickTooltipItem? defaultCandlestickTooltipItem(
  FlCandlestickPainter painter,
  CandlestickSpot touchedSpot,
  int spotIndex,
) {
  final textStyle = TextStyle(
    color: painter.getMainColor(
      spot: touchedSpot,
      spotIndex: spotIndex,
    ),
    fontSize: 14,
  );
  final valueStyle = TextStyle(
    color: painter.getMainColor(
      spot: touchedSpot,
      spotIndex: spotIndex,
    ),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return CandlestickTooltipItem(
    '',
    textStyle: textStyle,
    children: [
      TextSpan(
        text: 'open: ',
        style: textStyle,
      ),
      TextSpan(
        text: '${touchedSpot.open.toInt()}\n',
        style: valueStyle,
      ),
      TextSpan(
        text: 'high: ',
        style: textStyle,
      ),
      TextSpan(
        text: '${touchedSpot.high.toInt()}\n',
        style: valueStyle,
      ),
      TextSpan(
        text: 'low: ',
        style: textStyle,
      ),
      TextSpan(
        text: '${touchedSpot.low.toInt()}\n',
        style: valueStyle,
      ),
      TextSpan(
        text: 'close: ',
        style: textStyle,
      ),
      TextSpan(
        text: '${touchedSpot.close.toInt()}',
        style: valueStyle,
      ),
    ],
  );
}

/// Provides a [Color] to show different background color inside the [CandlestickTouchTooltipData].
///
/// You can override [CandlestickTouchTooltipData.getTooltipColor], it gives you
/// [touchedSpot] that touch happened on,
/// then you should and pass your custom [Color]
/// to show it inside the tooltip popup.
typedef GetCandlestickTooltipColor = Color Function(
  CandlestickSpot touchedSpot,
);

/// Default implementation for [CandlestickTouchTooltipData.getTooltipItems].
Color defaultCandlestickTooltipColor(CandlestickSpot touchedSpot) =>
    Colors.blueGrey.darken(80);

/// Holds data of showing each item in the tooltip popup.
class CandlestickTooltipItem with EquatableMixin {
  /// Shows a [text] with [textStyle], [textDirection],  and optional [children] in the tooltip popup,
  /// [bottomMargin] is the bottom space from spot.
  CandlestickTooltipItem(
    this.text, {
    this.textStyle,
    double? bottomMargin,
    TextAlign? textAlign,
    TextDirection? textDirection,
    this.children,
  })  : bottomMargin = bottomMargin ?? 8,
        textAlign = textAlign ?? TextAlign.center,
        textDirection = textDirection ?? TextDirection.ltr;

  /// Showing text.
  final String text;

  /// Style of showing text.
  final TextStyle? textStyle;

  /// Defines bottom space from spot.
  final double bottomMargin;

  /// TextAlign of the showing content.
  final TextAlign textAlign;

  /// Direction of showing text.
  final TextDirection textDirection;

  /// Add further style and format to the text of the tooltip
  final List<TextSpan>? children;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        text,
        textStyle,
        bottomMargin,
        textAlign,
        textDirection,
        children,
      ];

  /// Copies current [CandlestickTooltipItem] to a new [CandlestickTooltipItem],
  /// and replaces provided values.
  CandlestickTooltipItem copyWith({
    String? text,
    TextStyle? textStyle,
    double? bottomMargin,
    TextAlign? textAlign,
    TextDirection? textDirection,
    List<TextSpan>? children,
  }) =>
      CandlestickTooltipItem(
        text ?? this.text,
        textStyle: textStyle ?? this.textStyle,
        bottomMargin: bottomMargin ?? this.bottomMargin,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        children: children ?? this.children,
      );
}

/// This class contains the interface for drawing the candlestick shape.
abstract class FlCandlestickPainter with EquatableMixin {
  const FlCandlestickPainter();

  /// This method should be overridden to draw the candlestick shape
  void paint(
    Canvas canvas,
    ValueInCanvasProvider xInCanvasProvider,
    ValueInCanvasProvider yInCanvasProvider,
    CandlestickSpot spot,
    int spotIndex,
  );

  /// Used to show default UIs, for example [defaultCandlestickTooltipItem]
  Color getMainColor({
    required CandlestickSpot spot,
    required int spotIndex,
  });

  FlCandlestickPainter lerp(
    FlCandlestickPainter a,
    FlCandlestickPainter b,
    double t,
  );

  /// Used to implement touch behaviour of this dot, for example,
  /// it behaves like a square of [getSize]
  /// Check [DefaultCandlestickPainter.hitTest] for an example of an implementation
  (bool, double) hitTest(
    CandlestickSpot spot,
    double touchedX,
    double spotX,
    double extraTouchThreshold,
  ) {
    final distance = (touchedX - spotX).abs();
    final hit = distance <= extraTouchThreshold;
    return (hit, distance);
  }
}

/// [CandlestickChart]'s touch callback.
typedef CandlestickStyleProvider = CandlestickStyle Function(
  CandlestickSpot spot,
  int index,
);

CandlestickStyleProvider get _defaultStrokeColorProvider => (spot, _) {
      final generalColor =
          spot.isUp ? const Color(0xFF4CAF50) : const Color(0xFFEF5350);
      return CandlestickStyle(
        lineColor: generalColor,
        lineWidth: 1.5,
        bodyStrokeColor: generalColor,
        bodyStrokeWidth: 0,
        bodyFillColor: generalColor,
        bodyWidth: 4,
        bodyRadius: 0,
      );
    };

/// Default implementation of [FlCandlestickPainter].
///
/// It draws the candlestick shape with a line and a body (just like a standard
/// candlestick chart).
///
/// You can customize the appearance of the candlestick
/// using [CandlestickStyleProvider].
class DefaultCandlestickPainter extends FlCandlestickPainter {
  DefaultCandlestickPainter({
    CandlestickStyleProvider? candlestickStyleProvider,
  }) : candlestickStyleProvider =
            candlestickStyleProvider ?? _defaultStrokeColorProvider;

  final CandlestickStyleProvider candlestickStyleProvider;

  final _linePainter = Paint();
  final _bodyPainter = Paint();
  final _bodyStrokePainter = Paint();

  @override
  void paint(
    Canvas canvas,
    ValueInCanvasProvider xInCanvasProvider,
    ValueInCanvasProvider yInCanvasProvider,
    CandlestickSpot spot,
    int spotIndex,
  ) {
    final style = candlestickStyleProvider(spot, spotIndex);

    final xOffsetInCanvas = xInCanvasProvider(spot.x);
    final openYOffsetInCanvas = yInCanvasProvider(spot.open);
    final highYOffsetInCanvas = yInCanvasProvider(spot.high);
    final lowOYOffsetInCanvas = yInCanvasProvider(spot.low);
    final closeYOffsetInCanvas = yInCanvasProvider(spot.close);

    final bodyHighCanvas = min(openYOffsetInCanvas, closeYOffsetInCanvas);
    final bodyLowCanvas = max(openYOffsetInCanvas, closeYOffsetInCanvas);

    if (style.lineWidth > 0 && style.lineColor.a > 0) {
      canvas
        // Bottom line
        ..drawLine(
          Offset(xOffsetInCanvas, lowOYOffsetInCanvas),
          Offset(xOffsetInCanvas, bodyLowCanvas),
          _linePainter
            ..color = style.lineColor
            ..strokeWidth = style.lineWidth,
        )
        // Top line
        ..drawLine(
          Offset(xOffsetInCanvas, highYOffsetInCanvas),
          Offset(xOffsetInCanvas, bodyHighCanvas),
          _linePainter
            ..color = style.lineColor
            ..strokeWidth = style.lineWidth,
        );
    }

    // Body
    final bodyRect = Rect.fromLTRB(
      xOffsetInCanvas - style.bodyWidth / 2,
      bodyHighCanvas,
      xOffsetInCanvas + style.bodyWidth / 2,
      bodyLowCanvas,
    );
    if (style.bodyFillColor.a > 0 && style.bodyWidth > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          bodyRect,
          Radius.circular(style.bodyRadius),
        ),
        _bodyPainter
          ..color = style.bodyFillColor
          ..style = PaintingStyle.fill,
      );
    }
    if (style.bodyStrokeWidth > 0 && style.bodyStrokeColor.a > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          bodyRect,
          Radius.circular(style.bodyRadius),
        ),
        _bodyStrokePainter
          ..color = style.bodyStrokeColor
          ..strokeWidth = style.bodyStrokeWidth
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  FlCandlestickPainter lerp(
    FlCandlestickPainter a,
    FlCandlestickPainter b,
    double t,
  ) {
    if (a is! DefaultCandlestickPainter || b is! DefaultCandlestickPainter) {
      return b;
    }
    return DefaultCandlestickPainter(
      candlestickStyleProvider: b.candlestickStyleProvider,
    );
  }

  @override
  Color getMainColor({
    required CandlestickSpot spot,
    required int spotIndex,
  }) =>
      candlestickStyleProvider(spot, spotIndex).lineColor;

  @override
  List<Object?> get props => [
        candlestickStyleProvider,
      ];
}

/// Holds data for drawing each candlestick shape.
class CandlestickStyle with EquatableMixin {
  const CandlestickStyle({
    required this.lineColor,
    required this.lineWidth,
    required this.bodyStrokeColor,
    required this.bodyStrokeWidth,
    required this.bodyFillColor,
    required this.bodyWidth,
    required this.bodyRadius,
  });

  /// The color of the candlestick line.
  final Color lineColor;

  /// The width of the candlestick line.
  final double lineWidth;

  /// The color of the candlestick body stroke.
  final Color bodyStrokeColor;

  /// The width of the candlestick body stroke.
  final double bodyStrokeWidth;

  /// The fill color of the candlestick body.
  final Color bodyFillColor;

  /// The width of the candlestick body.
  final double bodyWidth;

  /// The radius of the corners of the candlestick body.
  final double bodyRadius;

  /// Lerps a [CandlestickStyle] based on [t] value, check [Tween.lerp].
  static CandlestickStyle lerp(
    CandlestickStyle a,
    CandlestickStyle b,
    double t,
  ) =>
      CandlestickStyle(
        lineColor: Color.lerp(a.lineColor, b.lineColor, t)!,
        lineWidth: lerpDouble(a.lineWidth, b.lineWidth, t)!,
        bodyStrokeColor: Color.lerp(a.bodyStrokeColor, b.bodyStrokeColor, t)!,
        bodyStrokeWidth: lerpDouble(a.bodyStrokeWidth, b.bodyStrokeWidth, t)!,
        bodyFillColor: Color.lerp(a.bodyFillColor, b.bodyFillColor, t)!,
        bodyWidth: lerpDouble(a.bodyWidth, b.bodyWidth, t)!,
        bodyRadius: lerpDouble(a.bodyRadius, b.bodyRadius, t)!,
      );

  @override
  List<Object?> get props => [
        lineColor,
        lineWidth,
        bodyStrokeColor,
        bodyStrokeWidth,
        bodyFillColor,
        bodyWidth,
        bodyRadius,
      ];
}

/// It lerps a [CandlestickChartData] to another [CandlestickChartData] (handles animation for updating values)
class CandlestickChartDataTween extends Tween<CandlestickChartData> {
  CandlestickChartDataTween({
    required CandlestickChartData begin,
    required CandlestickChartData end,
  }) : super(begin: begin, end: end);

  /// Lerps a [CandlestickChartData] based on [t] value, check [Tween.lerp].
  @override
  CandlestickChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
