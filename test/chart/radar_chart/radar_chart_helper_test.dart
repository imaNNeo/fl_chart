import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('Check caching of RadarChartHelper.calculateMinMaxAxisValue', () {
    test('Test read from cache1', () {
      final dataSet1 = [radarDataSet1];
      final result1 = RadarChartHelper.calculateMinMaxAxisValue(dataSet1);

      final dataSet2 = [radarDataSet2];
      final result2 = RadarChartHelper.calculateMinMaxAxisValue(dataSet2);

      expect(result1.readFromCache, false);
      expect(result2.readFromCache, false);
    });

    test('Test read from cache2', () {
      final dataSet = [radarDataSet1];
      final result1 = RadarChartHelper.calculateMinMaxAxisValue(dataSet);
      final result2 = RadarChartHelper.calculateMinMaxAxisValue(dataSet);
      expect(result1.readFromCache, false);
      expect(result2.readFromCache, true);
    });

    test('Test validity 1', () {
      final dataSet = [radarDataSet1];
      final result = RadarChartHelper.calculateMinMaxAxisValue(dataSet);

      expect(result.min, 0);
      expect(result.max, 4);
    });

    test('Test validity 2', () {
      final dataSet = [
        radarDataSet1.copyWith(dataEntries: [
          const RadarEntry(value: 1),
          const RadarEntry(value: 8),
          const RadarEntry(value: 12),
        ])
      ];

      final result = RadarChartHelper.calculateMinMaxAxisValue(dataSet);

      expect(result.min, 1);
      expect(result.max, 12);
    });

    test('Test Validity 3', () {
      final dataSet = [radarDataSet1.copyWith(dataEntries: [])];
      final result = RadarChartHelper.calculateMinMaxAxisValue(dataSet);

      expect(result.min, 0);
      expect(result.max, 0);
    });

    test('Test Equality', () {
      final dataSet1 = [radarDataSet1, radarDataSet2];
      final dataSet2 = [radarDataSet1, radarDataSet2];

      final result1 = RadarChartHelper.calculateMinMaxAxisValue(dataSet1);
      final result2 = RadarChartHelper.calculateMinMaxAxisValue(dataSet2)
          .copyWith(readFromCache: false);

      expect(result1, result2);
      expect(result1, result2);
    });

    test('Test Equality 2', () {
      final dataSets = [radarDataSet1, radarDataSet2];

      final result1 = RadarChartHelper.calculateMinMaxAxisValue(dataSets)
          .copyWith(readFromCache: true);
      final result2 = result1.copyWith(readFromCache: false);

      expect(result1 != result2, true);
    });

    test('Test RadarChartMinMaxAxisValues class', () {
      final result1 = RadarChartMinMaxAxisValues(4, 9, readFromCache: false)
          .copyWith(min: 5, max: 10, readFromCache: true);
      final result2 = RadarChartMinMaxAxisValues(5, 10, readFromCache: true);

      expect(result1, result2);
    });
  });
}
