import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/widgets.dart';

import '../base/base_chart/base_chart_painter.dart';
import 'gauge_chart_data.dart';

/// Low level GaugeChart Widget.
class GaugeChartLeaf extends LeafRenderObjectWidget {
  const GaugeChartLeaf({Key? key, required this.data, required this.targetData})
      : super(key: key);

  final GaugeChartData data, targetData;

  @override
  RenderGaugeChart createRenderObject(BuildContext context) => RenderGaugeChart(
      context, data, targetData, MediaQuery.of(context).textScaleFactor);

  @override
  void updateRenderObject(BuildContext context, RenderGaugeChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..buildContext = context;
  }
}

/// Renders our RadarChart, also handles hitTest.
class RenderGaugeChart extends RenderBaseChart<GaugeTouchResponse> {
  RenderGaugeChart(BuildContext context, GaugeChartData data,
      GaugeChartData targetData, double textScale)
      : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        super(targetData.gaugeTouchData, context);

  GaugeChartData get data => _data;
  GaugeChartData _data;

  set data(GaugeChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  GaugeChartData get targetData => _targetData;
  GaugeChartData _targetData;

  set targetData(GaugeChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.updateBaseTouchData(_targetData.gaugeTouchData);
    markNeedsPaint();
  }

  double get textScale => _textScale;
  double _textScale;

  set textScale(double value) {
    if (_textScale == value) return;
    _textScale = value;
    markNeedsPaint();
  }

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  var painter = GaugeChartPainter();

  PaintHolder<GaugeChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    painter.paint(
      buildContext,
      CanvasWrapper(canvas, mockTestSize ?? size),
      paintHolder,
    );
    canvas.restore();
  }

  @override
  GaugeTouchResponse getResponseAtLocation(Offset localPosition) {
    var touchedSpot = painter.handleTouch(
      localPosition,
      mockTestSize ?? size,
      paintHolder,
    );
    return GaugeTouchResponse(touchedSpot);
  }
}