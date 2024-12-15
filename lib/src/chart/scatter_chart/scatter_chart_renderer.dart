import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';

// coverage:ignore-start

/// Low level ScatterChart Widget.
class ScatterChartLeaf extends LeafRenderObjectWidget {
  const ScatterChartLeaf({
    super.key,
    required this.data,
    required this.targetData,
    required this.boundingBox,
    required this.canBeScaled,
  });

  final ScatterChartData data;
  final ScatterChartData targetData;
  final Rect? boundingBox;
  final bool canBeScaled;

  @override
  RenderScatterChart createRenderObject(BuildContext context) =>
      RenderScatterChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaler,
        boundingBox,
        canBeScaled: canBeScaled,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderScatterChart renderObject,
  ) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScaler = MediaQuery.of(context).textScaler
      ..buildContext = context
      ..boundingBox = boundingBox
      ..canBeScaled = canBeScaled;
  }
}
// coverage:ignore-end

/// Renders our ScatterChart, also handles hitTest.
class RenderScatterChart extends RenderBaseChart<ScatterTouchResponse> {
  RenderScatterChart(
    BuildContext context,
    ScatterChartData data,
    ScatterChartData targetData,
    TextScaler textScaler,
    Rect? boundingBox, {
    required bool canBeScaled,
  })  : _data = data,
        _targetData = targetData,
        _textScaler = textScaler,
        _boundingBox = boundingBox,
        super(targetData.scatterTouchData, context, canBeScaled: canBeScaled);

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
    super.updateBaseTouchData(_targetData.scatterTouchData);
    markNeedsPaint();
  }

  TextScaler get textScaler => _textScaler;
  TextScaler _textScaler;

  set textScaler(TextScaler value) {
    if (_textScaler == value) return;
    _textScaler = value;
    markNeedsPaint();
  }

  Rect? get boundingBox => _boundingBox;
  Rect? _boundingBox;

  set boundingBox(Rect? value) {
    if (_boundingBox == value) return;
    _boundingBox = value;
    markNeedsPaint();
  }

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  ScatterChartPainter painter = ScatterChartPainter();

  PaintHolder<ScatterChartData> get paintHolder =>
      PaintHolder(data, targetData, textScaler, boundingBox);

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
  ScatterTouchResponse getResponseAtLocation(Offset localPosition) {
    final touchedSpot = painter.handleTouch(
      localPosition,
      mockTestSize ?? size,
      paintHolder,
    );
    return ScatterTouchResponse(touchedSpot);
  }
}
