import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Renders a line chart as a widget, using provided [LineChartData].
class LineChart extends ImplicitlyAnimatedWidget {
  /// [data] determines how the [LineChart] should be look like,
  /// when you make any change in the [LineChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const LineChart(
    this.data, {
    this.chartRendererKey,
    super.key,
    super.duration = const Duration(milliseconds: 150),
    super.curve = Curves.linear,
  });

  /// Determines how the [LineChart] should be look like.
  final LineChartData data;

  /// We pass this key to our renderers which are supposed to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

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

  DragSpotUpdatedCallback? _dragSpotUpdatedCallback;

  final List<ShowingTooltipIndicators> _showingTouchedTooltips = [];

  final Map<int, List<int>> _showingTouchedIndicators = {};

  List<LineChartBarData> _lineBarsData = [];

  /// Keeps index of bar and spot that currently is being dragging
  (int barIndex, int spotIndex)? _draggingSpotIndexes;

  bool get _isAnyDraggable =>
      _lineBarsData.indexWhere((lineBarData) => lineBarData.isDraggable) != -1;

  @override
  void initState() {
    _lineBarsData = List.from(widget.data.lineBarsData);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LineChart oldWidget) {
    if (widget.data.lineBarsData != _lineBarsData) {
      _lineBarsData = List.from(widget.data.lineBarsData);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return AxisChartScaffoldWidget(
      chart: LineChartLeaf(
        data: _withTouchedIndicators(_lineChartDataTween!.evaluate(animation)),
        targetData: _withTouchedIndicators(showingData),
        key: widget.chartRendererKey,
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
      _providedTouchCallback = lineTouchData.touchCallback;
      _dragSpotUpdatedCallback = lineTouchData.dragSpotUpdatedCallback;
      return widget.data.copyWith(
        lineBarsData: _lineBarsData,
        lineTouchData: widget.data.lineTouchData.copyWith(
          touchCallback: _handleBuiltInTouch,
          distanceCalculator: _isAnyDraggable ? vectorDistanceCalculator : null,
        ),
      );
    }

    return widget.data;
  }

  void _handleBuiltInTouch(
    FlTouchEvent event,
    LineTouchResponse? touchResponse,
  ) {
    if (!mounted) {
      return;
    }

    // Cancel dragging
    if (event is FlPanEndEvent || event is FlLongPressEnd) {
      setState(() {
        _draggingSpotIndexes = null;
      });
    }

    // if indexes of dragging spot exist, changes it's position
    if (_draggingSpotIndexes != null) {
      final (barIndex, spotIndex) = _draggingSpotIndexes!;
      setState(() {
        _lineBarsData[barIndex].spots[spotIndex] =
            touchResponse!.touchedAxesPoint!;
      });
      _dragSpotUpdatedCallback?.call(
        UpdatedDragSpotsData(
          barIndex,
          spotIndex,
          _lineBarsData[barIndex].spots,
        ),
      );
    }

    _providedTouchCallback?.call(event, touchResponse);
    if (!event.isInterestedForInteractions ||
        touchResponse?.lineBarSpots == null ||
        touchResponse!.lineBarSpots!.isEmpty) {
      setState(() {
        _showingTouchedTooltips.clear();
        _showingTouchedIndicators.clear();
      });
      return;
    }

    setState(() {
      final sortedLineSpots = List.of(touchResponse.lineBarSpots!)
        ..sort((spot1, spot2) => spot2.y.compareTo(spot1.y));

      _showingTouchedIndicators.clear();
      for (var i = 0; i < touchResponse.lineBarSpots!.length; i++) {
        final touchedBarSpot = touchResponse.lineBarSpots![i];
        final barPos = touchedBarSpot.barIndex;
        _showingTouchedIndicators[barPos] = [touchedBarSpot.spotIndex];
      }

      _showingTouchedTooltips
        ..clear()
        ..add(ShowingTooltipIndicators(sortedLineSpots));
    });

    // If there is needed event and any lineBar with .isDraggable flag exists,
    // sets indexes of needed spot and starts dragging process.
    if (event is FlPanStartEvent || event is FlLongPressStart) {
      final barIndex = touchResponse.lineBarSpots?.first.barIndex;
      final spotIndex = touchResponse.lineBarSpots?.first.spotIndex;

      if (spotIndex != null && barIndex != null) {
        final isDraggable = widget.data.lineBarsData[barIndex].isDraggable;

        if (isDraggable) {
          setState(() {
            _draggingSpotIndexes = (barIndex, spotIndex);
          });
        }
      }
    }
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _lineChartDataTween = visitor(
      _lineChartDataTween,
      _getData(),
      (dynamic value) =>
          LineChartDataTween(begin: value as LineChartData, end: widget.data),
    ) as LineChartDataTween?;
  }
}
