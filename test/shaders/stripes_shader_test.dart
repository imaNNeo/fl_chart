// dart
import 'package:fl_chart/src/shaders/fl_shader.dart';
import 'package:fl_chart/src/shaders/stripes_shader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StripesShader', () {
    test('can be instantiated', () {
      final shader = StripesShader();
      expect(shader, isNotNull);
    });

    test('has correct path', () {
      final shader = StripesShader();
      expect(shader.path, 'packages/fl_chart/shaders/striped_pattern.frag');
    });

    test('is a subclass of FlShader', () {
      final shader = StripesShader();
      expect(shader, isA<FlShader>());
    });

    test('is not initialized before calling init()', () {
      final shader = StripesShader();
      expect(shader.isInitialized, isFalse);
    });

    test('throws StateError when accessing shader before init', () {
      final shader = StripesShader();
      expect(() => shader.shader, throwsStateError);
    });

    test('throws StateError when calling setFloat before init', () {
      final shader = StripesShader();
      expect(() => shader.setFloat(0, 1), throwsStateError);
    });
  });
}
