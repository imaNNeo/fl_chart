import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

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
        barChartGroupData1.copyWith(
          barRods: [
            BarChartRodData(toY: -10),
            BarChartRodData(toY: -40),
            BarChartRodData(toY: 0),
            BarChartRodData(toY: 10),
            BarChartRodData(toY: 5),
          ],
        ),
      ];
      final result = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result.minY, -40);
      expect(result.maxY, 10);
    });

    test('Test validity 3', () {
      final barGroups = [
        barChartGroupData1.copyWith(barRods: []),
      ];
      final result = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result.minY, 0);
      expect(result.maxY, 0);
    });

    test('Test validity 4', () {
      final barGroups = [
        barChartGroupData1.copyWith(
          barRods: [
            BarChartRodData(fromY: 0, toY: -10),
            BarChartRodData(fromY: -10, toY: -40),
            BarChartRodData(toY: 0),
            BarChartRodData(toY: 10),
            BarChartRodData(toY: 5),
            BarChartRodData(fromY: 10, toY: -50),
            BarChartRodData(fromY: 39, toY: -50),
          ],
        ),
      ];
      final result = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result.minY, -50);
      expect(result.maxY, 39);
    });

    test('Test equality', () {
      final barGroups = [barChartGroupData1, barChartGroupData2];
      final result1 = BarChartHelper.calculateMaxAxisValues(barGroups);
      final result2 = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result1, result2);
    });

    test('Test equality2', () {
      final barGroups = [barChartGroupData1, barChartGroupData2];
      final result1 = BarChartHelper.calculateMaxAxisValues(barGroups)
          .copyWith(readFromCache: true);
      final result2 = result1.copyWith(readFromCache: false);
      expect(result1 != result2, true);
    });

    test('Test BarChartMinMaxAxisValues class', () {
      final result1 = BarChartMinMaxAxisValues(0, 10)
          .copyWith(minY: 1, maxY: 11, readFromCache: true);
      final result2 = BarChartMinMaxAxisValues(1, 11, readFromCache: true);
      expect(result1, result2);
    });

    test('Test calculateMaxAxisValues with all positive values', () {
      final barGroups = [
        barChartGroupData1.copyWith(
          barRods: barChartGroupData1.barRods
              .map(
                (rod) => rod.copyWith(
                  fromY: 5,
                  backDrawRodData: BackgroundBarChartRodData(show: false),
                ),
              )
              .toList(),
        ),
        barChartGroupData2.copyWith(
          barRods: barChartGroupData2.barRods
              .map(
                (rod) => rod.copyWith(
                  fromY: 8,
                  backDrawRodData: BackgroundBarChartRodData(show: false),
                ),
              )
              .toList(),
        ),
      ];
      final result1 = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result1.minY, 5);
    });

    test('Test calculateMaxAxisValues with all negative values', () {
      final barGroups = [
        barChartGroupData1.copyWith(
          barRods: barChartGroupData1.barRods
              .map((rod) => rod.copyWith(fromY: -5))
              .toList(),
        ),
        barChartGroupData2.copyWith(
          barRods: barChartGroupData2.barRods
              .map((rod) => rod.copyWith(fromY: -8))
              .toList(),
        ),
      ];
      final result1 = BarChartHelper.calculateMaxAxisValues(barGroups);
      expect(result1.minY, -8);
    });
  });
}
