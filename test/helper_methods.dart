import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test equalsPaths', () {
    Path path1 = Path()
      ..moveTo(10, 10)
      ..lineTo(20, 20)
      ..arcTo(
          Rect.fromCenter(center: const Offset(5, 5), width: 40, height: 40),
          2,
          4,
          false);

    Path path1Duplicate = Path()
      ..moveTo(10, 10)
      ..lineTo(20, 20)
      ..arcTo(
          Rect.fromCenter(center: const Offset(5, 5), width: 40, height: 40),
          2,
          4,
          false);

    Path path2 = Path()
      ..moveTo(10, 10)
      ..lineTo(20, 20)
      ..arcTo(
          Rect.fromCenter(center: const Offset(5, 5), width: 40, height: 40),
          2.1,
          4,
          false);

    expect(HelperMethods.equalsPaths(path1, path1Duplicate), true);
    expect(HelperMethods.equalsPaths(path1, path2), false);
  });
}

class HelperMethods {
  static bool equalsPaths(Path path1, Path path2) {
    final metrics1 = path1.computeMetrics().toList();
    final metrics2 = path2.computeMetrics().toList();
    if (metrics1.length != metrics2.length) {
      return false;
    }
    for (int i = 0; i < metrics1.length; i++) {
      if (metrics1[i].length != metrics2[i].length) {
        return false;
      }
      if (metrics1[i].isClosed != metrics2[i].isClosed) {
        return false;
      }
      if (metrics1[i].contourIndex != metrics2[i].contourIndex) {
        return false;
      }
      final half = metrics1[i].length / 2;
      final tangent1 = metrics1[i].getTangentForOffset(half);
      final tangent2 = metrics2[i].getTangentForOffset(half);
      if (tangent1!.position != tangent2!.position) {
        return false;
      }
      if (tangent1.angle != tangent2.angle) {
        return false;
      }
      if (tangent1.vector != tangent2.vector) {
        return false;
      }
    }
    return true;
  }
}
