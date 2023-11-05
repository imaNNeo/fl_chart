import 'package:fl_chart/src/utils/lerp.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../chart/data_pool.dart';
import 'utils_test.mocks.dart';

@GenerateMocks([Utils, BuildContext])
void main() {
  const tolerance = 0.001;

  test('changeInstance', () {
    final Utils mockUtils = MockUtils();
    final realUtils = Utils();
    expect(Utils(), realUtils);
    Utils.changeInstance(mockUtils);
    expect(Utils(), mockUtils);
    expect(Utils() != realUtils, true);
    Utils.changeInstance(realUtils);
    expect(Utils(), realUtils);
    expect(Utils() != mockUtils, true);
  });

  test('test degrees to radians', () {
    expect(Utils().radians(57.2958), closeTo(1, tolerance));
    expect(Utils().radians(120), closeTo(2.0944, tolerance));
    expect(Utils().radians(324), closeTo(5.65487, tolerance));
    expect(Utils().radians(180), closeTo(3.1415, tolerance));
  });

  test('test radians to degree', () {
    expect(Utils().degrees(1.5), closeTo(85.9437, tolerance));
    expect(Utils().degrees(1.8), closeTo(103.132, tolerance));
    expect(Utils().degrees(1.2), closeTo(68.7549, tolerance));
  });

  test('test default size', () {
    expect(
      Utils().getDefaultSize(const Size(1080, 1920)).width,
      closeTo(756, tolerance),
    );
    expect(
      Utils().getDefaultSize(const Size(1080, 1920)).height,
      closeTo(756, tolerance),
    );

    expect(
      Utils().getDefaultSize(const Size(728, 1080)).width,
      closeTo(509.6, tolerance),
    );
    expect(
      Utils().getDefaultSize(const Size(728, 1080)).height,
      closeTo(509.6, tolerance),
    );

    expect(
      Utils().getDefaultSize(const Size(2560, 1600)).width,
      closeTo(1120, tolerance),
    );
    expect(
      Utils().getDefaultSize(const Size(2560, 1600)).height,
      closeTo(1120, tolerance),
    );

    expect(
      Utils().getDefaultSize(const Size(1000, 1000)).width,
      closeTo(700, tolerance),
    );
  });

  test('translate rotated position', () {
    expect(Utils().translateRotatedPosition(100, 90), 25);
    expect(Utils().translateRotatedPosition(100, 0), 0);
  });

  test('calculateRotationOffset()', () {
    expect(Utils().calculateRotationOffset(MockData.size1, 90), Offset.zero);
    expect(
      Utils().calculateRotationOffset(MockData.size1, 45).dx,
      closeTo(-2.278, tolerance),
    );
    expect(
      Utils().calculateRotationOffset(MockData.size1, 45).dy,
      closeTo(-2.278, tolerance),
    );

    expect(
      Utils().calculateRotationOffset(MockData.size1, 180).dx,
      closeTo(0.0, tolerance),
    );
    expect(
      Utils().calculateRotationOffset(MockData.size1, 180).dy,
      closeTo(0.0, tolerance),
    );

    expect(
      Utils().calculateRotationOffset(MockData.size1, 220).dx,
      closeTo(-2.2485, tolerance),
    );
    expect(
      Utils().calculateRotationOffset(MockData.size1, 220).dy,
      closeTo(-2.2485, tolerance),
    );

    expect(
      Utils().calculateRotationOffset(MockData.size1, 350).dx,
      closeTo(-0.87150, tolerance),
    );
    expect(
      Utils().calculateRotationOffset(MockData.size1, 350).dy,
      closeTo(-0.87150, tolerance),
    );
  });

  test('normalizeBorderRadius()', () {
    const input1 = BorderRadius.only(
      topLeft: Radius.circular(18),
      topRight: Radius.circular(18),
      bottomRight: Radius.circular(18),
      bottomLeft: Radius.circular(18),
    );
    const output1 = input1;
    expect(Utils().normalizeBorderRadius(input1, 40), output1);

    const input2 = BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
      bottomRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
    );
    const output2 = BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
    );
    expect(Utils().normalizeBorderRadius(input2, 40), output2);
  });

  test('normalizeBorderSide()', () {
    const input1 = BorderSide(width: 4);
    const output1 = input1;
    expect(Utils().normalizeBorderSide(input1, 40), output1);

    const input2 = BorderSide(width: 24);
    const output2 = BorderSide(width: 20);
    expect(Utils().normalizeBorderSide(input2, 40), output2);
  });

  test('lerp gradient', () {
    expect(
      lerpGradient(
        [
          Colors.red,
          Colors.green,
        ],
        [],
        0,
      ),
      Colors.red,
    );

    expect(
      lerpGradient(
        [
          Colors.red,
          Colors.green,
        ],
        [],
        1,
      ),
      Colors.green,
    );
  });

  test('test roundInterval', () {
    expect(Utils().roundInterval(99), 100);
    expect(Utils().roundInterval(75), 50);
    expect(Utils().roundInterval(76), 100);
    expect(Utils().roundInterval(60), 50);
    expect(Utils().roundInterval(0.000123), 0.0001);
    expect(Utils().roundInterval(0.000190), 0.0002);
    expect(Utils().roundInterval(0.000200), 0.0002);
    expect(Utils().roundInterval(0.000390000000), 0.0005);
    expect(Utils().roundInterval(0.000990000000), 0.001);
    expect(Utils().roundInterval(0.00000990000), 0.00001000);
    expect(Utils().roundInterval(0.0000009), 0.0000009);
    expect(
      Utils().roundInterval(0.000000000000000000990000000),
      0.000000000000000000990000000,
    );
    expect(Utils().roundInterval(0.000004901960784313726), 0.000005);
  });

  test('test Utils().getEfficientInterval', () {
    expect(Utils().getEfficientInterval(472, 340, pixelPerInterval: 10), 5);
    expect(Utils().getEfficientInterval(820, 10000, pixelPerInterval: 10), 100);
    expect(
      Utils().getEfficientInterval(1024, 412345234, pixelPerInterval: 10),
      5000000,
    );
    expect(
      Utils().getEfficientInterval(720, 812394712349, pixelPerInterval: 10),
      10000000000,
    );
    expect(
      Utils().getEfficientInterval(1024, 0.01, pixelPerInterval: 100),
      0.001,
    );
    expect(
      Utils().getEfficientInterval(1024, 0.0005, pixelPerInterval: 10),
      0.000005,
    );
    expect(Utils().getEfficientInterval(200, 0.5, pixelPerInterval: 20), 0.05);
    expect(Utils().getEfficientInterval(200, 1, pixelPerInterval: 20), 0.1);
    expect(Utils().getEfficientInterval(100, 0.5, pixelPerInterval: 20), 0.1);
    expect(Utils().getEfficientInterval(10, 10), 10);
    expect(Utils().getEfficientInterval(10, 0), 1);
  });

  test('test getFractionDigits', () {
    expect(Utils().getFractionDigits(1), 1);
    expect(Utils().getFractionDigits(343), 1);
    expect(Utils().getFractionDigits(22), 1);
    expect(Utils().getFractionDigits(444444), 1);
    expect(Utils().getFractionDigits(0.9), 2);
    expect(Utils().getFractionDigits(0.1), 2);
    expect(Utils().getFractionDigits(0.01), 3);
    expect(Utils().getFractionDigits(0.001), 4);
    expect(Utils().getFractionDigits(0.009), 4);
    expect(Utils().getFractionDigits(0.008), 4);
    expect(Utils().getFractionDigits(0.0001), 5);
    expect(Utils().getFractionDigits(0.0009), 5);
    expect(Utils().getFractionDigits(0.00001), 6);
    expect(Utils().getFractionDigits(0.000001), 7);
    expect(Utils().getFractionDigits(0.0000001), 8);
    expect(Utils().getFractionDigits(0.00000001), 9);
  });

  test('test formatNumber', () {
    expect(Utils().formatNumber(0, 10, 0), '0');
    expect(Utils().formatNumber(0, 10, -0), '0');
    expect(Utils().formatNumber(0, 10, -0.01), '0');
    expect(Utils().formatNumber(0, 10, 0.01), '0');
    expect(Utils().formatNumber(0, 10, -0.1), '-0.1');
    expect(Utils().formatNumber(0, 10, 423), '423');
    expect(Utils().formatNumber(0, 10, -423), '-423');
    expect(Utils().formatNumber(0, 10, 1000), '1K');
    expect(Utils().formatNumber(0, 10, 1234), '1.2K');
    expect(Utils().formatNumber(0, 10, 10000), '10K');
    expect(Utils().formatNumber(0, 10, 41234), '41.2K');
    expect(Utils().formatNumber(0, 10, 82349), '82.3K');
    expect(Utils().formatNumber(0, 10, 82350), '82.3K');
    expect(Utils().formatNumber(0, 10, 82351), '82.4K');
    expect(Utils().formatNumber(0, 10, -82351), '-82.4K');
    expect(Utils().formatNumber(0, 10, 100000), '100K');
    expect(Utils().formatNumber(0, 10, 101000), '101K');
    expect(Utils().formatNumber(0, 10, 2345123), '2.3M');
    expect(Utils().formatNumber(0, 10, 2352123), '2.4M');
    expect(Utils().formatNumber(0, 10, -2352123), '-2.4M');
    expect(Utils().formatNumber(0, 10, 521000000), '521M');
    expect(Utils().formatNumber(0, 10, 4324512345), '4.3B');
    expect(Utils().formatNumber(0, 10, 4000000000), '4B');
    expect(Utils().formatNumber(0, 10, -4000000000), '-4B');
    expect(Utils().formatNumber(0, 10, 823147521343), '823.1B');
    expect(Utils().formatNumber(0, 10, 8231475213435), '8231.5B');
    expect(Utils().formatNumber(0, 10, -8231475213435), '-8231.5B');
  });

  group('test getThemeAwareTextStyle', () {
    testWidgets('test 1', (WidgetTester tester) async {
      const style = TextStyle(color: Colors.brown);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultTextStyle(
              style: style,
              child: Container(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(Container));

      expect(
        Utils().getThemeAwareTextStyle(context, style),
        style,
      );
    });

    testWidgets('test 2', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Container(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(Container));

      expect(
        Utils()
            .getThemeAwareTextStyle(
              context,
              MockData.textStyle1,
            )
            .fontWeight,
        FontWeight.bold,
      );
    });
  });

  test('test getInitialIntervalValue()', () {
    expect(Utils().getBestInitialIntervalValue(-3, 3, 2), -2);
    expect(Utils().getBestInitialIntervalValue(-3, 3, 1), -3);
    expect(Utils().getBestInitialIntervalValue(-30, -20, 13), -26);
    expect(Utils().getBestInitialIntervalValue(0, 13, 8), 0);
    expect(Utils().getBestInitialIntervalValue(1, 13, 7), 7);
    expect(Utils().getBestInitialIntervalValue(1, 13, 3), 3);
    expect(Utils().getBestInitialIntervalValue(-1, 13, 3), 0);
    expect(Utils().getBestInitialIntervalValue(-2, 13, 3), 0);
    expect(Utils().getBestInitialIntervalValue(-3, 13, 3), -3);
    expect(Utils().getBestInitialIntervalValue(-4, 13, 3), -3);
    expect(Utils().getBestInitialIntervalValue(-5, 13, 3), -3);
    expect(Utils().getBestInitialIntervalValue(-6, 13, 3), -6);
    expect(Utils().getBestInitialIntervalValue(-6.5, 13, 3), -6);
    expect(Utils().getBestInitialIntervalValue(-1, 1, 2), 0);
    expect(Utils().getBestInitialIntervalValue(-1, 2, 2), 0);
    expect(Utils().getBestInitialIntervalValue(-2, 0, 2), -2);
    expect(Utils().getBestInitialIntervalValue(-3, 0, 2), -2);
    expect(Utils().getBestInitialIntervalValue(-4, 0, 2), -4);
    expect(Utils().getBestInitialIntervalValue(-0.5, 0.5, 2), 0);
    expect(Utils().getBestInitialIntervalValue(35, 130, 50), 50);
    expect(Utils().getBestInitialIntervalValue(49, 130, 50), 50);
    expect(Utils().getBestInitialIntervalValue(50, 130, 50), 50);
    expect(Utils().getBestInitialIntervalValue(60, 130, 50), 100);
    expect(Utils().getBestInitialIntervalValue(110, 130, 50), 110);
    expect(Utils().getBestInitialIntervalValue(90, 180, 50), 100);
    expect(Utils().getBestInitialIntervalValue(100, 180, 50), 100);
    expect(Utils().getBestInitialIntervalValue(110, 180, 50), 150);
    expect(Utils().getBestInitialIntervalValue(170, 180, 50), 170);
    expect(Utils().getBestInitialIntervalValue(-120, -10, 50), -100);
    expect(Utils().getBestInitialIntervalValue(-110, -10, 50), -100);
    expect(Utils().getBestInitialIntervalValue(-100, -10, 50), -100);
    expect(Utils().getBestInitialIntervalValue(-90, -10, 50), -50);
    expect(Utils().getBestInitialIntervalValue(-80, -10, 50), -50);
    expect(Utils().getBestInitialIntervalValue(-150, -10, 50), -150);
    expect(Utils().getBestInitialIntervalValue(-10, 10, 2, baseline: -1), -9);
    expect(Utils().getBestInitialIntervalValue(-10, 10, 2, baseline: -20), -10);
    expect(Utils().getBestInitialIntervalValue(-10, 10, 15, baseline: -30), 0);
    expect(Utils().getBestInitialIntervalValue(0, 20, 8, baseline: 28), 4);
    expect(Utils().getBestInitialIntervalValue(130, 140, 50), 130);
    expect(Utils().getBestInitialIntervalValue(145, 155, 50), 150);
    expect(
      Utils().getBestInitialIntervalValue(-200, -180, 30),
      -200,
    );
    expect(
      Utils().getBestInitialIntervalValue(-190, -170, 30),
      -180,
    );
    expect(
      Utils().getBestInitialIntervalValue(-2000, 2000, 100, baseline: -10000),
      -2000,
    );
    expect(
      Utils().getBestInitialIntervalValue(-120, 120, 33, baseline: -200),
      -101,
    );
    expect(
      Utils().getBestInitialIntervalValue(120, 180, 60, baseline: 2000),
      140,
    );
    expect(Utils().getBestInitialIntervalValue(-10, 10, 4, baseline: 3), -9);
  });

  test('test convertRadiusToSigma()', () {
    expect(Utils().convertRadiusToSigma(10), closeTo(6.2735, tolerance));
    expect(Utils().convertRadiusToSigma(42), closeTo(24.7487, tolerance));
    expect(Utils().convertRadiusToSigma(26), closeTo(15.5111, tolerance));
  });
}
