import 'dart:ui';

import 'package:fl_chart/src/extensions/path_extension.dart';

extension DashedLine on Canvas {
  /// draws a dashed line from passed in offsets
  void drawDashedLine(Offset from, Offset to, Paint painter, List<int> dashArray) {
    Path path = Path();
    path.moveTo(from.dx, from.dy);
    path.lineTo(to.dx, to.dy);
    path = path.toDashedPath(dashArray);
    this.drawPath(path, painter);
  }
}
