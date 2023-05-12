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
    super.key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
          duration: swapAnimationDuration,
          curve: swapAnimationCurve,
        );

  /// Determines how the [RadarChart] should be look like.
  final RadarChartData data;

  @override
  _RadarChartState createState() => _RadarChartState();
}

class _RadarChartState extends AnimatedWidgetBaseState<RadarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [RadarChartData] to the new one.
  RadarChartDataTween? _radarChartDataTween;

  @override
  Widget build(BuildContext context) {
    final showingData = _getDate();

    return RadarChartLeaf(
      data: _radarChartDataTween!.evaluate(animation),
      targetData: showingData,
    );
  }

  RadarChartData _getDate() {
    return widget.data;
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _radarChartDataTween = visitor(
      _radarChartDataTween,
      widget.data,
      (dynamic value) =>
          RadarChartDataTween(begin: value as RadarChartData, end: widget.data),
    ) as RadarChartDataTween?;
  }
}
