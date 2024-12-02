import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Callback function that is called when the size of the chart changes.
typedef OnSizeChanged = void Function(Size size);

// coverage:ignore-start

/// Low level LineChart Widget.
class LineChartLeaf extends LeafRenderObjectWidget {
  const LineChartLeaf({
    super.key,
    this.onSizeChanged,
    required this.data,
    required this.targetData,
  });

  final LineChartData data;
  final LineChartData targetData;
  final OnSizeChanged? onSizeChanged;

  @override
  RenderLineChart createRenderObject(BuildContext context) => RenderLineChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaler,
        onSizeChanged,
      );

  @override
  void updateRenderObject(BuildContext context, RenderLineChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScaler = MediaQuery.of(context).textScaler
      ..buildContext = context;
  }
}
// coverage:ignore-end

/// Renders our LineChart, also handles hitTest.
class RenderLineChart extends RenderBaseChart<LineTouchResponse> {
  RenderLineChart(
    BuildContext context,
    LineChartData data,
    LineChartData targetData,
    TextScaler textScaler, [
    OnSizeChanged? onSizeChanged,
  ])  : _data = data,
        _targetData = targetData,
        _textScaler = textScaler,
        _onSizeChanged = onSizeChanged,
        super(
          targetData.lineTouchData,
          context,
        );

  final OnSizeChanged? _onSizeChanged;

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
    super.updateBaseTouchData(_targetData.lineTouchData);
    markNeedsPaint();
  }

  TextScaler get textScaler => _textScaler;
  TextScaler _textScaler;
  set textScaler(TextScaler value) {
    if (_textScaler == value) return;
    _textScaler = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    super.performLayout();
    _onSizeChanged?.call(size);
  }

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  LineChartPainter painter = LineChartPainter();

  PaintHolder<LineChartData> get paintHolder =>
      PaintHolder(data, targetData, textScaler);

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    painter.paint(
      buildContext,
      CanvasWrapper(canvas, mockTestSize ?? size),
      paintHolder,
    );
    canvas.restore();
  }

  @override
  LineTouchResponse getResponseAtLocation(Offset localPosition) {
    final touchedSpots = painter.handleTouch(
      localPosition,
      mockTestSize ?? size,
      paintHolder,
    );
    return LineTouchResponse(touchedSpots);
  }
}
