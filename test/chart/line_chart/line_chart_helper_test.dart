import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('Check caching of LineChartHelper.calculateMaxAxisValues', () {
    test('Test validity 1', () {
      final lineChartHelper = LineChartHelper();
      final lineBars = [lineChartBarData1, lineChartBarData2];
      final (minX, maxX, minY, maxY) = lineChartHelper.calculateMaxAxisValues(
        lineBars,
      );
      expect(minX, 1);
      expect(maxX, 4);
      expect(minY, 1);
      expect(maxY, 2);
    });

    test('Test validity 2', () {
      final lineChartHelper = LineChartHelper();
      final lineBars = [
        lineChartBarData1.copyWith(
          spots: const [FlSpot(3, 4), FlSpot(-3, 50), FlSpot(14, -10)],
        ),
      ];
      final (minX, maxX, minY, maxY) = lineChartHelper.calculateMaxAxisValues(
        lineBars,
      );
      expect(minX, -3);
      expect(maxX, 14);
      expect(minY, -10);
      expect(maxY, 50);
    });

    test('Test equality', () {
      final lineChartHelper = LineChartHelper();
      final lineBars = [lineChartBarData1, lineChartBarData2];
      final lineBarsClone = [lineChartBarData1Clone, lineChartBarData2];
      final result1 = lineChartHelper.calculateMaxAxisValues(lineBars);
      final result2 = lineChartHelper.calculateMaxAxisValues(lineBarsClone);
      expect(result1, result2);
    });

    test('Test null spot 1', () {
      final lineChartHelper = LineChartHelper();
      final lineBars = [
        LineChartBarData(
          spots: [
            FlSpot.nullSpot,
            FlSpot.nullSpot,
            FlSpot.nullSpot,
            FlSpot.nullSpot,
          ],
        ),
      ];
      expect(lineChartHelper.calculateMaxAxisValues(lineBars), (0, 0, 0, 0));
    });

    test('Test null spot 2', () {
      final lineChartHelper = LineChartHelper();
      final lineBars = [
        LineChartBarData(
          spots: [
            FlSpot.nullSpot,
            const FlSpot(-1, 5),
            FlSpot.nullSpot,
            const FlSpot(4, -3),
          ],
        ),
      ];
      expect(lineChartHelper.calculateMaxAxisValues(lineBars), (-1, 4, -3, 5));
    });

    test(
      'Test barData with only nullSpot alongside valid barData (Issue #2115)',
      () {
        final lineChartHelper = LineChartHelper();
        final lineBars = [
          LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 1)]),
          LineChartBarData(spots: [FlSpot.nullSpot]),
        ];
        final (minX, maxX, minY, maxY) = lineChartHelper.calculateMaxAxisValues(
          lineBars,
        );
        expect(minX, 0);
        expect(maxX, 1);
        expect(minY, 0);
        expect(maxY, 1);
      },
    );

    test(
      'Test first barData with only nullSpot and second barData with valid spots',
      () {
        final lineChartHelper = LineChartHelper();
        final lineBars = [
          LineChartBarData(spots: [FlSpot.nullSpot]),
          LineChartBarData(spots: const [FlSpot(2, 3), FlSpot(5, 7)]),
        ];
        final (minX, maxX, minY, maxY) = lineChartHelper.calculateMaxAxisValues(
          lineBars,
        );
        expect(minX, 2);
        expect(maxX, 5);
        expect(minY, 3);
        expect(maxY, 7);
      },
    );
  });
}
