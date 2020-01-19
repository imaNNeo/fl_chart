import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';

extension DashedPath on Canvas {
  Path generateDashedPath(Path path, List<int> dashArray) {
    if (path != null && dashArray != null) {
      final castedArray = dashArray.map((value) => value.toDouble()).toList();

      return dashPath(path, dashArray: CircularIntervalList<double>(castedArray));
    } else {
      return path;
    }
  }

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
