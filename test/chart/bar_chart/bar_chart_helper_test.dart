import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('Check caching of BarChartHelper.calculateMaxAxisValues', () {
    test('Test validity 1', () {
      final barChartHelper = BarChartHelper();
      final barGroups = [barChartGroupData1, barChartGroupData2];
      final (minY, maxY) = barChartHelper.calculateMaxAxisValues(barGroups);
      expect(minY, 0);
      expect(maxY, 1132);
    });

    test('Test validity 2', () {
      final barChartHelper = BarChartHelper();
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
      final (minY, maxY) = barChartHelper.calculateMaxAxisValues(barGroups);
      expect(minY, -40);
      expect(maxY, 10);
    });

    test('Test validity 3', () {
      final barChartHelper = BarChartHelper();
      final barGroups = [
        barChartGroupData1.copyWith(barRods: []),
      ];
      final (minY, maxY) = barChartHelper.calculateMaxAxisValues(barGroups);
      expect(minY, 0);
      expect(maxY, 0);
    });

    test('Test validity 4', () {
      final barChartHelper = BarChartHelper();
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
      final (minY, maxY) = barChartHelper.calculateMaxAxisValues(barGroups);
      expect(minY, -50);
      expect(maxY, 39);
    });

    test('Test equality', () {
      final barChartHelper = BarChartHelper();
      final barGroups = [barChartGroupData1, barChartGroupData2];
      final result1 = barChartHelper.calculateMaxAxisValues(barGroups);
      final result2 = barChartHelper.calculateMaxAxisValues(barGroups);
      expect(result1, result2);
    });

    test('Test calculateMaxAxisValues with all positive values', () {
      final barChartHelper = BarChartHelper();
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
      final (minY, _) = barChartHelper.calculateMaxAxisValues(barGroups);
      expect(minY, 5);
    });

    test('Test calculateMaxAxisValues with all negative values', () {
      final barChartHelper = BarChartHelper();
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
      final (minY, _) = barChartHelper.calculateMaxAxisValues(barGroups);
      expect(minY, -8);
    });
  });
}
