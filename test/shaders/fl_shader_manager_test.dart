// dart
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/shaders/fl_shader_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_shaders.dart';

void main() {
  group('FlShaderManager', () {
    late FlShaderManager manager;

    setUp(() {
      manager = FlShaderManager()
        // Inject fake shaders for testing
        ..stripesShader = FakeStripesShader()
        ..circlePoisShader = FakeCirclePoisShader()
        ..squarePoisShader = FakeSquarePoisShader();
    });

    test('is a singleton', () {
      final a = FlShaderManager();
      final b = FlShaderManager();
      expect(identical(a, b), isTrue);
    });

    test('throws StateError if shaders accessed before init', () {
      expect(() => manager.stripesShader, throwsA(isA<StateError>()));
      expect(() => manager.circlePoisShader, throwsA(isA<StateError>()));
      expect(() => manager.squarePoisShader, throwsA(isA<StateError>()));
    });

    test('init initializes all shaders', () async {
      await manager.init();
      expect(manager.stripesShader.isInitialized, isTrue);
      expect(manager.circlePoisShader.isInitialized, isTrue);
      expect(manager.squarePoisShader.isInitialized, isTrue);
    });

    test('returns same shader instances', () async {
      await manager.init();
      final stripes1 = manager.stripesShader;
      final stripes2 = manager.stripesShader;
      expect(identical(stripes1, stripes2), isTrue);

      final circle1 = manager.circlePoisShader;
      final circle2 = manager.circlePoisShader;
      expect(identical(circle1, circle2), isTrue);

      final square1 = manager.squarePoisShader;
      final square2 = manager.squarePoisShader;
      expect(identical(square1, square2), isTrue);
    });
  });
}
