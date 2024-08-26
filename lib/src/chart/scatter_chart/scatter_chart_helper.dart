import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_data.dart';

/// Contains anything that helps ScatterChart works
class ScatterChartHelper {
  /// Calculates minX, maxX, minY, and maxY based on [scatterSpots],
  /// returns cached values, to prevent redundant calculations.
  static (
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) calculateMaxAxisValues(
    List<ScatterSpot> scatterSpots,
  ) {
    if (scatterSpots.isEmpty) {
      return (0, 0, 0, 0);
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
    return (minX, maxX, minY, maxY);
  }
}
