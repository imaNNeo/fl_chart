import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_renderer.dart';
import 'package:flutter/material.dart';

/// Renders a pie chart as a widget, using provided [CandlestickChartData].
class CandlestickChart extends ImplicitlyAnimatedWidget {
  /// [data] determines how the [CandlestickChart] should be look like,
  /// when you make any change in the [CandlestickChartData], it updates
  /// new values with animation, and duration is [duration].
  /// also you can change the [curve]
  /// which default is [Curves.linear].
  const CandlestickChart(
    this.data, {
    this.chartRendererKey,
    super.key,
    @Deprecated('Please use [duration] instead')
    Duration? swapAnimationDuration,
    Duration duration = const Duration(milliseconds: 150),
    @Deprecated('Please use [curve] instead') Curve? swapAnimationCurve,
    Curve curve = Curves.linear,
    this.transformationConfig = const FlTransformationConfig(),
  }) : super(
          duration: swapAnimationDuration ?? duration,
          curve: swapAnimationCurve ?? curve,
        );

  /// Determines how the [CandlestickChart] should be look like.
  final CandlestickChartData data;

  /// {@macro fl_chart.AxisChartScaffoldWidget.transformationConfig}
  final FlTransformationConfig transformationConfig;

  /// We pass this key to our renderers which are responsible to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

  /// Creates a [_CandlestickChartState]
  @override
  _CandlestickChartState createState() => _CandlestickChartState();
}

class _CandlestickChartState extends AnimatedWidgetBaseState<CandlestickChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [CandlestickChartData] to the new one.
  CandlestickChartDataTween? _candlestickChartDataTween;

  /// If [CandlestickTouchData.handleBuiltInTouches] is true, we override the callback to handle touches internally,
  /// but we need to keep the provided callback to notify it too.
  BaseTouchCallback<CandlestickTouchResponse>? _providedTouchCallback;

  ({
    Offset axisCoordinate,
    int spotIndex,
  })? touchedSpots;

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return AxisChartScaffoldWidget(
      data: showingData,
      transformationConfig: widget.transformationConfig,
      chartBuilder: (context, chartVirtualRect) => CandlestickChartLeaf(
        data: _withTouchedIndicators(
          _candlestickChartDataTween!.evaluate(animation),
        ),
        targetData: _withTouchedIndicators(showingData),
        key: widget.chartRendererKey,
        chartVirtualRect: chartVirtualRect,
        canBeScaled: widget.transformationConfig.scaleAxis != FlScaleAxis.none,
      ),
    );
  }

  CandlestickChartData _withTouchedIndicators(
    CandlestickChartData candlestickChartData,
  ) {
    if (!candlestickChartData.candlestickTouchData.enabled ||
        !candlestickChartData.candlestickTouchData.handleBuiltInTouches) {
      return candlestickChartData;
    }

    final spot = touchedSpots != null && touchedSpots!.spotIndex != -1
        ? candlestickChartData.candlestickSpots[touchedSpots!.spotIndex]
        : null;
    final touchInsideChart = touchedSpots != null &&
        touchedSpots!.axisCoordinate.dx >= candlestickChartData.minX &&
        touchedSpots!.axisCoordinate.dy >= candlestickChartData.minY &&
        touchedSpots!.axisCoordinate.dx <= candlestickChartData.maxX &&
        touchedSpots!.axisCoordinate.dy <= candlestickChartData.maxY;

    final providedPainter = candlestickChartData.touchedPointIndicator?.painter;
    final providedX = candlestickChartData.touchedPointIndicator?.x;
    final providedY = candlestickChartData.touchedPointIndicator?.y;
    return candlestickChartData.copyWith(
      showingTooltipIndicators:
          touchedSpots != null ? [touchedSpots!.spotIndex] : [],
      touchedPointIndicator: touchedSpots != null
          ? AxisSpotIndicator(
              x: providedX ?? spot?.x,
              y: providedY ??
                  (touchInsideChart ? touchedSpots!.axisCoordinate.dy : null),
              painter: providedPainter ??
                  AxisLinesIndicatorPainter(
                    horizontalLineProvider: (y) => HorizontalLine(
                      y: y,
                      color: Theme.of(context).colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                      strokeWidth: 1,
                    ),
                    verticalLineProvider: (x) => VerticalLine(
                      x: x,
                      color: Theme.of(context).colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                      strokeWidth: 1,
                    ),
                  ),
            )
          : null,
    );
  }

  CandlestickChartData _getData() {
    final candlestickTouchData = widget.data.candlestickTouchData;
    if (candlestickTouchData.enabled &&
        candlestickTouchData.handleBuiltInTouches) {
      _providedTouchCallback = candlestickTouchData.touchCallback;
      return widget.data.copyWith(
        candlestickTouchData: widget.data.candlestickTouchData
            .copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(
    FlTouchEvent event,
    CandlestickTouchResponse? touchResponse,
  ) {
    if (!mounted) {
      return;
    }
    _providedTouchCallback?.call(event, touchResponse);

    final desiredTouch = event.isInterestedForInteractions;

    if (!desiredTouch ||
        touchResponse == null ||
        touchResponse.touchedSpot == null) {
      setState(() {
        if (desiredTouch) {
          touchedSpots = (
            axisCoordinate: touchResponse?.touchChartCoordinate ?? Offset.zero,
            spotIndex: -1,
          );
        } else {
          touchedSpots = null;
        }
      });
      return;
    }
    setState(() {
      touchedSpots = (
        axisCoordinate: touchResponse.touchChartCoordinate,
        spotIndex: touchResponse.touchedSpot!.spotIndex,
      );
    });
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _candlestickChartDataTween = visitor(
      _candlestickChartDataTween,
      _getData(),
      (dynamic value) => CandlestickChartDataTween(
        begin: value as CandlestickChartData,
        end: widget.data,
      ),
    ) as CandlestickChartDataTween?;
  }
}
