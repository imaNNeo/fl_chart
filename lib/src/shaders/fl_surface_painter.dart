import 'package:fl_chart/src/shaders/fl_shader.dart';
import 'package:flutter/material.dart';

/// {@template fl_shader_painter}
/// An abstract [CustomPainter] that uses a [FlShader] to render custom graphics.
///
/// [FlSurfacePainter] provides a base for painters that utilize fragment shaders
/// for efficient and flexible rendering. Subclasses should implement the [paint]
/// method to define how the shader is applied to the canvas.
///
/// The [flShader] property holds the shader instance to be used for painting.
/// {@endtemplate}
abstract class FlSurfacePainter extends CustomPainter {
  FlSurfacePainter({required this.flShader});

  /// {@macro fl_shader}
  final FlShader flShader;

  /// Initializes the painter by setting up the shader.
  Future<void> initialize() async {
    await flShader.init();
  }

  /// Returns whether the shader is initialized.
  bool get isInitialized => flShader.isInitialized;
}
