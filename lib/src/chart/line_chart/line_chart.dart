import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  Size _chartSize = Size.zero;

  // Default full data range
  late double defaultMinX;
  late double defaultMaxX;
  late double defaultMinY;
  late double defaultMaxY;

  double get defaultDataWidth => defaultMaxX - defaultMinX;
  double get defaultDataHeight => defaultMaxY - defaultMinY;

  // Current transformed data range (after zooming/panning)
  late double currentMinX;
  late double currentMaxX;
  late double currentMinY;
  late double currentMaxY;

  double get currentDataWidth => currentMaxX - currentMinX;
  double get currentDataHeight => currentMaxY - currentMinY;

  // Scale boundaries
  final double minScaleFactor = 1;
  final double maxScaleFactor = 3;

  Offset lastFocalPoint = Offset.zero;
  bool isScaling = false;

  late LineChartData _data;

  double? _scaleStart;
  Offset? _referenceFocalPoint;

  @override
  void initState() {
    _data = _getData();
    updateDefaultDataRange();
    resetData();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant LineChart oldWidget) {
    if (widget.data != _data) {
      _data = _getData();
      updateDefaultDataRange();
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateDefaultDataRange() {
    defaultMinX = _data.minX;
    defaultMaxX = _data.maxX;
    defaultMinY = _data.minY;
    defaultMaxY = _data.maxY;
  }

  void resetDataAndSetState() {
    setState(resetData);
  }

  void resetData() {
    currentMinX = defaultMinX;
    currentMaxX = defaultMaxX;
    currentMinY = defaultMinY;
    currentMaxY = defaultMaxY;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    final double scaleChange;
    switch (event) {
      case final PointerScaleEvent scaleEvent:
        scaleChange = scaleEvent.scale;
      case final PointerScrollEvent scrollEvent:
        final localDelta = PointerEvent.transformDeltaViaPositions(
          untransformedEndPosition:
              scrollEvent.position + scrollEvent.scrollDelta,
          untransformedDelta: scrollEvent.scrollDelta,
          transform: scrollEvent.transform,
        );
        translateDataRangeFromScroll(localDelta: localDelta);
        return;
      default:
        return;
    }

    updateDataRangeForScale(
      focalPixel: event.localPosition,
      scaleChange: scaleChange,
    );
  }

  void translateDataRangeFromScroll({
    required Offset localDelta,
  }) {
    // Convert pixel delta to data delta
    // currentDataWidth and currentDataHeight are the current displayed data ranges
    final dataDeltaX = localDelta.dx * (currentDataWidth / _chartSize.width);
    // Y is inverted because screen Y increases downward while data Y increases upward
    final dataDeltaY = -localDelta.dy * (currentDataHeight / _chartSize.height);

    var newMinX = currentMinX + dataDeltaX;
    var newMaxX = currentMaxX + dataDeltaX;
    var newMinY = currentMinY + dataDeltaY;
    var newMaxY = currentMaxY + dataDeltaY;

    // Clamp and shift to ensure we never exceed default ranges

    // Handle X range
    if (newMinX < defaultMinX) {
      final delta = defaultMinX - newMinX;
      newMinX = defaultMinX;
      newMaxX = math.min(newMaxX + delta, defaultMaxX);
    }
    if (newMaxX > defaultMaxX) {
      final delta = newMaxX - defaultMaxX;
      newMaxX = defaultMaxX;
      newMinX = math.max(newMinX - delta, defaultMinX);
    }

    // Handle Y range
    if (newMinY < defaultMinY) {
      final delta = defaultMinY - newMinY;
      newMinY = defaultMinY;
      newMaxY = math.min(newMaxY + delta, defaultMaxY);
    }
    if (newMaxY > defaultMaxY) {
      final delta = newMaxY - defaultMaxY;
      newMaxY = defaultMaxY;
      newMinY = math.max(newMinY - delta, defaultMinY);
    }

    setState(() {
      currentMinX = newMinX;
      currentMaxX = newMaxX;
      currentMinY = newMinY;
      currentMaxY = newMaxY;
    });
  }

  // After scaling, we want the `focalDataPoint` (the point under the cursor before scaling)
  // to remain at the same pixel (focalPixel).
  // We'll adjust currentMinX, currentMaxX, currentMinY, currentMaxY accordingly.
  void updateDataRangeForScale({
    required Offset focalPixel,
    required double scaleChange,
  }) {
    // Convert the current focal pixel to data coordinates before scaling
    final focalDataPoint = pixelsToData(focalPixel);

    // The new data width/height after scaling
    final newDataWidth = currentDataWidth / scaleChange;
    final newDataHeight = currentDataHeight / scaleChange;

    // Bound the scaling within allowed limits
    final boundedDataWidth = clampDouble(
      newDataWidth,
      defaultDataWidth / maxScaleFactor,
      defaultDataWidth * minScaleFactor,
    );
    final boundedDataHeight = clampDouble(
      newDataHeight,
      defaultDataHeight / maxScaleFactor,
      defaultDataHeight * minScaleFactor,
    );

    // Recalculate scaleChange based on bounded values
    // Just recalculate the effective scale by comparing old data width to new bounded width
    final effectiveScaleX = currentDataWidth / boundedDataWidth;
    final effectiveScaleY = currentDataHeight / boundedDataHeight;

    // Now we solve for newMinX, newMaxX so that focalDataPoint stays under focalPixel.
    // focalPixel.x = dxRatio * chartWidth
    // dxRatio = (focalDataX - newMinX) / newDataWidth
    // => newMinX = focalDataX - dxRatio * newDataWidth
    // But we know dxRatio = focalPixel.dx / size.width
    final dxRatio = focalPixel.dx / _chartSize.width;
    final newWidth = currentDataWidth / effectiveScaleX;
    var newMinX = focalDataPoint.dx - dxRatio * newWidth;
    var newMaxX = newMinX + newWidth;

    // Similarly for Y:
    // dyRatio = (newMaxY - focalDataY) / newDataHeight
    // dyRatio = focalPixel.dy / size.height
    final dyRatio = focalPixel.dy / _chartSize.height;
    final newHeight = currentDataHeight / effectiveScaleY;
    var newMaxY = focalDataPoint.dy + dyRatio * newHeight;
    var newMinY = newMaxY - newHeight;

    // Ensure X range does not exceed defaults
    if (newMinX < defaultMinX) {
      final delta = defaultMinX - newMinX;
      // Shift the range to the right
      final shiftedMinX = defaultMinX;
      final shiftedMaxX = newMaxX + delta;
      // If shiftedMaxX exceeds defaultMaxX, clamp it again (if needed)
      // ... similar logic if the new range surpasses defaultMaxX
      newMinX = shiftedMinX;
      newMaxX = math.min(shiftedMaxX, defaultMaxX);
    }

    if (newMaxX > defaultMaxX) {
      final delta = newMaxX - defaultMaxX;
      // Shift the range to the left
      final shiftedMaxX = defaultMaxX;
      final shiftedMinX = newMinX - delta;
      // If shiftedMinX falls below defaultMinX, clamp it again
      newMaxX = shiftedMaxX;
      newMinX = math.max(shiftedMinX, defaultMinX);
    }

    // Similarly for the Y values
    if (newMinY < defaultMinY) {
      final delta = defaultMinY - newMinY;
      newMinY = defaultMinY;
      newMaxY = math.min(newMaxY + delta, defaultMaxY);
    }

    if (newMaxY > defaultMaxY) {
      final delta = newMaxY - defaultMaxY;
      newMaxY = defaultMaxY;
      newMinY = math.max(newMinY - delta, defaultMinY);
    }

    setState(() {
      currentMinX = newMinX;
      currentMaxX = newMaxX;
      currentMinY = newMinY;
      currentMaxY = newMaxY;
    });
  }

  // Convert a pixel coordinate (localPosition) to data coordinates
  // given the current min/max and size of the chart.
  Offset pixelsToData(Offset pixelPos) {
    final dxRatio = pixelPos.dx / _chartSize.width;
    final dyRatio = pixelPos.dy / _chartSize.height;

    // Assuming Y increases upwards in data, but screen Y increases downward.
    // We'll invert Y mapping.
    final dataX = currentMinX + dxRatio * currentDataWidth;
    final dataY = currentMaxY - dyRatio * currentDataHeight;

    return Offset(dataX, dataY);
  }

  LineChartData _transformData(LineChartData data) {
    final isTransformed = currentMinX != data.minX ||
        currentMaxX != data.maxX ||
        currentMinY != data.minY ||
        currentMaxY != data.maxY;

    final newData = data.copyWith(
      minX: currentMinX,
      maxX: currentMaxX,
      minY: currentMinY,
      maxY: currentMaxY,
      clipData: isTransformed ? const FlClipData.all() : null,
    );

    return newData;
  }

  @override
  Widget build(BuildContext context) {
    final transformedData = _transformData(_data);
    _lineChartDataTween = LineChartDataTween(
      begin: transformedData,
      end: _data,
    );
    return AxisChartScaffoldWidget(
      chart: LayoutBuilder(
        builder: (context, constraints) {
          _chartSize = constraints.biggest;
          return Listener(
            onPointerSignal: _onPointerSignal,
            child: LineChartLeaf(
              data: _withTouchedIndicators(
                _lineChartDataTween!.evaluate(animation),
              ),
              targetData: _withTouchedIndicators(transformedData),
              key: widget.chartRendererKey,
            ),
          );
        },
      ),
      data: transformedData,
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
            // TODO(Peetee06): Add scale/translate touch callback also when enabled or handleBuiltInTouches are false
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

    if (event is FlDoubleTapEvent) {
      resetDataAndSetState();
      return;
    }

    if (event is FlScaleStartEvent) {
      _scaleStart = defaultDataHeight / currentDataHeight;
      _referenceFocalPoint = event.details.localFocalPoint;
    } else if (event is FlScaleUpdateEvent) {
      assert(_scaleStart != null, 'Scale start event must be called first');
      if (event.details.scale != 1) {
        final desiredScale = _scaleStart! * event.details.scale;
        final currentScale = defaultDataHeight / currentDataHeight;
        final scaleChange = desiredScale / currentScale;
        updateDataRangeForScale(
          focalPixel: event.details.localFocalPoint,
          scaleChange: scaleChange,
        );
        return;
      }

      assert(
        _referenceFocalPoint != null,
        'Reference focal point must be set before scale update',
      );

      final translationChange =
          event.details.localFocalPoint - _referenceFocalPoint!;
      translateDataRangeFromScroll(
        localDelta: Offset(-translationChange.dx, -translationChange.dy),
      );
      _referenceFocalPoint = event.details.localFocalPoint;
    } else if (event is FlScaleEndEvent) {
      _scaleStart = null;
      _referenceFocalPoint = null;
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
      _data,
      (dynamic value) =>
          LineChartDataTween(begin: value as LineChartData, end: widget.data),
    ) as LineChartDataTween?;
  }
}
