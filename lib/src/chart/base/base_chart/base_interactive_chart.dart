import 'dart:math' as math;

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/fl_touch_event.dart';
import 'package:fl_chart/src/chart/line_chart/interactive_line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

typedef OnPointerSignal = void Function(PointerSignalEvent event);
typedef OnSizeChanged = void Function(Size size);

abstract class BaseInteractiveChart<D extends AxisChartData>
    extends StatefulWidget {
  const BaseInteractiveChart(
    this.data, {
    this.minScale = 1,
    this.maxScale = 3,
    super.key,
  });

  final double minScale;
  final double maxScale;

  final D data;
}

abstract class BaseInteractiveChartState<T extends BaseInteractiveChart>
    extends State<T> {
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

  ChartBounds calculateMaxAxisValues(covariant AxisChartData data);

  void updateDataBounds() {
    var newData = widget.data;

    /// If the data bounds are not set, calculate them.
    if (newData.minX.isNaN ||
        newData.maxX.isNaN ||
        newData.minY.isNaN ||
        newData.maxY.isNaN) {
      final axisBounds = calculateMaxAxisValues(newData);

      newData = newData.copyWithBounds(
        ChartBounds(
          minX: newData.minX.isNaN ? axisBounds.minX : newData.minX,
          maxX: newData.maxX.isNaN ? axisBounds.maxX : newData.maxX,
          minY: newData.minY.isNaN ? axisBounds.minY : newData.minY,
          maxY: newData.maxY.isNaN ? axisBounds.maxY : newData.maxY,
        ),
      );
    }

    _dataBounds = ChartBounds(
      minX: newData.minX,
      maxX: newData.maxX,
      minY: newData.minY,
      maxY: newData.maxY,
    );
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (oldWidget.data != widget.data) {
      final adjustmentMinX = _adjustedDataBounds.minX - _dataBounds.minX;
      final adjustmentMaxX = _adjustedDataBounds.maxX - _dataBounds.maxX;
      final adjustmentMinY = _adjustedDataBounds.minY - _dataBounds.minY;
      final adjustmentMaxY = _adjustedDataBounds.maxY - _dataBounds.maxY;

      updateDataBounds();

      _adjustedDataBounds = _adjustedDataBounds.copyWith(
        minX: _dataBounds.minX + adjustmentMinX,
        maxX: _dataBounds.maxX + adjustmentMaxX,
        minY: _dataBounds.minY + adjustmentMinY,
        maxY: _dataBounds.maxY + adjustmentMaxY,
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  void resetAdjustedDataBounds() {
    _adjustedDataBounds = _dataBounds.copyWith();
  }

  void resetDataBoundsAndSetState() {
    setState(resetAdjustedDataBounds);
  }

  void _onPointerSignal(PointerSignalEvent event) {
    switch (event) {
      case final PointerScaleEvent scaleEvent:
        final scaleChange = scaleEvent.scale;
        updateDataRangeForScale(
          focalPixel: event.localPosition,
          scaleChange: scaleChange,
        );
      case final PointerScrollEvent scrollEvent:
        final localDelta = PointerEvent.transformDeltaViaPositions(
          untransformedEndPosition:
              scrollEvent.position + scrollEvent.scrollDelta,
          untransformedDelta: scrollEvent.scrollDelta,
          transform: scrollEvent.transform,
        );
        translateDataRangeFromScroll(localDelta: localDelta);
      default:
    }
  }

  void _onBuiltInTouch(FlTouchEvent event, BaseTouchResponse? touchResponse) {
    if (!mounted) {
      return;
    }

    switch (event) {
      case FlDoubleTapEvent():
        resetDataBoundsAndSetState();

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

  bool get _isTransformed =>
      _adjustedDataBounds.minX != widget.data.minX ||
      _adjustedDataBounds.maxX != widget.data.maxX ||
      _adjustedDataBounds.minY != widget.data.minY ||
      _adjustedDataBounds.maxY != widget.data.maxY;

  FlClipData get _clipData =>
      _isTransformed ? const FlClipData.all() : widget.data.clipData;

  void _touchCallback(FlTouchEvent event, BaseTouchResponse? touchResponse) {
    _onBuiltInTouch(event, touchResponse);
    widget.data.touchData.touchCallback?.call(
      event,
      touchResponse,
    );
  }

  void _onSizeChanged(Size size) {
    _chartSize = size;
  }

  Widget buildInteractiveChart({
    required FlClipData clipData,
    required BaseTouchCallback touchCallback,
    required ChartBounds chartBounds,
    required OnPointerSignal onPointerSignal,
    required OnSizeChanged onSizeChanged,
  });

  /// Please use [buildInteractiveChart] to build the chart.
  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return buildInteractiveChart(
      clipData: _clipData,
      touchCallback: _touchCallback,
      chartBounds: _adjustedDataBounds,
      onPointerSignal: _onPointerSignal,
      onSizeChanged: _onSizeChanged,
    );
  }
}
