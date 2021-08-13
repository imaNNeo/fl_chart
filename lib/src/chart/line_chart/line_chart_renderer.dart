import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Low level LineChart Widget.
class LineChartLeaf extends LeafRenderObjectWidget {
  const LineChartLeaf({Key? key, required this.data, required this.targetData, this.touchCallback})
      : super(key: key);

  final LineChartData data, targetData;

  final LineTouchCallback? touchCallback;

  @override
  RenderLineChart createRenderObject(BuildContext context) => RenderLineChart(
      context, data, targetData, MediaQuery.of(context).textScaleFactor, touchCallback);

  @override
  void updateRenderObject(BuildContext context, RenderLineChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..touchCallback = touchCallback;
  }
}

/// Renders our LineChart, also handles hitTest.
class RenderLineChart extends RenderBox implements MouseTrackerAnnotation {
  RenderLineChart(BuildContext context, LineChartData data, LineChartData targetData,
      double textScale, LineTouchCallback? touchCallback)
      : _buildContext = context,
        _data = data,
        _targetData = targetData,
        _textScale = textScale,
        _touchCallback = touchCallback;

  final BuildContext _buildContext;

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

  final _painter = LineChartPainter();

  PaintHolder<LineChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

  List<LineBarSpot>? _lastTouchedSpots;

  late bool _validForMouseTracker;

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
    _painter.paint(_buildContext, CanvasWrapper(canvas, size), paintHolder);
    canvas.restore();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    _handleEvent(event);
  }

  @override
  PointerExitEventListener? get onExit => (PointerExitEvent event) {
        _handleEvent(event);
      };

  @override
  PointerEnterEventListener? get onEnter => null;

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  bool get validForMouseTracker => _validForMouseTracker;

  void _handleEvent(PointerEvent event) {
    if (_touchCallback == null) {
      return;
    }
    var response = LineTouchResponse(null, event, false);

    var touchedSpots = _painter.handleTouch(event, size, paintHolder);
    if (touchedSpots == null || touchedSpots.isEmpty) {
      _touchCallback?.call(response);
      return;
    }
    response = response.copyWith(lineBarSpots: touchedSpots);

    if (event is PointerDownEvent) {
      _lastTouchedSpots = touchedSpots;
    } else if (event is PointerUpEvent) {
      if (_lastTouchedSpots == touchedSpots) {
        response = response.copyWith(clickHappened: true);
      }
      _lastTouchedSpots = null;
    }

    _touchCallback?.call(response);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    super.detach();
  }
}
