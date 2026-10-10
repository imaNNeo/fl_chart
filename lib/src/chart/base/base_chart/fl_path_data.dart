import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/utils/lerp.dart';

/// Describes how a dashed line/path should be painted.
class FlPathData extends Equatable {
  const FlPathData({
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    this.strokeMiterLimit = 4,
    this.dashArray,
  });

  /// The shape at the ends of each dash. Check [StrokeCap] for more details.
  final StrokeCap strokeCap;

  /// The style of line joins. Check [StrokeJoin] for more details.
  final StrokeJoin strokeJoin;

  /// Limits how far the miter join can extend, only relevant when
  /// [strokeJoin] is [StrokeJoin.miter]. Defaults to `4`, matching Flutter's
  /// [Paint.strokeMiterLimit] default.
  final double strokeMiterLimit;

  /// Determines the dash length and space respectively. If null, the line is
  /// rendered solid.
  final List<int>? dashArray;

  /// Lerps two [FlPathData] based on [t].
  static FlPathData? lerp(FlPathData? a, FlPathData? b, double t) {
    // If only one value is provided, return it (or null if both are null).
    if (a == null || b == null) {
      return a ?? b;
    }

    return FlPathData(
      strokeCap: b.strokeCap,
      strokeJoin: b.strokeJoin,
      strokeMiterLimit: lerpDouble(a.strokeMiterLimit, b.strokeMiterLimit, t)!,
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
    );
  }

  /// Copies current [FlPathData] to a new [FlPathData],
  /// and replaces provided values.
  FlPathData copyWith({
    StrokeCap? strokeCap,
    StrokeJoin? strokeJoin,
    double? strokeMiterLimit,
    List<int>? dashArray,
  }) =>
      FlPathData(
        strokeCap: strokeCap ?? this.strokeCap,
        strokeJoin: strokeJoin ?? this.strokeJoin,
        strokeMiterLimit: strokeMiterLimit ?? this.strokeMiterLimit,
        dashArray: dashArray ?? this.dashArray,
      );

  /// Used for equality check, see [Equatable].
  @override
  List<Object?> get props => [
        strokeCap,
        strokeJoin,
        strokeMiterLimit,
        dashArray,
      ];
}
