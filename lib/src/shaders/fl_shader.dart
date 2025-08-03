import 'dart:ui';

/// {@template fl_shader}
/// An abstract base class for loading and managing fragment shaders.
///
/// [FlShader] provides a common interface for loading a fragment shader from an asset path,
/// initializing it asynchronously, and exposing the resulting [FragmentShader] instance.
///
/// Subclasses should specify the [path] to the shader asset and can use the [shader]
/// property after calling [init()]. The [isInitialized] flag indicates whether the shader
/// has been successfully loaded and is ready for use.
///
/// ### Example:
/// ```dart
/// class MyCustomShader extends FlShader {
///   MyCustomShader() : super(path: 'assets/shaders/my_shader.frag');
/// }
/// ```
/// {@endtemplate}
abstract class FlShader {
  FlShader({required this.path});

  /// The path to the shader asset.
  final String path;

  /// The [FragmentShader] instance created from the shader asset.
  late FragmentShader _shader;

  /// Indicates whether the shader has been initialized
  bool isInitialized = false;

  /// Initializes the shader by loading it from the specified asset path.
  ///
  /// This method should be called before using the [shader] property
  /// to ensure that the shader is properly loaded and ready for use.
  Future<void> init() async {
    final program = await FragmentProgram.fromAsset(path);
    _shader = program.fragmentShader();

    isInitialized = true;
  }

  /// Gets the fragment shader.
  FragmentShader get shader =>
      isInitialized ? _shader : throw StateError('Shader not initialized');

  /// Sets a float value in the shader.
  void setFloat(int index, double value) {
    if (!isInitialized) {
      throw StateError('Shader not initialized');
    }

    _shader.setFloat(index, value);
  }
}
