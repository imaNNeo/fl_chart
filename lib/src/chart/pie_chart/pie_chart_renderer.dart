import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'pie_chart_painter.dart';

/// Low level PieChart Widget.
class PieChartLeaf extends MultiChildRenderObjectWidget {
  PieChartLeaf({
    Key? key,
    required this.data,
    required this.targetData,
  }) : super(
          key: key,
          children: targetData.sections.map((e) => e.badgeWidget).toList(),
        );

  final PieChartData data, targetData;

  @override
  RenderPieChart createRenderObject(BuildContext context) => RenderPieChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaleFactor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderPieChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor;
  }
}

/// Renders our PieChart, also handles hitTest.
class RenderPieChart extends RenderBaseChart<PieTouchResponse>
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData>
    implements MouseTrackerAnnotation {
  RenderPieChart(BuildContext context, PieChartData data, PieChartData targetData, double textScale)
      : _buildContext = context,
        _data = data,
        _targetData = targetData,
        _textScale = textScale,
        super(targetData.pieTouchData.touchCallback);

  final BuildContext _buildContext;

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
    super.touchCallback = _targetData.pieTouchData.touchCallback;
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

  final _painter = PieChartPainter();

  PaintHolder<PieChartData> get paintHolder {
    return PaintHolder(data, targetData, textScale);
  }

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
      if (counter >= badgeOffsets.length) {
        break;
      }
      child.layout(childConstraints, parentUsesSize: true);
      final childParentData = child.parentData! as MultiChildLayoutParentData;
      final sizeOffset = Offset(child.size.width / 2, child.size.height / 2);
      childParentData.offset = badgeOffsets[counter]! - sizeOffset;
      child = childParentData.nextSibling;
      counter++;
    }
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
    _painter.paint(_buildContext, CanvasWrapper(canvas, size), paintHolder);
    canvas.restore();
    defaultPaint(context, offset);
  }

  @override
  PieTouchResponse getResponseAtLocation(Offset localPosition) {
    final pieSection = _painter.handleTouch(localPosition, size, paintHolder);
    return PieTouchResponse(pieSection);
  }
}
