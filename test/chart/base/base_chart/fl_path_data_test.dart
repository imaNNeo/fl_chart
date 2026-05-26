import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlPathData', () {
    group('equality', () {
      test('two FlPathData with same values are equal', () {
        const pathData1 = FlPathData(
          strokeCap: StrokeCap.round,
          strokeJoin: StrokeJoin.round,
          strokeMiterLimit: 5,
          dashArray: [5, 10],
        );
        const pathData2 = FlPathData(
          strokeCap: StrokeCap.round,
          strokeJoin: StrokeJoin.round,
          strokeMiterLimit: 5,
          dashArray: [5, 10],
        );
        expect(pathData1, equals(pathData2));
      });

      test('copyWith without parameters returns equal object', () {
        const original = FlPathData(
          strokeCap: StrokeCap.round,
          strokeJoin: StrokeJoin.bevel,
          strokeMiterLimit: 6,
          dashArray: [5, 10],
        );
        final copy = original.copyWith();
        expect(copy, equals(original));
      });

      test('copyWith changes all properties', () {
        const original = FlPathData();
        final copy = original.copyWith(
          strokeCap: StrokeCap.square,
          strokeJoin: StrokeJoin.bevel,
          strokeMiterLimit: 10,
          dashArray: [3, 6, 9],
        );
        expect(copy.strokeCap, equals(StrokeCap.square));
        expect(copy.strokeJoin, equals(StrokeJoin.bevel));
        expect(copy.strokeMiterLimit, equals(10));
        expect(copy.dashArray, equals([3, 6, 9]));
      });
    });

    group('lerp', () {
      const pathDataA = FlPathData(
        strokeCap: StrokeCap.square,
        strokeJoin: StrokeJoin.bevel,
        strokeMiterLimit: 2,
        dashArray: [10, 20],
      );
      const pathDataB = FlPathData(
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
        strokeMiterLimit: 8,
        dashArray: [20, 40],
      );

      test('lerp returns null when both are null', () {
        final result = FlPathData.lerp(null, null, 0.5);
        expect(result, isNull);
      });

      test('lerp returns a when b is null', () {
        const pathDataA = FlPathData(
          strokeCap: StrokeCap.round,
          strokeMiterLimit: 5,
        );
        final result = FlPathData.lerp(pathDataA, null, 0.5);
        expect(result, equals(pathDataA));
      });

      test('lerp returns b when a is null', () {
        const pathDataB = FlPathData(
          strokeCap: StrokeCap.square,
          strokeMiterLimit: 8,
        );
        final result = FlPathData.lerp(null, pathDataB, 0.5);
        expect(result, equals(pathDataB));
      });

      test('lerp at t=0 returns values closer to a', () {
        final result = FlPathData.lerp(pathDataA, pathDataB, 0)!;
        expect(result.strokeMiterLimit, equals(2));
        expect(result.dashArray, equals([10, 20]));
      });

      test('lerp at t=1 returns values closer to b', () {
        final result = FlPathData.lerp(pathDataA, pathDataB, 1)!;
        expect(result.strokeMiterLimit, equals(8));
        expect(result.dashArray, equals([20, 40]));
        expect(result.strokeCap, equals(StrokeCap.round));
        expect(result.strokeJoin, equals(StrokeJoin.round));
      });
    });
  });
}
