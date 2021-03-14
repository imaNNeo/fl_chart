import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'scatter_chart_painter.dart';

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

  late ScatterChartPainter _painter;

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

    _painter = ScatterChartPainter(data, targetData, textScale: textScale);
    _painter.paint(canvas, size);

    canvas.restore();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    _touchCallback?.call(_painter.handleTouch(event, size));
  }
}
