import '../data_pool.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Check caching of BarChartHelper.calculateMaxAxisValues', () {
    test('Test read from cache1', () {
      final barGroups1 = [barChartGroupData1];
      final result1 = BarChartHelper.calculateMaxAxisValues(barGroups1);

      final barGroups2 = [barChartGroupData2];
      final result2 = BarChartHelper.calculateMaxAxisValues(barGroups2);
      expect(result1.readFromCache, false);
      expect(result2.readFromCache, false);
    });

    test('Test read from cache2', () {
      final barGroups = [barChartGroupData1, barChartGroupData2];
      final result1 = BarChartHelper.calculateMaxAxisValues(barGroups);
      final result2 = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result1.readFromCache, false);
      expect(result2.readFromCache, true);
    });

    test('Test validity 1', () {
      final barGroups = [barChartGroupData1, barChartGroupData2];
      final result = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result.minY, 0);
      expect(result.maxY, 1132);
    });

    test('Test validity 2', () {
      final barGroups = [
        barChartGroupData1.copyWith(barRods: [
          BarChartRodData(y: -10),
          BarChartRodData(y: -40),
          BarChartRodData(y: 0),
          BarChartRodData(y: 10),
          BarChartRodData(y: 5),
        ])
      ];
      final result = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result.minY, -40);
      expect(result.maxY, 10);
    });

    test('Test equality', () {
      final barGroups = [barChartGroupData1, barChartGroupData2];
      final result1 = BarChartHelper.calculateMaxAxisValues(barGroups);
      final result2 = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result1, result2);
    });
  });
}
