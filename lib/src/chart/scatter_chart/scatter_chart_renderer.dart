import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'scatter_chart_painter.dart';

/// Low level ScatterChart Widget.
class ScatterChartLeaf extends LeafRenderObjectWidget {
  const ScatterChartLeaf({Key? key, required this.data, required this.targetData})
      : super(key: key);

  final ScatterChartData data, targetData;

  @override
  RenderScatterChart createRenderObject(BuildContext context) =>
      RenderScatterChart(context, data, targetData, MediaQuery.of(context).textScaleFactor);

  @override
  void updateRenderObject(BuildContext context, RenderScatterChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor;
  }
}

/// Renders our ScatterChart, also handles hitTest.
class RenderScatterChart extends RenderBaseChart<ScatterTouchResponse> {
  RenderScatterChart(
      BuildContext context, ScatterChartData data, ScatterChartData targetData, double textScale)
      : _buildContext = context,
        _data = data,
        _targetData = targetData,
        _textScale = textScale,
        super(targetData.scatterTouchData.touchCallback);

  final BuildContext _buildContext;

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
    super.touchCallback = _targetData.scatterTouchData.touchCallback;
    markNeedsPaint();
  }

  double get textScale => _textScale;
  double _textScale;

  set textScale(double value) {
    if (_textScale == value) return;
    _textScale = value;
    markNeedsPaint();
  }

  final _painter = ScatterChartPainter();

  PaintHolder<ScatterChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    _painter.paint(_buildContext, CanvasWrapper(canvas, size), paintHolder);
    canvas.restore();
  }

  @override
  ScatterTouchResponse getResponseAtLocation(Offset localPosition) {
    var touchedSpot = _painter.handleTouch(localPosition, size, paintHolder);
    return ScatterTouchResponse(touchedSpot);
  }
}
