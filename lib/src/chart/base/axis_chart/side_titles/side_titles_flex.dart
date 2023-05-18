import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Inspired from [Flex]
class SideTitlesFlex extends MultiChildRenderObjectWidget {
  SideTitlesFlex({
    super.key,
    required this.direction,
    required this.axisSideMetaData,
    List<AxisSideTitleWidgetHolder> widgetHolders =
        const <AxisSideTitleWidgetHolder>[],
  })  : axisSideTitlesMetaData = widgetHolders.map((e) => e.metaData).toList(),
        super(children: widgetHolders.map((e) => e.widget).toList());

  final Axis direction;
  final AxisSideMetaData axisSideMetaData;
  final List<AxisSideTitleMetaData> axisSideTitlesMetaData;

  @override
  AxisSideTitlesRenderFlex createRenderObject(BuildContext context) {
    return AxisSideTitlesRenderFlex(
      direction: direction,
      axisSideMetaData: axisSideMetaData,
      axisSideTitlesMetaData: axisSideTitlesMetaData,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant AxisSideTitlesRenderFlex renderObject,
  ) {
    renderObject
      ..direction = direction
      ..axisSideMetaData = axisSideMetaData
      ..axisSideTitlesMetaData = axisSideTitlesMetaData;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
  }
}

class AxisSideTitlesRenderFlex extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FlexParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FlexParentData>,
        DebugOverflowIndicatorMixin {
  AxisSideTitlesRenderFlex({
    Axis direction = Axis.horizontal,
    required AxisSideMetaData axisSideMetaData,
    required List<AxisSideTitleMetaData> axisSideTitlesMetaData,
  })  : _direction = direction,
        _axisSideMetaData = axisSideMetaData,
        _axisSideTitlesMetaData = axisSideTitlesMetaData;

  Axis get direction => _direction;
  Axis _direction;

  set direction(Axis value) {
    if (_direction != value) {
      _direction = value;
      markNeedsLayout();
    }
  }

  AxisSideMetaData get axisSideMetaData => _axisSideMetaData;
  AxisSideMetaData _axisSideMetaData;

  set axisSideMetaData(AxisSideMetaData value) {
    if (_axisSideMetaData != value) {
      _axisSideMetaData = value;
      markNeedsLayout();
    }
  }

  List<AxisSideTitleMetaData> get axisSideTitlesMetaData =>
      _axisSideTitlesMetaData;
  List<AxisSideTitleMetaData> _axisSideTitlesMetaData;

  set axisSideTitlesMetaData(List<AxisSideTitleMetaData> value) {
    if (_axisSideTitlesMetaData != value) {
      _axisSideTitlesMetaData = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  @override
  bool get debugNeedsLayout => false;

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    if (_direction == Axis.horizontal) {
      return defaultComputeDistanceToHighestActualBaseline(baseline);
    }
    return defaultComputeDistanceToFirstActualBaseline(baseline);
  }

  double _getCrossSize(Size size) {
    switch (_direction) {
      case Axis.horizontal:
        return size.height;
      case Axis.vertical:
        return size.width;
    }
  }

  double _getMainSize(Size size) {
    switch (_direction) {
      case Axis.horizontal:
        return size.width;
      case Axis.vertical:
        return size.height;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final sizes = _computeSizes(
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      constraints: constraints,
    );

    switch (_direction) {
      case Axis.horizontal:
        return constraints.constrain(Size(sizes.mainSize, sizes.crossSize));
      case Axis.vertical:
        return constraints.constrain(Size(sizes.crossSize, sizes.mainSize));
    }
  }

  _LayoutSizes _computeSizes({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    // Determine used flex factor, size inflexible items, calculate free space.
    final maxMainSize = _direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    final canFlex = maxMainSize < double.infinity;

    var crossSize = 0.0;
    var allocatedSize = 0.0; // Sum of the sizes of the non-flexible children.
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as FlexParentData;

      // Stretch
      final innerConstraints = switch (_direction) {
        Axis.horizontal => BoxConstraints.tightFor(
            height: constraints.maxHeight,
          ),
        Axis.vertical => BoxConstraints.tightFor(
            width: constraints.maxWidth,
          ),
      };

      final childSize = layoutChild(child, innerConstraints);
      allocatedSize += _getMainSize(childSize);
      crossSize = math.max(crossSize, _getCrossSize(childSize));
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    final idealSize = canFlex ? maxMainSize : allocatedSize;
    return _LayoutSizes(
      mainSize: idealSize,
      crossSize: crossSize,
      allocatedSize: allocatedSize,
    );
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    final sizes = _computeSizes(
      layoutChild: ChildLayoutHelper.layoutChild,
      constraints: constraints,
    );

    var actualSize = sizes.mainSize;
    var crossSize = sizes.crossSize;

    // Align items along the main axis.
    switch (_direction) {
      case Axis.horizontal:
        size = constraints.constrain(Size(actualSize, crossSize));
        actualSize = size.width;
        crossSize = size.height;
      case Axis.vertical:
        size = constraints.constrain(Size(crossSize, actualSize));
        actualSize = size.height;
        crossSize = size.width;
    }

    // Position elements
    var child = firstChild;
    var counter = 0;
    while (child != null) {
      final childParentData = child.parentData! as FlexParentData;
      final metaData = _axisSideTitlesMetaData[counter];
      final double childCrossPosition;

      // Stretch
      childCrossPosition = 0.0;
      final childMainPosition =
          metaData.axisPixelLocation - (_getMainSize(child.size) / 2);
      childParentData.offset = switch (_direction) {
        Axis.horizontal => Offset(childMainPosition, childCrossPosition),
        Axis.vertical => Offset(childCrossPosition, childMainPosition),
      };
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
    // There's no point in drawing the children if we're empty.
    if (size.isEmpty) {
      return;
    }

    _clipRectLayer.layer = null;
    defaultPaint(context, offset);
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
  }
}

class _LayoutSizes {
  const _LayoutSizes({
    required this.mainSize,
    required this.crossSize,
    required this.allocatedSize,
  });

  final double mainSize;
  final double crossSize;
  final double allocatedSize;
}

class AxisSideMetaData {
  AxisSideMetaData(this.minValue, this.maxValue, this.axisViewSize);
  final double minValue;
  final double maxValue;
  final double axisViewSize;

  double get diff => maxValue - minValue;
}

class AxisSideTitleMetaData with EquatableMixin {
  AxisSideTitleMetaData(this.axisValue, this.axisPixelLocation);
  final double axisValue;
  final double axisPixelLocation;

  @override
  List<Object?> get props => [
        axisValue,
        axisPixelLocation,
      ];
}

class AxisSideTitleWidgetHolder {
  AxisSideTitleWidgetHolder(this.metaData, this.widget);
  final AxisSideTitleMetaData metaData;
  final Widget widget;
}
