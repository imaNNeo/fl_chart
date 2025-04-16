import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_data.dart';

/// Contains anything that helps CandlestickChart works
class CandlestickChartHelper {
  /// Calculates minX, maxX, minY, and maxY based on [candleSpots],
  /// returns cached values, to prevent redundant calculations.
  static (
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) calculateMaxAxisValues(
    List<CandlestickSpot> candleSpots,
  ) {
    if (candleSpots.isEmpty) {
      return (0, 0, 0, 0);
    }

    var minX = candleSpots[0].x;
    var maxX = candleSpots[0].x;
    var minY = candleSpots[0].low;
    var maxY = candleSpots[0].high;
    for (var j = 0; j < candleSpots.length; j++) {
      final spot = candleSpots[j];
      if (spot.x > maxX) {
        maxX = spot.x;
      }

      if (spot.x < minX) {
        minX = spot.x;
      }

      if (spot.high > maxY) {
        maxY = spot.high;
      }

      if (spot.low < minY) {
        minY = spot.low;
      }
    }
    return (minX, maxX, minY, maxY);
  }
}
