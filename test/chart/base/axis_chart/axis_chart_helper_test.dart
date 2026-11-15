import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tolerance = 0.0001;

  List<double> axisValues({
    required double min,
    required double max,
    required double interval,
    double baseLine = 0,
    bool minIncluded = true,
    bool maxIncluded = true,
  }) {
    return AxisChartHelper()
        .iterateThroughAxis(
          min: min,
          max: max,
          interval: interval,
          baseLine: baseLine,
          minIncluded: minIncluded,
          maxIncluded: maxIncluded,
        )
        .toList();
  }

  void expectAxisValues(List<double> actual, List<double> expected) {
    expect(actual, hasLength(expected.length));
    for (var i = 0; i < expected.length; i++) {
      expect(
        actual[i],
        closeTo(expected[i], tolerance),
        reason: 'index $i: expected ${expected[i]}, got ${actual[i]}',
      );
    }
  }

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

    group('boundary titles near an interval label (#2061)', () {
      test('skips a min boundary that overlaps the next interval label', () {
        final results = axisValues(min: 3.2, max: 14, interval: 4);

        // 3.2 is 0.8 from 4; the overlap gap is a quarter of the interval (1).
        expectAxisValues(results, [4, 8, 12, 14]);
      });

      test('skips a max boundary that overlaps the previous interval label',
          () {
        final results = axisValues(min: 2, max: 12.2, interval: 4);

        // 12.2 is 0.2 from 12.
        expectAxisValues(results, [2, 4, 8, 12]);
      });

      test('skips both boundaries from the reported overlap example', () {
        final results = axisValues(min: 7.98, max: 8.52, interval: 0.10);

        // 7.98 is 0.02 from 8.00 and 8.52 is 0.02 from 8.50 (interval 0.10).
        expectAxisValues(results, [8, 8.1, 8.2, 8.3, 8.4, 8.5]);
      });

      test('skips the min title beside the next interval for issue #2061', () {
        // y spots -203 and -2 with an efficient interval of 50.
        final results = axisValues(min: -203, max: -2, interval: 50);

        // -203 is 3 away from -200 (0.06 of the interval). -2 is 48 away
        // from -50, so the max title stays.
        expectAxisValues(results, [-200, -150, -100, -50, -2]);
      });

      test('keeps a boundary that is at least a quarter interval away', () {
        // Exactly a quarter of the interval (distance 1, interval 4) is kept.
        final atThreshold = axisValues(min: 3, max: 20, interval: 4);
        expectAxisValues(atThreshold, [3, 4, 8, 12, 16, 20]);

        // Comfortably farther than a quarter (distance 2, interval 4).
        final far = axisValues(min: 2, max: 13, interval: 4);
        expectAxisValues(far, [2, 4, 8, 12, 13]);
      });

      test('does not duplicate a boundary that lands on an interval value', () {
        final results = axisValues(min: 0, max: 12, interval: 4);

        expectAxisValues(results, [0, 4, 8, 12]);
        expect(results.toSet(), hasLength(results.length));
      });

      test('minIncluded and maxIncluded false are unaffected', () {
        final close = axisValues(
          min: 7.98,
          max: 8.52,
          interval: 0.10,
          minIncluded: false,
          maxIncluded: false,
        );
        expectAxisValues(close, [8, 8.1, 8.2, 8.3, 8.4, 8.5]);

        // Far boundaries would be included when the flags are true, and are
        // still omitted when the flags are false.
        final far = axisValues(
          min: 2,
          max: 13,
          interval: 4,
          minIncluded: false,
          maxIncluded: false,
        );
        expectAxisValues(far, [4, 8, 12]);

        final minOnly = axisValues(
          min: 3.2,
          max: 14,
          interval: 4,
          maxIncluded: false,
        );
        expectAxisValues(minOnly, [4, 8, 12]);

        final maxOnly = axisValues(
          min: 2,
          max: 12.2,
          interval: 4,
          minIncluded: false,
        );
        expectAxisValues(maxOnly, [4, 8, 12]);
      });
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
