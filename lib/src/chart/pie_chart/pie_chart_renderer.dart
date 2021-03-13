import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'pie_chart_painter.dart';

class PieChartLeaf extends LeafRenderObjectWidget {
  const PieChartLeaf({
    Key? key,
    required this.data,
    required this.targetData,
    this.touchCallback,
  }) : super(key: key);

  final PieChartData data, targetData;

  final PieTouchCallback? touchCallback;

  @override
  RenderPieChart createRenderObject(BuildContext context) => RenderPieChart(
        data,
        targetData,
        MediaQuery.of(context).textScaleFactor,
        touchCallback,
      );

  @override
  void updateRenderObject(BuildContext context, RenderPieChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..touchCallback = touchCallback;
  }
}

class RenderPieChart extends RenderBox {
  RenderPieChart(
      PieChartData data, PieChartData targetData, double textScale, PieTouchCallback? touchCallback)
      : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        _touchCallback = touchCallback;

  PieChartData get data => _data;
  PieChartData _data;
  set data(PieChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  PieChartData get targetData => _targetData;
  PieChartData _targetData;
  set targetData(PieChartData value) {
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

  PieTouchCallback? _touchCallback;
  set touchCallback(PieTouchCallback? value) {
    _touchCallback = value;
  }

  late PieChartPainter _painter;

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

    _painter = PieChartPainter(data, targetData, textScale: textScale);
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
