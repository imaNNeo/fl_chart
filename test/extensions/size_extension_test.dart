import 'dart:ui';

import 'package:fl_chart/src/extensions/size_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test rotateByQuarterTurns extension.', () {
    expect(const Size(100, 200).rotateByQuarterTurns(0), const Size(100, 200));
    expect(const Size(100, 200).rotateByQuarterTurns(1), const Size(200, 100));
    expect(const Size(100, 200).rotateByQuarterTurns(2), const Size(100, 200));
    expect(const Size(100, 200).rotateByQuarterTurns(3), const Size(200, 100));
    expect(const Size(100, 200).rotateByQuarterTurns(4), const Size(100, 200));
    expect(const Size(100, 200).rotateByQuarterTurns(5), const Size(200, 100));
    expect(const Size(100, 200).rotateByQuarterTurns(6), const Size(100, 200));
    expect(
      () => const Size(100, 200).rotateByQuarterTurns(-1),
      throwsArgumentError,
    );
    expect(
      () => const Size(100, 200).rotateByQuarterTurns(-3),
      throwsArgumentError,
    );
  });
}
