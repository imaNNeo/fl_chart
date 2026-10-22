import 'package:fl_chart/fl_chart.dart';

/// Contains anything that helps LineChart works
class LineChartHelper {
  /// Calculates the [minX], [maxX], [minY], and [maxY] values of
  /// the provided [lineBarsData].
  (double minX, double maxX, double minY, double maxY) calculateMaxAxisValues(
    List<LineChartBarData> lineBarsData,
  ) {
    if (lineBarsData.isEmpty) {
      return (0, 0, 0, 0);
    }

    final FlSpot firstValidSpot;
    try {
      firstValidSpot = lineBarsData
          .expand((barData) => barData.spots)
          .firstWhere((element) => element != FlSpot.nullSpot);
    } catch (_) {
      // There is no valid spot across all lineBarData
      return (0, 0, 0, 0);
    }

    var minX = firstValidSpot.x;
    var maxX = firstValidSpot.x;
    var minY = firstValidSpot.y;
    var maxY = firstValidSpot.y;

    for (final barData in lineBarsData) {
      if (!barData.hasValidSpots) {
        continue;
      }

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

    return (minX, maxX, minY, maxY);
  }
}
