import 'package:fl_chart/src/extensions/gradient_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GradientExtension.getSafeColorStops', () {
    group('returns linearly calculated stops', () {
      test('when no stops are provided', () {
        expect(
          const _TestGradient(
            colors: [Colors.red, Colors.blue],
          ).getSafeColorStops(),
          [0, 1],
        );

        expect(
          const _TestGradient(
            colors: [Colors.red, Colors.blue, Colors.green],
          ).getSafeColorStops(),
          [0, 0.5, 1],
        );
      });

      test('when less stops than colors are provided', () {
        expect(
          const _TestGradient(
            colors: [Colors.red, Colors.blue, Colors.green],
            stops: [0.2, 0.8],
          ).getSafeColorStops(),
          [0, 0.5, 1],
        );
      });

      test('when more stops than colors are provided', () {
        expect(
          const _TestGradient(
            colors: [Colors.red, Colors.blue],
            stops: [0.2, 0.8, 0.9],
          ).getSafeColorStops(),
          [0, 1],
        );
      });
    });

    test('returns stops when same length as colors', () {
      expect(
        const _TestGradient(
          colors: [Colors.red, Colors.blue],
          stops: [0.1, 0.8],
        ).getSafeColorStops(),
        [0.1, 0.8],
      );
    });

    group('throws ArgumentError', () {
      group('when colors is empty', () {
        test('without stops', () {
          expect(
            () => const _TestGradient(colors: []).getSafeColorStops(),
            throwsArgumentError,
          );
        });

        test('with stops', () {
          expect(
            () => const _TestGradient(
              colors: [],
              stops: [0.1, 0.8],
            ).getSafeColorStops(),
            throwsArgumentError,
          );
        });
      });

      group('when colors length is 1', () {
        test('without stops', () {
          expect(
            () => const _TestGradient(
              colors: [Colors.red],
            ).getSafeColorStops(),
            throwsArgumentError,
          );
        });

        test('with stops', () {
          expect(
            () => const _TestGradient(
              colors: [Colors.red],
              stops: [0.1, 0.8],
            ).getSafeColorStops(),
            throwsArgumentError,
          );
        });
      });
    });
  });
}

class _TestGradient extends Gradient {
  const _TestGradient({required super.colors, super.stops});

  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) =>
      throw UnimplementedError();

  @override
  Gradient scale(double t) => throw UnimplementedError();

  @override
  Gradient withOpacity(double opacity) => throw UnimplementedError();
}
