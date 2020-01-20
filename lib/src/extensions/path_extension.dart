import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';

extension DashedPath on Path {
  /// get a dashed(or solid) path from a path
  Path toDashedPath(List<int> dashArray) {
    if (this != null && dashArray != null) {
      final castedArray = dashArray.map((value) => value.toDouble()).toList();
      final dashedPath = dashPath(this, dashArray: CircularIntervalList<double>(castedArray));

      return dashedPath;
    } else {
      return this;
    }
  }

  /// get a dashed(or solid) path from two offsets
  Path toDashedPathFromLine(Offset from, Offset to, List<int> dashArray) {
    this.moveTo(from.dx, from.dy);
    this.lineTo(to.dx, to.dy);
    return this.toDashedPath(dashArray);
  }
}
