import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/list_wrapper.dart';

/// Contains all the function to help the RadarChart work
class RadarChartHelper {
  /// Contains List of cached results, based on [List<RadarDataSet>]
  ///
  /// We use it to prevent redundant calculations
  static final Map<ListWrapper<RadarDataSet>, RadarChartMinMaxAxisValues>
      _cachedResults = {};

  static RadarChartMinMaxAxisValues calculateMinMaxAxisValue(
      List<RadarDataSet> dataSets) {
    if (dataSets.isEmpty) {
      return RadarChartMinMaxAxisValues(0, 0);
    }

    var listWrapper = dataSets.toWrapperClass();

    if (_cachedResults.containsKey(listWrapper)) {
      return _cachedResults[listWrapper]!.copyWith(readFromCache: true);
    }

    final RadarDataSet firstValidDataSet;
    try {
      firstValidDataSet =
          dataSets.firstWhere((element) => element.dataEntries.isNotEmpty);
    } catch (e) {
      //There are no RadarDataSet's with at least one dataEntry
      return RadarChartMinMaxAxisValues(0, 0);
    }

    double max = firstValidDataSet.dataEntries.first.value;
    double min = firstValidDataSet.dataEntries.first.value;

    for (RadarDataSet dataSet in dataSets) {
      for (RadarEntry radarEntry in dataSet.dataEntries) {
        if (radarEntry.value > max) {
          max = radarEntry.value;
        }
        if (radarEntry.value < min) {
          min = radarEntry.value;
        }
      }
    }

    _cachedResults[listWrapper] = RadarChartMinMaxAxisValues(min, max);

    return RadarChartMinMaxAxisValues(min, max);
  }
}

/// Holds min and max for use in [RadarChartData]
class RadarChartMinMaxAxisValues with EquatableMixin {
  final double min;
  final double max;
  final bool readFromCache;

  RadarChartMinMaxAxisValues(
    this.min,
    this.max, {
    this.readFromCache = false,
  });

  @override
  List<Object?> get props => [min, max, readFromCache];

  RadarChartMinMaxAxisValues copyWith({
    double? min,
    double? max,
    bool? readFromCache,
  }) {
    return RadarChartMinMaxAxisValues(
      min ?? this.min,
      max ?? this.max,
      readFromCache: readFromCache ?? this.readFromCache,
    );
  }
}
