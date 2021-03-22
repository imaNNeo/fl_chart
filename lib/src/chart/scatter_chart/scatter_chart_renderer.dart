import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'scatter_chart_painter.dart';

/// Low level ScatterChart Widget.
class ScatterChartLeaf extends LeafRenderObjectWidget {
  const ScatterChartLeaf(
      {Key? key, required this.data, required this.targetData, this.touchCallback})
      : super(key: key);

  final ScatterChartData data, targetData;

  final ScatterTouchCallback? touchCallback;

  @override
  RenderScatterChart createRenderObject(BuildContext context) =>
      RenderScatterChart(data, targetData, MediaQuery.of(context).textScaleFactor, touchCallback);

  @override
  void updateRenderObject(BuildContext context, RenderScatterChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..touchCallback = touchCallback;
  }
}

/// Renders our ScatterChart, also handles hitTest.
class RenderScatterChart extends RenderBox {
  RenderScatterChart(ScatterChartData data, ScatterChartData targetData, double textScale,
      ScatterTouchCallback? touchCallback)
      : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        _touchCallback = touchCallback;

  ScatterChartData get data => _data;
  ScatterChartData _data;
  set data(ScatterChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  ScatterChartData get targetData => _targetData;
  ScatterChartData _targetData;
  set targetData(ScatterChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    markNeedsPaint();
  }

  double get textScale => _textScale;
  double _textScale;
  set textScale(double value) {
    if (_textScale == value) return;
    _textScale = value;
    markNeedsPaint();
  }

  ScatterTouchCallback? _touchCallback;
  set touchCallback(ScatterTouchCallback? value) {
    _touchCallback = value;
  }

  final _painter = ScatterChartPainter();

  PaintHolder<ScatterChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

  ScatterTouchedSpot? _lastTouchedSpot;

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    _painter.paint(canvas, size, paintHolder);
    canvas.restore();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (_touchCallback == null) {
      return;
    }
    var response = ScatterTouchResponse(event, null, false);

    var touchedSpot = _painter.handleTouch(event, size, paintHolder);
    if (touchedSpot == null) {
      _touchCallback!.call(response);
      return;
    }
    response = response.copyWith(touchedSpot: touchedSpot);

    if (event is PointerDownEvent) {
      _lastTouchedSpot = touchedSpot;
    } else if (event is PointerUpEvent) {
      if (_lastTouchedSpot != null && _lastTouchedSpot == touchedSpot) {
        response = response.copyWith(clickHappened: true);
      }
      _lastTouchedSpot = null;
    }

    _touchCallback!.call(response);
  }
}
