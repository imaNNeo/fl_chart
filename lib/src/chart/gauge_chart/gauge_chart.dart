import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_data.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_renderer.dart';
import 'package:flutter/cupertino.dart';

class GaugeChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [GaugeChartData] should be look like.
  final GaugeChartData data;

  /// We pass this key to our renderers which are supposed to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

  /// [data] determines how the [GaugeChart] should be look like,
  /// when you make any change in the [GaugeChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const GaugeChart(
      this.data, {
        this.chartRendererKey,
        Key? key,
        Duration swapAnimationDuration = const Duration(milliseconds: 150),
        Curve swapAnimationCurve = Curves.linear,
      }) : super(
      key: key,
      duration: swapAnimationDuration,
      curve: swapAnimationCurve);

  /// Creates a [_GaugeChartState]
  @override
  _GaugeChartState createState() => _GaugeChartState();
}

class _GaugeChartState extends AnimatedWidgetBaseState<GaugeChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [GaugeChartData] to the new one.
  GaugeChartDataTween? _gaugeChartDataTween;

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return GaugeChartLeaf(
      data: _gaugeChartDataTween!.evaluate(animation),
      targetData: showingData,
    );
  }

  GaugeChartData _getData() {
    return widget.data;
  }

  @override
  void forEachTween(visitor) {
    _gaugeChartDataTween = visitor(
      _gaugeChartDataTween,
      widget.data,
          (dynamic value) => GaugeChartDataTween(begin: value, end: widget.data),
    ) as GaugeChartDataTween;
  }
}