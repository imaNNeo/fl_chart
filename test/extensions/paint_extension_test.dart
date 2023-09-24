import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';

void main() {
  test('test transparentIfWidthIsZero', () {
    final paint = Paint()
      ..color = MockData.color0
      ..strokeWidth = 4
      ..transparentIfWidthIsZero();
    expect(paint.strokeWidth, 4);
    expect(MockData.color0, paint.color);

    paint
      ..strokeWidth = 0.5
      ..transparentIfWidthIsZero();
    expect(paint.strokeWidth, 0.5);
    expect(MockData.color0, paint.color);

    paint
      ..strokeWidth = 0.0
      ..transparentIfWidthIsZero();
    expect(paint.strokeWidth, 0.0);
    expect(MockData.color0.withOpacity(0), paint.color);
  });

  test('test setColorOrGradient', () {
    final paint = Paint()
      ..color = MockData.color0
      ..setColorOrGradient(null, MockData.gradient1, MockData.rect1);
    expect(paint.shader, isNotNull);

    paint.setColorOrGradient(MockData.color0, null, MockData.rect1);
    expect(paint.color, MockData.color0);
    expect(paint.shader, isNull);
  });

  test('test setColorOrGradientForLine', () {
    final paint = Paint()
      ..color = MockData.color0
      ..setColorOrGradientForLine(
        null,
        MockData.gradient1,
        from: MockData.rect1.topLeft,
        to: MockData.rect1.bottomRight,
      );
    expect(paint.shader, isNotNull);

    paint.setColorOrGradient(MockData.color0, null, MockData.rect1);
    expect(paint.color, MockData.color0);
    expect(paint.shader, isNull);
  });
}
