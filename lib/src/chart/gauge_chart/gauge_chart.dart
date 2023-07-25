import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_data.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_renderer.dart';
import 'package:flutter/widgets.dart';

class GaugeChart extends ImplicitlyAnimatedWidget {
  /// [data] determines how the [GaugeChart] should be look like,
  /// when you make any change in the [GaugeChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const GaugeChart(
    this.data, {
    this.chartRendererKey,
    super.key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
          duration: swapAnimationDuration,
          curve: swapAnimationCurve,
        );

  /// Determines how the [GaugeChartData] should be look like.
  final GaugeChartData data;

  /// We pass this key to our renderers which are supposed to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

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
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _gaugeChartDataTween = visitor(
      _gaugeChartDataTween,
      widget.data,
      (dynamic value) =>
          GaugeChartDataTween(begin: value as GaugeChartData, end: widget.data),
    ) as GaugeChartDataTween?;
  }
}
