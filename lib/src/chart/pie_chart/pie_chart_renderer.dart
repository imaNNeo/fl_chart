import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'pie_chart_painter.dart';

/// Low level PieChart Widget.
class PieChartLeaf extends MultiChildRenderObjectWidget {
  PieChartLeaf({
    Key? key,
    required this.data,
    required this.targetData,
    this.touchCallback,
  }) : super(
          key: key,
          children: targetData.sections.map((e) => e.badgeWidget).toList(),
        );

  final PieChartData data, targetData;

  final PieTouchCallback? touchCallback;

  @override
  RenderPieChart createRenderObject(BuildContext context) => RenderPieChart(
        data,
        targetData,
        MediaQuery.of(context).textScaleFactor,
        touchCallback,
      );

  @override
  void updateRenderObject(BuildContext context, RenderPieChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..touchCallback = touchCallback;
  }
}

/// Renders our PieChart, also handles hitTest.
class RenderPieChart extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  RenderPieChart(
      PieChartData data, PieChartData targetData, double textScale, PieTouchCallback? touchCallback)
      : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        _touchCallback = touchCallback;

  PieChartData get data => _data;
  PieChartData _data;
  set data(PieChartData value) {
    if (_data == value) return;
    _data = value;
    // We must update layout to draw badges correctly!
    markNeedsLayout();
  }

  PieChartData get targetData => _targetData;
  PieChartData _targetData;
  set targetData(PieChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    // We must update layout to draw badges correctly!
    markNeedsLayout();
  }

  double get textScale => _textScale;
  double _textScale;
  set textScale(double value) {
    if (_textScale == value) return;
    _textScale = value;
    markNeedsPaint();
  }

  PieTouchCallback? _touchCallback;
  set touchCallback(PieTouchCallback? value) {
    _touchCallback = value;
  }

  final _painter = PieChartPainter();

  PaintHolder<PieChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

  PieTouchedSection? _lastTouchedSpot;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void performLayout() {
    var child = firstChild;
    size = computeDryLayout(constraints);

    final childConstraints = constraints.loosen();

    var counter = 0;
    var badgeOffsets = _painter.getBadgeOffsets(size, paintHolder);
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      final childParentData = child.parentData! as MultiChildLayoutParentData;
      final sizeOffset = Offset(child.size.width / 2, child.size.height / 2);
      childParentData.offset = badgeOffsets[counter++]! - sizeOffset;
      child = childParentData.nextSibling;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    _painter.paint(canvas, size, paintHolder);
    canvas.restore();
    defaultPaint(context, offset);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (_touchCallback == null) {
      return;
    }
    var response = PieTouchResponse(null, event, false);

    var touchedSection = _painter.handleTouch(event, size, paintHolder);
    if (touchedSection == null) {
      _touchCallback!.call(response);
      return;
    }
    response = response.copyWith(touchedSection: touchedSection);

    if (event is PointerDownEvent) {
      _lastTouchedSpot = touchedSection;
    } else if (event is PointerUpEvent) {
      if (_lastTouchedSpot == touchedSection) {
        response = response.copyWith(clickHappened: true);
      }
      _lastTouchedSpot = null;
    }

    _touchCallback!.call(response);
  }
}
