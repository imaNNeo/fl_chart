import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeStripesShader extends Fake implements StripesShader {
  late FragmentShader _shader;
  @override
  bool isInitialized = false;

  @override
  Future<void> init() async {
    final program =
        await FragmentProgram.fromAsset('shaders/striped_pattern.frag');
    _shader = program.fragmentShader();

    isInitialized = true;
  }

  @override
  FragmentShader get shader =>
      isInitialized ? _shader : throw StateError('Shader not initialized');

  @override
  void setFloat(int index, double value) {
    if (!isInitialized) {
      throw StateError('Shader not initialized');
    }

    _shader.setFloat(index, value);
  }
}

class FakeCirclePoisShader extends Fake implements CirclePoisShader {
  late FragmentShader _shader;
  @override
  bool isInitialized = false;

  @override
  Future<void> init() async {
    final program =
        await FragmentProgram.fromAsset('shaders/circle_pois_pattern.frag');
    _shader = program.fragmentShader();

    isInitialized = true;
  }

  @override
  FragmentShader get shader =>
      isInitialized ? _shader : throw StateError('Shader not initialized');

  @override
  void setFloat(int index, double value) {
    if (!isInitialized) {
      throw StateError('Shader not initialized');
    }

    _shader.setFloat(index, value);
  }
}

class FakeSquarePoisShader extends Fake implements SquarePoisShader {
  late FragmentShader _shader;
  @override
  bool isInitialized = false;

  @override
  Future<void> init() async {
    final program =
        await FragmentProgram.fromAsset('shaders/square_pois_pattern.frag');
    _shader = program.fragmentShader();

    isInitialized = true;
  }

  @override
  FragmentShader get shader =>
      isInitialized ? _shader : throw StateError('Shader not initialized');

  @override
  void setFloat(int index, double value) {
    if (!isInitialized) {
      throw StateError('Shader not initialized');
    }

    _shader.setFloat(index, value);
  }
}
