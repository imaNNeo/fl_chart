import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class SideTitlesFlex extends MultiChildRenderObjectWidget {
  SideTitlesFlex({
    Key? key,
    required this.direction,
    required this.axisSideMetaData,
    List<AxisSideTitleWidgetHolder> widgetHolders =
        const <AxisSideTitleWidgetHolder>[],
  })  : axisSideTitlesMetaData = widgetHolders.map((e) => e.metaData).toList(),
        super(key: key, children: widgetHolders.map((e) => e.widget).toList());

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
      BuildContext context, covariant AxisSideTitlesRenderFlex renderObject) {
    renderObject.direction = direction;
    renderObject.axisSideMetaData = axisSideMetaData;
    renderObject.axisSideTitlesMetaData = axisSideTitlesMetaData;
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

  double _overflow = 0;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  bool get _canComputeIntrinsics => false;

  double _getIntrinsicSize({
    required Axis sizingDirection,
    required double extent,
    required _ChildSizingFunction childSize,
  }) {
    if (!_canComputeIntrinsics) {
      assert(
        RenderObject.debugCheckingIntrinsics,
        'Intrinsics are not available for CrossAxisAlignment.baseline.',
      );
      return 0.0;
    }
    double totalFlex = 0.0;
    double inflexibleSpace = 0.0;
    double maxFlexFractionSoFar = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      inflexibleSpace += childSize(child, extent);
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      child = childParentData.nextSibling;
    }
    return maxFlexFractionSoFar * totalFlex + inflexibleSpace;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicWidth(extent),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicWidth(extent),
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicHeight(extent),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicHeight(extent),
    );
  }

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
    if (!_canComputeIntrinsics) {
      assert(debugCannotComputeDryLayout(
        reason:
            'Dry layout cannot be computed for CrossAxisAlignment.baseline, which requires a full layout.',
      ));
      return Size.zero;
    }

    final _LayoutSizes sizes = _computeSizes(
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

  _LayoutSizes _computeSizes(
      {required BoxConstraints constraints,
      required ChildLayouter layoutChild}) {
    // Determine used flex factor, size inflexible items, calculate free space.
    final double maxMainSize = _direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    final bool canFlex = maxMainSize < double.infinity;

    double crossSize = 0.0;
    double allocatedSize =
        0.0; // Sum of the sizes of the non-flexible children.
    RenderBox? child = firstChild;
    while (child != null) {
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      final BoxConstraints innerConstraints;

      // Stretch
      switch (_direction) {
        case Axis.horizontal:
          innerConstraints =
              BoxConstraints.tightFor(height: constraints.maxHeight);
          break;
        case Axis.vertical:
          innerConstraints =
              BoxConstraints.tightFor(width: constraints.maxWidth);
          break;
      }

      final Size childSize = layoutChild(child, innerConstraints);
      allocatedSize += _getMainSize(childSize);
      crossSize = math.max(crossSize, _getCrossSize(childSize));
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    final double idealSize = canFlex ? maxMainSize : allocatedSize;
    return _LayoutSizes(
      mainSize: idealSize,
      crossSize: crossSize,
      allocatedSize: allocatedSize,
    );
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final _LayoutSizes sizes = _computeSizes(
      layoutChild: ChildLayoutHelper.layoutChild,
      constraints: constraints,
    );

    final double allocatedSize = sizes.allocatedSize;
    double actualSize = sizes.mainSize;
    double crossSize = sizes.crossSize;

    // Align items along the main axis.
    switch (_direction) {
      case Axis.horizontal:
        size = constraints.constrain(Size(actualSize, crossSize));
        actualSize = size.width;
        crossSize = size.height;
        break;
      case Axis.vertical:
        size = constraints.constrain(Size(crossSize, actualSize));
        actualSize = size.height;
        crossSize = size.width;
        break;
    }
    final double actualSizeDelta = actualSize - allocatedSize;
    _overflow = math.max(0.0, -actualSizeDelta);
    final double remainingSpace = math.max(0.0, actualSizeDelta);
    late final double leadingSpace;
    late final double betweenSpace;

    // spaceBetween
    leadingSpace = 0.0;
    betweenSpace = childCount > 1 ? remainingSpace / (childCount - 1) : 0.0;

    // Position elements
    double childMainPosition = leadingSpace;
    RenderBox? child = firstChild;
    int counter = 0;
    while (child != null) {
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      final metaData = _axisSideTitlesMetaData[counter];
      final double childCrossPosition;

      // Stretch
      childCrossPosition = 0.0;
      final childMainPosition = metaData.axisPixelLocation -
          (_getMainSize(child.size) / 2);
      switch (_direction) {
        case Axis.horizontal:
          childParentData.offset =
              Offset(childMainPosition, childCrossPosition);
          break;
        case Axis.vertical:
          childParentData.offset =
              Offset(childCrossPosition, childMainPosition);
          break;
      }
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

typedef _ChildSizingFunction = double Function(RenderBox child, double extent);

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
  final double minValue;
  final double maxValue;
  final double axisViewSize;

  double get diff => maxValue - minValue;

  AxisSideMetaData(this.minValue, this.maxValue, this.axisViewSize);
}

class AxisSideTitleMetaData with EquatableMixin {
  final double axisValue;
  final double axisPixelLocation;

  AxisSideTitleMetaData(this.axisValue, this.axisPixelLocation);

  @override
  List<Object?> get props => [
        axisValue,
        axisPixelLocation,
      ];
}

class AxisSideTitleWidgetHolder {
  final AxisSideTitleMetaData metaData;
  final Widget widget;

  AxisSideTitleWidgetHolder(this.metaData, this.widget);
}
