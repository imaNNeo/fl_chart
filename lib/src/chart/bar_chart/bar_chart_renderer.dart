import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'bar_chart_painter.dart';

class BarChartLeaf extends LeafRenderObjectWidget {
  const BarChartLeaf({Key? key, required this.data, required this.targetData, this.touchCallback})
      : super(key: key);

  final BarChartData data, targetData;

  final BarTouchCallback? touchCallback;

  @override
  RenderBarChart createRenderObject(BuildContext context) =>
      RenderBarChart(data, targetData, MediaQuery.of(context).textScaleFactor, touchCallback);

  @override
  void updateRenderObject(BuildContext context, RenderBarChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..touchCallback = touchCallback;
  }
}

class RenderBarChart extends RenderBox {
  RenderBarChart(
      BarChartData data, BarChartData targetData, double textScale, BarTouchCallback? touchCallback)
      : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        _touchCallback = touchCallback;

  BarChartData get data => _data;
  BarChartData _data;
  set data(BarChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  BarChartData get targetData => _targetData;
  BarChartData _targetData;
  set targetData(BarChartData value) {
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

  BarTouchCallback? _touchCallback;
  set touchCallback(BarTouchCallback? value) {
    _touchCallback = value;
  }

  late BarChartPainter _painter;

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

    _painter = BarChartPainter(data, targetData, textScale: textScale);
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
