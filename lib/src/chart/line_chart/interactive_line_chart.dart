import 'dart:math' as math;
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/fl_touch_event.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class InteractiveLineChart extends StatefulWidget {
  const InteractiveLineChart(
    this.data, {
    this.chartRendererKey,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.linear,
    this.minScale = 1,
    this.maxScale = 3,
    super.key,
  });

  final double minScale;
  final double maxScale;

  /// Determines how the [LineChart] should be look like.
  final LineChartData data;

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

class _InteractiveLineChartState extends State<InteractiveLineChart> {
  late ChartBounds _dataBounds;
  late ChartBounds _adjustedDataBounds;

  Size _chartSize = Size.zero;

  double? _scaleStart;
  Offset? _referenceFocalPoint;

  @override
  void initState() {
    updateDataBounds();
    resetAdjustedDataBounds();
    super.initState();
  }

  void updateDataBounds() {
    _dataBounds = ChartBounds(
      minX: widget.data.minX,
      maxX: widget.data.maxX,
      minY: widget.data.minY,
      maxY: widget.data.maxY,
    );
  }

  void resetAdjustedDataBounds() {
    _adjustedDataBounds = _dataBounds.copyWith();
  }

  void resetDataBoundsAndSetState() {
    setState(resetAdjustedDataBounds);
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

  void _onBuiltInTouch(FlTouchEvent event, LineTouchResponse? touchResponse) {
    if (!mounted) {
      return;
    }

    switch (event) {
      case FlDoubleTapEvent():
        resetDataBoundsAndSetState();
        return;

      case FlScaleStartEvent():
        _scaleStart = _dataBounds.height / _adjustedDataBounds.height;
        _referenceFocalPoint = event.details.localFocalPoint;

      case FlScaleUpdateEvent():
        assert(_scaleStart != null, 'Scale start event must be called first');
        if (event.details.scale != 1) {
          final desiredScale = _scaleStart! * event.details.scale;
          final currentScale = _dataBounds.height / _adjustedDataBounds.height;
          final scaleChange = desiredScale / currentScale;
          updateDataRangeForScale(
            focalPixel: event.details.localFocalPoint,
            scaleChange: scaleChange,
          );
          return;
        } else {
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
        }

      case FlScaleEndEvent():
        _scaleStart = null;
        _referenceFocalPoint = null;
    }
  }

  void translateDataRangeFromScroll({
    required Offset localDelta,
  }) {
    // Convert pixel delta to data delta
    // currentDataWidth and currentDataHeight are the current displayed data ranges
    final dataDeltaX =
        localDelta.dx * (_adjustedDataBounds.width / _chartSize.width);
    // Y is inverted because screen Y increases downward while data Y increases upward
    final dataDeltaY =
        -localDelta.dy * (_adjustedDataBounds.height / _chartSize.height);

    var newMinX = _adjustedDataBounds.minX + dataDeltaX;
    var newMaxX = _adjustedDataBounds.maxX + dataDeltaX;
    var newMinY = _adjustedDataBounds.minY + dataDeltaY;
    var newMaxY = _adjustedDataBounds.maxY + dataDeltaY;

    // Clamp and shift to ensure we never exceed default ranges

    // Handle X range
    if (newMinX < _dataBounds.minX) {
      final delta = _dataBounds.minX - newMinX;
      newMinX = _dataBounds.minX;
      newMaxX = math.min(newMaxX + delta, _dataBounds.maxX);
    }
    if (newMaxX > _dataBounds.maxX) {
      final delta = newMaxX - _dataBounds.maxX;
      newMaxX = _dataBounds.maxX;
      newMinX = math.max(newMinX - delta, _dataBounds.minX);
    }

    // Handle Y range
    if (newMinY < _dataBounds.minY) {
      final delta = _dataBounds.minY - newMinY;
      newMinY = _dataBounds.minY;
      newMaxY = math.min(newMaxY + delta, _dataBounds.maxY);
    }
    if (newMaxY > _dataBounds.maxY) {
      final delta = newMaxY - _dataBounds.maxY;
      newMaxY = _dataBounds.maxY;
      newMinY = math.max(newMinY - delta, _dataBounds.minY);
    }

    setState(() {
      _adjustedDataBounds = ChartBounds(
        minX: newMinX,
        maxX: newMaxX,
        minY: newMinY,
        maxY: newMaxY,
      );
    });
  }

  void updateDataRangeForScale({
    required Offset focalPixel,
    required double scaleChange,
  }) {
    // Convert the current focal pixel to data coordinates before scaling
    final focalDataPoint = pixelsToData(focalPixel);

    // The new data width/height after scaling
    final newDataWidth = _adjustedDataBounds.width / scaleChange;
    final newDataHeight = _adjustedDataBounds.height / scaleChange;

    // Bound the scaling within allowed limits
    final boundedDataWidth = clampDouble(
      newDataWidth,
      _dataBounds.width / widget.maxScale,
      _dataBounds.width * widget.minScale,
    );
    final boundedDataHeight = clampDouble(
      newDataHeight,
      _dataBounds.height / widget.maxScale,
      _dataBounds.height * widget.minScale,
    );

    // Recalculate scaleChange based on bounded values
    // Just recalculate the effective scale by comparing old data width to new bounded width
    final effectiveScaleX = _adjustedDataBounds.width / boundedDataWidth;
    final effectiveScaleY = _adjustedDataBounds.height / boundedDataHeight;

    // Now we solve for newMinX, newMaxX so that focalDataPoint stays under focalPixel.
    // focalPixel.x = dxRatio * chartWidth
    // dxRatio = (focalDataX - newMinX) / newDataWidth
    // => newMinX = focalDataX - dxRatio * newDataWidth
    // But we know dxRatio = focalPixel.dx / size.width
    final dxRatio = focalPixel.dx / _chartSize.width;
    final newWidth = _adjustedDataBounds.width / effectiveScaleX;
    var newMinX = focalDataPoint.dx - dxRatio * newWidth;
    var newMaxX = newMinX + newWidth;

    // Similarly for Y:
    // dyRatio = (newMaxY - focalDataY) / newDataHeight
    // dyRatio = focalPixel.dy / size.height
    final dyRatio = focalPixel.dy / _chartSize.height;
    final newHeight = _adjustedDataBounds.height / effectiveScaleY;
    var newMaxY = focalDataPoint.dy + dyRatio * newHeight;
    var newMinY = newMaxY - newHeight;

    // Ensure X range does not exceed defaults
    if (newMinX < _dataBounds.minX) {
      final delta = _dataBounds.minX - newMinX;
      // Shift the range to the right
      final shiftedMinX = _dataBounds.minX;
      final shiftedMaxX = newMaxX + delta;
      // If shiftedMaxX exceeds defaultMaxX, clamp it again (if needed)
      // ... similar logic if the new range surpasses defaultMaxX
      newMinX = shiftedMinX;
      newMaxX = math.min(shiftedMaxX, _dataBounds.maxX);
    }

    if (newMaxX > _dataBounds.maxX) {
      final delta = newMaxX - _dataBounds.maxX;
      // Shift the range to the left
      final shiftedMaxX = _dataBounds.maxX;
      final shiftedMinX = newMinX - delta;
      // If shiftedMinX falls below defaultMinX, clamp it again
      newMaxX = shiftedMaxX;
      newMinX = math.max(shiftedMinX, _dataBounds.minX);
    }

    // Similarly for the Y values
    if (newMinY < _dataBounds.minY) {
      final delta = _dataBounds.minY - newMinY;
      newMinY = _dataBounds.minY;
      newMaxY = math.min(newMaxY + delta, _dataBounds.maxY);
    }

    if (newMaxY > _dataBounds.maxY) {
      final delta = newMaxY - _dataBounds.maxY;
      newMaxY = _dataBounds.maxY;
      newMinY = math.max(newMinY - delta, _dataBounds.minY);
    }

    setState(() {
      _adjustedDataBounds = ChartBounds(
        minX: newMinX,
        maxX: newMaxX,
        minY: newMinY,
        maxY: newMaxY,
      );
    });
  }

  Offset pixelsToData(Offset pixelPos) {
    final dxRatio = pixelPos.dx / _chartSize.width;
    final dyRatio = pixelPos.dy / _chartSize.height;

    // Assuming Y increases upwards in data, but screen Y increases downward.
    // We'll invert Y mapping.
    final dataX =
        _adjustedDataBounds.minX + dxRatio * _adjustedDataBounds.width;
    final dataY =
        _adjustedDataBounds.maxY - dyRatio * _adjustedDataBounds.height;

    return Offset(dataX, dataY);
  }

  @override
  Widget build(BuildContext context) {
    final isTransformed = _adjustedDataBounds.minX != widget.data.minX ||
        _adjustedDataBounds.maxX != widget.data.maxX ||
        _adjustedDataBounds.minY != widget.data.minY ||
        _adjustedDataBounds.maxY != widget.data.maxY;
    return LineChart(
      widget.data.copyWith(
        minX: _adjustedDataBounds.minX,
        maxX: _adjustedDataBounds.maxX,
        minY: _adjustedDataBounds.minY,
        maxY: _adjustedDataBounds.maxY,
        clipData: isTransformed ? const FlClipData.all() : widget.data.clipData,
        lineTouchData: widget.data.lineTouchData.copyWith(
          touchCallback: (event, touchResponse) {
            _onBuiltInTouch(event, touchResponse);
            widget.data.lineTouchData.touchCallback?.call(
              event,
              touchResponse,
            );
          },
        ),
      ),
      chartRendererKey: widget.chartRendererKey,
      curve: widget.curve,
      duration: widget.duration,
      onPointerSignal: _onPointerSignal,
      onSizeChanged: (size) {
        _chartSize = size;
      },
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

  ChartBounds translate(Offset delta) {
    return copyWith(
      minX: minX + delta.dx,
      maxX: maxX + delta.dx,
      minY: minY + delta.dy,
      maxY: maxY + delta.dy,
    );
  }
}
