// dart
import 'package:fl_chart/src/shaders/fl_shader.dart';
import 'package:fl_chart/src/shaders/square_pois_shader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SquarePoisShader', () {
    test('can be instantiated', () {
      final shader = SquarePoisShader();
      expect(shader, isNotNull);
    });

    test('has correct path', () {
      final shader = SquarePoisShader();
      expect(shader.path, 'packages/fl_chart/shaders/square_pois_pattern.frag');
    });

    test('is a subclass of FlShader', () {
      final shader = SquarePoisShader();
      expect(shader, isA<FlShader>());
    });

    test('is not initialized before calling init()', () {
      final shader = SquarePoisShader();
      expect(shader.isInitialized, isFalse);
    });

    test('throws StateError when accessing shader before init', () {
      final shader = SquarePoisShader();
      expect(() => shader.shader, throwsStateError);
    });

    test('throws StateError when calling setFloat before init', () {
      final shader = SquarePoisShader();
      expect(() => shader.setFloat(0, 1), throwsStateError);
    });
  });
}
