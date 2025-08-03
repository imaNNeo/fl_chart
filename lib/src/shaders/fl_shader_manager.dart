import 'package:fl_chart/fl_chart.dart';

/// {@template fl_shader_manager}
/// A singleton class that manages and initializes all built-in [FlShader] instances used in FL Chart.
///
/// [FlShaderManager] provides access to shared shader instances for stripes, circle polka dots, and square polka dots.
/// Call [init] before using any shader to ensure all shaders are loaded and ready for use.
///
/// Access the shaders via the [stripesShader], [circlePoisShader], and [squarePoisShader] getters.
/// If a shader is accessed before initialization, a [StateError] is thrown.
///
/// ### Example:
/// ```dart
/// await FlShaderManager().init();
/// final stripesShader = FlShaderManager().stripesShader;
/// ```
/// {@endtemplate}
class FlShaderManager {
  factory FlShaderManager() => _instance;

  FlShaderManager._();

  static final FlShaderManager _instance = FlShaderManager._();

  final StripesShader _stripesShader = StripesShader();
  final CirclePoisShader _circlePoisShader = CirclePoisShader();
  final SquarePoisShader _squarePoisShader = SquarePoisShader();

  Future<void> init() async {
    await _stripesShader.init();
    await _circlePoisShader.init();
    await _squarePoisShader.init();
  }

  StripesShader get stripesShader => _stripesShader.isInitialized
      ? _stripesShader
      : throw StateError('StripesShader not initialized');

  CirclePoisShader get circlePoisShader => _circlePoisShader.isInitialized
      ? _circlePoisShader
      : throw StateError('CirclePoisShader not initialized');

  SquarePoisShader get squarePoisShader => _squarePoisShader.isInitialized
      ? _squarePoisShader
      : throw StateError('SquarePoisShader not initialized');
}
