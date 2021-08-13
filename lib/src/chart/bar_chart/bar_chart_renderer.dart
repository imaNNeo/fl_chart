import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'bar_chart_painter.dart';

/// Low level BarChart Widget.
class BarChartLeaf extends LeafRenderObjectWidget {
  const BarChartLeaf({Key? key, required this.data, required this.targetData, this.touchCallback})
      : super(key: key);

  final BarChartData data, targetData;

  final BarTouchCallback? touchCallback;

  @override
  RenderBarChart createRenderObject(BuildContext context) => RenderBarChart(
      context, data, targetData, MediaQuery.of(context).textScaleFactor, touchCallback);

  @override
  void updateRenderObject(BuildContext context, RenderBarChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..touchCallback = touchCallback;
  }
}

/// Renders our BarChart, also handles hitTest.
class RenderBarChart extends RenderBox implements MouseTrackerAnnotation {
  RenderBarChart(
    BuildContext context,
    BarChartData data,
    BarChartData targetData,
    double textScale,
    BarTouchCallback? touchCallback,
  )   : _buildContext = context,
        _data = data,
        _targetData = targetData,
        _textScale = textScale,
        _touchCallback = touchCallback;

  final BuildContext _buildContext;

  BarChartData get data => _data;
  BarChartData _data;

  set data(BarChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  BarChartData get targetData => _targetData;
  BarChartData _targetData;

  set targetData(BarChartData value) {
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

  BarTouchCallback? _touchCallback;

  set touchCallback(BarTouchCallback? value) {
    _touchCallback = value;
  }

  final _painter = BarChartPainter();

  PaintHolder<BarChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

  BarTouchedSpot? _lastTouchedSpot;

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
    var response = BarTouchResponse(null, event, false);

    var touchedSpot = _painter.handleTouch(event, size, paintHolder);
    if (touchedSpot == null) {
      _touchCallback?.call(response);
      return;
    }
    response = response.copyWith(spot: touchedSpot);

    if (event is PointerDownEvent) {
      _lastTouchedSpot = touchedSpot;
    } else if (event is PointerUpEvent) {
      if (_lastTouchedSpot == touchedSpot) {
        response = response.copyWith(clickHappened: true);
      }
      _lastTouchedSpot = null;
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
