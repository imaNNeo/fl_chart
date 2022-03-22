import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';

void main() {
  test('test transparentIfWidthIsZero', () {
    Paint paint = Paint();
    paint.color = MockData.color0;
    paint.strokeWidth = 4;
    paint.transparentIfWidthIsZero();
    expect(paint.strokeWidth, 4);
    expect(MockData.color0, paint.color);

    paint.strokeWidth = 0.5;
    paint.transparentIfWidthIsZero();
    expect(paint.strokeWidth, 0.5);
    expect(MockData.color0, paint.color);

    paint.strokeWidth = 0.0;
    paint.transparentIfWidthIsZero();
    expect(paint.strokeWidth, 0.0);
    expect(MockData.color0.withOpacity(0), paint.color);
  });

  test('test setColorOrGradient', () {
    Paint paint = Paint();
    paint.color = MockData.color0;
    paint.setColorOrGradient(null, MockData.gradient1, MockData.rect1);
    expect(paint.shader, isNotNull);

    paint.setColorOrGradient(MockData.color0, null, MockData.rect1);
    expect(paint.color, MockData.color0);
    expect(paint.shader, isNull);
  });
}
