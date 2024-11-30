import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_pan_axis.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Renders a line chart as a widget, using provided [LineChartData].
class LineChart extends ImplicitlyAnimatedWidget {
  /// [data] determines how the [LineChart] should be look like,
  /// when you make any change in the [LineChartData], it updates
  /// new values with animation, and duration is [duration].
  /// also you can change the [curve]
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

  final List<ShowingTooltipIndicators> _showingTouchedTooltips = [];

  final Map<int, List<int>> _showingTouchedIndicators = {};

  final _lineChartHelper = LineChartHelper();

  late final double _minX;
  late final double _maxX;
  late final double _minY;
  late final double _maxY;

  late final AxisChartDataController<LineChartData> _axisChartDataController;

  @override
  void initState() {
    super.initState();
    final data = _getData();
    _axisChartDataController = AxisChartDataController(data: data);
    _minX = data.minX;
    _maxX = data.maxX;
    _minY = data.minY;
    _maxY = data.maxY;
  }

  @override
  void dispose() {
    _axisChartDataController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _axisChartDataController.value = _getData();
  }

  void _onScaleUpdate(ScaleUpdateDetails details, {bool isTouch = true}) {
    final scale = details.scale;
    if (scale.isNaN || scale == 0) {
      return;
    }

    final factorX = isTouch ? -0.05 : 0.05;
    final factorY = isTouch ? 0.05 : -0.05;

    final dx = details.focalPointDelta.dx * factorX;
    final dy = details.focalPointDelta.dy * factorY;

    final newData = _axisChartDataController.value;

    // Calculate proposed scaled values
    final xScale = scale;
    final yScale = scale;

    var scaledMinX = newData.minX * xScale;
    var scaledMaxX = newData.maxX / xScale;
    var scaledMinY = newData.minY * yScale;
    var scaledMaxY = newData.maxY / yScale;

    // Store the scaled widths
    final xWidth = scaledMaxX - scaledMinX;
    final yWidth = scaledMaxY - scaledMinY;

    // Adjust min values and maintain width
    if (scaledMinX < _minX) {
      scaledMinX = _minX;
      scaledMaxX = _minX + xWidth;
    }
    if (scaledMinY < _minY) {
      scaledMinY = _minY;
      scaledMaxY = _minY + yWidth;
    }

    // Adjust max values and maintain width
    if (scaledMaxX > _maxX) {
      scaledMaxX = _maxX;
      scaledMinX = _maxX - xWidth;
    }
    if (scaledMaxY > _maxY) {
      scaledMaxY = _maxY;
      scaledMinY = _maxY - yWidth;
    }

    // Final safety clamp
    scaledMinX = scaledMinX.clamp(_minX, _maxX);
    scaledMaxX = scaledMaxX.clamp(_minX, _maxX);
    scaledMinY = scaledMinY.clamp(_minY, _maxY);
    scaledMaxY = scaledMaxY.clamp(_minY, _maxY);

    // Ensure minimum distance is maintained
    final xDistance = scaledMaxX - scaledMinX;
    final yDistance = scaledMaxY - scaledMinY;

    if (xDistance < 0.5 * (_maxX - _minX) ||
        yDistance < 0.5 * (_maxY - _minY)) {
      scaledMinX = newData.minX;
      scaledMaxX = newData.maxX;
      scaledMinY = newData.minY;
      scaledMaxY = newData.maxY;
    }

    // Calculate translation within bounds
    var translatedMinX = scaledMinX + dx;
    var translatedMaxX = scaledMaxX + dx;
    var translatedMinY = scaledMinY + dy;
    var translatedMaxY = scaledMaxY + dy;

    // Clamp translated values
    if (translatedMinX < _minX) {
      translatedMaxX += _minX - translatedMinX;
      translatedMinX = _minX;
    }
    if (translatedMaxX > _maxX) {
      translatedMinX -= translatedMaxX - _maxX;
      translatedMaxX = _maxX;
    }
    if (translatedMinY < _minY) {
      translatedMaxY += _minY - translatedMinY;
      translatedMinY = _minY;
    }
    if (translatedMaxY > _maxY) {
      translatedMinY -= translatedMaxY - _maxY;
      translatedMaxY = _maxY;
    }

    final isScaled = (translatedMinX - _minX).abs() > 0.01 ||
        (translatedMaxX - _maxX).abs() > 0.01 ||
        (translatedMinY - _minY).abs() > 0.01 ||
        (translatedMaxY - _maxY).abs() > 0.01;

    if (!isScaled) {
      _resetScale();
      return;
    }

    final scaledData = newData.copyWith(
      minX: _round(translatedMinX),
      maxX: _round(translatedMaxX),
      minY: _round(translatedMinY),
      maxY: _round(translatedMaxY),
      clipData: isScaled ? const FlClipData.all() : null,
    );

    _axisChartDataController.value = scaledData;

    setState(() {
      _lineChartDataTween = LineChartDataTween(
        begin: _axisChartDataController.value,
        end: scaledData,
      );
    });
  }

  void _onPointerSignal(PointerSignalEvent event) {
    switch (event) {
      case final PointerScaleEvent scaleEvent:
        _onScaleUpdate(
          ScaleUpdateDetails(
            scale: scaleEvent.scale,
            focalPointDelta: scaleEvent.delta,
          ),
          isTouch: false,
        );

      case final PointerScrollEvent scrollEvent:
        if (scrollEvent.kind == PointerDeviceKind.trackpad) {
          _onScaleUpdate(
            ScaleUpdateDetails(
              focalPointDelta: scrollEvent.scrollDelta,
            ),
            isTouch: false,
          );
          return;
        }
        // Ignore left and right mouse wheel scroll.
        if (scrollEvent.scrollDelta.dy == 0.0) {
          return;
        }
        _onScaleUpdate(
          ScaleUpdateDetails(
            scale: math.exp(-scrollEvent.scrollDelta.dy),
            focalPointDelta: scrollEvent.scrollDelta,
          ),
          isTouch: false,
        );

      default:
        return;
    }
  }

  void _resetScale() {
    _axisChartDataController.value = _getData();
    setState(() {
      _lineChartDataTween = LineChartDataTween(
        begin: _axisChartDataController.value,
        end: _getData(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _onPointerSignal,
      child: GestureDetector(
        onScaleUpdate: _onScaleUpdate,
        onDoubleTap: _resetScale,
        child: ValueListenableBuilder<LineChartData>(
          valueListenable: _axisChartDataController,
          builder: (context, data, child) => AxisChartScaffoldWidget(
            chart: LineChartLeaf(
              data: _withTouchedIndicators(
                _lineChartDataTween!.evaluate(animation),
              ),
              targetData: _withTouchedIndicators(data),
              key: widget.chartRendererKey,
            ),
            data: data,
          ),
        ),
      ),
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
    var newData = widget.data;

    /// Calculate minX, maxX, minY, maxY for [LineChartData] if they are null,
    /// it is necessary to render the chart correctly.
    if (newData.minX.isNaN ||
        newData.maxX.isNaN ||
        newData.minY.isNaN ||
        newData.maxY.isNaN) {
      final (minX, maxX, minY, maxY) = _lineChartHelper.calculateMaxAxisValues(
        newData.lineBarsData,
      );
      newData = newData.copyWith(
        minX: newData.minX.isNaN ? minX : newData.minX,
        maxX: newData.maxX.isNaN ? maxX : newData.maxX,
        minY: newData.minY.isNaN ? minY : newData.minY,
        maxY: newData.maxY.isNaN ? maxY : newData.maxY,
      );
    }

    final lineTouchData = newData.lineTouchData;
    if (lineTouchData.enabled && lineTouchData.handleBuiltInTouches) {
      _providedTouchCallback = lineTouchData.touchCallback;
      newData = newData.copyWith(
        lineTouchData:
            newData.lineTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }

    return newData;
  }

  void _handleBuiltInTouch(
    FlTouchEvent event,
    LineTouchResponse? touchResponse,
  ) {
    if (!mounted) {
      return;
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

  double _round(double value) {
    if (value == 0) return 0;

    final fac = math.pow(10, 2).toInt();
    return (value * fac).round() / fac;
  }
}
