import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_curve.dart';
import 'package:flutter_test/flutter_test.dart';

void expectLikeStraightLine(LineChartCurve curve,
    {Offset point0 = Offset.zero, Offset point1 = const Offset(10, 10)}) {
  final path = Path()..moveTo(point0.dx, point0.dy);
  curve.appendToPath(path, point0, point1, null);

  final metrics = path.computeMetrics().toList();
  expect(metrics.length, 1);
  expect(metrics.single.length, closeTo(point1.distanceTo(point0), 0.001));
}

void main() {
  group('LineChartNoCurve', () {
    test('appendToPath draws straight line', () {
      expectLikeStraightLine(const LineChartNoCurve());
    });

    test('equality check', () {
      const a = LineChartNoCurve();
      const b = LineChartNoCurve();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('LineChartCubicTensionCurve', () {
    test('CubicTensionCurve with smoothness = 0 behaves like straight line',
        () {
      expectLikeStraightLine(LineChartCurve.cubicTension(smoothness: 0));
    });

    test('equality check', () {
      final a = LineChartCurve.cubicTension();
      final b = LineChartCurve.cubicTension();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('LineChartCubicMonotoneCurve', () {
    test('CubicMonotoneCurve with smooth = 0 behaves like straight line', () {
      expectLikeStraightLine(LineChartCurve.cubicMonotone(smooth: 0));
    });

    test('equality check', () {
      final a = LineChartCurve.cubicMonotone();
      final b = LineChartCurve.cubicMonotone();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}

extension on Offset {
  double distanceTo(Offset other) => (this - other).distance;
}
