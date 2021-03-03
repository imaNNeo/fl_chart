import '../data_pool.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Check caching of ScatterChartHelper.calculateMaxAxisValues', () {
    // final ScatterSpot scatterSpot1 = ScatterSpot(1, 40);
    // final ScatterSpot scatterSpot2 = ScatterSpot(-4, -8);
    // final ScatterSpot scatterSpot3 = ScatterSpot(-14, 5);
    // final ScatterSpot scatterSpot4 = ScatterSpot(-0, 0);

    test('Test read from cache', () {
      final scatterSpots1 = [scatterSpot2];
      final result1 = ScatterChartHelper.calculateMaxAxisValues(scatterSpots1);

      final scatterSpots2 = [scatterSpot3];
      final result2 = ScatterChartHelper.calculateMaxAxisValues(scatterSpots2);

      expect(result1.readFromCache, false);
      expect(result2.readFromCache, false);
    });

    test('Test read from cache', () {
      final scatterSpots = [scatterSpot1, scatterSpot2, scatterSpot3];
      final scatterSpotsClone = [scatterSpot1Clone, scatterSpot2Clone, scatterSpot3];
      final result1 = ScatterChartHelper.calculateMaxAxisValues(scatterSpots);
      final result2 = ScatterChartHelper.calculateMaxAxisValues(scatterSpotsClone);
      expect(result1.readFromCache, false);
      expect(result2.readFromCache, true);
    });

    test('Test validity 1', () {
      final scatterSpots = [scatterSpot1, scatterSpot2, scatterSpot3, scatterSpot4];
      final result = ScatterChartHelper.calculateMaxAxisValues(scatterSpots);
      expect(result.minX, -14);
      expect(result.maxX, 1);
      expect(result.minY, -8);
      expect(result.maxY, 40);
    });

    test('Test validity 2', () {
      final scatterSpots = [
        ScatterSpot(3, -1),
        ScatterSpot(-1, 3),
      ];
      final result = ScatterChartHelper.calculateMaxAxisValues(scatterSpots);
      expect(result.minX, -1);
      expect(result.maxX, 3);
      expect(result.minY, -1);
      expect(result.maxY, 3);
    });

    test('Test equality', () {
      final scatterSpots = [scatterSpot1, scatterSpot2, scatterSpot3];
      final scatterSpotsClone = [scatterSpot1Clone, scatterSpot2Clone, scatterSpot3];
      final result1 = ScatterChartHelper.calculateMaxAxisValues(scatterSpots);
      final result2 = ScatterChartHelper.calculateMaxAxisValues(scatterSpotsClone);
      expect(result1, result2);
    });
  });
}
