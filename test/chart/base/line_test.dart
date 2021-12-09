import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import '../data_pool.dart';

void main() {
  const tolerance = 0.001;

  test('test magnitude()', () {
    expect(line1.magnitude(), closeTo(14.142, tolerance));
    expect(line2.magnitude(), closeTo(22.360, tolerance));
    expect(line3.magnitude(), closeTo(18.027, tolerance));
    expect(line4.magnitude(), closeTo(32.310, tolerance));
    expect(line5.magnitude(), closeTo(5.830, tolerance));
  });

  test('test angle()', () {
    expect(line1.direction(), closeTo(Utils().radians(45), tolerance));
    expect(line2.direction(), closeTo(Utils().radians(63.434), tolerance));
    expect(line3.direction(), closeTo(Utils().radians(-3.179), tolerance));
    expect(line4.direction(), closeTo(Utils().radians(68.198), tolerance));
    expect(line5.direction(), closeTo(Utils().radians(59), tolerance));
  });

  test('test normalize()', () {
    expect(line1.normalize().dx, closeTo(0.707, tolerance));
    expect(line1.normalize().dy, closeTo(0.707, tolerance));

    expect(line2.normalize().dx, closeTo(0.447, tolerance));
    expect(line2.normalize().dy, closeTo(0.894, tolerance));

    expect(line3.normalize().dx, closeTo(-0.998, tolerance));
    expect(line3.normalize().dy, closeTo(0.0554, tolerance));

    expect(line4.normalize().dx, closeTo(-0.371, tolerance));
    expect(line4.normalize().dy, closeTo(-0.928, tolerance));

    expect(line5.normalize().dx, closeTo(0.514, tolerance));
    expect(line5.normalize().dy, closeTo(0.857, tolerance));
  });
}
