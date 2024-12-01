import 'package:fl_chart/src/utils/chart_transformation_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  late Matrix3 matrix1;

  setUp(() {
    matrix1 = Matrix3.identity();
  });

  group('FlMatrix3', () {
    group('scaleX', () {
      test('returns correct value', () {
        matrix1.setEntry(0, 0, 3);
        expect(matrix1.scaleX, 3);
      });

      test('sets correct value', () {
        matrix1.scaleX = 3;
        expect(matrix1.scaleX, 3);
        expect(matrix1.scaleY, 1);
      });
    });

    group('scaleY', () {
      test('returns correct value', () {
        matrix1.setEntry(1, 1, 4);
        expect(matrix1.scaleY, 4);
      });

      test('sets correct value', () {
        matrix1.scaleY = 4;
        expect(matrix1.scaleX, 1);
        expect(matrix1.scaleY, 4);
      });
    });

    group('translationX', () {
      test('returns correct value', () {
        matrix1.setEntry(0, 2, 8);
        expect(matrix1.translationX, 8);
      });

      test('sets correct value', () {
        matrix1.translationX = 8;
        expect(matrix1.translationX, 8);
        expect(matrix1.translationY, 0);
      });
    });

    group('translationY', () {
      test('returns correct value', () {
        matrix1.setEntry(1, 2, 5);
        expect(matrix1.translationY, 5);
      });

      test('sets correct value', () {
        matrix1.translationY = 5;
        expect(matrix1.translationX, 0);
        expect(matrix1.translationY, 5);
      });
    });

    group('setTranslation', () {
      test('sets translation in x and y directions', () {
        matrix1.setTranslation(x: 15, y: 10);
        expect(matrix1.translationX, 15);
        expect(matrix1.translationY, 10);
      });

      test('sets translation in x direction', () {
        matrix1.setTranslation(x: 15);
        expect(matrix1.translationX, 15);
        expect(matrix1.translationY, 0);
      });

      test('sets translation in y direction', () {
        matrix1.setTranslation(y: 10);
        expect(matrix1.translationX, 0);
        expect(matrix1.translationY, 10);
      });
    });

    group('translate', () {
      test('translates in x and y directions', () {
        matrix1
          ..setTranslation(x: 1, y: 1)
          ..translate(x: 15, y: 10);
        expect(matrix1.translationX, 16);
        expect(matrix1.translationY, 11);
      });

      test('translates only in x direction', () {
        matrix1
          ..setTranslation(x: 1, y: 1)
          ..translate(x: 15);
        expect(matrix1.translationX, 16);
        expect(matrix1.translationY, 1);
      });

      test('translates only in y direction', () {
        matrix1
          ..setTranslation(x: 1, y: 1)
          ..translate(y: 10);
        expect(matrix1.translationX, 1);
        expect(matrix1.translationY, 11);
      });
    });

    group('clamp', () {
      test('clamps scaleX', () {
        matrix1
          ..scaleX = 15
          ..clamp(minScale: 0, maxScale: 10);
        expect(matrix1.scaleX, 10);

        matrix1
          ..scaleX = -1
          ..clamp(minScale: 0, maxScale: 10);
        expect(matrix1.scaleX, 0);
      });

      test('clamps scaleY', () {
        matrix1
          ..scaleY = 15
          ..clamp(minScale: 0, maxScale: 10);
        expect(matrix1.scaleY, 10);

        matrix1
          ..scaleY = -1
          ..clamp(minScale: 0, maxScale: 10);
        expect(matrix1.scaleY, 0);
      });

      test('clamps translationX', () {
        matrix1
          ..translationX = 15
          ..clamp(minX: 0, maxX: 10);
        expect(matrix1.translationX, 10);

        matrix1
          ..translationX = -1
          ..clamp(minX: 0, maxX: 10);
        expect(matrix1.translationX, 0);
      });

      test('clamps translationY', () {
        matrix1
          ..translationY = 15
          ..clamp(minY: 0, maxY: 10);
        expect(matrix1.translationY, 10);

        matrix1
          ..translationY = -1
          ..clamp(minY: 0, maxY: 10);
        expect(matrix1.translationY, 0);
      });
    });
  });
}
