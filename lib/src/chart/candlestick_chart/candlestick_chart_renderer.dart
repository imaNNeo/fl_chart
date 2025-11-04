import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';

// coverage:ignore-start

/// Low level ScatterChart Widget.
class CandlestickChartLeaf extends LeafRenderObjectWidget {
  const CandlestickChartLeaf({
    super.key,
    required this.data,
    required this.targetData,
    required this.chartVirtualRect,
    required this.canBeScaled,
  });

  final CandlestickChartData data;
  final CandlestickChartData targetData;
  final Rect? chartVirtualRect;
  final bool canBeScaled;

  @override
  RenderCandlestickChart createRenderObject(BuildContext context) =>
      RenderCandlestickChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaler,
        chartVirtualRect,
        canBeScaled: canBeScaled,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderCandlestickChart renderObject,
  ) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScaler = MediaQuery.of(context).textScaler
      ..buildContext = context
      ..chartVirtualRect = chartVirtualRect
      ..canBeScaled = canBeScaled;
  }
}
// coverage:ignore-end

/// Renders our ScatterChart, also handles hitTest.
class RenderCandlestickChart extends RenderBaseChart<CandlestickTouchResponse> {
  RenderCandlestickChart(
    BuildContext context,
    CandlestickChartData data,
    CandlestickChartData targetData,
    TextScaler textScaler,
    Rect? chartVirtualRect, {
    required bool canBeScaled,
  })  : _data = data,
        _targetData = targetData,
        _textScaler = textScaler,
        _chartVirtualRect = chartVirtualRect,
        super(
          targetData.candlestickTouchData,
          context,
          canBeScaled: canBeScaled,
        );

  CandlestickChartData get data => _data;
  CandlestickChartData _data;

  set data(CandlestickChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  CandlestickChartData get targetData => _targetData;
  CandlestickChartData _targetData;

  set targetData(CandlestickChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.updateBaseTouchData(_targetData.candlestickTouchData);
    markNeedsPaint();
  }

  TextScaler get textScaler => _textScaler;
  TextScaler _textScaler;

  set textScaler(TextScaler value) {
    if (_textScaler == value) return;
    _textScaler = value;
    markNeedsPaint();
  }

  Rect? get chartVirtualRect => _chartVirtualRect;
  Rect? _chartVirtualRect;

  set chartVirtualRect(Rect? value) {
    if (_chartVirtualRect == value) return;
    _chartVirtualRect = value;
    markNeedsPaint();
  }

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  CandlestickChartPainter painter = CandlestickChartPainter();

  PaintHolder<CandlestickChartData> get paintHolder =>
      PaintHolder(data, targetData, textScaler, chartVirtualRect);

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
  bool hitTestSelf(Offset position) {
    if (!targetData.candlestickTouchData.enabled) {
      return false;
    }
    return super.hitTestSelf(position);
  }

  @override
  CandlestickTouchResponse getResponseAtLocation(Offset localPosition) {
    final chartSize = mockTestSize ?? size;
    return CandlestickTouchResponse(
      touchLocation: localPosition,
      touchChartCoordinate: painter.getChartCoordinateFromPixel(
        localPosition,
        chartSize,
        paintHolder,
      ),
      touchedSpot: painter.handleTouch(
        localPosition,
        chartSize,
        paintHolder,
      ),
    );
  }
}
