import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';

extension SideTitlesExtension on AxisTitles {
  double get totalReservedWidth {
    var size = 0.0;
    if (showAxisTitles) {
      size += axisNameSize;
    }
    if (showSideTitles) {
      size += sideTitles.reservedWidth ?? 11;
    }
    return size;
  }

  double get totalReservedHeight {
    var size = 0.0;
    if (showAxisTitles) {
      size += axisNameSize;
    }
    if (showSideTitles) {
      size += sideTitles.reservedHeight ?? 11;
    }
    return size;
  }
}
