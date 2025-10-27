import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_curve.dart';
import 'package:flutter_test/flutter_test.dart';

const samplePoints1 = [
  Offset(10, 10),
  Offset(20, 20),
  Offset(30, 40),
  Offset(40, 10),
];

void main() {
  test('static constructor', () {
    expect(LineChartCurve.noCurve, equals(const LineChartNoCurve()));
    expect(
      LineChartCurve.cubicTension(),
      equals(const LineChartCubicTensionCurve()),
    );
    expect(
      LineChartCurve.cubicMonotone(),
      equals(const LineChartCubicMonotoneCurve()),
    );
  });

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

    test('lerp no curve', () {
      const curve = LineChartCubicTensionCurve(smoothness: 0.8);

      expect(
        lerpCurve(curve, const LineChartNoCurve(), 0.5),
        equals(const LineChartCubicTensionCurve(smoothness: 0.4)),
      );
    });

    test('CubicTensionCurve with smoothness = 0 behaves like straight line',
        () {
      expectLikeStraightLine(const LineChartCubicTensionCurve(smoothness: 0));
    });

    test(
        'prevents overshoot when dy difference is below threshold in y direction',
        () {
      const curve = LineChartCubicTensionCurve(
        preventCurveOverShooting: true,
      );

      // Create points where dy difference is below threshold (5 < 10)
      final points = [
        Offset.zero,
        const Offset(20, 5), // dy = 5
        const Offset(40, 8), // dy = 3
      ];

      final path = _buildPathWithCurve(points, curve);

      final metrics = path.computeMetrics().toList();
      expect(metrics.length, 1);
    });

    test(
        'prevents overshoot when dx difference is below threshold in x direction',
        () {
      const curve = LineChartCubicTensionCurve(
        preventCurveOverShooting: true,
      );

      // Create points where dx difference is below threshold (5 < 10)
      final points = [
        Offset.zero,
        const Offset(5, 20), // dx = 5
        const Offset(8, 40), // dx = 3
      ];

      final path = _buildPathWithCurve(points, curve);

      final metrics = path.computeMetrics().toList();
      expect(metrics.length, 1);
    });
  });

  group('LineChartCubicMonotoneCurve', () {
    test('equality check', () {
      const a = LineChartCubicMonotoneCurve();
      const b = LineChartCubicMonotoneCurve();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('lerp no curve', () {
      const curve = LineChartCubicMonotoneCurve(smooth: 0.8);

      expect(
        lerpCurve(const LineChartNoCurve(), curve, 0.5),
        equals(const LineChartCubicMonotoneCurve(smooth: 0.4)),
      );
    });

    test('draw straight line if just two points', () {
      expectLikeStraightLine(
        const LineChartCubicMonotoneCurve(tinyThresholdSquared: 0),
        points: [Offset.zero, const Offset(10, 10)],
      );
    });

    test('draw straight line if smooth = 0', () {
      expectLikeStraightLine(
        const LineChartCubicMonotoneCurve(
          smooth: 0,
          tinyThresholdSquared: double.infinity,
        ),
      );
    });

    group('tinyThreshold parameter behavior', () {
      test('draw straight line if distance < tinyThreshold', () {
        expectLikeStraightLine(
          const LineChartCubicMonotoneCurve(
            tinyThresholdSquared: double.infinity,
          ),
        );
      });

      test('draw curved line if distance > tinyThreshold', () {
        final path = _buildPathWithCurve(
          samplePoints1,
          const LineChartCubicMonotoneCurve(tinyThresholdSquared: 0),
        );

        final metrics = path.computeMetrics().toList();

        expect(
          metrics.single.length,
          greaterThan(samplePoints1.straightDistance),
        );
      });
    });

    group('smooth parameter behavior', () {
      test('the effect of smooth increases monotonically', () {
        var smoothCount = 1;
        var lastCurveLength = samplePoints1.straightDistance;

        while (smoothCount < 11) {
          final smooth = 0.1 * smoothCount;

          final path = _buildPathWithCurve(
            samplePoints1,
            LineChartCubicMonotoneCurve(
              smooth: smooth,
              tinyThresholdSquared: 0,
            ),
          );
          final curveLength = path.computeMetrics().single.length;
          expect(curveLength, greaterThanOrEqualTo(lastCurveLength));
          lastCurveLength = curveLength;
          smoothCount++;
        }
      });
    });
  });
}

void expectLikeStraightLine(
  LineChartCurve curve, {
  List<Offset> points = samplePoints1,
}) {
  final path = _buildPathWithCurve(points, curve);

  final metrics = path.computeMetrics().toList();
  expect(metrics.single.length, closeTo(points.straightDistance, 0.001));
}

/// Helper function to build a complete path with the given curve
Path _buildPathWithCurve(List<Offset> points, LineChartCurve curve) {
  final path = Path();
  if (points.isEmpty) {
    return path;
  }

  path.moveTo(points[0].dx, points[0].dy);

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

extension on List<Offset> {
  double get straightDistance {
    double distance = 0;
    for (var i = 1; i < length; i++) {
      distance += this[i].distanceTo(this[i - 1]);
    }
    return distance;
  }
}
