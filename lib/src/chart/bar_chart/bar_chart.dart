import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

/// Renders a bar chart as a widget, using provided [BarChartData].
class BarChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [BarChart] should be look like.
  final BarChartData data;

  /// [data] determines how the [BarChart] should be look like,
  /// when you make any change in the [BarChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const BarChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(duration: swapAnimationDuration, curve: swapAnimationCurve);

  /// Creates a [_BarChartState]
  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends AnimatedWidgetBaseState<BarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [BarChartData] to the new one.
  BarChartDataTween? _barChartDataTween;

  final Map<int, List<int>> _showingTouchedTooltips = {};

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    /// Wr wrapped our chart with [GestureDetector], and onLongPressStart callback.
    /// because we wanted to lock the widget from being scrolled when user long presses on it.
    /// If we found a solution for solve this issue, then we can remove this undoubtedly.
    return GestureDetector(
      onLongPressStart: (details) {},
      child: BarChartLeaf(
        data: _withTouchedIndicators(_barChartDataTween!.evaluate(animation)),
        targetData: _withTouchedIndicators(showingData),
        touchCallback: _handleBuiltInTouch,
      ),
    );
  }

  BarChartData _withTouchedIndicators(BarChartData barChartData) {
    if (!barChartData.barTouchData.enabled || !barChartData.barTouchData.handleBuiltInTouches) {
      return barChartData;
    }

    final newGroups = <BarChartGroupData>[];
    for (var i = 0; i < barChartData.barGroups.length; i++) {
      final group = barChartData.barGroups[i];

      newGroups.add(
        group.copyWith(
          showingTooltipIndicators: _showingTouchedTooltips[i],
        ),
      );
    }

    return barChartData.copyWith(
      barGroups: newGroups,
    );
  }

  BarChartData _getData() {
    final barTouchData = widget.data.barTouchData;
    if (barTouchData.enabled && barTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        barTouchData: widget.data.barTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(BarTouchResponse touchResponse) {
    widget.data.barTouchData.touchCallback?.call(touchResponse);

    if (touchResponse.touchInput is PointerDownEvent ||
        touchResponse.touchInput is PointerMoveEvent ||
        touchResponse.touchInput is PointerHoverEvent) {
      setState(() {
        final spot = touchResponse.spot;
        if (spot == null) {
          _showingTouchedTooltips.clear();
          return;
        }
        final groupIndex = spot.touchedBarGroupIndex;
        final rodIndex = spot.touchedRodDataIndex;

        _showingTouchedTooltips.clear();
        _showingTouchedTooltips[groupIndex] = [rodIndex];
      });
    } else {
      setState(() {
        _showingTouchedTooltips.clear();
      });
    }
  }

  @override
  void forEachTween(visitor) {
    _barChartDataTween = visitor(
      _barChartDataTween,
      widget.data,
      (dynamic value) => BarChartDataTween(begin: value, end: widget.data),
    ) as BarChartDataTween;
  }
}
