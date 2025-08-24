// dart
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';

// Testable FlShader subclass
class TestFlShader extends FlShader {
  TestFlShader({required super.path});
}

void main() {
  group('FlShader', () {
    late TestFlShader testShader;

    setUp(() {
      testShader = TestFlShader(
        path: 'shaders/striped_pattern.frag',
      );
    });

    test('isInitialized is false before init', () {
      expect(testShader.isInitialized, isFalse);
    });

    test('init sets isInitialized to true and assigns shader', () async {
      await testShader.init();
      expect(testShader.isInitialized, isTrue);
      expect(testShader.shader, isA<ui.FragmentShader>());
    });

    test('shader getter throws before init', () {
      expect(() => testShader.shader, throwsA(isA<StateError>()));
    });

    test('setFloat throws before init', () {
      expect(() => testShader.setFloat(0, 1.0), throwsA(isA<StateError>()));
    });

    test('setFloat calls underlying shader after init', () async {
      await testShader.init();
      testShader.setFloat(2, 3.14);
    });
  });
}
