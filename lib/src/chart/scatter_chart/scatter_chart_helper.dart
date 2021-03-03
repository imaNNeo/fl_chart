import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/utils/list_wrapper.dart';

import 'scatter_chart_data.dart';

/// Contains anything that helps ScatterChart works
class ScatterChartHelper {
  /// Contains List of cached results, base on [List<ScatterSpot>]
  ///
  /// We use it to prevent redundant calculations
  static final Map<ListWrapper<ScatterSpot>, ScatterChartMinMaxAxisValues> _cachedResults = {};

  /// Calculates minX, maxX, minY, and maxY based on [scatterSpots],
  /// returns cached values, to prevent redundant calculations.
  static ScatterChartMinMaxAxisValues calculateMaxAxisValues(List<ScatterSpot> scatterSpots) {
    if (scatterSpots.isEmpty) {
      return ScatterChartMinMaxAxisValues(0, 0, 0, 0);
    }

    var listWrapper = scatterSpots.toWrapperClass();

    if (_cachedResults.containsKey(listWrapper)) {
      return _cachedResults[listWrapper]!.copyWith(readFromCache: true);
    }

    var minX = scatterSpots[0].x;
    var maxX = scatterSpots[0].x;
    var minY = scatterSpots[0].y;
    var maxY = scatterSpots[0].y;
    for (var j = 0; j < scatterSpots.length; j++) {
      final spot = scatterSpots[j];
      if (spot.x > maxX) {
        maxX = spot.x;
      }

      if (spot.x < minX) {
        minX = spot.x;
      }

      if (spot.y > maxY) {
        maxY = spot.y;
      }

      if (spot.y < minY) {
        minY = spot.y;
      }
    }

    final result = ScatterChartMinMaxAxisValues(minX, maxX, minY, maxY);
    _cachedResults[listWrapper] = result;
    return result;
  }
}

/// Holds minX, maxX, minY, and maxY for use in [ScatterChartData]
class ScatterChartMinMaxAxisValues with EquatableMixin {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final bool readFromCache;

  ScatterChartMinMaxAxisValues(
    this.minX,
    this.maxX,
    this.minY,
    this.maxY, {
    this.readFromCache = false,
  });

  @override
  List<Object?> get props => [minX, maxX, minY, maxY, readFromCache];

  ScatterChartMinMaxAxisValues copyWith(
      {double? minX, double? maxX, double? minY, double? maxY, bool? readFromCache}) {
    return ScatterChartMinMaxAxisValues(
      minX ?? this.minX,
      maxX ?? this.maxX,
      minY ?? this.minY,
      maxY ?? this.maxY,
      readFromCache: readFromCache ?? this.readFromCache,
    );
  }
}
