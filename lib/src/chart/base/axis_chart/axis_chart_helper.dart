import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

class AxisChartHelper {
  factory AxisChartHelper() {
    return _singleton;
  }

  AxisChartHelper._internal();

  static final _singleton = AxisChartHelper._internal();

  /// Iterates over an axis from [min] to [max].
  ///
  /// [interval] determines each step
  ///
  /// If [minIncluded] is true, it starts from [min] value,
  /// otherwise it starts from [min] + [interval]
  ///
  /// If [maxIncluded] is true, it ends at [max] value,
  /// otherwise it ends at [max] - [interval]
  Iterable<double> iterateThroughAxis({
    required double min,
    bool minIncluded = true,
    required double max,
    bool maxIncluded = true,
    required double baseLine,
    required double interval,
  }) sync* {
    final initialValue = Utils()
        .getBestInitialIntervalValue(min, max, interval, baseline: baseLine);
    var axisSeek = initialValue;
    final firstPositionOverlapsWithMin = axisSeek == min;
    if (!minIncluded && firstPositionOverlapsWithMin) {
      // If initial value is equal to data minimum,
      // move first label one interval further
      axisSeek += interval;
    }
    final diff = max - min;
    final count = diff ~/ interval;
    final lastPosition = initialValue + (count * interval);
    final lastPositionOverlapsWithMax = lastPosition == max;
    final end =
        !maxIncluded && lastPositionOverlapsWithMax ? max - interval : max;

    final epsilon = interval / 100000;
    if (minIncluded && !firstPositionOverlapsWithMin) {
      // Data minimum shall be included and is not yet covered
      yield min;
    }
    while (axisSeek <= end + epsilon) {
      yield axisSeek;
      axisSeek += interval;
    }
    if (maxIncluded && !lastPositionOverlapsWithMax) {
      yield max;
    }
  }

  /// Calculate translate offset to keep [SideTitle] child
  /// placed inside its corresponding axis.
  /// The offset will translate the child to the closest edge inside
  /// of the corresponding axis bounding box
  Offset calcFitInsideOffset({
    required AxisSide axisSide,
    required double? childSize,
    required double parentAxisSize,
    required double axisPosition,
    required double distanceFromEdge,
  }) {
    if (childSize == null) return Offset.zero;

    // Find title alignment along its axis
    final axisMid = parentAxisSize / 2;
    final mainAxisAlignment = (axisPosition - axisMid).isNegative
        ? MainAxisAlignment.start
        : MainAxisAlignment.end;

    // Find if child widget overflowed outside the chart
    late bool isOverflowed;
    if (mainAxisAlignment == MainAxisAlignment.start) {
      isOverflowed = (axisPosition - (childSize / 2)).isNegative;
    } else {
      isOverflowed = (axisPosition + (childSize / 2)) > parentAxisSize;
    }

    if (!isOverflowed) return Offset.zero;

    // Calc offset if child overflowed
    late double offset;
    if (mainAxisAlignment == MainAxisAlignment.start) {
      offset = (childSize / 2) - axisPosition + distanceFromEdge;
    } else {
      offset =
          -(childSize / 2) + (parentAxisSize - axisPosition) - distanceFromEdge;
    }

    return switch (axisSide) {
      AxisSide.left || AxisSide.right => Offset(0, offset),
      AxisSide.top || AxisSide.bottom => Offset(offset, 0),
    };
  }
}
