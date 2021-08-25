import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyColumn extends MultiChildRenderObjectWidget {
  MyColumn({
    Key? key,
    List<Widget> children = const <Widget>[],
    required this.minWidth,
    required this.rightPadding,
  }) : super(
    key: key,
    children: children,
  );

  final double minWidth;
  final double rightPadding;

  @override
  RenderMyColumn createRenderObject(BuildContext context) {
    return RenderMyColumn(minWidth, rightPadding);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderMyColumn renderObject) {
    renderObject
      ..minWidth = minWidth
      ..rightPadding = rightPadding;
  }
}

class RenderMyColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  RenderMyColumn(double minWidth, double rightPadding)
      : _minWidth = minWidth,
        _rightPadding = rightPadding,
        super();

  double get minWidth => _minWidth;
  double _minWidth;

  set minWidth(double value) {
    if (_minWidth == value) return;
    _minWidth = value;
    markNeedsLayout();
  }

  double get rightPadding => _rightPadding;
  double _rightPadding;

  set rightPadding(double value) {
    if (_rightPadding == value) return;
    _rightPadding = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  MapEntry<List<double>, double> _computeHeightsAndMaxWidth({required BoxConstraints constraints}) {
    var maxWidth = 0.0;
    final allHeights = <double>[];

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as MultiChildLayoutParentData;
      final childSize = ChildLayoutHelper.dryLayoutChild(child, constraints.copyWith(maxWidth: double.infinity));
      if (childSize.width > maxWidth) {
        maxWidth = childSize.width;
      }
      allHeights.add(childSize.height);
      child = childParentData.nextSibling;
    }

    return MapEntry(allHeights, maxWidth);
  }

  @override
  void performLayout() {
    final constraints = this.constraints as BoxConstraints;

    // Compute max width
    final entry = _computeHeightsAndMaxWidth(constraints: constraints);
    final heights = entry.key;
    var maxWidth = entry.value;

    if (maxWidth < minWidth) {
      maxWidth = minWidth;
    } else {
      maxWidth += rightPadding;
    }

    // Position elements
    var counter = 0;
    var baseLine = 0.0;
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as MultiChildLayoutParentData;
      final height = heights[counter];
      childParentData.offset = Offset(0, baseLine);
      child.layout(BoxConstraints.tight(Size(maxWidth, height)), parentUsesSize: true);
      baseLine += height;
      counter++;
      child = childParentData.nextSibling;
    }
    size = Size(maxWidth, baseLine);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

}