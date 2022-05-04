import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'line_chart_renderer.dart';

/// Renders a line chart as a widget, using provided [LineChartData].
class LineChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [LineChart] should be look like.
  final LineChartData data;

  /// [data] determines how the [LineChart] should be look like,
  /// when you make any change in the [LineChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const LineChart(
    this.data, {
    Key? key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
            key: key,
            duration: swapAnimationDuration,
            curve: swapAnimationCurve);

  /// Creates a [_LineChartState]
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends AnimatedWidgetBaseState<LineChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [LineChartData] to the new one.
  LineChartDataTween? _lineChartDataTween;

  /// If [LineTouchData.handleBuiltInTouches] is true, we override the callback to handle touches internally,
  /// but we need to keep the provided callback to notify it too.
  BaseTouchCallback<LineTouchResponse>? _providedTouchCallback;

  /// If [LineTouchData.handleBuiltInTouches] is true, we override the callback to handle touches internally,
  /// but we need to keep the provided callback to notify it too.
  BaseTouchCallback<LineTouchResponse>? _providedSecondTouchCallback;

  final Map<int, List<ShowingTooltipIndicators>> _showingMultiTouchedTooltips =
      {0: []};

  final Map<int, Map<int, List<int>>> _showingMultiTouchedIndicators = {0: {}};

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return AxisChartScaffoldWidget(
      chart: LineChartLeaf(
        data: _withTouchedIndicators(_lineChartDataTween!.evaluate(animation)),
        targetData: _withTouchedIndicators(showingData),
      ),
      data: showingData,
    );
  }

  LineChartData _withTouchedIndicators(LineChartData lineChartData) {
    if (!lineChartData.lineTouchData.enabled ||
        !lineChartData.lineTouchData.handleBuiltInTouches) {
      return lineChartData;
    }

    return lineChartData.copyWith(
      showingTooltipIndicators: _showingMultiTouchedTooltips.values
          .fold<List<ShowingTooltipIndicators>>(
              [], (value, element) => [...value, ...element]),
      lineBarsData: lineChartData.lineBarsData.map((barData) {
        final index = lineChartData.lineBarsData.indexOf(barData);

        return barData.copyWith(
          showingIndicators: _showingMultiTouchedIndicators.values
              .map((value) => value[index] ?? [])
              .fold<List<int>>([], (value, element) => [...value, ...element]),
        );
      }).toList(),
    );
  }

  LineChartData _getData() {
    final lineTouchData = widget.data.lineTouchData;
    if (lineTouchData.enabled && lineTouchData.handleBuiltInTouches) {
      _providedTouchCallback = lineTouchData.touchCallback;
      _providedSecondTouchCallback = lineTouchData.secondTouchCallback;
      return widget.data.copyWith(
        lineTouchData: widget.data.lineTouchData
            .copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(
      FlTouchEvent event, LineTouchResponse? touchResponse) {
    if (event is FlMultiDragGestureEvent) {
      final _event = event as FlMultiDragGestureEvent;
      _providedSecondTouchCallback?.call(event, touchResponse);

      _setTouches(event, touchResponse, _event.id);
    } else {
      _providedTouchCallback?.call(event, touchResponse);
      _setTouches(event, touchResponse, 0);
    }
  }

  void _setTouches(
      FlTouchEvent event, LineTouchResponse? touchResponse, int id) {
    _showingMultiTouchedTooltips.putIfAbsent(id, () => []);
    _showingMultiTouchedIndicators.putIfAbsent(id, () => {});
    final showingTouchedTooltips = _showingMultiTouchedTooltips[id]!;
    final showingTouchedIndicators = _showingMultiTouchedIndicators[id]!;
    if (!event.isInterestedForInteractions ||
        touchResponse?.lineBarSpots == null ||
        touchResponse!.lineBarSpots!.isEmpty) {
      setState(() {
        _showingMultiTouchedTooltips.removeWhere((key, value) => key == id);
        _showingMultiTouchedIndicators.removeWhere((key, value) => key == id);
      });
      return;
    }

    setState(() {
      final sortedLineSpots = List.of(touchResponse.lineBarSpots!);
      sortedLineSpots.sort((spot1, spot2) => spot2.y.compareTo(spot1.y));

      showingTouchedIndicators.clear();
      for (var i = 0; i < touchResponse.lineBarSpots!.length; i++) {
        final touchedBarSpot = touchResponse.lineBarSpots![i];
        final barPos = touchedBarSpot.barIndex;
        showingTouchedIndicators[barPos] = [touchedBarSpot.spotIndex];
      }

      showingTouchedTooltips.clear();
      showingTouchedTooltips.add(ShowingTooltipIndicators(sortedLineSpots));
    });
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
