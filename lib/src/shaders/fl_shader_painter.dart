import 'package:fl_chart/src/shaders/fl_shader.dart';
import 'package:flutter/material.dart';

/// {@template fl_shader_painter}
/// An abstract [CustomPainter] that uses a [FlShader] to render custom graphics.
///
/// [FlShaderPainter] provides a base for painters that utilize fragment shaders
/// for efficient and flexible rendering. Subclasses should implement the [paint]
/// method to define how the shader is applied to the canvas.
///
/// The [flShader] property holds the shader instance to be used for painting.
/// {@endtemplate}
abstract class FlShaderPainter extends CustomPainter {
  FlShaderPainter({required this.flShader});

  /// {@macro fl_shader}
  final FlShader flShader;
}
