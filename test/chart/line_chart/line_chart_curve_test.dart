import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_curve.dart';
import 'package:flutter_test/flutter_test.dart';

void expectLikeStraightLine(
  LineChartCurve curve, {
  Offset point0 = Offset.zero,
  Offset point1 = const Offset(10, 10),
}) {
  final path = Path()..moveTo(point0.dx, point0.dy);
  curve.appendToPath(path, point0, point1, null);

  final metrics = path.computeMetrics().toList();
  expect(metrics.length, 1);
  expect(metrics.single.length, closeTo(point1.distanceTo(point0), 0.001));
}

void main() {
  group('LineChartNoCurve', () {
    test('equality check', () {
      const a = LineChartNoCurve();
      const b = LineChartNoCurve();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('no curve case returns self', () {
      const curve = LineChartNoCurve();
      expect(curve.noCurveCase, equals(curve));
    });

    test('lerp with no curve case returns self', () {
      const curve = LineChartNoCurve();
      expect(curve.lerp(curve, 0.5), equals(curve));
    });

    test('appendToPath draws straight line', () {
      expectLikeStraightLine(const LineChartNoCurve());
    });
  });

  group('LineChartCubicTensionCurve', () {
    test('equality check', () {
      const a = LineChartCubicTensionCurve();
      const b = LineChartCubicTensionCurve();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('no curve case', () {
      const curve = LineChartCubicTensionCurve();

      expect(
        curve.noCurveCase,
        equals(
          LineChartCubicTensionCurve(
            smoothness: 0,
            preventCurveOverShooting: curve.preventCurveOverShooting,
            preventCurveOvershootingThreshold:
                curve.preventCurveOvershootingThreshold,
          ),
        ),
      );
    });

    test('CubicTensionCurve with smoothness = 0 behaves like straight line',
        () {
      expectLikeStraightLine(const LineChartCubicTensionCurve(smoothness: 0));
    });
  });

  group('LineChartCubicMonotoneCurve', () {
    test('equality check', () {
      const a = LineChartCubicMonotoneCurve();
      const b = LineChartCubicMonotoneCurve();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('no curve case', () {
      const curve = LineChartCubicMonotoneCurve();

      expect(
        curve.noCurveCase,
        equals(
          LineChartCubicMonotoneCurve(
            smooth: 0,
            monotone: curve.monotone,
            tinyThresholdSquared: curve.tinyThresholdSquared,
          ),
        ),
      );
    });

    group('smooth parameter behavior', () {
      test('smooth = 0 produces straight line', () {
        expectLikeStraightLine(
          const LineChartCubicMonotoneCurve(smooth: 0),
        );
      });

      test('smooth = 0.3 produces curved line shorter than smooth = 0.7', () {
        final points = [
          Offset.zero,
          const Offset(10, 10),
          const Offset(20, 5),
          const Offset(30, 15),
        ];

        final path1 = _buildPathWithCurve(
          points,
          const LineChartCubicMonotoneCurve(smooth: 0.3),
        );
        final path2 = _buildPathWithCurve(
          points,
          const LineChartCubicMonotoneCurve(smooth: 0.7),
        );

        final metrics1 = path1.computeMetrics().toList();
        final metrics2 = path2.computeMetrics().toList();

        expect(metrics1.length, 1);
        expect(metrics2.length, 1);

        // Higher smooth value should produce longer curved path
        expect(
          metrics2.single.length,
          greaterThan(metrics1.single.length),
        );
      });

      test('smooth = 1.0 produces maximum smoothness', () {
        final points = [
          Offset.zero,
          const Offset(10, 10),
          const Offset(20, 5),
        ];

        final path = _buildPathWithCurve(
          points,
          const LineChartCubicMonotoneCurve(smooth: 1),
        );

        final metrics = path.computeMetrics().toList();
        expect(metrics.length, 1);
        // Curved path should be longer than straight line
        expect(
          metrics.single.length,
          greaterThan(
            points[0].distanceTo(points[1]) + points[1].distanceTo(points[2]),
          ),
        );
      });
    });

    group('state management (_flag)', () {
      test('flag resets after last point', () {
        final points = [
          Offset.zero,
          const Offset(10, 10),
          const Offset(20, 5),
        ];

        // First path
        final path1 = _buildPathWithCurve(
          points,
          const LineChartCubicMonotoneCurve(),
        );

        // Second path should not be affected by first path's flag
        final path2 = _buildPathWithCurve(
          points,
          const LineChartCubicMonotoneCurve(),
        );

        final metrics1 = path1.computeMetrics().toList();
        final metrics2 = path2.computeMetrics().toList();

        // Both paths should have identical length
        expect(
          metrics1.single.length,
          closeTo(metrics2.single.length, 0.001),
        );
      });
    });
  });
}

/// Helper function to build a complete path with the given curve
Path _buildPathWithCurve(List<Offset> points, LineChartCurve curve) {
  if (points.isEmpty) {
    return Path();
  }

  final path = Path()..moveTo(points[0].dx, points[0].dy);

  for (var i = 1; i < points.length; i++) {
    final previous = points[i - 1];
    final current = points[i];
    final next = i < points.length - 1 ? points[i + 1] : null;

    curve.appendToPath(path, previous, current, next);
  }

  return path;
}

extension on Offset {
  double distanceTo(Offset other) => (this - other).distance;
}
