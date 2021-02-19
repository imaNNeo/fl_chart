import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/utils/list_wrapper.dart';

import 'bar_chart_data.dart';

/// Contains anything that helps BarChart works
class BarChartHelper {
  /// Contains List of cached results, base on [List<BarChartGroupData>]
  ///
  /// We use it to prevent redundant calculations
  static final Map<ListWrapper<BarChartGroupData>, BarChartMinMaxAxisValues> _cachedResults = {};

  /// Calculates minY, and maxY based on [barGroups],
  /// returns cached values, to prevent redundant calculations.
  static BarChartMinMaxAxisValues calculateMaxAxisValues(List<BarChartGroupData> barGroups) {
    if (barGroups.isEmpty) {
      return BarChartMinMaxAxisValues(0, 0);
    }

    var listWrapper = barGroups.toWrapperClass();

    if (_cachedResults.containsKey(listWrapper)) {
      return _cachedResults[listWrapper]!.copyWith(readFromCache: true);
    }
    for (var i = 0; i < barGroups.length; i++) {
      final barData = barGroups[i];
      if (barData.barRods.isEmpty) {
        throw Exception('barRods could not be null or empty');
      }
    }

    var maxY = barGroups[0].barRods[0].y;
    var minY = 0.0;

    for (var i = 0; i < barGroups.length; i++) {
      final barGroup = barGroups[i];
      for (var j = 0; j < barGroup.barRods.length; j++) {
        final rod = barGroup.barRods[j];

        if (rod.y > maxY) {
          maxY = rod.y;
        }

        if (rod.backDrawRodData.show && rod.backDrawRodData.y > maxY) {
          maxY = rod.backDrawRodData.y;
        }

        if (rod.y < minY) {
          minY = rod.y;
        }

        if (rod.backDrawRodData.show && rod.backDrawRodData.y < minY) {
          minY = rod.backDrawRodData.y;
        }
      }
    }

    final result = BarChartMinMaxAxisValues(minY, maxY);
    _cachedResults[listWrapper] = result;
    return result;
  }
}

/// Holds minY, and maxY for use in [BarChartData]
class BarChartMinMaxAxisValues with EquatableMixin {
  final double minY;
  final double maxY;
  final bool readFromCache;

  BarChartMinMaxAxisValues(this.minY, this.maxY, {this.readFromCache = false});

  @override
  List<Object?> get props => [minY, maxY, readFromCache];

  BarChartMinMaxAxisValues copyWith({double? minY, double? maxY, bool? readFromCache}) {
    return BarChartMinMaxAxisValues(
      minY ?? this.minY,
      maxY ?? this.maxY,
      readFromCache: readFromCache ?? this.readFromCache,
    );
  }
}
