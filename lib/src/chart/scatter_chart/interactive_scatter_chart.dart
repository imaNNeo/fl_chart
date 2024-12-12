import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_bounds.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_interactive_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_data.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_helper.dart';
import 'package:flutter/widgets.dart';

class InteractiveScatterChart extends BaseInteractiveChart<ScatterChartData> {
  const InteractiveScatterChart(
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
  BaseInteractiveChartState<InteractiveScatterChart, ScatterTouchResponse>
      createState() => _InteractiveScatterChartState();
}

class _InteractiveScatterChartState extends BaseInteractiveChartState<
    InteractiveScatterChart, ScatterTouchResponse> {
  @override
  AxisChartBounds calculateMaxAxisValues(ScatterChartData data) {
    final (minX, maxX, minY, maxY) = ScatterChartHelper.calculateMaxAxisValues(
      data.scatterSpots,
    );

    return AxisChartBounds(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
    );
  }

  @override
  Widget buildInteractiveChart({
    required FlClipData clipData,
    required BaseTouchCallback<ScatterTouchResponse> touchCallback,
    required AxisChartBounds chartBounds,
    required OnPointerSignal onPointerSignal,
    required OnSizeChanged onSizeChanged,
  }) {
    return ScatterChart(
      widget.data.copyWith(
        minX: chartBounds.minX,
        maxX: chartBounds.maxX,
        minY: chartBounds.minY,
        maxY: chartBounds.maxY,
        clipData: clipData,
        scatterTouchData: widget.data.scatterTouchData.copyWith(
          touchCallback: (event, touchResponse) {
            touchCallback(event, touchResponse);
            widget.data.scatterTouchData.touchCallback
                ?.call(event, touchResponse);
          },
        ),
      ),
      chartRendererKey: widget.chartRendererKey,
      curve: widget.curve,
      duration: widget.duration,
      onPointerSignal: onPointerSignal,
      onSizeChanged: onSizeChanged,
    );
  }
}
