import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('Check caching of ScatterChartHelper.calculateMaxAxisValues', () {
    test('Test validity 1', () {
      final scatterSpots = [
        scatterSpot1,
        scatterSpot2,
        scatterSpot3,
        scatterSpot4,
      ];
      final (minX, maxX, minY, maxY) =
          ScatterChartHelper.calculateMaxAxisValues(scatterSpots);
      expect(minX, -14);
      expect(maxX, 1);
      expect(minY, -8);
      expect(maxY, 40);
    });

    test('Test validity 2', () {
      final scatterSpots = [
        ScatterSpot(3, -1),
        ScatterSpot(-1, 3),
      ];
      final (minX, maxX, minY, maxY) =
          ScatterChartHelper.calculateMaxAxisValues(scatterSpots);
      expect(minX, -1);
      expect(maxX, 3);
      expect(minY, -1);
      expect(maxY, 3);
    });

    test('Test validity 3', () {
      final scatterSpots = <ScatterSpot>[];
      final (minX, maxX, minY, maxY) =
          ScatterChartHelper.calculateMaxAxisValues(scatterSpots);
      expect(minX, 0);
      expect(maxX, 0);
      expect(minY, 0);
      expect(maxY, 0);
    });

    test('Test equality', () {
      final scatterSpots = [scatterSpot1, scatterSpot2, scatterSpot3];
      final scatterSpotsClone = [
        scatterSpot1Clone,
        scatterSpot2Clone,
        scatterSpot3,
      ];
      final result1 = ScatterChartHelper.calculateMaxAxisValues(scatterSpots);
      final result2 =
          ScatterChartHelper.calculateMaxAxisValues(scatterSpotsClone);
      expect(result1, result2);
    });
  });
}
