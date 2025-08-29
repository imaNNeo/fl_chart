// dart
import 'package:fl_chart/src/shaders/circle_pois_shader.dart';
import 'package:fl_chart/src/shaders/fl_shader.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFlShader extends FlShader {
  FakeFlShader() : super(path: 'fake_path');
  @override
  Future<void> init() async {}
}

void main() {
  group('CirclePoisShader', () {
    test('should be instantiated without errors', () {
      final shader = CirclePoisShader();
      expect(shader, isNotNull);
    });

    test('should have correct path', () {
      final shader = CirclePoisShader();
      expect(shader.path, 'packages/fl_chart/shaders/circle_pois_pattern.frag');
    });

    test('should be a subclass of FlShader', () {
      final shader = CirclePoisShader();
      expect(shader, isA<FlShader>());
    });

    test('should not be initialized before calling init()', () {
      final shader = CirclePoisShader();
      expect(shader.isInitialized, isFalse);
    });

    test('should throw StateError when accessing shader before init', () {
      final shader = CirclePoisShader();
      expect(() => shader.shader, throwsStateError);
    });

    test('should throw StateError when calling setFloat before init', () {
      final shader = CirclePoisShader();
      expect(() => shader.setFloat(0, 1), throwsStateError);
    });
  });
}
