import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';

/// Defines extensions on the [List<RadarDataSet>]
extension DashedPath on List<RadarDataSet> {
  /// check all the [RadarDataSet] has a same [dataEntries] length
  bool get hasEqualDataEntriesLength {
    if (length == 0) return false;

    final firstDataEntriesLength = this[0].dataEntries.length;

    return every(
        (element) => element.dataEntries.length == firstDataEntriesLength);
  }
}
