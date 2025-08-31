import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/bar_chart_data_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';

void main() {
  group('BarChartDataExtension.calculateGroupsX', () {
    test('calculates correct positions for basic alignments', () {
      const width = 200.0;

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.start)
            .calculateGroupsX(width),
        [9.0, 43.0, 77.0],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.end)
            .calculateGroupsX(width),
        [123.0, 157.0, 191.0],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.center)
            .calculateGroupsX(width),
        [66.0, 100.0, 134.0],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.spaceBetween)
            .calculateGroupsX(width),
        [9.0, 100.0, 191.0],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.spaceAround)
            .calculateGroupsX(width),
        [33.33333333333333, 99.99999999999999, 166.66666666666666],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.spaceEvenly)
            .calculateGroupsX(width),
        [9.0, 100.0, 191.0],
      );
    });

    for (final alignment in [
      BarChartAlignment.start,
      BarChartAlignment.end,
      BarChartAlignment.center,
    ]) {
      test(
        'spaces evenly when a groupX exceeds view width for $alignment',
        () {
          expect(
            MockData.barChartData1
                .copyWith(alignment: alignment)
                .calculateGroupsX(60),
            [9.0, 30.0, 51.0],
          );
        },
      );
    }

    test('Throws Assertion error when barGroups is empty', () {
      expect(
        () => MockData.barChartData1
            .copyWith(barGroups: []).calculateGroupsX(100),
        throwsAssertionError,
      );
    });

    test('Test shrinkWrapOnWidthOverflow calcualtes spacing correctly', () {
      expect(
        MockData.barChartData1.calculateGroupsX(100),
        [9.0, 50.0, 91.0],
      );
    });
  });
}
