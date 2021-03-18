import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'line_chart_data.dart';
import 'line_chart_renderer.dart';

/// Renders a line chart as a widget, using provided [LineChartData].
class LineChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [LineChart] should be look like.
  final LineChartData data;

  /// [data] determines how the [LineChart] should be look like,
  /// when you make any change in the [LineChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const LineChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  /// Creates a [_LineChartState]
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends AnimatedWidgetBaseState<LineChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [LineChartData] to the new one.
  LineChartDataTween? _lineChartDataTween;

  final List<ShowingTooltipIndicators> _showingTouchedTooltips = [];

  final Map<int, List<int>> _showingTouchedIndicators = {};

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return LineChartLeaf(
      data: _withTouchedIndicators(_lineChartDataTween!.evaluate(animation)),
      targetData: _withTouchedIndicators(showingData),
      touchCallback: _handleBuiltInTouch,
    );
  }

  LineChartData _withTouchedIndicators(LineChartData lineChartData) {
    if (!lineChartData.lineTouchData.enabled || !lineChartData.lineTouchData.handleBuiltInTouches) {
      return lineChartData;
    }

    return lineChartData.copyWith(
      showingTooltipIndicators: _showingTouchedTooltips,
      lineBarsData: lineChartData.lineBarsData.map((barData) {
        final index = lineChartData.lineBarsData.indexOf(barData);
        return barData.copyWith(
          showingIndicators: _showingTouchedIndicators[index] ?? [],
        );
      }).toList(),
    );
  }

  LineChartData _getData() {
    final lineTouchData = widget.data.lineTouchData;
    if (lineTouchData.enabled && lineTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        lineTouchData: widget.data.lineTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(LineTouchResponse touchResponse) {
    widget.data.lineTouchData.touchCallback?.call(touchResponse);

    if (touchResponse.touchInput is PointerDownEvent ||
        touchResponse.touchInput is PointerMoveEvent ||
        touchResponse.touchInput is PointerHoverEvent) {
      setState(() {
        final sortedLineSpots = List.of(touchResponse.lineBarSpots);
        sortedLineSpots.sort((spot1, spot2) => spot2.y.compareTo(spot1.y));

        _showingTouchedIndicators.clear();
        for (var i = 0; i < touchResponse.lineBarSpots.length; i++) {
          final touchedBarSpot = touchResponse.lineBarSpots[i];
          final barPos = touchedBarSpot.barIndex;
          _showingTouchedIndicators[barPos] = [touchedBarSpot.spotIndex];
        }

        _showingTouchedTooltips.clear();
        _showingTouchedTooltips.add(ShowingTooltipIndicators(0, sortedLineSpots));
      });
    } else {
      setState(() {
        _showingTouchedTooltips.clear();
        _showingTouchedIndicators.clear();
      });
    }
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _lineChartDataTween = visitor(
      _lineChartDataTween,
      _getData(),
      (dynamic value) => LineChartDataTween(begin: value, end: widget.data),
    ) as LineChartDataTween;
  }
}
