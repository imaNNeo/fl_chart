import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_renderer.dart';
import 'package:flutter/cupertino.dart';

/// Renders a pie chart as a widget, using provided [ScatterChartData].
class ScatterChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [ScatterChart] should be look like.
  final ScatterChartData data;

  /// We pass this key to our renderers which are responsible to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

  /// [data] determines how the [ScatterChart] should be look like,
  /// when you make any change in the [ScatterChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const ScatterChart(
    this.data, {
    this.chartRendererKey,
    Key? key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
            key: key,
            duration: swapAnimationDuration,
            curve: swapAnimationCurve);

  /// Creates a [_ScatterChartState]
  @override
  _ScatterChartState createState() => _ScatterChartState();
}

class _ScatterChartState extends AnimatedWidgetBaseState<ScatterChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [ScatterChartData] to the new one.
  ScatterChartDataTween? _scatterChartDataTween;

  /// If [ScatterTouchData.handleBuiltInTouches] is true, we override the callback to handle touches internally,
  /// but we need to keep the provided callback to notify it too.
  BaseTouchCallback<ScatterTouchResponse>? _providedTouchCallback;

  List<int> touchedSpots = [];

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return AxisChartScaffoldWidget(
      data: showingData,
      chart: ScatterChartLeaf(
        data:
            _withTouchedIndicators(_scatterChartDataTween!.evaluate(animation)),
        targetData: _withTouchedIndicators(showingData),
        key: widget.chartRendererKey,
      ),
    );
  }

  ScatterChartData _withTouchedIndicators(ScatterChartData scatterChartData) {
    if (!scatterChartData.scatterTouchData.enabled ||
        !scatterChartData.scatterTouchData.handleBuiltInTouches) {
      return scatterChartData;
    }

    return scatterChartData.copyWith(
      showingTooltipIndicators: touchedSpots,
    );
  }

  ScatterChartData _getData() {
    final scatterTouchData = widget.data.scatterTouchData;
    if (scatterTouchData.enabled && scatterTouchData.handleBuiltInTouches) {
      _providedTouchCallback = scatterTouchData.touchCallback;
      return widget.data.copyWith(
        scatterTouchData: widget.data.scatterTouchData
            .copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(
      FlTouchEvent event, ScatterTouchResponse? touchResponse) {
    _providedTouchCallback?.call(event, touchResponse);

    final desiredTouch = event is FlPanDownEvent ||
        event is FlPanUpdateEvent ||
        event is FlPointerHoverEvent;

    if (!desiredTouch ||
        touchResponse == null ||
        touchResponse.touchedSpot == null) {
      setState(() {
        touchedSpots = [];
      });
      return;
    }
    setState(() {
      touchedSpots = [touchResponse.touchedSpot!.spotIndex];
    });
  }

  @override
  void forEachTween(visitor) {
    _scatterChartDataTween = visitor(
      _scatterChartDataTween,
      _getData(),
      (dynamic value) => ScatterChartDataTween(begin: value, end: widget.data),
    ) as ScatterChartDataTween;
  }
}
