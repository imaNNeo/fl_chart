import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';

extension DashedPath on Canvas {
  /// helper that generates dashed paths for other methods
  void drawDashedPath(Path path, Paint painter, List<int> dashArray) {
    if (path != null && dashArray != null) {
      final castedArray = dashArray.map((value) => value.toDouble()).toList();
      final dashedPath = dashPath(path, dashArray: CircularIntervalList<double>(castedArray));

      drawPath(dashedPath, painter);
    } else {
      drawPath(path, painter);
    }
  }

  /// draws a dashed line from passed in offsets
  void drawDashedLine(Offset from, Offset to, Paint painter, List<int> dashArray) {
    Path dashedPath = Path();
    dashedPath.moveTo(from.dx, from.dy);
    dashedPath.lineTo(to.dx, to.dy);
    drawDashedPath(dashedPath, painter, dashArray);
  }
}
