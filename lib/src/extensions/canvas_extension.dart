import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';

extension DashedPath on Canvas {
  /// helper that generates dashed paths for other methods
  Path generateDashedPath(Path path, List<int> dashArray) {
    if (path != null && dashArray != null) {
      final castedArray = dashArray.map((value) => value.toDouble()).toList();

      return dashPath(path, dashArray: CircularIntervalList<double>(castedArray));
    } else {
      return path;
    }
  }

  /// draws a dashed path from a regular path
  void drawDashedPath(Path path, Paint painter, List<int> dashArray) {
    Path dashedPath = generateDashedPath(path, dashArray);

    drawPath(dashedPath, painter);
  }

  /// draws a dashed line from passed in offsets
  void drawDashedLine(Offset from, Offset to, Paint painter, List<int> dashArray) {
    Path dashedPath = Path();
    dashedPath.moveTo(from.dx, from.dy);
    dashedPath.lineTo(to.dx, to.dy);
    dashedPath = generateDashedPath(dashedPath, dashArray);

    drawPath(dashedPath, painter);
  }
}
