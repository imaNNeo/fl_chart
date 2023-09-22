import 'package:fl_chart/src/chart/base/base_chart/initial_animation_configuration.dart';
import 'package:fl_chart/src/chart/base/base_chart/initial_animation_mixin.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_renderer.dart';
import 'package:flutter/material.dart';

/// Renders a radar chart as a widget, using provided [RadarChartData].
class RadarChart extends ImplicitlyAnimatedWidget {
  /// [data] determines how the [RadarChart] should be look like,
  /// when you make any change in the [RadarChart], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const RadarChart(
    this.data, {
    this.chartRendererKey,
    this.initialAnimationConfiguration = const InitialAnimationConfiguration(),
    super.key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
          duration: swapAnimationDuration,
          curve: swapAnimationCurve,
        );

  /// Determines how the [RadarChart] should be look like.
  final RadarChartData data;

  /// We pass this key to our renderers which are supposed to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

  /// Determines if the initial animation is enabled.
  final InitialAnimationConfiguration initialAnimationConfiguration;

  @override
  _RadarChartState createState() => _RadarChartState();
}

class _RadarChartState extends AnimatedWidgetBaseState<RadarChart>
    with InitialAnimationMixin<RadarChartData, RadarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [RadarChartData] to the new one.
  RadarChartDataTween? _radarChartDataTween;

  @override
  InitialAnimationConfiguration get initialAnimationConfiguration =>
      widget.initialAnimationConfiguration;

  @override
  Tween? get tween => _radarChartDataTween;

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return RadarChartLeaf(
      key: widget.chartRendererKey,
      data: _radarChartDataTween!.evaluate(animation),
      targetData: showingData,
    );
  }

  RadarChartData _getData() {
    return widget.data;
  }

  @override
  RadarChartData getAppearanceAnimationData(RadarChartData data) {
    return data.copyWith(scaleFactor: 0);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _radarChartDataTween =
        visitor(_radarChartDataTween, _getData(), (dynamic value) {
      final initialData = constructInitialData(value as RadarChartData);
      return RadarChartDataTween(
        begin: initialData,
        end: initialData,
      );
    }) as RadarChartDataTween?;
  }
}
