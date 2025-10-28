import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_curve.dart';
import 'package:flutter_test/flutter_test.dart';

const testPoints1 = [
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
          testPoints1,
          const LineChartCubicMonotoneCurve(tinyThresholdSquared: 0),
        );

        final metrics = path.computeMetrics().toList();

        expect(
          metrics.single.length,
          greaterThan(testPoints1.straightDistance),
        );
      });
    });

    group('smooth parameter behavior', () {
      test('the effect of smooth increases monotonically', () {
        var smoothCount = 1;
        var lastCurveLength = testPoints1.straightDistance;

        while (smoothCount < 11) {
          final smooth = 0.1 * smoothCount;

          final path = _buildPathWithCurve(
            testPoints1,
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

    group('monotone constraint behavior', () {
      test('SmoothMonotone.x prevents Y-direction overshoot with zigzag data',
          () {
        final points = [
          const Offset(0, 15),
          const Offset(10, -50),
          const Offset(20, -56.5),
          const Offset(30, -46.5),
          const Offset(40, -22.1),
          const Offset(50, -2.5),
        ];

        const curve = LineChartCubicMonotoneCurve(
          monotone: SmoothMonotone.x,
          smooth: 0.3,
          tinyThresholdSquared: 0,
        );

        final path = _buildPathWithCurve(points, curve);
        final samples = _samplePath(path, 100);

        // Verify that Y coordinates of each curve segment stay within
        // the Y range of its two endpoints
        for (var i = 0; i < points.length - 1; i++) {
          final minY =
              points[i].dy < points[i + 1].dy ? points[i].dy : points[i + 1].dy;
          final maxY =
              points[i].dy > points[i + 1].dy ? points[i].dy : points[i + 1].dy;

          final segmentSamples = samples
              .where((s) => s.dx >= points[i].dx && s.dx <= points[i + 1].dx);

          for (final sample in segmentSamples) {
            expect(
              sample.dy,
              inRange(minY - 1.0, maxY + 1.0),
              reason: 'Segment $i: Y=${sample.dy} out of range [$minY, $maxY]',
            );
          }
        }
      });

      test(
          'SmoothMonotone.y prevents X-direction overshoot with horizontal zigzag',
          () {
        final points = [
          const Offset(50, 0),
          const Offset(10, 10),
          const Offset(90, 20),
          const Offset(20, 30),
          const Offset(80, 40),
        ];

        const curve = LineChartCubicMonotoneCurve(
          monotone: SmoothMonotone.y,
          smooth: 0.3,
          tinyThresholdSquared: 0,
        );

        final path = _buildPathWithCurve(points, curve);
        final samples = _samplePath(path, 100);

        // Verify that X coordinates of each curve segment stay within
        // the X range of its two endpoints
        for (var i = 0; i < points.length - 1; i++) {
          final minX =
              points[i].dx < points[i + 1].dx ? points[i].dx : points[i + 1].dx;
          final maxX =
              points[i].dx > points[i + 1].dx ? points[i].dx : points[i + 1].dx;

          final segmentSamples = samples
              .where((s) => s.dy >= points[i].dy && s.dy <= points[i + 1].dy);

          for (final sample in segmentSamples) {
            expect(
              sample.dx,
              inRange(minX - 1.0, maxX + 1.0),
              reason: 'Segment $i: X=${sample.dx} out of range [$minX, $maxX]',
            );
          }
        }
      });
    });
  });
}

/// Sample points uniformly along the path
List<Offset> _samplePath(Path path, int sampleCount) {
  final samples = <Offset>[];
  final metrics = path.computeMetrics().first;

  for (var i = 0; i <= sampleCount; i++) {
    final distance = metrics.length * i / sampleCount;
    final tangent = metrics.getTangentForOffset(distance);
    if (tangent != null) {
      samples.add(tangent.position);
    }
  }

  return samples;
}

/// Custom range matcher
Matcher inRange(num min, num max) => _InRangeMatcher(min, max);

class _InRangeMatcher extends Matcher {
  const _InRangeMatcher(this.min, this.max);

  final num min;
  final num max;

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is! num) return false;
    return item >= min && item <= max;
  }

  @override
  Description describe(Description description) {
    return description.add('in range [$min, $max]');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    return mismatchDescription.add('was $item, outside range [$min, $max]');
  }
}

void expectLikeStraightLine(
  LineChartCurve curve, {
  List<Offset> points = testPoints1,
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
