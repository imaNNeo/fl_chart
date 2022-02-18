import 'dart:ui';

import 'package:fl_chart/src/extensions/rrect_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';

void main() {
  test('test getRect', () {
    expect(
      MockData.rRect1.getRect(),
      const Rect.fromLTRB(1, 1, 1, 1),
    );
  });
}
