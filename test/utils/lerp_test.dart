import 'dart:ui';

import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test lerpList', () {
    List<double> list1 = [1.0, 1.0, 2.0];
    List<double> list2 = [1.0, 2.0, 3.0, 5.0];
    expect(lerpList(list1, list2, 0.0, lerp: lerpDouble), [1.0, 1.0, 2.0, 5.0]);
    expect(lerpList(list1, list2, 0.5, lerp: lerpDouble), [1.0, 1.5, 2.5, 5.0]);
  });
}
