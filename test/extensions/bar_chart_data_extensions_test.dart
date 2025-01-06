import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/bar_chart_data_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';

void main() {
  group('BarChartDataExtension.calculateGroupsX', () {
    test('calculates correct positions for basic alignments', () {
      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.start)
            .calculateGroupsX(100),
        [9.0, 43.0, 77.0],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.end)
            .calculateGroupsX(100),
        [23.0, 57.0, 91.0],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.center)
            .calculateGroupsX(100),
        [16.0, 50.0, 84.0],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.spaceBetween)
            .calculateGroupsX(100),
        [9.0, 50.0, 91.0],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.spaceAround)
            .calculateGroupsX(100),
        [16.666666666666668, 50.0, 83.33333333333334],
      );

      expect(
        MockData.barChartData1
            .copyWith(alignment: BarChartAlignment.spaceEvenly)
            .calculateGroupsX(100),
        [20.5, 50.0, 79.5],
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
            [10.5, 30.0, 49.5],
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
  });
}
