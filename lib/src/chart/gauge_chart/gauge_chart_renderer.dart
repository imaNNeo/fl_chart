import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_data.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/widgets.dart';

// coverage:ignore-start

/// Low level GaugeChart Widget.
class GaugeChartLeaf extends MultiChildRenderObjectWidget {
  const GaugeChartLeaf({
    super.key,
    required this.data,
    required this.targetData,
  });

  final GaugeChartData data;
  final GaugeChartData targetData;

  @override
  RenderGaugeChart createRenderObject(BuildContext context) => RenderGaugeChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaler,
      );

  @override
  void updateRenderObject(BuildContext context, RenderGaugeChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScaler = MediaQuery.of(context).textScaler
      ..buildContext = context;
  }
}
// coverage:ignore-end

/// Renders our GaugeChart, also handles hitTest.
class RenderGaugeChart extends RenderBaseChart<GaugeTouchResponse> {
  RenderGaugeChart(
    BuildContext context,
    GaugeChartData data,
    GaugeChartData targetData,
    TextScaler textScaler,
  )   : _data = data,
        _targetData = targetData,
        _textScaler = textScaler,
        super(targetData.gaugeTouchData, context, canBeScaled: false);

  GaugeChartData _data;
  GaugeChartData _targetData;

  TextScaler _textScaler;

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;
  @visibleForTesting
  GaugeChartPainter painter = GaugeChartPainter();

  GaugeChartData get data => _data;

  set data(GaugeChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  PaintHolder<GaugeChartData> get paintHolder {
    return PaintHolder(data, targetData, textScaler);
  }

  GaugeChartData get targetData => _targetData;

  set targetData(GaugeChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.updateBaseTouchData(_targetData.gaugeTouchData);
    markNeedsPaint();
  }

  TextScaler get textScaler => _textScaler;

  set textScaler(TextScaler value) {
    if (_textScaler == value) return;
    _textScaler = value;
    markNeedsPaint();
  }

  @override
  GaugeTouchResponse getResponseAtLocation(Offset localPosition) {
    return GaugeTouchResponse(
      touchLocation: localPosition,
      touchedSpot: painter.handleTouch(
        localPosition,
        mockTestSize ?? size,
        paintHolder,
      ),
    );
  }

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
}
