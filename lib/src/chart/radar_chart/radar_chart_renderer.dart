import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'radar_chart_painter.dart';

/// Low level RadarChart Widget.
class RadarChartLeaf extends LeafRenderObjectWidget {
  const RadarChartLeaf({Key? key, required this.data, required this.targetData, this.touchCallback})
      : super(key: key);

  final RadarChartData data, targetData;

  final RadarTouchCallback? touchCallback;

  @override
  RenderRadarChart createRenderObject(BuildContext context) =>
      RenderRadarChart(data, targetData, MediaQuery.of(context).textScaleFactor, touchCallback);

  @override
  void updateRenderObject(BuildContext context, RenderRadarChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..touchCallback = touchCallback;
  }
}

/// Renders our RadarChart, also handles hitTest.
class RenderRadarChart extends RenderBox {
  RenderRadarChart(RadarChartData data, RadarChartData targetData, double textScale,
      RadarTouchCallback? touchCallback)
      : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        _touchCallback = touchCallback;

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
    markNeedsPaint();
  }

  double get textScale => _textScale;
  double _textScale;
  set textScale(double value) {
    if (_textScale == value) return;
    _textScale = value;
    markNeedsPaint();
  }

  RadarTouchCallback? _touchCallback;
  set touchCallback(RadarTouchCallback? value) {
    _touchCallback = value;
  }

  final _painter = RadarChartPainter();

  PaintHolder<RadarChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

  RadarTouchedSpot? _lastTouchedSpot;

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
    var response = RadarTouchResponse(null, event, false);

    var touchedSpot = _painter.handleTouch(event, size, paintHolder);
    if (touchedSpot == null) {
      _touchCallback!.call(response);
      return;
    }
    response = response.copyWith(
      touchedSpot: touchedSpot,
    );

    if (event is PointerDownEvent) {
      _lastTouchedSpot = touchedSpot;
    } else if (event is PointerUpEvent) {
      if (_lastTouchedSpot == touchedSpot) {
        response = response.copyWith(clickHappened: true);
      }
      _lastTouchedSpot = null;
    }

    _touchCallback!.call(response);
  }
}
