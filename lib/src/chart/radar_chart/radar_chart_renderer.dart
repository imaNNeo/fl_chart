import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'radar_chart_painter.dart';

/// Low level RadarChart Widget.
class RadarChartLeaf extends LeafRenderObjectWidget {
  const RadarChartLeaf({Key? key, required this.data, required this.targetData}) : super(key: key);

  final RadarChartData data, targetData;

  @override
  RenderRadarChart createRenderObject(BuildContext context) =>
      RenderRadarChart(context, data, targetData, MediaQuery.of(context).textScaleFactor);

  @override
  void updateRenderObject(BuildContext context, RenderRadarChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor;
  }
}

/// Renders our RadarChart, also handles hitTest.
class RenderRadarChart extends RenderBaseChart<RadarTouchResponse> {
  RenderRadarChart(
      BuildContext context, RadarChartData data, RadarChartData targetData, double textScale)
      : _buildContext = context,
        _data = data,
        _targetData = targetData,
        _textScale = textScale,
        super(targetData.radarTouchData.touchCallback);

  final BuildContext _buildContext;

  RadarChartData get data => _data;
  RadarChartData _data;
  set data(RadarChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  RadarChartData get targetData => _targetData;
  RadarChartData _targetData;
  set targetData(RadarChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.touchCallback = _targetData.radarTouchData.touchCallback;
    markNeedsPaint();
  }

  double get textScale => _textScale;
  double _textScale;
  set textScale(double value) {
    if (_textScale == value) return;
    _textScale = value;
    markNeedsPaint();
  }

  final _painter = RadarChartPainter();

  PaintHolder<RadarChartData> get paintHolder {
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
  RadarTouchResponse getResponseAtLocation(Offset localPosition) {
    var touchedSpot = _painter.handleTouch(localPosition, size, paintHolder);
    return RadarTouchResponse(touchedSpot);
  }
}
