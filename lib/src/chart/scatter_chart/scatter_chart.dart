import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_data.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

/// Renders a pie chart as a widget, using provided [ScatterChartData].
class ScatterChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [ScatterChart] should be look like.
  final ScatterChartData data;

  /// [data] determines how the [ScatterChart] should be look like,
  /// when you make any change in the [ScatterChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const ScatterChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  /// Creates a [_ScatterChartState]
  @override
  _ScatterChartState createState() => _ScatterChartState();
}

class _ScatterChartState extends AnimatedWidgetBaseState<ScatterChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [ScatterChartData] to the new one.
  ScatterChartDataTween? _scatterChartDataTween;

  List<int> touchedSpots = [];

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return ScatterChartLeaf(
      data: _withTouchedIndicators(_scatterChartDataTween!.evaluate(animation)),
      targetData: _withTouchedIndicators(showingData),
      touchCallback: _handleBuiltInTouch,
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
      return widget.data.copyWith(
        scatterTouchData: widget.data.scatterTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(ScatterTouchResponse touchResponse) {
    widget.data.scatterTouchData.touchCallback?.call(touchResponse);

    if (touchResponse.touchInput is PointerDownEvent ||
        touchResponse.touchInput is PointerMoveEvent ||
        touchResponse.touchInput is PointerHoverEvent) {
      setState(() {
        touchedSpots = [touchResponse.touchedSpotIndex];
      });
    } else {
      setState(() {
        touchedSpots = [];
      });
    }
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
