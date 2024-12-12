import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_bounds.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_interactive_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';
import 'package:flutter/cupertino.dart';

class InteractiveLineChart extends BaseInteractiveChart<LineChartData> {
  const InteractiveLineChart(
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
  BaseInteractiveChartState<InteractiveLineChart, LineTouchResponse>
      createState() => _InteractiveLineChartState();
}

class _InteractiveLineChartState
    extends BaseInteractiveChartState<InteractiveLineChart, LineTouchResponse> {
  final _lineChartHelper = LineChartHelper();

  @override
  AxisChartBounds calculateMaxAxisValues(LineChartData data) {
    final (minX, maxX, minY, maxY) = _lineChartHelper.calculateMaxAxisValues(
      data.lineBarsData,
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
    required BaseTouchCallback<LineTouchResponse> touchCallback,
    required AxisChartBounds chartBounds,
    required OnPointerSignal onPointerSignal,
    required OnSizeChanged onSizeChanged,
  }) {
    return LineChart(
      widget.data.copyWith(
        minX: chartBounds.minX,
        maxX: chartBounds.maxX,
        minY: chartBounds.minY,
        maxY: chartBounds.maxY,
        clipData: clipData,
        lineTouchData: widget.data.lineTouchData.copyWith(
          touchCallback: touchCallback,
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
