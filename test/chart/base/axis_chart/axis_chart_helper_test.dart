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
      expect(results.length, 4);
      expect(results[0], 0);
      expect(results[1], 3);
      expect(results[2], 6);
      expect(results[3], 10);
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
      expect(results.length, 3);
      expect(results[0], 35);
      expect(results[1], 100);
      expect(results[2], 130);
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

    List<double> iterate({
      required double min,
      required double max,
      required double interval,
      bool minIncluded = true,
      bool maxIncluded = true,
    }) =>
        AxisChartHelper()
            .iterateThroughAxis(
              min: min,
              minIncluded: minIncluded,
              max: max,
              maxIncluded: maxIncluded,
              interval: interval,
              baseLine: 0,
            )
            .toList();

    void expectNeighborsAtLeastHalfIntervalApart(
      List<double> results,
      double interval,
    ) {
      for (var i = 1; i < results.length; i++) {
        expect(
          results[i] - results[i - 1],
          greaterThanOrEqualTo(interval / 2 - interval / 100000),
          reason: 'values ${results[i - 1]} and ${results[i]} are '
              'closer than half an interval',
        );
      }
    }

    test('min title is not crowded by the next interval title (#1761)', () {
      const min = 1735664400000.0;
      const max = min + 5 * 86400000;
      const interval = 86400000.0;
      final results = iterate(min: min, max: max, interval: interval);
      expect(results, [
        1735664400000,
        1735776000000,
        1735862400000,
        1735948800000,
        1736035200000,
        1736096400000,
      ]);
      expect(results.first, min);
      expect(results.last, max);
      expectNeighborsAtLeastHalfIntervalApart(results, interval);
    });

    test('max title is not crowded by the previous interval title (#1761)', () {
      final results = iterate(min: 0, max: 9.2, interval: 1);
      expect(results, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9.2]);
      expectNeighborsAtLeastHalfIntervalApart(results, 1);
    });

    test('negative range keeps edge titles apart (#1761)', () {
      final results = iterate(min: -130, max: -35, interval: 50);
      expect(results, [-130, -100, -35]);
      expectNeighborsAtLeastHalfIntervalApart(results, 50);
    });

    test('min on an interval within float error is yielded once (#1761)', () {
      const interval = 0.1;
      final results = iterate(min: 0.7, max: 1.3, interval: interval);
      expect(results.length, 7);
      const expected = [0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3];
      for (var i = 0; i < expected.length; i++) {
        expect(results[i], closeTo(expected[i], interval / 100000));
      }
      expect(results.first, 0.7);
      expect(results.last, 1.3);
      expectNeighborsAtLeastHalfIntervalApart(results, interval);
    });

    test('range without interval titles keeps only min and max (#1761)', () {
      expect(iterate(min: 35, max: 40, interval: 50), [35, 40]);
    });

    test('both edges near the same interval keep min and max (#1761)', () {
      expect(iterate(min: 0.9, max: 1.1, interval: 1), [0.9, 1.1]);
    });

    test('both edges near the same large interval keep min and max (#1761)',
        () {
      expect(iterate(min: 49, max: 51, interval: 50), [49, 51]);
    });

    test('grid path (min and max excluded) is unchanged (#1761)', () {
      expect(
        iterate(
          min: 0.7,
          max: 1.3,
          interval: 0.1,
          minIncluded: false,
          maxIncluded: false,
        ),
        [
          0.7000000000000001,
          0.8,
          0.9000000000000001,
          1.0,
          1.1,
          1.2000000000000002,
        ],
      );
    });

    test('min equal to max yields a single value (#1761)', () {
      expect(iterate(min: 5, max: 5, interval: 1), [5]);
    });

    test('interval title exactly half an interval after min is kept (#1761)',
        () {
      expect(
        iterate(min: 0.45, max: 1.3, interval: 0.1),
        [0.45, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2000000000000002, 1.3],
      );
    });

    test('interval title exactly half an interval before max is kept (#1761)',
        () {
      expect(
        iterate(min: 0, max: 1.25, interval: 0.1),
        [
          0.0,
          0.1,
          0.2,
          0.30000000000000004,
          0.4,
          0.5,
          0.6000000000000001,
          0.7000000000000001,
          0.8,
          0.9,
          1.0,
          1.1,
          1.2000000000000002,
          1.25,
        ],
      );
    });

    test('only the min edge rule applies when max is excluded (#1761)', () {
      expect(
        iterate(min: 35, max: 130, interval: 50, maxIncluded: false),
        [35, 100],
      );
    });

    test('only the max edge rule applies when min is excluded (#1761)', () {
      expect(
        iterate(min: 0, max: 9.2, interval: 1, minIncluded: false),
        [1, 2, 3, 4, 5, 6, 7, 8, 9.2],
      );
    });

    test('tiny range with min near an interval keeps min (#1761)', () {
      expect(
        iterate(min: 0.7, max: 0.7000001, interval: 0.1),
        [0.7, 0.7000001],
      );
    });

    test('tiny range with min on an interval keeps min (#1761)', () {
      expect(iterate(min: 0, max: 0.000001, interval: 1), [0, 0.000001]);
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
