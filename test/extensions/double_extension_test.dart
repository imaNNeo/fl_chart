import 'package:fl_chart/src/extensions/double_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test double.precision', () {
    expect(0.0.precisionCount, 0);
    expect(0.1.precisionCount, 1);
    expect(0.02.precisionCount, 2);
    expect(3.000.precisionCount, 0);
    expect(3.001.precisionCount, 3);
    expect(0.23232323.precisionCount, 8);
    expect(0.493234898.precisionCount, 9);
    expect(0.4932348985.precisionCount, 10);
    expect(0.0000000005.precisionCount, 10);
    expect(0.0000000000005.precisionCount, 13);
    expect(0.0000000000000005.precisionCount, 16);
    expect(0.00000000000000000005.precisionCount, 20);
    expect(0.4343828875389984.precisionCount, 16);
    expect(0.0000000005389984.precisionCount, 16);
  });
}
