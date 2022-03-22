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

    for (var barData in lineBarsData) {
      if (barData.mostRightSpot.x > maxX) {
        maxX = barData.mostRightSpot.x;
      }

      if (barData.mostLeftSpot.x < minX) {
        minX = barData.mostLeftSpot.x;
      }

      if (barData.mostTopSpot.y > maxY) {
        maxY = barData.mostTopSpot.y;
      }

      if (barData.mostBottomSpot.y < minY) {
        minY = barData.mostBottomSpot.y;
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
