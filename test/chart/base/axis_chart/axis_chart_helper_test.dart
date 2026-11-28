import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tolerance = 0.0001;
  group('iterateThroughAxis()', () {
    test('test 1', () {
      final results = <double>[];
      AxisChartHelper()
          .iterateThroughAxis(min: 0, max: 0.1, interval: 0.001, baseLine: 0)
          .forEach(results.add);
      expect(results.length, 101);
    });

    test('test 2', () {
      final results = <double>[];
      AxisChartHelper()
          .iterateThroughAxis(
            min: 0,
            minIncluded: false,
            max: 0.1,
            maxIncluded: false,
            interval: 0.001,
            baseLine: 0,
          )
          .forEach(results.add);
      expect(results.length, 99);
      expect(results[0], closeTo(0.001, tolerance));
      expect(results[98], closeTo(0.099, tolerance));
    });

    test('test 3', () {
      final results = <double>[];
      AxisChartHelper()
          .iterateThroughAxis(min: 0, max: 1000, interval: 200, baseLine: 0)
          .forEach(results.add);
      expect(results.length, 6);
      expect(results[0], 0);
      expect(results[1], 200);
      expect(results[2], 400);
      expect(results[3], 600);
      expect(results[4], 800);
      expect(results[5], 1000);
    });

    test('test 4', () {
      final results = <double>[];
      AxisChartHelper()
          .iterateThroughAxis(min: 0, max: 10, interval: 3, baseLine: 0)
          .forEach(results.add);
      expect(results.length, 5);
      expect(results[0], 0);
      expect(results[1], 3);
      expect(results[2], 6);
      expect(results[3], 9);
      expect(results[4], 10);
    });

    test('test 5', () {
      final results = <double>[];
      AxisChartHelper()
          .iterateThroughAxis(
            min: 0,
            minIncluded: false,
            max: 10,
            maxIncluded: false,
            interval: 3,
            baseLine: 0,
          )
          .forEach(results.add);
      expect(results.length, 3);
      expect(results[0], 3);
      expect(results[1], 6);
      expect(results[2], 9);
    });

    test('test 6', () {
      final results = <double>[];
      AxisChartHelper()
          .iterateThroughAxis(min: 35, max: 130, interval: 50, baseLine: 0)
          .forEach(results.add);
      expect(results.length, 4);
      expect(results[0], 35);
      expect(results[1], 50);
      expect(results[2], 100);
      expect(results[3], 130);
    });

    test('test 7', () {
      final results = <double>[];
      AxisChartHelper()
          .iterateThroughAxis(min: 5, max: 35, interval: 10, baseLine: 5)
          .forEach(results.add);
      expect(results.length, 4);
      expect(results[0], 5);
      expect(results[1], 15);
      expect(results[2], 25);
      expect(results[3], 35);
    });

    test('large values do not drift away from the interval grid (#1473)', () {
      const min = 1698797425.0;
      const max = 1698797426.0;
      const interval = 0.1;
      final results = <double>[];
      AxisChartHelper()
          .iterateThroughAxis(
            min: min,
            max: max,
            interval: interval,
            baseLine: 0,
          )
          .forEach(results.add);

      expect(results.last, max);
      // No artifact label may sit right next to max (e.g. 1698797425.999999);
      // every neighboring pair must be roughly one interval apart.
      for (var i = 1; i < results.length; i++) {
        expect(
          results[i] - results[i - 1],
          greaterThan(interval / 2),
          reason: 'values ${results[i - 1]} and ${results[i]} are '
              'closer than half an interval',
        );
      }
    });

    test('inverted axis yields the same values as the normal axis (#1769)', () {
      final all = AxisChartHelper()
          .iterateThroughAxis(min: 3, max: -3, interval: 1, baseLine: 0)
          .toList();
      expect(all, hasLength(7));
      expect(all.toSet(), {-3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0});

      final inner = AxisChartHelper()
          .iterateThroughAxis(
            min: 3,
            minIncluded: false,
            max: -3,
            maxIncluded: false,
            interval: 1,
            baseLine: 0,
          )
          .toList();
      expect(inner, hasLength(5));
      expect(inner.toSet(), {-2.0, -1.0, 0.0, 1.0, 2.0});
    });

    test('inverted axis swaps minIncluded and maxIncluded (#1769)', () {
      final inverted = AxisChartHelper()
          .iterateThroughAxis(
            min: 3,
            minIncluded: false,
            max: -3,
            interval: 1,
            baseLine: 0,
          )
          .toSet();
      final normal = AxisChartHelper()
          .iterateThroughAxis(
            min: -3,
            max: 3,
            maxIncluded: false,
            interval: 1,
            baseLine: 0,
          )
          .toSet();
      expect(inverted, {-3.0, -2.0, -1.0, 0.0, 1.0, 2.0});
      expect(inverted, normal);
    });

    test('negative interval ends and matches the positive interval (#1769)',
        () {
      // A sync infinite loop cannot be stopped by a test timeout, so every
      // negative-interval call is capped with take() first.
      for (final (min, max) in [(3.0, -3.0), (-3.0, 3.0)]) {
        final negative = AxisChartHelper()
            .iterateThroughAxis(min: min, max: max, interval: -1, baseLine: 0)
            .take(100)
            .toList();
        final positive = AxisChartHelper()
            .iterateThroughAxis(min: min, max: max, interval: 1, baseLine: 0)
            .toSet();
        expect(negative.length, lessThan(100), reason: 'min: $min, max: $max');
        expect(
          negative.toSet(),
          {-3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0},
          reason: 'min: $min, max: $max',
        );
        expect(negative.toSet(), positive, reason: 'min: $min, max: $max');
      }
    });

    test('min == max keeps the output of e60b4c13 (#1769)', () {
      expect(
        AxisChartHelper()
            .iterateThroughAxis(min: 3, max: 3, interval: 1, baseLine: 0)
            .toList(),
        [3.0],
      );
      expect(
        AxisChartHelper()
            .iterateThroughAxis(
              min: 3,
              minIncluded: false,
              max: 3,
              maxIncluded: false,
              interval: 1,
              baseLine: 0,
            )
            .toList(),
        isEmpty,
      );
    });
  });

  group('calcFitInsideOffset', () {
    group('not overflowed', () {
      test('vertical axis', () {
        const result = Offset.zero;

        final offset = AxisChartHelper().calcFitInsideOffset(
          axisSide: AxisSide.left,
          childSize: 10,
          parentAxisSize: 100,
          axisPosition: 20,
          distanceFromEdge: 0,
        );

        expect(offset, result);
      });

      test('horizontal axis', () {
        const result = Offset.zero;

        final offset = AxisChartHelper().calcFitInsideOffset(
          axisSide: AxisSide.bottom,
          childSize: 10,
          parentAxisSize: 100,
          axisPosition: 20,
          distanceFromEdge: 0,
        );

        expect(offset, result);
      });
    });

    group('overflowed', () {
      test('vertical axis at start', () {
        const result = Offset(0, 5);

        final offset = AxisChartHelper().calcFitInsideOffset(
          axisSide: AxisSide.left,
          childSize: 10,
          parentAxisSize: 100,
          axisPosition: 0,
          distanceFromEdge: 0,
        );

        expect(offset, result);
      });
      test('vertical axis at end', () {
        const result = Offset(0, -5);

        final offset = AxisChartHelper().calcFitInsideOffset(
          axisSide: AxisSide.left,
          childSize: 10,
          parentAxisSize: 100,
          axisPosition: 100,
          distanceFromEdge: 0,
        );

        expect(offset, result);
      });

      test('horizontal axis at start', () {
        const result = Offset(5, 0);

        final offset = AxisChartHelper().calcFitInsideOffset(
          axisSide: AxisSide.bottom,
          childSize: 10,
          parentAxisSize: 100,
          axisPosition: 0,
          distanceFromEdge: 0,
        );

        expect(offset, result);
      });
      test('horizontal axis at end', () {
        const result = Offset(-5, 0);

        final offset = AxisChartHelper().calcFitInsideOffset(
          axisSide: AxisSide.bottom,
          childSize: 10,
          parentAxisSize: 100,
          axisPosition: 100,
          distanceFromEdge: 0,
        );

        expect(offset, result);
      });
    });
  });
}
