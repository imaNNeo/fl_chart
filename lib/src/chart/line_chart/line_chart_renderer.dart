import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class LineChartLeaf extends LeafRenderObjectWidget {
  const LineChartLeaf({Key? key, required this.data, required this.targetData, this.touchCallback})
      : super(key: key);

  final LineChartData data, targetData;

  final LineTouchCallback? touchCallback;

  @override
  RenderLineChart createRenderObject(BuildContext context) =>
      RenderLineChart(data, targetData, MediaQuery.of(context).textScaleFactor, touchCallback);

  @override
  void updateRenderObject(BuildContext context, RenderLineChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..touchCallback = touchCallback;
  }
}

class RenderLineChart extends RenderBox {
  RenderLineChart(LineChartData data, LineChartData targetData, double textScale,
      LineTouchCallback? touchCallback)
      : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        _touchCallback = touchCallback;

  LineChartData get data => _data;
  LineChartData _data;
  set data(LineChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  LineChartData get targetData => _targetData;
  LineChartData _targetData;
  set targetData(LineChartData value) {
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

  LineTouchCallback? _touchCallback;
  set touchCallback(LineTouchCallback? value) {
    _touchCallback = value;
  }

  late LineChartPainter _painter;

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

    _painter = LineChartPainter(data, targetData, textScale: textScale);
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
