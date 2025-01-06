import 'dart:math';

import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';

/// Contains anything that helps BarChart works
class BarChartHelper {
  /// Calculates minY, and maxY based on [barGroups],
  /// returns cached values, to prevent redundant calculations.
  (double minY, double maxY) calculateMaxAxisValues(
    List<BarChartGroupData> barGroups,
  ) {
    if (barGroups.isEmpty) {
      return (0, 0);
    }

    final BarChartGroupData barGroup;
    try {
      barGroup = barGroups.firstWhere((element) => element.barRods.isNotEmpty);
    } catch (_) {
      // There is no barChartGroupData with at least one barRod
      return (0, 0);
    }

    var maxY = max(barGroup.barRods[0].fromY, barGroup.barRods[0].toY);
    var minY = min(barGroup.barRods[0].fromY, barGroup.barRods[0].toY);

    for (var i = 0; i < barGroups.length; i++) {
      final barGroup = barGroups[i];
      for (var j = 0; j < barGroup.barRods.length; j++) {
        final rod = barGroup.barRods[j];

        maxY = max(maxY, rod.fromY);
        minY = min(minY, rod.fromY);

        maxY = max(maxY, rod.toY);
        minY = min(minY, rod.toY);

        if (rod.backDrawRodData.show) {
          maxY = max(maxY, rod.backDrawRodData.fromY);
          minY = min(minY, rod.backDrawRodData.fromY);
          maxY = max(maxY, rod.backDrawRodData.toY);
          minY = min(minY, rod.backDrawRodData.toY);
        }
      }
    }
    return (minY, maxY);
  }
}
