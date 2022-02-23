import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/list_wrapper.dart';

/// Contains anything that helps LineChart works
class LineChartHelper {
  /// Contains List of cached results, base on [List<LineChartBarData>]
  ///
  /// We use it to prevent redundant calculations
  static final Map<ListWrapper<LineChartBarData>, LineChartMinMaxAxisValues>
      _cachedResults = {};

  static LineChartMinMaxAxisValues calculateMaxAxisValues(
      List<LineChartBarData> lineBarsData) {
    if (lineBarsData.isEmpty) {
      return LineChartMinMaxAxisValues(0, 0, 0, 0);
    }

    var listWrapper = lineBarsData.toWrapperClass();

    if (_cachedResults.containsKey(listWrapper)) {
      return _cachedResults[listWrapper]!.copyWith(readFromCache: true);
    }

    final LineChartBarData lineBarData;
    try {
      lineBarData =
          lineBarsData.firstWhere((element) => element.spots.isNotEmpty);
    } catch (e) {
      // There is no lineBarData with at least one spot
      return LineChartMinMaxAxisValues(0, 0, 0, 0);
    }

    final FlSpot firstValidSpot;
    try {
      firstValidSpot =
          lineBarData.spots.firstWhere((element) => element != FlSpot.nullSpot);
    } catch (e) {
      // There is no valid spot
      return LineChartMinMaxAxisValues(0, 0, 0, 0);
    }

    var minX = firstValidSpot.x;
    var maxX = firstValidSpot.x;
    var minY = firstValidSpot.y;
    var maxY = firstValidSpot.y;

    for (var i = 0; i < lineBarsData.length; i++) {
      final barData = lineBarsData[i];
      for (var j = 0; j < barData.spots.length; j++) {
        final spot = barData.spots[j];
        if (spot.isNotNull()) {
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
      }
    }

    final result = LineChartMinMaxAxisValues(minX, maxX, minY, maxY);
    _cachedResults[listWrapper] = result;
    return result;
  }
}

/// Holds minX, maxX, minY, and maxY for use in [LineChartData]
class LineChartMinMaxAxisValues with EquatableMixin {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final bool readFromCache;

  LineChartMinMaxAxisValues(
    this.minX,
    this.maxX,
    this.minY,
    this.maxY, {
    this.readFromCache = false,
  });

  @override
  List<Object?> get props => [minX, maxX, minY, maxY, readFromCache];

  LineChartMinMaxAxisValues copyWith(
      {double? minX,
      double? maxX,
      double? minY,
      double? maxY,
      bool? readFromCache}) {
    return LineChartMinMaxAxisValues(
      minX ?? this.minX,
      maxX ?? this.maxX,
      minY ?? this.minY,
      maxY ?? this.maxY,
      readFromCache: readFromCache ?? this.readFromCache,
    );
  }
}

/// Extensions on [LineChartBarData]
extension LineChartDataExtension on LineChartBarData {
  /// Returns colorStops
  ///
  /// if [colorStops] provided, returns it directly,
  /// Otherwise we calculate it using colors list
  List<double> getSafeColorStops() {
    var stops = <double>[];
    if (colorStops == null || colorStops!.length != colors.length) {
      if (colors.length > 1) {
        /// provided colorStops is invalid and we calculate it here
        colors.asMap().forEach((index, color) {
          final percent = 1.0 / (colors.length - 1);
          stops.add(percent * index);
        });
      } else {
        throw ArgumentError('"colors" must have length > 1.');
      }
    } else {
      stops = colorStops!;
    }
    return stops;
  }
}

/// Extensions on [BarAreaData]
extension BarAreaDataExtension on BarAreaData {
  /// Returns colorStops
  ///
  /// if [colorStops] provided, returns it directly,
  /// Otherwise we calculate it using colors list
  List<double> getSafeColorStops() {
    var stops = <double>[];
    if (gradientColorStops == null ||
        gradientColorStops!.length != colors.length) {
      if (colors.length > 1) {
        /// provided colorStops is invalid and we calculate it here
        colors.asMap().forEach((index, color) {
          final percent = 1.0 / (colors.length - 1);
          stops.add(percent * index);
        });
      } else {
        throw ArgumentError('"colors" must have length > 1.');
      }
    } else {
      stops = gradientColorStops!;
    }
    return stops;
  }
}

/// Extensions on [BetweenBarsData]
extension BetweenBarsDataExtension on BetweenBarsData {
  /// Returns colorStops
  ///
  /// if [colorStops] provided, returns it directly,
  /// Otherwise we calculate it using colors list
  List<double> getSafeColorStops() {
    var stops = <double>[];
    if (gradientColorStops == null ||
        gradientColorStops!.length != colors.length) {
      if (colors.length > 1) {
        /// provided colorStops is invalid and we calculate it here
        colors.asMap().forEach((index, color) {
          final percent = 1.0 / (colors.length - 1);
          stops.add(percent * index);
        });
      } else {
        throw ArgumentError('"colors" must have length > 1.');
      }
    } else {
      stops = gradientColorStops!;
    }
    return stops;
  }
}
