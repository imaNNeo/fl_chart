import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/dashed_border.dart';
import 'package:flutter/widgets.dart';

extension FlBorderDataExtension on FlBorderData {
  EdgeInsets get allSidesPadding => EdgeInsets.only(
        left: show ? border.left.width : 0.0,
        top: show ? border.top.width : 0.0,
        right: show ? border.right.width : 0.0,
        bottom: show ? border.bottom.width : 0.0,
      );

  /// The [Border] to paint: a [DashedBorder] when [FlBorderData.dashArray]
  /// is set, otherwise [FlBorderData.border] itself.
  Border get borderToPaint {
    final dashArray = this.dashArray;
    if (dashArray == null || dashArray.isEmpty) {
      return border;
    }
    return DashedBorder.fromBorder(border, dashArray);
  }
}
