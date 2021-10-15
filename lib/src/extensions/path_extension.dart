import 'dart:ui';

import 'package:fl_chart/src/utils/path_drawing/dash_path.dart';

/// Defines extensions on the [Path]
extension DashedPath on Path {
  /// Returns a dashed path based on [dashArray].
  ///
  /// it is a circular array of dash offsets and lengths.
  /// For example, the array `[5, 10]` would result in dashes 5 pixels long
  /// followed by blank spaces 10 pixels long.
  Path toDashedPath(List<int>? dashArray) {
    if (dashArray != null) {
      final castedArray = dashArray.map((value) => value.toDouble()).toList();
      final dashedPath =
          dashPath(this, dashArray: CircularIntervalList<double>(castedArray));

      return dashedPath;
    } else {
      return this;
    }
  }
}
