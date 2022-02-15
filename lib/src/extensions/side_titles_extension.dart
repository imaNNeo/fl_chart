import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';

extension SideTitlesExtension on SideTitles {
  double get totalReservedSize {
    if (!showTitles) {
      return 0;
    }
    var size = reservedSize;
    if (axisName != null) {
      size += axisNameReservedSize;
    }
    return size;
  }
}