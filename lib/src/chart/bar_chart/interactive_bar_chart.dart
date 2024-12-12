import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_helper.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_bounds.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_interactive_chart.dart';
import 'package:flutter/widgets.dart';

class InteractiveBarChart extends BaseInteractiveChart<BarChartData> {
  const InteractiveBarChart(
    super.data, {
    this.chartRendererKey,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.linear,
    super.minScale = 1,
    super.maxScale = 3,
    super.key,
  });

  /// We pass this key to our renderers which are supposed to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

  /// The curve to apply when animating the parameters of this container.
  final Curve curve;

  /// The duration over which to animate the parameters of this container.
  final Duration duration;

  @override
  BaseInteractiveChartState<InteractiveBarChart, BarTouchResponse>
      createState() => _InteractiveBarChartState();
}

class _InteractiveBarChartState
    extends BaseInteractiveChartState<InteractiveBarChart, BarTouchResponse> {
  final _barChartHelper = BarChartHelper();
  @override
  AxisChartBounds calculateMaxAxisValues(BarChartData data) {
    final (minY, maxY) = _barChartHelper.calculateMaxAxisValues(
      data.barGroups,
    );

    return AxisChartBounds(
      minX: data.minX,
      maxX: data.maxX,
      minY: minY,
      maxY: maxY,
    );
  }

  @override
  Widget buildInteractiveChart({
    required FlClipData clipData,
    required BaseTouchCallback<BarTouchResponse> touchCallback,
    required AxisChartBounds chartBounds,
    required OnPointerSignal onPointerSignal,
    required OnSizeChanged onSizeChanged,
  }) {
    return BarChart(
      widget.data.copyWith(
        minY: chartBounds.minY,
        maxY: chartBounds.maxY,
        barTouchData: widget.data.barTouchData.copyWith(
          touchCallback: (event, touchResponse) {
            touchCallback(event, touchResponse);
            widget.data.barTouchData.touchCallback?.call(event, touchResponse);
          },
        ),
        clipData: clipData,
      ),
      chartRendererKey: widget.chartRendererKey,
      curve: widget.curve,
      duration: widget.duration,
      onPointerSignal: onPointerSignal,
      onSizeChanged: onSizeChanged,
    );
  }
}
