import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tolerance = 0.001;

  test('test degrees to radians', () {
    expect(radians(57.2958), closeTo(1, tolerance));
    expect(radians(120), closeTo(2.0944, tolerance));
    expect(radians(324), closeTo(5.65487, tolerance));
    expect(radians(180), closeTo(3.1415, tolerance));
  });

  test('test radians to degree', () {
    expect(degrees(1.5), closeTo(85.9437, tolerance));
    expect(degrees(1.8), closeTo(103.132, tolerance));
    expect(degrees(1.2), closeTo(68.7549, tolerance));
  });

  test('test default size', () {
    expect(getDefaultSize(const Size(1080, 1920)).width, closeTo(756, tolerance));
    expect(getDefaultSize(const Size(1080, 1920)).height, closeTo(756, tolerance));

    expect(getDefaultSize(const Size(728, 1080)).width, closeTo(509.6, tolerance));
    expect(getDefaultSize(const Size(728, 1080)).height, closeTo(509.6, tolerance));

    expect(getDefaultSize(const Size(2560, 1600)).width, closeTo(1120, tolerance));
    expect(getDefaultSize(const Size(2560, 1600)).height, closeTo(1120, tolerance));

    expect(getDefaultSize(const Size(1000, 1000)).width, closeTo(700, tolerance));
  });

  test('translate rotated position', () {
    expect(translateRotatedPosition(100, 90), 25);
    expect(translateRotatedPosition(100, 0), 0);
  });

  test('lerp gradient', () {
    expect(
        lerpGradient([
          Colors.red,
          Colors.green,
        ], [], 0.0),
        Colors.red);

    expect(
        lerpGradient([
          Colors.red,
          Colors.green,
        ], [], 1.0),
        Colors.green);
  });

  test('test getEfficientInterval', () {
    expect(getEfficientInterval(472, 340), 5);
    expect(getEfficientInterval(820, 10000), 100);
    expect(getEfficientInterval(1024, 412345234), 5000000);
    expect(getEfficientInterval(720, 812394712349), 10000000000);
  });

  test('test formatNumber', () {
    expect(formatNumber(0), '0');
    expect(formatNumber(423), '423');
    expect(formatNumber(-423), '-423');
    expect(formatNumber(1000), '1K');
    expect(formatNumber(1234), '1.2K');
    expect(formatNumber(10000), '10K');
    expect(formatNumber(41234), '41.2K');
    expect(formatNumber(82349), '82.3K');
    expect(formatNumber(82350), '82.3K');
    expect(formatNumber(82351), '82.4K');
    expect(formatNumber(-82351), '-82.4K');
    expect(formatNumber(100000), '100K');
    expect(formatNumber(101000), '101K');
    expect(formatNumber(2345123), '2.3M');
    expect(formatNumber(2352123), '2.4M');
    expect(formatNumber(-2352123), '-2.4M');
    expect(formatNumber(521000000), '521M');
    expect(formatNumber(4324512345), '4.3B');
    expect(formatNumber(4000000000), '4B');
    expect(formatNumber(-4000000000), '-4B');
    expect(formatNumber(823147521343), '823.1B');
    expect(formatNumber(8231475213435), '8231.5B');
    expect(formatNumber(-8231475213435), '-8231.5B');
  });
}
