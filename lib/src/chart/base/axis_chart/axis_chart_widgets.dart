import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Wraps a [child] widget and applies some default behaviours
///
/// Recommended to be used in [SideTitles.getTitlesWidget]
/// You need to pass [axisSide] value that provided by [TitleMeta]
/// It forces the widget to be close to the chart.
/// It also applies a [space] to the chart.
/// You can also fill [angle] in radians if you need to rotate your widget.
/// To force widget to be positioned within its axis bounding box,
/// define [fitInside] by passing [SideTitleFitInsideData]
class SideTitleWidget extends StatelessWidget {
  SideTitleWidget({
    super.key,
    required this.child,
    required this.axisSide,
    this.space = 8.0,
    this.angle = 0.0,
    this.fitInside = const SideTitleFitInsideData(
      enabled: false,
      distanceFromEdge: 0,
      parentAxisSize: 0,
      axisPosition: 0,
    ),
  });

  final AxisSide axisSide;
  final double space;
  final Widget child;
  final double angle;

  /// Define fitInside options with [SideTitleFitInsideData]
  ///
  /// To makes things simpler, it's recommended to use
  /// [SideTitleFitInsideData.fromTitleMeta] and pass the
  /// TitleMeta provided from [SideTitles.getTitlesWidget]
  ///
  /// If [fitInside.enabled] is true, the widget will be placed
  /// inside the parent axis bounding box.
  ///
  /// Some translations will be applied to force
  /// children to be positioned inside the parent axis bounding box.
  ///
  /// Will override the [SideTitleWidget.space] and caused
  /// spacing between [SideTitles] children might be not equal.
  final SideTitleFitInsideData fitInside;

  Alignment _getAlignment() {
    switch (axisSide) {
      case AxisSide.left:
        return Alignment.centerRight;
      case AxisSide.top:
        return Alignment.bottomCenter;
      case AxisSide.right:
        return Alignment.centerLeft;
      case AxisSide.bottom:
        return Alignment.topCenter;
      default:
        throw StateError('Invalid side');
    }
  }

  EdgeInsets _getMargin() {
    switch (axisSide) {
      case AxisSide.left:
        return EdgeInsets.only(right: space);
      case AxisSide.top:
        return EdgeInsets.only(bottom: space);
      case AxisSide.right:
        return EdgeInsets.only(left: space);
      case AxisSide.bottom:
        return EdgeInsets.only(top: space);
      default:
        throw StateError('Invalid side');
    }
  }

  /// Calculate translate offset to keep child
  /// placed inside its corresponding axis.
  /// The offset will translate the child to the closest edge inside
  /// of the parent
  Offset _getOffset() {
    if (!fitInside.enabled || _childSize.value == null) return Offset.zero;

    final parentAxisSize = fitInside.parentAxisSize;
    final axisPosition = fitInside.axisPosition;

    // Find title alignment along its axis
    final axisMid = parentAxisSize / 2;
    final mainAxisAligment = (axisPosition - axisMid).isNegative
        ? MainAxisAlignment.start
        : MainAxisAlignment.end;

    // Find if child widget overflowed outside the chart
    final childSize = _childSize.value!;
    late bool isOverflowed;
    if (mainAxisAligment == MainAxisAlignment.start) {
      isOverflowed = (axisPosition - (childSize / 2)).isNegative;
    } else {
      isOverflowed = (axisPosition + (childSize / 2)) > parentAxisSize;
    }

    if (isOverflowed == false) return Offset.zero;

    // Calc offset if child overflowed
    late double offset;
    if (mainAxisAligment == MainAxisAlignment.start) {
      offset = (childSize / 2) - axisPosition + fitInside.distanceFromEdge;
    } else {
      offset = -(childSize / 2) +
          (parentAxisSize - axisPosition) -
          fitInside.distanceFromEdge;
    }

    switch (axisSide) {
      case AxisSide.left:
      case AxisSide.right:
        return Offset(0, offset);
      case AxisSide.top:
      case AxisSide.bottom:
        return Offset(offset, 0);
    }
  }

  /// Calculate child width/height
  final GlobalKey widgetKey = GlobalKey();
  final ValueNotifier<double?> _childSize = ValueNotifier(null);
  void _getChildSize(_) {
    // If fitInside is false, no need to find child size
    if (!fitInside.enabled) return;

    // If childSize is not null, no need to find the size anymore
    if (_childSize.value != null) return;

    final context = widgetKey.currentContext;
    if (context == null) return;

    // Set size based on its axis side
    late double size;
    switch (axisSide) {
      case AxisSide.left:
      case AxisSide.right:
        size = context.size?.height ?? 0;
        break;
      case AxisSide.top:
      case AxisSide.bottom:
        size = context.size?.width ?? 0;
        break;
    }

    // If childSize is the same, no need to set new value
    if (_childSize.value == size) return;

    _childSize.value = size;
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(_getChildSize);

    return ValueListenableBuilder(
      valueListenable: _childSize,
      builder: (_, double? size, Widget? child) {
        return Transform.translate(
          offset: _getOffset(),
          child: Opacity(
            opacity: fitInside.enabled && size == null ? 0 : 1,
            child: child,
          ),
        );
      },
      child: Transform.rotate(
        angle: angle,
        child: Container(
          key: widgetKey,
          margin: _getMargin(),
          alignment: _getAlignment(),
          child: child,
        ),
      ),
    );
  }
}
