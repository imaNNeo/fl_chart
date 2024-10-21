import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_helper.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// coverage:ignore-start

/// Low level PieChart Widget.
class PieChartLeaf extends MultiChildRenderObjectWidget {
  PieChartLeaf({
    super.key,
    required this.data,
    required this.targetData,
  }) : super(children: targetData.sections.toWidgets());

  final PieChartData data;
  final PieChartData targetData;

  @override
  RenderPieChart createRenderObject(BuildContext context) => RenderPieChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaler,
      );

  @override
  void updateRenderObject(BuildContext context, RenderPieChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScaler = MediaQuery.of(context).textScaler
      ..buildContext = context;
  }
}
// coverage:ignore-end

/// Renders our PieChart, also handles hitTest.
class RenderPieChart extends RenderBaseChart<PieTouchResponse>
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData>
    implements MouseTrackerAnnotation {
  RenderPieChart(
    BuildContext context,
    PieChartData data,
    PieChartData targetData,
    TextScaler textScaler,
  )   : _data = data,
        _targetData = targetData,
        _textScaler = textScaler,
        super(targetData.pieTouchData, context);

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
    super.updateBaseTouchData(_targetData.pieTouchData);
    // We must update layout to draw badges correctly!
    markNeedsLayout();
  }

  TextScaler get textScaler => _textScaler;
  TextScaler _textScaler;

  set textScaler(TextScaler value) {
    if (_textScaler == value) return;
    _textScaler = value;
    markNeedsPaint();
  }

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  PieChartPainter painter = PieChartPainter();

  PaintHolder<PieChartData> get paintHolder =>
      PaintHolder(data, targetData, textScaler);

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
    final badgeOffsets = painter.getBadgeOffsets(
      mockTestSize ?? size,
      paintHolder,
    );
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
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

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
    badgeWidgetPaint(context, offset);
  }

  void badgeWidgetPaint(PaintingContext context, Offset offset) {
    RenderObject? child = firstChild;
    var counter = 0;
    while (child != null) {
      final childParentData = child.parentData! as MultiChildLayoutParentData;
      if (data.sections[counter].value > 0) {
        context.paintChild(child, childParentData.offset + offset);
      }
      child = childParentData.nextSibling;
      counter++;
    }
  }

  @override
  PieTouchResponse getResponseAtLocation(Offset localPosition) {
    final pieSection = painter.handleTouch(
      localPosition,
      mockTestSize ?? size,
      paintHolder,
    );
    return PieTouchResponse(pieSection);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    /// It produces an error when we change the sections list, Check this issue:
    /// https://github.com/imaNNeo/fl_chart/issues/861
    ///
    /// Below is the error message:
    /// Updated layout information required for RenderSemanticsAnnotations#f3b96 NEEDS-LAYOUT NEEDS-PAINT to calculate semantics.
    ///
    /// I don't know how to solve this error. That's why we disabled semantics for now.
  }
}
