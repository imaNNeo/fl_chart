// coverage:ignore-file
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_helper.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

/// [ScatterChart] needs this class to render itself.
///
/// It holds data needed to draw a scatter chart,
/// including background color, scatter spots, ...
class ScatterChartData extends AxisChartData with EquatableMixin {
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
  /// [clipData] forces the [LineChart] to draw lines inside the chart bounding box.
  ScatterChartData({
    List<ScatterSpot>? scatterSpots,
    FlTitlesData? titlesData,
    ScatterTouchData? scatterTouchData,
    List<int>? showingTooltipIndicators,
    FlGridData? gridData,
    super.borderData,
    double? minX,
    double? maxX,
    super.baselineX,
    double? minY,
    double? maxY,
    super.baselineY,
    FlClipData? clipData,
    super.backgroundColor,
    ScatterLabelSettings? scatterLabelSettings,
  })  : scatterSpots = scatterSpots ?? const [],
        scatterTouchData = scatterTouchData ?? ScatterTouchData(),
        showingTooltipIndicators = showingTooltipIndicators ?? const [],
        scatterLabelSettings = scatterLabelSettings ?? ScatterLabelSettings(),
        super(
          gridData: gridData ?? const FlGridData(),
          touchData: scatterTouchData ?? ScatterTouchData(),
          titlesData: titlesData ?? const FlTitlesData(),
          clipData: clipData ?? const FlClipData.none(),
          minX: minX ??
              ScatterChartHelper.calculateMaxAxisValues(
                scatterSpots ?? const [],
              ).minX,
          maxX: maxX ??
              ScatterChartHelper.calculateMaxAxisValues(
                scatterSpots ?? const [],
              ).maxX,
          minY: minY ??
              ScatterChartHelper.calculateMaxAxisValues(
                scatterSpots ?? const [],
              ).minY,
          maxY: maxY ??
              ScatterChartHelper.calculateMaxAxisValues(
                scatterSpots ?? const [],
              ).maxY,
        );
  final List<ScatterSpot> scatterSpots;
  final ScatterTouchData scatterTouchData;
  final List<int> showingTooltipIndicators;
  final ScatterLabelSettings scatterLabelSettings;

  /// Lerps a [ScatterChartData] based on [t] value, check [Tween.lerp].
  @override
  ScatterChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is ScatterChartData && b is ScatterChartData) {
      return ScatterChartData(
        scatterSpots: lerpScatterSpotList(a.scatterSpots, b.scatterSpots, t),
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        scatterTouchData: b.scatterTouchData,
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
        clipData: b.clipData,
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        scatterLabelSettings: ScatterLabelSettings.lerp(
          a.scatterLabelSettings,
          b.scatterLabelSettings,
          t,
        ),
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Copies current [ScatterChartData] to a new [ScatterChartData],
  /// and replaces provided values.
  ScatterChartData copyWith({
    List<ScatterSpot>? scatterSpots,
    FlTitlesData? titlesData,
    ScatterTouchData? scatterTouchData,
    List<int>? showingTooltipIndicators,
    FlGridData? gridData,
    FlBorderData? borderData,
    double? minX,
    double? maxX,
    double? baselineX,
    double? minY,
    double? maxY,
    double? baselineY,
    FlClipData? clipData,
    Color? backgroundColor,
    ScatterLabelSettings? scatterLabelSettings,
  }) {
    return ScatterChartData(
      scatterSpots: scatterSpots ?? this.scatterSpots,
      titlesData: titlesData ?? this.titlesData,
      scatterTouchData: scatterTouchData ?? this.scatterTouchData,
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
      clipData: clipData ?? this.clipData,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      scatterLabelSettings: scatterLabelSettings ?? this.scatterLabelSettings,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        scatterSpots,
        scatterTouchData,
        showingTooltipIndicators,
        gridData,
        titlesData,
        rangeAnnotations,
        minX,
        maxX,
        baselineX,
        minY,
        maxY,
        baselineY,
        rangeAnnotations,
        scatterLabelSettings,
        clipData,
        backgroundColor,
        borderData,
        touchData,
      ];
}

/// Defines information about a spot in the [ScatterChart]
class ScatterSpot extends FlSpot with EquatableMixin {
  /// You can change [show] value to show or hide the spot,
  /// [x], and [y] defines the location of spot in the [ScatterChart],
  /// [radius] defines the size of spot, and [color] defines the color of it.
  ScatterSpot(
    super.x,
    super.y, {
    bool? show,
    FlDotPainter? dotPainter,
  })  : show = show ?? true,
        dotPainter = dotPainter ??
            FlDotCirclePainter(
              radius: 6,
              color:
                  Colors.primaries[((x * y) % Colors.primaries.length).toInt()],
            );

  /// Determines show or hide the spot.
  final bool show;

  /// Determines shape of the spot
  final FlDotPainter dotPainter;

  Size get size => dotPainter.getSize(this);

  String get defaultLabel {
    if (dotPainter is FlDotCirclePainter) {
      return '${(dotPainter as FlDotCirclePainter).radius.toInt()}';
    } else {
      return '${x.toInt()}, ${y.toInt()}';
    }
  }

  @override
  ScatterSpot copyWith({
    double? x,
    double? y,
    bool? show,
    FlDotPainter? dotPainter,
  }) {
    return ScatterSpot(
      x ?? this.x,
      y ?? this.y,
      show: show ?? this.show,
      dotPainter: dotPainter ?? this.dotPainter,
    );
  }

  /// Lerps a [ScatterSpot] based on [t] value, check [Tween.lerp].
  static ScatterSpot lerp(ScatterSpot a, ScatterSpot b, double t) {
    return ScatterSpot(
      lerpDouble(a.x, b.x, t)!,
      lerpDouble(a.y, b.y, t)!,
      show: b.show,
      dotPainter: a.dotPainter.lerp(a.dotPainter, b.dotPainter, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        x,
        y,
        show,
        dotPainter,
      ];
}

/// Holds data to handle touch events, and touch responses in the [ScatterChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeo/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart's renderer captures the touch events, and passes the pointerEvent
/// to the painter, and gets touched spot, and wraps it into a concrete [ScatterTouchResponse].
class ScatterTouchData extends FlTouchData<ScatterTouchResponse>
    with EquatableMixin {
  /// You can disable or enable the touch system using [enabled] flag,
  ///
  /// [touchCallback] notifies you about the happened touch/pointer events.
  /// It gives you a [FlTouchEvent] which is the happened event such as [FlPointerHoverEvent], [FlTapUpEvent], ...
  /// It also gives you a [ScatterTouchResponse] which contains information
  /// about the elements that has touched.
  ///
  /// Using [mouseCursorResolver] you can change the mouse cursor
  /// based on the provided [FlTouchEvent] and [ScatterTouchResponse]
  ///
  /// if [handleBuiltInTouches] is true, [ScatterChart] shows a tooltip popup on top of the spots if
  /// touch occurs (or you can show it manually using, [ScatterChartData.showingTooltipIndicators])
  /// You can customize this tooltip using [touchTooltipData],
  ///
  /// If you need to have a distance threshold for handling touches, use [touchSpotThreshold].
  ScatterTouchData({
    bool? enabled,
    BaseTouchCallback<ScatterTouchResponse>? touchCallback,
    MouseCursorResolver<ScatterTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
    ScatterTouchTooltipData? touchTooltipData,
    double? touchSpotThreshold,
    bool? handleBuiltInTouches,
  })  : touchTooltipData = touchTooltipData ?? ScatterTouchTooltipData(),
        touchSpotThreshold = touchSpotThreshold ?? 0,
        handleBuiltInTouches = handleBuiltInTouches ?? true,
        super(
          enabled ?? true,
          touchCallback,
          mouseCursorResolver,
          longPressDuration,
        );

  /// show a tooltip on touched spots
  final ScatterTouchTooltipData touchTooltipData;

  /// we find the nearest spots on touched position based on this threshold
  final double touchSpotThreshold;

  /// set this true if you want the built in touch handling
  /// (show a tooltip bubble and an indicator on touched spots)
  final bool handleBuiltInTouches;

  /// Copies current [ScatterTouchData] to a new [ScatterTouchData],
  /// and replaces provided values.
  ScatterTouchData copyWith({
    bool? enabled,
    BaseTouchCallback<ScatterTouchResponse>? touchCallback,
    MouseCursorResolver<ScatterTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
    ScatterTouchTooltipData? touchTooltipData,
    double? touchSpotThreshold,
    bool? handleBuiltInTouches,
  }) {
    return ScatterTouchData(
      enabled: enabled ?? this.enabled,
      touchCallback: touchCallback ?? this.touchCallback,
      mouseCursorResolver: mouseCursorResolver ?? this.mouseCursorResolver,
      longPressDuration: longPressDuration ?? this.longPressDuration,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      handleBuiltInTouches: handleBuiltInTouches ?? this.handleBuiltInTouches,
      touchSpotThreshold: touchSpotThreshold ?? this.touchSpotThreshold,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
        longPressDuration,
        touchTooltipData,
        touchSpotThreshold,
        handleBuiltInTouches,
      ];
}

/// [ScatterChart]'s touch callback.
typedef ScatterTouchCallback = void Function(ScatterTouchResponse);

/// Holds information about touch response in the [ScatterChart].
///
/// You can override [ScatterTouchData.touchCallback] to handle touch events,
/// it gives you a [ScatterTouchResponse] and you can do whatever you want.
class ScatterTouchResponse extends BaseTouchResponse {
  /// If touch happens, [ScatterChart] processes it internally and
  /// passes out a [ScatterTouchResponse], it gives you information about the touched spot.
  ///
  /// [touchedSpot] tells you
  /// in which spot (of [ScatterChartData.scatterSpots]) touch happened.
  ScatterTouchResponse(this.touchedSpot) : super();
  final ScatterTouchedSpot? touchedSpot;

  /// Copies current [ScatterTouchResponse] to a new [ScatterTouchResponse],
  /// and replaces provided values.
  ScatterTouchResponse copyWith({
    ScatterTouchedSpot? touchedSpot,
  }) {
    return ScatterTouchResponse(touchedSpot ?? this.touchedSpot);
  }
}

/// Holds the touched spot data
class ScatterTouchedSpot with EquatableMixin {
  /// [spot], and [spotIndex] tells you
  /// in which spot (of [ScatterChartData.scatterSpots]) touch happened.
  const ScatterTouchedSpot(this.spot, this.spotIndex);

  /// Touch happened on this spot
  final ScatterSpot spot;

  /// Touch happened on this spot index
  final int spotIndex;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        spot,
        spotIndex,
      ];

  /// Copies current [ScatterTouchedSpot] to a new [ScatterTouchedSpot],
  /// and replaces provided values.
  ScatterTouchedSpot copyWith({
    ScatterSpot? spot,
    int? spotIndex,
  }) {
    return ScatterTouchedSpot(spot ?? this.spot, spotIndex ?? this.spotIndex);
  }
}

/// Holds representation data for showing tooltip popup on top of spots.
class ScatterTouchTooltipData with EquatableMixin {
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
  ScatterTouchTooltipData({
    Color? tooltipBgColor,
    double? tooltipRoundedRadius,
    EdgeInsets? tooltipPadding,
    FLHorizontalAlignment? tooltipHorizontalAlignment,
    double? tooltipHorizontalOffset,
    double? maxContentWidth,
    GetScatterTooltipItems? getTooltipItems,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    double? rotateAngle,
    BorderSide? tooltipBorder,
  })  : tooltipBgColor = tooltipBgColor ?? Colors.blueGrey.darken(15),
        tooltipRoundedRadius = tooltipRoundedRadius ?? 4,
        tooltipPadding = tooltipPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tooltipHorizontalAlignment =
            tooltipHorizontalAlignment ?? FLHorizontalAlignment.center,
        tooltipHorizontalOffset = tooltipHorizontalOffset ?? 0,
        maxContentWidth = maxContentWidth ?? 120,
        getTooltipItems = getTooltipItems ?? defaultScatterTooltipItem,
        fitInsideHorizontally = fitInsideHorizontally ?? false,
        fitInsideVertically = fitInsideVertically ?? false,
        rotateAngle = rotateAngle ?? 0.0,
        tooltipBorder = tooltipBorder ?? BorderSide.none,
        super();

  /// The tooltip background color.
  final Color tooltipBgColor;

  /// Sets a rounded radius for the tooltip.
  final double tooltipRoundedRadius;

  /// Applies a padding for showing contents inside the tooltip.
  final EdgeInsets tooltipPadding;

  /// Controls showing tooltip on left side, right side or center aligned with spot, default is center
  final FLHorizontalAlignment tooltipHorizontalAlignment;

  /// Applies horizontal offset for showing tooltip, default is zero.
  final double tooltipHorizontalOffset;

  /// Restricts the tooltip's width.
  final double maxContentWidth;

  /// Retrieves data for showing content inside the tooltip.
  final GetScatterTooltipItems getTooltipItems;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// Controls the rotation of the tooltip.
  final double rotateAngle;

  /// The tooltip border color.
  final BorderSide tooltipBorder;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        tooltipBgColor,
        tooltipRoundedRadius,
        tooltipPadding,
        tooltipHorizontalAlignment,
        tooltipHorizontalOffset,
        maxContentWidth,
        getTooltipItems,
        fitInsideHorizontally,
        fitInsideVertically,
        rotateAngle,
        tooltipBorder,
      ];

  /// Copies current [ScatterTouchTooltipData] to a new [ScatterTouchTooltipData],
  /// and replaces provided values.
  ScatterTouchTooltipData copyWith({
    Color? tooltipBgColor,
    double? tooltipRoundedRadius,
    EdgeInsets? tooltipPadding,
    FLHorizontalAlignment? tooltipHorizontalAlignment,
    double? tooltipHorizontalOffset,
    double? maxContentWidth,
    GetScatterTooltipItems? getTooltipItems,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    double? rotateAngle,
    BorderSide? tooltipBorder,
  }) {
    return ScatterTouchTooltipData(
      tooltipBgColor: tooltipBgColor ?? this.tooltipBgColor,
      tooltipRoundedRadius: tooltipRoundedRadius ?? this.tooltipRoundedRadius,
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
    );
  }
}

/// Provides a [ScatterTooltipItem] for showing content inside the [ScatterTouchTooltipData].
///
/// You can override [ScatterTouchTooltipData.getTooltipItems], it gives you
/// [touchedSpot] that touch happened on,
/// then you should and pass your custom [ScatterTooltipItem]
/// to show it inside the tooltip popup.
typedef GetScatterTooltipItems = ScatterTooltipItem? Function(
  ScatterSpot touchedSpot,
);

/// Default implementation for [ScatterTouchTooltipData.getTooltipItems].
ScatterTooltipItem? defaultScatterTooltipItem(ScatterSpot touchedSpot) {
  final textStyle = TextStyle(
    color: touchedSpot.dotPainter.mainColor,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  if (touchedSpot.dotPainter is FlDotCirclePainter) {
    text = '${(touchedSpot.dotPainter as FlDotCirclePainter).radius.toInt()}';
  } else {
    text = '${touchedSpot.x.toInt()}, ${touchedSpot.y.toInt()}';
  }
  return ScatterTooltipItem(
    text,
    textStyle: textStyle,
  );
}

/// Holds data of showing each item in the tooltip popup.
class ScatterTooltipItem with EquatableMixin {
  /// Shows a [text] with [textStyle], [textDirection],  and optional [children] in the tooltip popup,
  /// [bottomMargin] is the bottom space from spot.
  ScatterTooltipItem(
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

  /// List<TextSpan> add further style and format to the text of the tooltip
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

  /// Copies current [ScatterTooltipItem] to a new [ScatterTooltipItem],
  /// and replaces provided values.
  ScatterTooltipItem copyWith({
    String? text,
    TextStyle? textStyle,
    double? bottomMargin,
    TextAlign? textAlign,
    TextDirection? textDirection,
    List<TextSpan>? children,
  }) {
    return ScatterTooltipItem(
      text ?? this.text,
      textStyle: textStyle ?? this.textStyle,
      bottomMargin: bottomMargin ?? this.bottomMargin,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      children: children ?? this.children,
    );
  }
}

/// It lerps a [ScatterChartData] to another [ScatterChartData] (handles animation for updating values)
class ScatterChartDataTween extends Tween<ScatterChartData> {
  ScatterChartDataTween({
    required ScatterChartData begin,
    required ScatterChartData end,
  }) : super(begin: begin, end: end);

  /// Lerps a [ScatterChartData] based on [t] value, check [Tween.lerp].
  @override
  ScatterChartData lerp(double t) {
    return begin!.lerp(begin!, end!, t);
  }
}

/// It gives you the index value as well as the spot and gets the text style of the label.
typedef GetLabelTextStyleFunction = TextStyle? Function(
  int spotIndex,
  ScatterSpot spot,
);

/// It gives you the index value as well as the spot and returns the label of the spot.
typedef GetLabelFunction = String Function(
  int spotIndex,
  ScatterSpot spot,
);

/// It gives you the default text style of the label for a spot.
TextStyle? getDefaultLabelTextStyleFunction(
  int spotIndex,
  ScatterSpot spot,
) {
  return null;
}

/// It gives you the default label of the spot.
String getDefaultLabelFunction(
  int spotIndex,
  ScatterSpot spot,
) =>
    spot.defaultLabel;

/// Defines information about the labels in the [ScatterChart]
class ScatterLabelSettings with EquatableMixin {
  /// You can change [showLabel] value to show or hide the label,
  /// [textStyle] defines the style of label in the [ScatterChart].
  ScatterLabelSettings({
    bool? showLabel,
    GetLabelTextStyleFunction? getLabelTextStyleFunction,
    GetLabelFunction? getLabelFunction,
    TextDirection? textDirection,
  })  : showLabel = showLabel ?? false,
        getLabelTextStyleFunction =
            getLabelTextStyleFunction ?? getDefaultLabelTextStyleFunction,
        getLabelFunction = getLabelFunction ?? getDefaultLabelFunction,
        textDirection = textDirection ?? TextDirection.ltr;

  /// Determines whether to show or hide the labels.
  final bool showLabel;

  /// This function gives you the index value of the spot in the list and returns the text style.
  final GetLabelTextStyleFunction getLabelTextStyleFunction;

  /// This function gives you the index value of the spot in the list and returns the label.
  final GetLabelFunction getLabelFunction;

  /// Determines the direction of the text for the labels.
  final TextDirection textDirection;

  ScatterLabelSettings copyWith({
    bool? showLabel,
    GetLabelTextStyleFunction? getLabelTextStyleFunction,
    GetLabelFunction? getLabelFunction,
    TextDirection? textDirection,
  }) {
    return ScatterLabelSettings(
      showLabel: showLabel ?? this.showLabel,
      getLabelTextStyleFunction:
          getLabelTextStyleFunction ?? this.getLabelTextStyleFunction,
      getLabelFunction: getLabelFunction ?? this.getLabelFunction,
      textDirection: textDirection ?? this.textDirection,
    );
  }

  /// Lerps a [ScatterLabelSettings] based on [t] value, check [Tween.lerp].
  static ScatterLabelSettings lerp(
    ScatterLabelSettings a,
    ScatterLabelSettings b,
    double t,
  ) {
    return ScatterLabelSettings(
      showLabel: b.showLabel,
      getLabelTextStyleFunction: b.getLabelTextStyleFunction,
      getLabelFunction: b.getLabelFunction,
      textDirection: b.textDirection,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        showLabel,
        getLabelTextStyleFunction,
        getLabelFunction,
        textDirection,
      ];
}
