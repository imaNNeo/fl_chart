import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_renderer.dart';
import 'package:flutter/material.dart';

/// Renders a radar chart as a widget, using provided [RadarChartData].
class RadarChart extends ImplicitlyAnimatedWidget {
  /// [data] determines how the [RadarChart] should be look like,
  /// when you make any change in the [RadarChart], it updates
  /// new values with animation, and duration is [duration].
  /// also you can change the [curve]
  /// which default is [Curves.linear].
  const RadarChart(
    this.data, {
    super.key,
    @Deprecated('Please use [duration] instead')
    Duration? swapAnimationDuration,
    Duration duration = const Duration(milliseconds: 150),
    @Deprecated('Please use [curve] instead') Curve? swapAnimationCurve,
    Curve curve = Curves.linear,
  }) : super(
          duration: swapAnimationDuration ?? duration,
          curve: swapAnimationCurve ?? curve,
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

  RadarChartData _getDate() => widget.data;

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
