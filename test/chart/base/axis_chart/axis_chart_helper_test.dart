import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tolerance = 0.0001;
  group('iterateThroughAxis()', () {
    test('test 1', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        max: 0.1,
        interval: 0.001,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 101);
    });

    test('test 2', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        minIncluded: false,
        max: 0.1,
        maxIncluded: false,
        interval: 0.001,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 99);
      expect(results[0], closeTo(0.001, tolerance));
      expect(results[98], closeTo(0.099, tolerance));
    });

    test('test 3', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        max: 1000,
        interval: 200,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
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
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        max: 10,
        interval: 3,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 5);
      expect(results[0], 0);
      expect(results[1], 3);
      expect(results[2], 6);
      expect(results[3], 9);
      expect(results[4], 10);
    });

    test('test 5', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 0,
        minIncluded: false,
        max: 10,
        maxIncluded: false,
        interval: 3,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 3);
      expect(results[0], 3);
      expect(results[1], 6);
      expect(results[2], 9);
    });

    test('test 6', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 35,
        max: 130,
        interval: 50,
        baseLine: 0,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 4);
      expect(results[0], 35);
      expect(results[1], 50);
      expect(results[2], 100);
      expect(results[3], 130);
    });

    test('test 7', () {
      final results = <double>[];
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: 5,
        max: 35,
        interval: 10,
        baseLine: 5,
      );
      for (final axisValue in axisValues) {
        results.add(axisValue);
      }
      expect(results.length, 4);
      expect(results[0], 5);
      expect(results[1], 15);
      expect(results[2], 25);
      expect(results[3], 35);
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
