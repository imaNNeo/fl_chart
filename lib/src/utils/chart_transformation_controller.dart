import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';

/// Controller for the transformation matrix of the chart.
///
/// The Matrix3 can be used to transform the chart.
class ChartTransformationController extends ValueNotifier<Matrix3> {
  ChartTransformationController([Matrix3? value])
      : super(value ?? Matrix3.identity());
}

extension FlMatrix3 on Matrix3 {
  double get scaleX => entry(0, 0);
  double get scaleY => entry(1, 1);
  double get translationX => entry(0, 2);
  double get translationY => entry(1, 2);

  set scaleX(double scale) {
    setEntry(0, 0, scale);
  }

  set scaleY(double scale) {
    setEntry(1, 1, scale);
  }

  set scale(double scale) {
    scaleX = scale;
    scaleY = scale;
  }

  set translationX(double x) {
    setEntry(0, 2, x);
  }

  set translationY(double y) {
    setEntry(1, 2, y);
  }

  /// Translates the matrix by [x] and [y]
  void translate({double? x, double? y}) {
    setTranslation(
      x: translationX + (x ?? 0),
      y: translationY + (y ?? 0),
    );
  }

  /// Sets the translation components of the matrix
  void setTranslation({double? x, double? y}) {
    translationX = x ?? translationX;
    translationY = y ?? translationY;
  }

  void clamp({
    double? minScale,
    double? maxScale,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
  }) {
    scaleX = scaleX.clamp(
      minScale ?? double.negativeInfinity,
      maxScale ?? double.infinity,
    );
    scaleY = scaleY.clamp(
      minScale ?? double.negativeInfinity,
      maxScale ?? double.infinity,
    );
    translationX = translationX.clamp(
      minX ?? double.negativeInfinity,
      maxX ?? double.infinity,
    );
    translationY = translationY.clamp(
      minY ?? double.negativeInfinity,
      maxY ?? double.infinity,
    );
  }
}
