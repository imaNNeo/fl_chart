import 'package:equatable/equatable.dart';
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
  State<InteractiveLineChart> createState() => _InteractiveLineChartState();
}

class _InteractiveLineChartState
    extends BaseInteractiveChartState<InteractiveLineChart> {
  final _lineChartHelper = LineChartHelper();

  @override
  ChartBounds calculateMaxAxisValues(LineChartData data) {
    final (minX, maxX, minY, maxY) = _lineChartHelper.calculateMaxAxisValues(
      data.lineBarsData,
    );

    return ChartBounds(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
    );
  }

  @override
  Widget buildInteractiveChart({
    required FlClipData clipData,
    required BaseTouchCallback touchCallback,
    required ChartBounds chartBounds,
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

class ChartBounds extends Equatable {
  const ChartBounds({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  double get width => maxX - minX;
  double get height => maxY - minY;

  @override
  List<Object?> get props => [minX, maxX, minY, maxY];

  ChartBounds copyWith({
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
  }) {
    return ChartBounds(
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      minY: minY ?? this.minY,
      maxY: maxY ?? this.maxY,
    );
  }
}
